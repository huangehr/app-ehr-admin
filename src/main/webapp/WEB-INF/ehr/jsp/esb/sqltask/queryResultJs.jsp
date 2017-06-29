<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/5/13
  Time: 17:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
	(function ($, win) {
		function pageInit() {
			queryResult.init();
		}
		queryResult = {
			$form: $("#div_result_form"),
			$cancelBtn: $("#btn_cancel"),

			init: function () {
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				var info = ${envelop}.obj
				this.$form.attrScan();
				this.$form.Fields.fillValues({
					result: info.result,
				});
			},
			bindEvents: function () {
				queryResult.$cancelBtn.click(function(){
					closeResultInfoDialog();
				});
			}
		};
		/* *************************** 页面初始化 **************************** */
		pageInit();
	})(jQuery, window);
</script>
