<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div id="div_wrapper">
    <h4 class="f-mb20">接收时间：2018-06-01 - 2018-06-07</h4>
    <%--tab切换--%>
    <div class="f-tac f-mb20">
        <div class="btn-group" data-toggle="buttons">
            <label class="btn btn-default active" style="width: 100px;" id="tab1"><input type="radio" name="options" autocomplete="off" checked="">医院数据</label>
            <label class="btn btn-default" style="width: 100px;" id="tab2"><input type="radio" name="options" autocomplete="off">接收</label>
            <label class="btn btn-default" style="width: 100px;" id="tab3"><input type="radio" name="options" autocomplete="off">资源化</label>
        </div>
    </div>

    <div id="item1" class="item">
        <div class="panel-header">
            医院就诊档案数
        </div>
        <div id="table1" style="width: 100%"></div>
        <div class="panel-header mt20">
            医院数据集数
        </div>
        <div id="table2"></div>
    </div>
    <div id="item2" class="item" style="display: none;">
        <div class="panel-header">
            接收档案数
        </div>
        <div id="table3"></div>
        <div class="panel-header mt20">
            接收数据集数
        </div>
        <div id="table4"></div>
        <div class="panel-header mt20">
            质量异常详情
        </div>
        <div id="table5"></div>
    </div>
    <div id="item3" class="item" style="display: none;">
        <div class="panel-header">
            解析档案数
        </div>
        <div id="table6"></div>
        <div class="panel-header mt20">
            解析失败详情
        </div>
        <div id="table7"></div>
        <div class="panel-header mt20">
            质量异常详情
        </div>
        <div id="table8"></div>
    </div>
</div>
