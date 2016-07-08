<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######应用角色页面Title设置######-->
<div class="f-dn" data-head-title="true">应用角色</div>
<div id="div_wrapper">
    <!-- ####### 应用角色部分 ####### -->
    <div class="f-mw25 f-ds1 f-fl">
        <div class="f-mt10 f-ml10">
            <!--输入框-->
            <span class="f-fl f-lh30">平台应用：</span>
            <div class="f-fl">
                <input type="text" id="inp_appRole_search" class="f-ml10 inp_appRole_com_search"/>
            </div>
        </div>

        <%--<hr class="f-fl">--%>
        <!--应用角色-->
        <div class="f-mw100 f-fl f-mt15">
            <div id="div_appRole_grid"></div>
        </div>
    </div>
    <!--应用角色组部分-->
    <div id="div_resource_browse_msg" class="div-app-role ">

        <div class="f-mt10 f-ml10 f-fl f-mb10 f-mw99">
            <!--输入框-->
            <span class="f-fl f-lh30">应用角色组：</span>
            <div class="f-fl">
                <input type="text" id="inp_appRole_group_search" class="f-ml10 inp_appRole_com_search"/>
            </div>
            <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar f-fr f-mr10" id="div_add_appRoleGroup_btn">
                <span>新增</span>
            </div>

        </div>

        <div class="div-result-msg">
            <div id="div_appRole_group_grid"></div>
        </div>
    </div>
</div>