<%--
  Created by IntelliJ IDEA.
  User: AndyCai
  Date: 2015/11/25
  Time: 10:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true">数据集管理</div>
<div id="div_wrapper">
    <div style="height: 34px">

        <sec:authorize url="/template/平台标准数据集导入模版.xls">
        <a href="<%=request.getContextPath()%>/template/平台标准数据集导入模版.xls" class="btn u-btn-primary u-btn-small s-c0 J_add-btn f-fl f-mr10"
           style="">
            下载模版
        </a>
        </sec:authorize>

        <sec:authorize url="/std/dataset/import">
        <div id="upd" class="f-fl f-mr10" style="overflow: hidden; width: 84px; position: relative"></div>
        </sec:authorize>

    <%--<div id="div_upload" class="f-mr100" data-alone-file=true align="right">--%>
        <!--用来存放item-->
        <%--<div id="div_file_list" class="uploader-list f-mr100 f-h30"></div>--%>
        <%--<div id="div_file_picker" class="f-mt10" style="margin-top: -30px;">导入数据集</div>--%>
    <%--</div>--%>

        <sec:authorize url="/std/dataset/exportToExcel">
        <div>
            <button id="div_file_export" class="btn u-btn-primary u-btn-small s-c0 f-fl f-mr10" style="margin-top: 0px;height: 30px">全部导出</button>
        </div>
        </sec:authorize>

        <div id="conditionArea" class="f-mb10 f-mr10 f-fr" align="right">
            <input type="text" data-type="select" id="cdaVersion" data-attr-scan="version">
        </div>
    </div>
    <div style="width: 100%" id="grid_content">
        <!--######CDA信息表######-->
        <div id="div_left">
            <div class="m-retrieve-area f-h50 f-dn f-pr" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0;">
                <ul>
                    <li class="top-div f-mt10">
                        <span class="f-mt10 f-fs14 f-ml10" style="width: 70px;vertical-align: middle">
                            <strong style="font-weight: bolder;width: 70px;">数据集:</strong>
                        </span>

                        <input type="text" id="searchNm" placeholder="<spring:message code="lbl.input.placehold"/>">

                        <sec:authorize url="/std/dataset/setupdate">
                        <div title="新增" id="btn_create" class="image-create"></div>
                        </sec:authorize>
                    </li>
                </ul>
            </div>
            <div id="div_set_grid">
            </div>
        </div>
        <div id="div_right">
            <div class="m-retrieve-area f-dn f-pr" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0;overflow: hidden;">
                <ul>
                    <li class="">
                        <div class="s-con">
                            <span class="f-mt5 f-fs14 f-ml10" style="display: inline-block">
                               <strong style="font-weight: bolder;">数据元:</strong>
                            </span>
                        </div>
                        <div class="s-con">
                            <input type="text" id="searchNmEntry" placeholder="<spring:message code="lbl.input.placehold"/>"
                                   class="f-ml10">
                        </div>

                        <sec:authorize url="/std/dataset/deleteMetaData">
                            <div class="s-con f-fr">
                                <a id="btn_Delete_relation" class="btn u-btn-primary u-btn-small s-c0 J_add-btn f-fr f-mr20"
                                   style="  margin-right: 20px;margin-top: -30px;">
                                    批量删除
                                </a>
                            </div>
                        </sec:authorize>

                        <sec:authorize url="/std/dataset/elementupdate">
                            <div class="s-con f-fr">
                                <a id="btn_add_element" class="btn u-btn-primary u-btn-small s-c0 J_add-btn f-fr f-mr10"
                                   style="  margin-right: 126px;margin-top: -30px;">
                                    新增
                                </a>
                            </div>
                        </sec:authorize>
                    </li>
                </ul>
            </div>
            <div id="div_element_grid"></div>
        </div>
        <!--######用户信息表#结束######-->
    </div>
</div>

<input type="hidden" id="hd_url" value="${contextRoot}"/>
<input type="hidden" id="hdId" value=""/>
