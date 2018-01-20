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
            var dictId = 36;
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
                $searchCardNo: $('#inp_cardNo'),
                $searchName: $('#inp_name'),
                $searchAuditStatus: $('#ipt_auditStatus'),
                $searchBtn: $('#btn_search'),
                $addBtn: $('#btn_add'),

                init: function () {
                    this.initDDL(dictId, $('#ipt_auditStatus'));
					this.$searchCardNo.ligerTextBox({width: 140});
                    this.$searchName.ligerTextBox({width: 140});

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
                    this.grid = $("#div_userCards_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/userCards/searchUserCards',
                        parms: {
                            cardNo: '',
                            name: '',
                            auditStatus: '',
                        },
                        columns: [
							{ display: '卡号',name: 'cardNo', width: '10%',isAllowHide: false},
                            { display: '卡类别',name: 'cardTypeName', width: '8%',isAllowHide: false},
                            { display: '持卡人姓名', name: 'ownerName', width: '8%', minColumnWidth: 60,},
                            { display: '持卡人手机', name: 'ownerPhone', width: '10%', minColumnWidth: 60,},
                            { display: '发卡机构', name: 'releaseOrg', width: '10%', minColumnWidth: 60,},
                            { display: '发卡时间', name: 'releaseDate',width: '8%', align:'left' },
                            { display: '创建时间', name: 'createDate',width: '8%',align:'left'},
//                            { display: '有效期起始时间', name: 'validityDateBegin',width: '8%',align:'left'},
//                            { display: '有效期截止时间', name: 'validityDateEnd',width: '8%', align:'left' },
                            { display: '描述', name: 'description',width: '14%', align:'left' },
                            { display: '审核状态', name: 'auditStatus',width: '8%',render:function(row){
                                if (Util.isStrEquals(row.auditStatus,'0')) {
                                    return '未审核';
                                } else if (Util.isStrEquals(row.auditStatus,'1')) {
                                    return '已通过';
                                }else if (Util.isStrEquals(row.auditStatus,'2')) {
                                    return '已拒绝';
                                }else{
                                    return '未审核';
                                }
                            }
                            },
                            { display: '状态', name: 'status',width: '8%',render:function(row){
                                if (Util.isStrEquals(row.status,'1')) {
                                    return '有效';
                                } else {
                                    return '无效';
                                }
                            }
                            },
                            {display: '操作', name: 'operator', width: '8%', render: function (row) {
                                var html = '';
                                if(row.auditStatus == "0"){
                                    html += '<sec:authorize url="/userCards/agree"><a class="label_a" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "userCards:info:open", row.id ,1) + '">审核</a></sec:authorize>';
                                }else{
                                    html = '<sec:authorize url="/userCards/getUserDetail"><a class="label_a" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "userCards:info:open", row.id,2) + '">详情</a></sec:authorize>';
                                }
                                return html;
                            }}
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

                reloadGrid: function (curPage) {
                    var values = retrieve.$element.Fields.getValues();
					reloadGrid.call(this, values);
                },

                bindEvents: function () {
					//检索按钮
					retrieve.$searchBtn.click(function () {
						master.reloadGrid();
					});
					//新增按钮
					retrieve.$addBtn.click(function(){
						$.publish("userCards:userCardsInfo:open",['','new']);
					});
					//新增
                    $.subscribe('userCards:userCardsInfo:open',function(event,userCardsId,mode){
						isFirstPage = false;
                        var title = '';
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        if(mode == 'modify'){title = '修改就诊卡信息';};
						if(mode == 'new'){title = '新增用户就诊卡认证信息';};
                        master.userCardsInfoDialog = parent._LIGERDIALOG.open({
                            height:540,
                            width: 550,
                            title : title,
                            isHidden: false,
                            opener: true,
							load:true,
							show: false,
                            url: '${contextRoot}/userCards/infoInitial',
                            urlParms: {
                                id: userCardsId,
                                mode:mode
                            },
                            onLoaded:function() {
                                wait.close(),
                                master.userCardsInfoDialog.show()
                            }
                        });
                        master.userCardsInfoDialog.hide();
                    });

					//查看详情
                    $.subscribe('userCards:info:open',function(event,userCardsId,auditStatus){
                        isFirstPage = false;
                        var title = '用户认证详情';
                        var height = 400;
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        if(auditStatus == '0'){title = '用户认证审核';};
                        if(auditStatus == '1'){height=640;};
                        console.log(auditStatus);
                        master.userCardsInfoDialog = parent._LIGERDIALOG.open({
                            height:height,
                            width: 950,
                            title : title,
                            url: '${contextRoot}/userCards/getUserDetail',
                            urlParms: {
                                id: userCardsId,
                                auditStatus:auditStatus
                            },
                            isHidden: false,
                            opener: true,
                            load:true,
							show: false,
                            onLoaded:function() {
                                wait.close(),
                                master.userCardsInfoDialog.show()
                            }
                        });
                        master.userCardsInfoDialog.hide();
                    });

                },
            };
            /* ******************Dialog页面回调接口****************************** */
            win.parent.reloadMasterGrid = win.reloadMasterGrid = function () {
                master.reloadGrid();
            };
            win.parent.closeDialog = function (callback) {
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