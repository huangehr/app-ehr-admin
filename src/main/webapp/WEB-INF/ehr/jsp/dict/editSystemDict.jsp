<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_updateSystemDictDialog" data-role-form class="m-form-inline f-mt20 f-ml26" data-role-form>

    <div class="m-form-group">
        <label style="width:80px">字典名称：</label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_systemDictName" class="required useTitle ajax"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="type">
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
<input id="inp_systemNameCopy" type="hidden" value="">

