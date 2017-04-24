<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>


<script>

    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            var dictId = 65;
			var isFirstPage = true;

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }
			function reloadGrid (params) {
				if (isFirstPage){
					this.grid.options.newPage = 1;
				}
				this.grid.setOptions({parms: params});
				this.grid.loadData(true);
				isFirstPage = true;
			}

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchOrg: $('#inp_org'),
                $searchProfileId: $('#inp_profileId'),
                $searchName: $('#inp_name'),
                $searchStatus: $('#ipt_status'),
                $searchBtn: $('#btn_search'),
                $addBtn: $('#btn_add'),

                init: function () {
                    this.initDDL(dictId, $('#ipt_status'));
					this.$searchProfileId.ligerTextBox({width: 140});
                    this.$searchName.ligerTextBox({width: 140});
                    this.$searchOrg.ligerTextBox({width: 170});

                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                },

                initDDL: function (dictId, target) {
                    var target = $(target);
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/dict/searchDictEntryList", {
                        data: {dictId: dictId},
                        success: function (data) {
                            target.ligerComboBox({
                                valueField: 'code',
                                textField: 'value',
                                width: '100',
                                data: [].concat(data.detailModelList)
                            });
                        }
                    });
                }
            };

            master = {
                userCardsInfoDialog: null,
                grid: null,
                init: function () {
                    this.grid = $("#div_archiveRelative_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/userCards/searchArchiveRelation',
                        parms: {
                            orgIdOrOrgName: '',
                            nameOrIdCard: '',
                            profileId:'',
                            status: '',
                            page:1,
                            rows:15
                        },
                        columns: [
                            { display: '机构编码',name: 'orgCode', width: '8%',isAllowHide: false},
                            { display: '机构名称',name: 'orgName', width: '8%',isAllowHide: false},
                            { display: '姓名', name: 'name', width: '5%', minColumnWidth: 60,},
                            { display: '身份证号码', name: 'idCardNo', width: '12%', minColumnWidth: 60,},
                            { display: '就诊卡类别',name: 'cardTypeName', width: '5%',isAllowHide: false},
                            { display: '卡号',name: 'cardNo', width: '8%',isAllowHide: false},
                            { display: '就诊事件号',name: 'eventNo', width: '8%',isAllowHide: false},
                            { display: '就诊时间',name: 'eventDate', width: '8%',isAllowHide: false},
                            { display: '就诊类型', name: 'eventType',width: '5%',render:function(row){
                                if (Util.isStrEquals(row.eventType,'0')) {
                                    return '门诊';
                                } else if (Util.isStrEquals(row.eventType,'1')) {
                                    return '住院';
                                }else if (Util.isStrEquals(row.eventType,'2')) {
                                    return '体检';
                                }else{
                                    return '未审核';
                                }
                            }
                            },
                            { display: '关联档案号', name: 'profileId',width: '8%', align:'left' },
                            { display: '关联档案ID', name: 'applyId',width: '8%', align:'left' },
                            { display: '关联状态', name: 'status',width: '8%',render:function(row){
                                if (Util.isStrEquals(row.status,'0')) {
                                    return '未关联';
                                } else {
                                    return '已关联';
                                }
                            }
                            }
                        ],
						pageSize:20,
						enabledSort:true,
                        enabledEdit: true,
                        validate : true,
                        unSetValidateAttr:false,
                        allowHideColumn: false

                    }));

                    this.bindEvents();
                    this.grid.adjustToWidth();
                },

                reloadGrid: function () {
                    var values = retrieve.$element.Fields.getValues();
					reloadGrid.call(this, values);
                },

                bindEvents: function () {
					//检索按钮
					retrieve.$searchBtn.click(function () {
						master.reloadGrid();
					});

                },
            };
            /* ******************Dialog页面回调接口****************************** */
            win.reloadMasterGrid = function () {
                master.reloadGrid();
            };
            win.closeDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    master.reloadGrid();
                }
                master.userCardsInfoDialog.close();
            };
            /* *************************** 页面功能 **************************** */
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);

</script>