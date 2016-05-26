<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<!--######资源浏览页面Title设置######-->
<div class="f-dn" data-head-title="true">资源浏览</div>
<div class="f-mt20">

    <div class="div-resource-configuration-title">
        <a class="f-fl" href="#" onclick="javasctipt:histoty.back()">返回</a>
        <div class="f-fl f-ml100">
            <span>资源名称：</span><span>用户资源</span>
        </div>
        <div class="f-fl f-ml100">
            <span>资源主题：</span><span>用户</span>
        </div>
        <span class="sp-resource-configuration-name">患者就诊用药信息_资源配置</span>
    </div>
    <hr>

    <div class="div-resource-configuration">

        <div class="f-ml100 f-fl">
            <%--标准数据元--%>
            <div class="f-fl f-bd-configuration f-ml200">

                <div class="f-h40 f-mt20">
                        <span class="f-mt10 f-fs14 f-ml10">
                            <strong class="f-fwb">标准数据元:</strong>
                        </span>
                        <span class="sp-mateData-serch">
                            <input type="text" id="inp_mateData_search" placeholder="请输入数据元编号或名称">
                        </span>
                </div>

                <div id="div_resource_configuration_info_grid"></div>
            </div>

            <%--已选择的数据元--%>
            <div class="f-fr f-bd-configuration f-ml100">
                <div class="f-h40 f-mt20">
                        <span class="f-mt10 f-fs14 f-ml10">
                            <strong class="f-fwb">已选择:</strong>
                        </span>
                        <span class="sp-mateData-serch">
                            <input type="text" id="inp_mateData_search_true" placeholder="请输入数据元编号或名称">
                        </span>
                </div>
                <div id="div_resource_configuration_info_grid_true"></div>
            </div>
        </div>

        <div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar f-mt600" id="div_save_btn">
            <span>保存</span>
        </div>
    </div>
</div>