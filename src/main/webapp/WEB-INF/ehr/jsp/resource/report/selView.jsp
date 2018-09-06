<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
</style>

<div>
    <div class="wrapper">
        <div class="f-fl v-h-left f-pt5">
            <div class="v-h-con c-h-l-r f-pt10 f-pb10 ">
                <input type="radio" name="dataType" value="1" checked=""><span>档案数据</span>
            </div>
            <div class="v-h-con c-h-r-r f-pt10 f-pb10 ">
                <input type="radio" name="dataType" value="2"><span>指标统计</span>
            </div>
        </div>
        <div class="left-items">
            <div class="header">
                <input type="text" id="settingSearchNm" placeholder="请输入视图名称">
            </div>
            <div id="settingTreeContainer">
                <div class="content" id="supplyTree"></div>
            </div>
        </div>
    </div>

    <div class="m-form-control pane-attribute-toolbar">
        <%--<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" id="btnSave">--%>
            <%--<span>保存</span>--%>
        <%--</div>--%>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar f-mr20" id="btnClose">
            <span>关闭</span>
        </div>
    </div>
</div>