<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="infoForm" data-role-form class="m-form-inline f-mt20">
    <input id="id" name="id" data-attr-scan="id" hidden>
    <input id="dictCode" name="dictCode" data-attr-scan="dictCode" hidden>
    <div class="m-form-group">
        <label>值域名称<spring:message code="spe.colon"/></label>

        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="ipt_name" class="required" required-title=
            <spring:message code="lbl.must.input"/> data-attr-scan="name">
        </div>
    </div>

    <div class="m-form-group">
        <label>值域编码<spring:message code="spe.colon"/></label>

        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="ipt_code" class="required" required-title=
            <spring:message code="lbl.must.input"/> data-attr-scan="code">
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.definition"/><spring:message code="spe.colon"/></label>

        <div class="m-form-control ">
            <textarea id="ipt_description" class="f-w240 description  max-length-200 validate-special-char"
                      data-attr-scan="description" maxlength="500"></textarea>
        </div>
    </div>

    <div class="m-form-group f-pa update-footer">
        <div class="m-form-control">

            <div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam">
                <span>保存</span>
            </div>

            <div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam">
                <span>关闭</span>
            </div>

        </div>
    </div>

</div>
