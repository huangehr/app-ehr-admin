<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>


<div id="div_wrapper">
    <input type="hidden" id="inp_mode" value='${mode}'/>
    <div class="div-header">
        <div class="div-title">
            题型选择
        </div>
        <div class="div-item" data-type="0">
            <img src="${staticRoot}/images/wenjuan_icon.png" width="24" height="24">
            <label class="div-item-title">单选题</label>
        </div>

        <div class="div-item" data-type="1">
            <img src="${staticRoot}/images/wenjuan_icon.png" width="24" height="24">
            <label class="div-item-title">多选题</label>
        </div>

        <div class="div-item" data-type="2">
            <img src="${staticRoot}/images/wenjuan_icon.png" width="24" height="24">
            <label class="div-item-title">问答题</label>
        </div>
    </div>
    <div class="div-wenjuan-title">
        <div class="question-title">
            <div class="position-relative" style="width: 100%;">
                <div class="qs-content edit-area edit-title div-template-name" contenteditable="true" data-value=""
                     style="max-height: 30px;overflow: auto; line-height: 30px;font-weight: bold;">这是问卷名称，点击可编辑</div>
            </div>
        </div>
        <div class="question-title" style="border-bottom: 0;">
            <div class="position-relative" style="width: 100%;">
                <div class="qs-content edit-area edit-title div-template-comment" contenteditable="true" data-value=""
                     style="max-height: 30px;overflow: auto;line-height: 30px;">这是问卷说明文字，点击可编辑</div>
            </div>
        </div>
    </div>
    <div class="div-right-header">
        <div class="div-right-empty">
            <div class="div-img"></div>
        </div>
        <div id="question_box" style="display: none;">

        </div>
    </div>


    <div class="div-bottom">
        <div class="div-btn-group">
            <input type="button" value="问题库导入" id="import_btn" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr60">
            <input type="button" value="批量添加" id="patch_add_btn" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr60">
            <input type="button" value="预览模板" id="preview_btn" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr60 cb-53BC4A">
            <input type="button" value="保存问题" id="save_btn" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam cb-F0AA23">
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

    <%-- 更多操作【选项设置】框--%>
    <div id="div_MoreDialog" class="u-public-manage m-form-inline" style="display: none;">
        <div style="margin: 10px 0px 0px 20px;" class="div-select-checkbox">
            <img src="${ctx}/static/develop/images/weigouxuan_icon.png" width="16" height="16" style="cursor: pointer;" class="">
            <label class="label_title">选项后添加选择框</label>
        </div>
        <div style="margin: 10px 0px 0px 20px;display:none;" class="div-input-checkbox">
            <img src="${ctx}/static/develop/images/yigouxuan_icon.png" width="16" height="16">
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

    <%-- 【问题必答设置】框--%>
    <div id="div_requred_Dialog" class="u-public-manage m-form-inline" style="display: none;">
        <div style="margin: 10px 0px 0px 20px;" class="div-select-checkbox">
            <img src="" width="16" height="16" style="cursor: pointer;" class="">
            <label class="label_title">问题必答</label>
        </div>
        <div class="m-form-group f-pa" style="right: 10px;bottom: 0;">
            <div class="m-form-control">
                <input type="button" value="确认" class="btn_confirm l-button u-btn u-btn-primary u-btn-large f-ib f-vam">
                <div class="btn_cancle l-button u-btn u-btn-cancel u-btn-large f-ib f-vam">
                    <span>取消</span>
                </div>
            </div>
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

    <%-- 逻辑设置框--%>
    <div id="div-luojiSettingDialog" class="u-public-manage m-form-inline" style="display: none;">
        <div style="height: 300px;overflow:auto;overflow-x: hidden;" class="div-luoji-content">
            <div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" data-role-form style='display: block;'>
                <div class="m-form-group f-mt10 div-setting-item f-dn">

                    <%--<div class="m-form-control f-fs12 f-ml10" style="position: relative;">--%>
                    <%--<div>--%>
                    <%--<span>如果本题中选中/填写</span>--%>
                    <%--<select class="allOptions"></select>--%>
                    <%--<span>则跳转到</span>--%>
                    <%--<select class="allQuestions"></select>--%>
                    <%--</div>--%>
                    <%--<div  class="delete-img f-dn">--%>
                    <%--</div>--%>
                    <%--</div>--%>

                    <%--<div class="m-form-control f-fs12 f-ml10" style="position: relative;">--%>
                    <%--<div>--%>
                    <%--<span>如果本题中填写任意内容，则跳转到</span>--%>
                    <%--<select  class="allQuestions"></select>--%>
                    <%--</div>--%>
                    <%--</div>--%>

                </div>
                <div class="m-form-group div-add-setting-bottom f-dn">
                    <div class="m-form-control f-fs12 f-ml10">
                        <div  class="add-img" style="background: url(${ctx}/static/develop/images/add_btn.png) no-repeat;width:25px;height: 22px;background-size: 22px;">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="f-pa div-bottom-group" style="right: 190px;bottom: 10px;">
            <div class="m-form-control">
                <input type="button" value="保存设置" class="btn_confirm l-button u-btn u-btn-primary u-btn-large f-ib f-vam">
                <div class="btn_cancle l-button u-btn u-btn-cancel u-btn-large f-ib f-vam f-ml10">
                    <span>关闭弹窗</span>
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
            最少选<input class="inp-min-value" style='width: 50px;padding:5px;' onkeyup='this.value=this.value.replace(/[^1-9]D*$/,"")' ondragenter='return false' onpaste='return false;'/>项,
            最多选<input class="inp-max-value" style='width: 50px;padding:5px;' onkeyup='this.value=this.value.replace(/[^1-9]D*$/,"")' ondragenter='return false' onpaste='return false;'/>项</div>
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

    <%-- 问题库导入框--%>
    <div id="div-importQuesDialog" style="display: none;">
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

    <%-- 问题预览框--%>
    <div id="div-previewQuestionDialog" class="u-public-manage m-form-inline" style="display: none;">
        <div class="div-preview-content">

        </div>
        <div class="" style="position: absolute;bottom: 10px;left: 160px;">
            <input type="button" value="返回修改" id="inp_back_update" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr60">
            <input type="button" value="保存问题" id="inp_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam cb-F0AA23">
        </div>
    </div>


</div>