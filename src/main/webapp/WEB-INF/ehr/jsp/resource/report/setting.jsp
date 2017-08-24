<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div>
    <div class="wrapper">
        <div class="left-items">
            <div class="header">
                <input type="text" id="searchNm" placeholder="请输入视图名称">
            </div>
            <div class="content" id="supplyTree"></div>
        </div>

        <div class="arrow"></div>

        <div class="right-items">
            <div class="header">
                <span>已配置</span>
            </div>
            <div class="content" id="selectedGrid"></div>
        </div>
    </div>

    <div class="m-form-control pane-attribute-toolbar">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" id="btnSave">
            <span>保存</span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar f-mr20" id="btnClose">
            <span>关闭</span>
        </div>
    </div>
</div>

