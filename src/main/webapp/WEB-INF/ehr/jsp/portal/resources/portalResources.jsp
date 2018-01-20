<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!--######资源页面Title设置######-->
<div class="f-dn" data-head-title="true">资源管理</div>
<div id="div_wrapper">
    <div class="m-retrieve-area f-h50 f-dn f-pr  m-form-inline" data-role-form>
        <div class="m-form-group">
            <div class="m-form-control">
                <!--输入框-->
                <input type="text" id="inp_search" placeholder="请输入名称" class="f-ml10" data-attr-scan="searchNm"/>
            </div>


            <div class="m-form-control f-ml10">
                <!--按钮:查询 & 新增-->
                <sec:authorize url="/portalResources/searchPortalResources">
                    <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.search"/></span>
                    </div>
                </sec:authorize>
            </div>

            <div class="m-form-control m-form-control-fr">
                <sec:authorize url="/portalResources/updatePortalResources">
                    <div id="div_new_portalResources" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.create"/></span>
                    </div>
                </sec:authorize>
            </div>
        </div>
    </div>
    <!--######资源信息表######-->
    <div id="div_portalResources_info_grid">

    </div>
    <div id="div_portalResources_info_dialog">

    </div>
    <!--######资源信息表#结束######-->
</div>