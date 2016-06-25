<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
	(function ($, win) {
		$(function () {
			/* ************************** 变量定义 ******************************** */
			var Util = $.Util;
			var retrieve = null;
			var master = null;
			var isFirstPage = true;
			var categoryId = '';
			var backParams = ${backParams};
			var typeTree = null;
			var switchUrl = {
				configUrl:'${contextRoot}/resourceConfiguration/initial',
				grantUrl:'${contextRoot}/resource/grant/initial',
				viewUrl:'${contextRoot}/resourceView/initial'
			}
			/* *************************** 函数定义 ******************************* */
			function pageInit() {
				resizeContent();
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
			retrieve = {
				typeTree: null,
				$resourceBrowseTree: $("#div_resource_browse_tree"),
				$logicalRelationship: $("#inp_logical_relationship"),
				$searchModel: $(".div_search_model"),
				$resourceInfoGrid: $("#div_resource_info_grid"),
				$search: $("#inp_search"),
				$searchNm: $('#inp_searchNm'),
				init: function () {
					var self = this;
					var categoryName = '';
					$('#div_tree').mCustomScrollbar();
					this.$search.ligerTextBox({width:220,isSearch: true, search: function () {
						categoryName = $("#inp_search").val();
						typeTree.selectNode('');
						typeTree.s_search(categoryName);
						if(categoryName == ''){
							typeTree.collapseAll();
						}else{
							typeTree.expandAll();
						}
						var parms = {
							'searchNm':'',
							'categoryId':'',
						};
						reloadGrid(parms);
					}});
					this.$searchNm.ligerTextBox({width:240,isSearch: true, search: function () {
						var searchNm = $('#inp_searchNm').val();
						var parms = {
							'searchNm':searchNm,
							'categoryId':categoryId,
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
						parentIDFieldName :'pid',
						textFieldName: 'name',
						isExpand: false,
						childIcon:null,
						parentIcon:null,
						onSelect: function (e) {
							categoryId = e.data.id;
							master.reloadGrid();
						},
						onSuccess: function (data) {
							if(data.length != 0){
								$("#div_resource_browse_tree li div span").css({
									"line-height": "22px",
									"height": "22px"
								});
							}
							if(backParams.typeFilter){
								$('#inp_search').val(backParams.typeFilter);
								typeTree.s_search(backParams.typeFilter);
							}
							if(backParams.categoryIds){
								var categoryIds = backParams.categoryIds;
								typeTree.s_searchForLazy(categoryIds);
								var ids = categoryIds.split(",");
								var id = ids[ids.length-1];
								$('#inp_searchNm').val(backParams.sourceFilter)
								typeTree.selectNode(id);
							}
//							else{
//								var defaultNode = $('#div_resource_browse_tree li')[0];
//								typeTree.selectNode(defaultNode);
//							}
						},
					});
				},
			};
			master = {
				resourceInfoGrid:null,
				init: function () {
					this.resourceInfoGrid = $("#div_resource_info_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/resource/resourceManage/resources',
						parms: {
							searchNm: $('#inp_searchNm').val(),
							categoryId: categoryId
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '访问方式', name: 'grantType',hide:true},
							{display: '资源名称', name: 'name', width: '15%', align: 'left'},
							{display: '资源编码', name: 'code', width: '15%', align: 'left'},
							{display: '资源接口', name: 'rsInterfaceName', width: '15%', align: 'left'},
							{display: '资源分类', name: 'categoryName', width: '10%', align: 'left'},
							{display: '资源分类Id', name: 'categoryId',hide:true},
							{display: '资源说明', name: 'description', width: '23%', align: 'left'},
							{display: '操作', name: 'operator', width: '22%',align:'right', render: function (row) {
								var html = '';
								html += '<a class="label_a"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}','{5}'])", "rs:switch:open",row.id,row.name,row.categoryName,switchUrl.configUrl,"1") + '">配置</a>';
								if(row.grantType == '0'){
									html += '<a class="label_a" style="margin-left:5px;"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}','{5}'])", "rs:switch:open",row.id,row.name,row.categoryName,switchUrl.grantUrl,"1") + '">授权</a>';
								}
								html += '<a class="label_a" style="margin-left:5px;" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}','{5}'])", "rs:switch:open",row.id,row.name,row.categoryName,switchUrl.viewUrl,row.code) + '">浏览</a>';
								html += '<a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "rs:info:open", row.id,'modify',categoryId) + '"></a>';
								html += '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "rs:info:delete", row.id, 'delete') + '"></a>';
								return html;
							}}
						],
						checkbox: false,
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
				bindEvents: function () {
					//新增修改
					$('#btn_add').click(function(){
						$.publish("rs:info:open",['','new',categoryId]);
					});
					$.subscribe("rs:info:open",function(event,resourceId,mode,categoryId){
						var title = "";
						if(mode == "modify"){title = "修改资源";}
						if(mode == "view"){title = "查看资源";}
						if(mode == "new"){title = "新增资源";}
						master.rsInfoDialog = $.ligerDialog.open({
							height:550,
							width:500,
							title:title,
							url:'${contextRoot}/resource/resourceManage/infoInitial',
							urlParms:{
								id:resourceId,
								mode:mode,
								categoryId:categoryId
							},
							load:true
						});
					});
					//删除
					$.subscribe('rs:info:delete',function(event,id){
						$.ligerDialog.confirm("确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。", function (yes) {
							if(yes){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote("${contextRoot}/resource/resourceManage/delete",{
									data:{id:id},
									async:true,
									success: function(data) {
										if(data.successFlg){
											$.Notice.success('删除成功。');
											isFirstPage = false;
											master.reloadGrid();
										}else{
											$.Notice.error(data.errorMsg);
										}
									}
								});
							}
						})
					});
					//配置、浏览页面跳转
					$.subscribe("rs:switch:open",function(event,resourceId,resourceName,categoryName,url,resourceCode){
						var dataModel = $.DataModel.init();
						dataModel.updateRemote("${contextRoot}/resource/resourceManage/categoryIds", {
							data:{categoryId:categoryId},
							async:true,
							success: function(data) {
								if (data.successFlg) {
									var data = {
										'resourceId':resourceId,
										'resourceName':resourceName,
										'resourceSub':categoryName,
										'categoryIds':data.obj,
										'resourceCode':resourceCode,
										'backParams':{
											'categoryIds':data.obj,
											'sourceFilter':$('#inp_searchNm').val(),
											'typeFilter':$('#inp_search').val(),
										}
									}
									$("#contentPage").empty();
									$("#contentPage").load(url,{dataModel:JSON.stringify(data)});
								}
							},
						});
					});
				},
			};
			/* ************************* 模块初始化结束 ************************** */
			/* ************************* dialog回调函数 ************************** */
			var resizeContent = function(){
				var contentW = $('#div_content').width();
				//浏览器窗口高度-固定的（健康之路图标+位置）128-20px包裹上下padding
				var contentH = $(window).height()-128-20;
				var leftW = $('#div_left').width();
				$('#div_content').height(contentH);
				//减50px的检索条件div高度
				$('#div_tree').height(contentH-50);
				$('#div_right').width(contentW-leftW-20);
			};
			$(window).bind('resize', function() {
				resizeContent();
			});

			//未修改所属资源类别时，只刷新右侧列表；有修改所属资源类别时，左侧树重新定位，刷新右侧列表
			win.reloadMasterUpdateGrid = function (callbackParams) {
				if(!callbackParams){
					master.reloadGrid();
					return
				}
				$("#inp_search").val(callbackParams.typeFilter);
				typeTree.s_search(callbackParams.typeFilter);
				typeTree.s_searchForLazy(callbackParams.categoryIds);
				typeTree.selectNode(callbackParams.categoryId);
			};
			win.closeRsInfoDialog = function (callback) {
				isFirstPage = false;
				master.rsInfoDialog.close();
			};
			/* ************************* dialog回调函数结束 ************************** */

			/* *************************** 页面初始化 **************************** */
			pageInit();
			/* ************************* 页面初始化结束 ************************** */
		});
	})(jQuery, window);
</script>