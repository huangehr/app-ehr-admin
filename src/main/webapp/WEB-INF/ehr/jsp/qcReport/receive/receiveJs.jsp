<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;

            // 页面表格条件部模块
            var retrieve = null;

            // 页面主模块，对应于用户信息表区域
            var master = null;

            var infoDialog = null;
            /* ************************** 变量定义结束 ******************************** */
            var nowDate = '${nowDate}';

            var table1;
            var table2;
            var table3;
            var click=[1,0,0];
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.initTable1();
                master.bindEvents();
            }
            /* *************************** 函数定义结束******************************* */

            retrieve = {
                $starTime: $('#star_time'),
                $endTime: $('#end_time'),
                init: function () {
                    this.$starTime.ligerDateEditor({format: "yyyy-MM-dd",showTime:false,initValue:nowDate});
                    this.$endTime.ligerDateEditor({format: "yyyy-MM-dd",showTime:false,initValue:nowDate});
                    $("#startDate").ligerDateEditor({format: "yyyy-MM-dd",showTime:false,initValue:nowDate});
                    $("#endDate").ligerDateEditor({format: "yyyy-MM-dd",showTime:false,initValue:nowDate});
                    $("#eventType").ligerComboBox({
                        valueField: 'code',
                        textField: 'value',
                        width: '180',
                        data:[{
                            code: '',
                            value: '全部'
                        },{
                            code: '1',
                            value: '住院'
                        },{
                            code: '0',
                            value: '门诊'
                        },{
                            code: '2',
                            value: '体检'
                        }]
                    });
                    $("#form1").show();
                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                }
            };
            master = {
                initTable1: function () {
                    table1 = $("#table1").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/qcReport/qualityMonitoringList',
                        // 传给服务器的ajax 参数
                        method:'get',
                        parms: {
                            start: $("#startDate").val(),
                            end: $("#endDate").val(),
                            eventType: $("#eventType").ligerGetComboBoxManager().getValue()
                        },
                       allowHideColumn:false,
                        columns: [
                            { display: 'orgCode',name: 'orgCode', width: '0.1%',isAllowHide: false,hide:true},
                            {display: '机构', name: 'orgName', width: '15%',align: 'left'},
                            { display: '医院数据', columns:
                                [
                                    { display: '档案数', name: 'hospitalArchives', align: 'right' },
                                    { display: '数据集', name: 'hospitalDataset', align: 'right' }
                                ]
                            },
                            { display: '接收', columns:
                                [
                                    { display: '档案数', name: 'receiveArchives', align: 'right' },
                                    { display: '数据集', name: 'receiveDataset', align: 'right' },
                                    { display: '质量异常数', name: 'receiveException', align: 'right' }
                                ]
                            },
                            { display: '资源化', columns:
                                [
                                    { display: '解析成功', name: 'resourceSuccess', align: 'right' },
                                    { display: '解析失败', name: 'resourceFailure', align: 'right' },
                                    { display: '解析异常', name: 'resourceException', align: 'right' }
                                ]
                            },
                            {
                                display: '操作', name: 'operator', minWidth: 120, render: function (row) {
                                    var html = '<a href="javascript:void(0)" target="_blank"  onclick="javascript:'
                                        + Util.format("$.publish('{0}',['{1}','{2}'])", "receive:detail:open",row.orgCode,row.orgName)
                                            + '">查看</a>';
                                    return html;
                                }
                            }
                        ],
                        enabledSort:false,
                        usePager:false,
                        checkbox : true
                    }));
                    table1.adjustToWidth();
                },
                initTable2: function () {
                    table2 = $("#table2").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/qcReport/receptionList',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        method:'get',
                        parms: {
                            startDate: retrieve.$starTime.val(),
                            endDate: retrieve.$endTime.val()
                        },
                        allowHideColumn:false,
                        columns: [
                            {display: '机构/部门', name: 'orgName', width: '15%',align: 'left'},
                            {display: '及时率',
                                columns:[
                                    {display: '就诊', name: 'visitIntimeRate', width: '9%', align: 'left'},
                                    {display: '门诊', name: 'outpatientInTimeRate', width: '9%'},
                                    {display: '住院', name: 'hospitalInTimeRate', width: '9%'},
                                    {display: '体检', name: 'peInTimeRate', width: '9%',align: 'left'}]
                            },
                            {display: '完整率',
                                columns:[
                                    {display: '就诊', name: 'visitIntegrityRate', width: '9%', align: 'left'},
                                    {display: '门诊', name: 'outpatientIntegrityRate', width: '9%'},
                                    {display: '住院', name: 'hospitalIntegrityRate', width: '9%'},
                                    {display: '体检', name: 'peIntegrityRate', width: '9%',align: 'left'}]
                            },
                            {
                                display: '操作', name: 'operator', minWidth: 120, render: function (row) {
                                var html = '<a href="javascript:void(0)" target="_blank" style="display: inline-block;height: 33px;padding: 0 10px;line-height: 40px;vertical-align: top;" onclick="javascript:'
                                    + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}','{5}','{6}','{7}'])", "receive:infoDialog:open",row.orgCode,row.orgName,row.visitIntime,row.visitIntegrity,row.totalVisit,row.visitIntimeRate,row.visitIntegrityRate)
                                    + '">查看</a>';
                                return html;
                            }
                            }
                        ],
                        enabledSort:false,
                        checkbox : true
                    }));
                    table1.adjustToWidth();
                },
                bindEvents: function () {
                    var self = this;
                    $("#btn_search1").click(function () {
                        table1.options.newPage = 1;
                        table1.loadData();
                    });
                    $("#btn_search2").click(function () {
                        table2.options.newPage = 1;
                        table2.loadData();
                    });
//                    点击tab 切换表格
                    $(".btn-group").on("click",".btn",function() {
                        var index = $(this).index();
                        $(".btn-group").find(".btn").removeClass("active");
                        $(this).addClass("active");
                        if(index==0){
                            $("#table1").show();
                            $("#form1").show();
                            $("#table2").hide();
                            $("#form2").hide();
                        }else {
                            $("#table1").hide();
                            $("#form1").hide();
                            $("#table2").show();
                            $("#form2").show();
                            if(click[1]==0) {
                                click[1] = 1;
                                master.initTable2();
                            }
                        }
                    });
                    $.subscribe('receive:infoDialog:open',function (event,orgCode,orgName,visitIntime,visitIntegrity,totalVisit,visitIntimeRate,visitIntegrityRate) {
                         var wait = parent._LIGERDIALOG.waitting('正在加载中...');
                         infoDialog = parent._LIGERDIALOG.open({
                            title:'接收详情',
                            height: 700,
                            width: 600,
                            url: '${contextRoot}/qcReport/initReceiveDetail',
                            load: true,
                            isDrag:true,
                            show:true,
                            urlParms: {
                                orgCode: orgCode,
                                orgName: orgName,
                                visitIntime: visitIntime,
                                visitIntegrity: visitIntegrity,
                                totalVisit: totalVisit,
                                visitIntimeRate: visitIntimeRate.substr(0,visitIntimeRate.length-1),
                                visitIntegrityRate: visitIntegrityRate.substr(0,visitIntegrityRate.length-1),
                                startDate: retrieve.$starTime.val(),
                                endDate: retrieve.$endTime.val()
                            },
                            isHidden: false,
                            onLoaded:function() {
                                wait.close();
                                infoDialog.show();
                            },
                            complete: function () {
                                wait.close();
                            }
                        });
                    });

                    $.subscribe('receive:detail:open',function(event,orgCode,orgName){
                        var wait = parent._LIGERDIALOG.waitting('正在加载中...');
                        infoDialog = parent._LIGERDIALOG.open({
                            title:orgName+"("+orgCode+")",
                            height:630,
                            width: 800,
                            url: '${contextRoot}/qcReport/detail',
                            urlParms: {
                                orgCode: orgCode,
                                startDate: $("#startDate").val(),
                                endDate: $("#endDate").val()
                            },
                            isHidden: false,
                            opener: true,
                            load:true,
                            isDrag:true,
                            show:false,
                            onLoaded:function() {
                                wait.close();
                                infoDialog.show();
                            },
                            complete: function () {
                                wait.close();
                            }
                        });
                    });
                }
            };

            /* ************************* Dialog页面回调接口 ************************** */
            win.parent.dialogRefresh = win.dialogRefresh = function () {
            };
            win.parent.dialogClose = function () {
                infoDialog.close();
            };
            /* ************************* Dialog页面回调接口结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* *************************** 页面初始化结束 **************************** */

        });
    })(jQuery, window);
</script>