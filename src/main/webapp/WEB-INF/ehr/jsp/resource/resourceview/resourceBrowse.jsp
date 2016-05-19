<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######资源浏览页面Title设置######-->
<div class="f-dn" data-head-title="true">资源浏览</div>
<div id="div_wrapper" class="f-mt20">
    <!-- ####### 查询条件部分 ####### -->
    <div class="f-h785">

        <div class="f-w18 f-bd f-of-hd" style="float: left">
            <div class="f-mt10 f-ml10 f-w270">
                <!--输入框-->
                <input type="text" id="inp_search" class="f-ml10"/>
                <hr>
            </div>

            <!--资源浏览树-->
            <div id="div_resource_browse_tree">

            </div>
        </div>

        <!--资源浏览详情-->
        <div id="div_resource_browse_msg" class="div-resource-browse">

            <!--添加动态查询-->
            <div id="div_new_search" class="f-mt10 f-ml10">
                <span class="f-fl f-mt10">查询条件：</span>
                <div class="f-fl f-w90">
                    <div class="f-fl f-ml10 f-mr10">
                        <input type="text" id="inp_default_condition" data-attr-scan="1" class="f-ml10"/>
                    </div>
                    <div class="f-fl f-ml10 f-mr10">
                        <input type="text" id="inp_logical_relationship" data-sttr-scan="2" class="f-ml10"/>
                    </div>
                    <div class="f-fl f-ml10 f-mr10">
                        <input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10"/>
                    </div>
                    <span class="sp-back-add-img f-mt10" id="sp_new_search_btn"></span>
                </div>
            </div>
            <div class="f-fr f-mr279 f-mt10">
                <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_search_btn">
                    <span>搜索</span>
                </div>
                <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_cancel_btn">
                    <span>重置</span>
                </div>
            </div>

            <div class="div-result-msg f-mt10">

                <div class="f-fr f-mr279 f-mt10">
                    <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="1">
                        <span>导出选中结果</span>
                    </div>
                    <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="2">
                        <span>导出查询结果</span>
                    </div>
                </div>

                qq</div>

        </div>
        <div class="f-fl f-w90 f-mt10 f-ml60 dis-none div_search_model" >
            <div class="f-fl f-ml10 f-mr10">
                <input type="text" class="f-ml10 inp-model0 inp-find-search"/>
            </div>
            <div class="f-fl f-ml10 f-mr10">
                <input type="text" class="f-ml10 inp-model1 inp-find-search"/>
            </div>
            <div class="f-fl f-ml10 f-mr10">
                <input type="text" class="f-ml10 inp-model2 inp-find-search"/>
            </div>
            <div class="f-fl f-ml10 f-mr10">
                <input type="text" class="f-ml10 inp-model3 inp-find-search"/>
            </div>
            <span class="sp-back-del-img f-mt10 sp-del-btn"></span>
        </div>
    </div>
</div>