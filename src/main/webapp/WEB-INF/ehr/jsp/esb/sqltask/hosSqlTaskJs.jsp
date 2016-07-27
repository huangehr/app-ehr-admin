<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script>
	(function ($, win) {
		$(function () {
			/* ************************** 变量定义 ******************************** */
			// 通用工具类库
			var Util = $.Util;
			// 页面表格条件部模块
			var retrieve = null;
			// 页面主模块
			var master = null;
			// 画面信息表对象
			var isFirstPage = true;

			/* *************************** 函数定义 ******************************* */
			//页面初始化
			function pageInit() {
				retrieve.init();
				master.init();
			}
			//多条件查询参数设置
			function reloadGrid (params) {
				if (isFirstPage){
					this.grid.options.newPage = 1;
				}
				this.grid.setOptions({parms:params});
				this.grid.loadData(true);
				isFirstPage = true;
			}

			/* *************************** 模块初始化 ***************************** */
			retrieve = {
				$element: $('.m-retrieve-area'),
				$orgSysCode: $('#inp_code'),
				$status:$('#inp_status'),
				$newRecordBtn: $('#div_new_record'),
				$searchBtn: $('#btn_search'),
				init: function () {
					this.$element.attrScan();
					window.form = this.$element;
					this.$orgSysCode.ligerTextBox({width:240});
					this.$status.ligerComboBox({
						data:[["0","0"],["1","1"]],
						valueField : 0,
						textField: 1,
						width: 120
					});
				},
			};
			master = {
				hisInfoDialog: null,
				resultInfoDialog:null,
				grid:null,
				init: function () {
					this.grid = $("#div_his_info_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/esb/sqlTask/hosSqlTasks',
						parms: {
							orgSysCode: '',
							status:''
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '机构代码',name: 'orgCode', width:'10%', isAllowHide: false,align:'left'},
							{display: '系统代码', name: 'systemCode', width: '10%',align:'left'},
							{display: '查询SQL', name: 'sqlscript',width: '30%',align:'left'},
							{display: '查询结果', name: 'rusult', width: '6%', resizable: true,align:'center',
								render: function (row) {
									var html = "";
									if(row.status == '1'){
										html = '<a title="明细" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "his:queryResultDialog:open", row.id) + '">明细</a>';
									}
									return html;
								}
							},
							{display: '创建时间', name: 'createTime', width: '14%', resizable: true,align:'left'},
							{display: '状态', name: 'status', width: '10%', minColumnWidth: 20},
							{display: '查询消息', name: 'message', width: '10%', resizable: true,align:'left'},
							{
								display: '操作', name: 'operator', width: '10%', render: function (row) {
								var html = '';
								<sec:authorize url="/esb/sqlTask/delete">
								html = '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "his:hisInfoDialog:del", row.id) + '"></a>';
								</sec:authorize>
								return html;
							}}
						],
						enabledEdit: true,
						validate: true,
						unSetValidateAttr: false,
					}));
					this.grid.adjustToWidth();
					this.bindEvents();
				},
				reloadGrid: function () {
					var values = retrieve.$element.Fields.getValues();
					reloadGrid.call(this, values);
				},
				bindEvents: function () {
					var self = this;
					//查询事件
					retrieve.$searchBtn.click(function(){
						master.reloadGrid();
					});
					//新增用户
					retrieve.$newRecordBtn.click(function () {
						$.publish("his:hisInfo:open",['']);
					});
					$.subscribe("his:hisInfo:open",function(){
						self.hisInfoDialog = $.ligerDialog.open({
							height: 550,
							width: 500,
							title: '新增his查询',
							url: '${contextRoot}/esb/sqlTask/hosSqlTaskInfoDialog',
							load:true
						})
					});

					//查看查询结果明细
					$.subscribe('his:queryResultDialog:open', function (event, id) {
						var yes = true;
						//根据查询状态、查询消息先判断
						if (yes) {
							master.resultInfoDialog = $.ligerDialog.open({
								height: 550,
								width: 600,
								title: '查询结果明细',
								url: '${contextRoot}/esb/sqlTask/result?id='+id,
								load:true
							})
						}
					});
					//删除用户
					$.subscribe('his:hisInfoDialog:del', function (event, id) {
						$.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
							if(yes){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote("${contextRoot}/esb/sqlTask/delete",{
									data:{id:id},
									async:true,
									success: function(data) {
										if(data.successFlg){
											$.Notice.success('删除成功。');
											isFirstPage = false;
											master.reloadGrid();
										}else{
											$.Notice.error('删除失败。');
										}
									}
								});
							}
						});
					})
				}
			};

			/* ************************* 模块初始化结束 ************************** */

			/* ************************* Dialog页面回调接口 ************************** */
			win.reloadMasterUpdateGrid = function () {
				master.reloadGrid();
			};
			win.closeHisInfoDialog = function (tag) {
				isFirstPage = false;
				if(tag == '1'){
					$.Notice.success('操作成功');
				}
				master.hisInfoDialog.close();
			};
			win.closeResultInfoDialog = function () {
				master.resultInfoDialog.close();
			};
			/* ************************* Dialog页面回调接口结束 ************************** */

			/* *************************** 页面初始化 **************************** */

			pageInit();

			/* ************************* 页面初始化结束 ************************** */
		});
	})(jQuery, window);
</script>