<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<style>
	/*.col{*/
		/*color: blue;*/
	/*}*/

</style>

<div id="div_cards_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<input type="hidden" id="id"  value="${userCards.id}">

	<div class="m-form-group">
		<label>卡类别：</label>
		<label class="col">${userCards.cardTypeName}</label>
		<label>就诊卡号：</label>
		<label class="col">${userCards.cardNo}</label>
		<label >归属地:</label>
		<label class="col">${userCards.local}</label>
	</div>

	<div class="m-form-group">
		<label >持卡人姓名:</label>
		<div class="l-text-wrapper m-form-control ">
			<label class="col">${userCards.ownerName}</label>
		</div>
		<label >持卡人身份证:</label>
		<div class="l-text-wrapper m-form-control">
			<label class="col">${userCards.ownerIdcard}</label>
		</div>
		<label >持卡人绑定手机:</label>
		<div class="l-text-wrapper m-form-control">
			<label class="col">${userCards.ownerPhone}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >发卡机构:</label>
		<div class="l-text-wrapper m-form-control ">
			<label class="col">${userCards.releaseOrg}</label>
		</div>
		<label>发卡时间：</label>
		<div class="m-form-control">
			<label class="col">${userCards.releaseDate}</label>
		</div>
		<label>卡状态：</label>
		<div class="l-text-wrapper m-form-control ">
			<label class="col">
				<c:if test="${userCards.status == '1'}">有效</c:if>
				<c:if test="${userCards.status == '0'}">无效</c:if>
			</label>
		</div>
	</div>
	<div class="m-form-group">
		<label>描述：</label>
		<div class="m-form-control">
			<textarea  class="col" readonly title="${userCards.description}" style="width:750px;">${userCards.description}</textarea>
		</div>
	</div>
	<div class="m-form-group">
		<label>有效期起始时间：</label>
		<div class="m-form-control">
			<label class="col">${userCards.validityDateBegin}</label>
		</div>
		<label>有效期截止时间：</label>
		<div class="m-form-control">
			<label class="col">${userCards.validityDateEnd}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>审核者：</label>
		<div class="m-form-control ">
			<label class="col">${userCards.auditor}</label>
		</div>
		<label>审核状态：</label>
		<div class="m-form-control ">
			<label class="col">
				<c:if test="${userCards.auditStatus == '0'}">未审核</c:if>
				<c:if test="${userCards.auditStatus == '1'}">已通过</c:if>
				<c:if test="${userCards.auditStatus == '2'}">已拒绝</c:if>
			</label>
		</div>
		<c:if test="${userCards.auditStatus == '2'}">
				<label>审核不通过原因：</label>
				<div class="m-form-control">
					<label class="col">${userCards.auditReason}</label>
				</div>
		</c:if>
	</div>
	<c:if test="${userCards.auditStatus == '0'}">
		<div class="m-form-group">
			<label>审核：</label>
			<div class="m-form-control ">
					<input type="text" data-type="select" id="audit">
			</div>

			<div class="m-form-control " id="refuseReasonGroup" style="display: none;">
				<label>拒绝原因：</label>
				<div class="m-form-control" >
					<input type="text" id="reason" data-type="select"  class="col">
				</div>
			</div>

			<label class="">原因：</label>
			<div class="m-form-control ">
				<textarea id="otherReason" style="min-height: 35px;width:150px;border: 1px solid #D0D0D0;" class="max-length-500 validate-special-char"  maxlength="500"></textarea>
			</div>
		</div>

		<div class="m-form-group f-pr my-footer">
			<div class="m-form-control f-pa" style="right: 20px">
				<div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" >
					<span><spring:message code="btn.confirm"/></span>
				</div>
				<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
					<span><spring:message code="btn.cancel"/></span>
				</div>

				<div id="btn_relative" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span >关联保存</span>
				</div>
			</div>
		</div>

	</c:if>
</div>
<div style="margin-bottom: 30px;"></div>
<div id="div_userCardsRelative_info_grid"  >
</div>



