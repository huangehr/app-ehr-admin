<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div>
    <div id="categoryMemoryRate" style="width: 600px;height: 300px; display: inline-block;"></div>
    <div id="cacheKeys" style="width: 600px;height: 300px; display: inline-block;"></div>
</div>

<div class="m-form-inline">
    <div class="m-form-group f-mt10 f-mb10">
        <div class="m-form-control ">
            <input type="text" id="searchContent" placeholder="请输入规则名称或编码">
        </div>
        <div class="m-form-control f-ml10">
            <input type="text" data-type="select" id="searchCategoryCode" placeholder="缓存分类">
        </div>
        <div class="m-form-control f-ml10">
            <div id="btnSearch" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-mr10" >
                <span>查询</span>
            </div>
        </div>

        <div class="m-form-control m-form-control-fr">
            <sec:authorize url="/redis/cache/keyRule/detail">
                <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam"
                     onclick="javascript:$.publish( 'redis:cache:keyRule:detail', ['', 'new'] )">
                    <span>新增</span>
                </div>
            </sec:authorize>
        </div>
    </div>

    <div id="grid"></div>
</div>
