<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var userCardInfo = null;
        var master = null;
        var isFirstPage = true;
        var name='${userCards.ownerName}';
        var idCardNo='${userCards.ownerIdcard}';
        var cardNo ='${userCards.cardNo}';
        var auditStatus ='${userCards.auditStatus}';
        var relativeCount = 0;
        var reasonTxt='';


		/* *************************** 函数定义 ******************************* */
        function pageInit() {
            userCardInfo.init();
            if(auditStatus=='0'){
                master.init();
            }
            $("#btn_relative").hide();
        }
        /* *************************** 模块初始化 ***************************** */
        userCardInfo = {
			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),
            $btnRelative: $("#btn_relative"),
            $audit: $("#audit"),
            $reason: $("#reason"),

            init: function () {
                this.initDDL(68, $('#audit'));
                this.initDDL(69, $('#reason'));
                this.bindEvents();
            },

            initDDL: function (dictId, target) {
                var width = '100';
                if(dictId==69){
                    width = '200';
                }
                var target = $(target);
                var dataModel = $.DataModel.init();
                dataModel.fetchRemote("${contextRoot}/dict/searchDictEntryList", {
                    data: {dictId: dictId},
                    success: function (data) {
                        target.ligerComboBox({
                            valueField: 'code',
                            textField: 'value',
                            width: width,
                            data: [].concat(data.detailModelList)
                        });
                    }
                });
            },

            bindEvents: function () {
                var self = this;
                $("#audit").change(function(){
                    var auditVal = $("#audit_val").val();
                    if(auditVal==2){
                        $("#refuseReasonGroup").css('display','block');
                    }
                    if(auditVal==1){
                        $("#refuseReasonGroup").css('display','none');
                    }
                });

                this.$btnSave.click(function () {
                    var id = $("#id").val();
                    var auditVal = $("#audit_val").val();
                    var reasonVal = $("#reason_val").val();
                    var otherResonVal = $("#otherReason").val();
                    reasonTxt = otherResonVal;
                    if(auditVal=='' || auditVal==undefined){
                        $.Notice.error('审核不能为空');
                        return;
                    }else if(auditVal=='2'){
                        if(reasonVal==''){
                            $.Notice.error('拒绝原因不能为空');
                            return;
                        }else if(reasonVal=='0'){
                            if(otherResonVal=='' || otherResonVal==undefined){
                                $.Notice.error('原因不能为空');
                                return;
                            }
                        }else{
                            reasonTxt = $("#reason").val();
                        }
                    }
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/userCards/audit", {
                        data:{
                            id:id,
                            auditStatus:auditVal,
                            reason:reasonTxt
                        },
                        success: function(data) {
                            if (data.successFlg) {
                                $.Notice.success('审核成功');
                                $("#btn_save").hide();
                                if(auditVal=='1'){
                                    $("#btn_relative").show();
                                }
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    });


                });

                this.$btnCancel.click(function () {
                    win.closeDialog();
                });


            }

        };


        master = {
            $btnRelative: $("#btn_relative"),
            userCardsRelativeDialog: null,
            grid: null,
            init: function () {
                this.grid = $("#div_userCardsRelative_info_grid").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/archive/apply/getArRelaListForAudit',
                    parms: {
                        name: name,
                        idCardNo: idCardNo,
                        cardNo: cardNo
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
                    width:900,
                    enabledSort:true,
                    enabledEdit: true,
                    validate : true,
                    checkbox: true,
                    unSetValidateAttr:false,
                    allowHideColumn: false

                }));
                this.grid.adjustToWidth();
                this.bindEvents();
                relativeCount = this.grid.rows.length;
                console.log(relativeCount);
            },

            reloadGrid: function () {
                var values = retrieve.$element.Fields.getValues();
                reloadGrid.call(this, values);
            },

            bindEvents: function () {

                this.$btnRelative.click(function(){
                    var id =  $("#id").val();
                    var rows = master.grid.getSelectedRows();
                    if (rows.length == 0) {
                        $.Notice.warn('请选择要关联的数据行！');
                        return;
                    }
                    var archiveRelationIds = '';
                    for (var i = 0; i < rows.length; i++) {
                        archiveRelationIds += ',' + rows[i].id;
                    }
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/userCards/archiveSave", {
                        data:{
                            id:id,
                            archiveRelationIds:archiveRelationIds.substr(1)
                        },
                        success: function(data) {
                            if (data.successFlg) {
                                $.Notice.success('关联成功');
                                win.closeDialog();
                                win.reloadMasterGrid();
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    });
                });
            }


        };


        /* *************************** 页面初始化 **************************** */
        pageInit();

    })(jQuery, window);
</script>