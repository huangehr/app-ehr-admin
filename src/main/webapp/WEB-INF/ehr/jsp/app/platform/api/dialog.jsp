<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<style>
  .m-form-control.essential.ms:after{
    top: 34px;
  }
</style>
<div id="infoForm" data-role-form class="m-form-inline f-mt20">
  <input type="hidden" data-attr-scan="id">
  <input type="hidden" id="appId" data-attr-scan="appId">
  <input type="hidden" id="parentId" data-attr-scan="parentId">
  <div class="m-form-group">
    <label>名称<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="ipt_api_name" class="required ajax"  data-attr-scan="name">
    </div>
  </div>

  <div id="methodNameDiv" class="m-form-group">
    <label>方法名<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential apiProto">
      <input type="text" id="ipt_api_methodName" class="required"  data-attr-scan="methodName">
    </div>
  </div>

  <div class="m-form-group">
    <label>类别<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential f-pr0">
      <input type="text" id="ipt_api_type" data-type="select" class="required" data-attr-scan="type">
    </div>
  </div>

  <div class="m-form-group">
    <label>开放程度<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential f-pr0">
      <input type="text" id="ipt_api_openLevel" data-type="select" class="required" data-attr-scan="openLevel">
    </div>
  </div>

  <div class="m-form-group">
    <label>审计程度<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential f-pr0">
      <input type="text" id="ipt_api_auditLevel" data-type="select" class="required" data-attr-scan="auditLevel">
    </div>
  </div>

  <div class="m-form-group">
    <label>状态<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential f-pr0">
      <input type="text" id="ipt_api_activityType" data-type="select" class="required" data-attr-scan="activityType">
    </div>
  </div>

  <div>
    <div class="m-form-group">
      <label>版本<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential apiProto">
        <input type="text" id="ipt_api_version" class="required"  data-attr-scan="version">
      </div>
    </div>

    <div class="m-form-group">
      <label>协议<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential apiProto f-pr0">
        <input type="text" id="ipt_api_protocol" data-type="select" class="required" data-attr-scan="protocol">
      </div>
    </div>

    <div class="m-form-group">
      <label>方法<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential apiProto f-pr0">
        <input type="text" id="ipt_api_method" data-type="select" class="required" data-attr-scan="method">
      </div>
    </div>

    <div class="m-form-group">
      <label>描述<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential ms">
        <textarea id="ipt_api_description" class="required" data-attr-scan="description">
          </textarea>
      </div>
    </div>

  </div>
  <div class="m-form-group f-pa update-footer">
    <div class="m-form-control">

      <div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" >
        <span>保存</span>
      </div>

      <div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam f-mr10" >
        <span>关闭</span>
      </div>

    </div>
  </div>

</div>
