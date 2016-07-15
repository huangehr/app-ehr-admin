<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            var appRoleGrid = null;
            var appRoleGroupGrid = null;
            var appRoleId = null;
            var appRoleGroupInfoDialog = null;
            var url = "${contextRoot}/appRole/";
            var dataModel = $.DataModel.init();

            function pageInit() {
                master.init();
            }

            function reloadGrid(url, type, appRoleId, ps) {
                var appGrid = appRoleGroupGrid;
                if (Util.isStrEquals(type, "appRole")) {
                    appGrid = appRoleGrid;
                    appGrid.options.newPage = 1;
                }
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
                        url: url+'searchAppRole',
                        parms: {searchNm: '', gridType: 'appRole'},
                        isScroll: true,
                        async: true,
                        columns: [{display: '应用名称', name: 'name', width: '100%'}],
                        onSelectRow: function (data) {
                            self.reloadAppRoleGrid("appRoleGroup", appRoleId = data.id, "");
                        },
                        onAfterShowData: function (data) {
                            appRoleId = data.detailModelList[0].id;
                        }
                    }));

                    appRoleGroupGrid = self.$appRoleGroupGrid.ligerGrid($.LigerGridEx.config({
                        url: url+'searchAppRole',
                        parms: {searchNm: '', gridType: 'appRoleGroup', appRoleId: appRoleId},
                        isScroll: true,
                        async: true,
                        columns: [
                            {display: '应用组编码', name: 'code', width: '25%'},
                            {display: '应用组明称', name: 'name', width: '25%'},
                            {display: '描述', name: 'description', width: '25%'},
                            {
                                display: '操作', name: 'operator', width: '25%', render: function (row) {
                                var html = '<a class="label_a" title="权限配置" href="javascript:void(0)" onclick=javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:roles", JSON.stringify(row), 'featrueConfig') + '>权限配置</a>&nbsp;&nbsp;';
                                html += '<a class="label_a" title="接入应用" href="javascript:void(0)" onclick=javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:roles", JSON.stringify(row), 'appInsert') + '>应用接入</a>';
                                html += '<a class="grid_edit" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:roles", row.id, 'edit') + '"></a>';
                                html += '<a class="grid_delete" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:roles", row.id, 'delete') + '"></a>';
                                return html;
                            }
                            }
                        ],
                        onDblClickRow : function (row){
                            $.publish('app:roles', [row.id, 'sel']);
                        }
                    }));
                    self.clicks();
                },
                reloadAppRoleGrid: function (type, appRoleId, searchParams) {
                    if (Util.isStrEquals(type, "appRole")){
                        searchParams = {searchNm:searchParams,gridType:type};
                    }else{
                        searchParams = {searchNm: searchParams, gridType: type, appRoleId: appRoleId}
                    }
                    reloadGrid.call(this, url+'searchAppRole', type, appRoleId, searchParams);
                },
                clicks: function () {
                    var self = this;

                    self.$addAppRoleGroupBtn.click(function () {
                        $.publish('app:roles', [appRoleId, 'addAppRoleGroup'])
                    });
                    $.subscribe('app:roles', function (event, jsonStr, type) {
                        switch (type) {
                            case 'featrueConfig':
                                self.ligerDialogOpen(jsonStr, type, "权限配置", 600, 800);
                                break;
                            case 'appInsert':
                                self.ligerDialogOpen(jsonStr, type, "应用接入", 600, 800);
                                break;
                            case 'delete':
                                $.ligerDialog.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
                                    if (yes) {
                                        dataModel.updateRemote(url+"deleteAppRoleGroup", {
                                            data: {appGroupId: jsonStr},
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
                                self.ligerDialogOpen(jsonStr, type, "新增角色组", 400, 500);
                                break;
                            case 'edit':
                                self.ligerDialogOpen(jsonStr, type, "修改角色组", 400, 500);
                                break;
                            default:
                                self.ligerDialogOpen(jsonStr, type, "查看角色组", 400, 500);
                                break;
                        }
                    });
                },
                ligerDialogOpen: function (jsonStr, type, title, width, height) {
                    appRoleGroupInfoDialog = $.ligerDialog.open({
                        title: title,
                        height: width,
                        width: height,
                        url: url+'appRoleDialog',
                        load: true,
                        urlParms: {
                            jsonStr: jsonStr,
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