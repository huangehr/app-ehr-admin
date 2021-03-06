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
<style>
    html,body{height: 100%;width:100%;overflow: hidden;}
    .u-nav-breadcrumb { height: 40px; line-height: 40px; }
    .f-bd { border: 1px solid #D6D6D6;  overflow: auto;  height: 100%  }
    .f-w270 { width: 270px;  }
    .f-of-hd { overflow: hidden;  }
    .f-w18 { width: 18%  }
    .dis-none { display: none  }
    .div-resource-browse { height: calc(100% - 50px) !important;  width: 100%;  float: right;  border: 1px solid #D6D6D6;  }
    .sp-back-add-img {
        background: url(${staticRoot}/images/app/add_btn.png);
        float: left;
        width: 30px;
        height: 30px;
        cursor: pointer;
        margin: 0;
        background-repeat: no-repeat;
        /*background-position: 35px 6px;*/
        margin-right: 40px;
    }
    .sp-back-del-img {
        background: url(${staticRoot}/images/app/Close_btn_pre01.png);
        float: left;
        width: 60px;
        height: 30px;
        cursor: pointer;
        background-repeat: no-repeat;
        background-position: 35px 0;
    }
    .f-w90 { width: 90%; }
    .f-w100 { width: 100%; }
    .f-mt6 {margin-top: 6px;}
    .div-result-msg { border: 1px solid #D6D6D6;  width: 100%;  height: auto;  float: left;  }
    .f-mr279 { margin-right: 279px;  }
    .f-pr0 { width: 238px; padding-right: 0;  }
    .f-ds { display: none; }
    .f-ml-20 { margin-left: 5%; }
    .f-ml30 { margin-left: 30px; }
    .div-resource-view-title{ width:100%;height:30px;margin: 25px 0 30px 0; }
    .sp-search-width{ width: 5%;margin-left: 1%;}
    .f-ml15{ margin-left: 15%; }
    .f-mw{ width: 100px; }
    .l-panel-bar{margin-bottom: 45px !important;}
    .l-grid-hd-cell-inner{line-height: 40px;}
</style>


<!--######资源浏览页面Title设置######-->
<div id="div_nav_breadcrumb_bar" class="u-nav-breadcrumb f-pl10 s-bc5 f-fwb f-dn" style="display: block;">位置：
    <span id="span_nav_breadcrumb_content" data-sesson="3,37"><span class="strong">数据资源中心</span> &gt;
        <span class="on">视图即时查询</span> </span>
</div>

<div style="height: calc(100% - 50px);width: 300px;float: left;border:1px solid #dcdcdc;margin-left: 10px;margin-bottom: 10px;">
    <div class="m-retrieve-area f-h40 f-pr m-form-inline" style="border-bottom:1px solid #dcdcdc;">
        <div class="m-form-group f-mt10">
            <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                <div>视图查询：</div>
            </div>
            <div class="m-form-control f-fs12">
                <input type="text" id="searchNm" placeholder="请输入应用名称">
            </div>
        </div>
    </div>
    <div id="div-left-scroller" style="height: calc(100% - 50px)">
        <div id="div-left-tree" style="padding: 10px;"></div>
    </div>

</div>
<div id="div_wrapper" class="f-ml20" style="height: 100%;width: calc(100% - 340px);float: left;margin-right: 10px;">
    <!-- ####### 查询条件部分 ####### -->
    <div style="width: 100%;height: 100%;">
        <%--<div class="div-resource-view-title">--%>
            <%--<div class="f-fl f-ml250">--%>
                <%--<input type="text" id="sp_resourceSub"  placeholder="请选择资源分类" data-type="select" data-attr-scan="resourceSub">--%>
            <%--</div>--%>
            <%--<div class="f-fl f-ml30">--%>
                <%--<input type="text" id="sp_resourceName"  placeholder="请选择资源名称" data-type="select" data-attr-scan="resourceName">--%>
            <%--</div>--%>
        <%--</div>--%>
        <div id="div_resource_browse_msg" data-role-form class="div-resource-browse">
            <!--添加动态查询-->
            <div class="div-search-height" id="div_search_data_role_form" style="float: left;margin-left: 20px;width: 99%;">
                <div id="div_new_search" class="f-mt10" data-role-form>
                    <div class="f-fl f-w100" id="div_default_search">
                        <div class="f-fl f-w-auto f-mw7">
                            <div class="f-fl f-ml10 f-mr10 f-dn">
                                <input type="text" class="f-ml10 inp-reset inp-model0 inp-find-search"
                                       data-attr-scan="andOr" value="AND"/>
                            </div>
                            <span class="f-fl f-mt10">查询条件：</span>
                        </div>
                        <div class="f-fl f-mr10 f-ml10 f-mt6">
                            <input type="text" id="inp_default_condition" data-type="select" data-attr-scan="field"
                                   style="width: 238px" class="f-pr0 f-ml10 inp-reset div-table-colums "/>
                        </div>
                        <div class="f-fl f-ml10 f-mr10 f-mt6 div-and-or">
                            <input type="text" id="inp_logical_relationship" data-type="select" data-attr-scan="condition" class="f-ml10 inp-reset"/>
                        </div>
                        <div class="f-fl f-ml10 f-mr10 f-mt6 div-change-search" style="width: 100px;">
                            <input type="text" data-attr-scan="value" data-type="select" class="f-ml10 inp-reset inp-find-search inp_defualt_param"/>
                        </div>

                        <%-- #### 操作按钮 begin #### --%>
                        <div class="f-fr f-mr20 f-mt6">
                            <span class="sp-back-add-img f-mt6" id="sp_new_search_btn"></span>
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
                    </div>
                    <%-- #### 操作按钮 end #### --%>
                </div>
            </div>

            <div class="div-result-msg f-mt10">
                <div id="div_resource_info_grid"></div>
            </div>

        </div>
        <div class="f-fl f-w90 f-mt10 f-ml60 dis-none div_search_model" data-role-form >
            <div>
                <div class="f-fl f-ml10 f-mr10">
                    <input type="text" class="f-ml10 inp-reset inp-model0 inp-find-search" data-type="select"
                           data-attr-scan="andOr"/>
                </div>
                <div class="f-fl f-mr10 f-ml10">
                    <input type="text" class="f-ml10 inp-reset inp-model1 inp-find-search div-table-colums" data-type="select"
                           data-attr-scan="field"/>
                </div>
                <div class="f-fl f-ml10 f-mr10">
                    <input type="text" class="f-ml10 inp-reset inp-model2 inp-find-search" data-type="select"
                           data-attr-scan="condition"/>
                </div>
                <div class="f-fl f-ml10 f-mr10 div-new-change-search" style="width: 200px">
                    <input type="text" class="f-ml10 inp-find-search inp-reset inp-model3 inp-find-search" data-type="select"
                           data-attr-scan="value"/>
                </div>
                <span class="sp-back-del-img f-mt10 sp-del-btn"></span>
            </div>
        </div>
    </div>
    <div style="display: none;width: 14%" id="div-f-w1"></div>
    <div style="display: none;width: 7%" id="div-f-w2"></div>
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