<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/5/13
  Time: 17:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_result_form" class="m-form-inline f-mt20 f-tac" data-role-form>
	<div class="m-form-control">
		<textarea id="inp_query_result" data-attr-scan="result"></textarea>
	</div>
	<div class="m-form-group f-pa" style="bottom: 0;right: 10px;">
		<div class="m-form-control">
			<div id="btn_cancel" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr100" >
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>
	</div>
</div>

