<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_rs_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<input type="hidden" id="id" data-attr-scan="id"/>
	<div class="m-form-group">
		<label>视图分类<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control f-pr0">
			<input type="text" id="inp_category" readonly="readonly" data-type="select" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="categoryId" />
		</div>
	</div>

	<div class="m-form-group">
		<label>视图名称<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_name" class="required useTitle ajax f-h28 f-w240" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>视图编码<spring:message code="spe.colon"/></label>
		<!--<div class="m-form-control essential ">-->
		<div class="m-form-control l-text-wrapper essential">
			<input id="inp_code" class="required useTitle ajax validate-special-char f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>视图接口<spring:message code="spe.colon"/></label>
		<!--<div class="m-form-control essential ">-->
		<div class="m-form-control l-text-wrapper essential" style="padding-right: 0">
			<input id="inp_interface" class="required useTitle f-h28 f-w240 validate-special-char" data-type="select" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="rsInterface"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>数据来源<spring:message code="spe.colon"/></label>
		<div class="u-checkbox-wrap m-form-control">
			<input type="text" id="dataSource" readonly="readonly" data-attr-scan="dataSource">
			<%--<input type="radio" value="1" name="dataSource" data-attr-scan/>档案数据--%>
			<%--<input type="radio" value="2" name="dataSource" data-attr-scan/>指标统计--%>
		</div>
	</div>
	<div id="dataShowType" class="m-form-group" style="display: none;">
		<label>数据展示类型<spring:message code="spe.colon"/></label>
		<div class="m-form-control l-text-wrapper essential" style="padding-right: 0">
			<input type="text" id="echartType" class="required useTitle f-h28 f-w240 validate-special-char" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="echartType">
		</div>
	</div>

	<div id="dataMeasurementDiv" class="m-form-group" style="display: none;">
		<label>计量单位<spring:message code="spe.colon"/></label>
		<div class="m-form-control l-text-wrapper essential">
			<input type="text" id="dataMeasurement" placeholder="数字" class="required useTitle f-h28 f-w240 max-length-15 validate-number" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="dataMeasurement">
		</div>
	</div>

	<div id="dataUnitDiv" class="m-form-group" style="display: none;">
		<label>单位<spring:message code="spe.colon"/></label>
		<div class="m-form-control l-text-wrapper essential">
			<input type="text" id="dataUnit" class="required useTitle f-h28 f-w240 max-length-30 validate-special-char" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="dataUnit">
		</div>
	</div>

	<div id="dataPositionDiv" class="m-form-group" style="display: none;">
		<label>位置<spring:message code="spe.colon"/></label>
		<div class="m-form-control l-text-wrapper essential">
			<input type="text" id="dataPosition" class="required useTitle f-h28 f-w240 validate-special-char" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="dataPosition">
		</div>
	</div>

	<div class="m-form-group">
		<label>数据查询维度<spring:message code="spe.colon"/></label>
		<div class="m-form-control l-text-wrapper">
			<input id="inp_dimension" class="useTitle ajax validate-special-char f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="dimension"/>
		</div>
	</div>

	<div class="m-form-group">
		<label>访问方式<spring:message code="spe.colon"/></label>
		<div class="u-checkbox-wrap m-form-control">
			<input type="radio" value="1" name="grantType" data-attr-scan/>授权访问
			<input type="radio" value="0" name="grantType" data-attr-scan/>开放访问
		</div>
	</div>
	<div class="m-form-group">
		<label>视图说明<spring:message code="spe.colon"/></label>
		<div class="m-form-control">
			<textarea id="inp_description" class="f-h28 f-w240 max-length-500 validate-special-char" data-attr-scan="description" maxlength="500"></textarea>
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

