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
			var categoryOrgId = '';
			var typeTree = null;
			var orgId = '${orgId}';


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
						var parentId = $($('#'+id).parent()).parent().attr('userId');
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
				$btnSearch: $("#btn_search"),
				$searchNm: $('#inp_searchNm'),
                $searchNmLeft: $('#inp_searchNm_left'),
				$level: $('#inp_level'),

				init: function () {
					var self = this;
					var categoryName = '';
					$('#div_tree').mCustomScrollbar({
						axis:"yx"
					});

					<%--this.$search.customCombo('${contextRoot}/deptMember/getOrgList');--%>
                    this.$searchNmLeft.ligerTextBox({width:220,value:searchParams.resourceSearchNm,isSearch: true, search: function () {
                        self.getResourceBrowseTree();
                    }});
					this.$searchNm.ligerTextBox({width:240,value:searchParams.resourceSearchNm,isSearch: true, search: function () {
						var searchNm = $('#inp_searchNm').val();
						var parms = {
							'searchNm':searchNm,
							'userId':$('#categoryId').text(),
							'orgId':categoryOrgId
						};
						reloadGrid(parms);
					}});

					self.getResourceBrowseTree();
				},

				getResourceBrowseTree: function () {
                    var searchNm = $('#inp_searchNm_left').val();
					typeTree = this.$resourceBrowseTree.ligerSearchTree({
						nodeWidth: 240,
						url: '${contextRoot}/upAndDownMember/categories?orgId='+orgId+'&searchNm='+searchNm,
						checkbox: false,
						idFieldName: 'userId',
						parentIDFieldName :'parentUserId',
						textFieldName: 'userName',
						isExpand: false,
						childIcon:null,
						parentIcon:null,
						onSelect: function (e) {
							categoryId = e.data.userId;
							categoryName = e.data.userName;
							categoryOrgId = e.data.orgId;
							$('#categoryOrgId').text(categoryOrgId);
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
						url: '${contextRoot}/upAndDownMember/searchUpAndDownMembers',
						parms: {
							searchNm: $('#inp_searchNm').val(),
							userId:categoryId,
							orgId:categoryOrgId
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '姓名', name: 'userName', width: '15%', align: 'left'},
							{display: '职务', name: 'dutyName', width: '15%', align: 'left'},
							{display: '部门', name: 'deptName', width: '20%', align: 'left'},
							{display: '描述', name: 'remark', width: '30%', align: 'left'},
							{display: '操作', name: 'operator', width: '20%', render: function (row) {
								var html = '';
								html += '<sec:authorize url="/upAndDownMember/deleteUpAndDownDelMember"><a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "deptMember:deptMemberDialog:del", row.id) + '"></a></sec:authorize>';
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
					reloadGrid.call(this,{'searchNm':searchNm,'userId':categoryId,'orgId': categoryOrgId});
				},

				bindEvents: function () {
					var self = this;
					//新增修改
					$('#btn_addDown').click(function(){
						$.publish("rs:info:open",['','newDown',categoryId,categoryOrgId,categoryName]);
					});
					$('#btn_search').click(function(){
						categoryOrgId='';
						categoryName='';
						categoryId='';
						$('#categoryName').text('');
						$('#categoryId').text('');
						$('#categoryOrgId').text('');
						var orgId = $('#inp_search_val').val();
						if(orgId != ''){
							retrieve.getResourceBrowseTree(orgId);
						}else{
							return;
						}
					});


					$.subscribe("rs:info:open",function(event,resourceId,mode,categoryId,categoryOrgId,categoryName){
						var title = "";
						if(categoryId == ''|| categoryId==undefined ){
                            parent._LIGERDIALOG.error('请在左边选中一个成员');
							return ;
						}
						if(mode == "newDown"){title = "新增下级成员";}
						master.rsInfoDialog = parent._LIGERDIALOG.open({
							height:220,
							width:450,
							title:title,
							url:'${contextRoot}/upAndDownMember/infoInitial',
							urlParms:{
								id:resourceId,
								mode:mode,
								categoryName:categoryName,
								categoryId:categoryId,
								categoryOrgId:categoryOrgId,
							},
							load:true
						});
					});



					$.subscribe('deptMember:deptMemberDialog:del',function(event,id){
                        parent._LIGERDIALOG.confirm("确认删除该条信息？<br>如果是请点击确认按钮，否则请点击取消。", function (yes) {
							if(yes){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote("${contextRoot}/upAndDownMember/deleteOrgDeptMember",{
									data:{memberRelationId:id},
									async:true,
									success: function(data) {
										if(data.successFlg){
                                            parent._LIGERDIALOG.success('删除成功',function () {
												master.reloadGrid();
                                                typeTree.reload();
												return true;
											});
										}else{
											parent._LIGERDIALOG.error('删除失败');
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
//

			//新增修改所属成员类别为默认时，只刷新右侧列表；有修改所属成员类别时，左侧树重新定位，刷新右侧列表
			win.reloadMasterUpdateGrid = function (categoryIdNew) {
				if(!categoryIdNew){
					master.reloadGrid();
					return
				}
                retrieve.getResourceBrowseTree();
			};
			win.parent.closeRsInfoDialog = function (callback) {
				isFirstPage = false;
                master.reloadGrid();
                typeTree.reload();
				master.rsInfoDialog.close();
			};
			//新增、修改（成员分类有修改情况）定位
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