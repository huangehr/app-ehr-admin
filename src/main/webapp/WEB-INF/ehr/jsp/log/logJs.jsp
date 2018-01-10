<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;

            // 画面日志信息表对象
            var grid = null;
            var gridOperator = null;

            // 页面表格条件部模块
            var retrieve = null;

            // 页面主模块，对应于日志信息表区域
            var master = null;
            var masterOperator = null;


            var logInfo = null;

            /* ************************** 变量定义结束 ******************************** */
            var isFirstPage = true;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                masterOperator.init();
                master.init();
            }

            function reloadGrid (url, params,type) {
                debugger
                if(type == 1){
//                    masterOperator.init();
                    if (isFirstPage){
                        gridOperator.options.newPage = 1;
                    }
                    gridOperator.setOptions({parms: params});
                    gridOperator.loadData(true);
                }else{
//                    master.init();
                    if (isFirstPage){
                        grid.options.newPage = 1;
                    }
                    grid.setOptions({parms: params});
                    grid.loadData(true);
                }
                isFirstPage = true;
            }
            /* *************************** 函数定义结束******************************* */

            retrieve = {
                $element: $(".m-retrieve-area"),
                $searchBtn: $('#btn_search'),
                $searchlog: $("#inp_search"),
                $startTime:$('#inp_start_time'),
                $endTime:$('#inp_end_time'),

                init: function () {
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                    this.$searchlog.ligerTextBox({width: 240 });
                    $('#inp_caller').ligerTextBox({width: 240 });
                    var typeData =  [{ id: 1, text: '网关日志' },{ id: 2, text: '业务日志'}];
                    $("#inp_type").ligerComboBox({ data: typeData,value:'2'});
                    this.$startTime.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                    this.$endTime.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                }
            };

            function openWin(id, type) {
                var title = "日志详情";
                var wait = parent._LIGERDIALOG.waitting("请稍后...");
                logInfo = parent._LIGERDIALOG.open({
                    height:550,
                    width:500,
                    title:title,
                    url:'${contextRoot}/logManager/getLogByIdAndType',
                    urlParms:{
                        logId: id,
                        type: type
                    },
                    load:true,
                    show:false,
                    isHidden:false,
                    onLoaded:function(){
                        wait.close(),
                                logInfo.show()
                    }
                });
                logInfo.hide();
            }
            
            master = {
                messageInfoDialog: null,
                addMessageInfoDialog:null,
                init: function () {
                    grid = $("#div_log_info_dialog").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/logManager/searchListLogs',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        parms: {
                            patient: '',
                            type:$("#inp_type_val").val(),
                            startTime: '',
                            endTime: ''
                        },
                        allowHideColumn:false,
                        columns: [
                            {display: '系统名称', name: 'appKey', width: '15%'},
                            {display: '菜单名称', name: 'function', width: '20%'},
                            {display: '功能名称', name: 'operation', width: '15%'},
                            {display: '操作者', name: 'patient', width: '10%'},
                            {display: '操作时间', name: 'time', width: '15%'},
                            {display: '响应Code', name: 'responseCode', width: '15%'},
                            {display: '操作', name: 'response', minWidth: 100,render: function (row) {
                                var html = '<a class="label_a" title="查看详情" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "log:info:show", row.code, row.logType) + '">查看详情</a>';
                                return html;
                            }}
                        ],
                        onDblClickRow: function (d) {
//                            openWin(d.id, d.logType);
                        },
                        enabledEdit: true,
                        validate: true,
                        unSetValidateAttr: false
                    }));
                    grid.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function () {
                    var values = retrieve.$element.Fields.getValues();
                    retrieve.$element.attrScan();
                    var type = $("#inp_type_val").val();
                    reloadGrid.call(this, '${contextRoot}/logManager/searchListLogs', {
                        patient: $('#inp_caller').val(),
                        type:$("#inp_type_val").val(),
                        startTime: $('#inp_start_time').val(),
                        endTime: $('#inp_end_time').val()
                    },type);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        grid.options.newPage = 1;
                        master.reloadGrid();
                    });
                    $.subscribe("log:info:show",function(event, id, type){
                        openWin(id, type);
                    });
                }
            };


            masterOperator = {
                messageInfoDialog: null,
                addMessageInfoDialog:null,
                init: function () {
                    gridOperator = $("#div_log_info_dialog").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/logManager/searchListLogs',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        parms: {
                            patient: '',
                            type: '',
                            startTime: '',
                            endTime: ''
                        },
                        allowHideColumn:false,
                        columns: [
                            {display: '系统名称', name: 'appKey', width: '15%'},
                            {display: '菜单名称', name: 'function', width: '20%'},
                            {display: '功能名称', name: 'operation', width: '15%'},
                            {display: '操作者', name: 'patient', width: '10%'},
                            {display: '操作时间', name: 'time', width: '15%'},
                            {display: '响应Code', name: 'responseCode', width: '15%'},
                            {display: '操作', name: 'response', width: '10%',render: function (row) {
                                var html = '<a class="label_a" title="查看详情" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "log:info:show", row.id, row.logType) + '">查看详情</a>';
                                return html;
                            }}
                        ],
                        onDblClickRow: function (d) {
//                            openWin(d.id, d.logType);
                        },
                        enabledEdit: true,
                        validate: true,
                        unSetValidateAttr: false
                    }));
                    gridOperator.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function () {
                    var values = retrieve.$element.Fields.getValues();
                    retrieve.$element.attrScan();
                    var type = $("#inp_type_val").val();
                    reloadGrid.call(this, '${contextRoot}/logManager/searchListLogs',  {
                        patient: $('#inp_caller').val(),
                        type:$("#inp_type_val").val(),
                        startTime: $('#inp_start_time').val(),
                        endTime: $('#inp_end_time').val()
                    },type);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        gridOperator.options.newPage = 1;
                        masterOperator.reloadGrid();
                    });

                    $.subscribe("log:info:show",function(event, id, type){
                        openWin(id, type);
                    });
                }
            };


            /* ************************* Dialog页面回调接口 ************************** */
            win.reloadMasterUpdateGrid = function () {
                master.reloadGrid();
            };

            win.reloadMasterOperatorUpdateGrid = function () {
                masterOperator.reloadGrid();
            };

            win.closelogInfo = function () {
                logInfo.close();
            }
            /* ************************* Dialog页面回调接口结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* *************************** 页面初始化结束 **************************** */

        });
    })(jQuery, window);
</script>