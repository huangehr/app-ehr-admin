<%--
  Created by IntelliJ IDEA.
  User: janseny
  Date: 2017/4/6
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div class="f-dn" data-head-title="true">顶级成员添加</div>
<div id="div_wrapper">
    <!-- ####### 查询条件部分 ####### -->
    <div id="div_content" class="f-ww contentH">
        <div id="div_left" class="f-w240 f-bd f-of-hd">
            <div class="f-mt10 f-mb10 f-ml10 f-w200 " style="width: 120px">
              <input type="text" id="inp_search" data-type="select"  placeholder="请选择机构" class="f-ml10 f-h28"/>
                <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                    <span><spring:message code="btn.search"/></span>
                </div>
            </div>
            <!--成员浏览树-->
            <div id="div_tree" class="f-w230">
                <div id="div_resource_browse_tree"></div>
            </div>
        </div>
        <!--成员浏览详情-->
        <div id="div_right" class="div-resource-browse">
            <div class="right-retrieve">
                <span id="categoryName" style="font-size: 16px;font-weight:900"></span>
                <input type="hidden" id="categoryId" />
                <input type="hidden" id="categoryOrgId" />

                <div class="f-db f-pt10 f-pb10 f-ml10">
                    <!--输入框-->
                    <input type="text" id="inp_searchNm" placeholder="请输入成员名称" class="f-ml10 f-h28 f-w240"
                    data-attr-scan="searchNm"/>
                </div>
                <div class="f-db f-fr f-pt10 f-mr10">
                    <sec:authorize url="/upAndDownMember/infoInitial">
                        <div id="btn_addDown" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                            <span>新增下级成员</span>
                        </div>
                    </sec:authorize>
                </div>
            </div>
            <div class="div-result-msg">
                <div id="div_resource_info_grid"></div>
            </div>
        </div>
    </div>
</div>