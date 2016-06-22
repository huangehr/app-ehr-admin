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
				$name: $('#inp_name'),
				$status:$('#inp_status'),
				$startTimeLow:$('#inp_start_time'),
				$startTimeUp:$('#inp_end_time'),
				$searchBtn: $('#btn_search'),
				init: function () {
					this.$status.ligerComboBox({
						data:[["0","全部"],["1","待审核"],["2","已通过"],["3","已拒绝"]],
						valueField : 0,
						textField: 1,
						width: 120,
					});
					this.$element.attrScan();
					window.form = this.$element;
					this.$name.ligerTextBox({width:120});
					this.$startTimeLow.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
					this.$startTimeUp.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
				},
			};
			master = {
				init: function () {
					infoGrid = $("#div_info_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/esb/acqTask/hosAcqTasks',
						parms: {
							orgSysCode: '',
							status:'',
							startTimeLow:'',
							startTimeUp:'',
							endTimeLow:'',
							endTimeUp:''
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '申请时间', name: 'startTime', width: '25%', resizable: true,align:'center'},
							{display: '认证用户',name: 'orgCode', width:'35%', isAllowHide: false,align:'left'},
							{display: '状态', name: 'status', hide:true},
							{display: '状态', name: 'statusName', width: '15%', minColumnWidth: 20,},
							{display: '操作', name: 'operator', width: '25%', render: function (row) {
								var html = '<a class="label_a" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "authentication:info:open", row.id,row.status) + '">详情</a>';
								if(row.status != "1"){
									html += '<a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "authentication:operate", row.id, 'approve') + '">同意</a>';
									html += '<a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "authentication:operate", row.id, 'refuse') + '">拒绝</a>';
								}
								return html;
							}}
						],
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
					$.subscribe('authentication:info:open',function(event,id,statusName){
						var value = retrieve.$element.Fields.getValues();
						value.page = 1;
						value.rows = 15;
						value.sort = '';
						var data = {
							'statusName': statusName,
							'backParams': value,
						}
						$("#contentPage").empty();
						$("#contentPage").load('${contextRoot}/authentication/infoInitial',{id:id,dataModel:JSON.stringify(data)});
					});
					//修改状态
					$.subscribe('authentication:operate', function (event, id,operate) {
						var msg = "";
						if(Util.isStrEquals("approve",operate)){msg = "您同意了该认证，操作后无法修改，是否确认操作？";}
						if(Util.isStrEquals("refuse",operate)){msg = "您拒绝了该认证，操作后无法修改，是否确认操作？";}
						if(Util.isStrEmpty(msg)){return;}
						$.ligerDialog.confirm(msg, function (yes) {
							if (yes) {
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/authentication/operate', {
									data: {id: id,status:operate},
									success: function (data) {
										if (data.successFlg) {
											isFirstPage = false;
											master.reloadGrid();
										} else {
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