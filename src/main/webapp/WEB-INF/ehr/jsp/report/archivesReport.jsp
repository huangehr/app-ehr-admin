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
                                <input type="text" id="start_date1" class="validate-date l-text-field validate-date"  placeholder="请选择开始日期"/>
                            </div>
                            <div class="m-form-control" style="width: 32px;">
                                <label>--</label>
                            </div>
                            <div class="m-form-control">
                                <input type="text" id="end_date1" class="validate-date l-text-field validate-date"  placeholder="请选择结束日期"/>
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
                    <div class="m-form-inline condition" style="float: right;line-height: 30px;height: 30px;padding-right: 20px;">
                        <div class="m-form-group f-mt10">
                            <div class="m-form-control">
                                <input type="text" id="date1" class="validate-date l-text-field validate-date"  placeholder="请选择查询日期"/>
                            </div>
                            <div class="m-form-control f-ml10">
                                <!--按钮:查询-->
                                <div id="btn_search1" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" style="margin-bottom: 1px">
                                    <span><spring:message code="btn.search"/></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="chart2" style="width: 100%;height: 350px;margin-top: 50px;"></div>
                </div>
            </div>

            <div class="div-dzbl">
                <div class="div-jkda-header">
                    <i class="if-dzbl"></i>
                    <span class="yj-tit">业务指标</span>
                    <div class="m-form-inline condition" style="float: right;line-height: 30px;height: 30px;padding-right: 20px;">
                        <div class="m-form-group f-mt10">
                            <div class="m-form-control">
                                <input type="text" id="date2" class="validate-date l-text-field validate-date"  placeholder="请选择查询日期"/>
                            </div>
                            <div class="l-text-wrapper m-form-control ">
                                <input type="text" id="orgCode1"  data-type="select"  class="useTitle ajax"
                                       placeholder="请选择医院" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="parentHosId">
                            </div>
                            <div class="m-form-control f-ml10">
                                <!--按钮:查询-->
                                <div id="btn_search2" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" style="margin-bottom: 1px">
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
            <div class="div-dzbl" style="height: 636px">
                <div class="div-jkda-header">
                    <i class="if-jkda"></i>
                    <span class="yj-tit">完整性</span>
                    <div class="m-form-inline condition" style="float: right;line-height: 30px;height: 30px;padding-right: 20px;">
                        <div class="m-form-group f-mt10">
                            <div class="m-form-control">
                                <input type="text" id="start_date2" class="validate-date l-text-field validate-date"  placeholder="请选择开始日期"/>
                            </div>
                            <div class="m-form-control" style="width: 32px;">
                                <label>--</label>
                            </div>
                            <div class="m-form-control">
                                <input type="text" id="end_date2" class="validate-date l-text-field validate-date"  placeholder="请选择结束日期"/>
                            </div>
                            <div class="l-text-wrapper m-form-control ">
                                <input type="text" id="orgCode2"  data-type="select"  class="useTitle ajax"
                                       placeholder="请选择医院" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="parentHosId">
                            </div>
                            <div class="m-form-control f-ml10">
                                <!--按钮:查询-->
                                <div id="btn_search3" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" style="margin-bottom: 1px">
                                    <span><spring:message code="btn.search"/></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px 20px" id="chart4-head">
                    <div class="div-head">
                        <div class="div-items active">
                            <div class="div-item-title">平台与医院</div>
                            <div class="div-item-content">
                                <div class="div-item">
                                    <img src="/ehr/develop/images/01zhengtishuliang_icon.png">
                                    <span id="total_rate">0.00%</span>
                                    <div id="total" class="div-item-count">0/0</div>
                                    <div class="div-item-type">就诊人次</div>
                                </div>
                                <div class="div-item">
                                    <img src="/ehr/develop/images/02shujuji_icon.png">
                                    <span id="oupatient_rate">0.00%</span>
                                    <div id="oupatient_total" class="div-item-count">0/0</div>
                                    <div class="div-item-type">门诊人次</div>
                                </div>
                                <div class="div-item">
                                    <img src="/ehr/develop/images/03shujuyuan_icon.png">
                                    <span id="inpatient_rate">0.00%</span>
                                    <div id="inpatient_total" class="div-item-count">0/0</div>
                                    <div class="div-item-type">住院人次</div>
                                </div>
                            </div>
                        </div>
                        <div class="div-items" style="margin-left: 4%">
                            <div class="div-item-title">平台与上传</div>
                            <div class="div-item-content">
                                <div class="div-item">
                                    <img src="/ehr/develop/images/01zhengtishuliang_icon.png">
                                    <span id="total_rate_sc">0.00%</span>
                                    <div id="total_sc" class="div-item-count">0/0</div>
                                    <div class="div-item-type">就诊人次</div>
                                </div>
                                <div class="div-item">
                                    <img src="/ehr/develop/images/02shujuji_icon.png">
                                    <span id="oupatient_rate_sc">0.00%</span>
                                    <div id="oupatient_total_sc" class="div-item-count">0/0</div>
                                    <div class="div-item-type">门诊人次</div>
                                </div>
                                <div class="div-item">
                                    <img src="/ehr/develop/images/03shujuyuan_icon.png">
                                    <span id="inpatient_rate_sc">0.00%</span>
                                    <div id="inpatient_total_sc" class="div-item-count">0/0</div>
                                    <div class="div-item-type">住院人次</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="chart4" style="width: 100%;height: 350px;"></div>
            </div>
            <div class="div-dzbl" style="height: 616px">
                <div class="div-jkda-header">
                    <i class="if-jkda"></i>
                    <span class="yj-tit">及时性</span>
                    <div class="m-form-inline condition" style="float: right;line-height: 30px;height: 30px;padding-right: 20px;">
                        <div class="m-form-group f-mt10">
                            <div class="m-form-control">
                                <input type="text" id="start_date3" class="validate-date l-text-field validate-date"  placeholder="请选择开始日期"/>
                            </div>
                            <div class="m-form-control" style="width: 32px;">
                                <label>--</label>
                            </div>
                            <div class="m-form-control">
                                <input type="text" id="end_date3" class="validate-date l-text-field validate-date"  placeholder="请选择结束日期"/>
                            </div>
                            <div class="l-text-wrapper m-form-control ">
                                <input type="text" id="orgCode3"  data-type="select"  class="useTitle ajax"
                                       placeholder="请选择医院" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="parentHosId">
                            </div>
                            <div class="m-form-control f-ml10">
                                <!--按钮:查询-->
                                <div id="btn_search4" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" style="margin-bottom: 1px">
                                    <span><spring:message code="btn.search"/></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding: 0px 20px">
                    <div class="div-head" style="height: 129px;width: 100%">
                        <div class="div-items" style="width: 100%">
                            <div class="div-item-content">
                                <div class="div-item">
                                    <img src="/ehr/develop/images/01zhengtishuliang_icon.png">
                                    <span id="total_rate_time">0.00%</span>
                                    <div id="total_time" class="div-item-count">0/0</div>
                                    <div class="div-item-type">就诊人次</div>
                                </div>
                                <div class="div-item">
                                    <img src="/ehr/develop/images/02shujuji_icon.png">
                                    <span id="oupatient_rate_time">0.00%</span>
                                    <div id="oupatient_total_time" class="div-item-count">0/0</div>
                                    <div class="div-item-type">门诊人次</div>
                                </div>
                                <div class="div-item">
                                    <img src="/ehr/develop/images/03shujuyuan_icon.png">
                                    <span id="inpatient_rate_time">0.00%</span>
                                    <div id="inpatient_total_time" class="div-item-count">0/0</div>
                                    <div class="div-item-type">住院人次</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="chart5" style="width: 100%;height: 350px;"></div>
            </div>
        </div>
    </div>
</div>



