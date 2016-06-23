<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div id="div_std_info_form" data-role-form class="m-form-inline f-mt20 f-ml26" data-role-form>
    <h3 style="margin:-20px 0 0 30%;font-weight: bold">无匹配档案</h3>
    <div><span style="margin: 5px 5px 5px 5px">${msg}</span></div>
    <div class="m-form-group f-pa" style="bottom: 0;right: 10px;">
        <div class="m-form-control">
            <div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
                <span><spring:message code="btn.close"/></span>
            </div>
            <input type="button" value="审核不通过" id="btn_reject" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" />
        </div>
    </div>
</div>

