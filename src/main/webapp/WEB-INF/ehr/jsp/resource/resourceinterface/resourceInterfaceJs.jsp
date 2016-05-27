<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/5/24
  Time: 9:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
				$searchNm: $('#inp_searchNm'),
				$newRecordBtn: $('#div_new_record'),
				$searchBtn: $('#btn_search'),
				init: function () {
					this.$element.attrScan();
					window.form = this.$element;
					this.$searchNm.ligerTextBox({width:240});
				},
			};
			master = {
				grid: null,
				init: function () {
					this.grid = $("#div_data_info_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/resource/resourceInterface/searchRsInterfaces',
						parms: {
							searchNm: '',
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '接口名称',name: 'name', width:'35%', isAllowHide: false,align:'left'},
							{display: '接口编码', name: 'resourceInterface', width: '55%',align:'left'},
							{display: '请求参数', name: 'paramDescription', width: '25%', resizable: true,align:'left',hide:true},
							{display: '响应结果格式', name: 'resultDescription', width: '25%', resizable: true,align:'left',hide:true},
							{
								display: '操作', name: 'operator', width: '10%', render: function (row) {
								var html = '<a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "interface:infoDialog:open", row.id, 'modify') + '"></a>';
								html+= '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "interface:confirmDialog:del", row.id) + '"></a>';
								return html;
							}},
						],
						enabledEdit: true,
						validate: true,
						unSetValidateAttr: false,
						onDblClickRow : function (row){
							$.publish("interface:infoDialog:open",[row.id,'view']);
						}
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
					//新增、修改、查看事件
					retrieve.$newRecordBtn.click(function () {
						$.publish("interface:infoDialog:open",['','new']);
					});
					$.subscribe("interface:infoDialog:open",function(events,id,mode){
						var title = '';
						if(mode == 'modify'){
							title = '修改资源接口';
						}else if(mode == 'new'){
							title = '新增资源接口'
						}else{
							title = '查看资源接口';
						};
						master.infoDialog = $.ligerDialog.open({
							height: 660,
							width: 600,
							title: title,
							urlParms:{
								id:id,
								mode:mode,
							},
							url: '${contextRoot}/resource/resourceInterface/infoInitial',
							isHidden: false,
							load: true,
						})
					});

					$.subscribe('interface:confirmDialog:del', function (event, id) {
						$.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
							if(yes){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote("${contextRoot}/resource/resourceInterface/delete",{
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
			win.closeInterfaceInfoDialog = function () {
				master.infoDialog.close();
			};
			/* ************************* Dialog页面回调接口结束 ************************** */
			/* *************************** 页面初始化 **************************** */
			pageInit();
			/* ************************* 页面初始化结束 ************************** */
		});
	})(jQuery, window);
</script>