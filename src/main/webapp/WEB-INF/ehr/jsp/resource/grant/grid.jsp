<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">字典</div>

<!-- ####### 页面部分 ####### -->
<div>

    <div id="div_wrapper">

        <div id="conditionArea" class="f-mb10 f-mr10" align="right">
            <div class="body-head f-h30" align="left">
                <%--<a id="btn_back" class="f-fwb">返回上一层 </a>--%>
                <input id="adapter_plan_id" value='${adapterPlanId}' hidden="none" />
                <span class="f-ml20">视图名称：</span><input class="f-fwb f-mt10" readonly id="resource_name"/>
                <span class="f-ml20">视图主题：</span><input class="f-mt10" readonly id="resource_sub"/>
            </div>
        </div>

        <div id="grid_content" style="width: 100%;position: relative;overflow: hidden;padding-left: 7px;">
            <!--   属性菜单 -->
            <div id="div_left" style=" width:260px;float: left;">
                <div id="retrieve" class="m-retrieve-area f-pr m-form-inline condition retrieve-border" style="height: 90px" data-role-form>

                    <div id="retrieve_inner" class="m-retrieve-inner m-form-group f-mt10 f-ml10">
                        <div class=" f-mb10">
                            <div id="btn_goto_grant" style="width:240px !important;" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                                <span>应用授权</span>
                            </div>
                        </div>

                        <div class="m-form-control" >
                            <input type="text" id="ipt_search" placeholder="请输入应用名称" class="f-ml10" data-attr-scan="searchNm"/>
                        </div>
                    </div>
                </div>
                <div id="treeMenuWrap" style="border: 1px solid #D6D6D6; width: 260px; height: 100px">
                    <div id="treeMenu"></div>
                </div>
            </div>

            <!--   列表   -->
            <div id="div_right_g" style="float: left;width: 700px;margin-left: 10px">

                <div id="entryRetrieve" class="m-retrieve-area f-pr m-form-inline condition retrieve-border" data-role-form>
                    <div id="resource_title" style="font-size: 20px; height: 40px; text-align: center; padding-top: 14px; font-weight: bold"></div>
                    <div id="entry_retrieve_inner" class="m-retrieve-inner m-form-group f-mt10">


                    </div>

                </div>

                <div id="rightGrid"></div>
            </div>
        </div>
    </div>

</div>


