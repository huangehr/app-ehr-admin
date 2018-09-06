<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<%@ include file="vehiclemMenuCss.jsp" %>
<!--######用户管理页面Title设置######-->
<div class="new_Dialogue">
    <%--<div class="title_Bk">--%>
        <%--<div class="inlinebBlock addCar">新增车辆</div>--%>
        <%--<div class=" inlinebBlock close_Dialogue"></div>--%>
    <%--</div>--%>
    <div class="base_Info">
        <p>基本信息</p>
        <div class="head_portrait flex">
            <div class="inlinebBlock head_Text">头&#12288;&#12288;像</div>
            <div class="inlinebBlock head_Img u-upload alone f-ib f-tac f-vam u-upload-img" id="div_doctor_img_upload" data-alone-file=true>
                <%--<div id="div_file_list" class="uploader-list"></div>--%>
                <%--<div  id="div_file_picker"></div>--%>
            </div>
            <%--<div id="div_doctor_img_upload" class="u-upload alone f-ib f-tac f-vam u-upload-img" data-alone-file=true>--%>
                <%--<!--用来存放item-->--%>
                <%--<div id="div_file_picker" class="f-mt10"><spring:message code="btn.file.choose"/></div>--%>
            <%--</div>--%>
            <div class="inlinebBlock head_Explain">
                注：为了前端的优质显示效果建议，图片大小控制100k以内，像素200*200以内。格式(jpg、png、gif)
            </div>
        </div>
        <div class="license_plate_number">
            <label>车 &nbsp;牌&nbsp;号</label>
            <input type="text"id="license_Plate_input" />
            <%--<label>状&nbsp;态</label>--%>
            <%--<input type="radio"name="inp_status" value="1" /><span>值班</span>--%>
            <%--<input type="radio"name="inp_status" value="0"/><span>休息</span>--%>
        </div>
        <div class="deviceCoding">
            <label>设备编号</label>
            <input type="text"id="codingInput"  />
        </div>
        <div class="personnel_phone">
            <label>随车手机</label>
            <input type="text"id="personnel_phone_input"  />
        </div>
        <div class="Ascription">
            <label>归属地点</label>
            <div class="l-text-wrapper m-form-control essential">
                <input type="text" id="inpMonitorType" data-code="typeNames" data-type="select" class="required useTitle f-pr0 inp-reset div-table-colums "/>
            </div>
        </div>
        <div class="operation">
            <input class="btn" type="button" value="确定" id="div_update_btn"/>
            <input class="btn" type="button" value="取消" id="div_cancel_btn"/>
        </div>
    </div>
</div>
<script src="${staticRoot}/lib/ligerui/plugins/ligerSpinner.js"></script>
<%@ include file="vehiclemMenuJs.jsp" %>