<%--
  Created by IntelliJ IDEA.
  User: AndyCai
  Date: 2015/12/11
  Time: 14:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div id="div_catetype_info_form" data-role-form class="m-form-inline f-mt20">
  <div class="m-form-group">
    <label>名称：</label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" class="required useTitle f-w240 max-length-50 validate-special-char" required-title=<spring:message code="lbl.must.input"/> id="txt_name" data-attr-scan="name">
    </div>
  </div>
  <div class="m-form-group">
    <label>父级类别：</label>
    <div class="l-text-wrapper m-form-control">
      <input type="text" data-attr-scan="pid" id="ipt_select" data-type="select">
    </div>
  </div>


  <div class="m-form-group">
    <label>视图分类：</label>
    <div class="l-text-wrapper m-form-control essential">
      <input type="text" data-attr-scan="code" class="required" id="ipt_view" data-type="select" required-title="请选择视图分类">
    </div>
  </div>

  <div class="m-form-group">
    <label>说明：</label>
    <div class="m-form-control">
      <textarea rows="3" id="txt_description" name="txb_desc" style="width: 240px;height: 60px;" data-attr-scan="description"  class="useTitle max-length-200 validate-special-char"></textarea>
    </div>
  </div>

  <div class="m-form-control pane-attribute-toolbar">
    <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" id="btn_save">
      <span>保存</span>
    </div>
    <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar f-mr20" id="btn_close">
      <span>关闭</span>
    </div>
  </div>

  <input type="hidden" id="hdId" value="${id}"/>
  <input type="hidden" id="hd_url" value="${contextRoot}"/>
</div>
