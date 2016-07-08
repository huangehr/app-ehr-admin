<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
	(function ($, win) {
		$(function () {
			/* ************************** 全局变量定义 **************************** */
			var Util = $.Util;
			var retrieve = null;
			var masters = null;
			var appMaster = null;
			var rolesMaster = null;
			var isSaveSelectStatus = false;
			var stdAppId = '';
			var isFirstPage = true;
			/* *************************** 函数定义 ******************************* */
			function pageInit() {
				resizeContent();
				retrieve.init();
				appMaster.init();
				rolesMaster.init();
			}
			function resizeContent() {
				var contentW = $('#grid_content').width();
				var leftW = $('#div_left').width();
				var rightW = contentW-leftW - 20;
				$('#div_right').width(rightW);
			}
			function reloadRolesGrid(params) {
				rolesMaster.rolesGrid.setOptions({parms: params});
				rolesMaster.rolesGrid.loadData(true);
			}
			/* *************************** 标准字典模块初始化 ***************************** */
			retrieve = {
				$search:$('#inp_search'),
				$searchNm:$('#inp_searchNm'),
				init: function () {
					this.$search.ligerTextBox({width:180});
					this.$searchNm.ligerTextBox({width:240})
				}
			};
			appMaster = {
				appGrid : null,
				init : function (){
					var appName = $("#inp_search").val();
					this.appGrid = $("#div_std_app_grid").ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/dict/searchSysDicts',
						parms: {
							//stdAppName:appName,
							searchNm: appName,
							searchType: appName,
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
//						onAfterShowData:function(data){
//							if(!Util.isStrEmpty(stdAppId)){
//								appMaster.appGrid.select(0)
//							}
//						},
						onSuccess: function(data){
							if(data.detailModelList.length >0){
								stdAppId = data.detailModelList[0].id;
							}else{
								stdAppId = '-1';
							}
							rolesMaster.reloadRolesGrid();
						},
						onSelectRow: function (row) {
							stdAppId = row.id;
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
						url: '${contextRoot}/dict/searchDictEntryList',
						parms: {
							//stdAppId:'',
							dictId: stdAppId
						},
						columns: [
							{display: 'id', name: 'id', hide: true},
							{display: '角色组编码', name: 'code', width: '20%', isAllowHide: false, align: 'center'},
							{display: '角色组名称', name: 'value', width: '20%', isAllowHide: false, align: 'center'},
							{display: '描述', name: 'name', width: '30%', isAllowHide: false, align: 'center'},
							{
								display: '操作', name: 'operator', width: '30%', render: function (row) {
								var html = '<a class="label_a" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "roles:users:open", row.id, row.value) + '">人员配置</a>';
								html += '<a class="label_a" style="margin-left:15px" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "roles:limits:open", row.id, row.value) + '">权限配置</a>';
								html += '<a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "roles:infoDialog:open", row.id, 'modify') + '"></a>';
								html+= '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "roles:info:delete", row.id, 'delete') + '"></a>';
								return html;
							}}
						],
						//usePager:false,
						rownumbers:false,
						validate: true,
						unSetValidateAttr: false,
						allowHideColumn: false,
						onDblClickRow : function (data, rowindex, rowobj) {
							$.publish('roles:infoDialog:open',[data.dictId,'view']);
						}
					}));
					this.bindEvents();
				},
				reloadRolesGrid:function(){
					var rolesName = $("#inp_searchNm").val();
					var values = {
						dictId: stdAppId,
						//stdAppId:'',
						//rolesName:rolesName,
					};
					reloadRolesGrid.call(this,values);
				},
				bindEvents:function(){
					//查询列表
					$('#btn_roles_search').click(function () {
						rolesMaster.reloadRolesGrid();
					});
					//新增、该、查看角色组
					$('#div_new_record').click(function () {
						$.publish("roles:infoDialog:open",['','new']);
					});
					$.subscribe("roles:infoDialog:open",function(events,id,mode){
						var title = '';
						if(mode == 'modify'){
							title = '修改角色组';
						}else if(mode == 'new'){
							title = '新增角色组'
						}else{
							title = '查看角色组';
						};
						rolesMaster.rolesInfoDialog = $.ligerDialog.open({
							height: 360,
							width: 500,
							title: title,
							urlParms:{
								id:id,
								mode:mode,
							},
							url: '${contextRoot}/userRoles/rolesInfoInitial',
							isHidden: false,
							load: true,
						})
					});
					//删除角色组（删除判断）
					$.subscribe("roles:info:delete",function(event,id){
						$.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。',function(yes){
							if(yes){
								var dataModel = $.DataModel.init();
								dataModel.updateRemote("${contextRoot}/resource/resourceInterface/delete",{
									data:{id:id},
									async:true,
									success: function(data) {
										if(data.successFlg){
											$.Notice.success('删除成功。');
											isFirstPage = false;
											rolesMaster.reloadRolesGrid();
										}else{
											$.Notice.error('删除失败。');
										}
									}
								});
							}
						});
					});
					//人员配置弹出页面
					$.subscribe("roles:users:open",function(events,id,rolesName){
						rolesMaster.rolesInfoDialog = $.ligerDialog.open({
							height: 600,
							width: 800,
							title: '角色管理>'+rolesName+'人员配置',
							urlParms:{
								id:id,
							},
							url: '${contextRoot}/userRoles/rolesUsersInitial',
							isHidden: false,
							load: true,
						})
					});


					//权限配置弹出页面

					$.subscribe("roles:limits:open",function(events,id,rolesName){
						rolesMaster.rolesInfoDialog = $.ligerDialog.open({
							height: 600,
							width: 800,
							title: '角色管理>'+rolesName+'权限配置',
							urlParms:{
								id:id,
							},
							url: '${contextRoot}/userRoles/rolesUsersInitial',
							isHidden: false,
							load: true,
						})
					});
				}
			};
			/* ******************Dialog页面回调接口****************************** */
			win.reloadRolesGrid = function () {
				//角色组列表刷新
				rolesMaster.reloadRolesGrid();
			};
			win.closeRolesInfoDialog = function () {
				//角色组新增、修改会话框关闭
				rolesMaster.rolesInfoDialog.close();
			};
			win.closeRolesInfoDialog = function () {
				//角色组人员配置会话框关闭

			};
			win.closeRolesInfoDialog = function () {
				//角色组权限配置会话框关闭
			};
			/* *************************** 页面功能 **************************** */
			pageInit();
		});
	})(jQuery, window);
</script>
