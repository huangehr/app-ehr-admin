<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div style="width: 100%;height: 100%; overflow: auto;padding-bottom: 0;" class="div-main-content">
    <div ms-controller="app" style="background: #F2F3F7;padding: 20px;width: 100%;">
        <div class="c-w-100">
            <div class="div-qyrkgak">
                <div class="div-jkda-header">
                    <i class="if-qyrkgak"></i>
                    <span class="yj-tit">采集指标</span>
                    <div class="m-form-inline condition" style="float: right;line-height: 30px;height: 30px;padding-right: 20px;">
                        <div class="m-form-group f-mt10">
                            <div class="m-form-control">
                                <input type="text" id="inp_start_date" class="validate-date l-text-field validate-date"  placeholder="请选择开始日期"/>
                            </div>
                            <div class="m-form-control" style="width: 32px;">
                                <label>--</label>
                            </div>
                            <div class="m-form-control">
                                <input type="text" id="inp_end_date" class="validate-date l-text-field validate-date"  placeholder="请选择结束日期"/>
                            </div>
                            <div class="m-form-control f-ml10">
                                <!--按钮:查询-->
                                <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" style="margin-bottom: 1px">
                                    <span><spring:message code="btn.search"/></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <div id="chart1" style="width: 100%;height: 300px;"></div>
                    <div id="chart2" style="width: 100%;height: 350px;"></div>
                </div>
            </div>

            <div class="div-dzbl">
                <div class="div-jkda-header">
                    <i class="if-dzbl"></i>
                    <span class="yj-tit">业务指标</span>
                    <div class="m-form-inline condition" style="float: right;line-height: 30px;height: 30px;padding-right: 20px;">
                        <div class="m-form-group f-mt10">
                            <div class="m-form-control">
                                <input type="text" id="date" class="validate-date l-text-field validate-date"  placeholder="请选择查询日期"/>
                            </div>
                            <div class="l-text-wrapper m-form-control ">
                                <input type="text" id="orgCode"  data-type="select"  class="useTitle ajax"
                                       placeholder="请选择医院" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="parentHosId">
                            </div>
                            <div class="m-form-control f-ml10">
                                <!--按钮:查询-->
                                <div id="search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" style="margin-bottom: 1px">
                                    <span><spring:message code="btn.search"/></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <div id="chart3" style="width: 100%;height: 350px;"></div>
                </div>
            </div>
        </div>
    </div>
</div>



