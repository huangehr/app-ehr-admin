<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######LOG上传接口Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="tille.esb.log.uploadLog"/></div>
<div id="div_wrapper" >
    <!-- ####### 查询条件部分 ####### -->
    <div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" data-role-form>
        <div class="m-form-group f-mt10 ">
            <div class="m-form-control">
                <!--下拉框-->
                <input type="text" id="inp_org"  data-type="comboSelect" class="validate-org-length f-w240" data-attr-scan="organization"/>
            </div>
            <div class="m-form-control">
                 <input type="text" id="beginTime" class="useTitle u-f-mt5"  placeholder=<spring:message code="lbl.hosLog.beginTime"/> data-attr-scan="beginTime" />
            </div>
            <div class="m-form-control">
                <input type="text" id="endTime" class="useTitle u-f-mt5"   placeholder=<spring:message code="lbl.hosLog.endTime"/> data-attr-scan="endTime" />
            </div>
            <div class="m-form-control f-ml20">
                <!--按钮:查询-->
                <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
                    <span><spring:message code="btn.search"/></span>
                </div>
            </div>
            <div class="m-form-control m-form-control-fr">
                <div id="btn_clear" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
                    <span><spring:message code="btn.clear"/></span>
                </div>
            </div>
        </div>

    </div>
    <!--######LOG上传接口表######-->
    <div id="div_esb_log_grid" >

    </div>
    <!--######LOG上传接口#结束######-->
</div>