<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="infoForm" data-role-form class="m-form-inline f-mt20">
  <input id="id" name="id" data-attr-scan="id"  hidden>
  <input id="metaId" name="metaId" data-attr-scan="metaId"  hidden>
  <div style="margin: 20px">
    <label style="">字段名称<spring:message code="spe.colon"/><span id="metaName"></span></label>
  </div>

  <div class="m-form-group f-ml20 f-mt20">
    <%--<div class="l-text-wrapper m-form-control">--%>
      <%--<input type="text" id="ipt_logic" data-type="select" class="required" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="logic">--%>
    <%--</div>--%>

    <%--<div class="l-text-wrapper m-form-control f-ml10">--%>
      <%--<input type="text" id="ipt_content" class="required" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="content">--%>
    <%--</div>--%>

      <div class="l-text-wrapper m-form-control">
          <input type="text" id="ipt_logic" data-type="select" class="required" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="logic">
      </div>

      <div id="iptWrap">
        <%--<div class="l-text-wrapper m-form-control f-ml10">--%>
          <%--<input type="text" id="ipt_content1" class="required" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="content1">--%>
        <%--</div>--%>
        <%--<div class="l-text-wrapper m-form-control f-ml10" style="padding-top: 8px">--%>
          <%--与--%>
        <%--</div>--%>
        <%--<div class="l-text-wrapper m-form-control f-ml10">--%>
          <%--<input type="text" id="ipt_content2" class="required" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="content2">--%>
        <%--</div>--%>
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
