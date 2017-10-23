<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.dict.manage"/></div>
<div id="div_wrapper" >
    <div style="width: 100%" id="grid_content">
        <!--######指标首页######-->
        <div id="div_left" style="width:100%;float: left;">
            <div id="dictRetrieve" class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px">
                <div class="m-form-group f-mt10">
                    <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                        <div>卫生业务：</div>
                    </div>
                    <div class="m-form-control f-fs12">
                        <input type="text" id="searchNm" placeholder="<spring:message code="lbl.input.placehold"/>">
                    </div>

                    <div class="m-form-control f-mr10 f-fr">
                        <sec:authorize url="/health/createHealthBusiness">
                            <div id="div_new_record" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam"  onclick="javascript:$.publish('health:healthBusinessInfo:open',['','new'])">
                                <span><spring:message code="btn.create"/></span>
                            </div>
                        </sec:authorize>
                    </div>

                </div>
            </div>
            <div id="div_stdDict_grid" >
            </div>
        </div>

    </div>
</div>
