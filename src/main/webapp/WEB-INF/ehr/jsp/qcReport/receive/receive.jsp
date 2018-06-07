<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!--######质控管理-接收情况######-->
<div class="f-dn" data-head-title="true">接收情况</div>
<div id="div_wrapper">


        <div class="f-tac f-mb20">
            <div class="btn-group" data-toggle="buttons">
                <label class="btn btn-default" style="width: 100px;" id="platform_receive"><input type="radio" name="options" autocomplete="off" checked="">平台接收</label>
                <label class="btn btn-default active" style="width: 100px;" id="platform_resource"><input type="radio" name="options" autocomplete="off" checked="">接收情况</label>
                <%--<label class="btn btn-default" style="width: 100px;" id="platform_upload"><input type="radio" name="options" autocomplete="off">平台上传</label>--%>
            </div>
        </div>

    <div class="m-retrieve-area f-dn f-pr  m-form-inline" data-role-form>
        <div class="m-form-group">
            <%--new add--%>
            <div class="m-form-control" style="height: 30px;line-height: 30px;">
                就诊时间：
            </div>
            <%--new add--%>
            <div class="m-form-control f-ml10 f-mb10">
                <!--开始时间-->
                <input type="text" id="star_time" class="l-text-field required" data-attr-scan="searchRegisterTimeStart" placeholder="就诊起始时间"/>
            </div>

            <%--new add--%>
            <div class="m-form-control" style="height: 30px;line-height: 30px;">
                -
            </div>

            <%--new add--%>
            <div class="m-form-control f-ml10 f-mb10">
                <!--结束时间-->
                <input type="text" id="end_time" data-attr-scan="searchRegisterTimeEnd" class="required" placeholder="就诊结束时间"/>
            </div>

            <div class="m-form-control f-ml10 f-mb10">
                <!--按钮:查询-->
                <sec:authorize url="/patient/searchPatient">
                    <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.search"/></span>
                    </div>
                </sec:authorize>
            </div>

            <div class="m-form-control m-form-control-fr f-mb10" style="float: right">
                <sec:authorize url="/patient/updatePatient">
                    <div id="div_export" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.export"/></span>
                    </div>
                </sec:authorize>
            </div>

            <div class="m-form-control m-form-control-fr f-mb10" style="float: right;margin-right: 20px;">
                <sec:authorize url="/patient/updatePatient">
                    <div id="div_report_create" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.report.create"/></span>
                    </div>
                </sec:authorize>
            </div>
            <%--<div id="div_new_patient" class="l-button u-btn u-btn-primary u-btn-small l-button-over">
              <span>新增</span>
            </div>--%>
        </div>
    </div>
    <!--######平台接收######-->
    <div id="div_patient_info_grid" style="display: none">

    </div>
    <!--######平台接收#结束######-->
    <!--######接收情况######-->
    <div id="div_platform_receive_info_grid">

    </div>
    <!--######接收情况#结束######-->
</div>

<div id="div_user_info_dialog">

</div>