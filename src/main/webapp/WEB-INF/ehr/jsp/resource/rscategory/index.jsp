<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="f-dn" data-head-title="true">资源类别</div>
<div id="div_wrapper">
    <div class="m-retrieve-area f-h50 f-dn f-pr"
         style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px;">
        <ul>
            <li class="f-mt15 li_seach">
                <div style="float: left; width: 250px; margin-left: 12px; margin-top: -5px;">
                    <input type="text" id="inp_search" name="inp_search" placeholder="请输入名称"
                           class="f-ml10" >
                </div>

                <sec:authorize url="/rscategory/typeupdate">
                <div style="float: right; width: 95px; margin-top: -5px;">
                    <a id="btn_Update_relation" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">
                        新增
                    </a>
                </div>
                </sec:authorize>
            </li>
        </ul>
    </div>
    <div id="div_cate_type_grid">

    </div>
    <input type="hidden" id="hd_url" value="${contextRoot}"/>
</div>