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
            <div class="m-form-control m-form-control-fr f-ml20">
                <div class="div-add-btn">
                    <div class="div-btn-text">新增模板</div>
                </div>
            </div>
        </div>
    </div>
    <!-- 列表 -->
    <div id="div_question_list">

    </div>
</div>


<%-- 查看问卷框--%>
<div id="div-seeQuestionDialog" class="u-public-manage m-form-inline" style="display: none;">
    <div class="div-see-content">


    </div>

    <div class="" style="position: absolute;bottom: 10px;left: 105px;">
        <input type="button" value="引用模板" id="appoint_btn" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr60 cb-53BC4A">
        <input type="button" value="修改模板" id="inp_back_update" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr60">
        <input type="button" value="关闭弹窗" id="inp_close" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam cb-F0AA23">
    </div>
</div>
