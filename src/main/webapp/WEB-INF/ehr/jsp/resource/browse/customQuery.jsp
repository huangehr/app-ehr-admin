<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<link rel="stylesheet" href="${staticRoot}/common/reset.css">
<link rel="stylesheet" href="${staticRoot}/lib/bootstrap/css/bootstrap.css">
<link rel="stylesheet" href="${staticRoot}/common/font-awesome.css">
<link rel="stylesheet" href="${staticRoot}/common/function.css">
<link rel="stylesheet" href="${staticRoot}/common/unit.css">
<link rel="stylesheet" href="${staticRoot}/common/skin.css">
<link rel="stylesheet" href="${staticRoot}/common/cyc-menu.css">
<link rel="stylesheet" href="${staticRoot}/common/cyc-linkage.css">

<link rel="stylesheet" href="${staticRoot}/lib/plugin/tips/tips.css">
<link rel="stylesheet" href="${staticRoot}/lib/ligerui/skins/Aqua/css/ligerui-all.css">
<link rel="stylesheet" href="${staticRoot}/lib/ligerui/skins/Gray2014/css/all.css">
<link rel="stylesheet" href="${staticRoot}/lib/plugin/scrollbar/jquery.mCustomScrollbar.css">
<link rel="stylesheet" href="${staticRoot}/lib/plugin/combo/comboDropdown.css">

<link rel="stylesheet" href="${staticRoot}/lib/ligerui/skins/custom/css/all.css">
<link rel="stylesheet" href="${staticRoot}/common/cover.css">
<link rel="stylesheet" href="${staticRoot}/lib/plugin/combo/comboDropdown.css">

<%--树--%>
<div style="height: 100%;width: 300px;float: left;border:1px solid #dcdcdc;margin-left: 10px;margin-bottom: 10px;">

    <ul class="tab-main">
        <li class="tab-item active">档案数据</li>
        <li class="tab-item">指标统计</li>
    </ul>


    <div id="div-left-scroller" style="height: calc(100% - 50px)">
        <div id="div-left-tree" style="padding: 10px;"></div>
    </div>
</div>

<%--档案数据 --%>
<div class="tab-con">
    <div id="div_wrapper" class="f-ml20" style="height: 100%;width: calc(100% - 340px);float: left;margin-right: 10px;">
        <!-- ####### 查询条件部分 ####### -->
        <div style="width: 100%;height: 100%;">
            <div id="div_resource_browse_msg" data-role-form class="div-resource-browse" style="position: relative">
                <!--添加动态查询-->
                <div class="f-fl div-search-height" id="div_search_data_role_form" style="width: 100%;padding-left: 20px;padding-bottom:20px;">
                    <div id="div_new_search" class="f-mt10" data-role-form>
                        <div class="search-top">
                            <%-- #### 操作按钮 begin #### --%>
                            <div class="f-fr f-mr20 f-mt6">
                                <div class="f-ib f-vam close-toolbar" id="ddSeach">
                                    <span>维度选择</span>
                                    <i class="dd-icon"></i>
                                    <div class="pop-main">
                                        <div class="sj-icon">
                                            <div class="sj-sj-icon"></div>
                                        </div>
                                        <div class="pop-s-con">
                                            <%-- ##########搜索条件###########--%>
                                            <%--地区--%>
                                            <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                                <label class="inp-label" for="inpRegion">地区: </label>
                                                <div class="inp-text">
                                                    <input type="text" id="inpRegion" data-code="EHR_000241" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums "/>
                                                </div>
                                            </div>
                                            <%--医疗机构--%>
                                            <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                                <label class="inp-label" for="inpMechanism">医疗机构: </label>
                                                <div class="inp-text">
                                                    <input type="text" id="inpMechanism" data-code="EHR_000021" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums "/>
                                                </div>
                                            </div>
                                            <%--时间范围--%>
                                            <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                                <label class="inp-label" for="inpStarTime">起始日期: </label>
                                                <div class="inp-text">
                                                    <input type="text" id="inpStarTime" data-code="EHR_000065" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums " readonly="readonly"/>
                                                </div>
                                            </div>
                                            <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                                <label class="inp-label" for="inpEndTime">结束日期: </label>
                                                <div class="inp-text">
                                                    <input type="text" id="inpEndTime" data-code="EHR_000065" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums "/>
                                                </div>
                                            </div>

                                            <%--动态生成条件--%>
                                            <div class="" id="addSearchDom">

                                            </div>
                                            <%-- ##########搜索条件end###########--%>
                                            <div class="f-fr pop-btns">
                                                <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_reset_btn">
                                                    <span>重置</span>
                                                </div>
                                                <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_search_btn">
                                                    <span>搜索</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar"
                                     id="generateView">
                                    <span>生成视图</span>
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
                            <%-- #### 操作按钮 end #### --%>
                        </div>
                    </div>
                </div>
                <%--表格--%>
                <div class="div-result-msg f-mt10">
                    <div id="div_resource_info_grid"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<%--指标统计--%>
