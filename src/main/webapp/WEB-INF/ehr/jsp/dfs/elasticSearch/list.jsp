<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.dict.manage"/></div>
<div id="div_wrapper" >
    <div style="width: 100%" id="grid_content">
        <!--######ElasticSearch首页######-->
        <div id="div_left" style="width:100%;float: left;">
            <div id="dictRetrieve" class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px">
                <div class="m-form-group f-mt10">
                    <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                        <div>索引名称：</div>
                    </div>
                    <div class="m-form-control f-fs12">
                        <input type="text" id="indexNm" value="medical_service_index" class="f-ml10" placeholder="请输入索引名称">
                    </div>
                    <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                        <div>索引类型：</div>
                    </div>
                    <div class="m-form-control f-fs12">
                        <input type="text" id="indexType" value="medical_service" placeholder="请输入索引类型">
                    </div>
                    <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                        <div>指标编码：</div>
                    </div>
                    <div class="m-form-control f-fs12">
                        <input type="text" id="quotaCode" placeholder="请输入指标编码">
                    </div>
                    <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                        <div>结果>=</div>
                    </div>
                    <div class="m-form-control f-fs12">
                        <input type="text" id="begin" placeholder="起始数值">
                    </div>
                    <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                        <div><=</div>
                    </div>
                    <div class="m-form-control f-fs12">
                        <input type="text" id="end" placeholder="结束数值">
                    </div>
                    <div class="m-form-control f-ml10 f-mb10">
                        <!--按钮:查询-->
                        <sec:authorize url="/elasticSearch/searchElasticSearch">
                            <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                                <span><spring:message code="btn.search"/></span>
                            </div>
                        </sec:authorize>
                    </div>
                    <div class="m-form-control f-mr10 f-fr">
                        <sec:authorize url="/elasticSearch/createElasticSearch">
                            <div id="div_new_record" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam"  onclick="javascript:$.publish('elastic:elasticInfo:open',['','','','new'])">
                                <span><spring:message code="btn.create"/></span>
                            </div>
                        </sec:authorize>
                    </div>

                </div>
            </div>
            <div id="elasticSearch" >
            </div>
        </div>

    </div>
</div>
