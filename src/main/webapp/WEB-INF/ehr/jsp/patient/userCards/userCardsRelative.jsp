<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<style>
    .sa{
        width: 500px;
        height: 10px;
        margin-top: 10px;
        margin-bottom: 30px;
        margin-left: 20px;
    }
</style>

<!-- ####### 页面部分 ####### -->
<div id="div_wrapper" class="sa" style="display: block" >
    <div id="btn_save" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
        <span >关联保存</span>
    </div>
</div>

<!--###### 查询明细列表 ######-->
<div id="div_userCardsRelative_info_grid" ></div>
</div>


