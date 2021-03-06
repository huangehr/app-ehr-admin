<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div id="div_feature_config">
    <div class="f-ml10 f-mb10 f-mt10">
        <div class="m-form-group">
            <%--<label>配置内容：</label>--%>
            <%--<div class="l-button u-btn u-btn-primary u-btn-large f-ib f-vam save-toolbar div-roleGroup-btn"
                 id="div_fun_featrue_btn">
                <span>功能权限</span>
            </div>--%>
            <%--<div class="l-button u-btn u-btn-cancel u-btn-large f-ib f-vam close-toolbar div-roleGroup-btn"--%>
            <%--id="div_api_featrue_btn">--%>
            <%--<span>API权限</span>--%>
            <%--</div>--%>
            <div class="f-fr f-mr10 l-button u-btn u-btn-primary u-btn-large f-ib f-vam close-toolbar div-roleGroup-btn"
                   id="div_featrue_save_btn">
                <span>保存</span>
            </div>
            <div class="f-fr f-mr10 l-button u-btn u-btn-primary u-btn-large f-ib f-vam close-toolbar div-roleGroup-btn"
                 id="div_reset_btn" style="width: auto!important;padding: 0 10px;">
                <span>重置为当前用户类别关联的角色组</span>
            </div>
        </div>
    </div>
    <div class="f-mw100"><div class="f-mw50 f-fl f-ml10 f-mb10">全部角色组</div><div class="f-mw50 f-fl f-ml10 f-mb10">已选择角色组</div></div>
    <div class="f-mw100">
        <div class="f-mw50 f-ds1 f-fl f-ml10 div-appRole-grid-scrollbar" style="height: 450px">
            <%--<div class="f-mw100 f-fl f-mt5 f-mb5">--%>
                <%--<label class="f-lh30 f-ml10 f-fl lab-title-msg">角色组</label>--%>
                <%--&lt;%&ndash;<div class="f-fl">&ndash;%&gt;--%>
                    <%--&lt;%&ndash;<input type="text" id="inp_fun_featrue_search" placeholder="请输入名称" class="f-ml10"/>&ndash;%&gt;--%>
                <%--&lt;%&ndash;</div>&ndash;%&gt;--%>
            <%--</div>--%>
            <%--<hr class="f-mt5 f-mb10 f-mw100">--%>
            <%--<div id="div_function_featrue_grid"></div>--%>
            <div id="div_api_featrue_grid" class="f-dn"></div>
        </div>
        <div class="f-mw50 f-ds1 f-fr f-mr10 div-appRole-grid-scrollbar" style="height: 450px">
            <%--<label class="f-mt10 f-ml10 f-mh26">已选择角色组</label>--%>
            <%--<hr class="f-mt5 f-mb10">--%>
            <%--<div id="div_configFun_featrue_grid"></div>--%>
            <div id="div_configApi_featrue_grid" class="f-dn"></div>
        </div>
    </div>
</div>