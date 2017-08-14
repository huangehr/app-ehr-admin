<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div id="reportCategoryForm" class="m-form-inline f-mt20" data-role-form>
    <input type="hidden" id="id" data-attr-scan="id">

    <div class="m-form-group">
        <label>父级类别：</label>
        <div class="l-text-wrapper m-form-control">
            <input type="text" data-type="select" id="pid" data-attr-scan="pid">
        </div>
    </div>
    <div class="m-form-group">
        <label>名称：</label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" class="f-w240 max-length-50 required ajax"
                   id="name" data-attr-scan="name">
        </div>
    </div>
    <div class="m-form-group">
        <label>编码：</label>
        <div class="l-text-wrapper m-form-control essential">
            <input type="text" class="f-w240 max-length-50 required ajax"
                   id="code" data-attr-scan="code">
        </div>
    </div>
    <div class="m-form-group">
        <label>说明：</label>
        <div class="m-form-control">
            <textarea rows="3" class="f-w240 max-length-200"
                      id="remark" data-attr-scan="remark"></textarea>
        </div>
    </div>

    <div class="m-form-control pane-attribute-toolbar">
        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam f-mr10" id="btnSave">
            <span>保存</span>
        </div>
        <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar f-mr20" id="btnClose">
            <span>关闭</span>
        </div>
    </div>
</div>

