<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!--######医生管理页面Title设置######-->
<div class="f-dn" data-head-title="true">医生管理</div>
<div id="div_wrapper">
    <div class="m-retrieve-area f-h50 f-dn f-pr  m-form-inline" data-role-form>
        <%--<input type="text" id="inp_search" placeholder="输入姓名或身份证号"/>--%>
        <div class="m-form-group">
            <div class="m-form-control">
                <!--输入框-->
                <input type="text" id="inp_search" placeholder="请输入姓名" class="f-ml10" data-attr-scan="searchNm"/>
            </div>


            <div class="m-form-control f-ml10">
                <!--按钮:查询 & 新增-->
                <sec:authorize url="/doctor/searchDoctor">
                    <div id="btn_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.search"/></span>
                    </div>
                </sec:authorize>
            </div>

            <div class="m-form-control m-form-control-fr">
                <sec:authorize url="/doctor/updateDoctor">
                    <div id="div_new_doctor" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <span><spring:message code="btn.create"/></span>
                    </div>
                    <div id="div_down_doctor" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                       <sec:authorize url="/ehr/doctorTemplate">
                            <a href="<%=request.getContextPath()%>/template/医护人员导入模板.xls"
                               style="color: #fff">
                                下载模版
                            </a>
                        </sec:authorize>
                    </div>
                    <div id="div_upload_doctor" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        <sec:authorize url="/doctorImport/import">
                            <div id="upd" class="f-fr f-mr10" style="overflow: hidden; width: 84px" ></div>
                        </sec:authorize>
                    </div>
                </sec:authorize>

            </div>
            <%--<div id="div_new_patient" class="l-button u-btn u-btn-primary u-btn-small l-button-over">
              <span>新增</span>
            </div>--%>
        </div>
    </div>
    <!--######医生信息表######-->
    <div id="div_doctor_info_grid">

    </div>
    <!--######医生信息表#结束######-->
</div>
<div id="div_doctor_info_dialog">

</div>