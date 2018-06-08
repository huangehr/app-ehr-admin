<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<style>
    .data-null span {width:100%;display:block;text-align: center;padding: 15px;font-size: 16px;color: #999;}
    .m-form-group label{width: 150px!important;}
    .m-form-inline .m-form-group span {
        display: block;
        position: relative;
        float: left;
        min-height: 30px;
        line-height: 30px;
        text-align: right;
        padding-right: 10px;
        padding-left: 10px;
        font-weight: normal;
    }
    .receive {
        width: 100%;
        min-height: 30px;
        line-height: 30px;
        padding-right: 10px;
        padding-left: 10px;
        font-weight: 700;
        font-size: 20px!important;
    }
    .hospital {
        float: left;
        width: 100%;
        min-height: 30px;
        line-height: 30px;
        padding-right: 10px;
        padding-left: 10px;
        font-weight: 700;
        font-size: 25px!important;
        margin-bottom: 20px;
    }
</style>

<!--###### 接收情况 > 接收详情页######-->
<div id="div_info_form" data-role-form class="tab-con m-form-inline" style="overflow:auto">
    <div class="tab-con-info">
        <div class="hospital" id="hospital">
        </div>
        <div class="m-form-group">
            <label>就诊时间：</label>

            <div class="l-text-wrapper m-form-control">
                <span id="visitTime"></span>
            </div>
        </div>
        <div class="m-form-group ">
            <label>应接收档案数：</label>

            <div class="l-text-wrapper m-form-control ">
                <span id="totalVisit"></span>
            </div>
        </div>
        <div class="m-form-group ">
            <label>及时采集档案数：</label>
            <div class="l-text-wrapper m-form-control">
                <span id="visitIntime"></span>
            </div>
            <label>及时率：</label>
            <div class="l-text-wrapper m-form-control">
                <span id="visitIntimeRate"></span>
            </div>
        </div>
        <div class="m-form-group ">
            <label>已采集档案数：</label>
            <div class="l-text-wrapper m-form-control">
                <span id="visitIntegrity"></span>
            </div>
            <label>完整率：</label>

            <div class="l-text-wrapper m-form-control">
                <span id="visitIntegrityRate"></span>
            </div>
        </div>

    </div>

    <div class="receive">接收情况
        <hr>
    </div>

    <!--######接收详情######-->
    <div id="div_info_grid">

    </div>
    <!--######接收详情#结束######-->
</div>

<div class="m-form-control pane-attribute-toolbar btm-btns" style="text-align: center;padding-top: 15px;">
    <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
        <span>返回</span>
    </div>
</div>
<input type="hidden" id="inp_patientCopyId">
