<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="charts-main">
    <ul class="tab-list">
        <%--Tabs--%>
    </ul>
    <%--<div class="tab-con">--%>
        <%--<div class="con-tab">--%>
            <%--<ul class="con-t-t">--%>
                <%--<li class="con-t-i c-t-lef active">展示</li>--%>
                <%--<li class="con-t-i c-t-right">查询</li>--%>
            <%--</ul>--%>
        <%--</div>--%>
        <%--<div class="con-t-con">--%>
            <%--<div class="condition">--%>
                <%--<a href="javascript:;" class="go-back">&lt; &nbsp;上卷</a>--%>
            <%--</div>--%>
            <%--<div></div>--%>
        <%--</div>--%>
        <%--<div class="con-t-con un-show">--%>
            <%--<div class="condition">--%>
                <%--<input type="checkbox" name="che1" value="1"/>选项1--%>
                <%--<input type="checkbox" name="che1" value="2"/>选项2--%>
                <%--<input type="checkbox" name="che1" value="3"/>选项3--%>
                <%--<input type="checkbox" name="che1" value="4"/>选项4--%>
            <%--</div>--%>
            <%--&lt;%&ndash;charts&ndash;%&gt;--%>
            <%--<div id="chartsMain" style="width:748px;height: 403px"></div>--%>
        <%--</div>--%>
    <%--</div>--%>
</div>

<script type="text/html" id="tabTmp">
    <div class="tab-con {{class}}" data-id="{{id}}">
        <div class="con-tab">
            <ul class="con-t-t">
                <li class="con-t-i c-t-lef active">展示</li>
                <li class="con-t-i c-t-right">查询</li>
            </ul>
        </div>
        <div class="con-t-con">
            <%--goback--%>
            <div class="condition" data-quota-filter="" data-list="{{dimension}}" data-num="0">
                <a href="javascript:;" class="go-back un-show">&lt; &nbsp;上卷</a>
            </div>
            <%--charts--%>
            <div id="{{idOne}}" style="width:748px;height: 403px"></div>
        </div>
        <div class="con-t-con un-show">
            <%--checkedbox--%>
            <div class="condition">
                {{checkboxs}}
            </div>
            <%--charts--%>
            <div id="{{idTwo}}" style="width:748px;height: 403px"></div>
        </div>
    </div>
</script>