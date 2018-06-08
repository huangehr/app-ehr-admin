<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var table1;
            var table2;
            var table3;
            var table4;
            var table5;
            var table6;
            var table7;
            var table8;
            var startDate="2018-06-01";
            var endDate="2018-06-07";
            var orgCode="";
            var click=[1,0,0];
            pageInit();

            function pageInit() {
                $(".item").css("height",$(window).height()-100);
                bindEvents();
                initItem1();
            }
            function initItem1() {
                table1 = $("#table1").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/qcReport/dailyReport',
                    parms: {
                        startDate: startDate,
                        endDate: endDate,
                        orgCode: orgCode
                    },
                    height: '112px',
                    method:'GET',
                    columns: [
                        { display: '住院档案数', name: 'inpatient', width: '25%', align:'center'},
                        { display: '门诊档案数', name: 'oupatient', width: '25%',align:'center'},
                        { display: '体检档案数', name: 'physical', width: '25%',align:'center'},
                        { display: '总计', name: 'total', width: '25%',align:'center'}
                    ],
                    enabledSort:false,
                    rownumbers:false,
                    usePager:false
                }));
                table1.adjustToWidth();

                table2 = $("#table2").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/qcReport/datasetWarningList',
                    parms: {
                        type: '1',
                        orgCode: orgCode
                    },
                    method:'GET',
                    columns: [
                        { display: '编码', name: 'datasetCode',width: '50%',align:'center'},
                        { display: '名称', name: 'datasetName', width: '50%',align:'center'}
                    ],
                    enabledSort:false
                }));
                table2.adjustToWidth();
            }
            function initItem2() {
                table3 = $("#table3").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/qcReport/archiveReport',
                    parms: {
                        startDate: startDate,
                        endDate: endDate,
                        orgCode: orgCode
                    },
                    pageSize:2,
                    method:'GET',
                    columns: [
                        { display: '日期', name: 'date',width: '20%',align:'center'},
                        { display: '住院档案数', name: 'inpatient',width: '20%',align:'center'},
                        { display: '门诊档案数', name: 'oupatient',width: '20%',align:'center'},
                        { display: '体检档案数', name: 'physical',width: '20%',align:'center'},
                        { display: '总计', name: 'total',width: '20%',align:'center'}
                    ],
                    enabledSort:false,
                    usePager:false
                }));
                table3.adjustToWidth();

                table4 = $("#table4").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/qcReport/dataSetList',
                    parms: {
                        startDate: startDate,
                        endDate: endDate,
                        orgCode: orgCode
                    },
                    method:'GET',
                    columns: [
                        { display: '编码', name: 'dataset',align:'center'},
                        { display: '名称', name: 'datasetName',align:'center'},
                        { display: '总数', name: 'count',align:'center'},
                        { display: '行数', name: 'row',align:'center'}
                    ],
                    enabledSort:false,
                    usePager:false
                }));
                table4.adjustToWidth();

                table5 = $("#table5").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/qcReport/metadataError',
                    parms: {
                        step: "1",
                        startDate: startDate,
                        endDate: endDate,
                        orgCode: orgCode
                    },
                    method:'GET',
                    columns: [
                        { display: '错误原因', name: 'error_type',align:'center'},
                        { display: '错误数量', name: 'error_count',align:'center'}
                    ],
                    enabledSort:false,
                    usePager:false
                }));
                table5.adjustToWidth();
            }
            function initItem3() {
                table6 = $("#table6").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/qcReport/resourceSuccessfulCount',
                    parms: {
                        startDate: startDate,
                        endDate: endDate,
                        orgCode: orgCode
                    },
                    method:'GET',
                    height: '112px',
                    columns: [
                        { display: '住院档案数', name: 'inpatient',align:'center'},
                        { display: '门诊档案数', name: 'oupatient',align:'center'},
                        { display: '体检档案数', name: 'physical',align:'center'},
                        { display: '总计', name: 'total',align:'center'}
                    ],
                    enabledSort:false,
                    rownumbers:false,
                    usePager:false
                }));
                table6.adjustToWidth();

                table7 = $("#table7").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/qcReport/archiveFailed',
                    parms: {
                        startDate: startDate,
                        endDate: endDate,
                        orgCode: orgCode
                    },
                    method:'GET',
                    columns: [
                        { display: '错误原因', name: 'error_type',align:'center'},
                        { display: '错误数量', name: 'error_count',align:'center'}
                    ],
                    enabledSort:false,
                    usePager:false
                }));
                table7.adjustToWidth();

                table8 = $("#table8").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/qcReport/metadataError',
                    parms: {
                        step: "2",
                        startDate: startDate,
                        endDate: endDate,
                        orgCode: orgCode
                    },
                    method:'GET',
                    columns: [
                        { display: '错误原因', name: 'error_type',align:'center'},
                        { display: '错误数量', name: 'error_count',align:'center'}
                    ],
                    enabledSort:false,
                    usePager:false
                }));
                table8.adjustToWidth();
            }
            function bindEvents() {
                $(".btn-group").on("click",".btn",function() {
                    var index = $(this).index();
                    $(".btn-group").find(".btn").removeClass("active");
                    $(this).addClass("active");
                    if(index == 0){
                        $("#item1").show();
                        $("#item2").hide();
                        $("#item3").hide();
                    }else if (index == 1){
                        $("#item1").hide();
                        $("#item2").show();
                        $("#item3").hide();
                        if(click[1]==0) {
                            click[1] = 1;
                            initItem2();
                        }
                    }else{
                        $("#item1").hide();
                        $("#item2").hide();
                        $("#item3").show();
                        if(click[2]==0) {
                            click[2] = 1;
                            initItem3();
                        }
                    }
                });
            }
        });
    })(jQuery, window);
</script>