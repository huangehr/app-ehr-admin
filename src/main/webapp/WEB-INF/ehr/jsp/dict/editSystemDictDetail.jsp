<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%--系统字典详情的新增--%>
<div id="div_add_systemDictEntityDialog" class="u-public-manage m-form-inline">
    <div class="m-form-group div-dict-code mt20">
        <label style="width: 99px;">字典编码:</label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_systemDictEntity_code" class="required useTitle max-length-30" required-title=<spring:message code="lbl.must.input"/>  />
        </div>
    </div>
    <div class="m-form-group">
        <label style="width: 99px;">字典值:</label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_systemDictEntity_value" class="required useTitle max-length-100" required-title=<spring:message code="lbl.must.input"/> />
        </div>
    </div>
    <div class="m-form-group" style="display: none">
        <label style="width: 99px;">序号:</label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_systemDictEntity_sort" class="max-length-11 validate-digits" />
        </div>
    </div>
    <div class="m-form-group">
        <label style="width: 99px;">分类:</label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_systemDictEntity_catalog" class="max-length-32 validate-logic-conditions" />
        </div>
    </div>
    <div class="m-form-group f-pa" style="bottom: 0;right: 135px;">
        <div class="m-form-control">
            <input type="button" value="确认" id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" />
            <%--<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >--%>
            <%--<span><spring:message code="btn.close"/></span>--%>
            <%--</div>--%>
        </div>
    </div>
</div>
