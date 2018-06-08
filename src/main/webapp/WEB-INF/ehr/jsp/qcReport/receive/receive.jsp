<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!--######质控管理-接收情况######-->
<div class="f-dn" data-head-title="true">接收情况</div>
<div id="div_wrapper">


    <div class="f-tac f-mb20">
        <div class="btn-group" data-toggle="buttons">
            <label class="btn btn-default active" style="width: 100px;" id="platform_receive"><input type="radio" name="options" autocomplete="off" checked="">平台接收</label>
            <label class="btn btn-default" style="width: 100px;" id="platform_resource"><input type="radio" name="options" autocomplete="off" checked="">接收情况</label>
            <%--<label class="btn btn-default" style="width: 100px;" id="platform_upload"><input type="radio" name="options" autocomplete="off">平台上传</label>--%>
        </div>
    </div>

    <div id="form1" class="m-retrieve-area f-dn f-pr  m-form-inline">
        <div class="m-form-group">
            <%--new add--%>
            <div class="m-form-control" style="height: 30px;line-height: 30px;">
                接收时间：
            </div>
            <%--new add--%>
            <div class="m-form-control f-ml10">
                <!--开始时间-->
                <input type="text" id="startDate" class="l-text-field"  placeholder="接收起始时间"/>
            </div>

            <%--new add--%>
            <div class="m-form-control" style="height: 30px;line-height: 30px;">
                -
            </div>

            <%--new add--%>
            <div class="m-form-control f-ml10">
                <!--结束时间-->
                <input type="text" id="endDate" class="required" placeholder="接收结束时间"/>
            </div>

            <%--new add--%>
            <div class="m-form-control f-ml10">
                <input id="eventType" data-type="select" data-attr-scan="eventType" placeholder="请选择就诊类型">
            </div>

            <div class="m-form-control f-ml10">
                <!--按钮:查询-->
                <div id="btn_search1" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                    <span><spring:message code="btn.search"/></span>
                </div>
            </div>

            <div class="m-form-control m-form-control-fr" style="float: right">
                <div id="div_export1" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                    <span><spring:message code="btn.export"/></span>
                </div>
            </div>

            <div class="m-form-control m-form-control-fr" style="float: right;margin-right: 20px;">
                <div id="div_report_create1" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                    <span><spring:message code="btn.report.create"/></span>
                </div>
            </div>
        </div>
    </div>

    <div id="form2" class="m-retrieve-area f-dn f-pr  m-form-inline" style="display: none">
        <div class="m-form-group">
            <%--new add--%>
            <div class="m-form-control" style="height: 30px;line-height: 30px;">
                就诊时间：
            </div>
            <%--new add--%>
            <div class="m-form-control f-ml10">
                <!--开始时间-->
                <input type="text" id="star_time" class="l-text-field required"  placeholder="就诊起始时间"/>
            </div>

            <%--new add--%>
            <div class="m-form-control" style="height: 30px;line-height: 30px;">
                -
            </div>

            <%--new add--%>
            <div class="m-form-control f-ml10">
                <!--结束时间-->
                <input type="text" id="end_time" class="required" placeholder="就诊结束时间"/>
            </div>

            <div class="m-form-control f-ml10">
                <!--按钮:查询-->
                <div id="btn_search2" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                    <span><spring:message code="btn.search"/></span>
                </div>
            </div>

            <div class="m-form-control m-form-control-fr" style="float: right">
                <div id="div_export" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                    <span><spring:message code="btn.export"/></span>
                </div>
            </div>

            <div class="m-form-control m-form-control-fr" style="float: right;margin-right: 20px;">
                <div id="div_report_create" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                    <span><spring:message code="btn.report.create"/></span>
                </div>
            </div>
            <%--<div id="div_new_patient" class="l-button u-btn u-btn-primary u-btn-small l-button-over">
              <span>新增</span>
            </div>--%>
        </div>
    </div>
    <!--######平台接收######-->
    <div id="table1">

    </div>
    <!--######平台接收#结束######-->
    <!--######接收情况######-->
    <div id="table2" style="display: none">

    </div>
    <!--######接收情况#结束######-->
</div>