<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######资源浏览页面Title设置######-->
<div class="f-dn" data-head-title="true">申请审核</div>
<div id="div_audit" class="f-mt10 f-audit-fw100">
    <!-- ####### 查询条件部分 ####### -->
    <div class="">
        <div class="div-audit-view-title f-audit-fw100">
            <a id="btn_back" class="f-fl">返回上一层</a>
        </div>
    </div>
    <div class="div-audit-msg f-audit-fw100 f-fl f-mb10 f-mt10">
        <div class="div-apply-msg f-audit-fw50 f-fl">
            <fieldset class="fie-bd">
                <legend class="f-pl10 f-pr10"><b>申请信息</b></legend>
                <div id="" data-role-form class="m-form-inline" >
                    <div class="m-form-group m-form-readonly">
                        <label>就诊时间:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_analyse_time" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>就诊机构:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_analyse_org" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>就诊医生:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_analyse_doctor" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>卡号:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_card_nmuber" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>就诊结果:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_analyse_out" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>检查项目:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_examine_pro" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>诊断开药:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_analyse_drug" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>备注:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_remark" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="div-matching-msg f-audit-fw50 f-fl">
            <fieldset class="fie-bd">
                <legend class="f-pl10 f-pr10"><b>待匹配档案</b></legend>
                <div id="div_matching_form" data-role-form class="m-form-inline" >
                    <div class="m-form-group m-form-readonly">
                        <label>就诊时间:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_analyse_time" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>就诊机构:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_analyse_org" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>就诊医生:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_analyse_doctor" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>卡号:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_card_nmuber" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>就诊结果:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_analyse_out" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>检查项目:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_examine_pro" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>诊断开药:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_analyse_drug" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>备注:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_remark" class="f-matching-bd" data-attr-scan=""/>
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>

        <div class="m-form-control pane-attribute-toolbar div-relevance-unrelevance-btn">
            <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_relevance_btn">
                <span>关联</span>
            </div>
            <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_unrelevance_btn">
                <span>无关联</span>
            </div>
        </div>
    </div>

    <div id="div_matching_record_grid" class="f-fl f-audit-fw100"></div>
</div>