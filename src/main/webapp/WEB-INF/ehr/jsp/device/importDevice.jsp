<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!--######用户管理页面Title设置######-->
<div class="new_Dialogue">
    <div class="base_Info">
        <%--<div class="div_info">--%>
            <%--<div class="sigh">--%>
                <%--如果该年月的排班已存在，将覆盖原来的排班记录--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="div_year">
        </div>
        <div class="div_imfo wu-example" id="uploader" >
            <label>导入文件</label>
            <input style="padding-left:10px;" type="text" readonly id="thelist"  class="uploader-list"/>
            <div style="display: inline-block;position: relative;" >
                <div id="import_button"></div>
            </div>
        </div>
        <div class="div_download">
            模板下载
        </div>
        <div class="div_btn">
            <div id="okbutton" class="l-button u-btn u-btn-primary u-btn-small f-ib f-va">导入</div>
            <div id="cancelbutton" class="l-button u-btn u-btn-small f-ib f-va">取消</div>
        </div>
    </div>
</div>