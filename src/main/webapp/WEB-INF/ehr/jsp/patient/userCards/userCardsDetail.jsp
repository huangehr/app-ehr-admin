<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<div id="div_cards_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<input type="hidden" id="id"  value="${userCards.id}">

	<div class="m-form-group">
		<label>卡类别：</label>
		<div class="l-text-wrapper m-form-control ">
			<label>${userCards.cardTypeName}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>就诊卡号：</label>
		<div class="l-text-wrapper m-form-control ">
			<label>${userCards.cardNo}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >归属地:</label>
		<div class="l-text-wrapper m-form-control">
			<label>${userCards.local}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >持卡人姓名:</label>
		<div class="l-text-wrapper m-form-control ">
			<label>${userCards.ownerName}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >持卡人身份证:</label>
		<div class="l-text-wrapper m-form-control">
			<label>${userCards.ownerIdcard}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >持卡人绑定手机:</label>
		<div class="l-text-wrapper m-form-control">
			<label>${userCards.ownerPhone}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >发卡机构:</label>
		<div class="l-text-wrapper m-form-control ">
			<label>${userCards.ownerName}</label>
		</div>
	</div>
	<div class="m-form-group">
		<label>发卡时间：</label>
		<div class="m-form-control">
			<label>${userCards.releaseDate}</label>
		</div>
	</div>
	<div class="m-form-group">
		<label>有效期起始时间：</label>
		<div class="m-form-control">
			<label>${userCards.validityDateBegin}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>有效期截止时间：</label>
		<div class="m-form-control">
			<label>${userCards.validityDateEnd}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>描述：</label>
		<div class="m-form-control ">
			<label>${userCards.description}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>卡状态：</label>
		<div class="l-text-wrapper m-form-control ">
			<label>
				<c:if test="${userCards.status == '1'}">有效</c:if>
				<c:if test="${userCards.status == '0'}">无效</c:if>
			</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>审核者：</label>
		<div class="m-form-control ">
			<label>${userCards.auditor}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>审核状态：</label>
		<div class="m-form-control ">
			<label>
				<c:if test="${userCards.auditStatus == '0'}">未审核</c:if>
				<c:if test="${userCards.auditStatus == '1'}">已通过</c:if>
				<c:if test="${userCards.auditStatus == '2'}">已拒绝</c:if>
			</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>审核不通过原因</label>
		<div class="m-form-control ">
			<label>${userCards.auditReason}</label>
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

