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
                <div id="div_apply_form" data-role-form class="m-form-inline">
                    <div class="m-form-group m-form-readonly">
                        <label>就诊时间:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_analyse_time" class="f-matching-bd"
                                   data-attr-scan="visDate"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>就诊机构:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_analyse_org" class="f-matching-bd"
                                   data-attr-scan="visOrg"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>就诊医生:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_analyse_doctor" class="f-matching-bd"
                                   data-attr-scan="visDoctor"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>卡号:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_card_nmuber" class="f-matching-bd"
                                   data-attr-scan="cardNo"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>就诊结果:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_analyse_out" class="f-matching-bd"
                                   data-attr-scan="diagnosedResult"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>检查项目:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_examine_pro" class="f-matching-bd"
                                   data-attr-scan="diagnosedProject"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>诊断开药:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_analyse_drug" class="f-matching-bd"
                                   data-attr-scan="medicines"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly">
                        <label>备注:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_apply_remark" class="f-matching-bd" data-attr-scan="memo"/>
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="div-matching-msg f-audit-fw50 f-fl">
            <fieldset class="fie-bd">
                <legend class="f-pl10 f-pr10"><b>待匹配档案</b></legend>
                <div class="f-fl div-lift-btn"><span class="sp-lift-btn f-fl sp-matching-change-btn" id="sp_lift"></span></div>
                <div id="div_matching_form" data-role-form class="m-form-inline f-fl f-mw80">
                    <input type="text" class="f-dn" data-attr-scan="id"/>
                    <div class="m-form-group m-form-readonly f-fl">
                        <label>就诊时间:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_analyse_time" class="f-matching-bd"
                                   data-attr-scan="visDate"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly f-fl">
                        <label>就诊机构:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_analyse_org" class="f-matching-bd"
                                   data-attr-scan="visOrg"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly f-fl">
                        <label>就诊医生:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_analyse_doctor" class="f-matching-bd"
                                   data-attr-scan="visDoctor"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly f-fl">
                        <label>卡号:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_card_nmuber" class="f-matching-bd"
                                   data-attr-scan="cardNo"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly f-fl">
                        <label>就诊结果:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_analyse_out" class="f-matching-bd"
                                   data-attr-scan="diagnosedResult"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly f-fl">
                        <label>检查项目:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_examine_pro" class="f-matching-bd"
                                   data-attr-scan="diagnosedProject"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly f-fl">
                        <label>诊断开药:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_analyse_drug" class="f-matching-bd"
                                   data-attr-scan="medicines"/>
                        </div>
                    </div>
                    <div class="m-form-group m-form-readonly f-fl">
                        <label>备注:</label>
                        <div class="l-text-wrapper m-form-control">
                            <input type="text" id="inp_matching_remark" class="f-matching-bd" data-attr-scan="memo"/>
                        </div>
                    </div>
                </div>
                <div class="f-fl div-right-btn"><span class="sp-right-btn f-fl sp-matching-change-btn" id="sp_right"></span></div>
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

    <div class="f-dn f-ml20 u-public-manage m-form-inline" id="div_unrelevance_form" data-role-form>
        <div class="f-mt10 f-mb10">
            <input type="radio" name="unrelevanceeElse" data-attr-scan value="提供的内容不够完善，有多条档案相似">提供的内容不够完善，有多条档案相似<br>
        </div>
        <div class="f-mt10 f-mb10">
            <input type="radio" name="unrelevanceeElse" data-attr-scan value="诊断结果差异较大">诊断结果差异较大<br>
        </div>
        <div class="f-mt10 f-mb10">
            <input type="radio" name="unrelevanceeElse" data-attr-scan value="诊断结果差异较大">检查项目差异较大<br>
        </div>
        <div class="f-mt10 f-mb10">
            <input type="radio" name="unrelevanceeElse" data-attr-scan value="诊断结果差异较大">诊断开药差异较大<br>
        </div>
        <div class="f-mt10 f-mb10">
            <input type="radio" name="unrelevanceeElse" data-attr-scan id="inp_else">其他<br>
            <textarea class="tet-else"></textarea><br>
        </div>

        <div class="m-form-control pane-attribute-toolbar div-unrelevance-reason-btn f-pa f-mb10">
            <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_unrelevance_save_btn">
                <span>确认</span>
            </div>
            <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar"
                 id="div_unrelevance_cancel_btn">
                <span>取消</span>
            </div>
        </div>
    </div>

    <div id="div_matching_record_grid" class="f-fl f-audit-fw100"></div>

</div>