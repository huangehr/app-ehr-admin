<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;

            var grid = null;

            // 页面表格条件部模块
            var retrieve = null;

            // 页面主模块，对应于用户信息表区域
            var master = null;
            /* ************************** 变量定义结束 ******************************** */
            var nowDate = '${nowDate}';
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }

            function reloadGrid (url, params) {
//                grid.set({
//                    url: url,
//                    parms: params
////                    newPage:1
//                });
//                grid.reload();
                grid.setOptions({parms: params});
                grid.loadData(true);
            }
            /* *************************** 函数定义结束******************************* */

            retrieve = {
                $element: $(".m-retrieve-area"),
                $searchBtn: $('#btn_search'),
                $starTime: $('#star_time'),
                $endTime: $('#end_time'),
                init: function () {
                    this.$element.show();
                    this.$starTime.ligerDateEditor({format: "yyyy-MM-dd",showTime:false,initValue:nowDate});
                    this.$endTime.ligerDateEditor({format: "yyyy-MM-dd",showTime:false,initValue:nowDate});

                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                }
            };
            master = {
                resourceGrid:null,
                dialog : null,
                init: function () {
                    var self = this;
                    self.resourceGrid =grid = $("#div_platform_receive_info_grid").ligerGrid($.LigerGridEx.config({
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
                    self.resourceGrid.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function () {
                    //var values = retrieve.$element.Fields.getValues();

                    retrieve.$element.attrScan();
                    var values ={
                        startDate: retrieve.$starTime.val(),
                        endDate: retrieve.$endTime.val()
                    };
                    reloadGrid.call(this, '${contextRoot}/qcReport/receptionList', values);              },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        grid.options.newPage = 1;
                        master.reloadGrid();
                    });
//                    点击tab 切换表格
                    $(".btn-group").on("click",".btn",function() {
                        var index = $(this).index();
                        $(".btn-group").find(".btn").removeClass("active");
                        $(this).addClass("active");
                        if(index==0){
                            retrieve.$element.show();
                            $("#div_patient_info_grid").show();
                            $("#div_unknowarchives_info_grid").hide();
                            self.KnownPatientGrid.reload();
                        }else {
                            retrieve.$element.hide();
                            $("#div_patient_info_grid").hide();
                            $("#div_unknowarchives_info_grid").show();
                            self.UnknowArchivesGrid.reload();
                        }
                    });
                    $.subscribe('receive:infoDialog:open',function (event,orgCode,orgName,visitIntime,visitIntegrity,totalVisit,visitIntimeRate,visitIntegrityRate) {
//                        var wait = parent._LIGERDIALOG.waitting('正在加载中...');
                        master.dialog = parent._LIGERDIALOG.open({
                            title:'接收详情',
                            height: 700,
                            width: 600,
                            url: '${contextRoot}/qcReport/initReceiveDetail',
                            isHidden: false,
                            opener: true,
                            load:true,
                            isDrag:true,
                            show:false,
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
                            onLoaded:function() {
//                                wait.close();
//                                master.dialog.show();
                            }
                        });
                    })
                }
            };

            /* ************************* Dialog页面回调接口 ************************** */
            win.parent.dialogRefresh = win.dialogRefresh = function () {
                master.reloadGrid();
            };
            win.parent.dialogClose = function () {
                debugger
                master.dialog.close();
                master.reloadGrid();
            };
            /* ************************* Dialog页面回调接口结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* *************************** 页面初始化结束 **************************** */

        });
    })(jQuery, window);
</script>