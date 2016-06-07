<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
	(function ($, win) {
		$(function () {
			/* ************************** 变量定义 ******************************** */
			var Util = $.Util;
			// 页面表格条件部模块
			var retrieve = null;
			// 页面主模块，对应于用户信息表区域
			var master = null;
			var conditionArea = null;
			var resourceInfoGrid = null;
			var dataModel = $.DataModel.init();
			var appId = '${appId}';
			var categoryId = '';
			var isFirstPage = true;
			var typeTree = null;
			var backParams = ${backParams};
			//应用已授权资源集合
			var appRsIds = [];
			/* *************************** 函数定义 ******************************* */
			function pageInit() {
				conditionArea.init();
				retrieve.init();
				master.init();
			}
			function reloadGrid(params) {
				if (isFirstPage){
					master.resourceInfoGrid.options.newPage = 1;
				}
				master.resourceInfoGrid.setOptions({parms: params});
				master.resourceInfoGrid.loadData(true);
				isFirstPage = true;
			}
			/* *************************** 模块初始化 ***************************** */
			conditionArea = {
				$appName :$('#msg_appName'),
				$catalogName :$('#msg_catalogName'),
				$orgName :$('#msg_orgName'),
				init : function () {
					this.initAppMsg();
				},
				initAppMsg: function () {
					var self = this;
					var dataModel = $.DataModel.init();
					dataModel.fetchRemote("${contextRoot}/app/app",{
						data:{appId:appId},
						success: function(data) {
							var model = data.obj;
							self.$appName.val(model.name);
							self.$catalogName.val(model.catalogName);
							self.$orgName.val(model.orgName);
						},
					});
				}
			};
			retrieve = {
				$resourceBrowseTree: $("#div_resource_browse_tree"),
				$logicalRelationship: $("#inp_logical_relationship"),
				$searchModel: $(".div_search_model"),
				$resourceInfoGrid: $("#div_resource_info_grid"),
				$search: $("#inp_search"),
				$searchNm: $('#inp_searchNm'),
				init: function () {
					var self = this;
					var categoryName = '';
					this.$search.ligerTextBox({width:220,isSearch: true, search: function () {
						categoryName = $("#inp_search").val();
						typeTree.s_search(categoryName);
						if(categoryName == ''){
							typeTree.collapseAll();
						}else{
							typeTree.expandAll();
						}
					}});
					this.$searchNm.ligerTextBox({width:240,isSearch: true, search: function () {
						var searchNm = $('#inp_searchNm').val();
						var parms = {
							'searchNm':searchNm,
							'categoryId':categoryId
						};
						reloadGrid(parms);
					}});
					self.getResourceBrowseTree();
				},
				getResourceBrowseTree: function () {
					typeTree = this.$resourceBrowseTree.ligerSearchTree({
						nodeWidth: 240,
						url: '${contextRoot}/resource/resourceManage/categories',
						checkbox: false,
						idFieldName: 'id',
						parentIDFieldName:'pid',
						textFieldName: 'name',
						isExpand: false,
						childIcon:'folder',
						parentIcon:'folder',
						onSelect: function (e) {
							categoryId = e.data.id;
							master.reloadGrid();
						},
						onSuccess: function (data) {
							$("#div_resource_browse_tree li div span").css({
								"line-height": "22px",
								"height": "22px"
							});
							if(backParams.categoryIds){
								var categoryIds = backParams.categoryIds;
								typeTree.s_searchForLazy(categoryIds);
								var ids = categoryIds.split(",");
								var id = ids[ids.length-1];
								$('#inp_searchNm').val(backParams.sourceFilter)
								typeTree.selectNode(id);
							}
						},
					});
				},
			};
			master = {
				resourceInfoGrid:null,
				init: function () {
					//获取应用已授权资源ids
					master.loadResourceIds();
					this.resourceInfoGrid = $("#div_resource_info_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/resource/resourceManage/resources',
						parms: {
							searchNm: '',
							categoryId: categoryId
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '资源名称', name: 'name', width: '15%', align: 'left'},
							{display: '资源代码', name: 'code', width: '15%', align: 'left'},
							{display: '数据源', name: 'rsInterfaceName', width: '15%', align: 'left'},
							{display: '资源分类', name: 'categoryName', width: '15%', align: 'left'},
							{display: '资源分类Id', name: 'categoryId',hide:true},
							{display: '资源说明', name: 'description', width: '30%', align: 'left'},
							{display: '操作', name: 'operator', width: '10%', render: function (row) {
								var html = '';
								if(appRsIds.indexOf(row.id)<0){
									return ''
								}
								html += '<a class="label_a"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:resourceManage:list",row.id,appId) + '">维度管理</a>';
								return html;
							}}
						],
						checkbox: true,
						validate : true,
						unSetValidateAttr:false,
						allowHideColumn: false,
						onDblClickRow : function (row){
							$.publish("rs:info:open",[row.id,'view'])
						}
					}));
					this.resourceInfoGrid.adjustToWidth();
					this.bindEvents();
				},
				reloadGrid: function () {
					var searchNm = $('#inp_searchNm').val();
					reloadGrid.call(this,{'searchNm':searchNm,'categoryId': categoryId});
				},
				loadResourceIds:function(){
					var dataModel = $.DataModel.init();
					dataModel.updateRemote("${contextRoot}/app/resourceIds",{
						data:{appId:appId},
						async:true,
						success: function(data) {
							if(data.successFlg){
								appRsIds = data.detailModelList;
							}
						}
					});
				},
				bindEvents: function () {
					//授权
					$('#btn_grant').click(function(){
						$.publish('app:rs:grant',['']);
					});
					$.subscribe('app:rs:grant',function(event,ids){
						if(!ids){
							var rows = master.resourceInfoGrid.getSelectedRows();
							if(rows.length==0){
								$.Notice.warn('请选择要授权给应用的资源！');
								return;
							}
							for(var i=0;i<rows.length;i++){
								ids += ',' + rows[i].id;
							}
							ids = ids.length>0 ? ids.substring(1, ids.length) : ids ;
						}
						$.Notice.confirm('确认要授权所选资源？', function (r) {
							if(r){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/app/resource/grant',{
									data:{appId:appId,resourceIds:ids},
									success:function(data){
										if(data.successFlg){
											$.Notice.success( '授权成功！');
											master.loadResourceIds();
											master.reloadGrid();
										}else{
											$.Notice.error('授权失败！');
										}
									}
								});
							}
						})
					});

					//维度授权页面跳转
					$.subscribe('app:resourceManage:list', function (event,resourceId,resourceName,categoryName) {
						var dataModel = $.DataModel.init();
						dataModel.updateRemote("${contextRoot}/resource/resourceManage/categoryIds", {
							data:{categoryId:categoryId},
							async:true,
							success: function(data) {
								if (data.successFlg) {
									var data = {
										'appId':appId,
										'resourceId':resourceId,
										'resourceName':resourceName,
										'resourceSub':categoryName,
										'backParams':{
											'categoryIds':data.obj,
											'sourceFilter':$('#inp_searchNm').val(),
										}
									}
									$("#contentPage").empty();
									$("#contentPage").load('${contextRoot}/app/resourceManage/initial',{dataModel:JSON.stringify(data)});
								}
							},
						});
					});
				},
			};
			var resizeContent = function(){
				var contentW = $('#div_content').width();
				var leftW = $('#div_left').width();
				$('#div_right').width(contentW-leftW-20);
			}();
			$(window).bind('resize', function() {
				resizeContent();
			});
			win.reloadMasterUpdateGrid = function () {
				master.reloadGrid();
			};
			win.closeRsInfoDialog = function (callback) {
				isFirstPage = false;
				master.rsInfoDialog.close();
			};
			/* ************************* 模块初始化结束 ************************** */
			/* *************************** 页面初始化 **************************** */
			pageInit();
			/* ************************* 页面初始化结束 ************************** */
		});
	})(jQuery, window);
</script>