<div class="tab-con" style="display: none">
    <%--树--%>
    <div style="height: 100%;width: 300px;float: left;border:1px solid #dcdcdc;margin-left: 10px;margin-bottom: 10px;">
        <div id="zhibiao" style="height: calc(100% - 50px)">
            <div id="zhibiaoTree" style="padding: 10px;"></div>
        </div>
    </div>
    <div id="div_wrapper" class="f-ml20" style="height: 100%;width: calc(100% - 340px);float: left;margin-right: 10px;">
        <!-- ####### 查询条件部分 ####### -->
        <div style="width: 100%;height: 100%;">
            <div id="" data-role-form class="div-resource-browse" style="position: relative">
                <!--添加动态查询-->
                <div class="f-fl div-search-height" id="div_search_data_role_form" style="width: 100%;padding-left: 20px;padding-bottom:20px;">
                    <div id="" class="f-mt10" data-role-form>
                        <div class="search-top">
                            <%-- #### 操作按钮 begin #### --%>
                            <div class="f-fr f-mr20 f-mt6">
                                <div class="f-ib f-vam close-toolbar" id="">
                                    <span>维度选择</span>
                                    <i class="dd-icon"></i>
                                    <div class="pop-main">
                                        <div class="sj-icon">
                                            <div class="sj-sj-icon"></div>
                                        </div>
                                        <div class="pop-s-con">
                                            <%-- ##########搜索条件###########--%>
                                            <%--地区--%>
                                            <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                                <label class="inp-label" for="inpRegion">地区: </label>
                                                <div class="inp-text">
                                                    <input type="text" id="" data-code="EHR_000241" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums "/>
                                                </div>
                                            </div>
                                            <%--医疗机构--%>
                                            <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                                <label class="inp-label" for="inpMechanism">医疗机构: </label>
                                                <div class="inp-text">
                                                    <input type="text" id="" data-code="EHR_000021" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums "/>
                                                </div>
                                            </div>
                                            <%--时间范围--%>
                                            <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                                <label class="inp-label" for="inpStarTime">起始日期: </label>
                                                <div class="inp-text">
                                                    <input type="text" id="" data-code="EHR_000065" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums " readonly="readonly"/>
                                                </div>
                                            </div>
                                            <div class="f-fl f-mr10 f-ml10 f-mt6 clear-s">
                                                <label class="inp-label" for="inpEndTime">结束日期: </label>
                                                <div class="inp-text">
                                                    <input type="text" id="" data-code="EHR_000065" data-type="select" class="f-pr0 f-ml10 inp-reset div-table-colums "/>
                                                </div>
                                            </div>

                                            <%--动态生成条件--%>
                                            <div class="" id="addSearchDom">

                                            </div>
                                            <%-- ##########搜索条件end###########--%>
                                            <div class="f-fr pop-btns">
                                                <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="">
                                                    <span>重置</span>
                                                </div>
                                                <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="">
                                                    <span>搜索</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar"
                                     id="">
                                    <span>生成视图</span>
                                </div>

                                <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam save-toolbar"
                                     id="">
                                    <span>导出选中结果</span>
                                </div>
                                <div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar"
                                     id="">
                                    <span>导出查询结果</span>
                                </div>
                            </div>
                            <%-- #### 操作按钮 end #### --%>
                        </div>
                    </div>
                </div>
                <%--表格--%>
                <div class="div-result-msg f-mt10">
                    <div id=""></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${staticRoot}/lib/jquery/jquery-1.9.1.js"></script>
<script src="${staticRoot}/module/cookie.js"></script>
<script src="${staticRoot}/module/util.js"></script>
<script src="${staticRoot}/module/juicer.js"></script>
<script src="${staticRoot}/module/pubsub.js"></script>
<script src="${staticRoot}/module/sessionOut.js"></script>
<script src="${staticRoot}/module/ajax.js"></script>
<script src="${staticRoot}/module/baseObject.js"></script>
<script src="${staticRoot}/module/dataModel.js"></script>
<script src="${staticRoot}/module/pinyin.js"></script>
<script src="${staticRoot}/lib/plugin/formEx/attrscan.js"></script>
<script src="${staticRoot}/lib/plugin/formEx/readonly.js"></script>
<script src="${staticRoot}/lib/bootstrap/js/bootstrap.js"></script>
<script src="${staticRoot}/lib/ligerui/core/base.js"></script>

<script src="${staticRoot}/lib/plugin/tips/tips.js"></script>
<script src="${staticRoot}/lib/plugin/validate/jValidate.js"></script>
<script src="${staticRoot}/lib/plugin/validation/jquery.validate.min.js"></script>
<script src="${staticRoot}/lib/plugin/validation/jquery.metadata.js"></script>
<script src="${staticRoot}/lib/plugin/validation/messages_cn.js"></script>

<script src="${staticRoot}/lib/ligerui/plugins/ligerLayout.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerDrag.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerResizable.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerDialog.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerGrid.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerTree.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerButton.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerCheckBox.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerCheckBoxList.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerComboBox.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerListBox.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerTextBox.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerDateEditor.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerForm.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/customTree.js"></script>
<script src="${staticRoot}/lib/ligerui/plugins/ligerRadio.js"></script>

<script src="${staticRoot}/lib/plugin/notice/topNotice.js"></script>
<script src="${staticRoot}/lib/plugin/combo/addressDropdown.js"></script>

<script src="${staticRoot}/lib/plugin/scrollbar/jquery.mousewheel.min.js"></script>
<script src="${staticRoot}/lib/plugin/scrollbar/jquery.mCustomScrollbar.js"></script>

<script src="${staticRoot}/lib/ligerui/custom/ligerGridEx.js"></script>
<script src="${staticRoot}/lib/ligerui/custom/customCombo.js"></script>
<script src="${staticRoot}/lib/ligerui/custom/cyc-menu.js"></script>
<script src="${staticRoot}/lib/ligerui/custom/cyc-linkage.js"></script>
<script src="${staticRoot}/lib/ligerui/custom/cyc-big.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>