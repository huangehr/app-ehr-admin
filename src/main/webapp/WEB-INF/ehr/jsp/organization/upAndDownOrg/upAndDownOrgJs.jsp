<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
			var categoryName = '';
			var typeTree = null;


			var rsPageParams = JSON.parse(sessionStorage.getItem('rsPageParams'));
			sessionStorage.removeItem('rsPageParams');
			var searchParams = {
				categoryId:rsPageParams&&rsPageParams.categoryId || '',
				categorySearchNm:rsPageParams &&rsPageParams.categorySearchNm || '',
				resourceSearchNm:rsPageParams&&rsPageParams.resourceSearchNm || '',
				page:rsPageParams&&rsPageParams.page || 1,
				pageSize:rsPageParams&&rsPageParams.pageSize || 15,
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
				if(searchParams.page >1){
					master.resourceInfoGrid.options.newPage = searchParams.page;//只针对跳转页面返回时
					searchParams.page = 1;//重置
				}
				master.resourceInfoGrid.setOptions({parms: params});
				master.resourceInfoGrid.loadData(true);
				isFirstPage = true;
			};

			//由跳转页面返回成员注册页面时的页面初始化-------------
			function treeNodeInit (id){
				if(!id){return}
				function expandNode (id){
					var level = $($('#'+id).parent()).parent().attr('outlinelevel')
					if(level){
						var parentId = $($('#'+id).parent()).parent().attr('id')
						$($($('#'+id).parent()).prev()).children(".l-expandable-close").click()//展开节点
						expandNode(parentId);
					}
				}
				expandNode(id);
				typeTree.selectNode(id);
			};

			/* *************************** 模块初始化 ***************************** */
			retrieve = {

				typeTree: null,
				$resourceBrowseTree: $("#div_resource_browse_tree"),
				$logicalRelationship: $("#inp_logical_relationship"),
				$searchModel: $(".div_search_model"),
				$resourceInfoGrid: $("#div_resource_info_grid"),
				$search: $("#inp_search"),
				$searchNm: $('#inp_searchNm'),
				$level: $('#inp_level'),



				init: function () {
					var self = this;
					var categoryName = '';
					$('#div_tree').mCustomScrollbar({
						axis:"yx"
					});

					this.$searchNm.ligerTextBox({width:240,value:searchParams.resourceSearchNm,isSearch: true, search: function () {
						var searchNm = $('#inp_searchNm').val();
						var parms = {
							'searchNm':searchNm,
							'orgId':categoryOrgId
						};
						reloadGrid(parms);
					}});

					self.getResourceBrowseTree();
				},

				getResourceBrowseTree: function () {
					typeTree = this.$resourceBrowseTree.ligerSearchTree({
						nodeWidth: 240,
						url: '${contextRoot}/upAndDownOrg/categories',
						checkbox: false,
						idFieldName: 'id',
						parentIDFieldName :'parentHosId',
						textFieldName: 'fullName',
						isExpand: false,
						childIcon:null,
						parentIcon:null,
						onSelect: function (e) {
							categoryId = e.data.id;
							categoryName = e.data.fullName;
							$('#categoryName').text(categoryName);
							$('#categoryId').text(categoryId);
							master.reloadGrid();
						},
						onSuccess: function (data) {
							if(data.length != 0){
								$("#div_resource_browse_tree li div span").css({
									"line-height": "22px",
									"height": "22px"
								});
							}
							if(!Util.isStrEmpty(searchParams.categorySearchNm)){
								$('#inp_search').val(searchParams.categorySearchNm);
								typeTree.s_search(searchParams.categorySearchNm);
							}
							if(!Util.isStrEmpty(searchParams.categoryId)){
								treeNodeInit(searchParams.categoryId)
							}
						},
					});
				},
			};

			master = {
				resourceInfoGrid:null,
				init: function () {
					this.resourceInfoGrid = $("#div_resource_info_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/upAndDownOrg/searchUpAndDownOrgs',
						parms: {
							searchNm: $('#inp_searchNm').val(),
							orgId:categoryId
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '机构类型', name: 'orgTypeName', width: '8%', align: "left"},
							{display: '机构代码', name: 'orgCode', width: '9%', align: "left"},
							{display: '机构全名', name: 'fullName', width: '15%', align: "left"},
							{display: '联系人', name: 'admin', width: '8%', align: "left"},
							{display: '联系方式', name: 'tel', width: '8%', align: "left"},
							{display: '入驻方式', name: 'settledWayName', width: '10%', isAllowHide: false},
							{display: '操作', name: 'operator', width: '25%', render: function (row) {
								var html = '';
								html += '<sec:authorize url="/upAndDownOrg/deleteUpAndDownDelMember"><a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "upAndDownOrg:upAndDownOrgDialog:del", row.id) + '"></a></sec:authorize>';
								return html;
							}}
						],
						pageSize:searchParams.pageSize,
						checkbox: false,
						validate : true,
						unSetValidateAttr:false,
						allowHideColumn: false,
					}));
					this.resourceInfoGrid.adjustToWidth();
					this.bindEvents();
				},

				reloadGrid: function () {
					var searchNm = $('#inp_searchNm').val();
					reloadGrid.call(this,{'searchNm':searchNm,'orgId': categoryId});
				},

				bindEvents: function () {
					var self = this;
					//新增
					$('#btn_addDown').click(function(){
						$.publish("rs:info:open",['',categoryId]);
					});
					$.subscribe("rs:info:open",function(event,resourceId,categoryId){
						var title = "新增下级机构";
                    	var	wait = $.Notice.waitting('请稍后...');
						if(categoryId == ''){
							$.Notice.error('请在坐边选中一个机构');
							if(wait){
								wait.close();
							}
							return ;
						}
						master.rsInfoDialog = $.ligerDialog.open({
							height:200,
							width:500,
							title:title,
							url:'${contextRoot}/upAndDownOrg/infoInitial',
							urlParms:{
								categoryId:categoryId
							},
							load:true,
							show:false,
							isHidden: false,
                            onLoaded:function() {
                                wait.close();
                                master.rsInfoDialog.show();
                            }
						});
						master.rsInfoDialog.hide();
					});



					$.subscribe('upAndDownOrg:upAndDownOrgDialog:del',function(event,id){
						$.ligerDialog.confirm("确认删除该条信息？<br>如果是请点击确认按钮，否则请点击取消。", function (yes) {
							if(yes){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote("${contextRoot}/upAndDownOrg/updateOrgDeptMember",{
									data:{orgId:id,pOrgId:0,mode:'del'},
									async:true,
									success: function(data) {
										if(data.successFlg){
											$.Notice.success('删除成功',function () {
												master.reloadGrid();
												return true;
											});
										}else{
											$.Notice.error('删除失败');
											return false;
										}
									}
								});
							}
						})
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

			//新增修改所属成员类别为默认时，只刷新右侧列表；有修改所属成员类别时，左侧树重新定位，刷新右侧列表
			win.reloadMasterUpdateGrid = function (categoryIdNew) {
				if(!categoryIdNew){
					master.reloadGrid();
					return
				}
				treeNodeInit(categoryIdNew);
			};
			win.closeRsInfoDialog = function (callback) {
				isFirstPage = false;
				master.rsInfoDialog.close();
			};

			win.locationTree = function(callbackParams){
				if(!callbackParams){
					master.reloadGrid();
					return
				}
				var select = function(id){
					if(id){
						var parentId = $('#'+id).parent().parent().attr("id");
						$('#'+id+' >.l-body>.l-expandable-close').click()
						select(parentId);
					}
				}
				$("#inp_search").val(callbackParams.typeFilter);
				typeTree.s_search(callbackParams.typeFilter);
				select(callbackParams.categoryId);

			}
			/* ************************* dialog回调函数结束 ************************** */

			/* *************************** 页面初始化 **************************** */
			pageInit();
			/* ************************* 页面初始化结束 ************************** */
		});
	})(jQuery, window);
</script>