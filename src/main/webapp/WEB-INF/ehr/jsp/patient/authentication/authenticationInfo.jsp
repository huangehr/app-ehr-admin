<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div id="conditionArea"align="right">
	<div class="body-head f-h30 f-pb10" align="left">
		<a class="f-fwb" id="btn_back">返回上一层 </a>
		<input id="id" hidden=hidden />
	</div>
</div>
<div id="div_wrapper">
	<div id="div_content" data-role-form>
		<%--左边--%>
		<div id="div_left">
			<div class="m-form-group f-tac">
				<span>&nbsp&nbsp&nbsp姓名：</span>
				<input class="f-mt10 f-b0" readonly="readonly" data-attr-scan="name" />
			</div>
			<div class="m-form-group f-tac">
				<span>身份证号码：</span>
				<input class="f-mt10 f-b0" readonly="readonly" data-attr-scan="idCard"/>
			</div>
			<div class="m-form-group f-tac">
				<span>医疗卡类型：</span>
				<input class="f-mt10 f-b0" readonly="readonly" data-attr-scan="medicalCardType"/>
			</div>
			<div class="m-form-group f-mt20 f-tac">
				<div id="div_image_left_large" class="div_image_large"></div>
				<div id="div_image_left" class="div_image"></div>
			</div>

		</div>
		<%--右边--%>
		<div id="div_right" class="f-db">
			<div class="m-form-group f-tac">
				<span>&nbsp&nbsp&nbsp&nbsp电话：</span>
				<input class="f-mt10 f-b0" readonly="readonly" data-attr-scan="telephone"/>
			</div>
			<div class="m-form-group f-tac">
				<span>身份证有效期：</span>
				<input class="f-mt10 f-b0" readonly="readonly" data-attr-scan="idCardEffective"/>
			</div>
			<div class="m-form-group f-tac">
				<span>&nbsp&nbsp医疗卡号：</span>
				<input class="f-mt10 f-b0" readonly="readonly" data-attr-scan="medicalCardNo"/>
			</div>
			<div class="m-form-group f-mt20 f-tac">
				<div id="div_image_right_large" class="div_image_large"></div>
				<div id="div_image_right" class="div_image"></div>
			</div>
		</div>
		<%--操作按钮--%>
		<div id="div_btn" class="f-db" style="width: 100%;height: 50px;">
			<div class="m-form-control f-tac">
				<input type="button" value="同意" id="btn_approve" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr30" />
				<div id="btn_refuse" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" >
					<span>拒绝</span>
				</div>
			</div>
		</div>
	</div>
</div>