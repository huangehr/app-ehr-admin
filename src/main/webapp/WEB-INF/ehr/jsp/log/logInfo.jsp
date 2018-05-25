<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/8/16
  Time: 19:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>


<div id="div_rs_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
    <div class="m-form-group">
        <label>系统名称<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control f-pr0">
            <input type="text" id="appKey" readonly="readonly" data-type="select" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="appKey" />
        </div>
    </div>

    <div class="m-form-group">
        <label>菜单名称<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control f-pr0">
            <input type="text" id="function" readonly="readonly" data-type="select" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="functionName" />
        </div>
    </div>


    <div class="m-form-group">
        <label>操作名称<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control f-pr0">
            <input type="text" id="operation" readonly="readonly" data-type="select" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="operation" />
        </div>
    </div>

    <div class="m-form-group">
        <label>操作者<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control f-pr0">
            <input type="text" id="patient" readonly="readonly" data-type="select" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="patient" />
        </div>
    </div>

    <div class="m-form-group">
        <label>操作时间<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control f-pr0">
            <input type="text" id="time" readonly="readonly" data-type="select" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="time" />
        </div>
    </div>

    <div class="m-form-group">
        <label>响应时间<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control f-pr0">
            <input type="text" id="responseTime" readonly="readonly" data-type="select" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="responseTime" />
        </div>
    </div>

    <div class="m-form-group">
        <label>响应code<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control f-pr0">
            <input type="text" id="responseCode" readonly="readonly" data-type="select" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="responseCode" />
        </div>
    </div>

    <div class="m-form-group">
        <label>响应结果<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control f-pr0">
            <%--<input type="text" id="response" readonly="readonly" data-type="select" style="text-align: left" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="response" />--%>
            <textarea name="" id="response" cols="36" rows="10" style="width: 237px" data-attr-scan="response" readonly="readonly"></textarea>
        </div>
    </div>
</div>
