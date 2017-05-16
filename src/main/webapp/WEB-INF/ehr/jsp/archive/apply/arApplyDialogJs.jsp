<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<script type="text/javascript">
    (function ($, win) {
        var Util = $.Util;
        var objectForm = null;
        var archiveGrid = null;
        var master = null;
        var mode = eval("(" + '${mode}' + ")");
        var name = mode.name;
        var idCardNo = mode.idCard;
        var cardNo = mode.cardNo;
        var id = mode.id;

        //多条件查询参数设置
        function reloadGrid (params) {
            if (isFirstPage){
                archiveGrid.options.newPage = 1;
            }
            archiveGrid.set({
                parms: params
            });
            archiveGrid.reload();
            isFirstPage = true;
        }

        function pageInit() {
            objectForm.init();
            master.init();
        }

        objectForm = {
            $btnAudit: $("#btn_audit"),
            $btnFefuse: $("#btn_refuse"),
            $btnHelp: $("#btn_help"),
            $applyUserName: $("#inp_name"),
            $applyIdCard: $("#inp_idCard"),
            $applyAnalyseTime: $("#inp_apply_analyse_time"),
            $applyAnalyseOrg: $("#inp_apply_analyse_org"),
            $applyAnalyseDoctor: $("#inp_apply_analyse_doctor"),
            $applyCardNmuber: $("#inp_apply_card_nmuber"),
            $applyAnalyseOut: $("#inp_apply_analyse_out"),
            $applyExaminePro: $("#inp_apply_examine_pro"),
            $applyAnalyseDrug: $("#inp_apply_analyse_drug"),
            $applyRemark: $("#inp_apply_remark"),
            $auditReason:$("#inp_apply_reason"),
            $form:$("#div_std_info_form"),


            init: function () {
                objectForm.$applyUserName.ligerTextBox({width: 150, height: 25});
                objectForm.$applyIdCard.ligerTextBox({width: 150, height: 25});
                objectForm.$applyCardNmuber.ligerTextBox({width: 150, height: 25});

                objectForm.$applyAnalyseTime.ligerTextBox({width: 150, height: 25});
                objectForm.$applyAnalyseOrg.ligerTextBox({width: 150, height: 25});
                objectForm.$applyAnalyseDoctor.ligerTextBox({width: 150, height: 25});

                objectForm.$applyAnalyseOut.ligerTextBox({width: 650, height: 25});

                objectForm.$applyExaminePro.ligerTextBox({width: 650, height: 25});
                objectForm.$applyAnalyseDrug.ligerTextBox({width: 650, height: 25});

                objectForm.$applyRemark.ligerTextBox({width: 650, height: 25});
                objectForm.$auditReason.ligerTextBox({width: 650, height: 75});
                this.bindEvents();
                this.$form.attrScan();
                if(mode.auditReason==null||mode.auditReason==""){
                    mode.auditReason="找不到对应的档案列表！";
                }
                objectForm.$form.Fields.fillValues({
                    name:mode.name,
                    idCard:mode.idCard,
                    visDate:mode.visDate,
                    visOrg:mode.visOrg,
                    visDoctor:mode.visDoctor,
                    cardNo:mode.cardNo,
                    diagnosedResult:mode.diagnosedResult,
                    diagnosedProject:mode.diagnosedProject,
                    medicines:mode.medicines,
                    memo:mode.memo,
                    auditReason:mode.auditReason
                });

            },
            bindEvents: function () {
                this.$btnAudit.click(function () {
                    var reason = $("#inp_apply_reason").val();
                    var rows = master.grid.getSelectedRows();
                    if (rows.length == 0) {
                        $.Notice.warn('请在下方勾选要关联的数据行！');
                        return;
                    }
                    var archiveRelationIds = '';
                    for (var i = 0; i < rows.length; i++) {
                        archiveRelationIds += ',' + rows[i].id;
                    }
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/archive/apply/arApplyAudit", {
                        data:{
                            applyId:id,
                            status:1,
                            auditReason:reason,
                            archiveRelationIds:archiveRelationIds
                        },
                        success: function(data) {
                            if (data.successFlg) {
                                $.Notice.success('审核成功');
                                win.closeDialog();
                                win.reloadMasterGrid();
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    });
                });
                this.$btnFefuse.click(function () {
                    var reason = $("#inp_apply_reason").val();
                    if(reason=='' || reason==undefined){
                        $.Notice.error('理由不能为空');
                        return;
                    }
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/archive/apply/arApplyAudit", {
                        data:{
                            applyId:id,
                            status:2,
                            auditReason:reason,
                            archiveRelationIds:''
                        },
                        success: function(data) {
                            if (data.successFlg) {
                                $.Notice.success('审核成功');
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

        master = {
            userCardsRelativeDialog: null,
            grid: null,
            init: function () {
                this.grid = $("#div_archive_audit_grid").ligerGrid($.LigerGridEx.config({
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
                    enabledSort:true,
                    enabledEdit: true,
                    validate : true,
                    checkbox: true,
                    unSetValidateAttr:false,
                    allowHideColumn: false

                }));
                this.grid.adjustToWidth();
                this.bindEvents();
            },

            reloadGrid: function () {
                var values = retrieve.$element.Fields.getValues();
                reloadGrid.call(this, values);
            },

            bindEvents: function () {

            }


        };


        pageInit();

    })(jQuery, window);
</script>