<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div id="div_std_info_form" data-role-form class="m-form-inline f-mt20 f-ml26" data-role-form>
    <div class="div-apply-msg f-audit-fw50">
        <div class="m-form-group m-form-readonly">
            <label>姓名:</label>
            <div class="l-text-wrapper m-form-control">
                <input type="text" id="inp_name" class="f-matching-bd" data-attr-scan="name"/>
            </div>
            <label>身份证号:</label>
            <div class="l-text-wrapper m-form-control">
                <input type="text" id="inp_idCard" class="f-matching-bd" data-attr-scan="idCard"/>
            </div>
            <label>医疗卡号:</label>
            <div class="l-text-wrapper m-form-control">
                <input type="text"  id="inp_apply_card_nmuber" class="f-matching-bd" data-attr-scan="cardNo"/>
            </div>
        </div>
        <div class="m-form-group m-form-readonly">
            <label>就诊时间:</label>
            <div class="l-text-wrapper m-form-control">
                <input type="text" id="inp_apply_analyse_time" class="f-matching-bd" data-attr-scan="visDate"/>
            </div>
            <label>就诊机构:</label>
            <div class="l-text-wrapper m-form-control">
                <input type="text"  id="inp_apply_analyse_org" class="f-matching-bd" data-attr-scan="visOrg"/>
            </div>
            <label>就诊医生:</label>
            <div class="l-text-wrapper m-form-control">
                <input type="text"  id="inp_apply_analyse_doctor" class="f-matching-bd" data-attr-scan="visDoctor"/>
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

        <div class="m-form-group">
            <label>理由:</label>
            <div class="l-text-wrapper m-form-control">
                <textarea type="text" id="inp_apply_reason"  class="f-matching-bd"  data-attr-scan="auditReason"/>
            </div>
        </div>
    </div>

    <!--######辅助审核档案信息列表######-->
    <div id="div_archive_audit_grid">

    </div>



    <div class="m-form-group f-pa" style="bottom: 10px;right: 10px;">
        <div class="m-form-control">
            <div id="btn_audit" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
                <span>通过</span>
            </div>
        </div>
        <div class="m-form-control">
            <div id="btn_reject" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
                <span>拒绝</span>
            </div>
        </div>
        <div class="m-form-control">
            <div id="btn_help" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
                <span>辅助审核</span>
            </div>
        </div>
    </div>


</div>

