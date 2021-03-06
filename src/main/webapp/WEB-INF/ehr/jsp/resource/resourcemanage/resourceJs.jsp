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
			var typeTree = null;
			var switchUrl = {
				configUrl:'${contextRoot}/resourceConfiguration/initial',
				grantUrl:'${contextRoot}/resource/grant/initial',
				viewUrl:'${contextRoot}/resourceView/initial'
			}

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
			//由跳转页面返回资源注册页面时的页面初始化-------------
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

                $droDList: $('#droDList'),
				init: function () {
					var self = this;
					var categoryName = '';
					$('#div_tree').mCustomScrollbar({
						axis:"yx"
					});
					this.$search.ligerTextBox({width:220,value:searchParams.categorySearchNm,isSearch: true, search: function () {
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
                            'dataSource':0
						};
						reloadGrid(parms);
					}});
					this.$searchNm.ligerTextBox({width:240,value:searchParams.resourceSearchNm,isSearch: true, search: function () {
						var searchNm = $('#inp_searchNm').val();
                        var resourceType = $('#droDList_val').val();
                        debugger
						var parms = {
							'searchNm':searchNm,
							'categoryId':categoryId,
                            'dataSource': parseInt(resourceType)
						};
						reloadGrid(parms);
					}});
					self.getResourceBrowseTree();

                    self.$droDList.ligerComboBox({
                        data: [{
                            id: '0',
                            text: '全部'
                        },{
                            id: '1',
                            text: '档案数据'
                        },{
                            id: '2',
                            text: '指标统计'
                        }]
                    });
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
						url: '${contextRoot}/resource/resourceManage/resources',
						parms: {
							searchNm: $('#inp_searchNm').val(),
							categoryId: categoryId,
                            dataSource: 0
						},
						columns: [
							{name: 'id', hide: true, isAllowHide: false},
							{display: '访问方式', name: 'grantType',hide:true},
							{display: '视图名称', name: 'name', width: '15%', align: 'left'},
							{display: '视图编码', name: 'code', width: '15%', align: 'left'},
							{display: '视图接口', name: 'rsInterfaceName', width: '15%', align: 'left'},
							{display: '视图分类', name: 'categoryName', width: '10%', align: 'left'},
							{display: '视图分类Id', name: 'categoryId',hide:true},
							{display: '视图说明', name: 'description', width: '13%', align: 'left'},
							{display: '操作', name: 'operator', width: '32%', render: function (row) {
								var html = '<div style="text-align:right;">';
                                if (row.dataSource == 2 || row.dataSource == null) {
                                    html += '<sec:authorize url="/resourceConfiguration/zhibaioConfigue"><a class="label_a" style="margin-left:5px;"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "rs:switch:zhibaioConfigue",row.id) + '">指标配置</a></sec:authorize>';
                                    html += '<sec:authorize url="/resourceConfiguration/zhibaioShow"><a class="label_a" style="margin-left:5px;"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "rs:switch:zhibaioShow",row.id) + '">指标预览</a></sec:authorize>';
                                }
								if (row.dataSource != 2){
                                    html += '<sec:authorize url="/resource/defaultParam/initial"><a class="label_a" title="默认参数配置" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "rs:param:list:open", row.id,row.code) + '">默认参数配置</a></sec:authorize>';
									<%--html += '<sec:authorize url="/resourceConfiguration/initial"><a class="label_a" style="margin-left:5px;"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}','{5}','{6}'])", "rs:switch:open",row.id,row.name,row.categoryName,switchUrl.configUrl,"1",row.dataSource) + '">配置</a></sec:authorize>';--%>
                                    if(row.grantType == '0'){
                                        html += '<sec:authorize url="/resource/grant/initial"><a class="label_a" style="margin-left:5px;"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}','{5}','{6}'])", "rs:switch:open",row.id,row.name,row.categoryName,switchUrl.grantUrl,"1",row.dataSource) + '">授权</a></sec:authorize>';
                                    }
                                    html += '<sec:authorize url="/resourceView/initial"><a class="label_a" style="margin-left:5px;" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}','{5}','{6}'])", "rs:switch:open",row.id,row.name,row.categoryName,switchUrl.viewUrl,row.code,row.dataSource) + '">浏览</a></sec:authorize>';
								}
								html += '<sec:authorize url="/resource/resourceManage/infoInitial"><a class="grid_edit" style="width:30px" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "rs:info:open", row.id,'modify',categoryId) + '"></a></sec:authorize>';
								html += '<sec:authorize url="/resource/resourceManage/delete"><a class="grid_delete" style="width:30px" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "rs:info:delete", row.id, 'delete') + '"></a></sec:authorize>';
