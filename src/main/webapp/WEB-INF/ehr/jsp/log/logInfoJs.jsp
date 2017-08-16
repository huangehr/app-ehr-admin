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
            var Log = {
                $inpCategory: $('#inp_category'),
                $form: $('#div_rs_info_form'),
                init: function () {
                    this.initForm();
                },
                initForm: function () {
                    this.$inpCategory.ligerTextBox();
                    debugger
                    this.$form.attrScan();
                    this.$form.Fields.fillValues({
                        categoryId: 'asdasd'
                    });
                    this.$form.show();
                }
            }
            Log.init();
        });
    })(jQuery, window)
</script>
