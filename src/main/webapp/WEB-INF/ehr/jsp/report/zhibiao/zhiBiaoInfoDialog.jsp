<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<%@ include file="zhiBiaoInfoDialogCss.jsp" %>
<input value="${id}" class="f-dn" id="inp_zhiBiaoId"/>
<div id="div_patient_info_form" data-role-form class="m-form-inline f-mt20" style="overflow:auto">
    <div>
        <div class="m-form-group">
            <label>编码：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_code" class="required ajax useTitle max-length-50 validate-special-char"  required-title=<spring:message code="lbl.must.input"/> data-attr-scan="code"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>名称：</label>
            <div class="l-text-wrapper m-form-control essential ">
                <input type="text" id="inp_name" class="required useTitle ajax" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="name"/>
            </div>
        </div>
        <div class="m-form-group">
            <label>指标类型：</label>
            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_quota_type" class="required ajax useTitle" placeholder="请选择指标类型" data-type="select" data-attr-scan="quotaType" required-title=<spring:message code="lbl.must.input"/>>
            </div>
        </div>
        <div class="m-form-group">
            <label>执行方式：</label>
            <div class="u-checkbox-wrap m-form-control">
                <input type="radio" value="1" name="jobType">立即执行
                <input type="radio" value="2" name="jobType">周期执行
            </div>
        </div>
        <div class="m-form-group  f-dn divTimeInterval">
            <label>执行时间：</label>
            <div class="m-form-control essential" style="position: relative; padding-right: 10px;">
                <input type="text" id="inp_zhixing_date" class="required"  placeholder="请选择时间"
                       required-title=<spring:message code="lbl.must.input"/>/>
            </div>
        </div>
        <div class="m-form-group f-dn divTimeInterval" id="divTimeInterval">
            <label>执行周期：</label>
            <div class="m-form-control">
                <div>
                    <input type="radio" name="interval_type" value="0" checked/>分
                    <input type="radio" name="interval_type" value="1" />时
                    <input type="radio" name="interval_type" value="2" />天
                    <input type="radio" name="interval_type" value="3" />周
                    <input type="radio" name="interval_type" value="4" />月
                </div>

                <div id="divIntervalOption0" class="divIntervalOption f-h50" style="display: block;">
                    <div class="label-left">每隔</div><input type="text" id="txtM" /><div class="label-left">分</div>
                </div>
                <div id="divIntervalOption1" class="divIntervalOption f-h50">
                    <div class="label-left">每隔</div><input type="text" id="txtH" /><div class="label-left">时</div>
                </div>
                <div id="divIntervalOption2" class="divIntervalOption f-h50">
                    <div class="label-left">每隔</div><input type="text" id="txtD" /><div class="label-left">天</div>
                </div>
                <div id="divIntervalOption3" class="divIntervalOption f-h50">
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
        <div class="m-form-group">
            <label>对象类：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_object_class" class="required"  data-attr-scan="jobClazz">
            </div>
        </div>
        <div class="m-form-group">
            <label>数据源：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_data_source" class="required ajax useTitle" placeholder="请选择数据源" data-type="select"  required-title=<spring:message code="lbl.must.input"/>>
            </div>
        </div>
        <div class="m-form-group" id="div_dataSource_json">
            <label>源配置：</label>

            <div class="l-text-wrapper m-form-control essential">
                <textarea id="inp_dataSource_json" class="required useTitle validate-special-char"  required-title=<spring:message code="lbl.must.input"/> ></textarea>
            </div>
        </div>
        <div class="m-form-group f-mt5">
            <label>数据存储：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_data_storage" class="required ajax useTitle" placeholder="请选择数据存储" data-type="select"  required-title=<spring:message code="lbl.must.input"/>>
            </div>
        </div>
        <div class="m-form-group" id="div_dataStorage_json">
            <label>存储配置：</label>

            <div class="l-text-wrapper m-form-control essential">
                <textarea type="text" id="inp_dataStorage_json" class="required useTitle validate-special-char"  required-title=<spring:message code="lbl.must.input"/> ></textarea>
            </div>
        </div>
        <div class="m-form-group ">
            <label>存储方式：</label>

            <div class="u-checkbox-wrap m-form-control ">
                <input type="radio" value="1" name="dataLevel" data-attr-scan>全量
                <input type="radio" value="2" name="dataLevel" data-attr-scan>增量
            </div>
        </div>
        <%--<div class="m-form-group ">--%>
            <%--<label>状态：</label>--%>
            <%--<div class="u-checkbox-wrap m-form-control ">--%>
                <%--<input type="radio" value="1" name="status" data-attr-scan>正常--%>
                <%--<input type="radio" value="-1" name="status" data-attr-scan>删除--%>
                <%--<input type="radio" value="0" name="status" data-attr-scan>不可用--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="m-form-group f-mb30">
            <label>备注：</label>
            <div class="l-text-wrapper m-form-control">
                <textarea id="inp_introduction" class="f-w240 description  max-length-256 validate-special-char" data-attr-scan="remark" ></textarea>
            </div>
        </div>
    </div>

    <div class="m-form-control pane-attribute-toolbar" style="text-align: center;">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" id="div_update_btn">
            <span>保存</span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
            <span>关闭</span>
        </div>
    </div>
</div>

<input type="hidden" id="execTime">


<script src="${staticRoot}/lib/ligerui/plugins/ligerSpinner.js"></script>
<%@ include file="zhiBiaoInfoDialogJs.jsp" %>

