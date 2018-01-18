<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/static-dev/base/avalon/avalon2.js"></script>

<div class="charts-main" ms-controller="nrsApp">
    <div class="tab-con " data-id="">
        <%--上卷下砖--%>
        <div class="drill-list">
            <div class="dirll-item" id="dirllUp" ms-click="cUp" :class="downValArr.length > 0 ? 'active' : ''">
                <div class="triangle up-triangle"></div>上卷
                <div class="hover-show" ms-text="upVal()"></div>
            </div>
            <div class="dirll-item" id="dimensionName">
                <span ms-text="selVal == '' ? '分类' : selVal"></span>
                <div class="hover-show" ms-text="selVal == '' ? '分类' : selVal"></div>
            </div>
            <div class="dirll-item" id="dirllDown" ms-click="cSH" :class="downClass">
                <div class="triangle down-triangle"></div>下钻
                <div class="hover-show" :class="downClass" ms-text="dimensionMap.length != downValArr.length ? '请选择下钻数据' : '无下钻项'"></div>
                <ul class="dimension-list" ms-if="showDown && dimensionMap.length > 0">
                    <li class="dimension-item"
                        ms-for="($index, item) in @dimensionMap"
                        ms-if="item.isShow"
                        ms-text="item.value"
                        ms-click="cDown(item.key, item.value, $index)"
                    ></li>
                </ul>
            </div>
        </div>

        <div class="con-t-con">
            <%--goback--%>
            <div class="condition">
                <div class="nav ">下钻项：</div>
                <div class="nav ">
                    <ul>
                        <li id="cDropDown" ms-attr="{key:nowDimension[0]}"><a href="#" ms-text="getFirstVal()"></a></li>
                        <li ms-for="($index, item) in downKeyArr">&gt;<a href="#" ms-text="dimensionMap[item].value" ms-click="cLink(dimensionMap[item].key, $index)"></a> </li>
                    </ul>
                </div>
            </div>
            <%--charts--%>
            <div id="chart" style="width:748px;height: 403px"></div>
        </div>
    </div>
</div>