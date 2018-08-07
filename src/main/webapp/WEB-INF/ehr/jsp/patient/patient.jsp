<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!--######人口管理页面Title设置######-->
<div class="f-dn" data-head-title="true">人口管理</div>
<div id="div_wrapper">

    <%--新增tab切换未识别档案--%>
        <div class="f-tac f-mb20">
            <div class="btn-group" data-toggle="buttons">
                <label class="btn btn-default active" style="width: 100px;" id="known_patient"><input type="radio" name="options" autocomplete="off" checked="">已识别居民</label>
                <label class="btn btn-default" style="width: 100px;" id="unknow_archives"><input type="radio" name="options" autocomplete="off">未识别档案</label>
            </div>
        </div>

    <div class="m-retrieve-area f-dn f-pr  m-form-inline" data-role-form id="known_form">
        <%--<input type="text" id="inp_search" placeholder="输入姓名或身份证号"/>--%>
        <div class="m-form-group">
            <div class="m-form-control f-mb10">
                <!--输入框-->
                <input type="text" id="inp_search" placeholder="请输入姓名或身份证号" class="f-ml10" data-attr-scan="searchNm"/>
            </div>

            <div class="m-form-control f-ml10 f-mb10">
                <!--输入框-->
                <input type="text" id="search_homeAddress" placeholder="请输入家庭地址" class="f-ml10" data-attr-scan="homeAddress"/>
            </div>

            <%--new add--%>
            <div class="m-form-control f-ml10 f-mb10">
                <!--下拉框：性别-->
                <input type="text" id="sex" data-attr-scan="gender" placeholder="性别"/>
            </div>

            <%--new add--%>
            <div class="m-form-control f-ml10 f-mb10">
                <!--开始时间-->
                <input type="text" id="star_time" class="l-text-field" data-attr-scan="searchRegisterTimeStart" placeholder="注册起始时间"/>
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

            <div class="m-form-control m-form-control-fr f-mb10" style="float: right">
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
    <div class="m-retrieve-area f-dn f-pr  m-form-inline" data-role-form id="unknown_form" style="display: none">
            <%--<input type="text" id="inp_search" placeholder="输入姓名或身份证号"/>--%>
            <div class="m-form-group">
                <div class="m-form-control f-mb10">
                    <!--输入框-->
                    <input type="text" id="inp_name" placeholder="请输入姓名" class="f-ml10" data-attr-scan="name"/>
                </div>

                <div class="m-form-control f-ml10 f-mb10">
                    <!--输入框-->
                    <input type="text" id="inp_card_no" placeholder="请输入就诊卡号" class="f-ml10" data-attr-scan="card_no"/>
                </div>

                <%--new add--%>
                <div class="m-form-control f-ml10 f-mb10">
                    <!--下拉框：性别-->
                    <input type="text" id="inp_telephone" data-attr-scan="telephone" placeholder="请输入手机号码"/>
                </div>

                <div class="m-form-control f-ml10 f-mb10">
                    <!--按钮:查询 & 新增-->
                    <sec:authorize url="/patient/searchPatient">
                        <div id="btn_search_un" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                            <span><spring:message code="btn.search"/></span>
                        </div>
                    </sec:authorize>
                </div>
            </div>
        </div>
    <!--######人口信息表######-->
    <div id="div_patient_info_grid">

    </div>
    <!--######人口信息表#结束######-->
    <!--######未识别档案######-->
    <div id="div_unknowarchives_info_grid" style="display: none">

    </div>
    <!--######未识别档案#结束######-->
</div>

<div id="div_user_info_dialog">

</div>