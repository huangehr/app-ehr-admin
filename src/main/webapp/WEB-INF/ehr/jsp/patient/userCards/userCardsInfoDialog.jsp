<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<style>
	#inp_description { height: 100px; }
	.m-form-readonly textarea{pointer-events: auto}
	#div_app_info_form .mCustomScrollBox{ display:none !important}
</style>


<div id="div_cards_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<input type="hidden" id="inp_id"  data-attr-scan="id" value="0">

	<div class="m-form-group">
		<label >归属地:</label>
		<div class="l-text-wrapper m-form-control">
			<input type="text" id="inp_local" class="f-h28 f-w240"  data-attr-scan="local">
		</div>
	</div>

	<div class="m-form-group">
		<label >持卡人姓名:</label>
		<div class="l-text-wrapper m-form-control ">
			<input type="text" id="inp_ownerName" class="f-h28 f-w240"  data-attr-scan="ownerName">
		</div>
	</div>

	<div class="m-form-group">
		<label >持卡人身份证:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_ownerIdcard" class="f-h28 f-w240 required useTitle ajax validate-id-number" data-attr-scan="ownerIdcard">
		</div>
	</div>

	<div class="m-form-group">
		<label >持卡人绑定手机:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_ownerPhone" class="required useTitle validate-mobile-phone"   data-attr-scan="ownerPhone">
		</div>
	</div>


	<div class="m-form-group">
		<label>卡类别</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_card_type" class="required"
				   data-type="select"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="cardType"/>
		</div>
	</div>

	<div class="m-form-group">
		<label>就诊卡号<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_card_no" class="required max-length-50 validate-code-char"  data-attr-scan="cardNo"/>
		</div>
	</div>
	<div class="m-form-group">
		<label >发卡机构:</label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_release_org" class="required f-h28 f-w240"  data-attr-scan="releaseOrg">
		</div>
	</div>
	<div class="m-form-group">
		<label>发卡时间<spring:message code="spe.colon"/></label>
		<div class="m-form-control">
			<input type="text" id="inp_release_date" class="validate-date  l-text-field " placeholder="输入发卡时间 格式(2017-04-15)"
				    data-attr-scan="releaseDate"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>有效期起始时间<spring:message code="spe.colon"/></label>
		<div class="m-form-control">
			<input type="text" id="inp_validity_date_begin" class="validate-date  l-text-field " placeholder="输入起始时间 格式(2017-04-15)"
				   data-attr-scan="validityDateBegin"/>
		</div>
	</div>
	<div class="m-form-group">
		<label>有效期截止时间<spring:message code="spe.colon"/></label>
		<div class="m-form-control">
			<input type="text" id="inp_validity_date_end" class="validate-date  l-text-field " placeholder="输入截止时间 格式(2017-04-15)"
				   data-attr-scan="validityDateEnd"/>
		</div>
	</div>

	<div class="m-form-group">
		<label><spring:message code="lbl.description"/><spring:message code="spe.colon"/></label>
		<div class="m-form-control ">
			<textarea id="inp_description" class="f-w240 max-length-500 validate-special-char" data-attr-scan="description" maxlength="500"></textarea>
		</div>
	</div>

	<div class="m-form-group">
		<label>卡状态<spring:message code="spe.colon"/></label>
		<div class="l-text-wrapper m-form-control essential">
			<input type="text" id="inp_status" data-type="select" class="required" data-attr-scan="status"/>
		</div>
	</div>




	<div class="m-form-group f-pr my-footer" align="right" hidden="hidden">
		<div class="m-form-control f-pa" style="right: 10px">
			<div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.save"/></span>
			</div>
			<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
				<span><spring:message code="btn.close"/></span>
			</div>
		</div>
	</div>
</div>

