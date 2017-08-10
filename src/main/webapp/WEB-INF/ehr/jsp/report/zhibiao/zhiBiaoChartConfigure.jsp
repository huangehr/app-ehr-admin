<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<link rel="stylesheet" href="${staticRoot}/lib/bootstrap/css/bootstrap.min.css">
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.dict.manage"/></div>
<input value="${quotaCode}" class="f-dn" id="inp_quotaCode"/>
<div id="div_wrapper" style="height: 100%;overflow: hidden;">
    <div style="width: 100%;height: 100%;" id="grid_content">
        <div style="padding: 20px 0 0 22px;">
            指标名称：${quotaName}
        </div>
        <!--   指标详情   border: 1px solid #D6D6D6-->
        <div id="div_right" style="float: left;width: 100%;height: 100%;padding-left: 10px; ">
            <div style="width: 96%;height:90%;padding-top: 20px;position: relative">
                <%--列表--%>
                <div class="" style="float: left;width: 302px;">
                    <div class="m-form-control f-fs12 div-main-search" style="display: block;padding: 10px 0 10px 10px;    border: 1px solid #D6D6D6;border-bottom: none">
                        <input type="text" id="searchNmEntry" placeholder="<spring:message code="lbl.input.placehold"/>">
                    </div>
                    <div id="div_relation_grid">

                    </div>
                </div>

                <div style="width: 20px;position: absolute;left: 315px;">
                    <div style="background: url(${staticRoot}/images/zhixiang_icon.png) no-repeat;width: 20px;height: 40px;margin-top: 224px;margin-left: 2px;">
                    </div>
                </div>
                <%--自动生成列表--%>
                <div style="float: right;width: 302px;padding-left:10px;border: 1px solid #D6D6D6;border-bottom: none;">
                    <div style="height: 51px;line-height: 51px;padding-left: 10px;">
                        已配置
                    </div>
                    <div id="div_main_relation">
                        <div class="h-40 div-header-content">
                            <div class="div-header">编码</div>
                            <div class="div-header">图表</div>
                            <div class="div-opera-header">操作</div>
                        </div>
                    </div>
                </div>
            </div>
            <div>
                <button id="div_save" class="btn u-btn-primary u-btn-small s-c0 f-fr f-mr10" style="position: absolute;right: 155px;bottom: 20px;">保存</button>
                <button id="div_close" class="btn u-btn-cancel u-btn-small s-c0 f-fr f-mr10" style="position: absolute;right: 20px;bottom: 20px;">关闭</button>
            </div>
        </div>
    </div>
</div>
