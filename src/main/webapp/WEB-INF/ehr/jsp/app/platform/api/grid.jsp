<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">应用api</div>

<!-- ####### 页面部分 ####### -->
<div id="div_wrapper">
    <div id="grid_content" style="width: 100%">
        <!--   属性菜单 -->
        <%--<div id="div_left">--%>

            <%--<div id="l_searchForm" style="border: 1px solid rgb(214, 214, 214); border-bottom: none"--%>
                 <%--class="m-retrieve-area f-h50 f-pr m-form-inline condition" data-role-form>--%>
                <%--<div class="m-retrieve-inner m-form-group f-mt10 l-tools" style="margin-left: 10px;">--%>
                    <%--<div class="m-form-control">--%>
                        <%--<input type="text" id="l_search_name" placeholder="请输入关键词" class="f-ml10" data-attr-scan="name"/>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</div>--%>

            <%--<div id="treeMenuWrap">--%>
                <%--<div style="width: 360px">--%>
                    <%--<div id="treeMenu" style="margin-top: -42px;  "></div>--%>
                <%--</div>--%>
            <%--</div>--%>

        <%--</div>--%>


        
        <!--   列表   -->
        <div id="div_right">
            <div id="r_searchForm"
                 class="m-retrieve-area f-h50 f-pr m-form-inline condition" data-role-form>
                <div class="m-retrieve-inner m-form-group f-mt10 r-tools" style="margin-left: 10px;">
                    <input type="hidden" id="parentId" data-attr-scan="appId">
                    <div class="m-form-control">
                        <input type="text" id="r_search_name" placeholder="请输入名称" class="f-ml10" data-attr-scan="name"/>
                    </div>
                    <div class="m-form-control f-ml10">
                        <input type="text" id="r_search_open_lv"  placeholder="开放程度" data-type="select" data-attr-scan="openLevel">
                    </div>

                    <div class="m-form-control m-form-control-fr" style="margin-left: 10px">
                        <div id="btn_add" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
                            <span ><spring:message code="btn.create"/></span>
                        </div>
                    </div>
                </div>
            </div>

            <div id="rightGrid"></div>
        </div>
    </div>
</div>


