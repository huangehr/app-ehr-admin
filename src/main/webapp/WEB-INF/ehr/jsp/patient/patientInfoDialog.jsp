<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="pop_tab">
    <ul>
        <li class="cur" id="btn_basic">基础属性</li>
        <%--<li id="btn_card" >卡管理</li>--%>
        <%--<li id="btn_archive" >档案管理</li>--%>
        <%--<li id="btn_home_relation" >家庭关系</li>--%>

    </ul>
</div>
<!--######人口管理页面 > 人口信息对话框模板页######-->
<div id="div_patient_info_form" data-role-form class="m-form-inline f-mt20" style="overflow:auto">
    <div>
        <div id="div_patient_img_upload" class="u-upload alone f-ib f-tac f-vam u-upload-img" data-alone-file=true>
            <!--用来存放item-->
            <div id="div_file_list" class="uploader-list"></div>
            <div id="div_file_picker" class="f-mt10"><spring:message code="btn.file.choose"/></div>
        </div>
        <div class="m-form-group">
            <label>姓名：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_realName" class="required useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>身份证号：</label>

            <div class="l-text-wrapper m-form-control essential ">
                <input type="text" id="inp_idCardNo" class="required useTitle ajax validate-id-number"  validate-id-number-title="请输入合法的身份证号"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="idCardNo"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>性别：</label>

            <div class="u-checkbox-wrap m-form-control ">
                <input type="radio" value="1" name="gender" data-attr-scan>男
                <input type="radio" value="2" name="gender" data-attr-scan>女
            </div>
        </div>
        <div class="m-form-group ">
            <label>民族：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_patientNation" data-type="select" class="required useTitle"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="nation"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>籍贯：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_patientNativePlace" class="required useTitle max-length-100 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="nativePlace"/>
            </div>
        </div>
        <div class="m-form-group">
            <label>婚姻状况：</label>

            <div class="m-form-control ">
                <input type="text" id="inp_select_patientMartialStatus" data-type="select"
                       data-attr-scan="martialStatus">
            </div>
        </div>
        <div class="m-form-group">
            <label>出生日期：</label>

            <div class="m-form-control">
                <input type="text" id="inp_patientBirthday" class="validate-date  l-text-field " placeholder="输入日期 格式(2016-04-15)"
                       required-title=<spring:message code="lbl.must.input"/> data-attr-scan="birthday"/>
            </div>
        </div>

        <div class="m-form-group">
            <label>户籍地址：</label>

            <div class="m-form-control f-w240">
                <input type="text" id="inp_birthPlace" class="validate-special-char" data-type="comboSelect" data-attr-scan="birthPlaceInfo">
            </div>
        </div>

        <div class="m-form-group">
            <label>家庭地址：</label>

            <div class="m-form-control f-w240">
                <input type="text" id="inp_homeAddress" class="validate-special-char" data-type="comboSelect"
                       data-attr-scan="homeAddressInfo"/>
            </div>
        </div>
        <div class="m-form-group">
            <label>工作地址：</label>

            <div class="m-form-control f-w240">
                <input type="text" id="inp_workAddress" class="validate-special-char"  data-type="comboSelect"
                       data-attr-scan="workAddressInfo"/>
            </div>
        </div>
        <div class="m-form-group">
            <label>户籍性质：</label>

            <div class="u-checkbox-wrap m-form-control">
                <input type="radio" value="temp" name="residenceType" data-attr-scan>农村
                <input type="radio" value="usual" name="residenceType" data-attr-scan>非农村
            </div>
        </div>
        <div class="m-form-group">
            <label>联系方式：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_patientTel" class="required useTitle validate-mobile-phone"  required-title=<spring:message code="lbl.must.input"/> validate-mobile-phone-title="请输入正确的手机号码" data-attr-scan="telephoneNo"/>
            </div>
        </div>
        <div class="m-form-group">
            <label>邮箱：</label>

            <div class="l-text-wrapper m-form-control">
                <input type="text" id="inp_patientEmail" class="useTitle validate-email max-length-50 validate-special-char" validate-email-title="请输入正确的邮箱" placeholder="请输入邮箱" data-attr-scan="email"/>
            </div>
        </div>
        <div class="m-form-group f-mt20" id="reset_password">
            <hr class="u-border">
            <div class="f-pr u-bd" style="display: none">
                <div class="f-pa f-w40 f-wtl">
                    高级
                </div>
                <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mt10 f-mb10 f-ml100" id="div_resetPassword">
                    <span>重置密码</span>
                </div>
            </div>
        </div>
    </div>

    <div class="m-form-control pane-attribute-toolbar">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" id="div_update_btn">
            <span>保存</span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
            <span>关闭</span>
        </div>
    </div>
    <input type="hidden" id="inp_patientCopyId">
</div>

<!--######卡管理 > 卡信息对话框模板页######-->
<div id="div_card_info" data-role-form class="m-form-inline">
    <div class="f-pr u-bd f-mt20">
        <div class="f-pa f-w90 f-wtl">
            已关联卡
        </div>
        <div class="f-mt30">
            <div class="f-ml10 f-fl">
                <input type="text" id="inp_select_cardType" placeholder="类型" data-type="select" data-attr-scan="">
            </div>
            <div class="f-ml10 f-fl">
                <input type="text" id="inp_card_search" placeholder="卡号"/>
            </div>
            <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam  f-ml50" id="div_addCard">
                <span>关联卡</span>
            </div>

            <div id="div_card_info_form" data-role-form class="f-mt10">

                <!--卡基本信息 -->
                <div id="div_card_basicMsg" class="u-card-basicMsg m-form-inline m-form-readonly">
                    <div class="m-form-group">
                        <label>类型：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_cardType" class="required useTitle" data-attr-scan="cardType"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>卡号：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_cardNo" class="required useTitle" data-attr-scan="number"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>持有人姓名：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_HolderName" class="required useTitle"
                                   data-attr-scan="ownerName"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>发行地：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_issueAddress" class="required useTitle" data-attr-scan="local"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>发行机构：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_issueOrg" class="required useTitle" data-attr-scan="releaseOrgName"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>关联时间：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_addDate" class="required useTitle" data-attr-scan="createDate"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>状态：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_cardStatus" class="required useTitle"
                                   data-attr-scan="statusName"/>
                        </div>
                    </div>
                    <div class="m-form-group">
                        <label>说明：</label>

                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_cardExplain" class="required useTitle"
                                   data-attr-scan="description"/>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<!--######档案管理 > 档案信息对话框模板页######-->
<div id="div_archive_info" data-role-form class="m-form-inline" >
    <div class="f-pr u-bd f-mt20">
        <div class="f-pa f-w90 f-wtl">
            已关联档案
        </div>
        <div class="f-mt20">
            <div class="f-ml10 f-fl">
                <input type="text" id="inp_select_start" placeholder="时间" data-type="select" data-attr-scan="">
            </div>
            <div class="f-ml10 f-fl">
                <input type="text" id="inp_select_end" placeholder="时间" data-type="select" data-attr-scan="">
            </div>
            <div class="f-ml10 f-fl f-mt10 f-w240">
                <input type="text" id="inp_select_archiveOrg" placeholder="就诊机构" data-type="select" data-attr-scan="">
            </div>
            <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam  f-ml100 f-mt10" id="div_search_archive">
                <span>搜索</span>
            </div>
            <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam  f-ml30 f-mt10" id="div_add_archive">
                <span>关联档案</span>
            </div>

            <div id="div_archive_info_form" data-role-form class="f-mt10">

            </div>
        </div>
    </div>
</div>

<div id="div_home_relation" data-role-form class="m-form-inline" >

</div>
