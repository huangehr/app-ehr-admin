<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div class="f-dn" data-head-title="true">门户配置管理</div>
<div id="div_wrapper">
    <div class="m-retrieve-area f-h50 f-dn f-pr  m-form-inline" data-role-form>
        <div class="m-form-group">
            <div class="m-form-control">
                <!--输入框-->
                <input type="text" id="inp_search" placeholder="请输入应用ID" class="f-ml10" data-attr-scan="searchNm"/>
            </div>


            <div class="m-form-control f-ml10">
                <!--按钮:查询 & 新增-->
                <sec:authorize url="/portalSetting/searchPortalSettings">
                    <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.search"/></span>
                    </div>
                </sec:authorize>
            </div>

            <div class="m-form-control m-form-control-fr">
                <sec:authorize url="/portalSetting/updatePortalSetting">
                    <div id="div_new_portalSetting" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.create"/></span>
                    </div>
                </sec:authorize>
            </div>
        </div>
    </div>
    <!--######门户配置醒信息表######-->
    <div id="div_portalSetting_info_grid">

    </div>
    <!--######门户配置表#结束######-->
</div>
<div id="div_portalSetting_info_dialog">

</div>