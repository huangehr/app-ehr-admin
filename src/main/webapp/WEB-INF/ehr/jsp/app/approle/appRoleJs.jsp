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
                $appBrowseMsg: $("#div_app_browse_msg"),

                init: function () {
                    var self = this;
                    self.$appBrowseMsg.width($(window).width()-630);
                    self.$appRoleComSearch.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
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
                        async: false,
                        columns: [{display: '应用名称', name: 'name', width: '100%'}],
                        onSelectRow: function (data) {
                            self.reloadAppRoleGrid("appRoleGroup", appRoleId = data.id, "");
                        },
                        onAfterShowData: function (data) {
                            appRoleGrid.select(0);
                        }
                    }));

                    appRoleGroupGrid = self.$appRoleGroupGrid.ligerGrid($.LigerGridEx.config({
                        url: url+'searchAppRole',
                        parms: {searchNm: '', gridType: 'appRoleGroup', appRoleId: appRoleId},
                        isScroll: true,
                        columns: [
                            {display: '角色组编码', name: 'code', width: '20%'},
                            {display: '角色组名称', name: 'name', width: '20%'},
                            {display: '描述', name: 'description', width: '25%'},
                            {
                                display: '操作', name: 'operator', width: '35%', render: function (row) {
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

                    appRoleGroupGrid.adjustToWidth();
                    self.clicks();
                },
                reloadAppRoleGrid: function (type, appRoleId, searchParams) {
                    if (Util.isStrEquals(type, "appRole")){
                        searchParams = {searchNm:searchParams,gridType:type};
                    }else{
                        searchParams = {searchNm: searchParams, gridType: type, appRoleId: appRoleId}
                    }
                    reloadGrid.call(this, url+'searchAppRole', type, appRoleId, searchParams);
                    $("#div_appRole_grid .l-bar-message").css({"left":"56%"}).html("共"+appRoleGrid.data.totalCount+"条");
                },
                clicks: function () {
                    var self = this;

                    self.$addAppRoleGroupBtn.click(function () {
                        $.publish('app:roles', [appRoleId, 'addAppRoleGroup'])
                    });
                    $.subscribe('app:roles', function (event, jsonStr, type) {
                        switch (type) {
                            case 'featrueConfig':
                                var model = JSON.parse(jsonStr);
                                self.ligerDialogOpen(jsonStr, type, '应用角色>'+model.name+"权限配置", 600, 800);
                                break;
                            case 'appInsert':
                                var model = JSON.parse(jsonStr);
                                self.ligerDialogOpen(jsonStr, type, '应用角色>'+model.name+"应用接入", 600, 800);
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
                                                    $.Notice.error(data.errorMsg);
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
                master.reloadAppRoleGrid("appRoleGroup", appRoleId, "");
            };
            pageInit();
            $(window).resize(function(){
                master.$appBrowseMsg.width($(window).width()-630);
            });

        })
    })(jQuery, window)
</script>