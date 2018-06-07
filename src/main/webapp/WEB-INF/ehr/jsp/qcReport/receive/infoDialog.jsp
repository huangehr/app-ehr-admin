<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .btm-btns{position: absolute;bottom: 0;right: 0;}
    .tab-con{position: absolute;left: 0;right: 0;top: 50px;bottom: 55px;}
    /*div.tab-con-info{padding-bottom: 60px}*/
    .l-dialog-body{position: relative;overflow: hidden}
    .card-l-item{padding: 0 10px;margin-bottom: 10px}
    .card-l-item div{height:30px;line-height:30px;position:relative;padding: 0 10px;border-width: 1px 1px 0 1px;border-style: solid;border-color: #ccc;background: #f1f1f1;}
    .card-l-item div span {display: block}
    .card-l-item div a {position: absolute;right: 0;top: 0}
    .card-l-item ul{width: 100%;}
    .card-l-item ul li{display: inline-block;width: 49%;height:30px;line-height:30px;padding: 0 10px;}
    .first-ul{border-width: 1px 1px 0 1px;border-style: solid;border-color: #ccc}
    .last-ul{border-width: 0 1px 1px 1px;border-style: solid;border-color: #ccc}
    .grid_delete{height: 30px;}
    .data-null{margin-top: 90px;position: relative}
    .null-page{width: 260px;height: 163px;background: url("${contextRoot}/develop/images/shujukong_bg.png") no-repeat center;margin: 0 auto;}
    .data-null span {width:100%;display:block;text-align: center;padding: 15px;font-size: 16px;color: #999;}
</style>

<!--###### 接收情况 > 接收详情页######-->
<div id="div_patient_info_form" data-role-form class="tab-con m-form-inline" style="overflow:auto">
    <div class="tab-con-info">
        <div id="div_patient_img_upload" class="u-upload alone f-ib f-tac f-vam u-upload-img" data-alone-file=true>
            <!--用来存放item-->
            <div id="div_file_list" class="uploader-list"></div>
            <div id="div_file_picker" class="f-mt10"><spring:message code="btn.file.choose"/></div>
        </div>
        <div class="m-form-group">
            <label>就诊时间：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_realName" class="required useTitle max-length-50 validate-special-char" data-attr-scan="name"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>应接收档案数：</label>

            <div class="l-text-wrapper m-form-control essential ">
                <input type="text" id="inp_idCardNo" class="required useTitle ajax validate-id-number" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="idCardNo"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>及时采集档案数：</label>

            <div class="l-text-wrapper m-form-control essential f-pr0">
                <input type="text" id="inp_patientNation" data-type="select" class="required useTitle" data-attr-scan="nation"/>
            </div>
        </div>
        <div class="m-form-group ">
            <label>已采集档案数：</label>

            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inp_patientNativePlace" class="required useTitle max-length-100 validate-special-char" data-attr-scan="nativePlace"/>
            </div>
        </div>

    </div>

    <div>接收情况</div>
    <hr>
    <!--######接收详情######-->
    <div id="div_info_grid">

    </div>
    <!--######接收详情#结束######-->
</div>

<div class="m-form-control pane-attribute-toolbar btm-btns">
    <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
        <span>返回</span>
    </div>
</div>
<input type="hidden" id="inp_patientCopyId">
