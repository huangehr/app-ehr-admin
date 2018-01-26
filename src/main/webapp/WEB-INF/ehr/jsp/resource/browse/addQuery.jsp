<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018/1/24 0024
  Time: 下午 4:23
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ include file="addQueryCss.jsp" %>
<div class="aq-main animated fadeInRight">
    <div class="aq-top">
        <div class="aq-tit"><span class="aq-tit-one">综合查询系统</span><apan class="aq-tit-two"> &nbsp;&gt;&nbsp; 新建查询</apan></div>
        <div class="aq-btns">
            <div class="aq-btn" id="saveBtn">生成视图</div>
            <div class="aq-btn" id="outExc">导出数据</div>
            <!--<div class="aq-btn show-set-btn">展开设置 <i class="icon-d"></i></div>-->
            <div class="aq-btn sel-btn">筛选 <i class="icon-d"></i></div>
        </div>
        <div class="sel-con">
            <form class="layui-form" name="aqform" action="">
                <div class="sel-body">

                    <div class="sel-set-body" id="selSetBody">
                        <div class="set-set-item" v-if="timeChkBox.length > 0">
                            <div class="set-label">
                                <span class="c-box c-box-all" v-on:click="checkTimeAll()" :class="timeClass"></span>
                                <i class="set-icon-time"></i>
                                <span class="label-text">日期</span>
                            </div>
                            <div class="set-list set-time-con">
                                <ul class="check-list">
                                    <li v-for="(item, index) in timeChkBox">
                                        <span class="c-box c-box-one" v-on:click="setCheckTimeSta(index)" :class="item.checked"></span>
                                        <span class="item-text" v-text="item.name"></span>
                                    </li>
                                </ul>
                                <!--字段内容-->
                            </div>
                        </div>
                        <div class="set-set-item" v-if="textChkBox.length > 0">
                            <div class="set-label">
                                <span class="c-box c-box-all" v-on:click="checkTextAll()" :class="textClass"></span>
                                <i class="set-icon-text"></i>
                                <span class="label-text">文本</span>
                            </div>
                            <div class="set-list set-text-con ">
                                <ul class="check-list">
                                    <li v-for="(item, index) in textChkBox">
                                        <span class="c-box c-box-one" v-on:click="setCheckTextSta(index)" :class="item.checked"></span>
                                        <span class="item-text" v-text="item.name"></span>
                                    </li>
                                </ul>
                                <!--字段内容-->
                            </div>
                        </div>

                        <!--<div class="sel-btns">-->
                        <!--<div class="aq-btn" id="sureSetBtn" v-on:click="setTableTitle()">确定</div>-->
                        <!--<button type="reset" id="resetSetBtn" class="aq-btn aq-defaule" v-on:click="resetCheck()">重置</button>-->
                        <!--</div>-->
                    </div>

                    <ul id="dynamicSelData" class="sel-list">
                        <!--筛选条件-->
                    </ul>
                </div>
                <div class="sel-btns">
                    <div class="aq-btn" id="searchBtn" lay-submit lay-filter="formDemo">确定</div>
                    <button type="reset" id="resetForm" class="aq-btn aq-defaule">重置</button>
                </div>
            </form>
        </div>
    </div>
    <!--表格-->
    <div class="aq-bottom">
        <table class="aq-table" data-mobile-responsive="true"></table>
    </div>
</div>
<%@ include file="addQueryJS.jsp" %>

