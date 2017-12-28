<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### Title设置 ####### -->
<div class="div-title"><span class="span-location">江西省上饶市</span>趋势分析数据</div>
<input value="${thirdParty}" class="f-dn" id="inp_thirdParty"/>
<!-- ####### 页面部分 ####### -->
<div class="adpater-plan-modal">
  <!-- ####### 查询条件部分 ####### -->
  <div class="m-retrieve-area f-dn f-pr m-form-inline condition" data-role-form>
    <div class="m-form-group f-mt10">
      <div class="m-form-control f-mr10">
        <!--下拉框-->
        <input type="text" id="inp_orgArea" placeholder="请选择地区" data-type="comboSelect" data-attr-scan="location">
      </div>
      <div class="m-form-control">
        <input type="text" id="inp_start_date" class="validate-date l-text-field validate-date"  placeholder="请选择查询的开始时间"/>
      </div>
      <div class="m-form-control" style="width: 32px;">
        <label>--</label>
      </div>
      <div class="m-form-control">
        <input type="text" id="inp_end_date" class="validate-date l-text-field validate-date"  placeholder="请选择查询的结束时间"/>
      </div>
      <div class="m-form-control f-ml10">
        <!--按钮:查询-->
          <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
            <span><spring:message code="btn.search"/></span>
          </div>
      </div>
      <div class="m-form-control m-form-control-fr">
        <!--按钮:新增 <spring:message code="btn.create"/>-->
        <div id="btn_detail" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam f-mr10" >
          <span> 趋势分析详情</span>
        </div>
      </div>

    </div>
      <div class="div-head">
        <div class="div-items">
          <div class="div-item-title">完整性</div>
          <div class="div-item-content">
            <div class="div-item">
              <img src="${staticRoot}/images/01zhengtishuliang_icon.png">
              <span></span>
              <div class="div-item-count"></div>
              <div class="div-item-type">整体数量</div>
            </div>
            <div class="div-item">
              <img src="${staticRoot}/images/02shujuji_icon.png">
              <span></span>
              <div class="div-item-count"></div>
              <div class="div-item-type">数据集</div>
            </div>
            <div class="div-item">
              <img src="${staticRoot}/images/03shujuyuan_icon.png">
              <span></span>
              <div class="div-item-count"></div>
              <div class="div-item-type">数据元</div>
            </div>
          </div>
        </div>
        <div class="div-items" style="margin: 0px 20px;width: calc(20% - 50px);width: -moz-calc(20% - 50px);width: -webkit-calc(20% - 50px);">
          <div class="div-item-title">准确性</div>
          <div class="div-item-content">
            <div class="div-item" style="width: 100%;">
              <img src="${staticRoot}/images/04zhuquexing_icon.png">
              <span></span>
              <div class="div-item-count"></div>
              <div class="div-item-type">准确性</div>
            </div>
          </div>
        </div>
        <div class="div-items">
          <div class="div-item-title">及时性</div>
          <div class="div-item-content">
            <div class="div-item">
              <img src="${staticRoot}/images/05quanbujishi_icon.png">
              <span></span>
              <div class="div-item-count"></div>
              <div class="div-item-type">全部及时性</div>
            </div>
            <div class="div-item">
              <img src="${staticRoot}/images/06zhuyuanjishi_icon.png">
              <span></span>
              <div class="div-item-count"></div>
              <div class="div-item-type">住院病人及时性</div>
            </div>
            <div class="div-item">
              <img src="${staticRoot}/images/07menzhenjishi_icon.png">
              <span></span>
              <div class="div-item-count"></div>
              <div class="div-item-type">门诊病人及时性</div>
            </div>
          </div>
        </div>
      </div>

  </div>
</div>

<div class="div-chart-content">
    <div class="div-zuoqiehuan"></div>
    <div class="div-youqiehuan"></div>
    <div class="div-qsfx" style="">趋势分析：</div>
    <div class="div-group" style="display: none;">
       <div class="div-btn active">日</div>
      <div class="div-btn">周</div>
      <div  class="div-btn">月</div>
    </div>
  <div id="chart-main"></div>
</div>

<div class="f-pt20 f-mb20 div-organization-content">


</div>











