<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div id="div_wrapper">
    <!-- 检索条件 -->
    <div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" data-role-form style='display: block;'>
        <div class="m-form-group f-mt10">
            <div class="m-form-control f-fs12 f-ml10">
                <input type="text" id="inp_searchNm" placeholder="标题">
            </div>
            <div class="m-form-control f-fs12 f-ml10">
                <input id="sel_status" placeholder="选择状态"/>
            </div>
            <div class="m-form-control m-form-control-fr f-mr20">
                <div class="div-pldelete-btn">
                    <div class="div-btn-text">批量删除</div>
                </div>
                <div class="div-add-btn">
                    <div class="div-btn-text">新增问题</div>
                </div>
            </div>
        </div>
    </div>
    <!-- 列表 -->
    <div id="div_question_list">

    </div>
</div>