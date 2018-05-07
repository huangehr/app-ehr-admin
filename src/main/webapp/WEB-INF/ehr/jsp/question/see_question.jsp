<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ include file="question_addCss.jsp" %>
<style>
    body{height: initial;}
    .div-item{margin:10px 20px 20px;border: 1px solid #dcdcdc;}
    .c-border-top{border-top:1px solid #dcdcdc;}
    .c-323232{color: #323232}
    .div-padding{padding:5px 10px 5px;}
    .c-red{color:red}
    .input-text{margin-left:10px;width:240px;padding:5px}
    .max-input-text{width: 470px;padding: 5px;border: 0;}
    .div-textarea{width: 328px;height: 50px;padding: 5px;}
    .pt10{padding-top: 10px;}
    .p10{padding:10px}
    .label_title{font-weight: initial;}
</style>
<div id="div_question_info_form" class="m-form-inline f-mt20 f-ml10">
    <input type="hidden" id="questionId" value='${id}'/>
    <input type="hidden" id="type" value='${type}'/>

    <div class="div-see-question-content" style="height: 300px;overflow: auto;">

    </div>



    <div class="m-form-group f-pa" style="right: 10px;bottom: 0;">
        <div class="m-form-control">
            <%--<input type="button" value="编辑问题" id="btn_edit-question" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" />--%>
            <div id="btn_close" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
                <span>关闭弹窗</span>
            </div>
        </div>
    </div>
</div>