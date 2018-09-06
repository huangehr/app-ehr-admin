<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div id="div_wrapper">
    <input type="hidden" id="inp_mode" value='${mode}'/>
    <input type="hidden" id="inp_template_id" value='${templateId}'/>
    <div class="div-prev f-dn">
        <div class="f-pr f-mt160 div-type" data-type="1">
            <div class="div-radio-img active"></div>
            <div class="position-relative">
                <div>创建空白模板</div>
            </div>
        </div>

        <div class="f-mt20 f-pr div-type" data-type="2">
            <div class="div-radio-img"></div>
            <div class="position-relative">
                <div>引用已有模板</div>
                <div class="div-combox">
                    <select class="js-example-data-array sel-adapter-metadata-code"  id="sel_wenjuan"  style="width:180px;display: none;"></select>
                </div>
            </div>

        </div>
    </div>

    <div class="div-next f-dn">
        <div id="div-form" data-role-form class="m-form-inline f-mt20">
            <div class="m-form-group">
                <label>问卷名称</label>
                <div class="l-text-wrapper m-form-control essential">
                    <input type="text" id="inp_wenjuan_name" class="required ajax useTitle" required-title="问卷名称不能为空">
                </div>
            </div>
            <div class="m-form-group">
                <label>问卷说明</label>
                <div class="m-form-control essential">
                    <textarea id="tea_wenjuan_instruction" class="div-textarea f-w240 required ajax useTitle" required-title="问卷说明不能为空" maxlength="500"></textarea>
                </div>
            </div>
            <div class="m-form-group">
                <label>问卷标签</label>
                <div class="l-text-wrapper m-form-control div-label-content">

                </div>
            </div>
        </div>
    </div>

    <div class="div-bottom f-tac">
        <input type="button" value="上一步" id="pre_btn" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr60 f-dn">
        <input type="button" value="下一步" id="next_btn" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr60 f-ml20">
    </div>
</div>
