<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
	(function ($, win) {
		$(function () {

			var Util = $.Util;
			var master = null;
			var orgGrid = null;
			var configOrgGrid = null;
			var configModel = null;
			var obj = ${obj};
			var isFirstPage = false;
			var dataModel = $.DataModel.init();

			function pageInit() {
				master.configInit();
			}

			function reloadGrid(url, value, type) {
				var grid = Util.isStrEquals(type, 'org') ? orgGrid : configOrgGrid;
				if(isFirstPage && Util.isStrEquals(type, 'org')){
					grid.options.newPage = 1
				}
				grid.setOptions({parms: {searchNm: value}});
				grid.loadData(true);
				isFirstPage = false;
			}

			master = {
				$orgSearch: $("#inp_org_search"),
				$orgGrid: $("#div_org_grid"),
				$configOrgGrid: $("#div_config_org_grid"),
				configInit: function () {
					var self = this;
					self.$orgSearch.ligerTextBox({
						width: 240, isSearch: true, search: function () {
							isFirstPage = true;
							self.reloadOrgGrid(self.$orgSearch.val(), 'userRoles/searchOrgs', 'org');
						}
					});
					configOrgGrid = self.$configOrgGrid.ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/userRoles/roleOrgList',
						parms: {searchNm: obj.id},
						width: $(".f-mw50").width(),
						height: 450,
						isScroll: true,
						async: false,
						columns: [{display: '名称', name: 'orgName', width: '100%'}],
						onAfterShowData: function (data) {
							//获取角色组所有配置的机构
							dataModel.updateRemote("${contextRoot}/userRoles/roleOrgByRoleId", {
								data: {roleId: obj.id},
								async: false,
								success: function (data) {
									configModel = data.detailModelList;
								}
							});
						}
					}));

					orgGrid = self.$orgGrid.ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/userRoles/searchOrgs',
						parms: {searchNm: ''},
						width: $(".f-mw50").width(),
						height: 450,
						isScroll: true,
						async: false,
						checkbox: true,
						columns: [{display: '名称', name: 'fullName', width: '100%'}],
						onCheckRow: function (checked, data, rowid, rowdata) {
							var url = checked ? 'orgCreate' : 'orgDelete';
							dataModel.updateRemote("${contextRoot}/userRoles/" + url, {
										data: {orgCode: data.orgCode, roleId: obj.id},
										success: function (data) {
									self.reloadOrgGrid(obj.id, 'userRoles/roleOrgList', 'configOrg');
									self.changeTotalCount();
								}
							});
						},
						isChecked: function (row) {
							var bo = false;
							if (Util.isStrEmpty(configModel))return;
							for (var i = 0; i < configModel.length; i++) {
								if (Util.isStrEquals(row.orgCode, configModel[i].orgCode)) {
									bo = true
								}
							}
							return bo;
						}
					}));
					self.$orgGrid.find('.l-grid-hd-cell-checkbox').removeClass('l-grid-hd-cell-checkbox');
					self.changeTotalCount();
					self.clicks();
				},
				changeTotalCount:function () {
					$("#div_org_grid .l-bar-message").css({"left":"56%"}).html("共"+orgGrid.data.totalCount+"条");
					$("#div_config_org_grid .l-bar-message").css({"left":"56%"}).html("共"+configOrgGrid.data.totalCount+"条");
				},
				reloadOrgGrid: function (value, url, type) {
					reloadGrid.call(this, '${contextRoot}/' + url, value, type);
					master.changeTotalCount();
				},
				clicks: function () {
					//修改信息
					var self = this;
				}

			};

			pageInit();
		})
	})(jQuery, window)
</script>