<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            var userGrid = null;
            var configUserGrid = null;
            var configModel = null;
            var obj = ${obj};

            var dataModel = $.DataModel.init();

            function pageInit() {
                master.configInit();
            }

            function reloadGrid(url, value, type) {
                var grid = Util.isStrEquals(type, 'user') ? userGrid : configUserGrid;
                grid.setOptions({parms: {searchNm: value}});
                grid.loadData(true);
            }

            master = {
                $userSearch: $("#inp_user_search"),
                $userGrid: $("#div_user_grid"),
                $configUserGrid: $("#div_config_user_grid"),
                configInit: function () {
                    var self = this;
                    self.$userSearch.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            self.reloadUserGrid(self.$userSearch.val(), 'userRoles/searchUsers', 'user');
                        }
                    });
                    configUserGrid = self.$configUserGrid.ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/userRoles/roleUserList',
                        parms: {searchNm: obj.id},
                        width: $(".f-mw50").width(),
                        height: 450,
                        isScroll: true,
                        async: false,
                        columns: [{display: '姓s名', name: 'userName', width: '100%'}],
                        onAfterShowData: function (data) {
                            configModel = data.detailModelList;
                        }
                    }));

                    userGrid = self.$userGrid.ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/userRoles/searchUsers',
                        parms: {searchNm: ''},
                        width: $(".f-mw50").width(),
                        height: 450,
                        isScroll: true,
                        async: false,
                        checkbox: true,
                        columns: [{display: '姓名', name: 'realName', width: '100%'}],
                        onCheckRow: function (checked, data, rowid, rowdata) {
                            var url = checked ? 'userCreate' : 'userDelete';
                            dataModel.updateRemote("${contextRoot}/userRoles/" + url, {
                                data: {userId: data.id, roleId: obj.id},
                                success: function (data) {
                                    self.reloadUserGrid(obj.id, 'userRoles/roleUserList', 'configUser');
                                    self.changeTotalCount();
                                }
                            });
                        },
                        isChecked: function (row) {
                            var bo = false;
                            var configModel = Util.isStrEmpty(configUserGrid.data.detailModelList)?configModel:configUserGrid.data.detailModelList;
                            if (Util.isStrEmpty(configModel))return;
                            for (var i = 0; i < configModel.length; i++) {
                                if (Util.isStrEquals(row.id, configModel[i].userId)) {
                                    bo = true
                                }
                            }
                            return bo;
                        }
                    }));
                    self.$userGrid.find('.l-grid-hd-cell-checkbox').removeClass('l-grid-hd-cell-checkbox');
                    self.changeTotalCount();
                    self.clicks();
                },
                changeTotalCount:function () {
                    debugger
                    $("#div_user_grid .l-bar-message").css({"left":"56%"}).html("共"+userGrid.data.totalCount+"条");
                    $("#div_config_user_grid .l-bar-message").css({"left":"56%"}).html("共"+configUserGrid.data.totalCount+"条");
                },
                reloadUserGrid: function (value, url, type) {
                    reloadGrid.call(this, '${contextRoot}/' + url, value, type);
                    master.changeTotalCount();
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