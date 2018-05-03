<%--
  Created by IntelliJ IDEA.
  User: 黄仁伟
  Date: 2018/3/28
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div class="dc-main animated fadeInRight" id="dcApp" style="display: none">
    <div class="dc-body">
        <div class="dc-left">
            <!--大圆-->
            <div class="dc-big-circle">
                <div class="dc-circle-item item-one active loaded" v-on:click="change(0)" >
                    <div class="dc-img"><img src="${staticRoot}/images/shujuzili_icon.png" alt=""></div>
                    <div class="dc-label">数据治理</div>
                </div>
                <div class="dc-img1 item-one dc-icon0 active"><img src="${staticRoot}/images/shujuzili_icon.png" alt=""></div>

                <div class="dc-circle-item item-two " v-on:click="change(1)">
                    <div class="dc-img"><img src="${staticRoot}/images/shujufenxi_icon.png" alt=""></div>
                    <div class="dc-label">数据分析</div>
                </div>
                <div class="dc-img1 item-two dc-icon1"><img src="${staticRoot}/images/shujufenxi_icon.png" alt=""></div>

                <div class="dc-circle-item item-three" v-on:click="change(2)">
                    <div class="dc-img"><img src="${staticRoot}/images/keshihua_icon.png" alt=""></div>
                    <div class="dc-label">可视化</div>
                </div>
                <div class="dc-img1 item-three dc-icon2"><img src="${staticRoot}/images/keshihua_icon.png" alt=""></div>

                <div class="dc-circle-item item-four" v-on:click="change(3)">
                    <div class="dc-img"><img src="${staticRoot}/images/fenjiguanli_icon.png" alt=""></div>
                    <div class="dc-label">分级管理</div>
                </div>
                <div class="dc-img1 item-four dc-icon3"><img src="${staticRoot}/images/fenjiguanli_icon.png" alt=""></div>
                <div class="dc-info-circle">
                    <%--<div class="dc-icon">--%>
                        <%--<img :src="itemData[index].icon" alt="">--%>
                    <%--</div>--%>
                    <div class="item-info">
                        <div class="item-tit"><span class="" v-text="itemData[index].title"></span></div>
                        <div class="item-con"><span class="" v-text="itemData[index].content"></span></div>
                    </div>
                </div>
            </div>
            <!--环绕的小圆-->
            <div class="dc-little-circle1"></div>
            <div class="dc-little-circle" id="runningDom">
                <div class="container">
                    <div class="dot"></div>
                    <div class="pulse"></div>
                    <div class="pulse1"></div>
                </div>
            </div>
        </div>
        <div class="dc-right">
            <%--全屏按鈕--%>
            <div class="qp-icon" v-on:click="toggleFullscreen"></div>
            <!--数据治理-->
            <div class="dc-item-info fadeInUp">
                <h3 class="dc-r-titO">数据治理</h3>
                <p class="dc-r-con">数据治理是要在大数据生命周期、医疗数据种类及特征的基础上,提出医疗大数据生命周期模型,并基于此模型提出医疗大数据治理的问题、目标及具体措施,包括数据标准的制定、元数据管理、医疗数据质量管理以及数据生命周期管理等。</p>
                <h4 class="dc-r-titT">标准管理</h4>
                <ul class="ui-grid">
                    <li class="ui-col-1">
                        <div class="dc-bz-icon ptbz-icon"></div>
                        <div class="dc-dz-tit" >平台标准</div>
                        <%--<div class="dc-dz-num">472456472</div>--%>
                        <%--<a class="dc-dz-info" href="javascript:;" v-on:click="checkInfo">查看详情</a>--%>
                    </li>
                    <li class="ui-col-1">
                        <div class="dc-bz-icon ccpt-icon"></div>
                        <div class="dc-dz-tit">存储平台</div>
                        <%--<div class="dc-dz-num">472456472</div>--%>
                        <%--<a class="dc-dz-info" href="javascript:;">查看详情</a>--%>
                    </li>
                    <li class="ui-col-1">
                        <div class="dc-bz-icon sjzd-icon"></div>
                        <div class="dc-dz-tit">数据字典</div>
                        <%--<div class="dc-dz-num">472456472</div>--%>
                        <%--<a class="dc-dz-info" href="javascript:;">查看详情</a>--%>
                    </li>
                </ul>
                <h4 class="dc-r-titT">数据采集</h4>
                <div class="dc-cj" v-on:click="checkInfo(dataHandle[0].appId, dataHandle[0].menuId)">
                    <div class="dc-cj-left">
                        <div class="dc-cj-icon"></div>
                        <div class="dc-cj-tit">数据采集总量</div>
                        <div class="dc-cj-num">{{dataHandle[0].total||0  | formatNumber}}</div>
                    </div>
                    <%--图表1--%>
                    <div class="dc-cj-right">
                        <div id="echart1" class="chart-div"></div>
                    </div>
                </div>
                <h4 class="dc-r-titT">数据存储</h4>
                <ul class="ui-grid ui-grid-middle dc-cc" v-on:click="checkInfo(dataHandle[1].appId, dataHandle[1].menuId)">
                    <li class="ui-col-1 dc-cc-item">
                        <div class="dc-cc-icon jm-icon"></div>
                        <div class="dc-cc-tit">居民建档数</div>
                        <div class="dc-cc-num" >{{dataHandle[1].view[1][0].patient | formatNumber}}</div>
                    </li>
                    <li class="ui-col-1 dc-cc-item">
                        <div class="dc-cc-icon yl-icon"></div>
                        <div class="dc-cc-tit">医疗资源建档数</div>
                        <div class="dc-cc-num">{{dataHandle[1].view[1][1].medicalResources | formatNumber}}</div>
                    </li>
                    <li class="ui-col-1 dc-cc-item">
                        <div class="dc-cc-icon jk-icon"></div>
                        <div class="dc-cc-tit">健康档案建档数</div>
                        <div class="dc-cc-num">{{dataHandle[1].view[1][2].healthArchive | formatNumber}}</div>
                    </li>
                    <li class="ui-col-1 dc-cc-item">
                        <div class="dc-cc-icon dz-icon"></div>
                        <div class="dc-cc-tit">电子病历建档数</div>
                        <div class="dc-cc-num">{{dataHandle[1].view[1][3].electronicCases | formatNumber}}</div>
                    </li>
                </ul>
            </div>
            <!--数据分析-->
            <div class="dc-item-info">
                <h3 class="dc-r-titO">数据分析</h3>
                <p class="dc-r-con">大数据分析过程包括从异构数据源采集数据，对数据进行预处理，使用统计分析模型、机器学习方法及自然语言处理逻辑，结合应用的分析模型，完成整个分析过程。通过分布式缓存、分布式计算、流式计算等技术方案完成大数据分析。</p>
                <h4 class="dc-r-titT">已注册指标</h4>
                <div class="dc-zb" v-on:click="checkInfo(dataAnalysis.appId, dataAnalysis.menuId)">
                    <div class="dc-zb-top">
                        <div class="dc-zb-icon"></div>
                        <div class="dc-zb-con">
                            <div class="dc-zb-lab">指标总数</div>
                            <div class="dc-zb-num">{{dataAnalysis.total |  formatNumber}}</div>
                        </div>
                    </div>
                    <%--图表2--%>
                    <div class="dc-zb-bottom">
                        <div id="echart2" class="chart-div"></div>
                    </div>
                </div>
            </div>

            <!--可视化配置-->
            <div class="dc-item-info">
                <h3 class="dc-r-titO">可视化配置</h3>
                <p class="dc-r-con">大数据的分析结果，最终要通过直观的可视化界面来展示。它能够帮助大数据获得完整的数据视图并挖掘数据的价值。大数据分析和可视化应该无缝连接，这样才能在大数据应用中发挥最大的功效。</p>
                <h4 class="dc-r-titT">已配置视图</h4>
                <div class="dc-ksh ui-grid ui-grid-middle" v-on:click="checkInfo(dataVisualization[0].appId, dataVisualization[0].menuId)">
                    <div class="dc-ksh-left ui-col-0">
                        <div class="dc-ksh-icon"></div>
                        <div class="dc-ksh-tit">视图总数</div>
                        <div class="sc-ksh-num">{{dataVisualization[0].total | formatNumber}}</div>
                    </div>
                    <%--图表3--%>
                    <div class="dc-ksh-right ui-col-1">
                        <div id="echart3" class="chart-div"></div>
                    </div>
                </div>
                <h4 class="dc-r-titT">已配置资源报表</h4>
                <div class="dc-ksh ui-grid ui-grid-middle" v-on:click="checkInfo(dataVisualization[1].appId, dataVisualization[1].menuId)">
                    <div class="dc-ksh-left ui-col-0">
                        <div class="dc-ksh-icon zybb-icon"></div>
                        <div class="dc-ksh-tit">资源报表总数</div>
                        <div class="sc-ksh-num">{{dataVisualization[1].total | formatNumber}}</div>
                    </div>
                    <%--图表4--%>
                    <div class="dc-ksh-right ui-col-1">
                        <div id="echart4" class="chart-div"></div>
                    </div>
                </div>
            </div>

            <!--分级管理-->
            <div class="dc-item-info">
                <h3 class="dc-r-titO">分级管理</h3>
                <p class="dc-r-con">安全控制与授权管理体系主要为平台在运行过程中数据安全和隐私保护等提供支持。授权据用户对区域卫生信息平台系统的使用性质的不同进行授权分级管理，系统支持对用户、角色、资源和权限的标准化管理，实施权限管理和权限的分配。</p>
                <a class="dc-fj-item" href="javascript:;" v-on:click="checkInfo(dataHM[0].appId, dataHM[0].menuId)">
                    <div class="dc-fj-left">
                        <div class="dc-fj-icon jgsq-icon"></div>
                    </div>
                    <div class="dc-fj-info">
                        <div class="dc-fj-tit">机构数据授权</div>
                        <div class="dc-fj-con">允许管理和控制接入机构的数据访问策略，严格控制机构内的访问权限。</div>
                    </div>
                </a>
                <a class="dc-fj-item" href="javascript:;" v-on:click="checkInfo(dataHM[1].appId, dataHM[1].menuId)">
                    <div class="dc-fj-left">
                        <div class="dc-fj-icon yysq-icon"></div>
                    </div>
                    <div class="dc-fj-info">
                        <div class="dc-fj-tit">应用授权</div>
                        <div class="dc-fj-con">进一步管理和控制机构接入应用的视图访问权限及API访问权限。</div>
                    </div>
                </a>
                <a class="dc-fj-item" href="javascript:;" v-on:click="checkInfo(dataHM[2].appId, dataHM[2].menuId)">
                    <div class="dc-fj-left">
                        <div class="dc-fj-icon jssq-icon"></div>
                    </div>
                    <div class="dc-fj-info">
                        <div class="dc-fj-tit">角色授权</div>
                        <div class="dc-fj-con">启用访问控制功能，依据安全策略控制用户对平台系统的访问，能识别不同的用户和角色提供不同范围和层次的数据和功能访问的能力。</div>
                    </div>
                </a>
            </div>

        </div>
    </div>
</div>
