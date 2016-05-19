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

<div id="div_his_info_form" data-role-form class="m-form-inline f-mt20" data-role-form>
	<input type="hidden" id="id" data-attr-scan="id"/>
	<div class="m-form-group">
		<label >机构代码:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_org_code" class="required useTitle f-h28 f-w240" placeholder="请输入机构代码或名称检索" data-type="select"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="orgCode">
		</div>
	</div>
	<div class="m-form-group">
		<label >程序包代码:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_system_code" class="required useTitle f-h28 f-w240 max-length-200"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="systemCode">
		</div>
	</div>
	<div class="m-form-group">
		<label >查询SQL:</label>
		<div class="m-form-control">
			<textarea id="inp_query_sql" class="f-h100 f-w240  validate-special-char" data-attr-scan="sqlscript"></textarea>
		</div>
	</div>
	<div class="m-form-group f-pa" style="bottom: 0;right: 10px;">
		<div class="m-form-control">
			<input type="button" value="<spring:message code="btn.save"/>" id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" />
			<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>
	</div>
</div>

