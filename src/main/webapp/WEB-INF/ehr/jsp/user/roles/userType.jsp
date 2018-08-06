<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!--######应用角色页面Title设置######-->
<div class="f-dn" data-head-title="true">应用分组</div>
<div id="div_wrapper">
    <!-- ####### 应用角色部分 ####### -->
    <div class="f-mw25 f-ds1 f-fl" style="position: absolute;left: 0;top: 0;bottom: 0;">
        <div class="f-mt10 f-ml10">
            <!--输入框-->
            <%--<span class="f-fl f-lh30">平台应用：</span>--%>
            <div class="f-fl">
                <input type="text" id="inp_userType_search" placeholder="请输入应用名称" class="f-ml10 inp_userType_com_search"/>
            </div>
            <sec:authorize url="/user/updateUser">
                <div class="m-form-control m-form-control-fr" style="float: right;margin-right: 10px;">
                    <div id="div_new_userType" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
                        <span><spring:message code="btn.create"/></span>
                    </div>
                </div>
            </sec:authorize>
        </div>

        <%--<hr class="f-fl">--%>
        <!--应用角色-->
        <div class="f-mw100 f-fl f-mt15">
            <div id="div_userType_grid"></div>
        </div>
    </div>
    <!--应用角色组部分-->
    <div id="div_app_browse_msg" class="div-app-role" style="position: absolute;left: 460px;top: 0;bottom: 0;right: 0">
        <div class="div-result-msg">
            <div class="f-ml10 f-mb10 f-mt10">
                <span class="f-fl f-lh30 f-f14">关联角色组</span>
                <div class="m-form-group">
                    <div class="f-fr f-mr10 l-button u-btn u-btn-primary u-btn-large f-ib f-vam close-toolbar div-roleGroup-btn"
                         id="div_featrue_save_btn">
                        <span>保存</span>
                    </div>
                </div>
            </div>
            <div class="f-mw100"><div class="f-mw50 f-fl f-ml10 f-mb10">全部角色组</div><div class="f-mw50 f-fl f-ml10 f-mb10">已选择角色组</div></div>
            <div class="f-mw100">
                <div class="f-mw50 f-ds1 f-fl f-ml10 div-appRole-grid-scrollbar" style="height: 450px">
                    <div id="div_api_featrue_grid" class="f-dn"></div>
                </div>
                <div class="f-mw50 f-ds1 f-fr f-mr10 div-appRole-grid-scrollbar" style="height: 450px">
                    <div id="div_configApi_featrue_grid" class="f-dn"></div>
                </div>
            </div>
        </div>
    </div>
</div>