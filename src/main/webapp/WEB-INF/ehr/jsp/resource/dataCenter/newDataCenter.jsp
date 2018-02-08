<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script src="${contextRoot}/static-dev/base/avalon/avalon2.js"></script>

<div ms-controller="dataCenter">
    <div class="tmp-top">
        <div class="top-list">
            <a class="tmp-top-item tm-one" href="#div1">
                <div class="tmp-tit">居民建档数</div>
                <div class="tmp-num" ms-text="byNum"></div>
                <div class="tm-icon icon-one"></div>
            </a>
            <a class="tmp-top-item tm-two" href="#div2">
                <div class="tmp-tit">医疗资源建档数</div>
                <div class="tmp-num" ms-text="mbNum"></div>
                <div class="tm-icon icon-two"></div>
            </a>
            <a class="tmp-top-item tm-three" href="#div3">
                <div class="tmp-tit">健康档案建档数</div>
                <div class="tmp-num" ms-text="jzNum"></div>
                <div class="tm-icon icon-three"></div>
            </a>
            <a class="tmp-top-item tm-four" href="#div4">
                <div class="tmp-tit">电子病历建档数</div>
                <div class="tmp-num" ms-text="zzNum"></div>
                <div class="tm-icon icon-four"></div>
            </a>
        </div>
    </div>
    <div class="hr-body" style="padding-bottom: 15px;padding-left: 15px;padding-right: 15px;">
        <%--全员人口个案库--%>
        <div class="row mg-0 hr-c-top" id="div1">
            <div class="big-tit">
                <div class="big-con">
                    <i class="bt-icon bt-i-one"></i><span class="bt-txt">全员人口个案库</span>
                </div>
            </div>
            <div class="hr-chart-top col-sm-4 pd-r-0  pd-l-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">健康卡绑定情况</div>
                    </div>
                    <div id="charts1" class="hr-chart charts-con" data-color="" data-xy-change="false"></div>
                </div>
            </div>
            <div class="hr-chart-top col-sm-8 pd-l-0 pd-r-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">人口个案信息分布</div>
                    </div>
                    <div id="charts2" class="hr-chart charts-con" data-color="" data-xy-change="false"></div>
                </div>
            </div>
            <div class="hr-chart-top col-sm-12 pd-l-0 pd-r-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">人口个案新增情况</div>
                    </div>
                    <div id="charts3" class="hr-chart charts-con charts-con-new" data-color="" data-xy-change="false"></div>
                </div>
            </div>
        </div>
        <%--医疗资源库--%>
        <div class="row mg-0 hr-c-top" id="div2">
            <div class="big-tit">
                <div class="big-con">
                    <i class="bt-icon bt-i-two"></i><span class="bt-txt">医疗资源库</span>
                </div>
            </div>
            <div class="hr-chart-top col-sm-12 pd-l-0 pd-r-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">医疗机构建档分布</div>
                    </div>
                    <div id="charts4" class="hr-chart charts-con charts-con-jd" data-color="" data-xy-change="false"></div>
                </div>
            </div>
            <div class="hr-chart-top col-sm-8 pd-r-0 pd-l-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">医疗人员分布</div>
                    </div>
                    <div id="charts5" class="hr-chart charts-con" data-color="" data-xy-change="false"></div>
                </div>
            </div>
            <div class="hr-chart-top col-sm-4 pd-l-0 pd-r-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">医护人员比例</div>
                    </div>
                    <div id="charts6" class="hr-chart charts-con" data-color="" data-xy-change="false"></div>
                </div>
            </div>
        </div>
        <%--健康档案--%>
        <div class="row mg-0 hr-c-top" id="div3">
            <div class="big-tit">
                <div class="big-con">
                    <i class="bt-icon bt-i-three"></i><span class="bt-txt">健康档案</span>
                </div>
            </div>
            <div class="hr-chart-top col-sm-2 pd-r-0 pd-l-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <%--<div class="c-title">档案来源分布情况</div>--%>
                    </div>
                    <div class="hr-chart" data-color="" data-xy-change="false" style="padding: 68px 0 0 25px;">
                        <div class="cd-label" style="background: #FF9999;">累计整合档案数:</div>
                        <div class="cd-num" style="margin-bottom: 15px;background: #FF9999;" ms-text="ljzhNum"></div>
                        <div class="cd-label" style="background: #49d2db;">累计待整合档案数:</div>
                        <div class="cd-num" ms-text="ljdzhNum" style="background: #49d2db;"></div>
                    </div>
                </div>
            </div>
            <div class="hr-chart-top col-sm-5  pd-l-0 pd-r-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">档案来源分布情况</div>
                    </div>
                    <div id="charts7" class="hr-chart charts-con" data-color="" data-xy-change="false"></div>
                </div>
            </div>
            <div class="hr-chart-top col-sm-5 pd-l-0 pd-r-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">健康档案分布情况</div>
                    </div>
                    <div id="charts8" class="hr-chart charts-con" data-color="" data-xy-change="false"></div>
                </div>
            </div>
            <div class="hr-chart-top col-sm-12 pd-l-0 pd-r-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">健康档案入库情况分析</div>
                    </div>
                    <div id="charts9" class="hr-chart charts-con charts-con-rk" data-color="" data-xy-change="false"></div>
                </div>
            </div>
        </div>

        <div class="row mg-0 hr-c-top" id="div4">
            <div class="big-tit">
                <div class="big-con">
                    <i class="bt-icon bt-i-four"></i><span class="bt-txt">电子病历</span>
                </div>
            </div>
            <div class="hr-chart-top col-sm-4 pd-r-0 pd-l-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">电子病历来源分布情况</div>
                    </div>
                    <div id="charts10" class="hr-chart charts-con" data-color="" data-xy-change="false"></div>
                </div>
            </div>
            <div class="hr-chart-top col-sm-4 pd-l-0 pd-r-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">电子病历采集医院分布</div>
                    </div>
                    <div id="charts11" class="hr-chart charts-con" data-color="" data-xy-change="false"></div>
                </div>
            </div>
            <div class="hr-chart-top col-sm-4 pd-l-0 pd-r-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">电子病历采集科室分布</div>
                    </div>
                    <div id="charts12" class="hr-chart charts-con" data-color="" data-xy-change="false"></div>
                </div>
            </div>
            <div class="hr-chart-top col-sm-12 pd-l-0 pd-r-0">
                <div class="charts">
                    <div class="hr-tit-con">
                        <div class="c-title">电子病历采集情况</div>
                    </div>
                    <div id="charts13" class="hr-chart charts-con charts-con-cj" data-color="" data-xy-change="false"></div>
                </div>
            </div>
        </div>
    </div>
</div>