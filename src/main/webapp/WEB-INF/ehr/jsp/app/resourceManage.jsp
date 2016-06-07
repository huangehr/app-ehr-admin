<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/5/23
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### 头部 ####### -->
<div id="conditionArea" align="right">
	<div class="body-head f-h50" align="left">
		<a id="btn_back" class="f-fwb">返回上一层 </a>
		<input id="appId" hidden=hidden />
		<input id="resourceId" hidden=hidden />
		<span class="f-ml20">资源名称：</span><input class="f-fwb f-mt10"  readonly="readonly" readonly id="rsName"/>
		<span class="f-ml20">资源代码：</span><input class="f-mt10" readonly="readonly" id="rsCode"/>
		<span class="f-ml20">资源主题：</span><input class="f-mt10" readonly="readonly" id="rsTopic"/>
	</div>
</div>
<div id="div_wrapper" style="border: 1px solid #D6D6D6;" >
	<div class="m-retrieve-area f-dn f-pr m-form-inline"  data-role-form>
		<div class="m-form-group f-mt10">
			<div class="m-form-control f-ml10">
				<input type="text" id="inp_search" placeholder="请输入字段名称" class="f-w240 f-h28" data-attr-scan="searchNm"/>
			</div>
			<div class="m-form-control m-form-control-fr f-mr10">
				<div id="btn_selected_allow" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span >选中允许</span>
				</div>
			</div>
			<div class="m-form-control m-form-control-fr f-mr20">
				<div id="btn_selected_forbid" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span>选中禁止</span>
				</div>
			</div>
			<div class="m-form-control m-form-control-fr f-mr20">
				<div id="btn_all_allow" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span >全部允许</span>
				</div>
			</div>
			<div class="m-form-control f-mr20  m-form-control-fr">
				<div id="btn_all_forbid" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
					<span>全部禁止</span>
				</div>
			</div>
		</div>
	</div>
	<!--###### 数据明细列表 ######-->
	<div>
		<div id="div_app_info_grid"></div>
	</div>
</div>