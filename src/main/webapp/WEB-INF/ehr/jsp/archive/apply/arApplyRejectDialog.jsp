<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_std_info_form" data-role-form class="m-form-inline f-mt20 f-ml26" data-role-form>
    <h3 style="margin:0px 0 18px 35%;font-weight: bold;font-size:35px;">明细 - 审批不通过</h3>
    <div class="div-apply-msg f-audit-fw50">
        <fieldset class="fie-bd">
            <legend class="f-pl10 f-pr10"><b>申请信息</b></legend>
            <div id="div_apply_form" data-role-form class="m-form-inline">
                <div class="m-form-group m-form-readonly">
                    <label>姓名:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_name" class="f-matching-bd" data-attr-scan="name"/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly">
                    <label>身份证号:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_idCard" class="f-matching-bd" data-attr-scan="idCard"/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly">
                    <label>就诊时间:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_apply_analyse_time" class="f-matching-bd" data-attr-scan="visDate"/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly">
                    <label>就诊机构:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text"  id="inp_apply_analyse_org" class="f-matching-bd" data-attr-scan="visOrg"/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly">
                    <label>就诊医生:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text"  id="inp_apply_analyse_doctor" class="f-matching-bd" data-attr-scan="visDoctor"/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly">
                    <label>医疗卡号:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text"  id="inp_apply_card_nmuber" class="f-matching-bd" data-attr-scan="cardNo"/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly">
                    <label>就诊结果:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_apply_analyse_out" class="f-matching-bd" data-attr-scan="diagnosedResult"/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly">
                    <label>检查项目:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_apply_examine_pro"  class="f-matching-bd" data-attr-scan="diagnosedProject"/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly">
                    <label>诊断开药:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_apply_analyse_drug" class="f-matching-bd" data-attr-scan="medicines"/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly">
                    <label>备注:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_apply_remark" class="f-matching-bd"  data-attr-scan="memo"/>
                    </div>
                </div>
            </div>
        </fieldset>
    </div>
    <div class="div-apply-msg f-audit-fw50" style="margin-top: 10px;">
        <fieldset class="fie-bd">
            <legend class="f-pl10 f-pr10"><b>不通过原因</b></legend>
                <div class="m-form-group m-form-readonly">
                    <div class="l-text-wrapper m-form-control">
                        <textarea id="audit_reason" class="f-matching-bd" data-attr-scan="auditReason"/>
                    </div>
                </div>
        </fieldset>
    </div>
    <%--<div class="m-form-group f-pa" style="bottom: 10px;right: 10px;">--%>
        <%--<div class="m-form-control">--%>
            <%--<div id="btn_ok" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >--%>
                <%--<span>确定</span>--%>
            <%--</div>--%>
        <%--</div>--%>
    <%--</div>--%>
</div>

