<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="infoForm" data-role-form class="m-form-inline f-mt10">
    <input id="id" name="id" data-attr-scan="id" hidden>

    <div id="searchArea" class="f-h40">
        <div class="m-form-control f-fr f-mr10">
            <input type="text" id="ipt_app_search" placeholder="请输入系统名称" class="f-ml10" data-attr-scan="searchNm"/>
        </div>
    </div>

    <div id="form_middle">
        <div class="f-ml10 f-fl" style="width: 230px; height: 260px; border: 1px solid #888; ">
            <div style="border-bottom: 1px solid #888; line-height: 30px; text-align: center">授权系统类型</div>
            <div id="org_tree_wrap" style="height: 224px;">
                <div id="org_tree"></div>
            </div>
        </div>

        <div class=" f-mr10" style="height: 260px; margin-left: 250px; border: 1px solid #888;">
            <div class="l-tree" style="border-bottom: 1px solid #888; line-height: 30px; ">
                <div class="l-body">
                    <div id="allChecked" class=" l-box l-checkbox l-checkbox-unchecked" style="margin-left: 22px; margin-top: 6px; cursor: pointer"></div>
                </div>
                <div style="margin-left: 70px">授权系统名称</div>
            </div>
            <div id="app_tree_wrap" style="height: 224px;">
                <div id="app_tree"></div>
            </div>
        </div>
    </div>

    <div id="form_bottom">
        <div class="f-ml10 f-mt10">已选择：</div>
        <div id="checked_tree_wrap" style="border: 1px solid #888; width: 468px; height: 200px; margin-left: 10px">
            <div id="checked_tree"></div>
        </div>
    </div>

    <div class="m-form-group f-pa update-footer">
        <div class="m-form-control">
            <div id="btn_save" class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam">
                <span>确认</span>
            </div>
            <div id="btn_cancel" class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam">
                <span>取消</span>
            </div>
        </div>
    </div>

</div>
