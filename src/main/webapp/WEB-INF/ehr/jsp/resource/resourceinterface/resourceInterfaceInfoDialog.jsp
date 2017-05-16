<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2016/5/24
  Time: 9:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div id="div_data_info_form" data-role-form class="m-form-inline f-mt20">
	<input type="hidden" id="id" data-attr-scan="id"/>
	<div class="m-form-group">
		<label>接口名称:</label>
		<div class="m-form-control essential">
			<input type="text" id="inp_name" class="required useTitle ajax f-w350 f-h28 max-length-50"  required-title=<spring:message code="lbl.must.input"/>  data-attr-scan="name">
		</div>
	</div>
	<div class="m-form-group">
		<label >接口编码:</label>
		<div class="m-form-control essential">
			<textarea id="inp_code" class=" required useTitle ajax f-w350  validate-special-char max-length-500"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="resourceInterface"></textarea>
		</div>
	</div>
	<div class="m-form-group">
		<label >请求参数:</label>
		<div class="m-form-control">
			<textarea id="inp_params" class="f-w350  validate-special-char max-length-500" data-attr-scan="paramDescription"></textarea>
		</div>
	</div>
	<div class="m-form-group">
		<label >响应结果格式:</label>
		<div class="m-form-control">
			<textarea id="inp_result_format"  class="f-w350  validate-special-char max-length-1000" data-attr-scan="resultDescription"></textarea>
		</div>
	</div>
	<div class="m-form-group">
		<label >说明:</label>
		<div class="m-form-control">
			<textarea id="inp_description" class="f-w350  validate-special-char max-length-500" data-attr-scan="description"></textarea>
		</div>
	</div>
	<div class="m-form-group f-pa" style="bottom: 0;right: 20px;">
		<div class="m-form-control">
			<input type="button" value="<spring:message code="btn.save"/>" id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" />
			<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>
	</div>
</div>