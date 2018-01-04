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
    <title>${title}</title>
    <tiles:insertAttribute name="header" />
    <tiles:insertAttribute name="pageCss" ignore="true"/>
        <style>
            html,body{
                height: 100%;
            }
            .u-nav-breadcrumb {
                height: 40px;
                line-height: 40px;
            }
            .s-bc5 {
                background-color: #edf6fa;
            }
            .grid_edit {
                display: inline-block;
                width: 40px;
                height: 40px;
                cursor: pointer;
                background: url(${staticRoot}/images/app/bianji01_btn.png) center no-repeat;
            }
            .grid_delete {
                display: inline-block;
                width: 40px;
                height: 40px;
                cursor: pointer;
                background: url(${staticRoot}/images/app/shanchu01_btn.png) center no-repeat;
            }
            .grid_hold{
                display:inline-block;
                width: 40px;
                height: 40px;
                cursor:pointer;
                background: url(${staticRoot}/images/app/icon_baocun.png) center no-repeat;
            }
            .grid_towrite{
                display:inline-block;
                width: 40px;
                height: 40px;
                cursor:pointer;
                background: url(${staticRoot}/images/app/icon_bianji.png) center no-repeat;
            }
            .grid_detail{
                display:inline-block;
                width: 40px;
                height: 40px;
                cursor:pointer;
                background: url(${staticRoot}/images/app/icon_xiangqing.png) center no-repeat;
            }
            a{
                vertical-align: middle;
            }
            .go-back{
                float: right;
                margin-top: 4px;
                margin-right: 11px;
            }
            #div_wrapper{
                height: 100%;
                overflow: hidden;
                position: relative;
            }
            #contentPage{
                /*height: calc(100% - 40px);*/
                height: 100%;
                padding: 10px 10px;
            }
        </style>
</head>
<body style="overflow: hidden">
    <div id="div_nav_breadcrumb_bar" class="u-nav-breadcrumb f-pl10 s-bc5 f-fwb" style="display: none">
        位置：<span id="navLink"></span>
    </div>
    <div data-content-page style="" id="contentPage">
        <tiles:insertAttribute name="contentPage" ignore="true"/>
    </div>
    <tiles:insertAttribute name="footer"/>
    <tiles:insertAttribute name="pageJs" ignore="true"/>
    <input type="hidden" id="flag_top_window" />
    <script>
        window.addEventListener('message', function(e){
            if (e.data) {
                 $('#navLink').html(e.data.join(' <i class="glyphicon glyphicon-chevron-right"></i> '));
            } else {
                alert('未定义的消息');
            }
        }, false);
    </script>

</body>
</html>