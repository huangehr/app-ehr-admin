<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######新增角色组页面######-->
<div id="div_feature_config">
    <div class="f-ml10 f-mb10 f-mt10">
        <div class="m-form-group">
            <label>配置内容：</label>
            <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar div-roleGroup-btn"
                 id="div_add_roleGroup_btn">
                <span>功能权限</span>
            </div>
            <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar div-roleGroup-btn"
                 id="div_cancel_roleGroup_btn">
                <span>api权限</span>
            </div>
        </div>
    </div>
    <div class="f-mw100">
        <div class="f-mw50 f-ds1 f-fl div-appRole-grid-scrollbar" style="height: 450px">
            <label class="f-mt10 f-ml10 lab-title-msg"></label>
            <hr class="f-mt5 f-mb10">
            <div id="div_function_featrue_grid" class=""></div>
        </div>
        <div class="f-mw50 f-ds1 f-fr div-appRole-grid-scrollbar" style="height: 450px">
            <label class="f-mt10 f-ml10">已配置权限</label>
            <hr class="f-mt5 f-mb10">
            <div id="div_api_featrue_grid" class=""></div>
        </div>
    </div>
</div>