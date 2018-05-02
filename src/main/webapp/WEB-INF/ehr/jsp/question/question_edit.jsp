<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ include file="question_addCss.jsp" %>

<div id="div_question_info_form" class="m-form-inline f-mt20 f-ml10">
    <input type="hidden" id="questionId" value='${id}'/>
    <input type="hidden" id="type" value='${mode}'/>

    <div class="div-edit-question-content" style="height: 300px;overflow: auto;">

    </div>



    <div class="m-form-group f-pa" style="right: 191px;bottom: 0;">
        <div class="m-form-control">
            <input type="button" value="保存问题" id="btn_save-question" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" />
            <div id="btn_close" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
                <span>关闭弹窗</span>
            </div>
        </div>
    </div>
</div>

<%-- 更多操作框--%>
<div id="div_MoreDialog" class="u-public-manage m-form-inline" style="display: none;">
    <div style="margin: 10px 0px 0px 20px;" class="div-select-checkbox">
        <img src="${staticRoot}/images/weigouxuan_icon.png" width="16" height="16" style="cursor: pointer;" class="">
        <label class="label_title">选项后添加选择框</label>
    </div>
    <div style="margin: 10px 0px 0px 20px;display:none;" class="div-input-checkbox">
        <img src="${staticRoot}/images/yigouxuan_icon.png" width="16" height="16">
        <label class="label_title">填空框是否必填</label>
    </div>

    <div class="m-form-group f-pa" style="right: 10px;bottom: 0;">
        <div class="m-form-control">
            <input type="button" value="确认" class="btn_more_confirm l-button u-btn u-btn-primary u-btn-large f-ib f-vam">
            <div class="btn_more_cancle l-button u-btn u-btn-cancel u-btn-large f-ib f-vam">
                <span>取消</span>
            </div>
        </div>
    </div>
</div>

<div class="edit-child-element-content" style="display: none;">
    <div class="edit-img" contenteditable="false" style="width: 170px; ">
        <ul>
            <li class="handle-element handle-child-element" title="更多操作" onclick=""></li>
            <li class="handle-element remove-child-element" title="删除" onclick=""></li>
            <li class="handle-element up-child-element" title="上移" onclick=""></li>
            <li class="handle-element down-child-element" title="下移" onclick=""></li>
        </ul>
    </div>
</div>

<%-- 批量添加选项框--%>
<div id="div-patchDialog" class="u-public-manage m-form-inline" style="display: none;">
    <div class="label_title" style="padding-left: 10px;font-weight: bold;">每行代表一个选项，可以添加多个选项</div>
    <div class="choice-area"> <textarea class="batch-choices"></textarea> </div>
    <div class="required div-errorInfo" style="margin-left: 20px;"></div>
    <a style="float: right;margin-right: 15px;text-decoration: underline; color: #2D9BD2;" class="a-clear-text">清空文本框</a>
    <div class="m-form-group f-pa" style="right: 10px;bottom: 0;">
        <div class="m-form-control">
            <input type="button" value="确认" class="btn_patch_confirm l-button u-btn u-btn-primary u-btn-large f-ib f-vam">
            <div class="btn_patch_cancle l-button u-btn u-btn-cancel u-btn-large f-ib f-vam">
                <span>取消</span>
            </div>
        </div>
    </div>
</div>

<%-- 问题说明框--%>
<div id="div-instructionDialog" class="u-public-manage m-form-inline" style="display: none;">
    <div class="label_title" style="padding-left: 10px;font-weight: bold;">请输入问题说明，若为空，则不显示说明</div>
    <div class="choice-area"> <textarea class="batch-choices"></textarea> </div>
    <div class="m-form-group f-pa" style="right: 10px;bottom: 0;">
        <div class="m-form-control">
            <input type="button" value="确认" class="btn_confirm l-button u-btn u-btn-primary u-btn-large f-ib f-vam">
            <div class="btn_cancle l-button u-btn u-btn-cancel u-btn-large f-ib f-vam">
                <span>取消</span>
            </div>
        </div>
    </div>
</div>

<%-- 多选设置框--%>
<div id="div-duoxuanSettingDialog" class="u-public-manage m-form-inline" style="display: none;">
    <div style="margin-top: 40px;text-align: center;">
        最少选<input class="inp-min-value" style='width: 50px;padding:5px;'  ondragenter='return false' onpaste='return false;'/>项,
        最多选<input class="inp-max-value" style='width: 50px;padding:5px;'  ondragenter='return false' onpaste='return false;'/>项</div>
    <div class="required div-errorInfo" style="margin-top: 20px; text-align: center;"></div>
    <div class="m-form-group f-pa" style="right: 10px;bottom: 0;">
        <div class="m-form-control">
            <input type="button" value="确认" class="btn_confirm l-button u-btn u-btn-primary u-btn-large f-ib f-vam">
            <div class="btn_cancle l-button u-btn u-btn-cancel u-btn-large f-ib f-vam">
                <span>取消</span>
            </div>
        </div>
    </div>
</div>

<%-- 批量添加问题框--%>
<div id="div-patchAddQuestionDialog" class="u-public-manage m-form-inline" style="display: none;">
    <div style="margin: 10px 20px 0;">
        <div class="div-header-content">1、第一行为题目，中间不要换行</div>
        <div class="div-header-content">2、回车后，下一行开始为选项行，选项不要空行，选项前面不要加数字，一个选项单独一行</div>
        <div class="div-header-content">3、选项结束后，一个空行，表示问题的结束，换下一个新问题</div>
        <div class="div-header-content">4、如果下面没有选项，直接空一行，默认为问答题</div>
        <textarea style="width: 560px;height: 340px;padding:10px 20px;margin-top: 20px;" class="div-patch-textarea">

			</textarea>
    </div>
    <a style="float: right;margin-right: 15px;text-decoration: underline; color: #2D9BD2;" class="a-clear-text">清空文本框</a>
    <div class="m-form-group f-pa" style="right: 250px;bottom: 0;">
        <div class="m-form-control">
            <input type="button" value="确定" class="btn_confirm l-button u-btn u-btn-primary u-btn-large f-ib f-vam">
        </div>
    </div>
</div>