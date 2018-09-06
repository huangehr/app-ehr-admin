<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/8/21
  Time: 15:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="rf-main">
    <%--左--%>
    <div class="rf-con rf-left">
        <%--搜索--%>
        <div class="rf-tit l-tit">
            <input type="text" value="" id="searchInp" />
        </div>
        <%--树--%>
        <div class="rf-tree" style="height: 376px">
            <div id="leftTree"></div>
        </div>
    </div>

    <div class="arrow"></div>

    <%--右--%>
    <div class="rf-con rf-right">
        <%--title--%>
        <div class="rf-tit r-tit">
            配置
        </div>
        <%--树--%>
        <div class="rf-tree" style="height: 376px">
            <div id="rightTree"></div>
        </div>
    </div>
    <%--按钮--%>
    <div id="saveBtn" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
        <span>保存</span>
    </div>
</div>