<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/4/13
  Time: 13:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!--#####Title设置#####-->
<div class="f-dn" data-head-title="true">健康问题字典</div>
<div id="div_wrapper" >
	<!--#########查询部分##&ndash-->
	<div class="m-retrieve-area f-h50 f-pr m-form-inline" data-role-form>
		<div class="m-form-group f-mt10">
			<div class="m-form-control f-tal">
				<label style="text-align: left;width: 80px;font-size:14px;font-weight: 700">字典项: </label>
			</div>
			<div class="m-form-control">
				<!--输入框-->
				<input type="text" id="inp_searchNm" class="f-ml30" placeholder="请输入疾病编码或名称" data-attr-scan="searchNm"/>
			</div>
			<!--按钮:新增&批量删除-->
			<div class="m-form-control f-ml20">
				<div id="div_new_record" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span>新增</span>
				</div>
			</div>
			<div class="m-form-control m-form-control-fr">
				<div id="btn_deletes" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span>批量删除</span>
				</div>
			</div>
		</div>
	</div>
	<!--###CDA版本信息表###-->
	<div id="div_special_dict_grid"></div>
</div>