//								html += '<a class="grid_delete" title="默认参数" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "rs:param:list:open", row.id,row.code) + '"></a>';
                                html += '</div>';
								return html;
							}}
						],
						pageSize:searchParams.pageSize,
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

				saveParamsToSession:function(){
					var values = {};
					values.categoryId = categoryId;
					values.categorySearchNm = $("#inp_search").val();
					values.resourceSearchNm = $('#inp_searchNm').val();
					values.page = parseInt($('.pcontrol input', master.resourceInfoGrid.toolbar).val());
					values.pageSize = $(".l-bar-selectpagesize select", master.resourceInfoGrid.toolbar).val();
					sessionStorage.setItem("rsPageParams",JSON.stringify(values));
				},

				bindEvents: function () {
					//新增修改
					$('#btn_add').click(function(){
						$.publish("rs:info:open",['','new',categoryId]);
					});
					$.subscribe("rs:info:open",function(event,resourceId,mode,categoryId){
						var title = "";
						var wait = $.Notice.waitting("请稍后...");
						if(mode == "modify"){title = "修改视图";}
						if(mode == "view"){title = "查看视图";}
						if(mode == "new"){title = "新增视图";}
						master.rsInfoDialog = $.ligerDialog.open({
							height:550,
							width:500,
							title:title,
							url:'${contextRoot}/resource/resourceManage/infoInitial',
							urlParms:{
								id:resourceId,
								mode:mode,
								categoryId:categoryId,
							},
							load:true,
							show:false,
							isHidden:false,
							onLoaded:function(){
								wait.close(),
								master.rsInfoDialog.show()
							}
						});
						master.rsInfoDialog.hide();
					});


                    //指标配置
                    $.subscribe("rs:switch:zhibaioConfigue",function(event, resourceId){
                        var title = "指标配置";
                        var wait = $.Notice.waitting("请稍后...");
                        master.zhibaioConfigueDialog = $.ligerDialog.open({
                            height:700,
                            width:900,
                            title:title,
                            url:'${contextRoot}/resource/resourceManage/resourceConfigue',
                            urlParms:{
                                id:resourceId
                            },
                            load:true,
                            show:false,
                            isHidden:false,
                            onLoaded:function(){
                                wait.close(),
                                master.zhibaioConfigueDialog.show()
                            }
                        });
                        master.zhibaioConfigueDialog.hide();
                    });
                    //指标预览
                    $.subscribe("rs:switch:zhibaioShow",function(event,resourceId){
                        var title = "指标预览";
                        var wait = $.Notice.waitting("请稍后...");
                        master.zhibaioShowDialog = $.ligerDialog.open({
                            height:650,
                            width:800,
                            title:title,
                            url:'${contextRoot}/resource/resourceManage/resourceShow',
                            urlParms:{
                                id:resourceId,
                                quotaId: '',
                                dimension: '',
                                quotaFilter: ''
                            },
                            load:true,
                            show:false,
                            isHidden:false,
                            onLoaded:function(){
                                wait.close(),
                                master.zhibaioShowDialog.show()
                            }
                        });
                        master.zhibaioShowDialog.hide();
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
					$.subscribe("rs:param:list:open",function(event,resourcesId,resourcesCode){
						master.rsParamDialog = $.ligerDialog.open({
							height:500,
							width:600,
							title:"配置默认参数",
							url:'${contextRoot}/resource/rsDefaultParam/initial',
							urlParms:{
								resourcesId:resourcesId,
								resourcesCode:resourcesCode,
							},
							load:true
						});
					});
					//配置、浏览、授权页面跳转
					$.subscribe("rs:switch:open",function(event,resourceId,resourceName,categoryName,url,resourceCode,dataSource){
						master.saveParamsToSession();
						var data = {
							'resourceId':resourceId,
							'resourceName':resourceName,
							'resourceSub':categoryName,
							'resourceCode':resourceCode,
                            'dataSource':dataSource
						}
						$("#contentPage").empty();
						$("#contentPage").load(url,{dataModel:JSON.stringify(data)});
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

			//新增修改所属资源类别为默认时，只刷新右侧列表；有修改所属资源类别时，左侧树重新定位，刷新右侧列表
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
            win.closeZhibaioConfigueDialog = function (callback) {
                master.zhibaioConfigueDialog.close();
            };
			//新增、修改（资源分类有修改情况）定位
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