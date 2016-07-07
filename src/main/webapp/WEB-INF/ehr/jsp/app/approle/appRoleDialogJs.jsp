<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            // 表单校验工具类
            var jValidation = $.jValidation;
            var appRoleGroupModel = ${appRoleGroupModel};
            appRoleGroupModel = Util.isStrEmpty(appRoleGroupModel.obj)?"addAppRoleGroup":appRoleGroupModel;
            debugger

            function pageInit() {
                master.init();
            }

            master = {
                $appRoleGroupId: $("#inp_appRole_groupId"),
                $appRoleGroupName: $("#inp_appRole_groupName"),
                $appRoleExplain: $("#inp_appRole_explain"),
                $addAppRoleGroupForm: $("#div_add_appRole_group_form"),
                $addRoleGroupBtn: $("#div_add_roleGroup_btn"),
                $cancelRoleGroupBtn: $("#div_cancel_roleGroup_btn"),
                $roleGroupBtn: $(".div-roleGroup-btn"),

                init: function () {
                    var self = this;
                    self.$appRoleGroupId.ligerTextBox({width: 240});
                    self.$appRoleGroupName.ligerTextBox({width: 240});
                    self.$appRoleExplain.ligerTextBox({width: 240});

//                    this.$addAppRoleGroupForm.attrScan();
//                    this.$addAppRoleGroupForm.Fields.fillValues({
//                        id: user.id,
//                        loginCode: user.loginCode,
//                        realName: user.realName,
//                        idCardNo: user.idCardNo
//                    });
                    self.clicks();
                },

                clicks: function () {
                    //修改用户信息
                    var self = this;
                    var validator = new jValidation.Validation(this.$addAppRoleGroupForm, {
                        immediate: true, onSubmit: false,
                        onElementValidateForAjax: function (elm) {
                        }
                    });
                    self.$roleGroupBtn.click(function () {
                        if (Util.isStrEquals(this.id, 'div_cancel_roleGroup_btn'))
                            return win.parent.closeAppRoleGroupInfoDialog();

                        var appRoleGroupModel = self.$addAppRoleGroupForm.Fields.getValues();
                        var dataModel = $.DataModel.init();
                        dataModel.updateRemote("${contextRoot}/appRole/saveAppRoleGroup", {
                            data: {appRoleGroupModel: JSON.stringify(appRoleGroupModel)},
                            success: function (data) {
//                                var dialogMsg = Util.isStrEquals(appRoleGroupModel,'addAppRoleGroup')?"新增成功":"新增失败";
                                if (data.successFlg) {
                                    win.parent.closeAddUserInfoDialog(function () {
                                        win.parent.$.Notice.success('用户新增成功');
                                    });
                                } else {
                                    window.top.$.Notice.error(data.errorMsg);
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