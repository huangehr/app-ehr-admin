<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/10/20
  Time: 10:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!-- ####### 页面部分 ####### -->
<div class="adpater-plan-modal">
    <!-- ####### 查询条件部分 ####### -->
    <div id="searchForm" class="m-retrieve-area f-h50 f-pr m-form-inline condition" data-role-form>
        <div id="sf-bar" class="m-retrieve-inner m-form-group f-mt10">
            <div class="f-fr f-mr10">
                <div id="downLoad" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam u-btn-lar">
                    <span>导出错误信息</span>
                </div>
                <div id="saveBtn" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam u-btn-lar">
                    <span>保存</span>
                </div>
            </div>
        </div>
    </div>

    <!--###### 查询明细列表 ######-->
    <div id="gridForm" data-role-form>
        <div id="impGrid" style="margin: 0 10px;">

        </div>
    </div>

</div>