<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
    .search-top{padding: 10px 0;}
    .div-search-height{position: relative;}
    .div_resource_browse_msg > div> div{min-height: 100%}
    .div-result-msg{border:none}
    #ddSeach{height: 35px;line-height: 35px;padding: 0 44px 0 10px;position: relative;background: #fff;border: 1px solid #ccc;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px;cursor: pointer}
    #ddSeach:after{content: ' ';width: 1px;height: 100%;display: block;background: #ccc;position: absolute;top:0;right: 35px;}
    .dd-icon{width: 20px;height: 20px;display: block;position: absolute;top: 8px;right: 7px;background: url(${staticRoot}/images/d.png) no-repeat center ;background-size: contain;}
    .sj-icon,.sj-sj-icon{width:0;height:0;  border-width:0 10px 10px;border-style:solid;position: absolute}
    .sj-icon{border-color:transparent transparent #ccc;bottom: 2px;right: -3px;z-index: 999}
    .sj-sj-icon{border-color:transparent transparent #fff;bottom: -11px;right: -10px}
    .pop-s-con{width: 872px;padding: 10px;position: absolute;right: -221px;top: 8px;background: #fff;border: 1px solid #ccc;padding-bottom: 55px;z-index: 998;overflow: auto}
    .pop-btns{position: absolute;bottom: 10px;right: 10px;z-index: 999}
    .inp-text{display: inline-block;vertical-align: middle;    font-size: 12px;}
    .inp-label{width: 161px;vertical-align: middle;text-align: right;font-size: 12px;padding-right: 10px;margin-bottom: 0}
    .clear-s{font-size: 0}
    .pop-main{display:none;width: 10px;height: 10px;left: 81px;right: 0;position: absolute}
</style>
<!--######资源浏览页面Title设置######-->
<div class="f-dn" data-head-title="true">资源浏览</div>
<div id="div_wrapper" class="f-mt10">
    <!-- ####### 查询条件部分 ####### -->
    <div class="f-h785">
        <div class="div-resource-view-title">
            <div class="f-fl f-ml250">
                <input type="text" id="sp_resourceSub"  placeholder="请选择视图分类" data-type="select" data-attr-scan="resourceSub">
            </div>
            <div class="f-fl f-ml30">
                <input type="text" id="sp_resourceName"  placeholder="请选择视图名称" data-type="select" data-attr-scan="resourceName">
            </div>
        </div>
        <div id="div_resource_browse_msg" data-role-form class="div-resource-browse">
            <!--添加动态查询-->
            <div class="div-search-height" id="div_search_data_role_form" style="float: left;margin-left: 20px;width: 99%;">
                <div id="div_new_search" class="f-mt10" data-role-form>
                    <div class="f-fl f-w100" id="div_default_search">
                        <%--<div class="f-fl f-ml10 f-mr10 f-w-auto f-mw7">--%>
                            <%--<div class="f-fl f-ml10 f-mr10 f-dn">--%>
                                <%--<input type="text" class="f-ml10 inp-reset inp-model0 inp-find-search"--%>
                                       <%--data-attr-scan="andOr" value="AND"/>--%>
                            <%--</div>--%>
                            <%--<span class="f-fl f-mt10 f-ml10">查询条件：</span>--%>
                        <%--</div>--%>
                        <%--&lt;%&ndash;<div class="f-fl f-ml10 f-mr10 f-w-auto f-mw" style="width: 7.5%">&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<span class="f-fl f-mt10 f-ml15">查询条件：</span>&ndash;%&gt;--%>
                        <%--&lt;%&ndash;</div>&ndash;%&gt;--%>
                        <%--<div class="f-fl f-mr10 f-ml10 f-mt6">--%>
                            <%--<input type="text" id="inp_default_condition" data-type="select" data-attr-scan="field"--%>
                                   <%--style="width: 238px" class="f-pr0 f-ml10 inp-reset div-table-colums "/>--%>
                        <%--</div>--%>
                        <%--<div class="f-fl f-ml10 f-mr10 f-mt6 div-and-or">--%>
                            <%--<input type="text" id="inp_logical_relationship" data-type="select" data-attr-scan="condition" class="f-ml10 inp-reset"/>--%>
                        <%--</div>--%>
                        <%--<div class="f-fl f-ml10 f-mr10 f-mt6 div-change-search" style="width: 200px;">--%>
                            <%--<input type="text" data-attr-scan="value" data-type="select" class="f-ml10 inp-reset inp-find-search inp_defualt_param"/>--%>
                        <%--</div>--%>
                        <%--<span class="sp-back-add-img f-mt6" id="sp_new_search_btn"></span>--%>

                        <%-- #### 操作按钮 begin #### --%>
                        <div class="f-fr f-mr20 f-mt6">
                            <%--<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar" id="div_search_btn">--%>
                                <%--<span>搜索</span>--%>
                            <%--</div>--%>
                            <%--<div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar" id="div_reset_btn">--%>
                                <%--<span>重置</span>--%>
                            <%--</div>--%>
                                <div class="f-ib f-vam close-toolbar" id="ddSeach">
                                    <span>查询条件</span>
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
                            <%--<div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam save-toolbar"--%>
                                 <%--id="div_out_sel_excel_btn">--%>
                                <%--<span>导出选中结果</span>--%>
                            <%--</div>--%>
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
    <input type="text">
</div>