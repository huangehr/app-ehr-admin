<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!--######用户管理页面Title设置######-->
<div class="new_Dialogue">
    <%--<div class="title_Bk">--%>
        <%--<div class="inlinebBlock addCar">导入排班</div>--%>
        <%--<div class=" inlinebBlock close_Dialogue"></div>--%>
    <%--</div>--%>
    <div class="base_Info">
        <div class="div_info">
            <div class="sigh">
                如果该年月的排班已存在，将覆盖原来的排班记录
            </div>
        </div>
        <div class="div_year">
        </div>
        <div class="div_imfo wu-example" id="uploader" >
            <label>导入文件</label>
            <input type="text" disabled="disabled" id="thelist"  class="uploader-list"/>
            <div id="div_doctor_img_upload" class="u-upload alone f-ib f-tac f-vam u-upload-img" data-alone-file=true>
                <!--用来存放item-->
                <%--<div id="div_file_picker" class="f-mt10"><spring:message code="btn.file.choose"/></div>--%>
            </div>
        </div>
        <%--<div id="uploader" class="wu-example">--%>
            <%--<!--用来存放文件信息-->--%>
            <%--<div id="thelist" class="uploader-list"></div>--%>
            <%--<div class="btns">--%>
                <%--<div id="picker">选择文件</div>--%>
                <%--<button id="ctlBtn" class="btn btn-default">开始上传</button>--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="div_download">
            模板下载
        </div>
        <div class="div_btn">
            <div id="importbutton"></div>
            <div id="cenclebutton">取消</div>
        </div>
    </div>
</div>