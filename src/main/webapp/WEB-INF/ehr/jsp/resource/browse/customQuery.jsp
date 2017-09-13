<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>


<div class="query-main">
    <%--按钮组--%>
    <div class="query-btns">
        <div class="query-change">
            <div class="chang-btn cb-right active">档案数据</div>
            <div class="chang-btn cb-left">指标统计</div>
        </div>
        <ui class="single-btns">
            <li class="single-btn query-con">查询</li>
            <li class="single-btn gen-view">生成视图</li>
            <li class="single-btn out-exc">导出</li>
        </ui>
    </div>
    <div class="screen-con">
        <div class="sc-btn">展开筛选<i class="icon-xiala"></i></div>
    </div>

    <%--树--%>
    <div class="query-tree">
        <div class="m-form-control ser-con">
            <input type="text" id="searchInp" placeholder="请输入名称">
        </div>
        <div class="tree-con">
            <div id="divLeftTree" style="padding: 10px;"></div>
        </div>
    </div>

    <%--查询条件&表格--%>
    <div class="query-conc">
        <%--查询条件--%>
        <div class="select-con" style="display: none">

            <div class="pub-sel">
                <%--固定条件--%>
            </div>

            <div class="sel-item time">
                <span class="sel-lab">期间: </span>
                <ul class="con-list">
                    <li class="con-item ci-inp">
                        <input type="text" id="startDate">
                    </li>
                    <li class="con-item ci-inp">
                        <input type="text" id="endDate">
                    </li>
                </ul>
            </div>

            <div class="sel-more">
                <%--动态条件--%>
            </div>

        </div>
        <%--表格--%>
        <div>
            <div id="divResourceInfoGrid"></div>
            <div id="zbGrid" style="display: none"></div>
        </div>
    </div>
</div>

<script type="text/html" id="selTmp">
    <div class="sel-item" data-parent-code="{{pCode}}" data-code-list="">
        <span class="sel-lab">{{label}}: </span>
        <ul class="con-list">
            {{content}}
        </ul>
        <div class="show-more">
            <div class="sc-btn sw-w">更多<i class="icon-xiala"></i></div>
        </div>
    </div>
</script>









