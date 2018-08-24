<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%--定义页面文档类型以及使用的字符集,浏览器会根据此来调用相应的字符集显示页面内容--%>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">

    <%--IE=edge告诉IE使用最新的引擎渲染网页，chrome=1则可以激活Chrome Frame.--%>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">

    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>基础信息平台</title>
    <tiles:insertAttribute name="header" />
    <tiles:insertAttribute name="layoutCss" ignore="true"/>
    <tiles:insertAttribute name="pageCss" ignore="true"/>
    <link rel="stylesheet" href="${staticRoot}/common/font-awesome.css">
    <link rel="stylesheet" href="${staticRoot}/common/style.min.css">
        <style>
            .menucyc >li>ul>li>ul>li ul{
                border: none;
            }
        </style>
</head>
<body>
<%--top--%>
<div id="div_top" class="l-page-top m-logo">
    <div class="f-fr usr_msg">
        欢迎登录：${current_user.realName}&nbsp;&nbsp;|&nbsp;&nbsp;<a href="${contextRoot}/user/initialChangePassword"
                                                                 class="f-color-0">修改密码</a><br>
        上次登录：${last_login_time}&nbsp;&nbsp;|&nbsp;&nbsp;<a href="${contextRoot}/logout/reLogin" class="f-color-0">退出</a>
    </div>
</div>
<%--<div class="m-index-nav" style="display: none;">--%>
    <%--当前位置：<span id="n_indexNav"></span>--%>
<%--</div>--%>
<div id="div_main_content" class="l-layout">
    <div position="left" class="l-layout-content f-hh" hidetitle="false">
        <!--菜单导航栏-->
        <div class="m-nav-menu f-hh" id="menucyc-scroll">
            <div class="m-snav-title f-pr f-h40 f-ww f-fs14 s-c0 s-bc2 f-fwb">
                <div class="img-bgp"></div>
                <spring:message code="title.navigation.menu"/>
            </div>
            <div class="m-nav-tree f-hh">
                <ul id="ul_tree" class="m-snav"></ul>
            </div>
        </div>
    </div>
    <div position="center" title="" class="l-layout-content">
        <%--tab-content--%>
        <div class="content-tabs">
            <button class="roll-nav roll-left J_tabLeft"><i class="glyphicon glyphicon-chevron-left"></i></button>
            <nav class="page-tabs J_menuTabs">
                <div class="page-tabs-content">
                </div>
            </nav>
            <button class="roll-nav roll-right J_tabRight"><i class="glyphicon glyphicon-chevron-right"></i></button>
            <div class="btn-group roll-nav roll-right">
                <button class="dropdown J_tabClose" data-toggle="dropdown">关闭操作<span class="caret"></span></button>
                <ul role="menu" class="dropdown-menu dropdown-menu-right">
                    <li class="J_tabCloseAll"><a>关闭全部选项卡</a>
                    </li>
                    <li class="J_tabCloseOther"><a>关闭其他选项卡</a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="J_mainContent" id="content-main">

        </div>
    </div>
</div>
<tiles:insertAttribute name="footer" />
<tiles:insertAttribute name="layoutJs" ignore="true"/>
<tiles:insertAttribute name="pageJs" ignore="true"/>
</body>
</html>
