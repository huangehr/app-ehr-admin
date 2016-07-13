<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            // 表单校验工具类
            var jValidation = $.jValidation;
            var dataModel = $.DataModel.init();
            var Dialogtype = '${Dialogtype}';
            var appRoleGroupModel = Util.isStrEquals(Dialogtype,'addAppRoleGroup')?'${appRoleGroupModel}':${appRoleGroupModel};

            function pageInit() {
                master.init();
            }
            master = {
                $appRoleGroupId: $("#inp_appRole_groupId"),
                $appRoleGroupName: $("#inp_appRole_groupName"),
                $appRoleExplain: $("#inp_appRole_explain"),
                $appRoleGroupForm: $("#div_appRole_group_form"),
                $addRoleGroupBtn: $("#div_add_roleGroup_btn"),
                $cancelRoleGroupBtn: $("#div_cancel_roleGroup_btn"),
                $roleGroupBtn: $(".div-roleGroup-btn"),

                init: function () {
                    var self = this;
                    self.$appRoleGroupForm.attrScan();
                    self.$appRoleGroupId.ligerTextBox({width: 240});
                    self.$appRoleGroupName.ligerTextBox({width: 240});
                    self.$appRoleExplain.ligerTextBox({width: 240,height:130});
                    Util.isStrEquals(Dialogtype,'sel')?($(".div-appRole-btn").hide(),$(".m-form-group").addClass('m-form-readonly')):"";

                    if (!Util.isStrEquals(Dialogtype, 'addAppRoleGroup')) {
                        self.$appRoleGroupForm.Fields.fillValues({
                            id:appRoleGroupModel.obj.id,
                            appId:appRoleGroupModel.obj.appId,
                            code: appRoleGroupModel.obj.code,
                            name: appRoleGroupModel.obj.name,
                            description: appRoleGroupModel.obj.description
                        });
                    }
                    self.clicks();
                },
                clicks: function () {
                    //修改用户信息
                    var self = this;
                    var validator = new jValidation.Validation(this.$appRoleGroupForm, {
                        immediate: true, onSubmit: false,
                        onElementValidateForAjax: function (elm) {
                        }
                    });
                    self.$roleGroupBtn.click(function () {
                        if (Util.isStrEquals(this.id, 'div_cancel_roleGroup_btn'))
                            return win.parent.closeAppRoleGroupInfoDialog();
                        var appGroupModel = self.$appRoleGroupForm.Fields.getValues();
                        var saveType = Util.isStrEquals(appGroupModel.id,'')?('add',appGroupModel.appId = appRoleGroupModel):'update';
                        dataModel.updateRemote("${contextRoot}/appRole/saveAppRoleGroup", {
                            data: {appRoleGroupModel: JSON.stringify(appGroupModel),saveType:'add'},
                            success: function (data) {
                                var dialogMsg = Util.isStrEquals(appGroupModel.id,'')?"新增":"修改";
                                if (data.successFlg) {
                                    win.parent.closeAppRoleGroupInfoDialog();
                                    $.Notice.success(dialogMsg+'成功');
                                } else {
                                    $.Notice.error(dialogMsg+'失败');
                                }
                            }
                        })
                    })
                }

            };

            pageInit();
        })
    })(jQuery, window)
</script>