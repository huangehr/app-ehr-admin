<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
	(function ($, win) {
		$(function () {

			var Util = $.Util;
			var master = null;
			var gridType = ['configAppInsertGrid', 'appInsertGrid'];
			var obj = ${obj};
			<%--var gridUrl = ['${contextRoot}/resourceBrowse/searchResource', '${contextRoot}/resourceBrowse/searchResource'];--%>

			var dataModel = $.DataModel.init();

			function pageInit() {
				master.init();
			}

			function reloadGrid(url, value) {
				gridType[1].setOptions({parms: value});
				gridType[1].loadData(true);
			}

			master = {
				$appInsertSearch: $("#inp_appInsert_search"),
				$appInsertGrid: $("#div_appInsert_grid"),
				$configAppInsertGrid: $("#div_config_appInsert_grid"),

				init: function () {
					var self = this;
					self.$appInsertSearch.ligerTextBox({
						width: 240, isSearch: true, search: function () {
							self.reloadAppInsetrGrid(self.$appInsertSearch.val());
						}
					});
					var ele = [self.$configAppInsertGrid,self.$appInsertGrid];
					for (var i = 0; i < gridType.length; i++) {
						var checkboxBo = Util.isStrEquals(i,1)?true:false;
						gridType[i] = ele[i].ligerGrid($.LigerGridEx.config({
							url: '${contextRoot}/appRole/searchAppInsert',
							parms: {searchNm: ''},
							width:$(".f-mw50").width(),
							height:400,
							isScroll: true,
							checkbox:checkboxBo,
							async: true,
							columns: [{display: '应用名称', name: 'name', width: '100%'}],
							onCheckRow: function (checked,data,rowid,rowdata) {
								dataModel.updateRemote("${contextRoot}/appRole/updateAppInsert", {
									data: {appInsertId: data.id,updateType:checked},
									success: function (data) {

									}
								});
							}
						}));
					}
					self.clicks();
				},
				reloadAppInsetrGrid: function (value) {
					reloadGrid.call(this, '${contextRoot}/appRole/searchAppInsert', value);
				},
				clicks: function () {
					//修改用户信息
					var self = this;
				}

			};

			pageInit();
		})
	})(jQuery, window)
</script>