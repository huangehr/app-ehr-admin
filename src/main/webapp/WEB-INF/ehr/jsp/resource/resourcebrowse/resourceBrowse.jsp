<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######资源浏览页面Title设置######-->
<div class="f-dn" data-head-title="true">资源浏览</div>
<div id="div_wrapper" class="f-mt20">
    <!-- ####### 查询条件部分 ####### -->
    <div class="f-h785">
        <div class="f-w20 f-bd f-of-hd" style="float: left">
            <div class="f-mt10 f-ml10 f-w270">
                <!--输入框-->
                <input type="text" id="inp_search" class="f-ml10"/>
            </div>
            <hr>
            <!--资源浏览树-->
            <div id="div_resource_browse_tree"></div>
        </div>
        <!--资源浏览详情-->
        <div id="div_resource_browse_msg" data-role-form class="div-resource-browse">
            <!--添加动态查询-->
            <div class="f-mt10 f-ml10 div-search-height" style="float: left;margin-left: 20px;width: 93%;">
                <div id="div_new_search" class="f-mt10" data-role-form>
                    <div class="f-fl f-w90">
                        <div class="f-fl f-ml10 f-mr10 f-w-auto" style="width: 100px">
                            <span class="f-fl f-mt10 f-ml10">查询条件：</span>
                        </div>
                        <div class="f-fl f-ml10 f-mr10">
                            <input type="text" id="inp_default_condition" data-type="select" data-attr-scan="field"
                                   class="f-pr0 f-mw238 f-ml10 inp-reset"/>
                        </div>
                        <div class="f-fl f-ml10 f-mr10 div-and-or">
                            <input type="text" id="inp_logical_relationship" data-type="select"
                                   data-attr-scan="condition" class="f-ml10 inp-reset"/>
                        </div>
                        <div class="f-fl f-ml10 f-mr10 div-change-search">
                            <input type="text" data-attr-scan="value" data-type="select"
                                   class="f-ml10 inp-reset inp_defualt_param"/>
                        </div>
                        <span class="sp-back-add-img f-mt10" id="sp_new_search_btn"></span>
                    </div>
                </div>
            </div>
            <div class="f-fr f-mr20 f-mt10">
                <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_search_btn">
                    <span>搜索</span>
                </div>
                <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_reset_btn">
                    <span>重置</span>
                </div>
                <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar"
                     id="div_out_sel_excel_btn">
                    <span>导出选中结果</span>
                </div>
                <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar"
                     id="div_out_all_excel_btn">
                    <span>导出查询结果</span>
                </div>
            </div>

            <div class="div-result-msg f-mt10">
                <div id="div_resource_info_grid"></div>
            </div>
        </div>
        <div class="f-fl f-w90 f-mt10 f-ml60 dis-none div_search_model" data-role-form >
            <div class="f-fl f-ml10 f-mr10">
                <input type="text" class="f-ml10 inp-reset inp-model0 inp-find-search" data-type="select"
                       data-attr-scan="andOr"/>
            </div>
            <div class="f-fl f-ml10 f-mr10">
                <input type="text" class="f-ml10 inp-reset inp-model1 inp-find-search" data-type="select"
                       data-attr-scan="field"/>
            </div>
            <div class="f-fl f-ml10 f-mr10">
                <input type="text" class="f-ml10 inp-reset inp-model2 inp-find-search" data-type="select"
                       data-attr-scan="condition"/>
            </div>
            <div class="f-fl f-ml10 f-mr10 div-new-change-search">
                <input type="text" class="f-ml10 inp-reset inp-model3 inp-find-search" data-type="select"
                       data-attr-scan="value"/>
            </div>
            <span class="sp-back-del-img f-mt10 sp-del-btn"></span>
        </div>
    </div>
</div>