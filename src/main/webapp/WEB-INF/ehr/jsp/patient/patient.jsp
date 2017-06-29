<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!--######人口管理页面Title设置######-->
<div class="f-dn" data-head-title="true">人口管理</div>
<div id="div_wrapper">
    <div class="m-retrieve-area f-dn f-pr  m-form-inline" data-role-form>
        <%--<input type="text" id="inp_search" placeholder="输入姓名或身份证号"/>--%>
        <div class="m-form-group">
            <div class="m-form-control">
                <!--输入框-->
                <input type="text" id="inp_search" placeholder="请输入姓名或身份证号" class="f-ml10" data-attr-scan="searchNm"/>
            </div>


            <%--new add--%>
            <div class="m-form-control f-ml10 f-mb10">
                <!--下拉框：性别-->
                <input type="text" id="sex" data-attr-scan="gender" placeholder="性别"/>
            </div>




            <div class="m-form-control f-ml10 f-mb10">
                <!--下拉框-->
                <input type="text" id="search_homeAddress" data-type="comboSelect" data-attr-scan="homeAddress"/>
            </div>

            <%--new add--%>
            <div class="m-form-control f-ml10 f-mb10">
                <!--开始时间-->
                <input type="text" id="star_time" class="l-text-field" data-attr-scan="searchRegisterTimeStart" placeholder="注册启始时间"/>
            </div>

            <%--new add--%>
            <div class="m-form-control" style="height: 30px;line-height: 30px;">
                -
            </div>

            <%--new add--%>
            <div class="m-form-control f-ml10 f-mb10">
                <!--结束时间-->
                <input type="text" id="end_time" data-attr-scan="searchRegisterTimeEnd" placeholder="注册结束时间"/>
            </div>

            <%--&lt;%&ndash;new add&ndash;%&gt;--%>
            <%--<div class="m-form-control f-ml10 f-mb10">--%>
                <%--<!--下拉框：采集机构-->--%>
                <%--<input type="text" id="jg" data-attr-scan="jg" placeholder="请选择采集机构"/>--%>
            <%--</div>--%>



            <div class="m-form-control f-ml10 f-mb10">
                <!--按钮:查询 & 新增-->
                <sec:authorize url="/patient/searchPatient">
                    <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.search"/></span>
                    </div>
                </sec:authorize>
            </div>

            <div class="m-form-control m-form-control-fr f-mb10">
                <sec:authorize url="/patient/updatePatient">
                    <div id="div_new_patient" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.create"/></span>
                    </div>
                </sec:authorize>
            </div>
            <%--<div id="div_new_patient" class="l-button u-btn u-btn-primary u-btn-small l-button-over">
              <span>新增</span>
            </div>--%>
        </div>
    </div>
    <!--######人口信息表######-->
    <div id="div_patient_info_grid">

    </div>
    <!--######人口信息表#结束######-->
</div>
<div id="div_user_info_dialog">

</div>