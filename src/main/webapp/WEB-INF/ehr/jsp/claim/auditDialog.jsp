<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######资源浏览页面Title设置######-->
<div class="f-dn" data-head-title="true">不通过的原意</div>
<div id="div_audit" class="f-mt10 f-audit-fw100">
    <div class=" f-ml20 u-public-manage m-form-inline" id="div_unrelevance_form" data-role-form>
        <div class="f-mt10 f-mb10">
            <input type="radio" name="unrelevanceeElse" data-attr-scan value="提供的内容不够完善，有多条档案相似">提供的内容不够完善，有多条档案相似<br>
        </div>
        <div class="f-mt10 f-mb10">
            <input type="radio" name="unrelevanceeElse" data-attr-scan value="诊断结果差异较大">诊断结果差异较大<br>
        </div>
        <div class="f-mt10 f-mb10">
            <input type="radio" name="unrelevanceeElse" data-attr-scan value="检查项目差异较大">检查项目差异较大<br>
        </div>
        <div class="f-mt10 f-mb10">
            <input type="radio" name="unrelevanceeElse" data-attr-scan value="诊断开药差异较大">诊断开药差异较大<br>
        </div>
        <div class="f-mt10 f-mb10 m-form-readonly">
            <input type="radio" name="unrelevanceeElse" id="inp_else">其他<br>
            <textarea class="tet-else ajax" data-attr-scan ></textarea><br>
            <span class="f-ml25 f-dn"><b>请输入原因</b></span>
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
</div>