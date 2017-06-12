<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<link rel="stylesheet" href="${staticRoot}/lib/bootstrap/css/bootstrap.min.css">
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.dict.manage"/></div>
<div id="div_wrapper" style="height: 100%;overflow: hidden;">
  <div id="conditionArea" class="f-mb10 f-mr10" align="right" style="display: none;">

        <input type="text" data-type="select" id="stdDictVersion" data-attr-scan="version">

  </div>

  <div style="width: 100%;height: 100%;" id="grid_content">
  <!--   指标详情   border: 1px solid #D6D6D6-->
    <div id="div_right" style="float: left;width: 100%;height: 100%;padding-left: 10px; ">
      <div id="entryRetrieve" class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" style="padding-bottom: 100px;display:block;border-bottom: 0">
        <div class="pop_tab">
          <ul>
            <li class="cur" id="btn_basic">主维度</li>
            <li id="btn_card">细维度</li>
          </ul>
        </div>

        <div class="m-form-group f-mt10 f-pt50">
          <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
            <div>维度：</div>
          </div>
          <div class="m-form-control f-fs12">
            <input type="text" id="searchNmEntry" placeholder="<spring:message code="lbl.input.placehold"/>">
          </div>
        </div>
        <div style="position: absolute;left: calc(55% - -20px);top: 60px;font-size: 14px;font-weight: bold;">已选中维度：</div>
      </div>

      <div style="width: 100%;height: 435px;">
        <div id="div_relation_grid" style="float: left;">

        </div>
        <div style="width: 20px;float: left;">
                <div style="background: url(${staticRoot}/images/zhixiang_icon.png) no-repeat;width: 20px;height: 40px;margin-top: 224px;margin-left: 2px;">

                </div>
        </div>
        <div id="div_relation_grid1" style="float: right;margin-right: 16px;">

        </div>
      </div>

    </div>
  </div>
</div>
