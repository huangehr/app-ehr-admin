<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script>
	(function ($, win) {
		$(function () {
			/* ************************** 全局变量定义 **************************** */
			var Util = $.Util;
			var retrieve = null;
			var appMaster = null;
			var rolesMaster = null;
			var appId = '';
			var isFirstPage = true;
			/* *************************** 函数定义 ******************************* */
			function pageInit() {
				retrieve.init();
				appMaster.init();
				rolesMaster.init();
			}

			function reloadRolesGrid(params) {
				if (isFirstPage){
					rolesMaster.rolesGrid.options.newPage = 1;
				}
				rolesMaster.rolesGrid.setOptions({parms: params});
				rolesMaster.rolesGrid.loadData(true);
				isFirstPage = true;
			}

            //添加碎片
            function appendNav(str, url, data) {
                sessionStorage.setItem("rolelevel1",JSON.stringify(data));
                $('#navLink').append('<span class="applevel1"> <i class="glyphicon glyphicon-chevron-right"></i> <span style="color: #337ab7">'  +  str+'</span></span>');
                $('#div_nav_breadcrumb_bar').show().append('<div class="btn btn-default go-back"><i class="glyphicon glyphicon-chevron-left"></i>返回上一层</div>');
                $("#contentPage").css({
                    'height': 'calc(100% - 40px)'
                }).empty().load(url,data);
            }
			/* *************************** 标准字典模块初始化 ***************************** */
			retrieve = {
				$element: $('#std_roles'),
				$search:$('#inp_search'),
				$searchNm:$('#inp_searchNm'),
				init: function () {
					this.$search.ligerTextBox({width:200, isSearch: true, search: function () {
						var appName = $("#inp_search").val();
						appMaster.appGrid.setOptions({parms: {
							searchNm: appName,
							searchType: appName}
						});
						appMaster.appGrid.loadData(true);
					}});
					this.$searchNm.ligerTextBox({width:200, isSearch: true, search: function () {
						rolesMaster.reloadRolesGrid();
					}})
				}
			};
			appMaster = {
				appGrid : null,
				init : function (){
					var appName = $("#inp_search").val();
					this.appGrid = $("#div_std_app_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/userRoles/searchApps',
						parms: {
							searchNm: appName
						},
						columns: [
							{display: 'id', name: 'id', hide: true},
							{display: '平台应用名称', name: 'name', width: '100%', isAllowHide: false, align: 'center'},
						],
						//usePager:false,
						rownumbers:false,
						validate: true,
						unSetValidateAttr: false,
						allowHideColumn: false,
						onAfterShowData:function(data){
								appMaster.appGrid.select(0);
						},
						onSelectRow: function (row) {
							appId = row.id;
							rolesMaster.reloadRolesGrid();
						}
					}));
					this.bindEvent();
				},
				bindEvent:function(){
					//检索事件，刷新平台应用列表
					$('#btn_app_search').click(function(){
						var appName = $("#inp_search").val();
						appMaster.appGrid.setOptions({parms: {
							searchNm: appName,
							searchType: appName,}
						});
						appMaster.appGrid.loadData(true);
					})
				},
			};
			rolesMaster = {
				rolesGrid : null,
				init : function (){
					var rolesName = $("#inp_searchNm").val();
					this.rolesGrid = $("#div_roles_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/userRoles/search',
						parms: {
							searchNm:rolesName,
							appId: appId,
						},
						columns: [
							{display: 'id', name: 'id', width: '0.1%', hide: true},
							{display: '角色组编码', name: 'code', width: '15%', isAllowHide: false, align: 'center'},
							{display: '角色组名称', name: 'name', width: '15%', isAllowHide: false, align: 'center'},
							{display: '机构名称', name: 'orgName', width: '15%', isAllowHide: false, align: 'center'},
							{display: '描述', name: 'description', width: '10%', isAllowHide: false, align: 'center'},
							{
								display: '操作', name: 'operator', minWidth: 405, render: function (row) {
								var jsonStr = JSON.stringify(row);
								var html = '';

								<sec:authorize url="/appRole/updateFeatureConfig">
									html = '<a class="label_a" href="javascript:void(0)" onclick=javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "roles:config:open", jsonStr,"limits") + '>权限配置</a>';
								</sec:authorize>

								<sec:authorize url="Role_User_Setting">
									html += '<a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick=javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "roles:config:open", jsonStr,"users") + '>人员配置</a>';
								</sec:authorize>

								<sec:authorize url="/userRoles/orgConfig">
									html += '<a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick=javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "roles:orgConfig:open", jsonStr,"roles.org") + '>机构授权</a>';
								</sec:authorize>

								html += '<sec:authorize url="/userRoles/resource/initial"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "roles:resource:list", row.id,row.name,row.catalogName) + '">视图授权</a></sec:authorize>';

                                html += '<sec:authorize url="/userRoles/resource/initial"><a class="label_a" style="margin-left:10px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "roles:resource:bbconfig", row.id) + '">资源报表配置</a></sec:authorize>';


								<sec:authorize url="/userRoles/update">
									html += '<a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "roles:infoDialog:open", row.id, 'modify', appId) + '"></a>';
								</sec:authorize>
								<sec:authorize url="/userRoles/delete">
									html+= '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "roles:info:delete", row.id, 'delete') + '"></a>';
								</sec:authorize>

								return html;
							}}
						],
						//usePager:false,
						rownumbers:false,
						validate: true,
						unSetValidateAttr: false,
						allowHideColumn: false,
						onDblClickRow : function (data, rowindex, rowobj) {
							$.publish('roles:infoDialog:open',[data.id,'view']);
						}
					}));
                    this.rolesGrid.adjustToWidth();
					this.bindEvents();
				},
				reloadRolesGrid:function(){
					var rolesName = $("#inp_searchNm").val();
					var values = {
						appId: appId,
						searchNm:rolesName,
					};
					reloadRolesGrid.call(this,values);
                    $("#div_std_app_grid .l-bar-message").css({"left":"56%"}).html("共"+appMaster.appGrid.data.totalCount+"条");
				},
				//获取当前页面检索条件及页面分页信息,并保存到session中
				savePageParamsToSession: function(){
					alert(retrieve);
					alert(retrieve.$element);
					alert(retrieve.$element.Fields);
					var values = retrieve.$element.Fields.getValues();
					values.page = parseInt($('.pcontrol input', master.grid.toolbar).val());
					values.pageSize = $(".l-bar-selectpagesize select", master.grid.toolbar).val();
					sessionStorage.setItem("appPageParams",JSON.stringify(values));
				},
				bindEvents:function(){
					//查询列表
//					$('#btn_roles_search').click(function () {
//						rolesMaster.reloadRolesGrid();
//					});
					//新增、修改、查看角色组
					$('#div_new_record').click(function () {
						$.publish("roles:infoDialog:open",['','new',appId]);
					});

					//批量新增角色组
					$('#div_new_batchAddRoles').click(function () {
						$.publish("roles:div_new_batchAddRoles:open",[appId]);
					});

					$.subscribe("roles:infoDialog:open",function(events,id,mode,appId){
						isFirstPage = false;
						var title = '';
						var wait = parent._LIGERDIALOG.waitting("正在加载...");
						if(mode == 'modify'){
							title = '修改角色组';
						}else if(mode == 'new'){
							title = '新增角色组'
						}else{
							title = '查看角色组';
						};
						if(!appId){
							appId = '';
						}
						rolesMaster.rolesInfoDialog = parent._LIGERDIALOG.open({
							height: 400,
							width: 500,
							title: title,
							show:false,
							urlParms:{
								id:id,
								mode:mode,
								appId:appId
							},
							url: '${contextRoot}/userRoles/rolesInfoInitial',
							isHidden: false,
							load: true,
							onLoaded:function() {
							    wait.close(),
							    rolesMaster.rolesInfoDialog.show()
							}
						})
						rolesMaster.rolesInfoDialog.hide();
					});

					$.subscribe("roles:div_new_batchAddRoles:open",function(events,appId){
						if(!appId){
							appId = '';
						}
						rolesMaster.rolesBatchAddDialog = parent._LIGERDIALOG.open({
							height: 400,
							width: 500,
							title: '批量添加角色组',
							show:false,
							urlParms:{
								appId:appId
							},
							url: '${contextRoot}/userRoles/rolesBatchAddInitial',
							isHidden: false,
							load: true,
							onLoaded:function() {
								rolesMaster.rolesBatchAddDialog.show()
							}
						})
						rolesMaster.rolesBatchAddDialog.hide();
					});


                    $.subscribe("roles:resource:bbconfig",function(events,id){
                        var title = '资源报表配置';
                        var wait = parent._LIGERDIALOG.waitting("正在加载...");
                        rolesMaster.bbConfigDialog = parent._LIGERDIALOG.open({
                            height: 540,
                            width: 600,
                            title: title,
                            show:false,
                            urlParms:{
                                id:id
                            },
                            url: '${contextRoot}/userRoles/rfConfig',
                            isHidden: false,
                            load: true,
                            onLoaded:function() {
                                wait.close(),
                                rolesMaster.bbConfigDialog.show()
                            }
                        })
                        rolesMaster.bbConfigDialog.hide();
                    });


					//删除角色组（删除判断）
					$.subscribe("roles:info:delete",function(event,id){
						parent._LIGERDIALOG.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
							if(yes){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote("${contextRoot}/userRoles/delete",{
									data:{id:id},
									async:true,
									success: function(data) {
										if(data.successFlg){
											parent._LIGERDIALOG.success('删除成功。');
											isFirstPage = false;
											rolesMaster.reloadRolesGrid();
										}else{
											parent._LIGERDIALOG.error(data.errorMsg);
										}
									}
								});
							}
						});
					});


					//机构授权弹出页面
					$.subscribe("roles:orgConfig:open",function(events,obj,type){
						var model = JSON.parse(obj)
						var title = '角色管理>机构数据授权';
						rolesMaster.roleRelationDialog = parent._LIGERDIALOG.open({
							height: 600,
							width: 800,
							title: title,
							urlParms:{
								obj:obj,
								dialogType:type,
							},
							url: '${contextRoot}/userRoles/orgDialog',
							isHidden: false,
							load: true
						})
					});


					//人员、权限配置弹出页面
					$.subscribe("roles:config:open",function(events,obj,type){
						var model = JSON.parse(obj)
						var title = Util.isStrEquals(type,'users')?'角色管理>'+model.name+'人员配置':'角色管理>'+model.name+'权限配置';
						rolesMaster.roleRelationDialog = parent._LIGERDIALOG.open({
							height: 600,
							width: 800,
							title: title,
							urlParms:{
								obj:obj,
								dialogType:type,
							},
							url: '${contextRoot}/userRoles/configDialog',
							isHidden: false,
							load: true
						})
					});
					//资源授权页面跳转
					$.subscribe('roles:resource:list', function (event, rolesId,name,code) {
						var data = {
							'rolesId':rolesId,
							'rolesName':name,
							'code':code,
							'categoryIds':'',
							'sourceFilter':'',
                            'appId':appId
						}
						var url = '${contextRoot}/userRoles/resource/initial?';
                        appendNav('视图授权', url, {backParams:JSON.stringify(data)});
					});

                    $(document).on('click', '.go-back', function () {
                        win.location.reload();
                    });
					<%--$.subscribe("roles:users:open",function(events,id,rolesName){--%>
						<%--rolesMaster.rolesInfoDialog = parent._LIGERDIALOG.open({--%>
							<%--height: 600,--%>
							<%--width: 800,--%>
							<%--title: '角色管理>'+rolesName+'人员配置',--%>
							<%--urlParms:{--%>
								<%--id:id,--%>
							<%--},--%>
							<%--url: '${contextRoot}/userRoles/rolesUsersInitial',--%>
							<%--isHidden: false,--%>
							<%--load: true,--%>
						<%--})--%>
					<%--});--%>


					<%--//权限配置弹出页面--%>

					<%--$.subscribe("roles:limits:open",function(events,id,rolesName){--%>
						<%--rolesMaster.rolesInfoDialog = parent._LIGERDIALOG.open({--%>
							<%--height: 600,--%>
							<%--width: 800,--%>
							<%--title: '角色管理>'+rolesName+'权限配置',--%>
							<%--urlParms:{--%>
								<%--id:id,--%>
							<%--},--%>
							<%--url: '${contextRoot}/userRoles/rolesUsersInitial',--%>
							<%--isHidden: false,--%>
							<%--load: true,--%>
						<%--})--%>
					<%--});--%>
				}
			};
			/* ******************Dialog页面回调接口****************************** */
            win.parent.reloadRolesGrid = win.reloadRolesGrid = function () {
				//角色组列表刷新
				rolesMaster.reloadRolesGrid();
			};
			win.parent.closeRolesInfoDialog = function () {
				//角色组新增、修改会话框关闭
				rolesMaster.rolesInfoDialog.close();
			};
			win.parent.rolesBatchAddDialog = function () {
				//角色组新增
				rolesMaster.rolesBatchAddDialog.close();
			};
            win.parent.closeBBConfigDialogDialog = function () {
                //关闭资源报表配置会话框
                rolesMaster.bbConfigDialog.close();
            };
			win.parent.closeRoleRelationDialog = function () {
				//角色组人员配置、权限配置会话框关闭
				rolesMaster.roleRelationDialog
			};
			/* *************************** 页面功能 **************************** */
			pageInit();
		});
	})(jQuery, window);
</script>
