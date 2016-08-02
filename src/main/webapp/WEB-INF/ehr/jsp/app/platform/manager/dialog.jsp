<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="infoForm" data-role-form class="m-form-inline f-mt20">

  <input id="id" name="id" data-attr-scan="id"  hidden >
  <input id="appId" name="appId" data-attr-scan="appId"  hidden >
  <input id="parentId" name="parentId" data-attr-scan="parentId"  hidden >

  <div class="m-form-group">
    <label>名称<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="ipt_af_name" class="required ajax" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name">
    </div>
  </div>

  <div class="m-form-group">
    <label>编码<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="ipt_af_code" class="required validate-code-char ajax" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code">
    </div>
  </div>

  <div class="m-form-group">
    <label>类型<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="ipt_af_type" data-type="select" class="required" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="type">
    </div>
  </div>

  <div class="m-form-group" style="display: none">
    <label>开放程度<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="ipt_af_open" data-type="select" class="" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="openLevel">
    </div>
  </div>

  <div class="m-form-group">
    <label>审计要求<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control">
      <input type="text" id="ipt_af_audit" data-type="select" class="" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="auditLevel">
    </div>
  </div>

  <div class="m-form-group">
    <label>图标URL<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control">
      <input type="text" id="ipt_af_icon_url" class="" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="iconUrl">
    </div>
  </div>

  <div class="m-form-group">
    <label>URL<spring:message code="spe.colon"/></label>
    <div class="m-form-control ">
      <textarea id="ipt_af_url" class="ajax f-w240 max-length-200" data-attr-scan="url" maxlength="500"></textarea>
    </div>
  </div>

  <div class="m-form-group">
    <label><spring:message code="lbl.definition"/><spring:message code="spe.colon"/></label>
    <div class="m-form-control ">
      <textarea id="ipt_af_description" class="f-w240  max-length-200" data-attr-scan="description" maxlength="500"></textarea>
    </div>
  </div>

  <div class="m-form-group f-pa update-footer">
    <div class="m-form-control">

      <div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" >
        <span>保存</span>
      </div>

      <div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
        <span>关闭</span>
      </div>

    </div>
  </div>

</div>
