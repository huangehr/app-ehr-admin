<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">数据元</div>

<!-- ####### 页面部分 ####### -->
<div class="adpater-plan-modal">

  <!-- ####### 查询条件部分 ####### -->
  <div id="searchForm" class="m-retrieve-area f-pr m-form-inline condition" data-role-form>
    <div class="m-retrieve-inner m-form-group f-mt10">

      <div class="m-form-control f-mb10">
        <input type="text" id="ipt_search" placeholder="请输入资源标准编码或数据元名称" class="f-ml10" data-attr-scan="stdCode"/>
      </div>

      <div class="m-form-control f-ml10 f-mb10">
        <input type="text" id="ipt_search_type"  placeholder="类型" data-type="select" data-attr-scan="columnType">
      </div>

      <div class="m-form-control f-ml10 f-mb10">
        <input type="text" id="ipt_search_null_able"  placeholder="是否可为空" data-type="select" data-attr-scan="nullAble">
      </div>

      <div class="m-form-control f-ml10 f-mb10">
        <input type="text" id="ipt_search_is_valid"  placeholder="是否失效" data-type="select" data-attr-scan="valid">
      </div>

        <div class="m-form-control f-ml10 f-mb10">
            <input type="text" id="ipt_search_data_source"  placeholder="数据来源" data-type="select" data-attr-scan="dataSource">
        </div>

      <sec:authorize url="/ehr/template">
		  <a href="<%=request.getContextPath()%>/template/资源数据元导入模版.xls" class="btn u-btn-primary u-btn-small s-c0 J_add-btn f-fr f-mr10 f-mb10"
		  style="">
		  下载模版
		  </a>
	  </sec:authorize>
	  <sec:authorize url="/resource/meta/import">
      	<div id="upd" class="f-fr f-mr10 f-mb10" style="overflow: hidden; width: 84px;position: relative"></div>
	  </sec:authorize>
    </div>
  </div>

  <!--###### 查询明细列表 ######-->
  <div id="gtGrid" >

  </div>
</div>


