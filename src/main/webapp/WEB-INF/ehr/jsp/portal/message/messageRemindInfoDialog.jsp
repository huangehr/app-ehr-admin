<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div id="div_info_form" data-role-form class="m-form-inline f-mt20 f-pb10" style="overflow:auto">
    <input data-attr-scan="id" hidden="hidden"/>

    <div class="m-form-group">
        <label><spring:message code="lbl.messageRemind.appId"/><spring:message code="spe.colon"/></label>
        <div class="m-form-control essential">
            <input type="text" id="inp_appId" data-attr-scan="appId"  class="required f-w240 description  max-length-50 validate-special-char">
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.messageRemind.appName"/><spring:message code="spe.colon"/></label>
        <div class="m-form-control essential">
            <input type="text" id="inp_appName"  data-attr-scan="appName" class="required f-w240 description  max-length-50 validate-special-char">
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.messageRemind.type"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" id="inp_typeId" data-type="select" data-attr-scan="typeId"  />
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.messageRemind.toUser"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control ">
            <input type="text" id="ipt_search_user"  placeholder="请选择对象用户" data-type="select" data-attr-scan="toUserId">
        </div>
    </div>

    <div class="m-form-group" id="inp_content_div">
        <label><spring:message code="lbl.messageRemind.content"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control ">
			<textarea id="inp_content" class=" f-w240 description  max-length-256 validate-special-char"
                      data-attr-scan="content" ></textarea>
        </div>
    </div>

    <div class="m-form-group">
        <label><spring:message code="lbl.messageRemind.workUri"/><spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control ">
            <textarea id="inp_workUri"   data-attr-scan="workUri"  class=" f-w240 description  max-length-56 validate-special-char"></textarea>
        </div>
    </div>

    <div id="div_toolbar" class="m-form-control pane-attribute-toolbar">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" id="div_update_btn">
            <span><spring:message code="btn.save"/></span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
            <span><spring:message code="btn.close"/></span>
        </div>
    </div>

</div>