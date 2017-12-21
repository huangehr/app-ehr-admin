<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.dict.manage"/></div>
<div id="div_wrapper" >
    <div style="width: 100%" id="grid_content">
        <div id="div_left" style="width:100%;float: left;">
            <div id="dictRetrieve" class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" style="display:block;">
                <div class="m-form-group f-mt10">
                    <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
                    </div>
                    <div class="m-form-control f-fs12">
                        <input type="text" id="searchNm" placeholder="请输入车牌号码">
                    </div>

                    <div class="m-form-control f-mr10 f-fr">
                        <sec:authorize url="/emergency/createMenu">
                        <div id="div_new_record" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam"  onclick="javascript:$.publish('urgentcommand:vehiclemMenu:open',['','new'])">
                            <span><spring:message code="btn.create"/></span>
                        </div>
                        </sec:authorize>
                    </div>

                </div>
            </div>
            <div id="div_relLoad_data" ms-controller="avacontroller" >
                <ul class="temp">
                    <li ms-repeat-item="data">
                        <div class="info">
                            <div class="inlineBlock backroundImg"></div>
                            <div class="inlineBlock boxText">
                                <p  ms-text="item.id"></p>
                                <p>归属地：<a  ms-text="item.orgName"></a></p>
                                <p>手机号码：<a ms-text="item.phone"></a></p>
                                <p ms-if="item.status=='wait'" class="status">状态：<a style="color: #35afe1">待命中</a></p>
                                <p ms-if="item.status=='onWay'" class="status">状态：<a style="color: #35afe1">前往中</a></p>
                                <p ms-if="item.status=='arrival'" class="status">状态：<a style="color: #35afe1">抵达</a></p>
                                <p ms-if="item.status=='back'" class="status">状态：<a style="color: #35afe1">返程中</a></p>
                                <p ms-if="item.status=='down'" class="status">状态：<a style="color: #35afe1">休息</a></p>
                            </div>
                            <sec:authorize url="/government/editMenu">
                            <div class="inlineBlock change"ms-click="jumpMenu(item.id)">
                            </div>
                            </sec:authorize>
                        </div>
                        <div class="edit">
                            <input class="btn  be_On_change" type="button" value="休息" data-code="1" ms-if="item.status!='down'" ms-attr-id="item.id">
                            <input class="btn  be_On_change" type="button" value="值班" data-code="0" ms-if="item.status=='down'" ms-attr-id="item.id">
                            <input class="btn  delete" type="button" value="删除" ms-attr-id="item.id">
                        </div>
                    </li>
                    <%--<li>--%>
                    <%--<div class="info">--%>
                    <%--<div class="inlineBlock backroundImg"></div>--%>
                    <%--<div class="inlineBlock boxText">--%>
                    <%--<p>赣E12012</p>--%>
                    <%--<p>归属地:上饶市人民第五医院</p>--%>
                    <%--<p>随车手机:13859288248</p>--%>
                    <%--<p>状态:<a style="color: #35afe1">休息中</a></p>--%>
                    <%--</div>--%>
                    <%--<div class="inlineBlock change"></div>--%>
                    <%--</div>--%>
                    <%--<div class="edit">--%>
                    <%--<input class="btn  be_On_duty" type="button" value="值班">--%>
                    <%--<input class="btn  delete" type="button" value="删除">--%>
                    <%--</div>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                    <%--<div class="info">--%>
                    <%--<div class="inlineBlock backroundImg"></div>--%>
                    <%--<div class="inlineBlock boxText">--%>
                    <%--<p>赣E12012</p>--%>
                    <%--<p>归属地:上饶市人民第五医院</p>--%>
                    <%--<p>随车手机:13859288248</p>--%>
                    <%--<p>状态:<a style="color: #35afe1">休息中</a></p>--%>
                    <%--</div>--%>
                    <%--<div class="inlineBlock change"></div>--%>
                    <%--</div>--%>
                    <%--<div class="edit">--%>
                    <%--<input class="btn  be_On_duty" type="button" value="值班">--%>
                    <%--<input class="btn  delete" type="button" value="删除">--%>
                    <%--</div>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                    <%--<div class="info">--%>
                    <%--<div class="inlineBlock backroundImg"></div>--%>
                    <%--<div class="inlineBlock boxText">--%>
                    <%--<p>赣E12012</p>--%>
                    <%--<p>归属地:上饶市人民第五医院</p>--%>
                    <%--<p>随车手机:13859288248</p>--%>
                    <%--<p>状态:<a style="color: #35afe1">休息中</a></p>--%>
                    <%--</div>--%>
                    <%--<div class="inlineBlock change"></div>--%>
                    <%--</div>--%>
                    <%--<div class="edit">--%>
                    <%--<input class="btn  be_On_duty" type="button" value="值班">--%>
                    <%--<input class="btn  delete" type="button" value="删除">--%>
                    <%--</div>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                    <%--<div class="info">--%>
                    <%--<div class="inlineBlock backroundImg"></div>--%>
                    <%--<div class="inlineBlock boxText">--%>
                    <%--<p>赣E12012</p>--%>
                    <%--<p>归属地:上饶市人民第五医院</p>--%>
                    <%--<p>随车手机:13859288248</p>--%>
                    <%--<p>状态:<a style="color: #35afe1">休息中</a></p>--%>
                    <%--</div>--%>
                    <%--<div class="inlineBlock change"></div>--%>
                    <%--</div>--%>
                    <%--<div class="edit">--%>
                    <%--<input class="btn  be_On_duty" type="button" value="值班">--%>
                    <%--<input class="btn  delete" type="button" value="删除">--%>
                    <%--</div>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                    <%--<div class="info">--%>
                    <%--<div class="inlineBlock backroundImg"></div>--%>
                    <%--<div class="inlineBlock boxText">--%>
                    <%--<p>赣E12012</p>--%>
                    <%--<p>归属地:上饶市人民第五医院</p>--%>
                    <%--<p>随车手机:13859288248</p>--%>
                    <%--<p>状态:<a style="color: #35afe1">休息中</a></p>--%>
                    <%--</div>--%>
                    <%--<div class="inlineBlock change"></div>--%>
                    <%--</div>--%>
                    <%--<div class="edit">--%>
                    <%--<input class="btn  be_On_duty" type="button" value="值班">--%>
                    <%--<input class="btn  delete" type="button" value="删除">--%>
                    <%--</div>--%>
                    <%--</li>--%>
                </ul>
            </div>
            <%--分页--%>
            <div class="fydiv">
                <ul class="fenye">

                </ul>
            </div>
        </div>

    </div>
</div>

