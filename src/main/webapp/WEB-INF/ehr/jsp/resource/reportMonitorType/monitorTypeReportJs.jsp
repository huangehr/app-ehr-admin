<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
	(function ($, win) {
		$(function () {

			var Util = $.Util;
			var master = null;
			var reportGrid = null;
			var configReportGrid = null;
			var configModel = null;
			var typeId = ${id};
			var isFirstPage = false;
			var dataModel = $.DataModel.init();

			function pageInit() {
				master.configInit();
			}

			function reloadGrid(url, value, type) {
				var grid = Util.isStrEquals(type, 'report') ? reportGrid : configReportGrid;
				if(isFirstPage && Util.isStrEquals(type, 'report')){
					grid.options.newPage = 1
				}
				grid.setOptions({parms: {searchNm: value}});
				grid.loadData(true);
				isFirstPage = false;
			}

			master = {
				$reportSearch: $("#inp_report_search"),
				$reportGrid: $("#div_report_grid"),
				$configReportGrid: $("#div_config_report_grid"),
				configInit: function () {
					var self = this;
					self.$reportSearch.ligerTextBox({
						width: 240, isSearch: true, search: function () {
							isFirstPage = true;
							self.reloadReportGrid(self.$reportSearch.val(), '/resource/monitorTypeReport/search', 'report');
						}
					});
					configReportGrid = self.$configReportGrid.ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/resource/monitorTypeReport/monitorTypeReportList',
						parms: {searchNm: typeId},
						width: $(".f-mw50").width(),
						height: 450,
						isScroll: true,
						async: false,
						columns: [{display: '名称', name: 'reportName', width: '100%'}],
						onAfterShowData: function (data) {
							//获取角色组所有配置的报表
							dataModel.updateRemote("${contextRoot}/resource/monitorTypeReport/monitorTypeReportByMonitorTypeId", {
								data: {monitorTypeId: typeId},
								async: false,
								success: function (data) {
									configModel = data.detailModelList;
								}
							});
						}
					}));

					reportGrid = self.$reportGrid.ligerGrid($.LigerGridEx.config({
						url: '${contextRoot}/resource/monitorTypeReport/search',
						parms: {searchNm: ''},
						width: $(".f-mw50").width(),
						height: 450,
						isScroll: true,
						async: false,
						checkbox: true,
						columns: [{display: '名称', name: 'name', width: '100%'}],
						onCheckRow: function (checked, data, rowid, rowdata) {
							var url = checked ? 'reportCreate' : 'reportDelete';
							dataModel.updateRemote("${contextRoot}/resource/monitorTypeReport/" + url, {
										data: {reportId: data.id, monitorTypeId: typeId},
										success: function (data) {
									self.reloadReportGrid(typeId, '/resource/monitorTypeReport/monitorTypeReportList', 'configReport');
									self.changeTotalCount();
								}
							});
						},
						isChecked: function (row) {
							var bo = false;
							if (Util.isStrEmpty(configModel))return;
							for (var i = 0; i < configModel.length; i++) {
								if (Util.isStrEquals(row.id, configModel[i].reportId)) {
									bo = true
								}
							}
							return bo;
						}
					}));
					self.$reportGrid.find('.l-grid-hd-cell-checkbox').removeClass('l-grid-hd-cell-checkbox');
					self.changeTotalCount();
					self.clicks();
				},
				changeTotalCount:function () {
					$("#div_report_grid .l-bar-message").css({"left":"56%"}).html("共"+reportGrid.data.totalCount+"条");
					$("#div_config_report_grid .l-bar-message").css({"left":"56%"}).html("共"+configReportGrid.data.totalCount+"条");
				},
				reloadReportGrid: function (value, url, type) {
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