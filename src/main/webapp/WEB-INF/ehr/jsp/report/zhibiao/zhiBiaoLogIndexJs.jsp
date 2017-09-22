<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var dictMaster = null;
            // 页面表格条件部模块
            var patientRetrieve = null;
            var quotaCode = '${quotaCode}';

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                patientRetrieve.init();
                dictMaster.init();
            }

            patientRetrieve = {
                $element: $(".m-retrieve-area"),
                $searchBtn: $('#btn_search'),
                $starTime: $('#inp_start_time'),
                $endTime: $('#inp_end_time'),
                init: function () {
                    this.$element.show();
                    this.$starTime.ligerDateEditor({format: "yyyy-MM-dd hh:mm:ss",showTime:true});
                    this.$endTime.ligerDateEditor({format: "yyyy-MM-dd hh:mm:ss",showTime:true});

                    this.bindEvents();
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                },
                bindEvents: function () {
                    var self = this;
                }

            };

            /* *************************** 标准字典模块初始化 ***************************** */
            dictMaster = {
                dictInfoDialog: null,
                detailDialog:null,
                grid: null,
                init: function () {
                    var self = this;
                    if (this.grid) {
                        this.reloadGrid(1);
                    }else {
                        this.grid = $("#div_quotaLog_grid").ligerGrid($.LigerGridEx.config({
                            url:  '${contextRoot}/tjQuota/queryQuotaLog',
                            parms: {
                                quotaCode: quotaCode,
                                startTime: '',
                                endTime: ''
                            },
                            columns: [
//                                {display: '区域代码', name: 'saasId', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '指标编码', name: 'quotaCode', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '开始执行时间', name: 'startTime', width: '15%', isAllowHide: false, align: 'left'},
                                {display: '结束时间', name: 'endTime', width: '15%', isAllowHide: false, align: 'left'},
                                {display: '任务执行情况', name: 'content', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '结果', name: 'statusName', width: '10%', isAllowHide: false, align: 'left'}
                            ],
                            validate: true,
                            unSetValidateAttr: false,
                            allowHideColumn: false,

                        }));
                        this.bindEvents();
                        // 自适应宽度
                        this.grid.adjustToWidth();
                    }
                },
                reloadGrid: function () {
                    patientRetrieve.$element.attrScan();
                    var values = patientRetrieve.$element.Fields.getValues();
                    Util.reloadGrid.call(this.grid, '${contextRoot}/tjQuota/queryQuotaLog', values);
                },
                bindEvents: function () {
                    var self = this;
                    patientRetrieve.$searchBtn.click(function () {
                        dictMaster.grid.options.newPage = 1;
                        dictMaster.reloadGrid();
                    });

                }
            };

            /* ******************Dialog页面回调接口****************************** */
            win.reloadMasterGrid = function () {
                dictMaster.reloadGrid();
            };
            win.closeDialog = function (type, msg) {
                dictMaster.dictInfoDialog.close();
                if (msg)
                    $.Notice.success(msg);
            };
            win.closeZhiBiaoInfoDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    dictMaster.reloadGrid();
                }
                dictMaster.dictInfoDialog.close();
            };

            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>