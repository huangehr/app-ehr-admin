<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
	(function ($, win) {
		$(function () {
			/* ************************** 变量定义 ******************************** */
			// 通用工具类库
			var Util = $.Util;
			// 页面表格条件部模块
			var retrieve = null;
			var infoGrid = null;
			// 页面主模块
			var master = null;
			// 页面面信息列表
			var isFirstPage = true;
			//跳转页面回传主页吧过滤参数、Grid表格参数
			var backParams = ${backParams};
			var searchParms = {
				startTime:backParams.startTime || '',
				endTime:backParams.endTime || '',
				status:backParams.status || '',
				name:backParams.name || '',
				page:backParams.page || 1,
				pageSize:backParams.pageSize || 15,
			}
			/* *************************** 函数定义 ******************************* */
			//页面初始化
			function pageInit() {
				retrieve.init();
				master.init();
			}
			//多条件查询参数设置
			function reloadGrid (params) {
				if (isFirstPage){
					infoGrid.options.newPage = 1;
				}
				infoGrid.setOptions({parms:params});
				infoGrid.loadData(true);
				isFirstPage = true;
			}

			/* *************************** 模块初始化 ***************************** */
			retrieve = {
				$element: $('.m-retrieve-area'),
				$startTime:$('#inp_start_time'),
				$endTime:$('#inp_end_time'),
				$status:$('#inp_status'),
				$name: $('#inp_name'),
				$searchBtn: $('#btn_search'),
				statusBox : null,
				init: function () {
					this.statusBox = this.$status.ligerComboBox({
						url: "${contextRoot}/dict/searchDictEntryList",
						dataParmName: 'detailModelList',
						urlParms: {dictId: 36},
						valueField: 'code',
						textField: 'value',
						width: 120,
						value:"0"
					});
					this.$element.attrScan();
					window.form = this.$element;
					this.$name.ligerTextBox({width:120});
					this.$startTime.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
					this.$endTime.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
					this.initSearch();
				},
				initSearch:function(){
					this.$startTime.val(searchParms.startTime);
					this.$endTime.val(searchParms.endTime);
					this.statusBox.setValue(searchParms.status);
					this.$name.val(searchParms.name);
				}
			};
			master = {
				init: function () {
					infoGrid = $("#div_info_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/authentication/search',
						parms: {
							startTime:searchParms.startTime,
							endTime:searchParms.endTime,
							status:searchParms.status,
							name:searchParms.name,
							page:searchParms.page ,
							pageSize:searchParms.pageSize,
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '申请时间', name: 'applyDate', width: '25%', resizable: true,align:'center'},
							{display: '认证用户',name: 'name', width:'35%', isAllowHide: false,align:'left'},
							{display: '状态', name: 'status', hide:true},
							{display: '状态', name: 'statusName', width: '15%', minColumnWidth: 20,},
							{display: '操作', name: 'operator', width: '25%', render: function (row) {
								var html = '<a class="label_a" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "authentication:info:open", row.id,row.status) + '">详情</a>';
								if(row.status == "0"){
									html += '<a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "authentication:status", row.id, '1') + '">同意</a>';
									html += '<a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "authentication:status", row.id, '2') + '">拒绝</a>';
								}
								return html;
							}}
						],
						page:searchParms.page,
						pageSize:searchParms.pageSize,
						enabledEdit: true,
						validate: true,
						unSetValidateAttr: false,
					}));
					infoGrid.adjustToWidth();
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
					//详情页面
					$.subscribe('authentication:info:open',function(event,id,status){
						var value = retrieve.$element.Fields.getValues();
						value.page = parseInt($('.pcontrol input', infoGrid.toolbar).val());
						value.pageSize = $(".l-bar-selectpagesize select", infoGrid.toolbar).val();
						value.sort = '';
						var data = {
							'status':status,
							'backParams': value,
						}
						$("#contentPage").empty();
						$("#contentPage").load('${contextRoot}/authentication/infoInitial',{id:id,dataModel:JSON.stringify(data)});
					});
					//修改状态
					$.subscribe('authentication:status', function (event, id,status) {
						var msg = "";
						if(Util.isStrEquals("1",status)){msg = "您同意了该认证，操作后无法修改，是否确认操作？";}
						if(Util.isStrEquals("2",status)){msg = "您拒绝了该认证，操作后无法修改，是否确认操作？";}
						if(Util.isStrEmpty(msg)){return;}
						$.ligerDialog.confirm(msg, function (yes) {
							if (yes) {
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/authentication/updateStatus', {
									data: {id: id,status:status},
									success: function (data) {
										if (data.successFlg) {
											isFirstPage = false;
											$.Notice.success("操作成功")
											master.reloadGrid();
										} else {
											$.Notice.error("操作失败")
										}
									}
								});
							}
						});
					});
				}
			};

			/* ************************* 模块初始化结束 ************************** */

			/* ************************* Dialog页面回调接口 ************************** */
			win.reloadAcqInfoGrid = function () {
				master.reloadGrid();
			};
			win.closeAcqInfoDialog = function (tag) {
				if(tag){
					$.Notice.success('操作成功');
				}
				infoGrid.close();
			};
			/* ************************* Dialog页面回调接口结束 ************************** */

			/* *************************** 页面初始化 **************************** */
			pageInit();
			/* ************************* 页面初始化结束 ************************** */
		});
	})(jQuery, window);
</script>