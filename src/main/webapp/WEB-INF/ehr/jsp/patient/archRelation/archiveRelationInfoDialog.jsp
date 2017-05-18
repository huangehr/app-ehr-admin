<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<div id="div_cards_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<input type="hidden" id="inp_id"  data-attr-scan="id" value="0">

	<div class="m-form-group">
		<label>机构编码</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_orgCode" class="required"
				    required-title=<spring:message code="lbl.must.input"/> data-attr-scan="orgCode"/>
		</div>
	</div>

	<div class="m-form-group">
		<label>机构名称</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_orgName" class="required"
				      required-title=<spring:message code="lbl.must.input"/> data-attr-scan="orgName"/>
		</div>
	</div>

	<div class="m-form-group">
		<label>姓名</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_sname" class="required"
				   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name"/>
		</div>
	</div>

	<div class="m-form-group">
		<label >身份证</label>
		<div class="l-text-wrapper m-form-control ">
			<input type="text" id="inp_idCardNo" class="f-h28 f-w240  useTitle " data-attr-scan="idCardNo">
		</div>
	</div>

	<div class="m-form-group">
		<label>就诊卡类别</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_cardType" class="required" data-type="select"    data-attr-scan="cardType"/>
		</div>
	</div>

	<div class="m-form-group">
		<label>就诊卡号<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_cardNo" class="required max-length-50 validate-code-char"  data-attr-scan="cardNo"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>就诊事件号<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_eventNo" class="max-length-50 validate-code-char"  data-attr-scan="eventNo"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>就诊时间<spring:message code="spe.colon"/></label>
		<div class="m-form-control">
			<input type="text" id="inp_eventDate" class="validate-date  l-text-field " placeholder="输入发卡时间 格式(2017-04-15)"
				    data-attr-scan="eventDate"/>
		</div>
	</div>

	<div class="m-form-group">
		<label>就诊类型<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_eventType" data-type="select" class="required" data-attr-scan="eventType"/>
		</div>
	</div>




	<div class="m-form-group f-pr my-footer" align="center" hidden="hidden">
		<div class="m-form-control f-pa" style="right: 20px">
			<div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" style="right: 10px">
				<span><spring:message code="btn.save"/></span>
			</div>
			<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>
	</div>
</div>

