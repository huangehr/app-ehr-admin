<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2016/5/24
  Time: 9:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script type="text/javascript">
	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var dataInfo = null;
		//应用id
		var appId = '';
		//用户id
		var userId = '${userId}';
		//用户所属角色组ids
		var userRolesIds = ${envelop}.obj;
		//选择应用所属角色组
		var appRolesIds = '';
		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			dataInfo.init();
		}
		/* *************************** 模块初始化 ***************************** */
		dataInfo = {
			appRolesGrid:null,
			appFeatureTree:null,
			init: function () {
				$('#div_feature_bottom').mCustomScrollbar({
					axis:"y"
				});
				this.appRolesGrid = $("#div_app_roles_grid").ligerGrid($.LigerGridEx.config({
					url: '${contextRoot}/user/appRoles',
					columns: [
						{name: 'appId', hide: true, isAllowHide: false},
						{name: 'roleId', hide: true, isAllowHide: false},
						{display: '应用名称', name: 'appName', width: '30%',align:'center'},
						{display: '应用角色组', name: 'roleName', width: '70%',align:'center'},
					],
					height:300,
					usePager:false,
					enabledEdit: true,
					validate: true,
					unSetValidateAttr: false,
					onAfterShowData:function(data){
						dataInfo.appRolesGrid.select(0)
					},
					onSelectRow: function (row) {
						appId = row.appId;
						appRolesIds = row.roleId
						dataInfo.appFeatureTree.options.parms = {'roleIds': appRolesIds};
						dataInfo.appFeatureTree.reload();
					},
				}));
				this.appFeatureTree = $("#div_user_features_grid").ligerSearchTree({
					url: '${contextRoot}/user/userAppFeatures',
					parms:{roleIds: ''},
					idFieldName: 'id',
					parentIDFieldName: 'parentId',
					textFieldName: 'name',
					isExpand: false,
					async: false,
					checkbox:false,
					onSuccess: function (data) {
						$("#div_user_features_grid li div span ,#div_api_featrue_grid li div span").css({
							"line-height": "22px",
							"height": "22px"
						});
					}
				});
				this.appRolesGrid.adjustToWidth();
			},
		};

		/* *************************** 页面初始化 **************************** */
		pageInit();

	})(jQuery, window);
</script>