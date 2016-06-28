<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var recordInfo = null;
            var dialog = frameElement.dialog;
            var claimModel = ${claimModel};
            // 表单校验工具类
            var jValidation = $.jValidation;
            var dataModel = $.DataModel.init();
            // 页面表格条件部模块

            function pageInit() {
                recordInfo.init();
            }
            recordInfo = {
                $unrelevanceForm: $("#div_unrelevance_form"),
                $unrelevanceeElse: $('input[name="unrelevanceeElse"]', this.$unrelevanceForm),
                $unrelevanceSaveBtn: $("#div_unrelevance_save_btn"),
                $unrelevanceCancelBtn: $("#div_unrelevance_cancel_btn"),
                $tetElse: $(".tet-else").parent(),

                init: function () {
                    var self = this;
                    self.$unrelevanceeElse.ligerRadio();
                    self.clicks();
                },

                clicks: function () {
                    var self = this;
                    self.$unrelevanceeElse.click(function () {
                        Util.isStrEmpty(this.id)?(self.$tetElse.addClass('m-form-readonly'),$(".tet-else").val('')):self.$tetElse.removeClass('m-form-readonly');
                    });
                    var validator = new jValidation.Validation(self.$unrelevanceForm, {
                        immediate: true, onSubmit: false,
                        onElementValidateForAjax: function (elm) {
                            return Util.isStrEmpty($(elm).val())?false:true;
                        }
                    });

                    self.$unrelevanceSaveBtn.click(function () {
                        debugger
                        if (validator.validate()){
                            return;
                        }
//                        $("#inp_else").val($(".tet-else").val());
                        self.$unrelevanceForm.attrScan();
                        var data = self.$unrelevanceForm.Fields.getValues();
                        var savedialog = $.ligerDialog.waitting('正在保存,请稍候...');
                        claimModel.auditReason = data.unrelevanceeElse;
                        dataModel.updateRemote("${contextRoot}/audit/updateClaim", {
                            data: {jsonModel:JSON.stringify(claimModel)},
                            success: function (data) {
                                savedialog.close();
                                if (data.successFlg) {
                                    win.parent.closeAuditDialog("保存成功");
                                } else {
                                    win.parent.closeAuditDialog("保存失败");
                                }
                            }
                        })
                    });
                    self.$unrelevanceCancelBtn.on("click", function () {
                        dialog.close();
                    });
                }
            };
            pageInit();
        });
    })(jQuery, window);
</script>