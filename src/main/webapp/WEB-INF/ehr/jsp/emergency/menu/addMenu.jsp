
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<%@ include file="addMenuCss.jsp" %>
<!--######用户管理页面Title设置######-->
<div class="new_Dialogue">
    <div class="base_Info">
        <div class="license_plate_number divInput">
            <label>地&#12288;&#12288;点</label>
            <input type="text"id="license_Plate_input" />
        </div>
        <div class="personnel_phone divInput">
            <label>经&#12288;&#12288;度</label>
            <input type="text"id="personnel_phone_input" onkeypress="if(!this.value.match(/^[\+\-]?\d*?\.?\d*?$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))this.o_value=this.value" onkeyup="if(!this.value.match(/^[\+\-]?\d*?\.?\d*?$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))this.o_value=this.value" onblur="if(!this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?|\.\d*?)?$/))this.value=this.o_value;else{if(this.value.match(/^\.\d+$/))this.value=0+this.value;if(this.value.match(/^\.$/))this.value=0;this.o_value=this.value}" />
        </div>
        <div class="Ascription divInput">
            <label>纬&#12288;&#12288;度</label>
            <input type="text" id="inpMonitorType" onkeypress="if(!this.value.match(/^[\+\-]?\d*?\.?\d*?$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))this.o_value=this.value" onkeyup="if(!this.value.match(/^[\+\-]?\d*?\.?\d*?$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))this.o_value=this.value" onblur="if(!this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?|\.\d*?)?$/))this.value=this.o_value;else{if(this.value.match(/^\.\d+$/))this.value=0+this.value;if(this.value.match(/^\.$/))this.value=0;this.o_value=this.value}" />
        </div>
        <div class="area divInput">
            <label>所属片区</label>
            <input type="text" id="areaType"  />
        </div>
        <div class="operation">
            <input class="btn" type="button" value="确定" id="div_update_btn"/>
            <input class="btn" type="button" value="取消" id="div_cancel_btn"/>
        </div>
    </div>
</div>
<script src="${staticRoot}/lib/ligerui/plugins/ligerSpinner.js"></script>
<%@ include file="addMenuJs.jsp" %>