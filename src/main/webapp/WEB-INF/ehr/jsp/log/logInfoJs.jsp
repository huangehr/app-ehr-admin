<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/8/16
  Time: 19:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win, u) {
        $(function () {
            var obg = ${logData};
            var Log = {
                $appKey: $('#appKey'),
                $function: $('#function'),
                $operation: $('#operation'),
                $patient: $('#patient'),
                $time: $('#time'),
                $responseTime: $('#responseTime'),
                $responseCode: $('#responseCode'),
                $response: $('#response'),
                $form: $('#div_rs_info_form'),
                init: function () {
                    this.initForm();
                },
                initForm: function () {
                    this.$appKey.ligerTextBox();
                    this.$function.ligerTextBox();
                    this.$operation.ligerTextBox();
                    this.$patient.ligerTextBox();
                    this.$time.ligerTextBox();
                    this.$responseTime.ligerTextBox();
                    this.$responseCode.ligerTextBox();
                    this.$response.ligerTextBox({
                        height: '100',
                        digits: false
                    });
                    this.$form.attrScan();
                    debugger
                    if (obg) {
                        if (obg.successFlg) {
                            var d = obg.detailModelList[0];
                            debugger
                            this.$form.Fields.fillValues({
                                appKey: d.appKey,
                                function:d.function,
                                operation:d.operation,
                                patient:d.patient,
                                time:d.time,
                                responseTime:d.responseTime,
                                responseCode:d.responseCode,
                                response: d.response,
                            });
                            this.$form.show();
                        }
                    }
                }
            }
            Log.init();
        });
    })(jQuery, window)
</script>
