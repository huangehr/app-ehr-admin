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
            var id = ${id};
            var slaveKey1Name ='${slaveKey1Name}';
            var slaveKey2Name ='${slaveKey2Name}';
            var slaveKey3Name ='${slaveKey3Name}';

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                patientRetrieve.init();
                dictMaster.init();
            }

            patientRetrieve = {
                $element: $(".m-retrieve-area"),
                $searchBtn: $('#btn_search'),
                $orgName: $('#inp_org_name'),
                $location: $("#inp_location"),
                $starTime: $('#inp_start_time'),
                $endTime: $('#inp_end_time'),
                init: function () {
                    this.$element.show();
                    this.$starTime.ligerDateEditor({format: "yyyy-MM-dd",showTime:true});
                    this.$endTime.ligerDateEditor({format: "yyyy-MM-dd",showTime:true});

                    this.$location.addressDropdown({tabsData:[
                        {name: '省份',code:'id',value:'name', url: '${contextRoot}/address/getParent', params: {level:'1'}},
                        {name: '城市',code:'id',value:'name', url: '${contextRoot}/address/getChildByParent'},
                        {name: '县区',code:'id',value:'name', url: '${contextRoot}/address/getChildByParent'}
                    ]});
                    this.$orgName.ligerTextBox({width: 140 });
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
                        this.grid = $("#div_quotaResult_grid").ligerGrid($.LigerGridEx.config({
                            url:  '${contextRoot}/tjQuota/selectQuotaResult',
                            parms: {
                                tjQuotaId: id,
                                orgName: '',
                                location: '',
                                startTime: '',
                                endTime: ''
                            },
                            columns: [
                                {display: '指标编码', name: 'quotaCode', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '统计时间', name: 'quotaDate', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '省份', name: 'provinceName', width: '5%', isAllowHide: false, align: 'left'},
                                {display: '城市', name: 'cityName', width: '5%', isAllowHide: false, align: 'left'},
                                {display: '区县', name: 'townName', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '机构名称', name: 'orgName', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '团队名称', name: 'teamName', width: '10%', isAllowHide: false, align: 'left'},
                                {display: slaveKey1Name, name: 'slaveKey1Name', width: '10%', hide: (!!!slaveKey1Name), align: 'left'},
                                {display: slaveKey2Name, name: 'slaveKey2Name', width: '10%', hide: (!!!slaveKey2Name), align: 'left'},
                                {display: slaveKey3Name, name: 'slaveKey3Name', width: '10%', hide: (!!!slaveKey3Name), align: 'left'},
                                {display: '结果', name: 'result', width: '10%', isAllowHide: false, align: 'left'}
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
                reloadGrid: function (curPage) {
                    patientRetrieve.$element.attrScan();
//                    var values = patientRetrieve.$element.Fields.getValues();
                    var address = patientRetrieve.$element.Fields.location.getValue();
                    var values = $.extend({}, patientRetrieve.$element.Fields.getValues(),
                            {province: (address.names[0] == null ? '' : address.names[0])},
                            {city: (address.names[1] == null ? '' : address.names[1])},
                            {district: (address.names[2] == null ? '' : address.names[2])});
                    Util.reloadGrid.call(this.grid, '${contextRoot}/tjQuota/selectQuotaResult', values, curPage);
                },
                bindEvents: function () {
                    var self = this;
                    patientRetrieve.$searchBtn.click(function () {
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
