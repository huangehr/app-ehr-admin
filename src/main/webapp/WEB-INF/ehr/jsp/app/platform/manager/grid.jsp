<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">字典</div>

<!-- ####### 页面部分 ####### -->
<div>

    <div id="div_wrapper">

        <div id="conditionArea" class="f-mb10 f-mr10" align="right">
            <div class="body-head f-h30" align="left" style="line-height: 30px">
                <a id="btn_back" class="f-fwb">返回上一层 </a>
            </div>
        </div>

        <div id="grid_content" style="width: 100%">
            <!--   属性菜单 -->
            <div id="div_left" style=" width:360px;float: left;">
                <div id="treeMenuWrap" style="border: 1px solid #D6D6D6; width: 360px; height: 100px; overflow: hidden">
                    <div style="width: 360px">
                        <div id="treeMenu" style="margin-top: -42px;  "></div>
                    </div>
                </div>
            </div>

            <!--   列表   -->
            <div id="div_right" style="float: left;width: 700px;margin-left: 10px">
                <div id="rightGrid"></div>
            </div>
        </div>
    </div>

</div>


