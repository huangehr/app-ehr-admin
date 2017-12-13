<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .containBox {
        width: 1408px;
        height: 950px;
    }

    .div_title {
        color: #30A9DE;
        font-size: 16px;
        padding-top: 30px;
        padding-left: 60px;
        background-position: 1374px 20px;
    }

    .base_info {
        padding-left: 130px;
        height: auto;
    }

    .main_info {
        padding-bottom: 20px;
        border-bottom: 2px solid #EDF0F0;
    }

    .main_info_kid {
        padding-top: 20px;
    }

    .main_info_kid>div {
        padding: 7px 20px;
    }

    .particular>span:nth-of-type(2) {
        margin-left: 70px;
    }

    .basis>div:first-child {
        padding-top: 15px;
    }

    .edio_btn {
        width: 250px;
        margin: 10px auto;
    }

    .edio_btn>input {
        width: 110px;
        height: 34px;
    }

    .edio_btn input:nth-of-type(1) {
        background: #30A9DE;
        color: #FFFFFF;
        border: 1px solid #E8ECEB;
        border-radius: 3px;
    }

    .edio_btn>input:nth-of-type(2) {
        background: #FFFFFF;
        color: #323232;
        border: 1px solid #E8ECEB;
        border-radius: 3px;
        margin-left: 20px;
    }
</style>
<div class="containBox">

    <div class="div_title">
        排班信息
    </div>
    <div class="base_info">
        <div class=" basis">
            <div class="main_info .p-t40">
                基本信息${id}
            </div>
            <div class="main_info_kid">
                <div class="kid_ particular">
                    <span class="span_left">日&#12288;&#12288;期</span><span class="span_right"><input disabled="disabled" value="2011-11"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">归属地点</span><span class="span_right"><input disabled="disabled" value="第一医院"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">车&#8194;牌&#8194;号</span><span class="span_right"><input disabled="disabled" value="赣E12012"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">主/付班&#12288;</span><span class="span_right"><input disabled="disabled" value="主车"></span>
                </div>
            </div>
        </div>
        <div class=" basis">
            <div class="main_info">
                医生信息
            </div>
            <div class="main_info_kid">
                <div class="kid_ particular">
                    <span class="span_left">姓&#12288;&#12288;名</span><span class="span_right"><input disabled="disabled" value="文彬"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">性&#12288;&#12288;别</span><span class="span_right"><input disabled="disabled" value="女"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">身份证号</span><span class="span_right"><input disabled="disabled" value="13859288248"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">手机号码</span><span class="span_right"><input disabled="disabled" value="13859288248"></span>
                </div>
            </div>
        </div>
        <div class=" basis">
            <div class="main_info">
                护士信息
            </div>
            <div class="main_info_kid">
                <div class="kid_ particular">
                    <span class="span_left">姓&#12288;&#12288;名</span><span class="span_right"><input disabled="disabled" value="文彬"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">性&#12288;&#12288;别</span><span class="span_right"><input disabled="disabled" value="女"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">身份证号</span><span class="span_right"><input disabled="disabled" value="13859288248"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">手机号码</span><span class="span_right"><input disabled="disabled" value="13859288248"></span>
                </div>
            </div>
        </div>
        <div class=" basis">
            <div class="main_info">
                司机信息
            </div>
            <div class="main_info_kid">
                <div class="kid_ particular">
                    <span class="span_left">姓&#12288;&#12288;名</span><span class="span_right"><input disabled="disabled" value="文彬"></span>
                </div>
                <div class="kid_ particular">
                    <span class="span_left">性&#12288;&#12288;别</span><span class="span_right"><input disabled="disabled" value="女"></span>
                </div>
            </div>
        </div>
        <div class=" basis">
            <div class="edio_btn">
                <input type="button" value="编辑"  id=""/>
                <input type="button" value="关闭" />
            </div>
        </div>
    </div>
</div>