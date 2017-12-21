<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="m-form-inline">
    <div class="m-form-group f-mt10">
        <div class="m-form-control f-fs12">
            <input type="text" id="searchContent" placeholder="请输入机构类型编码或名称">
        </div>

        <div class="m-form-control m-form-control-fr">
            <sec:authorize url="/org/typeCategory/detail">
                <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam"
                     onclick="javascript:$.publish( 'org:typeCategory:detail', ['', 'new'] )">
                    <span>新增</span>
                </div>
            </sec:authorize>
        </div>
    </div>

    <div id="grid"></div>
</div>
