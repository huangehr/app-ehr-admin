<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/9/19
  Time: 11:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="f-dn" data-head-title="true">视图注册</div>
<div id="div_wrapper" style="height: 96%;">

    <div class="v-header">
        <div class="f-fl v-h-left f-pt5">
            <div class="v-h-con c-h-l-r f-pt10 f-pb10 ">
                <input type="radio" name="dataType" value="1" checked/><span>档案数据</span>
            </div>
            <div class="v-h-con c-h-r-r f-pt10 f-pb10 ">
                <input type="radio" name="dataType" value="2"/><span>指标统计</span>
            </div>
        </div>
        <div class="f-fr c-h-right m-form-inline">
            <div class="f-db f-fr f-pt10 f-mr10" id="div_search_data_role_form">
                <%--档案数据配置按钮--%>
                <div id="daBtns" class="f-fl" style="display: none;margin-right: 3px">
                    <div id="norBtn" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span>默认参数配置</span>
                    </div>
                    <div id="dataBtn" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span>数据元配置</span>
                    </div>
                    <div id="autBtn" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span>授权</span>
                    </div>
                </div>
                <%--指标统计配置按钮--%>
                <div id="zbBtns" class="f-fl f-mr10" style="display: none">
                    <div id="zbConfigBtn" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span>指标配置</span>
                    </div>
                    <div id="zbShowBtn" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span>指标预览</span>
                    </div>
                </div>

                <div id="outBtn" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                    <span>导出</span>
                </div>

                <div class="f-ib f-vam close-toolbar" id="ddSeach">
                    <span>查询条件</span>
                    <i class="dd-icon"></i>
                    <div class="pop-main">
                        <div class="sj-icon">
                            <div class="sj-sj-icon"></div>
                        </div>
                        <div class="pop-s-con">
                            <%-- ##########搜索条件###########--%>
                            <div class="nr-dy">
                                <%--地区--%>
                                <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                    <label class="inp-label" for="inpRegion">地区: </label>
                                    <div class="inp-text">
                                        <input type="text" id="inpRegion" data-code="org_area" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums "/>
                                    </div>
                                </div>
                                <%--医疗机构--%>
                                <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                    <label class="inp-label" for="inpMechanism">医疗机构: </label>
                                    <div class="inp-text">
                                        <input type="text" id="inpMechanism" data-code="org_name" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums "/>
                                    </div>
                                </div>
                            </div>
                            <%--时间范围--%>
                            <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                <label class="inp-label" for="inpStarTime">起始日期: </label>
                                <div class="inp-text">
                                    <input type="text" id="inpStarTime" data-code="event_date" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums " readonly="readonly"/>
                                </div>
                            </div>
                            <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                <label class="inp-label" for="inpEndTime">结束日期: </label>
                                <div class="inp-text">
                                    <input type="text" id="inpEndTime" data-code="event_date" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums "/>
                                </div>
                            </div>

                            <%--动态生成条件--%>
                            <div class="" id="addSearchDom">

                            </div>
                            <%-- ##########搜索条件end###########--%>
                            <div class="f-fr pop-btns">
                                <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_reset_btn">
                                    <span>重置</span>
                                </div>
                                <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_search_btn">
                                    <span>搜索</span>
                                </div>
                                <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="save_search_btn">
                                    <span>更新条件</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ####### 查询条件部分 ####### -->
    <div id="div_content" class="f-ww contentH">
        <div id="div_left" class="f-w240 f-bd f-of-hd">
            <div class="f-mt10 f-mb10 f-ml10 f-w240">
                <input type="text" id="inpSearch" placeholder="请输入视图分类名称" class="f-ml10 f-h28"/>
            </div>
            <!--资源浏览树-->
            <div id="divTree" class="f-w230" style="height: 93%;">
                <ul id="treeDom" class="ztree" style="width: 100%;margin-right: 30px"></ul>

                <ul id="treeDomZB" class="ztree" style="display: none"></ul>
            </div>
        </div>
        <!--资源浏览详情-->
        <div id="div_right" class="div-resource-browse" style="width:100%;height:100%;position: relative;">
            <div class="div-result-msg nr-con" style="z-index: 2">
                <div id="divResourceInfoGrid"></div>
            </div>
            <div class="nr-con" style="z-index: 1">
                <div id="divQutoResourceInfoGrid"></div>
            </div>
        </div>
    </div>
</div>
