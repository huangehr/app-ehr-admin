<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######用户管理页面Title设置######-->

<div class="boxContain">
    <div class="div_Top">
        <div class="sm_box inlineBloock"></div>
        <div class="standbyText inlineBloock">
            待命地点设置
        </div>
        <div class="addBtn inlineBloock">新增</div>
        <div id="standby_grid"></div>
    </div>
    <%--<div class='div_Bottom' >--%>
        <%--<div class="sm_box inlineBloock"></div>--%>
        <%--<div class="standbyText inlineBloock">--%>
            <%--频率设置--%>
        <%--</div>--%>
        <%--<div class="contain_save">--%>
            <%--<div class="sm_contain_save">--%>
                <%--<input type="text">--%>
                <%--<input type="button" value="保存">--%>
                <%--<input type="button" value="取消" style="margin-left: 20px;border: none;background: #f1f5f7;">--%>
            <%--</div>--%>
            <%--<div class="sm_contain_text">--%>
                <%--手机app定位时间间隔，单位秒，只能输入自然数--%>
            <%--</div>--%>
        <%--</div>--%>
    <%--</div>--%>
</div>