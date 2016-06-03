<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
	(function ($, win) {
		$(function () {
			/* ************************** 变量定义 ******************************** */
			var Util = $.Util;
			var retrieve = null;
			var master = null;
			var dataModel = $.DataModel.init();
			var isFirstPage = true;
			var categoryId = '';
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
				$resourceBrowseTree: $("#div_resource_browse_tree"),
				$logicalRelationship: $("#inp_logical_relationship"),
				$searchModel: $(".div_search_model"),
				$resourceInfoGrid: $("#div_resource_info_grid"),
				$search: $("#inp_search"),
				$searchNm: $('#inp_searchNm'),
				init: function () {
					var self = this;
					var categoryName = '';
					var flag = false;
					this.$search.ligerTextBox({width:220,isSearch: true, search: function () {
						categoryName = $("#inp_search").val();
						if(!Util.isStrEmpty(categoryName)){
							flag = true
						}
						self.getResourceBrowseTree(categoryName,flag);
					}});
					this.$searchNm.ligerTextBox({width:240,isSearch: true, search: function () {
						var searchNm = $('#inp_searchNm').val();
						var parms = {
							'searchNm':searchNm,
							'categoryId':categoryId
						};
						reloadGrid(parms);
					}});
					self.getResourceBrowseTree(categoryName,flag);
				},
				getResourceBrowseTree: function (categoryName,flag) {
					var typeTree = this.$resourceBrowseTree.ligerTree({
						nodeWidth: 240,
						url: '${contextRoot}/resource/resourceManage/tree?categoryName='+categoryName,//参数ids值为测试值
						<%--url: '${contextRoot}/resource/resourceManage/categories?categoryName='+categoryName+'&pid=',//参数ids值为测试值--%>
						<%--isLeaf: function (data) {--%>
						<%--},--%>
						<%--delay: function (e) {--%>
							<%--var data = e.data;--%>
							<%--return {url: '${contextRoot}/resource/resourceManage/categories?categoryName='+categoryName+'&pid=' + data.id}--%>
						<%--},--%>
						checkbox: false,
						idFieldName: 'id',
						parentIDFieldName :'pid',
						textFieldName: 'name',
						isExpand: flag,
						childIcon:'folder',
						parentIcon:'folder',
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
								for(var i=0;i<data.length;i++){
									if(data[i].pid == null){
										categoryId =  data[i].id;
										typeTree.selectNode(categoryId)
										master.reloadGrid();
										return
									}
								}
							}
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
							searchNm: '',
							categoryId: categoryId
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '资源名称', name: 'name', width: '15%', align: 'left'},
							{display: '资源编码', name: 'code', width: '15%', align: 'left'},
							{display: '资源接口', name: 'rsInterfaceName', width: '15%', align: 'left'},
							{display: '资源分类', name: 'categoryName', width: '10%', align: 'left'},
							{display: '资源分类Id', name: 'categoryId',hide:true},
							{display: '资源说明', name: 'description', width: '23%', align: 'left'},
							{display: '操作', name: 'operator', width: '22%', render: function (row) {
								var html = '';
								html += '<a class="label_a"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "rs:switch:open",row.id,'config') + '">配置</a>';
								html += '<a class="label_a" style="margin-left:5px;"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "rs:grant:open",row.id,row.name,row.categoryName) + '">授权</a>';
								html += '<a class="label_a" style="margin-left:5px;" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "rs:switch:open",row.id,'browse') + '">浏览</a>';
								html += '<a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "rs:info:open", row.id,'modify',categoryId) + '"></a>';
								html += '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "rs:info:delete", row.id, 'delete') + '"></a>';
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
											$.Notice.error('删除失败。');
										}
									}
								});
							}
						})
					});
					//配置、浏览页面跳转
					$.subscribe("rs:switch:open",function(event,resourceId,pageName){
						var url = '${contextRoot}/resource/resourceManage/switch?pageName='+pageName+'&resourceId='+resourceId;
						$("#contentPage").empty();
						$("#contentPage").load(url);
					});
					//授权页面跳转
					$.subscribe("rs:grant:open",function(event,resourceId,resourceName,categoryName){
						var data = {
							'resourceId':resourceId,
							'resourceName':resourceName,
							'resourceSub':categoryName
						}
						//var data="{resourceId:'"+resourceId+"',resourceName:'"+resourceName+"',resourceSub:'"+categoryName+"'}";
						var url = '${contextRoot}/resource/grant/initial';
						$("#contentPage").empty();
						$("#contentPage").load(url,{dataModel:JSON.stringify(data)});
					});
				},
			};
			/* ************************* 模块初始化结束 ************************** */
			/* ************************* dialog回调函数 ************************** */
			var resizeContent = function(){
				var contentW = $('#div_content').width();
				var leftW = $('#div_left').width();
				$('#div_right').width(contentW-leftW-20);
			};
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
			/* ************************* dialog回调函数结束 ************************** */

			/* *************************** 页面初始化 **************************** */
			pageInit();
			/* ************************* 页面初始化结束 ************************** */
		});
	})(jQuery, window);
</script>