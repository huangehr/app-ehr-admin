<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var recordInfo = null;
            var recordGrid = null;
            var reloadData = null;
            var unrelevanceDialog = null;
            var claimModel = ${claimModel};
//            delete claimModel.obj['statusName'];
//            delete claimModel.obj['visOrgName'];
//            claimModel.obj.applyDate = new Date(claimModel.obj.applyDate);
//            claimModel.obj.auditDate = new Date(claimModel.obj.auditDate);
//            claimModel.obj.applyDate = '2016-06-22T13:41:11Z+0800';

            var ApplyStrModel = ${ApplyStr};
            var auditHeight = $(".div-audit-msg").height();
            var windowHeight = $(window).height();
            var dataModel = $.DataModel.init();
            // 页面表格条件部模块

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                recordInfo.init();
                recordInfo.recordGridInfo();
            }


            /* *************************** 检索模块初始化 ***************************** */
            recordInfo = {


                $matchingRecordGrid: $("#div_matching_record_grid"),
                $unrelevanceForm: $("#div_unrelevance_form"),
                $unrelevanceeElse: $('input[name="unrelevanceeElse"]', this.$unrelevanceForm),
                $relevanceBtn: $("#div_relevance_btn"),
                $unrelevanceBtn: $("#div_unrelevance_btn"),
                $unrelevanceSaveBtn: $("#div_unrelevance_save_btn"),
                $unrelevanceCancelBtn: $("#div_unrelevance_cancel_btn"),
                $matchingChangeBtn: $(".sp-matching-change-btn"),

                init: function () {
                    var self = this;

                    self.$unrelevanceeElse.ligerRadio();

                    $('.sp-lift-btn').css('background','url()');
                    reloadData.reloadAuditData(claimModel.obj, self.$applyForm);
                    reloadData.reloadAuditData(ApplyStrModel.detailModelList[0], self.$matchingForm);

                },

                recordGridInfo: function () {
                    var self = this;

                    self.clicks();
                },
                clicks: function () {
                    var self = this;
                    var claimId = ApplyStrModel.detailModelList[0].id;

                    self.$unrelevanceSaveBtn.click(function () {
                        $("#inp_else").val($(".tet-else").val());
                        self.$unrelevanceForm.attrScan();
                        var data = self.$unrelevanceForm.Fields.getValues();
                        debugger

                        var dialog = $.ligerDialog.waitting('正在保存,请稍候...');
                        claimModel.obj.auditReason = data.unrelevanceeElse;
                        dataModel.updateRemote("${contextRoot}/audit/updateClaim", {
                            data: {jsonModel:JSON.stringify(claimModel.obj)},
                            async: true,
                            success: function (data) {
                                dialog.close();
                                if (data.successFlg) {
                                    $.Notice.success('保存成功。');
                                } else {
                                    $.Notice.error('保存失败。');
                                }
                            }
                        });
                        unrelevanceDialog.close();
                    });
                    self.$unrelevanceCancelBtn.on("click", function () {
                        unrelevanceDialog.close();
                    });

                }
            };

            /* *************************** 检索模块初始化结束 ***************************** */

            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window);
</script>