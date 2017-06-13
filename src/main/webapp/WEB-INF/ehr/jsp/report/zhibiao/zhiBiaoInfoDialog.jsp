<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div id="div_patient_info_form" data-role-form class="m-form-inline f-mt20" style="overflow:auto">
    <div>
        <div class="m-form-group">
            <label>编码：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_code" class="required useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>名称：</label>

            <div class="l-text-wrapper m-form-control essential ">
                <input type="text" id="inp_name" class="required useTitle ajax validate-id-number"  validate-id-number-title="请输入合法的身份证号"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="idCardNo"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>周期：</label>

            <div class="l-text-wrapper m-form-control essential ">
                <input type="text" id="inp_cycle" class="required useTitle ajax validate-id-number"  validate-id-number-title="请输入合法的身份证号"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="idCardNo"/>
            </div>
        </div>
        <div class="m-form-group">
            <label>对象类：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_object_class" class="required"  data-attr-scan="location">
            </div>
        </div>

        <div class="m-form-group">
            <label>数据源：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_data_source" class="required" placeholder="请选择数据源" data-type="comboSelect" data-attr-scan="location">
            </div>
        </div>
        <div class="m-form-group" id="div_dataSource_json">
            <label>config_json：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_dataSource_json" class="required" data-attr-scan="location">
            </div>
        </div>
        <div class="m-form-group">
            <label>数据存储：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_data_storage" class="required" placeholder="请选择数据存储" data-type="comboSelect" data-attr-scan="location">
            </div>
        </div>
        <div class="m-form-group" id="div_dataStorage_json">
            <label>config_json：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_dataStorage_json" class="required" data-type="comboSelect" data-attr-scan="location">
            </div>
        </div>
        <div class="m-form-group ">
            <label>存储方式：</label>

            <div class="u-checkbox-wrap m-form-control ">
                <input type="radio" value="1" name="gender" data-attr-scan>全量
                <input type="radio" value="2" name="gender" data-attr-scan>增量
            </div>
        </div>
        <div class="m-form-group ">
            <label>状态：</label>

            <div class="u-checkbox-wrap m-form-control ">
                <input type="radio" value="1" name="gender" data-attr-scan>生效
                <input type="radio" value="2" name="gender" data-attr-scan>失效
            </div>
        </div>
        <div class="m-form-group f-mb30">
            <label>备注：</label>
            <div class="l-text-wrapper m-form-control">
                <textarea id="inp_introduction" class="f-w240 description  max-length-256 validate-special-char" data-attr-scan="introduction" ></textarea>
            </div>
        </div>
    </div>

    <div class="m-form-control pane-attribute-toolbar">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" id="div_update_btn">
            <span>保存</span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
            <span>关闭</span>
        </div>
    </div>
    <input type="hidden" id="inp_patientCopyId">
</div>

<div id="div_weekDialog" class="u-public-manage m-form-inline" style="position: relative;height: 77%;">
    <div class="m-form-group">
        <label>任务执行方式：</label>
        <div class="u-checkbox-wrap m-form-control ">
            <input type="radio" value="1" name="gender">单次执行
            <input type="radio" value="2" name="gender">周期执行
        </div>
    </div>
    <div class="m-form-group">
        <label>任务触发时间：</label>
        <div class="m-form-control">
            <input type="text" id="inp_zhixing_date" class="validate-date l-text-field validate-date"  placeholder="输入日期 格式(2016-04-15)"
                   required-title=<spring:message code="lbl.must.input"/> data-attr-scan="birthday"/>
        </div>
    </div>
    <div class="m-form-group">
        <label>执行周期：</label>
        <div class="m-form-control">
            <div>
                <input type="radio" name="interval_type" value="0" checked/>分
                <input type="radio" name="interval_type" value="1" />时
                <input type="radio" name="interval_type" value="2" />天
                <input type="radio" name="interval_type" value="3" />周
                <input type="radio" name="interval_type" value="4" />月
            </div>

            <div id="divIntervalOption0" class="divIntervalOption" style="display: block">
                <div class="label-left">每隔</div><input type="text" id="txtM" /><div class="label-left">分</div>
            </div>
            <div id="divIntervalOption1" class="divIntervalOption">
                <div class="label-left">每隔</div><input type="text" id="txtH" /><div class="label-left">时</div>
            </div>
            <div id="divIntervalOption2" class="divIntervalOption">
                <div class="label-left">每隔</div><input type="text" id="txtD" /><div class="label-left">天</div>
            </div>
            <div id="divIntervalOption3" class="divIntervalOption">
                <input type="checkbox" name="week_day" value="2"/>周一
                <input type="checkbox" name="week_day" value="3"/>周二
                <input type="checkbox" name="week_day" value="4"/>周三
                <input type="checkbox" name="week_day" value="5"/>周四
                <input type="checkbox" name="week_day" value="6"/>周五<br/>
                <input type="checkbox" name="week_day" value="7"/>周六
                <input type="checkbox" name="week_day" value="1"/>周日
            </div>
            <div id="divIntervalOption4" class="divIntervalOption">
                <div class="m-form-group">
                    <input type="radio" name="month_day" value="0" checked/>每月第一天
                </div>
                <div class="m-form-group">
                    <input type="radio" name="month_day" value="1" />每月最后一天
                </div>
                <div class="m-form-group">
                    <div style="float: left">
                        <input type="radio" name="month_day" value="2"/>
                    </div>
                    <div class="label-left" style="padding-left:0px;">每月第</div><input type="text" id="txtMD" disabled/><div class="label-left">天</div>
                </div>
            </div>
        </div>
    </div>
    <div style="position: absolute; left: 50%; margin-left: -50px; bottom: -50px;">
        <div class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-t30" id="div_week_confirm_btn">
            <span>确认</span>
        </div>
    </div>
</div>
<script src="${staticRoot}/lib/ligerui/plugins/ligerSpinner.js"></script>

