<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_icd_info_form" data-role-form class="m-form-inline f-mt20">
	<input type="hidden" id="id" data-attr-scan="id"/>
	<div class="m-form-group">
		<label >诊断编码:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_icd10_code" class="required useTitle ajax f-w240 max-length-50"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code" />
		</div>
	</div>
	<div class="m-form-group">
		<label >诊断名称:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_icd10_name" class="required useTitle ajax f-w240 max-length-200"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name" />
		</div>
	</div>
	<div class="m-form-group">
		<label >标志:</label>
		<div class="u-checkbox-wrap m-form-control">
			<input id="inp_infectiousFlag" style="height: 20px;width: 20px;margin-left: 30px;" type="checkbox" value="1" name="infectiousFlag" data-attr-scan /> 传染病
			<input id="inp_chronicFlag" style="height: 20px;width: 20px;" type="checkbox" value="1" name="chronicFlag" data-attr-scan /> 慢病

		</div>
	</div>
	<%--<div>--%>
		<%--<div class="f-pr u-bd" id="icd10_flag">--%>
			<%--<div class="f-pa f-wtl" style="">--%>
				<%--数据来源--%>
			<%--</div>--%>
			<%--<div class="m-form-group f-mt20">--%>
				<%--<label style="width: 140px;">数据集: </label>--%>
				<%--<div class="l-text-wrapper m-form-control">--%>
					<%--<input type="text" id="inp_data_set" class="f-w240"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code" />--%>
				<%--</div>--%>
			<%--</div>--%>
			<%--<div class="m-form-group">--%>
				<%--<label style="width: 140px;">数据元:</label>--%>
				<%--<div class="l-text-wrapper m-form-control">--%>
					<%--<input type="text" id="inp_meta_data" class="f-w240"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code" />--%>
				<%--</div>--%>
			<%--</div>--%>
		<%--</div>--%>
	<%--</div>--%>
	<div class="m-form-group">
		<label >说明:</label>
		<div class="m-form-control">
			<textarea id="inp_icd10_description" class="f-w240 validate-special-char max-length-200" data-attr-scan="description"></textarea>
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