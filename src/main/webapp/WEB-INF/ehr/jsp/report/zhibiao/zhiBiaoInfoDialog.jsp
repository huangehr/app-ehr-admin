<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######人口管理页面 > 人口信息对话框模板页######-->
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

            <div class="m-form-control f-w240 essential">
                <input type="text" id="inp_object_class" class="required" placeholder="请选择对象类" data-type="comboSelect" data-attr-scan="location">
            </div>
        </div>

        <div class="m-form-group">
            <label>数据源：</label>

            <div class="m-form-control f-w240 essential">
                <input type="text" id="inp_data_source" class="required" placeholder="请选择数据源" data-type="comboSelect" data-attr-scan="location">
            </div>
        </div>
        <div class="m-form-group">
            <label>数据存储：</label>

            <div class="m-form-control f-w240 essential">
                <input type="text" id="inp_data_storage" class="required" placeholder="请选择数据存储" data-type="comboSelect" data-attr-scan="location">
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

