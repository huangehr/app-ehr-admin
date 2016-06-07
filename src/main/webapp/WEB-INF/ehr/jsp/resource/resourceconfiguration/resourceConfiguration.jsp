<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######资源浏览页面Title设置######-->
<div class="f-dn" data-head-title="true">资源配置</div>
<div class="f-mat" id="div_wrapper">

    <div class="div-resource-configuration-title">
        <a id="btn_back" class="f-fl" >返回上一层</a>
        <div class="f-fl f-ml100">
            <span>资源名称：</span><span id="sp_resourceName"></span>
        </div>
        <div class="f-fl f-ml100">
            <span>资源主题：</span><span id="sp_resourceSub"></span>
        </div>
    </div>
    <hr>
    <span class="sp-resource-configuration-name"><h3>患者就诊用药信息_资源配置</h3></span>


    <div class="div-resource-configuration">

        <div class="f-fl f-mpr">
            <%--标准数据元--%>
            <div class="f-fl f-bd-configuration f-ml200test" >

                <div class="f-h30 f-mt10 f-mb10" >
                        <span class="f-mt10 f-fs14 f-ml10 f-fl" >
                            <strong class="f-fwb">标准数据元:</strong>
                        </span>
                        <span class="f-fl f-ml10">
                            <input type="text" id="inp_mateData_search" placeholder="请输入数据元编号或名称">
                        </span>
                </div>

                <div id="div_resource_configuration_info_grid" class="f-wat"></div>
            </div>

            <%--已选择的数据元--%>
            <div class="f-fr f-bd-configuration">
                <div class="f-h30 f-mt10 f-mb10">
                        <span class="f-mt10 f-fs14 f-ml10 f-fl">
                            <strong class="f-fwb">已选择:</strong>
                        </span>
                        <span class="f-fl f-ml10">
                            <input type="text" id="inp_mateData_search_true" placeholder="请输入数据元编号或名称">
                        </span>
                </div>
                <div id="div_resource_configuration_info_grid_true"></div>
            </div>
        </div>

        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar f-fr f-mt10" id="div_save_btn">
            <span>保存</span>
        </div>
    </div>
</div>
<input type="hidden" id="infoMsg" value="false">