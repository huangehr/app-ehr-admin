<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script src="${contextRoot}/develop/lib/plugin/mousepop/mouse_pop.js"></script>
<script>
	(function ($, win) {
		$(function () {
			/* ************************** 变量定义 ******************************** */
			var Util = $.Util;
			var retrieve = null;
			var master = null;
			var isFirstPage = true;
			var categoryId = '';
			var categoryName='';
			var categoryOrgId = '';
			var status = '';
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
				$status:$('#inp_status'),
				$search: $("#inp_search"),
				$searchNm: $('#inp_searchNm'),


				init: function () {
					var self = this;
					var categoryName = '';
					$('#div_tree').mCustomScrollbar({
						axis:"yx"
					});

					this.statusBox = this.$status.ligerComboBox({
						url: "${contextRoot}/dict/searchDictEntryList",
						dataParmName: 'detailModelList',
						urlParms: {dictId:61},
						valueField: 'code',
						textField: 'value',
						width: 120,
						value:"0"
					});

//					this.$search.ligerTextBox({width:220,value:searchParams.categorySearchNm,isSearch: true, search: function () {
//						categoryName = $("#inp_search").val();
//						typeTree.selectNode('');
//						typeTree.s_search(categoryName);
//						if(categoryName == ''){
//							typeTree.collapseAll();
//						}else{
//							typeTree.expandAll();
//						}
//						var parms = {
//							'searchNm':'',
//							'categoryId':'',
//						};
//						reloadGrid(parms);
//					}});


					this.$searchNm.ligerTextBox({width:240,value:searchParams.resourceSearchNm,isSearch: true, search: function () {
						var searchNm = $('#inp_searchNm').val();
						status = $('#inp_status').val();
						var parms = {
							'searchNm':searchNm,
							'status':status,
							'categoryId':categoryId
						};
						reloadGrid(parms);
					}});

					self.getResourceBrowseTree();
				},

				getResourceBrowseTree: function () {
					typeTree = this.$resourceBrowseTree.ligerSearchTree({
						nodeWidth: 240,
						url: '${contextRoot}/deptMember/categories',
						checkbox: false,
						idFieldName: 'id',
						parentIDFieldName :'parentDeptId',
						textFieldName: 'name',
						isExpand: false,
						childIcon:null,
						parentIcon:null,
						onSelect: function (e) {
							categoryId = e.data.id;
							categoryName = e.data.name;
							categoryOrgId = e.data.orgId;
							$('#categoryId').text(categoryId);
							$('#categoryOrgId').text(categoryOrgId);
							$('#categoryName').text(categoryName);
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
						url: '${contextRoot}/deptMember/searchOrgDeptMembers',
						parms: {
							searchNm: $('#inp_searchNm').val(),
							status:$('#inp_status').text(),
							categoryId: categoryId
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '姓名', name: 'userName', width: '15%', align: 'left'},
							{display: '职务', name: 'dutyName', width: '15%', align: 'left'},
							{display: '部门', name: 'deptName', width: '15%', align: 'left'},
							{display: '描述', name: 'remark', width: '23%', align: 'left'},
							{display: '是否生/失效',
								name: 'activityFlagName',
								width: '8%',
								isAllowHide: false,
								render: function (row) {
									var html = '';
									if (row.status == 0) {
										html += '<sec:authorize url="/deptMember/activity"><a class="grid_on" title="已生效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "deptMember:deptMemberDialog:status", row.id, '1','失效') + '"></a></sec:authorize>';

									} else {
										html += '<sec:authorize url="/deptMember/activity"><a class="grid_off" title="未生效" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "deptMember:deptMemberDialog:status", row.id, '0','生效') + '"></a></sec:authorize>';

									}
									return html;
								}
							},
							{display: '操作', name: 'operator', width: '32%', render: function (row) {
								var html = '';
								html += '<sec:authorize url="/deptMember/infoInitial"><a class="grid_edit" style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "rs:info:open", row.id,'modify',categoryId) + '"></a></sec:authorize>';
								html += '<sec:authorize url="/deptMember/deleteOrgDeptMember"><a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "deptMember:deptMemberDialog:del", row.id) + '"></a></sec:authorize>';
								return html;
							}}
						],
						pageSize:searchParams.pageSize,
						checkbox: false,
						validate : true,
						unSetValidateAttr:false,
						allowHideColumn: false,
//						onDblClickRow : function (row){
//							$.publish("rs:info:open",[row.id,'view'])
//						}
					}));
					this.resourceInfoGrid.adjustToWidth();
					this.bindEvents();
				},

				activity: function (id, status) {
					var dataModel = $.DataModel.init();
					dataModel.createRemote('${contextRoot}/deptMember/activity', {
						data: {id: id, status: status},
						success: function (data) {
							if (data.successFlg) {
								$.Notice.success('操作成功。');
								master.reloadGrid();
							}
						}
					});
				},


				reloadGrid: function () {
					var searchNm = $('#inp_searchNm').val();
					reloadGrid.call(this,{'searchNm':searchNm,'status':status,'categoryId': categoryId});
				},

				bindEvents: function () {
					var self = this;
					//新增修改
					$('#btn_add').click(function(){
						$.publish("rs:info:open",['','new',categoryId,categoryOrgId]);
					});
					$.subscribe("rs:info:open",function(event,resourceId,mode,categoryId,categoryOrgId){
						var title = "";
						if(mode == "modify"){title = "修改成员";}
						if(mode == "new"){
							title = "新增成员";
							if(categoryId == ''){
								$.Notice.error('请在坐边选中一个机构');
								return ;
							}
						}
						master.rsInfoDialog = $.ligerDialog.open({
							height:550,
							width:500,
							title:title,
							url:'${contextRoot}/deptMember/infoInitial',
							urlParms:{
								id:resourceId,
								mode:mode,
								categoryId:categoryId,
								categoryOrgId:categoryOrgId
							},
							load:true
						});
					});

					$.subscribe('deptMember:deptMemberDialog:status', function (event, id, status,msg) {
						$.ligerDialog.confirm('是否对该成员进行'+msg+'操作', function (yes) {
							if (yes) {
								self.activity(id, status);
							}
						});

					});

					$.subscribe('deptMember:deptMemberDialog:del',function(event,id){
						$.ligerDialog.confirm("确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。", function (yes) {
							if(yes){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote("${contextRoot}/deptMember/deleteOrgDeptMember",{
									data:{memberRelationId:id},
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
            $MousePop.init({
				//添加子类
				setAddChildFun: function ( id, me, categoryName) {
					console.log(categoryName);
					me.showPopWin(me,function () {
						//确认按钮回调：返回true关闭窗口
						var url = "${contextRoot}/deptMember/updateOrgDept",
								name = me.$popWim.find('.name').val(),
								code = me.$popWim.find('.code').val();
						if(name =='' || name == undefined){
							$.Notice.error('名称不能为空');
							return false;
						}
						if(code =='' || code == undefined){
							$.Notice.error('编码不能为空');
							return false;
						}
						me.res( url,
								{
									id:id,
									mode:'new',
									code:code,
									name:name
								},
								function (data) {
									if(data.successFlg){
										$.Notice.success('添加成功',function () {
											location.reload();
											return true;
										});
									}else{
										$.Notice.error(data.errorMsg);
										return false;
									}
								}
						);

					},{title: (!!categoryName ? categoryName + ' > 添加子部门' : '添加子部门')});
				},
				//修改名称
				setEditNameFun: function ( id, me, categoryName) {
					me.showPopWin(me,function () {
						//确认按钮回调：返回true关闭窗口
						var url = "${contextRoot}/deptMember/updateOrgDept",
								name = me.$popWim.find('.name').val();
						if(name =='' || name == undefined){
							$.Notice.error('名称不能为空');
							return false;
						}
						me.res( url,
								{   id:id,
									mode:'modify',
									code:'',
									name:name
								},
								function (data) {
									if(data.successFlg){
										$.Notice.success('修改成功',function () {
											location.reload();
											return true;
										});
									}else{
										$.Notice.error(data.errorMsg);
										return false;
									}
								}
						);
					},{title:(!!categoryName ? categoryName + ' > 修改名称' : '修改名称'),name:categoryName,className:'pt',classCode:'pop-f-hide'});
				},
				//删除
				setDelFun: function ( id, me) {
					var url = '';
					if (!confirm('确定要删除吗？')){
						return false;
					}
					var url = "${contextRoot}/deptMember/delOrgDept";
					me.res( url,{orgDeptId:id},
							function (data) {
								if(data.successFlg){
									$.Notice.success('删除成功',function () {
										location.reload();
										return true;
									});
								}else{
									$.Notice.error('删除失败');
									return false;
								}
							}
					);
				},
				//上移
				setUpFun: function ( id, me, pId) {
					var url = '${contextRoot}/deptMember/changeSortOrgDept';
					me.res( url,
							{   preDeptId:id,
								afterDeptId:pId
							},
							function (data) {
								if(data.successFlg){
									$.Notice.success('操作成功',function () {
										location.reload();
										return true;
									});
								}else{
									$.Notice.error('操作失败');
									return false;
								}
							}
					);
				},
				//下移
				setDownFun: function ( id, me, nId) {
					var url = '${contextRoot}/deptMember/changeSortOrgDept';
					me.res( url,
							{   preDeptId:id,
								afterDeptId:nId
							},
							function (data) {
								if(data.successFlg){
									$.Notice.success('操作成功',function () {
										location.reload();
										return true;
									});
								}else{
									$.Notice.error('操作失败');
									return false;
								}
							}
					);
                },
                //添加父类
                setAddParentFun: function ( id, me, categoryName) {
                    var html = ['<div class="pop-form">',
									'<label for="name">机构：</label>',
                                    '<input id="inp_deptId" class="required useTitle f-h28 f-w150 validate-special-char" data-type="select" placeholder="请选择部门"/>',
                                '</div>'].join('');
                    me.showPopWin(me,function () {
						var url = "${contextRoot}/deptMember/updateOrgDept",
							name = me.$popWim.find('.name').val(),
							code = me.$popWim.find('.code').val(),
							orgId = me.$popWim.find('#inp_deptId').val();
						alert(orgId);
						if(name =='' || name == undefined){
							$.Notice.error('名称不能为空');
							return false;
						}
						if(code =='' || code == undefined){
							$.Notice.error('编码不能为空');
							return false;
						}
						if(orgId =='' || orgId == undefined){
							$.Notice.error('机构不能为空');
							return false;
						}
						me.res( url,
								{
									id:1111111,
									mode:'addRoot',
									code:code,
									name:name
								},
								function (data) {
									if(data.successFlg){
										$.Notice.success('操作成功',function () {
											location.reload();
											return true;
										});
									}else{
										$.Notice.error('操作失败');
										return false;
									}
								}
						);
						return true;
                    },{title:'添加根部门'});
                    me.$popWim.append(html);
					var inpD = $('#inp_deptId');
					inpD.customCombo('${contextRoot}/deptMember/getDeptList');
					inpD.parent().css({
						width:'185'
					}).parent().css({
						display:'inline-block',
						width:'185px'
					});
                }
            });

		});
	})(jQuery, window);
</script>