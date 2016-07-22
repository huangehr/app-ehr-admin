<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            var obj = ${jsonStr};
            var gridType = ['configAppInsertGrid', 'appInsertGrid'];
            var dataModel = $.DataModel.init();
            var configAppInsertGrid = null;

            function pageInit() {
                master.init();
            }

            function reloadGrid(url, value, grid, type) {
                if (Util.isStrEquals(type,'appInsertGrid')){
                    grid.options.newPage = 1;
                }
                grid.setOptions({parms: value});
                grid.loadData(true);
            }

            master = {
                $appInsertSearch: $("#inp_appInsert_search"),
                $appInsertGrid: $("#div_appInsert_grid"),
                $configAppInsertGrid: $("#div_config_appInsert_grid"),

                init: function () {
                    var self = this;
                    self.$appInsertSearch.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            self.reloadAppInsetrGrid(self.$appInsertSearch.val(), gridType[1], 'appInsertGrid');
                        }
                    });
                    var ele = [self.$configAppInsertGrid, self.$appInsertGrid];
                    for (var i = 0; i < gridType.length; i++) {
                        var name = null;
                        var checkboxBo = null;
                        if (Util.isStrEquals(i, 1)) {
                            name = "name";
                            checkboxBo = true;
                        } else {
                            checkboxBo = false;
                            name = "appName";
                        }
                        gridType[i] = ele[i].ligerGrid($.LigerGridEx.config({
                            url: '${contextRoot}/appRole/searchInsertApps',
                            parms: {searchNm: '', gridType: gridType[i], appRoleId: obj.id},
                            width: $(".f-mw50").width(),
                            height: 450,
                            isScroll: true,
                            checkbox: checkboxBo,
                            async: false,
                            columns: [{display: '应用名称', name: name, width: '100%'}],
                            onCheckRow: function (checked, data, rowid, rowdata) {
                                configAppInsertGrid = null;
                                dataModel.updateRemote("${contextRoot}/appRole/updateAppInsert", {
                                    data: {appInsertId: data.id, appRoleId: obj.id, updateType: checked},
                                    success: function (data) {
                                        if (data.successFlg) {
                                            self.reloadAppInsetrGrid('', gridType[0], 'configAppInsertGrid');
                                        }
                                    }
                                });
                            },
                            isChecked: function (row) {
                                var bo = false;
                                if (Util.isStrEquals(i, 1)) {
                                    return;
                                }
                                if (Util.isStrEmpty(configAppInsertGrid)) {
                                    dataModel.updateRemote("${contextRoot}/appRole/searchInsertApps", {
                                        data: {searchNm: '', gridType: "configAppInsertGrid", appRoleId: obj.id, page: 1, rows: Util.isStrEquals(gridType[0].data.totalCount,0)?15:gridType[0].data.totalCount},
                                        async: false,
                                        success: function (data) {
                                            configAppInsertGrid = data.detailModelList;
                                        }
                                    });
                                }
//                                var configAppInsertGrid = gridType[0].data.detailModelList;
                                if (Util.isStrEmpty(configAppInsertGrid)){
                                    return false;
                                }
                                for (var i = 0; i < configAppInsertGrid.length; i++) {
                                    if (Util.isStrEquals(row.id, configAppInsertGrid[i].appId)) {
                                        bo = true
                                    }
                                }
                                return bo;
                            }
                        }));
                    }
                    $("#div_appInsert_grid .l-bar-message").css({"left":"56%"}).html("共"+gridType[1].data.totalCount+"条");
                    $("#div_config_appInsert_grid .l-bar-message").css({"left":"56%"}).html("共"+gridType[0].data.totalCount+"条");
                    self.$appInsertGrid.find('.l-grid-hd-cell-checkbox').removeClass('l-grid-hd-cell-checkbox');
                    self.clicks();
                },
                reloadAppInsetrGrid: function (value, grid, type) {
                    value = {searchNm: value, gridType: type, appRoleId: obj.id};
                    reloadGrid.call(this, '${contextRoot}/appRole/searchInsertApps', value, grid, type);
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