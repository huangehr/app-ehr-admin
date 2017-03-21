<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="infoContent" style=" border: 1px solid rgb(214, 214, 214); overflow: auto" data-role-form>

  <div class="body-head" align="left" style="margin-left: 10px; margin-top: 10px">
    <a id="btn_back" class="f-fwb">返回上一层 </a>
  </div>

  <!-- 基础信息-->
  <div id="apiForm" class="m-form-inline"  >
    <input type="hidden" data-attr-scan="id">
    <input type="hidden" data-attr-scan="appId">
    <input type="hidden" data-attr-scan="parentId">
    <div id="div_name" class="m-form-group">
      <label>名称<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_name" class="required ajax"  data-attr-scan="name">
      </div>
    </div>

    <div id="div_methodName" class="m-form-group">
      <label>方法名<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_methodName" class="required"  data-attr-scan="methodName">
      </div>
    </div>


    <div id="div_method" class="m-form-group">
      <label>方法<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_method" data-type="select" class="required" data-attr-scan="method">
      </div>
    </div>

    <div id="div_http" class="m-form-group">
      <label>IP地址<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_http" data-type="required" class="required" data-attr-scan="microServiceUri">
      </div>
    </div>


    <div id="div_type" class="m-form-group">
      <label>类型<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_type" data-type="select" class="required" data-attr-scan="type">
      </div>
    </div>

    <div id="div_open" class="m-form-group">
      <label>开放程度<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_openLevel" data-type="select" class="required" data-attr-scan="openLevel">
      </div>
    </div>

    <div id="div_microServiceName" class="m-form-group">
      <label>微服务名<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_microServiceName" class="required"  data-attr-scan="microServiceName">
      </div>
    </div>

    <div id="div_msMethodName" class="m-form-group">
      <label>微服务方法名<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_msMethodName" data-type="select" class="required" data-attr-scan="msMethodName">
      </div>
    </div>



    <div id="div_status" class="m-form-group">
      <label>状态<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_activityType" data-type="select" class="required" data-attr-scan="activityType">
      </div>
    </div>

    <div id="div_version" class="m-form-group">
      <label>版本<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_version" class="required"  data-attr-scan="version">
      </div>
    </div>

    <div id="div_protocol" class="m-form-group">
      <label>协议<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_protocol" data-type="select" class="required" data-attr-scan="protocol">
      </div>
    </div>

    <div id="div_audit" class="m-form-group">
      <label>审计程度<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <input type="text" id="ipt_api_auditLevel" data-type="select" class="required" data-attr-scan="auditLevel">
      </div>
    </div>

    <div id="div_des" class="m-form-group" style="width: 100%">
      <label>描述<spring:message code="spe.colon"/></label>
      <div class="l-text-wrapper m-form-control essential">
        <textarea id="ipt_api_description" class="required" data-attr-scan="description"></textarea>
      </div>
    </div>

  </div>

  <!-- 请求参数 -->
  <div style="margin: 10px">
    <div class="req-parms-title">请求参数</div>
    <div id="parmsForm" class="m-retrieve-area f-h50 f-pr m-form-inline" style="line-height: 50px;border-left: 1px solid #ccc; border-right: 1px solid #ccc"></div>
    <div id="parmsGrid" ></div>
  </div>

  <!-- 参数示例 -->
  <div style="margin: 10px">
    <div class="req-parms-title">参数示例</div>
    <div>
      <textarea id="ipt_parms" data-attr-scan="parameterDemo" style="height: 200px; width: 100%"
                class="f-w240 max-length-500 validate-special-char" maxlength="500" ></textarea>
    </div>
  </div>

  <!-- 返回值 -->
  <div style="margin: 10px">
    <div class="req-parms-title">返回值</div>
    <div id="responseForm" class="m-retrieve-area f-h50 f-pr m-form-inline" style="line-height: 50px; border-left: 1px solid #ccc; border-right: 1px solid #ccc"></div>
    <div id="responseGrid" ></div>
  </div>

  <!-- 参数示例 -->
  <div style="margin: 10px">
    <div class="req-parms-title">返回值示例</div>
    <div>
      <textarea id="ipt_res_val" data-attr-scan="responseDemo" style="height: 200px; width: 100%"
                class="f-w240 max-length-500 validate-special-char" maxlength="500" ></textarea>
    </div>
  </div>

  <div align="center" style="margin: 20px">
    <div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam" >
      <span>保存</span>
    </div>

    <%--<div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam" >--%>
      <%--<span>关闭</span>--%>
    <%--</div>--%>
  </div>

</div>




