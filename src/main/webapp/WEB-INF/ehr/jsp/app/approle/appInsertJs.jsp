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

            function pageInit() {
                master.init();
            }

            function reloadGrid(url, value,grid,type) {
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
                            self.reloadAppInsetrGrid(self.$appInsertSearch.val(),gridType[1],'appInsertGrid');
                        }
                    });
                    var ele = [self.$configAppInsertGrid,self.$appInsertGrid];
                    for (var i = 0; i < gridType.length; i++) {
                        var checkboxBo = Util.isStrEquals(i,1)?true:false;
                        gridType[i] = ele[i].ligerGrid($.LigerGridEx.config({
                            url: '${contextRoot}/appRole/searchInsertApps',
                            parms: {searchNm: '',gridType:gridType[i],appRoleId:obj.id},
                            width:$(".f-mw50").width(),
                            height:400,
                            isScroll: true,
                            checkbox:checkboxBo,
                            async: true,
                            columns: [{display: '应用名称', name: 'name', width: '100%'}],
                            onCheckRow: function (checked,data,rowid,rowdata) {
                                dataModel.updateRemote("${contextRoot}/appRole/updateAppInsert", {
                                    data: {appInsertId: data.id,appRoleId:obj.id,updateType:checked},
                                    success: function (data) {
                                        if (data.successFlg){
                                            self.reloadAppInsetrGrid('',gridType[0],'configAppInsertGrid');
                                        }
                                    }
                                });
                            }
                        }));
                    }
                    self.clicks();
                },
                reloadAppInsetrGrid: function (value,grid,type) {
                    value = {searchNm:value,gridType:type};
                    reloadGrid.call(this, '${contextRoot}/appRole/searchInsertApps', value,grid,type);
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