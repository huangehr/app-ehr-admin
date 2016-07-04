<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######资源浏览页面Title设置######-->
<div class="f-dn" data-head-title="true">资源浏览</div>
<div id="div_wrapper" class="f-mt20">
    <!-- ####### 查询条件部分 ####### -->
    <div class="f-h785">
        <div class="f-mw19 f-bd f-of-hd f-fl">
            <div class="f-mt10 f-ml10 f-w270">
                <!--输入框-->
                <input type="text" id="inp_search" class="f-ml10"/>
            </div>
            <hr>
            <!--资源浏览树-->
            <div class="div-resource-tree">
                <div id="div_resource_browse_tree" class="f-mw100"></div>
            </div>
        </div>
        <!--资源浏览详情-->

        <div id="div_resource_browse_msg" class="div-resource-browse div-resource-treess" >
            <!--添加动态查询-->
            <div class="f-mt10 f-ml10 div-search-height f-fl f-ml20 f-mw93" id="div-search-data-role-form">
                <div id="div_new_search" class="f-mt10" data-role-form>
                    <div class="f-fl f-mw100" id="div_default_search">
                        <div class="f-fl f-ml10 f-mr10 f-w-auto f-mw7">
                            <div class="f-fl f-ml10 f-mr10 f-dn">
                                <input type="text" class="f-ml10 inp-reset inp-model0 inp-find-search"
                                       data-attr-scan="andOr" value="AND"/>
                            </div>
                            <span class="f-fl f-mt10 f-ml10">查询条件：</span>
                        </div>
                        <div class="f-fl f-ml10 f-mr10 ">
                            <input type="text" id="inp_default_condition" data-type="select" data-attr-scan="field"
                                   class="f-pr0 f-mw238 f-ml10 inp-reset div-table-colums"/>
                        </div>
                        <div class="f-fl f-ml10 f-mr10 div-and-or">
                            <input type="text" id="inp_logical_relationship" data-type="select"
                                   data-attr-scan="condition" class="f-ml10 inp-reset"/>
                        </div>
                        <div class="f-fl f-ml10 f-mr10 div-change-search f-mw42">
                            <input type="text" data-attr-scan="value" data-type="select"
                                   class="f-ml10 inp-reset inp-com-param inp_defualt_param"/>
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
                <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam save-toolbar"
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
        <div class="f-fl f-mw100 f-mt10 f-ml60 dis-none div_search_model" data-role-form>
            <div>
                <div class="f-fl f-ml10 f-mr10">
                    <input type="text" class="f-ml10 inp-reset inp-model0 inp-find-search" data-type="select"
                           data-attr-scan="andOr"/>
                </div>
                <div class="f-fl f-ml10 f-mr10 ">
                    <input type="text" class="f-ml10 inp-reset inp-model1 inp-find-search div-table-colums"
                           data-type="select"
                           data-attr-scan="field"/>
                </div>
                <div class="f-fl f-ml10 f-mr10">
                    <input type="text" class="f-ml10 inp-reset inp-model2 inp-find-search" data-type="select"
                           data-attr-scan="condition"/>
                </div>
                <div class="f-fl f-ml10 f-mr10 div-new-change-search f-mw42 ">
                    <input type="text" class="f-ml10 inp-reset inp-model3 inp-com-param inp-find-search"
                           data-type="select"
                           data-attr-scan="value"/>
                </div>
                <span class="sp-back-del-img f-mt10 sp-del-btn"></span>
            </div>
        </div>
        <div class="f-dn f-mw14" id="div-f-w1"></div>
        <div class="f-dn f-mw7" id="div-f-w2"></div>
    </div>
</div>