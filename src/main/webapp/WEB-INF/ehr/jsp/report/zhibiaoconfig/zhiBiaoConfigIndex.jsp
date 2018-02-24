<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.dict.manage"/></div>
<div id="div_wrapper" >
  <div class="f-tac f-mb20">
    <div class="btn-group" data-toggle="buttons">
      <label class="btn btn-default active" style="width: 100px;" id="switch_dataSource"><input type="radio" name="options" autocomplete="off" checked="">数据源管理</label>
      <label class="btn btn-default" style="width: 100px;" id="switch_dataStoage"><input type="radio" name="options" autocomplete="off">数据存储管理</label>
      <label class="btn btn-default" style="width: 100px;" id="switch_dimension"><input type="radio" name="options" autocomplete="off">默认维度管理</label>
      <label class="btn btn-default" style="width: 100px;" id="switch_slave_dimension"><input type="radio" name="options" autocomplete="off">可选维度管理</label>
    </div>
  </div>

  <!-- ####### 查询条件部分 ####### -->
  <div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" data-role-form>
    <div class="m-form-group f-mt10 ">

      <div class="div-datasource-search">
        <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
          <div>数据源：</div>
        </div>
        <div class="m-form-control">
          <!--输入框-->
          <input type="text" id="inp_datasource_search" placeholder="请输入名称" class="f-ml10" data-attr-scan="searchNm"/>
        </div>
      </div>

      <div class="div-datastorage-search f-dn">
        <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
          <div>数据存储：</div>
        </div>
        <div class="m-form-control">
          <!--输入框-->
          <input type="text" id="inp_datastorage_search" placeholder="请输入名称" class="f-ml10" data-attr-scan="searchNm"/>
        </div>
      </div>

      <div class="div-main-search f-dn">
        <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
          <div>维度：</div>
        </div>
        <div class="m-form-control">
          <!--输入框-->
          <input type="text" id="inp_main_search" placeholder="请输入名称" class="f-ml10" data-attr-scan="searchNm"/>
        </div>
      </div>

      <div class="div-slave-search f-dn">
        <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
          <div>维度：</div>
        </div>
        <div class="m-form-control">
          <!--输入框-->
          <input type="text" id="inp_slave_search" placeholder="请输入名称" class="f-ml10" data-attr-scan="searchNm"/>
        </div>
      </div>

      <div class="m-form-control f-mr10 f-fr">
        <sec:authorize url="/tjDimensionMain/updateTjDimensionMain">
          <div id="div_new_record" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam"  onclick="javascript:$.publish('zhibiao:zhiBiaoInfo:open',['','new'])">
            <span><spring:message code="btn.create"/></span>
          </div>
        </sec:authorize>
      </div>
    </div>
  </div>

  <!--######数据源管理表######-->
  <div id="div_datasource_info_grid">

  </div>
  <!--######数据源管理表#结束######-->

  <!--######数据存储管理表######-->
  <div id="div_datastorage_info_grid">

  </div>
  <!--######数据存储管理表#结束######-->

  <!--######默认维度管理表######-->
  <div id="div_weidu_info_grid">

  </div>
  <!--######默认维度管理表#结束######-->

  <!--######可选维度管理表######-->
  <div id="div_slave_weidu_info_grid" >

  </div>
  <!--######可选维度管理表#结束######-->

</div>
