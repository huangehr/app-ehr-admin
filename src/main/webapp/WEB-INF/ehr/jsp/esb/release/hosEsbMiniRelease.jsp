<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.dict.manage"/></div>
<div id="div_wrapper" >
  <div style="width: 100%" id="grid_content">
    <!--######程序代码版本发布######-->
    <div id="div_left" style=" width:700px;float: left;">
      <div id="hosReleaseRetrieve" class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px">
        <div class="m-form-group f-mt10">
          <div class="m-form-control f-fs12">
            <input type="text" id="systemCode" placeholder="<spring:message code="lbl.hosRelease.searchSystemCode"/>">
          </div>
          <sec:authorize url='/esb/hosRelease/releaseInfo'>
          <div class="f-pt5 f-fr f-mr10" >
            <div title="<spring:message code="btn.create"/>" id="btn_create" class="image-create"  onclick="javascript:$.publish('hosRelease:releaseInfo:open',['','new'])"></div>
          </div>
          </sec:authorize>
        </div>
      </div>
      <div id="div_hosRelease_grid" >
      </div>
    </div>

  <!--  客户端安装结果上报日志   -->
    <div id="div_right" style="float: left;width:400px;margin-left: 10px">
      <div  class="f-h50" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px"></div>
       <div id="div_install_log_grid" ></div>
  </div>
</div>
