<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="div_std_info_form" data-role-form class="m-form-inline f-mt20 f-ml26" data-role-form>
    <h3 style="margin:0px 0 18px 40%;font-weight: bold;font-size:35px;">审批已通过</h3>
    <div class="div-apply-msg f-audit-fw100 f-fl">
        <fieldset class="fie-bd">
            <legend class="f-pl10 f-pr10"><b>申请信息</b></legend>
            <div id="div_apply_form" data-role-form class="m-form-inline">
                <div class="m-form-group m-form-readonly">
                    <label>就诊时间:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_apply_analyse_time" class="f-matching-bd" data-attr-scan="applyDate"/>
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
                    <label>卡号:</label>
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
            <fieldset class="fie-bd" style="margin: -333px 10px 0px 0px;float: right">
            <legend class="f-pl10 f-pr10"><b>关联档案</b></legend>
            <div class="f-fl div-lift-btn"><span class="sp-lift-btn f-fl sp-matching-change-btn"></span></div>
            <div id="div_matching_form" data-role-form class="m-form-inline f-fl f-mw80">
                <div class="m-form-group m-form-readonly f-fl">
                    <label>就诊时间:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_matching_analyse_time" class="f-matching-bd" data-attr-scan=""/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly f-fl">
                    <label>就诊机构:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_matching_analyse_org" class="f-matching-bd" data-attr-scan=""/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly f-fl">
                    <label>就诊医生:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_matching_analyse_doctor" class="f-matching-bd"
                               data-attr-scan=""/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly f-fl">
                    <label>卡号:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_matching_card_nmuber" class="f-matching-bd" data-attr-scan=""/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly f-fl">
                    <label>就诊结果:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_matching_analyse_out" class="f-matching-bd" data-attr-scan=""/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly f-fl">
                    <label>检查项目:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_matching_examine_pro" class="f-matching-bd" data-attr-scan=""/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly f-fl">
                    <label>诊断开药:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_matching_analyse_drug" class="f-matching-bd" data-attr-scan=""/>
                    </div>
                </div>
                <div class="m-form-group m-form-readonly f-fl">
                    <label>备注:</label>
                    <div class="l-text-wrapper m-form-control">
                        <input type="text" id="inp_matching_remark" class="f-matching-bd" data-attr-scan=""/>
                    </div>
                </div>
            </div>
            <div class="f-fl div-right-btn"><span class="sp-right-btn f-fl sp-matching-change-btn"></span></div>
        </fieldset>
    </div>
    <div class="m-form-group f-pa" style="bottom: 10px;right: 10px;">
        <div class="m-form-control">
            <div id="btn_ok" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >
                <span>确定</span>
            </div>
        </div>
    </div>
</div>

