<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<link rel="stylesheet" href="${staticRoot}/develop/lib/bootstrap/css/bootstrap.min.css">
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.dict.manage"/></div>
<div id="div_wrapper" >
  <div id="conditionArea" class="f-mb10 f-mr10" align="right" style="display: none;">

        <input type="text" data-type="select" id="stdDictVersion" data-attr-scan="version">

  </div>
  <div style="height: 45px;padding-top: 5px;">

    <sec:authorize url="/cdadict/exportToExcel">
      <div>
        <button id="div_file_export1" class="btn u-btn-primary u-btn-small s-c0 f-fr f-mr10">日志查询</button>
      </div>
    </sec:authorize>

    <sec:authorize url="/cdadict/exportToExcel">
      <div>
        <button id="div_file_export2" class="btn u-btn-primary u-btn-small s-c0 f-fr f-mr10">维度管理</button>
      </div>
    </sec:authorize>

    <sec:authorize url="/cdadict/exportToExcel">
      <div>
        <button id="div_file_export3" class="btn u-btn-primary u-btn-small s-c0 f-fr f-mr10">数据存储管理</button>
      </div>
    </sec:authorize>
    <sec:authorize url="/cdadict/exportToExcel">
    <div>
      <button id="div_file_export" class="btn u-btn-primary u-btn-small s-c0 f-fr f-mr10">数据源管理</button>
    </div>
    </sec:authorize>
  </div>

  <div style="width: 100%" id="grid_content">
    <!--######指标首页######-->
    <div id="div_left" style="width:100%;float: left;">
      <div id="dictRetrieve" class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px">
        <div class="m-form-group f-mt10">
          <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
            <div>指标：</div>
          </div>
          <div class="m-form-control f-fs12">
            <input type="text" id="searchNm" placeholder="<spring:message code="lbl.input.placehold"/>">
          </div>

          <sec:authorize url="/cdadict/saveDict">
          <div class="f-pt5 f-fl f-mr10" >
            <div title="新增" id="btn_create" class="image-create"  onclick="javascript:$.publish('stddict:dictInfo:open',['','new'])"></div>
          </div>
          </sec:authorize>

        </div>
      </div>
      <div id="div_stdDict_grid" >
      </div>
    </div>

  </div>
</div>
