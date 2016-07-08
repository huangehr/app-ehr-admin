<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            var appRoleGrid = null;
            var appRoleGroupGrid = null;
            var windowHeight = $(window).height();
            var appRoleId = null;
            var appRoleGroupInfoDialog = null;

            var dataModel = $.DataModel.init();

            function pageInit() {
                master.init();
            }

            function reloadGrid(url, type, appRoleId, ps) {
                var appGrid = Util.isStrEquals(type, "appRole") ? appRoleGrid : appRoleGroupGrid;
                appGrid.setOptions({parms: ps});
                appGrid.loadData(true);
            }

            master = {
                $appRoleComSearch: $(".inp_appRole_com_search"),
                $appRoleGrid: $("#div_appRole_grid"),
                $appRoleGroupGrid: $("#div_appRole_group_grid"),
                $appRoleGroupSearch: $("#inp_appRole_group_search"),
                $addAppRoleGroupBtn: $("#div_add_appRoleGroup_btn"),

                init: function () {
                    var self = this;
                    self.$appRoleComSearch.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            var inpEleType = this.find('input').attr('id');
                            var gridType = Util.isStrEquals(inpEleType, 'inp_appRole_search') ? 'appRole' : 'appRoleGroup';
                            appRoleId = Util.isStrEquals(inpEleType, 'inp_appRole_group_search') ? appRoleId : '';
                            self.reloadAppRoleGrid(gridType, appRoleId, this.find('input').val());
                        }
                    });

                    appRoleGrid = self.$appRoleGrid.ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/appRole/searchAppRole',
                        parms: {searchNm: '', gridType: 'appRole'},
                        isScroll: true,
                        async: true,
                        columns: [{display: '应用名称', name: 'realName', width: '100%'}],
                        onSelectRow: function (data) {
                            self.reloadAppRoleGrid("appRoleGroup", appRoleId = data.id, "");
                        },
                        onAfterShowData: function (data) {
                            appRoleId = data.detailModelList[0].id;
                        }
                    }));

                    appRoleGroupGrid = self.$appRoleGroupGrid.ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/appRole/searchAppRole',
                        parms: {searchNm: '', gridType: 'appRoleGroup', appRoleId: appRoleGrid.appRoleid},
                        isScroll: true,
                        columns: [
                            {display: '应用组编码', name: 'realName', width: '25%'},
                            {display: '应用组明称', name: 'loginCode', width: '25%'},
                            {display: '描述', name: 'loginCode', width: '25%'},
                            {
                                display: '操作', name: 'operator', width: '25%', render: function (row) {
                                var html = '<a class="label_a" title="权限配置" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:roles", row.id, 'featrueConfig') + '">权限配置</a>&nbsp;&nbsp;';
                                html += '<a class="label_a" title="接入应用" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:roles", row.id, 'appInsert') + '">应用接入</a>';
                                html += '<a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:roles", row.id, 'edit') + '"></a>';
                                html += '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:roles", row.id, 'delete') + '"></a>';
                                return html;
                            }
                            }
                        ]
                    }));
                    self.clicks();
                },
                reloadAppRoleGrid: function (type, appRoleId, searchParams) {
                    reloadGrid.call(this, '${contextRoot}/app/searchAppData', type, appRoleId, searchParams);
                },
                clicks: function () {
                    //修改用户信息
                    var self = this;
                    self.$addAppRoleGroupBtn.click(function () {
                        $.publish('app:roles',['','addAppRoleGroup'])
                    });

                    $.subscribe('app:roles', function (event, appGroupId, type) {
                        switch (type) {
                            case 'featrueConfig':
                                self.ligerDialogOpen(appGroupId,type,"权限配置");
                                break;
                            case 'appInsert':
                                self.ligerDialogOpen(appGroupId,type,"应用接入");
                                break;
                            case 'delete':
                                $.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
                                    if (yes) {
                                        dataModel.updateRemote("${contextRoot}/appRole/deleteAppRoleGroup", {
                                            data: {appGroupId: appGroupId},
                                            async: true,
                                            success: function (data) {
                                                if (data.successFlg) {
                                                    $.Notice.success('删除成功。');
                                                    master.reloadAppRoleGrid('appRoleGroup', appRoleId, self.$appRoleGroupSearch.val());
                                                } else {
                                                    $.Notice.error('删除失败。');
                                                }
                                            }
                                        });
                                    }
                                });
                                break;
                            case 'addAppRoleGroup':
                                self.ligerDialogOpen(appGroupId,type,"新增角色组");
                                break;
                            default:
                                self.ligerDialogOpen(appGroupId,type,"修改角色组");
                                break;
                        }
                    });
                },
                ligerDialogOpen: function (appRoleGroupId,type,title) {
//                    var self = this;
                    appRoleGroupInfoDialog = $.ligerDialog.open({
                        title: title,
                        height: 400,
                        width: 500,
                        url: '${contextRoot}/appRole/appRoleDialog',
                        load: true,
                        urlParms: {
                            appRoleGroupId: appRoleGroupId,
                            type: type
                        }
                    });
                }
            };

            win.closeAppRoleGroupInfoDialog = function (callback) {
                appRoleGroupInfoDialog.close();
            };

            pageInit();
        })
    })(jQuery, window)
</script>