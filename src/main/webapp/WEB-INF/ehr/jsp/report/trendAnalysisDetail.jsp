<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<a href="javascript:$('#contentPage').empty();$('#contentPage').load('${contextRoot}/report/initial');" class="f-fwb" style="position: absolute; top: 30px;">返回上一层 </a>

<!-- ####### Title设置 ####### -->
<div class="div-title"></div>
<input value="${location}" class="f-dn" id="inp_location"/>
<input value="${orgCode}" class="f-dn" id="inp_orgCode"/>
<input value="${orgName}" class="f-dn" id="inp_orgName"/>
<input value="${quotaId}" class="f-dn" id="inp_quotaId"/>
<input value="${startTime}" class="f-dn" id="inp_startTime"/>
<input value="${endTime}" class="f-dn" id="inp_endTime"/>

<!-- ####### 页面部分 ####### -->
<div class="adpater-plan-modal">
  <!-- ####### 查询条件部分 ####### -->
  <div class="m-retrieve-area f-dn f-pr m-form-inline condition" data-role-form>
    <div class="m-form-group f-mt10">
      <div class="m-form-control">
        <input type="text" id="inp_start_date" class="validate-date l-text-field validate-date"  placeholder="请选择查询的开始时间"/>
      </div>
      <div class="m-form-control" style="width: 32px;">
        <label>--</label>
      </div>
      <div class="m-form-control">
        <input type="text" id="inp_end_date" class="validate-date l-text-field validate-date"  placeholder="请选择查询的结束时间"/>
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











