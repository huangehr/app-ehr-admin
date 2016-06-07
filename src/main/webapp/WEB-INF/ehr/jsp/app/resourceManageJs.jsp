<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
	(function ($, win) {
		$(function () {
			/* ************************** 全局变量定义 **************************** */
			var Util = $.Util;
			var retrieve = null;
			var master = null;
			var conditionArea = null;
			var isFirstPage = true;
			var sourceData = ${dataModel};
			var appId = sourceData.appId;
			var resourceId = sourceData.resourceId;
			/* *************************** 函数定义 ******************************* */
			function pageInit() {
				conditionArea.init();
				retrieve.init();
				master.init();
			}
			function reloadGrid (params) {
				if (isFirstPage){
					this.grid.options.newPage = 1;
				}
				this.grid.setOptions({parms: params});
				this.grid.loadData(true);
				isFirstPage = true;
			}
			/* *************************** 模块初始化 ***************************** */
			conditionArea = {
				$resourceName :$('#rsName'),
				$resourceCode :$('#rsCode'),
				$categoryName :$('#rsTopic'),
				init : function () {
					this.initResourceMsg();
				},
				initResourceMsg: function () {
					var self = this;
					var dataModel = $.DataModel.init();
					dataModel.fetchRemote("${contextRoot}/app/resource",{
						data:{resourceId:resourceId},
						success: function(data) {
							var model = data.obj;
							self.$resourceName.val(model.name);
							self.$resourceCode.val(model.code);
							self.$categoryName.val(model.name);
						},
					});
				}
			},

			retrieve = {
				$element: $('.m-retrieve-area'),
				$searchNm: $('#inp_search'),
				init: function () {
					this.$element.show();
					this.$element.attrScan();
					window.form = this.$element;
					this.$searchNm.ligerTextBox({
						width: 240, isSearch: true, search: function () {
							master.reloadGrid();
						}
					});
				},
			};
			master = {
				grid: null,
				init: function () {
					this.grid = $("#div_app_info_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/app/resource/metadata',
						parms: {
							resourceId: sourceData.resourceId,
						},
						columns: [
							{ display: 'id',name: 'id', width: '15%',isAllowHide: false,hide:true },
							{ display: '资源id',name: 'resourcesId', width: '15%',isAllowHide: false,hide:true },
							{ display: '数据元id',name: 'metadataId', width: '15%',isAllowHide: false,hide:true },
							//{ display: 'APP Secret', name: 'secret', width: '10%', minColumnWidth: 60,hide:true },
							{ display: '字段名称', name: 'metadataId',width: '20%',align: 'left', isAllowHide: false },
							{ display: '维度授权', name: 'resourcesId', width: '60%',align: 'left'},
							{display: '是否有效', name: 'resourcesId', width: '10%', align: 'center', render: function (row) {
								return row.valid==1? '是': '否';
							}},
							{display: '操作', name: 'operator', width: '10%'}
						],
						checkbox:true,
						enabledEdit: true,
						validate : true,
						unSetValidateAttr:false,
						allowHideColumn: false,
					}));
					this.bindEvents();
					this.grid.adjustToWidth();
				},
				reloadGrid: function () {
					var values = retrieve.$element.Fields.getValues();
					reloadGrid.call(this, values);
				},
				bindEvents: function () {
					$('#btn_back').click(function(){
						$('#contentPage').empty();
						$('#contentPage').load('${contextRoot}/app/resource/initial?appId='+appId+'&backParams='+JSON.stringify(sourceData.backParams));
					});
					//全部禁止
					$('#btn_all_forbid').click(function(){
						$.Notice.confirm('确认要全部禁止？', function (r) {
							if(r){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/specialdict/hp/deletes',{
									success:function(data){
										if(data.successFlg){
											$.Notice.success( '授权成功！');
											masters.reloadGrid();
										}else{
											$.Notice.error('授权失败！');
										}
									}
								});
							}
						})
					});
					//全部允许
					$('#btn_all_allow').click(function(){
						$.Notice.confirm('确认要全部允许？', function (r) {
							if(r){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/specialdict/hp/deletes',{
									success:function(data){
										if(data.successFlg){
											$.Notice.success( '授权成功！');
											masters.reloadGrid();
										}else{
											$.Notice.error('授权失败！');
										}
									}
								});
							}
						})
					});
					//选中禁止
					$('#btn_selected_forbid').click(function(){
						var ids = '';
						var rows = master.grid.getSelectedRows();
						if(rows.length==0){
							$.Notice.warn('请选择要授权数据行！');
							return;
						}
						for(var i=0;i<rows.length;i++){
							ids += ',' + rows[i].id;
						}
						ids = ids.length>0 ? ids.substring(1, ids.length) : ids ;
						$.Notice.confirm('确认要授权所选数据？', function (r) {
							if(r){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/specialdict/hp/deletes',{
									data:{ids:ids},
									success:function(data){
										if(data.successFlg){
											$.Notice.success( '授权成功！');
											masters.reloadGrid();
										}else{
											$.Notice.error('授权失败！');
										}
									}
								});
							}
						})
					});
					//选中允许
					$('#btn_selected_allow').click(function(){
						var ids = '';
						var rows = master.grid.getSelectedRows();
						if(rows.length==0){
							$.Notice.warn('请选择要授权数据行！');
							return;
						}
						for(var i=0;i<rows.length;i++){
							ids += ',' + rows[i].id;
						}
						ids = ids.length>0 ? ids.substring(1, ids.length) : ids ;
						$.Notice.confirm('确认要授权所选数据？', function (r) {
							if(r){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/specialdict/hp/deletes',{
									data:{ids:ids},
									success:function(data){
										if(data.successFlg){
											$.Notice.success( '授权成功！');
											masters.reloadGrid();
										}else{
											$.Notice.error('授权失败！');
										}
									}
								});
							}
						})
					});
				},
			};
			/* *************************** 页面初始化 **************************** */
			pageInit();
		});
	})(jQuery, window);
</script>