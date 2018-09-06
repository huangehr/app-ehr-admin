<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="f-mb30">
    <div id="total" style="width: 30%;height: 300px; display: inline-block;"></div>
    <div id="serviceList" style="width: 65%;height: 300px; display: inline-block;"></div>
</div>

<div class="m-form-inline" id="searchForm">
    <div class="m-form-group f-mt10 f-mb10">
        <div class="m-form-control ">
            <input type="text" id="searchSn" placeholder="文件编号">
        </div>
        <div class="m-form-control f-ml10">
            <input type="text" id="searchName" placeholder="文件名">
        </div>
        <div class="m-form-control f-ml10">
            <div id="btnSearch" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-mr10" >
                <span>查询</span>
            </div>
        </div>

        <div id="dowloadUrl" class="m-form-control">
            <span>下载服务器域名：</span>
            <span id="defaultPublicUrl"></span>
            <span id="modifyPublicUrl">修改</span>
        </div>
    </div>

    <div id="grid"></div>
</div>
