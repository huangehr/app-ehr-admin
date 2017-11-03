<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/11/1
  Time: 9:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div style="width: 100%;height: 100%; overflow: auto;padding-bottom: 40px;" class="div-main-content">
    <div ms-controller="app" style="background: #F2F3F7;padding: 20px;width: 100%;">
        <div class="c-w-100">
            <%--全员人口个案库--%>
            <div class="div-qyrkgak">
                <div class="div-jkda-header">
                    <i class="if-qyrkgak"></i>
                    <span class="yj-tit">全员人口个案库</span>
                </div>
                <div>
                    <div class="div-qyrkgak-chart1">
                        <div class="c-w-100 c-h-100">
                            <div id="div_jkda_chart6">

                            </div>
                        </div>
                        <div class="div-instruction">
                            <div class="div-jkda-amount" id="tdCNum"></div>
                            <div class="div-jkda-title">健康卡绑定量</div>
                        </div>
                    </div>
                    <div class="div-chuizhi-xian"></div>
                    <div id="div_jkda_chart7" style="width: 67%;"></div>
                    <div class="div-chuizhi-xian"></div>
                </div>
            </div>
            <%--医疗资源库--%>
            <div class="div-ylzyk">
                <div class="div-jkda-header">
                    <i class="if-ylzyk"></i>
                    <span class="yj-tit">医疗资源库</span>
                </div>
                <div>
                    <div id="div_jkda_chart9"></div>
                    <div class="div-ylzyk-content">
                        <div class="div-ylzyk-header">
                            <div class="div-ylzyk-title">全市统计</div>
                            <div class="c-border-top f-pt22 f-pl30">
                                <div>
                                    <label class="f-pl20 f-fs16 c-fwb c-333">医生：</label>
                                    <label class="f-fs16 c-44d4ca" id="qsDocNum"></label>
                                </div>
                                <div class="f-pt35">
                                    <label class="f-pl20 f-fs16 c-fwb c-333">护士：</label>
                                    <label class="f-fs16 c-ffbd5c" id="qsHsNum"></label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%--健康档案--%>
            <div class="div-jkda">
                <div class="div-jkda-header">
                    <i class="if-jkda"></i>
                    <span class="yj-tit">健康档案</span>
                </div>
                <div class="div-jkda-content">
                    <div class="c-w-100 div-chart">
                        <div id="div_jkda_chart1" class="c-w-100 c-h-100">

                        </div>
                        <div class="div-instruction">
                            <div class="div-jkda-amount" id="arcNum"></div>
                            <div class="div-jkda-title">档案识别</div>
                        </div>
                    </div>
                    <div class="c-w-100 div-bottom-instruction">
                        <div class="f-mb10 f-pl30">
                            <label class="bar-a cb-42d16f"></label>
                            可识别:
                            <label class="c-42d16f" id="identNum"></label>
                        </div>
                        <div class="f-pl30">
                            <label class="bar-a cb-ffbd5c"></label>
                            不可识别:
                            <label class="c-ffbd5c" id="unIdentNum"></label>
                        </div>
                    </div>
                </div>
                <div class="div-jkda-content">
                    <div class="c-w-100 div-chart">
                        <div id="div_jkda_chart2" class="c-w-100 c-h-100">

                        </div>
                        <div class="div-instruction">
                            <div class="div-jkda-amount" id="hosCountNum"></div>
                            <div class="div-jkda-title">住院/门诊</div>
                        </div>
                    </div>
                    <div class="c-w-100 div-bottom-instruction">
                        <div class="f-mb10 f-pl30">
                            <label class="bar-a cb-5bc9f4"></label>
                            住院:
                            <label class="c-5bc9f4" id="hosNum"></label>
                        </div>
                        <div class="f-mb10 f-pl30">
                            <label class="bar-a cb-ffbd5c"></label>
                            门诊:
                            <label class="c-ffbd5c" id="odNum"></label>
                        </div>
                        <div class="f-pl30">
                            <label class="bar-a cb-9a9cf4"></label>
                            体检:
                            <label class="c-9a9cf4" id="tjNum"></label>
                        </div>
                    </div>
                </div>
                <div class="div-jkda-content">
                    <div class="c-w-100 div-chart">
                        <div id="div_jkda_chart3" class="c-w-100 c-h-100">

                        </div>
                        <div class="div-instruction">
                            <div class="div-jkda-amount" id="dataNum"></div>
                            <div class="div-jkda-title">数据统计</div>
                        </div>
                    </div>
                    <div class="c-w-100 div-bottom-instruction">
                        <div class="f-mb10 f-pl30">
                            <label class="bar-a cb-9a9cf4"></label>
                            今日入库:
                            <label class="c-9a9cf4" id="tadayNum"></label>
                        </div>
                    </div>
                </div>
                <div class="div-jkda-content">
                    <div class="div-ljjzrs"></div>
                    <div style="font-size: 1.2vw;color:#333;padding: 20px 0px 10px 30px;">累计就诊人数</div>
                    <div style="font-size: 1.05vw;color:#FF807F;padding: 0px 0px 30px 30px;">每日新增<label style="color:#FF807F;" id="newNum"></label></div>
                    <div>
                        <label class="c-ffbd5c" style="margin: 0px 10px 0px 30px;font-size: 1.96vw;" id="odCountNum"></label>
                        <label style="font-size: 1.3vw;color:#333;">人</label>
                    </div>
                </div>
            </div>
            <%--电子病历--%>
            <div class="div-dzbl">
                <div class="div-jkda-header">
                    <i class="if-dzbl"></i>
                    <span class="yj-tit">电子病历</span>
                </div>
                <div>
                    <div id="div_jkda_chart4"></div>
                    <div class="div-chuizhi-xian"></div>
                    <div class="div-dzbl-content">
                        <div class="c-w-60 c-h-100 c-pr c-fl f-index10">
                            <div id="div_jkda_chart5" class="c-w-100 c-h-100">

                            </div>
                            <div class="div-instruction">
                                <div class="div-jkda-amount" id="dzCNum"></div>
                                <div class="div-jkda-title">今日住院/今日就诊</div>
                            </div>
                        </div>
                        <div class="c-w-40 c-h-100 c-fl f-fs12">
                            <div class="f-mb20 f-pt135">
                                <label class="bar-a cb-42d16f"></label>
                                今日住院:
                                <label class="c-42d16f" id="dzHosNum"></label>
                            </div>
                            <div>
                                <label class="bar-a cb-ffbd5c"></label>
                                今日就诊
                                <label class="c-ffbd5c" id="dzConNum"></label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



