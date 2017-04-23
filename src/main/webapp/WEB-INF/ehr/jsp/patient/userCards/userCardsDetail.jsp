<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<style>
	.col{
		color: blue;
	}

</style>

<div id="div_cards_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
	<input type="hidden" id="id"  value="${userCards.id}">
	<input type="hidden" id="cardNo"  value="${userCards.cardNo}">
	<input type="hidden" id="ownerName"  value="${userCards.ownerName}">
	<input type="hidden" id="idCardNo"  value="${userCards.ownerIdcard}">

	<div class="m-form-group">
		<label>卡类别：</label>
		<div class="l-text-wrapper m-form-control ">
			<label class="col">${userCards.cardTypeName}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>就诊卡号：</label>
		<div class="l-text-wrapper m-form-control ">
			<label class="col">${userCards.cardNo}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >归属地:</label>
		<div class="l-text-wrapper m-form-control">
			<label class="col">${userCards.local}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >持卡人姓名:</label>
		<div class="l-text-wrapper m-form-control ">
			<label class="col">${userCards.ownerName}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >持卡人身份证:</label>
		<div class="l-text-wrapper m-form-control">
			<label class="col">${userCards.ownerIdcard}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >持卡人绑定手机:</label>
		<div class="l-text-wrapper m-form-control">
			<label class="col">${userCards.ownerPhone}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label >发卡机构:</label>
		<div class="l-text-wrapper m-form-control ">
			<label class="col">${userCards.ownerName}</label>
		</div>
	</div>
	<div class="m-form-group">
		<label>发卡时间：</label>
		<div class="m-form-control">
			<label class="col">${userCards.releaseDate}</label>
		</div>
	</div>
	<div class="m-form-group">
		<label>有效期起始时间：</label>
		<div class="m-form-control">
			<label class="col">${userCards.validityDateBegin}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>有效期截止时间：</label>
		<div class="m-form-control">
			<label class="col">${userCards.validityDateEnd}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>描述：</label>
		<div class="m-form-control ">
			<label class="col">${userCards.description}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>卡状态：</label>
		<div class="l-text-wrapper m-form-control ">
			<label class="col">
				<c:if test="${userCards.status == '1'}">有效</c:if>
				<c:if test="${userCards.status == '0'}">无效</c:if>
			</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>审核者：</label>
		<div class="m-form-control ">
			<label class="col">${userCards.auditor}</label>
		</div>
	</div>

	<div class="m-form-group">
		<label>审核状态：</label>
		<div class="m-form-control ">
			<label class="col">
				<c:if test="${userCards.auditStatus == '0'}">未审核</c:if>
				<c:if test="${userCards.auditStatus == '1'}">已通过</c:if>
				<c:if test="${userCards.auditStatus == '2'}">已拒绝</c:if>
			</label>
		</div>
	</div>

	<c:if test="${userCards.auditStatus == '2'}">
		<div class="m-form-group">
			<label>审核不通过原因：</label>
			<div>
				<label class="col">${userCards.auditReason}</label>
			</div>
		</div>
	</c:if>


		<c:if test="${userCards.auditStatus == '0'}">
			<div class="m-form-group">
				<label>审核：</label>
				<div class="m-form-control ">
					<label>
						<select id="audit" class="col" style="width: 80px;height: 25px;">
							<option value="">请选择</option>
							<option value="1">通过</option>
							<option value="2">拒绝</option>
						</select>
					</label>
				</div>
				<div id="btn_relative" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" >
					<span>辅助审核查看</span>
				</div>
			</div>

			<div class="m-form-group" id="refuseReasonGroup" style="display: none">
				<label>拒绝原因：</label>
				<div class="m-form-control ">
					<label class="col">
						<select id="reason" style="height: 25px;">
							<option value="">请选择</option>
							<option value="1">信息不全，匹配出多张就诊卡</option>
							<option value="2">信息不符，没有匹配的就诊卡</option>
							<option value="0">其他</option>
						</select>
					</label>
				</div>
			</div>

			<div class="m-form-group" id="otherGroup">
				<label>原因：</label>
				<div class="m-form-control ">
					<label class="col">
						<textarea id="otherReason" class="f-w240 max-length-500 validate-special-char"  maxlength="500"></textarea>
					</label>
				</div>
			</div>

			<div class="m-form-group f-pr my-footer">
				<div class="m-form-control f-pa" style="right: 10px">
					<div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" >
						<span><spring:message code="btn.confirm"/></span>
					</div>
					<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
						<span><spring:message code="btn.cancel"/></span>
					</div>
				</div>
			</div>

		</c:if>







</div>

