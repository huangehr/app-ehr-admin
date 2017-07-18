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

            /* ************************** 变量定义结束 ******************************** */
            var isFirstPage = true;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }

            function reloadGrid (url, params,type) {
                if(type == 1){
                    masterOperator.init();
                    if (isFirstPage){
                        gridOperator.options.newPage = 1;
                    }
                    gridOperator.setOptions({parms: params});
                    gridOperator.loadData(true);
                }else{
                    master.init();
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
                    var typeData =  [{ id: 1, text: '网关日志' },{ id: 2, text: '业务日志'}];
                    $("#inp_type").ligerComboBox({ data: typeData});
                    this.$startTime.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                    this.$endTime.ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                }
            };

            master = {
                messageInfoDialog: null,
                addMessageInfoDialog:null,
                init: function () {
                    grid = $("#div_log_info_dialog").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/logManager/searchLogs',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        parms: {
                            caller: '',
                            type: '',
                            startTime: '',
                            endTime: ''
                        },
                        allowHideColumn:false,
                        columns: [
                            {display: '记录时间', name: 'time', width: '10%'},
                            {display: '用户ID', name: 'caller', width: '10%'},
                            {display: '响应Code', name: 'responseCode', width: '10%'},
                            {display: '响应时间', name: 'responseTime', width: '10%'},
                            {display: '响应结果', name: 'response', width: '60%'}
                        ],
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
                    reloadGrid.call(this, '${contextRoot}/logManager/searchLogs', values,type);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        grid.options.newPage = 1;
                        master.reloadGrid();
                    });
                }
            };


            masterOperator = {
                messageInfoDialog: null,
                addMessageInfoDialog:null,
                init: function () {
                    gridOperator = $("#div_log_info_dialog").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/logManager/searchLogs',
                        // 传给服务器的ajax 参数
                        pageSize:20,
                        parms: {
                            caller: '',
                            type: '',
                            startTime: '',
                            endTime: ''
                        },
                        allowHideColumn:false,
                        columns: [
                            {display: '记录时间', name: 'time', width: '20%'},
                            {display: '用户ID', name: 'caller', width: '20%'},
                            {display: '响应Code', name: 'responseCode', width: '10%'},
                            {display: '响应时间', name: 'responseTime', width: '10%'},
                            {display: '响应结果', name: 'response', width: '60%'}
//                            {display: '数据', name: 'params', width: '60%'}
                        ],
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
                    reloadGrid.call(this, '${contextRoot}/logManager/searchLogs', values,type);
                },
                bindEvents: function () {
                    var self = this;
                    retrieve.$searchBtn.click(function () {
                        gridOperator.options.newPage = 1;
                        masterOperator.reloadGrid();
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

            /* ************************* Dialog页面回调接口结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* *************************** 页面初始化结束 **************************** */

        });
    })(jQuery, window);
</script>