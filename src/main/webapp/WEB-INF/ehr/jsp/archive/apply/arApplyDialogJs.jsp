<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
    (function ($, win) {
        var objectForm = null;
        var archiveGrid = null;

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
            objectForm.searchList();
        }
        var mode = eval("(" + '${mode}' + ")");
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
            $arRelaList:$("#div_archive_audit_grid"),
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
            searchList: function () {
                var values =  objectForm.$form.Fields.getValues();
                archiveGrid = $("#div_correlation_audit_grid").ligerGrid($.LigerGridEx.config({
                    url: '${contextRoot}/archive/apply/getArRelaListForAudit',
                    parms:{
                        "name": values.name,
                        "idCardNo": values.idCardNo,
                        "cardNo": values.cardNo
                    },
                    columns: [
                        {display: '审核状态', name: 'statusName', width: '10%', resizable: true,align: 'left'},
                        {display: '姓名', name: 'name', width: '10%',align: 'left'},
                        {display: '身份证号', name: 'idCardNo', width: '15%'},
                        {display: '就诊卡号', name: 'cardNo', width: '15%', resizable: true,align: 'left'},
                        {display: '就诊时间', name: 'eventDate', width: '15%', resizable: true,align: 'left'},
                        {display: '机构名称', name: 'orgName', width: '25%', resizable: true,align: 'left'},
                        {display: '', name: 'id', hide: true},
                        {display: '操作',name: 'operator', width:'10%', align:'center',render: function (row) {
                            var html="";
                            if(row.status==0){
                                html = '<sec:authorize url="/correlation/validateAudit"><a href="javascript:void(0)" title="档案关联" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "archive:audit:rela", row.status,row.id) + '">关联</a></sec:authorize>';
                            }else{
                                html = '<sec:authorize url="/correlation/msgDialog"><a href="javascript:void(0)" title="" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "archive:audit:view", row.status,row.id) + '">查看</a></sec:authorize>';
                            }
                            return html;
                        }}
                    ]
                }));
                // 自适应宽度
                archiveGrid.adjustToWidth();
                this.bindEvents();
            },
            bindEvents: function () {
                this.$btnAudit.click(function () {
                    win.closeDialog();
                });
                this.$btnFefuse.click(function () {
                    win.closeDialog();
                });
                this.$btnHelp.click(function () {
                    win.closeDialog();
                });
            }
        };
        pageInit();

    })(jQuery, window);
</script>