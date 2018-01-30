<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2018/1/9
  Time: 9:16
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<div class="iq-body animated fadeInRight">
    <div class="iq-top">
        <ul class="check-tab">
            <li class="check-item active">新查询</li>
            <li class="check-item">已存查询</li>
        </ul>
    </div>
    <!--新查询-->
    <div class="iq-main">
        <div class="iq-left">
            <div class="pub-tit"><span>类型</span></div>
            <div class="iq-type">
                <ul class="iq-type-check">
                    <li class="iq-type-item active">档案数据</li>
                    <li class="iq-type-item">指标统计</li>
                </ul>
                <div class="iq-l-search">
                    <input type="text" id="searchVal">
                    <a href="#" id="searchBtn"></a>
                </div>
            </div>
            <!--树-->
            <div class="iq-tree-con">
                <div class="iq-tree ztree" id="resourceTree"></div>
                <div class="iq-tree ztree" id="quotaTree" style="display: none"></div>
            </div>
        </div>
        <div class="iq-right">
            <div class="pub-tit"><span>已选</span><div class="sel-btn" id="selBtn">查询</div></div>
            <!--表格-->
            <div class="iq-table-con">
                <!--档案数据-->
                <table class="iq-table" id="resourceTable" data-mobile-responsive="true"></table>
                <!--指标数据-->
                <table class="iq-table" id="quotaTable" style="display: none" data-mobile-responsive="true"></table>
            </div>
        </div>
    </div>
    <!--已存查询-->
    <div class="iq-main" style="display: none">
        <div id="iqApp">
            <div class="pub-tit"><span>已存查询</span></div>
            <div class="iq-char-list">
                <div class="iq-char-item" v-for="item in qrList" :data-id="item.id" v-on:click="goInfo(item.id, item.code, item.dataSource, item.name)">
                    <a href="#" class="iq-close" v-on:click="del(item.id)"></a>
                    <img src="${staticRoot}/images/PxBkCook_03.png" alt="">
                    <p class="img-tit" v-text="item.name"></p>
                </div>
            </div>
            <div class="load-more" v-on:click="load()">
                <i class="icon-load" v-if="isShow"></i><span class="load-con" v-text="message"></span>
            </div>
        </div>
    </div>
</div>