<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>

<style>
	.i-text{
		width: 185px;
		height: 30px;
		line-height: 30px;
		padding-right: 17px;
		color: #555555;
		padding-left: 5px;
		vertical-align: middle;
	}
	.uploadBtn{
		position: relative;
		vertical-align: middle;
		overflow: hidden;
	}
	.uploadBtn .file{
		width: 50px;
		height: 30px;
		position: absolute;
		top: 0;
		left: 0;
		opacity: 0;
		z-index: 999;
	}
</style>
<div id="div_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<input type="hidden" id="id"  data-attr-scan="id">
	<div class="m-form-group">
		<label>设备名称:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="device_name" class="required useTitle max-length-50 validate-special-char" placeholder="请输入设备名称"
                   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="deviceName"/>
		</div>
		<label>所属机构:</label>
		<div class="l-text-wrapper m-form-control essential f-pr0">
			<input type="text" id="org_code" data-type="select" class="required useTitle validate-special-char"
				   placeholder="请选择所属机构" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="orgCode"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>设备代码:</label>
		<div class="l-text-wrapper m-form-control f-pr0 essential" style="position: relative;">
			<input type="text" id="device_type" data-type="select" class="required" data-attr-scan="deviceType"
                   placeholder="请选择设备代码" required-title=<spring:message code="lbl.must.input"/>>
		</div>
		<label>采购数量:</label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="purchase_num"  class="validate-positive-integer" data-attr-scan="purchaseNum" placeholder="请输入采购数量">
		</div>
	</div>
	<div class="m-form-group">
		<label>产地:</label>
		<div class="l-text-wrapper m-form-control f-pr0 essential">
			<input type="text" id="origin_place" class="required" data-type="select" placeholder="请选择产地"
                   data-attr-scan="originPlace" required-title=<spring:message code="lbl.must.input"/>/>
		</div>
		<label>生产厂家:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="manufacturer_name" class="required useTitle max-length-50 validate-special-char" data-attr-scan="manufacturerName"
                   placeholder="请输入生产厂家" required-title=<spring:message code="lbl.must.input"/>/>
		</div>
	</div>
    <div class="m-form-group">
        <label>设备型号:</label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="device_model" class="required useTitle max-length-30 validate-special-char"  data-attr-scan="deviceModel" placeholder="请输入设备型号"
                   required-title=<spring:message code="lbl.must.input"/>/>
        </div>
        <label>采购日期:</label>
        <div class="l-text-wrapper m-form-control f-pr0 essential">
            <input id="purchase_time" class="required" placeholder="请输入采购日期"  required-title=<spring:message code="lbl.must.input"/>
                    data-attr-scan="purchaseTime"/>
        </div>
    </div>
	<div class="m-form-group">
		<label>新旧情况:</label>
		<div class="l-text-wrapper m-form-control f-pr0 essential">
			<input type="text" id="is_new" data-type="select" class="required" data-attr-scan="isNew"
                   placeholder="请选择新旧情况" required-title=<spring:message code="lbl.must.input"/>/>
		</div>
		<label>购买单价（千元）:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input id="device_price" class="required validate-number" placeholder="请输入购买单价"  required-title=<spring:message code="lbl.must.input"/>
                    data-attr-scan="devicePrice"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>理论设计寿命（年）:</label>
		<div id="roleDiv" class="l-text-wrapper m-form-control">
			<input type="text" id="year_limit" data-attr-scan="yearLimit" class="validate-positive-integer"  placeholder="请输入理论设计寿命">
		</div>
		<label>使用情况:</label>
		<div class="l-text-wrapper m-form-control f-pr0 essential">
			<input type="text" id="status" data-type="select" class="required" data-attr-scan="status"
                   placeholder="请选择使用情况" required-title=<spring:message code="lbl.must.input"/>>
		</div>
	</div>
	<div class="m-form-group">
		<label class="">是否配备GPS:</label>
		<div class="l-text-wrapper m-form-control f-pr0">
			<input id="is_gps" data-type="select" data-attr-scan="isGps" placeholder="请选择是否配备GPS">
		</div>
	</div>
	<div class="m-form-group f-pr my-footer f-mt20" align="right" hidden="hidden">
		<div class="m-form-control f-pa f-mb10" style="right: 20px">
			<div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" >
				<span><spring:message code="btn.save"/></span>
			</div>
			<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>
	</div>
</div>

