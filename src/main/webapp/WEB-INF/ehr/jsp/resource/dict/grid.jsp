<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- ####### Title设置 ####### -->
<div class="f-dn" data-head-title="true">字典</div>

<!-- ####### 页面部分 ####### -->
<div>

    <div id="div_wrapper">

        <div id="grid_content" style="width: 100%">
            <!--   字典-->
            <div id="div_left" style=" width:400px;float: left;">
                <div id="retrieve" class="m-retrieve-area f-h50 f-pr m-form-inline condition retrieve-border" data-role-form>

                    <div id="retrieve_inner" class="m-retrieve-inner m-form-group f-mt10">

                        <div class="f-mt10 f-fs14 f-ml10 f-fl f-fwb f-mr10">
                            <span id="left_title"><spring:message code="lbl.dict"/></span>
                        </div>

                        <div class="m-form-control" >
                            <input type="text" id="ipt_search" placeholder="请输入方案代码或名称" class="f-ml10" data-attr-scan="code"/>
                        </div>

                    </div>
                </div>

                <div id="leftGrid"></div>
            </div>

            <!--   字典项   -->
            <div id="div_right" style="float: left;width: 700px;margin-left: 10px">
                <div id="entryRetrieve" class="m-retrieve-area f-h50 f-pr m-form-inline condition retrieve-border" data-role-form>
                    <input id="s_dictCode" data-attr-scan="dictCode"  hidden>
                    <div id="entry_retrieve_inner" class="m-retrieve-inner m-form-group f-mt10">

                        <div class="f-mt10 f-fs14 f-ml10 f-fl f-fwb f-mr10">
                            <span id="right_title"><spring:message code="lbl.dict.meta"/></span>
                        </div>

                        <div class="m-form-control" >
                            <input type="text" id="searchNmEntry" placeholder="<spring:message code="lbl.input.placehold"/>" class="f-ml10" data-attr-scan="code"/>
                        </div>


                        </div>

                </div>

                <div id="rightGrid"></div>
            </div>
        </div>
    </div>

</div>

