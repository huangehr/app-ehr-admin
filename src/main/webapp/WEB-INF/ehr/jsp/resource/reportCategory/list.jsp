<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div data-head-title="true">资源报表分类</div>

<div class="m-retrieve-area f-h50 f-pr m-form-inline">
    <div class="m-form-group f-mt10">
        <div class="m-form-control f-fs12">
            <input type="text" id="searchNm" placeholder="请输入代码或者名称">
        </div>

        <div class="m-form-control m-form-control-fr">
            <sec:authorize url="/resource/reportCategory/">
                <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam"
                     onclick="javascript:$.publish( 'resource:reportCategory:open', ['', 'new'] )">
                    <span>新增</span>
                </div>
            </sec:authorize>
        </div>
    </div>
</div>

<div id="grid"></div>
