<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .l-text{
        width:180px;
    }
    .l-text-field {
        width: 178px;
    }
    .l-text.l-text-combobox{
        width: 240px;
    }
    .l-text-combobox .l-text-field{
        width: 238px;
    }
</style>
<div style="width: 100%;height: 100%; overflow: auto;padding-bottom: 0;" class="div-main-content">
    <div ms-controller="app" style="background: #F2F3F7;width: 100%;">
        <div class="c-w-100">
            <div class="div-qyrkgak" style="height: 1210px;">
                <div class="div-jkda-header">
                    <i class="if-qyrkgak"></i>
                    <span class="yj-tit">采集指标</span>
                    <div class="m-form-inline condition" style="float: right;line-height: 30px;height: 30px;padding-right: 20px;">
                        <div class="m-form-group f-mt10">
                            <div class="m-form-control" style="padding-right: 0px;">
                                <input type="text" id="start_date1" class="validate-date l-text-field validate-date"  placeholder="请选择开始日期"/>
                            </div>
                            <div class="m-form-control" style="width: 32px;margin-right: 10px;">
                                <label>--</label>
                            </div>
                            <div class="m-form-control">
                                <input type="text" id="end_date1" class="validate-date l-text-field validate-date"  placeholder="请选择结束日期"/>
                            </div>
                            <div class="l-text-wrapper m-form-control ">
                                <input type="text" id="orgCode6"  data-type="select"  class="useTitle ajax"
                                       placeholder="请选择医院" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="parentHosId">
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
                    <div class="hr-tit-con"><div class="c-title">按日期统计</div></div>
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
                    <div class="hr-tit-con"><div class="c-title">按医院统计</div></div>
                    <div id="chart2" style="width: 100%;height: 350px;margin-top: 50px;"></div>
                    <div class="m-form-inline condition" style="float: right;line-height: 30px;height: 30px;padding-right: 20px;">
                        <div class="m-form-group f-mt10">
                            <div class="m-form-control">
                                <input type="text" id="date3" class="validate-date l-text-field validate-date"  placeholder="请选择查询日期"/>
                            </div>
                            <div class="l-text-wrapper m-form-control ">
                                <input type="text" id="orgCode4"  data-type="select"  class="useTitle ajax"
                                       placeholder="请选择医院" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="parentHosId">
                            </div>
                            <div class="m-form-control f-ml10">
                                <!--按钮:查询-->
                                <div id="btn_search5" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" style="margin-bottom: 1px">
                                    <span><spring:message code="btn.search"/></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="hr-tit-con"><div class="c-title">数据集总量</div></div>
                    <div id="chart6" style="width: 50%;height: 300px;margin-top: 40px;float: left"></div>

                    <div style="max-width: 48%;height: 280px;margin-top: 40px;float: left;overflow-y: auto;margin-right: 20px;">
                        <table id="grid" style="display: none;">
                            <thead>
                            <tr>
                                <th style="width: 50px;"></th>
                                <th class="center">名称</th>
                                <th class="center">总数</th>
                                <th class="center">行数</th>
                            </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
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
                            <div class="m-form-control" style="width: 32px;margin-right: 10px;">
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
                            <div class="m-form-control" style="width: 32px;margin-right: 10px;">
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

            <div class="div-dzbl" style="height: 780px">
                <div class="div-jkda-header">
                    <i class="if-jkda"></i>
                    <span class="yj-tit">准确性</span>
                    <div class="m-form-inline condition" style="float: right;line-height: 30px;height: 30px;padding-right: 20px;">
                        <div class="m-form-group f-mt10">
                            <div class="m-form-control">
                                <input type="text" id="start_date4" class="validate-date l-text-field validate-date"  placeholder="请选择开始日期"/>
                            </div>
                            <div class="m-form-control" style="width: 32px;margin-right: 10px;">
                                <label>--</label>
                            </div>
                            <div class="m-form-control">
                                <input type="text" id="end_date4" class="validate-date l-text-field validate-date"  placeholder="请选择结束日期"/>
                            </div>
                            <div class="l-text-wrapper m-form-control ">
                                <input type="text" id="orgCode5"  data-type="select"  class="useTitle ajax"
                                       placeholder="请选择医院" required-title=<spring:message code="lbl.must.input"/> data-attr-scan="parentHosId">
                            </div>
                            <div class="m-form-control f-ml10">
                                <!--按钮:查询-->
                                <div id="btn_search6" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" style="margin-bottom: 1px">
                                    <span><spring:message code="btn.search"/></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="chart7" style="width: 100%;height: 350px;"></div>
                <div style="width: 50%;float: left">
                    <div class="hr-tit-con"><div class="c-title">错误分类占比</div></div>
                    <div id="chart8" style="width: 100%;height: 350px;"></div>
                </div>
                <div style="width: 50%;float: left">
                    <div class="hr-tit-con"><div class="c-title">错误数据元占比</div></div>
                    <div id="chart9" style="width: 100%;height: 350px;"></div>
                </div>
            </div>
        </div>
    </div>
</div>



