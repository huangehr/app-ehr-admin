<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="f-dn" data-head-title="true"><spring:message code="title.app.manage"/></div>
<!-- ####### 页面部分 ####### -->
<div id="div_wrapper" >
    <!-- ####### 查询条件部分 ####### -->
    <div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" data-role-form>
        <div class="m-form-group f-mt10">
            <input hidden value="${quotaCode}" data-attr-scan="quotaCode"/>
            <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                <div>任务开始时间：</div>
            </div>
            <div class="m-form-control">
                <input type="text" id="inp_start_time" class="f-h28 f-w160" placeholder="任务开始时间"  data-attr-scan="startTime">
            </div>
            <div class="m-form-control" style="margin-top: -2px;font-weight:bold;font-size:22px;vertical-align: middle;margin-right: 10px;display: inline-block;"> ~ </div>
            <div class="m-form-control">
                <input type="text" id="inp_end_time" class="f-h28 f-w160" placeholder="任务结束时间" data-attr-scan="endTime">
            </div>

            <div class="m-form-control f-ml10 f-mb10">
                <sec:authorize url="/quota/quotaLog">
                    <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.search"/></span>
                    </div>
                </sec:authorize>
            </div>

        </div>
    </div>

    <div id="div_quotaLog_grid" >
    </div>
</div>
