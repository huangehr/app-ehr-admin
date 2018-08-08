<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div id="div_feature_config">
    <div class="f-ml10 f-mb10 f-mt10 m-form-inline" id="div_user_type_form" data-role-form>
        <input data-attr-scan="id" hidden="hidden" id="inp_Id"/>
        <input data-attr-scan="activeFlag" hidden="hidden" id="inp_activeFlag"/>
        <div class="m-form-group">
            <label>用户类别编码：</label>
            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_Code" class="required useTitle max-length-50"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code" onkeyup="this.value=this.value.replace(/[^\u4e00-\u9fa5\w]/g,'')" ；
                       this.value=this.value.replace(/[^\u4e00-\u9fa5\w]/g,''/>
            </div>
            <label>用户类别名称：</label>
            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_Name" class="required useTitle ajax"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name" onkeyup="this.value=this.value.replace(/[^\u4e00-\u9fa5\w]/g,'')" ；
                       this.value=this.value.replace(/[^\u4e00-\u9fa5\w]/g,''/>
            </div>
        </div>
        <div class="m-form-group">
            <label>备注：</label>
            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_Memo" class="required useTitle ajax"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="memo" onkeyup="this.value=this.value.replace(/[^\u4e00-\u9fa5\w]/g,'')" ；
                       this.value=this.value.replace(/[^\u4e00-\u9fa5\w]/g,''/>
            </div>
        </div>
    </div>
    <div class="f-mw100"><div class="f-mw50 f-fl f-ml10 f-mb10">全部角色组</div><div class="f-mw50 f-fl f-ml10 f-mb10">已选择角色组</div></div>
    <div class="f-mw100">
        <div class="f-mw50 f-ds1 f-fl f-ml10 div-appRole-grid-scrollbar" style="height: 360px">
            <div id="div_api_featrue_grid" class="f-dn"></div>
        </div>
        <div class="f-mw50 f-ds1 f-fr f-mr10 div-appRole-grid-scrollbar" style="height: 360px">
            <div id="div_configApi_featrue_grid" class="f-dn"></div>
        </div>
    </div>
    <div class="m-form-control pane-attribute-toolbar">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar f-mr10" id="div_btn_add">
            <span><spring:message code="btn.save"/></span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
            <span><spring:message code="btn.close"/></span>
        </div>
    </div>
</div>