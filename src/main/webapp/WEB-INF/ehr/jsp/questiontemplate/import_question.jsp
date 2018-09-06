<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ include file="edit_templateCss.jsp" %>

<div id="div_question_info_form" class="m-form-inline f-mt20 f-ml10">
    <!-- 检索条件 -->
    <div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" data-role-form style='display: block;'>
        <div class="m-form-group f-mt10">
            <div class="m-form-control f-fs12 f-ml10">
                <input type="text" id="inp_searchNm" placeholder="标题">
            </div>
            <div class="m-form-control f-fs12 f-ml10">
                <input id="sel_status" placeholder="选择状态"/>
            </div>
            <div class="m-form-control m-form-control-fr">
                <input type="button" value="批量导出" id="patch_import_btn" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr60">
            </div>
        </div>
    </div>
    <!-- 列表 -->
    <div id="div_question_list" class="f-ml10">

    </div>
</div>
<%-- 问题库导入的预览问题框--%>
<div id="div-seeQuestionDialog" class="m-form-inline f-mt20 f-ml10" style="display: none;">
    <div class="div-see-question-content" style="height: 300px;overflow: auto;">

    </div>



    <div class="m-form-group f-pa" style="right: 10px;bottom: 0;">
        <div class="m-form-control">
            <div id="btn_close" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
                <span>关闭弹窗</span>
            </div>
        </div>
    </div>
</div>