<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!--######系统字典管理页面Title设置######-->
<div id="inp_form">
    <input id="inp_systemDictId" type="hidden">
    <div>
        <input type="text" id="inp_search" placeholder="请输入字典名称"/>
    </div>

    <div style="width: 100%" id="grid_content" class="f-mt10">
        <div class="u-left">
            <div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px">
                <div class="m-form-group f-mt10">
                    <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                        <div>系统字典：</div>
                    </div>
                    <sec:authorize url="/dict/createDict">
                    <div id="div_addSystemDict" class="l-button u-btn u-btn-primary u-btn-small l-button-over f-fr f-mr10">
                        <span>新增字典</span>
                    </div>
                    </sec:authorize>
                </div>
            </div>

            <div id="div_SystemDict_info_grid" class="m-systemDict-form-info"></div>
        </div>

        <div class="u-right">
            <div class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0">
                <div class="m-form-group f-mt10">
                    <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                        <div>字典详情：</div>
                    </div>
                    <sec:authorize url="/dict/createDictEntry">
                    <div id="div_addSystemDictEntity" class="l-button u-btn u-btn-primary u-btn-small l-button-over f-fr f-mr10">
                        <span>新增明细</span>
                    </div>
                    </sec:authorize>
                </div>
            </div>

            <div id="div_systemEntity_info_grid" class="m-systemDictEntity-form-info"></div>
        </div>
    </div>
</div>
<input id="inp_systemDictName" type="hidden" value="">
<input id="inp_systemNameCopy" type="hidden" value="">
