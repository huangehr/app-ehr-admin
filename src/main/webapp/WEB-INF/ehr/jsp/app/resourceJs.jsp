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
			var categoryId = '';
			var isFirstPage = true;
			var typeTree = null;
			var backParams = ${backParams};
			var appId = backParams.appId;
			//应用已授权资源集合
			var appRsIds = [];

			// 资源分类；资源明细检索信息，page，pageSize-------------------
			var appRsPageParams = JSON.parse(sessionStorage.getItem('appRsPageParams'))
			sessionStorage.removeItem('appRsPageParams');
			var searchParams = {
				//左侧资源分类树
				categoryId:appRsPageParams && appRsPageParams.categoryId || '',
				categorySearchNm:appRsPageParams && appRsPageParams.categoryFilter || '',
				//右侧资源列表
				searchNm:appRsPageParams && appRsPageParams.resourceFilter || '',
				page:appRsPageParams && appRsPageParams.page || 1,
				pageSize:appRsPageParams && appRsPageParams.pageSize || 15,
			}

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
				if(searchParams.page >1){
					master.resourceInfoGrid.options.newPage = searchParms.page;
					searchParams.page = 1;//重置
				}
				master.resourceInfoGrid.setOptions({parms: params});
				master.resourceInfoGrid.loadData(true);
				isFirstPage = true;
			}
			//维度授权返回资源页面，资源页面的初始化
			function treeNodeInit(id){
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
			}
			//添加碎片
            function appendNav(str, url, data) {
                $('#navLink').append('<span class="weidu"> <i class="glyphicon glyphicon-chevron-right"></i> <span style="color: #337ab7">'  +  str+'</span></span>');
                $(".go-back").hide();
                $(".applevel1").find("span").css("color","");
                $('#div_nav_breadcrumb_bar').show().append('<div class="btn btn-default go-backa"><i class="glyphicon glyphicon-chevron-left"></i>返回上一层</div>');
                $("#contentPage").css({
                    'height': 'calc(100% - 40px)'
                }).empty().load(url,data);
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
					this.$appName.html(backParams.appName);
					this.$catalogName.html(backParams.catalogName);
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
					$('#div_tree').mCustomScrollbar({
						axis:'yx'
					});
					this.$search.ligerTextBox({width:220,value:searchParams.categorySearchNm,isSearch: true, search: function () {
						categoryName = $("#inp_search").val();
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
					this.$searchNm.ligerTextBox({width:240,value:searchParams.resourceSearchNm,isSearch: true, search: function () {
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
						childIcon:null,
						parentIcon:null,
						onSelect: function (e) {
							categoryId = e.data.id;
							master.reloadGrid();
						},
						onSuccess: function (data) {
							$("#div_resource_browse_tree li div span").css({
								"line-height": "22px",
								"height": "22px"
							});
							if(!Util.isStrEmpty(searchParams.categorySearchNm)){
								$('#inp_search').val(searchParams.categorySearchNm);
								typeTree.s_search(searchParams.categorySearchNm);
							}
							if(!Util.isStrEmpty(searchParams.categoryId)){
								treeNodeInit(searchParams.categoryId);
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
							{display: '视图名称', name: 'name', width: '15%', align: 'left'},
							{display: '视图代码', name: 'code', width: '15%', align: 'left'},
							{display: '数据源', name: 'rsInterfaceName', width: '15%', align: 'left'},
							{display: '视图分类', name: 'categoryName', width: '15%', align: 'left'},
							{display: '视图分类Id', name: 'categoryId',hide:true},
							{display: '视图说明', name: 'description', width: '20%', align: 'left'},
							{display: '是否授权', name: 'status', width: '10%', render: function (row) {
								if(appRsIds.indexOf(row.id)<0){
									return '否'
								}
								return '是';
							}},
							{display: '操作', name: 'operator', width: '10%', render: function (row) {
								if(appRsIds.indexOf(row.id)<0){
									return ''
								}
								var html = '<a class="label_a"  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}'])", "app:resourceManage:list",row.id,row.code,row.name,row.categoryName) + '">维度授权</a>';
								return html;
							}}
						],
						pageSize:searchParams.pageSize,
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
						async:false,
						success: function(data) {
							if(data.successFlg){
								appRsIds = data.detailModelList;
							}
						}
					});
				},
				//资源分类、资源列表检索页面数据保存到sessionStorage
				savePageParamsToSession:function(){
					var values = {};
					values.categoryId = categoryId;
					values.categorySearchNm = $("#inp_search").val();
					values.resourceSearchNm = $('#inp_searchNm').val();
					values.page = parseInt($('.pcontrol input', master.resourceInfoGrid.toolbar).val());
					values.pageSize = $(".l-bar-selectpagesize select", master.resourceInfoGrid.toolbar).val();
					sessionStorage.setItem("appRsPageParams",JSON.stringify(values));
				},
				bindEvents: function () {
					//资源授权
					$('#btn_grant').click(function(){
						$.publish('app:rs:grant',['']);
					});
					$.subscribe('app:rs:grant',function(event,ids){
						if(!ids){
							var rows = master.resourceInfoGrid.getSelectedRows();
							if(rows.length==0){
								parent._LIGERDIALOG.warn('请选择要授权给应用的视图！');
								return;
							}
							for(var i=0;i<rows.length;i++){
								//只授权还未授权过的资源（排除已授权资源id）
								if(appRsIds.indexOf(rows[i].id)<0){
									ids += ',' + rows[i].id;
								}
							}
							ids = ids.length>0 ? ids.substring(1, ids.length) : ids ;
							if(Util.isStrEmpty(ids)){
								parent._LIGERDIALOG.warn( '所选视图都已授权！');
								return;
							}
						}
						parent._LIGERDIALOG.confirm('确认要授权所选视图？', function (r) {
							if(r){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/app/resource/grant',{
									data:{appId:appId,resourceIds:ids},
									success:function(data){
										if(data.successFlg){
											appRsIds = [];
											isFirstPage = false;
											parent._LIGERDIALOG.success( '授权成功！');
											master.loadResourceIds();
											master.reloadGrid();
										}else{
											parent._LIGERDIALOG.error('授权失败！');
										}
									}
								});
							}
						})
					});

                    //一键资源授权
                    $('#btn_grant_all').click(function(){
                        $.publish('app:rs:grant:all',['']);
                    });
                    $.subscribe('app:rs:grant:all',function(event,ids){
                        if(!categoryId){
                            parent._LIGERDIALOG.warn('请选择要授权的视图分类！');
                            return;
                        }
                        parent._LIGERDIALOG.confirm('确认要授权所有视图？', function (r) {
                            if(r){
                                var dataModel = $.DataModel.init();
                                var waittingDialog = $.ligerDialog.waitting("正在处理中，请稍候..");
                                dataModel.updateRemote('${contextRoot}/app/grantByCategoryId',{
                                    data:{appId:appId,categoryIds:categoryId,resourceIds:ids},
                                    success:function(data){
                                        waittingDialog.close();
                                        if(data.successFlg){
                                            appRsIds = [];
                                            isFirstPage = false;
                                            parent._LIGERDIALOG.success( '授权成功！');
                                            master.loadResourceIds();
                                            master.reloadGrid();
                                        }else{
                                            parent._LIGERDIALOG.error('授权失败！');
                                        }
                                    }
                                });
                            }
                        })
                    });

                    //一键取消资源授权
                    $('#btn_grant_cancel_all').click(function(){
                        $.publish('app:rs:grant:cancel:all',['']);
                    });
                    $.subscribe('app:rs:grant:cancel:all',function(event,ids){
                        if(!categoryId){
                            parent._LIGERDIALOG.warn('请选择要授权的视图分类！');
                            return;
                        }
                        parent._LIGERDIALOG.confirm('确认要取消所有视图的授权？', function (r) {
                            if(r){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/app/deleteAppsGrantResourcesByCategoryId',{
                                    data:{appId:appId,categoryIds:categoryId,resourceIds:ids},
                                    success:function(data){
                                        if(data.successFlg){
                                            appRsIds = [];
                                            isFirstPage = false;
                                            parent._LIGERDIALOG.success( '取消授权成功！');
                                            master.loadResourceIds();
                                            master.reloadGrid();
                                        }else{
                                            parent._LIGERDIALOG.error('取消授权失败！');
                                        }
                                    }
                                });
                            }
                        })
                    });

					//资源授权删除
					$('#btn_grant_cancel').click(function(){
						$.publish("app:rs:grant:cancel",[''])
					});
					$.subscribe('app:rs:grant:cancel',function(event,ids){
						if(!ids){
							var rows = master.resourceInfoGrid.getSelectedRows();
							if(rows.length==0){
								parent._LIGERDIALOG.warn('请选择要删除的授权视图！');
								return;
							}
							for(var i=0;i<rows.length;i++){
								//只删除已授权的资源（排除未授权资源的ids)
								if(appRsIds.indexOf(rows[i].id)>=0){
									ids += ',' + rows[i].id;
								}
							}
							ids = ids.length>0 ? ids.substring(1, ids.length) : ids ;
							if(Util.isStrEmpty(ids)){
								parent._LIGERDIALOG.warn('所选视图都未授权！');
								return;
							}
						}
						parent._LIGERDIALOG.confirm('确认要取消授权所选视图？', function (r) {
							if(r){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/app/resource/cancel',{
									data:{appId:appId,resourceIds:ids},
									success:function(data){
										if(data.successFlg){
											appRsIds = [];
											isFirstPage = false;
											parent._LIGERDIALOG.success( '取消授权成功！');
											master.loadResourceIds();
											master.reloadGrid();
										}else{
                                            parent._LIGERDIALOG.error('取消授权失败！');
										}
									}
								});
							}
						})
					});

					//维度授权页面跳转
					$.subscribe('app:resourceManage:list', function (event,resourceId,code,resourceName,categoryName) {
						master.savePageParamsToSession();//页面数据保存sessionStorage
						//跳转维度授权页面，带参数
						var data = {
							'appId':appId,
							'resourceId':resourceId,
							'code':code,
							'resourceName':resourceName,
							'resourceSub':categoryName,
							'backParams':backParams,//资源页面顶app信息
						}
                        var url='${contextRoot}/app/resourceManage/initial?appId='+appId+'&resourceId='+resourceId;
                        appendNav('维度授权', url,{dataModel:JSON.stringify(data)});
						<%--$("#contentPage").empty();--%>
						<%--$("#contentPage").load('${contextRoot}/app/resourceManage/initial?appId='+appId+'&resourceId='+resourceId,{dataModel:JSON.stringify(data)});--%>
					});
                    $(document).on('click', '.go-backa', function (e) {
                        debugger;
                        $('.go-backa').remove();
                        $(".go-back").show();
                        $(".applevel1").find("span").css("color","#337ab7");
                        $(".weidu").remove();
                        var data = JSON.parse(sessionStorage.getItem("applevel1"));
                        var url = '${contextRoot}/app/resource/initial';
                        $("#contentPage").empty();
                        $("#contentPage").load(url,data);
                    });
				},
			};
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