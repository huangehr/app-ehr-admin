<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script>
	(function ($, win) {
		$(function () {
			/* ************************** 变量定义 ******************************** */
			var Util = $.Util;
			// 页面表格条件部模块
			var retrieve = null;
			// 页面主模块，对应于用户信息表区域
			var master = null;
			// 画面申请信息表对象
			var archiveGrid = null;
			//是否第一页
			var isFirstPage = true;

			/* *************************** 函数定义 ******************************* */
			/**
			 * 页面初始化。
			 * @type {Function}
			 */
			function pageInit() {
				retrieve.init();
				master.searchList();
			}
			//多条件查询参数设置
			function reloadGrid (params) {
				if (isFirstPage){
					archiveGrid.options.newPage = 1;
				}
				if("all"==params.auditStatus){
					delete params.auditStatus;
				}
				archiveGrid.set({
					parms: params
				});
				archiveGrid.reload();
				isFirstPage = true;
			}

			/* *************************** 模块初始化 ***************************** */
			retrieve = {
				// 模块对应的容器
				$element: $('.m-retrieve-area'),
				// 搜索框
				$applyName: $('#applyName'),
				//状态下拉框
				$auditType: $('#auditStatus'),
				//开始时间
				$searchBeginTime: $("#beginTime"),
				//结束时间
				$searchEndTime:$("#endTime"),
				//查询按钮
				$searchBtn: $('#btn_search'),

				init: function () {
					this.$element.show();
					this.$element.attrScan();
					retrieve.initDDL();
				},
				//下拉框列表项初始化
				initDDL: function () {
					this.$searchBeginTime.ligerDateEditor({
						format: "yyyy-MM-dd hh:mm",
						showTime: true,
						labelWidth: 100,
						labelAlign: 'center',
						cancelable : true
					});
					this.$searchEndTime.ligerDateEditor({
						format: "yyyy-MM-dd hh:mm",
						labelWidth: 100,
						labelAlign: 'center',
						cancelable : true,
						showTime: true
					});
					this.$applyName.ligerTextBox({width:240});
					this.$auditType.ligerComboBox({
						url: "${contextRoot}/dict/searchDictEntryList",
						dataParmName: 'detailModelList',
						urlParms: {dictId: 36},
						valueField: 'code',
						textField: 'value',
						value:"0"

					});
				}
			};
			master = {
				validateDialog:null,
				searchList: function () {
					var values =  retrieve.$element.Fields.getValues();
					archiveGrid = $("#div_correlation_audit_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/archive/apply/getApplyList',
						parms:values,
						columns: [
							{display: '审核状态', name: 'statusName', width: '10%', resizable: true,align: 'left'},
							{display: '申请人', name: 'name', width: '10%',align: 'left'},
							{display: '身份证号', name: 'idCard', width: '25%'},
							{display: '申请时间', name: 'applyDate', width: '15%', resizable: true,align: 'left'},
							{display: '审核人', name: 'auditor', width: '15%', resizable: true,align: 'left'},
							{display: '审核时间', name: 'auditDate', width: '15%', resizable: true,align: 'left'},
							{display: '', name: 'id', hide: true},
							{display: '', name: 'userId', hide: true},
							{display: '操作',name: 'operator', width:'10%', align:'center',render: function (row) {
								var html="";
								if(row.status==0){
								 html = '<sec:authorize url="/correlation/validateAudit"><a href="javascript:void(0)" title="审核" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "archive:audit:update", row.status,row.id) + '">审核</a></sec:authorize>';
								}else if(row.status==1){
								 html = '<sec:authorize url="/correlation/msgDialog"><a href="javascript:void(0)" title="查看" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "archive:audit:success", row.status,row.id) + '">查看</a></sec:authorize>';
								}else{
								 html = '<sec:authorize url="/correlation/msgDialog"><a  href="javascript:void(0)" title="查看" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "archive:audit:error", row.status,row.id) + '">查看</a></sec:authorize>';
								}
								return html;
							}}
						],onReload:function(){
							master.reloadGrid();
						}
					}));
					// 自适应宽度
					archiveGrid.adjustToWidth();
					this.bindEvents();
				},
				reloadGrid: function () {
					this.searchList();
				},
				openMsgDialog:function(status,id){
					master.validateDialog = $.ligerDialog.open({
						height:640,
						width: 1000,
						url: '${contextRoot}/archive/apply/arApplyDialog',
						urlParms: {
							status: status,
							id:id
						},
						isHidden: false,
						opener: true,
						load:true
					});
			    },
				bindEvents: function () {
					//事件绑定
					retrieve.$searchBtn.click(function(){
						master.reloadGrid();
					});

					$.subscribe('archive:audit:update', function (event, status, id) {
						master.openMsgDialog("audit",id);
					});
					$.subscribe('archive:audit:success', function (event, status, id) {
						master.openMsgDialog("success",id);
					});
					$.subscribe('archive:audit:error', function (event, status, id) {
						master.openMsgDialog("view",id);
					});
				}
			};
			win.closeDialog = function (msg) {
				master.validateDialog.close();
				master.reloadGrid();
				if(msg)
					$.Notice.success(msg);
			};
			/* *************************** 页面初始化 **************************** */
			pageInit();
			/* ************************* 页面初始化结束 ************************** */
		});
	})(jQuery, window);
</script>