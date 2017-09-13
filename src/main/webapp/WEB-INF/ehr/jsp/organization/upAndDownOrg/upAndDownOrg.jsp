<%--
  Created by IntelliJ IDEA.
  User: janseny
  Date: 2017/4/14
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div class="f-dn" data-head-title="true">下级机构设置</div>
<div id="div_wrapper">
    <!-- ####### 查询条件部分 ####### -->
    <div id="div_content" class="f-ww contentH">
        <div id="div_left" class="f-w240 f-bd f-of-hd">
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
                <div class="f-db f-fr f-mr10">
                    <sec:authorize url="/upAndDownorg/infoInitial">
                        <div id="btn_addDown" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                            <span>新增下级机构</span>
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