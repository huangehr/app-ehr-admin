<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div id="editMain">
    <%--top--%>
    <div class="top-con">
        <%--按钮--%>
        <div id="upHtmlFile" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
            <span>添加模板</span>
        </div>
        <%--按钮--%>
        <div id="saveTmp" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
            <span>保存模板</span>
        </div>
        <input type="file" style="display: none" class="up-file" />
    </div>
    <%--content--%>
    <div class="tmp-con">
        <%--暂无模板展示--%>
        <div class="none-tmp">
            <img src="${staticRoot}/images/error.png" alt="">
            <div class="none-tmp-text">请添加模板...</div>
        </div>
    </div>
</div>