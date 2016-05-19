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
			// 页面主模块
			var master = null;
			// 页面面信息列表
			var acqInfoGrid = null;
			var isFirstPage = true;

			/* *************************** 函数定义 ******************************* */
			//页面初始化
			function pageInit() {
				retrieve.init();
				master.init();
			}
			//多条件查询参数设置
			function reloadGrid (url, params) {
				if (isFirstPage){
					acqInfoGrid.options.newPage = 1;
				}
				acqInfoGrid.set({
					url: url,
					parms: params
				});
				acqInfoGrid.reload();
				isFirstPage = true;
			}

			/* *************************** 模块初始化 ***************************** */
			retrieve = {
				$element: $('.m-retrieve-area'),
				$orgSysCode: $('#inp_code'),
				$status:$('#inp_status'),
				$startTimeLow:$('#inp_start_time_low'),
				$startTimeUp:$('#inp_start_time_up'),
				$endTimeLow:$('#inp_end_time_low'),
				$endTimeUp:$('#inp_end_time_up'),
				$newRecordBtn: $('#div_new_record'),
				$searchBtn: $('#btn_search'),
				init: function () {
					this.$status.ligerComboBox({
						data:[["0","0"],["1","1"]],
						valueField : 0,
						textField: 1,
						width: 120
					});
					this.$element.attrScan();
					window.form = this.$element;
					this.$orgSysCode.ligerTextBox({width:240});
					this.$startTimeLow.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
					this.$startTimeUp.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});

					this.$endTimeLow.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 100, labelAlign: 'center',absolute:false,cancelable:true});
					this.$endTimeUp.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 100, labelAlign: 'center',absolute:false,cancelable:true});

				},
			};
			master = {
				acqInfoDialog: null,
				init: function () {
					acqInfoGrid = $("#div_acq_info_grid").ligerGrid($.LigerGridEx.config({
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
							{display: '机构代码',name: 'orgCode', width:'15%', isAllowHide: false,align:'left'},
							{display: '系统代码', name: 'systemCode', width: '20%',align:'left'},
							{display: '开始时间', name: 'startTime', width: '15%', resizable: true,align:'left'},
							{display: '结束时间', name: 'endTime', width: '15%', resizable: true,align:'left'},
							{display: '状态', name: 'status', width: '10%', minColumnWidth: 20,},
							{display: '查询消息', name: 'message', width: '15%', resizable: true,align:'left'},
							{
								display: '操作', name: 'operator', width: '10%', render: function (row) {
								var html = '<a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "acq:acqInfo:open", row.id, 'modify') + '"></a>';
								html+= '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "acq:acqInfo:del", row.id) + '"></a>';
								return html;
							}}
						],
						enabledEdit: true,
						validate: true,
						unSetValidateAttr: false,
					}));
					acqInfoGrid.adjustToWidth();
					this.bindEvents();
				},
				reloadGrid: function () {
					var values = retrieve.$element.Fields.getValues();
					;
					reloadGrid.call(this, '${contextRoot}/esb/acqTask/hosAcqTasks', values);
				},
				bindEvents: function () {
					var self = this;
					//查询事件
					retrieve.$searchBtn.click(function(){
						master.reloadGrid();
					});
					//新增、修改、查看事件
					retrieve.$newRecordBtn.click(function () {
						$.publish("acq:acqInfo:open",['','new']);
					});
					$.subscribe("acq:acqInfo:open",function(events,acqId,mode){
						var title = '';
						if(mode == 'modify'){
							title = '修改补采任务';
						}else{
							title = '新增补采任务'
						};
						master.acqInfoDialog = $.ligerDialog.open({
							height: 400,
							width: 500,
							title: title,
							urlParms:{
								acqId:acqId,
								mode:mode,
							},
							url: '${contextRoot}/esb/acqTask/acqInfoDialog',
							isHidden: false,
							opener: true,
						})
					});

					//修改状态
					$.subscribe('user:userInfoModifyDialog:failure', function (event, userId,activated,msg) {
						$.ligerDialog.confirm('是否对该进行'+msg+'操作', function (yes) {
							if (yes) {
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/user/activityUser', {
									data: {userId: userId,activated:activated},
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

					$.subscribe('acq:acqInfo:del', function (event, id) {
						$.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
							if(yes){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote("${contextRoot}/esb/acqTask/delete",{
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
			win.reloadAcqInfoGrid = function () {
				master.reloadGrid();
			};
			win.closeAcqInfoDialog = function (tag) {
				if(tag){
					$.Notice.success('操作成功');
				}
				master.acqInfoDialog.close();
			};
			/* ************************* Dialog页面回调接口结束 ************************** */

			/* *************************** 页面初始化 **************************** */
			pageInit();
			/* ************************* 页面初始化结束 ************************** */
		});
	})(jQuery, window);
</script>