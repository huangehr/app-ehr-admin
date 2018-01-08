<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="m-form-inline">
    <div id="conditionArea" class="f-mb10 f-mr10" align="right">
        <div class="body-head f-h30" align="left">
            <%--<a id="btn_back" class="f-fwb">返回上一层 </a>--%>
            <span>消息队列编码：${channel}</span>
        </div>
    </div>

    <div class="m-form-group f-mt10">
        <div class="m-form-control f-fs12">
            <input type="text" id="searchContent" placeholder="请输入发布者应用ID">
        </div>

        <div class="m-form-control m-form-control-fr">
            <sec:authorize url="/redis/mq/publisher/detail">
                <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam"
                     onclick="javascript:$.publish( 'redis:mq:publisher:detail', ['', 'new'] )">
                    <span>新增</span>
                </div>
            </sec:authorize>
        </div>
    </div>

    <div id="grid"></div>
</div>
