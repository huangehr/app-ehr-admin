<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
    (function ($, win) {
        var rejectForm = null;
        function pageInit() {
            rejectForm.init();
        }
        var mode = eval("(" + '${mode}' + ")");
        rejectForm = {
            $btnOk: $("#btn_ok"),
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
            $auditReason:$("#audit_reason"),
            $form:$("#div_std_info_form"),
            init: function () {
                rejectForm.$applyUserName.ligerTextBox({width: 240, height: 25});
                rejectForm.$applyIdCard.ligerTextBox({width: 240, height: 25});
                rejectForm.$applyAnalyseTime.ligerTextBox({width: 240, height: 25});
                rejectForm.$applyAnalyseOrg.ligerTextBox({width: 240, height: 25});
                rejectForm.$applyAnalyseDoctor.ligerTextBox({width: 240, height: 25});
                rejectForm.$applyCardNmuber.ligerTextBox({width: 240, height: 25});
                rejectForm.$applyAnalyseOut.ligerTextBox({width: 240, height: 25});
                rejectForm.$applyExaminePro.ligerTextBox({width: 240, height: 25});
                rejectForm.$applyAnalyseDrug.ligerTextBox({width: 240, height: 25});
                rejectForm.$applyRemark.ligerTextBox({width: 240, height: 25});
                rejectForm.$auditReason.ligerTextBox({width: 340, height: 75});
                this.bindEvents();
                this.$form.attrScan();
                if(mode.auditReason==null||mode.auditReason==""){
                    mode.auditReason="找不到对应的档案列表！";
                }
                rejectForm.$form.Fields.fillValues({
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
            },bindEvents: function () {
                this.$btnOk.click(function () {
                    win.closeDialog();
                });
            }
        };
        pageInit();

    })(jQuery, window);
</script>