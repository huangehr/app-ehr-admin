<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true">标准适配</div>
<div id="div_wrapper" style="overflow: visible;">
  <div id="conditionArea" class="f-mb10 f-mr10" align="right">
    <div class="body-head f-h50" align="left">
      <a href="#" id="gohis" class="f-fwb">返回上一层 </a>
      <input id="adapter_plan_id" value='${adapterPlanId}' hidden="none" />
      <span class="f-ml20">方案类别：</span><input class="f-fwb f-mt10" readonly id="adapter_scheme_type"/>
      <span class="f-ml20">方案名称：</span><input class="f-mt10" readonly id="adapter_scheme_name"/>
      <span class="f-ml20">方案编码：</span><input class="f-mt10" readonly id="adapter_scheme_code"/>
    </div>
    <div class="switch f-tac f-h50">
      <button id="switch_dataSet" class="btn btn-primary f-mt10"><spring:message code="lbl.dataset"/></button>
      <button id="switch_dict" class="btn f-mt10"><spring:message code="lbl.dict"/></button>
    </div>
  </div>

  <div id="grid_content" style="width: 100%">
    <div id="div_left" class="f-fl f-w400">
      <div id="retrieve" class="m-retrieve-area f-h50 f-dn f-pr" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0">
        <ul>
          <li class=" f-mt15">
            <div class="f-fl f-ml10">
              <input type="text" id="searchNm"  class="f-fs12" placeholder="<spring:message code="lbl.input.placehold"/>">
            </div>
          </li>
        </ul>
      </div>
      <div id="div_left_grid" >

      </div>
    </div>


    <div id="div_right" style="float: left;width: 700px;margin-left: 10px">
      <div id="entryRetrieve" class="m-retrieve-area f-h50 f-dn f-pr" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px">
        <ul>
          <li class=" f-mt15">
            <div style="margin-left: 340px;">
            </div>
          </li>
        </ul>
      </div>
      <div id="div_relation_grid" ></div>
    </div>
  </div>
</div>
