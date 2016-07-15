<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="infoForm" data-role-form class="m-form-inline f-mt20 " data-role-form>
  <input type="hidden" id="inp_source_type"  data-attr-scan="sourceType">
  <input type="hidden" id="inp_app_tags"  data-attr-scan="tags">
  <input type="hidden" id="inp_app_id"  data-attr-scan="id">
  <input type="hidden" id="inp_app_status"  data-attr-scan="status">
  <input type="hidden" id="inp_app_creator"  data-attr-scan="creator">
  <input type="hidden" id="inp_app_auditor"  data-attr-scan="auditor">
  <input type="hidden" id="inp_app_createTime"  data-attr-scan="createTime">
  <input type="hidden" id="inp_app_auditTime"  data-attr-scan="auditTime">
  <div class="m-form-group">
    <label>应用名称<spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="inp_app_name" class="required validate-special-char" data-attr-scan="name"/>
    </div>
  </div>
  <div class="m-form-group">
    <label >应用代码:</label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="inp_app_code" class="required validate-code-char ajax f-h28 f-w240" data-attr-scan="code">
    </div>
  </div>

  <div class="m-form-group">
    <label><spring:message code="lbl.secret.key"/><spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control u-ui-readonly">
      <input type="text" id="inp_app_secret"  data-attr-scan="secret"/>
    </div>
  </div>

  <div class="m-form-group">
    <label >机构名称:</label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="inp_org_code" class="required f-h28 f-w240" data-type="select" placeholder="请输入机构代码或名称检索" data-attr-scan="org">
    </div>
  </div>

  <div class="m-form-group">
    <label><spring:message code="lbl.type"/><spring:message code="spe.colon"/></label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" id="inp_dialog_catalog" data-type="select" class="required" data-attr-scan="catalog">
    </div>
  </div>


  <div class="m-form-group">
    <label><spring:message code="lbl.callback.URL"/><spring:message code="spe.colon"/></label>
    <div class="m-form-control essential">
      <textarea id="inp_url" class="required max-length-500 validate-special-char" placeholder="请输入回调URL" data-attr-scan="url" maxlength="500"></textarea>
    </div>
  </div>

  <div class="m-form-group">
    <label><spring:message code="lbl.description"/><spring:message code="spe.colon"/></label>
    <div class="m-form-control ">
      <textarea id="inp_description" class="f-w240 max-length-500 validate-special-char" data-attr-scan="description" maxlength="500"></textarea>
    </div>
  </div>

  <div class="m-form-group f-pr my-footer" align="right" >
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

