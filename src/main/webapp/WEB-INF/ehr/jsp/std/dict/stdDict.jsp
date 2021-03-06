<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.dict.manage"/></div>
<div id="div_wrapper" >

  <div style="height: 38px">
    <sec:authorize url="/template/平台标准字典导入模版.xls">
    <a href="<%=request.getContextPath()%>/template/平台标准字典导入模版.xls" class="btn u-btn-primary u-btn-small s-c0 J_add-btn f-fl f-mr10"
       style="">
      下载模版
    </a>
    </sec:authorize>

    <sec:authorize url="/cdadict/importFromExcel">
    <div id="upd" class="f-fl f-mr10" style="overflow: hidden; width: 84px; position: relative"></div>
    </sec:authorize>

    <sec:authorize url="/cdadict/exportToExcel">
    <div>
      <button id="div_file_export" class="btn u-btn-primary u-btn-small s-c0 f-fl f-mr10" style="margin-top: 0px;height: 30px">全部导出</button>
    </div>
    </sec:authorize>


    <div id="conditionArea" class="f-mb10 f-mr10 f-fr" align="right">

      <input type="text" data-type="select" id="stdDictVersion" data-attr-scan="version">

    </div>
  </div>

  <div style="width: 100%" id="grid_content">
    <!--######标准字典######-->
    <div id="div_left" style=" width:400px;float: left;">
      <div id="dictRetrieve" class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px">
        <div class="m-form-group f-mt10">
          <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
            <div>字典：</div>
          </div>
          <div class="m-form-control f-fs12">
            <input type="text" id="searchNm" placeholder="<spring:message code="lbl.input.placehold"/>">
          </div>

          <sec:authorize url="/cdadict/saveDict">
          <div class="f-pt5 f-fr f-mr10" >
            <div title="新增" id="btn_create" class="image-create"  onclick="javascript:$.publish('stddict:dictInfo:open',['','new'])"></div>
          </div>
          </sec:authorize>

        </div>
      </div>
      <div id="div_stdDict_grid" >
      </div>
    </div>

  <!--   字典详情   -->
    <div id="div_right" style="float: left;width: 700px;margin-left: 10px">
      <div id="entryRetrieve" class="m-retrieve-area f-dn f-pr m-form-inline" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0">
        <div class="m-form-group f-mt10" style="padding-bottom: 0">
          <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10 f-mb10">
            <div>字典项：</div>
          </div>
          <div class="m-form-control f-fs12 f-mb10">
            <input type="text" id="searchNmEntry" placeholder="<spring:message code="lbl.input.placehold"/>">
          </div>

          <sec:authorize url="/cdadict/deleteDictEntryList">
          <div class=" f-mb10">
            <a id="btn_Delete_relation" class="btn u-btn-primary u-btn-small s-c0 J_add-btn f-fr f-mr20 f-mb10"
               href="javascript:$.publish('entry:dictInfoGrid:delete',[''])" href="#">
              <spring:message code="btn.multi.delete"/>
            </a>
          </div>
          </sec:authorize>

          <sec:authorize url="/cdadict/saveDictEntry">
          <div class=" f-mb10">
            <a id="btn_create_relation" class="btn u-btn-primary u-btn-small s-c0 J_add-btn f-fr f-mr10 f-mb10"
               href="javascript:$.publish('entry:dictInfo:open',['','','new'])">
              <spring:message code="btn.create"/>
            </a>
          </div>
          </sec:authorize>

        </div>
      </div>
      <div id="div_relation_grid" ></div>
    </div>
  </div>
</div>
