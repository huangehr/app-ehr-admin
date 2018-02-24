<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<%@ include file="addElasticInfoDialogCss.jsp" %>
<style>
    .i-text{
        width: 185px;
        height: 30px;
        line-height: 30px;
        padding-right: 17px;
        color: #555555;
        padding-left: 5px;
        vertical-align: middle;
    }
    .uploadBtn{
        position: relative;
        vertical-align: middle;
        overflow: hidden;
    }
    .uploadBtn .file{
        width: 50px;
        height: 30px;
        position: absolute;
        top: 0;
        left: 0;
        opacity: 0;
        z-index: 999;
    }
</style>
<div id="div_patient_info_form" data-role-form class="m-form-inline f-mt20" style="overflow:auto">
    <div>
        <form id ="uploadForm" enctype="multipart/form-data">

            <div class="m-form-group">
                <label>文件：</label>
                <div class="l-text-wrapper m-form-control essential">
                    <input type="text"  class="i-text required" id="iosUrl" data-attr-scan="iosQrCodeUrl"  readonly="readonly" />
                    <div class="uploadBtn">上传
                        <input type="file" id="inp_file_iosUrl" name="file" class="file">
                    </div>
                </div>
            </div>

        </form>
    </div>

</div>

<input type="hidden" id="execTime">


<script src="${staticRoot}/lib/ligerui/plugins/ligerSpinner.js"></script>
<%@ include file="addElasticInfoDialogJs.jsp" %>

