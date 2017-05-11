<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="infoForm" data-role-form class="m-form-inline f-mt20">

  <input id="valid" name="valid" value="1" data-attr-scan="valid"  hidden >
  <input id="dictCode" name="dictCode" value="1" data-attr-scan="dictCode"  hidden >

  <div class="m-form-group">
    <label>资源标准编码<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="ipt_meta_code" class="required validate-meta-id ajax" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="id">
    </div>
  </div>

  <div class="m-form-group">
    <label>业务领域<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="ipt_domain" data-type="select" class="required" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="domain">
    </div>
  </div>

  <div class="m-form-group">
    <label>内部标识符<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="ipt_std_code" class="required validate-code-char " required-title=<spring:message code="lbl.must.input"/> data-attr-scan="stdCode">
    </div>
  </div>

  <div class="m-form-group">
    <label>数据元名称<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="ipt_meta_name" class="required" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name">
    </div>
  </div>

  <div class="m-form-group">
    <label>类型<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="ipt_column_type" data-type="select" class="required" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="columnType">
    </div>
  </div>

  <div class="m-form-group">
    <label>关联字典<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control">
      <input type="text" id="ipt_dict_id" data-type="select" class="" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="dictId">
    </div>
  </div>

  <div class="m-form-group">
    <label>是否可为空<spring:message code="spe.colon"/></label>
    <div class="u-checkbox-wrap m-form-control">
      <input type="radio" value="1" name="gender" data-attr-scan="nullAble" checked>是
      <input type="radio" value="0" name="gender" data-attr-scan="nullAble">否
    </div>
  </div>

  <div class="m-form-group">
    <label><spring:message code="lbl.definition"/><spring:message code="spe.colon"/></label>
    <div class="m-form-control ">
      <textarea id="ipt_description" class="f-w240 description  max-length-200 validate-special-char" data-attr-scan="description" maxlength="500"></textarea>
    </div>
  </div>

  <div class="m-form-group f-pa update-footer">
    <div class="m-form-control">

      <div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" >
        <span>保存</span>
      </div>

      <div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam f-mr20" >
        <span>关闭</span>
      </div>

    </div>
  </div>

</div>
