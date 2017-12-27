<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<%@ include file="schinfoCss.jsp" %>

<div class="containBox">
    <%--<div class="div_title">--%>
        <%--排班信息--%>
    <%--</div>--%>

    <div class="base_info" ms-controller="avacontroller">
        <div class=" basis">
            <div class="main_info .p-t40">
                基本信息
            </div>
            <div class="main_info_kid">
                <div class="kid_ particular">
                    <span class="span_left">日&#12288;&#12288;期</span><span class="span_right"><input disabled="disabled" value="2011-11" id="date"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">车&#8194;牌&#8194;号</span><span class="span_right"><input disabled="disabled" value="赣E12012" id="car"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">主/付班&#8194;</span><span class="span_right"><input disabled="disabled" value="主车" id="main"></span>
                </div>
            </div>
        </div>
        <div class=" basis" ms-repeat-item="data">
            <div class="main_info">
                <a ms-if="item.dutyRole == '医生'">医生信息</a>
                <a ms-if="item.dutyRole == '护士'">护士信息</a>
                <a ms-if="item.dutyRole == '司机'">司机信息</a>
            </div>
            <form class="main_info_kid" ms-attr-id="'form'+item.id">
                <div class="kid_ particular">
                    <span class="span_left">姓&#12288;&#12288;名</span><span class="span_right"><input disabled="disabled" ms-attr-value="item.dutyName" class="mayEdit" name="dutyName"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">性&#12288;&#12288;别</span><span class="span_right"><select class="sex" ms-attr-id="item.id" name="gender"><option grade="1" value="1">男</option><option grade="2" value="2">女</option></select></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">工&#12288;&#12288;号</span><span class="span_right"><input disabled="disabled" ms-attr-value="item.dutyNum" class="mayEdit" name="dutyNum"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left" >手机号码</span><span class="span_right"><input disabled="disabled" ms-attr-value="item.dutyPhone" class="mayEdit" name="dutyPhone"></span>
                </div>
            </form>
        </div>

        <%--<div class=" basis">--%>
            <%--<div class="main_info .p-t40">--%>
                <%--基本信息 ${date}--%>
            <%--</div>--%>
            <%--<div class="main_info_kid">--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">日&#12288;&#12288;期</span><span class="span_right"><input disabled="disabled" value="2011-11"></span>--%>
                <%--</div>--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">归属地点</span><span class="span_right"><input disabled="disabled" value="第一医院"></span>--%>
                <%--</div>--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">车&#8194;牌&#8194;号</span><span class="span_right"><input disabled="disabled" value="赣E12012"></span>--%>
                <%--</div>--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">主/付班&#8194;</span><span class="span_right"><input disabled="disabled" value="主车"></span>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div class=" basis" >--%>
            <%--<div class="main_info">--%>
                <%--医生信息--%>
            <%--</div>--%>
            <%--<div class="main_info_kid">--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">姓&#12288;&#12288;名</span><span class="span_right"><input disabled="disabled" value="文彬"></span>--%>
                <%--</div>--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">性&#12288;&#12288;别</span><span class="span_right"><input disabled="disabled" value="女"></span>--%>
                <%--</div>--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">身份证号</span><span class="span_right"><input disabled="disabled" value="13859288248"></span>--%>
                <%--</div>--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">手机号码</span><span class="span_right"><input disabled="disabled" value="13859288248"></span>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div class=" basis">--%>
            <%--<div class="main_info">--%>
                <%--护士信息--%>
            <%--</div>--%>
            <%--<div class="main_info_kid">--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">姓&#12288;&#12288;名</span><span class="span_right"><input disabled="disabled" value="文彬"></span>--%>
                <%--</div>--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">性&#12288;&#12288;别</span><span class="span_right"><input disabled="disabled" value="女"></span>--%>
                <%--</div>--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">身份证号</span><span class="span_right"><input disabled="disabled" value="13859288248"></span>--%>
                <%--</div>--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">手机号码</span><span class="span_right"><input disabled="disabled" value="13859288248"></span>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div class=" basis">--%>
            <%--<div class="main_info">--%>
                <%--司机信息--%>
            <%--</div>--%>
            <%--<div class="main_info_kid">--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">姓&#12288;&#12288;名</span><span class="span_right"><input disabled="disabled" value="文彬"></span>--%>
                <%--</div>--%>
                <%--<div class="kid_ particular">--%>
                    <%--<span class="span_left">性&#12288;&#12288;别</span><span class="span_right"><input disabled="disabled" value="女"></span>--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
            <div class="edio_btn">
                <input type="button" value="编辑"  id="edit"/>
                <input type="button" value="关闭" id = "cancel"/>
            </div>
    </div>
</div>
<%@ include file="schinfoJs.jsp" %>
