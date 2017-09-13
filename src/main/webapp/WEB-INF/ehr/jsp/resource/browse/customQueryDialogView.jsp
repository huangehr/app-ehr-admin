<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_rs_info_form" data-role-form class="m-form-inline f-mt20 " data-role-form>
    <input type="hidden" id="id" data-attr-scan="id"/>
    <div class="m-form-group">
        <label>资源分类<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential f-pr0">
            <input type="text" id="inp_category" readonly="readonly" data-type="select" class="required useTitle f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="categoryId" />
        </div>
    </div>

    <div class="m-form-group">
        <label>资源名称<spring:message code="spe.colon"/></label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" id="inp_name" class="required useTitle ajax f-h28 f-w240" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>资源编码<spring:message code="spe.colon"/></label>
        <!--<div class="m-form-control essential ">-->
        <div class="m-form-control l-text-wrapper essential">
            <input id="inp_code" class="required useTitle ajax validate-special-char f-h28 f-w240"   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>资源接口<spring:message code="spe.colon"/></label>
        <!--<div class="m-form-control essential ">-->
        <div class="m-form-control l-text-wrapper essential">
            <input id="inp_interface" class="required useTitle f-h28 f-w240 validate-special-char" data-type="select" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="rsInterface"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>数据来源<spring:message code="spe.colon"/></label>
        <div class="u-checkbox-wrap m-form-control">
            <input type="radio" value="1" name="dataSource" data-attr-scan/>档案数据
            <input type="radio" value="2" name="dataSource" data-attr-scan/>指标统计
        </div>
    </div>
    <div class="m-form-group">
        <label>访问方式<spring:message code="spe.colon"/></label>
        <div class="u-checkbox-wrap m-form-control">
            <input type="radio" value="1" name="grantType" data-attr-scan/>开放访问
            <input type="radio" value="0" name="grantType" data-attr-scan/>授权访问
        </div>
    </div>
    <div class="m-form-group">
        <label>资源说明<spring:message code="spe.colon"/></label>
        <div class="m-form-control">
            <textarea id="inp_description" class="f-h28 f-w240 max-length-500 validate-special-char" data-attr-scan="description" maxlength="500"></textarea>
        </div>
    </div>
    <div class="m-form-group f-pa" style="bottom: 0;right: 20px;">
        <div class="m-form-control">
            <input type="button" value="<spring:message code="btn.save"/>" id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" />
            <div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
                <span><spring:message code="btn.close"/></span>
            </div>
        </div>
    </div>
</div>

