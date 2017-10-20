<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/10/20
  Time: 10:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    (function (w, $, u) {
        $(function () {
            function textRender(row, index, name, column){
//                根据自己的需求判断字段  输出表格对应内容
                return '';
            }
            var UOED = {
                $impGrid: $('#impGrid'),
                $downLoad: $('#downLoad'),
                $saveBtn: $('#saveBtn'),
                thisGrid: null,
                init: function () {
                    this.loadGriData(this.initGridClom());
                },
                initGridClom: function () {
                    return [
                        {display: '排序号', name: 'excelSeq', hide: true, render: function (row, index) {
                            return '<input type="hidden" value="'+ row.excelSeq +'" data-attr-scan="excelSeq_'+ index +'">'
                        }},
                        {display: '机构代码', name: 'orgCode', width: '110', align: 'left', render: textRender},
                        {display: '机构全名', name: 'fullName', width: '93', align: 'left', render: textRender},
                        {display: '医院类型', name: 'hosTypeId', width: '151', align: 'left', render: textRender},
                        {display: '医院归属',hide: true, name: 'ascriptionType', width: '40', align: 'left', render: textRender},
                        {display: '机构简称', hide: true, name: 'shortName', width: '110', align: 'left', render: textRender},
                        {display: '机构类型', name: 'orgType', width: '110', align: 'left', render: textRender},
                        {display: '医院等级',hide: true,  name: 'levelId', width: '100', align: 'left', render: textRender},

                        {display: '医院法人', hide: true,name: 'legalPerson', width: '148', align: 'left', render: textRender},
                        {display: '联系人', name: 'admin', width: '140', align: 'left', render: textRender},
                        {display: '联系方式', name: 'phone', width: '125', align: 'left', render: textRender},
                        {display: '中西医标识',hide: true, name: 'zxy', width: '140', align: 'left', render: textRender},

                        {display: '上级医院',  hide: true,name: 'parentHosId', width: '95', align: 'left', render: textRender},
                        {display: '机构地址',  hide: true,name: 'location', width: '95', align: 'left', render: textRender},
                        {display: '交通路线',  hide: true,name: 'traffic', width: '95', align: 'left', render: textRender},
                        {display: '入驻方式',  hide: true,name: 'settledWay', width: '95', align: 'left', render: textRender},
                        {display: '经度',  hide: true,name: 'ing', width: '95', align: 'left', render: textRender},
                        {display: '标签',  hide: true,name: 'tags', width: '95', align: 'left', render: textRender},
                        {display: '医院简介',  hide: true,name: 'introduction', width: '95', align: 'left', render: textRender},
                        {display: '资质信息',  hide: true,name: 'qualification', width: '95', align: 'left', render: textRender},
                        {display: '纬度', hide: true, name: 'lat', width: '95', align: 'left', render: textRender}
                    ];
                },
                loadGriData: function (columns) {
                    var me = this;
                    me.thisGrid = me.$impGrid.ligerGrid($.LigerGridEx.config({
                        url: '',
                        columns:columns,
                        height: 520,
                        pageSize:10,
                        pageSizeOptions:[10, 15],
                        delayLoad: true,
                        checkbox: false,
//                        onAfterShowData: data
                    }))
                    me.thisGrid.adjustToWidth();
                }
            }
        });
    })(window, jQuery)
</script>
