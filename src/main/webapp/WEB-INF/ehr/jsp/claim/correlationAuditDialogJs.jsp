<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
    (function ($, win) {
        var auditForm = null;
        var mode = eval("(" + '${mode}' + ")");
        var archives = '${archives}'==''?{}:eval("(" + '${archives}' + ")");
        function pageInit() {
            auditForm.init();
        }
        auditForm = {
            $btnOk: $("#btn_ok"),
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

            $matchingAnalyseTime: $("#inp_matching_analyse_time"),
            $matchingAnalyseOrg: $("#inp_matching_analyse_org"),
            $matchingAnalyseDoctor: $("#inp_matching_analyse_doctor"),
            $matchingCardNmuber: $("#inp_matching_card_nmuber"),
            $matchingAnalyseOut: $("#inp_matching_analyse_out"),
            $matchingExaminePro: $("#inp_matching_examine_pro"),
            $matchingAnalyseDrug: $("#inp_matching_analyse_drug"),
            $matchingRemark: $("#inp_matching_remark"),

            init: function () {
                this.bindEvents();
                auditForm.$matchingAnalyseTime.ligerTextBox({width: 240, height: 25});
                auditForm.$matchingAnalyseOrg.ligerTextBox({width: 240, height: 25});
                auditForm.$matchingAnalyseDoctor.ligerTextBox({width: 240, height: 25});
                auditForm.$matchingCardNmuber.ligerTextBox({width: 240, height: 25});
                auditForm.$matchingAnalyseOut.ligerTextBox({width: 240, height: 25});
                auditForm.$matchingExaminePro.ligerTextBox({width: 240, height: 25});
                auditForm.$matchingAnalyseDrug.ligerTextBox({width: 240, height: 25});
                auditForm.$matchingRemark.ligerTextBox({width: 240, height: 25});

                auditForm.$applyAnalyseTime.ligerTextBox({width: 240, height: 25});
                auditForm.$applyAnalyseOrg.ligerTextBox({width: 240, height: 25});
                auditForm.$applyAnalyseDoctor.ligerTextBox({width: 240, height: 25});
                auditForm.$applyCardNmuber.ligerTextBox({width: 240, height: 25});
                auditForm.$applyAnalyseOut.ligerTextBox({width: 240, height: 25});
                auditForm.$applyExaminePro.ligerTextBox({width: 240, height: 25});
                auditForm.$applyAnalyseDrug.ligerTextBox({width: 240, height: 25});
                auditForm.$applyRemark.ligerTextBox({width: 240, height: 25});

                auditForm.$form.attrScan();
                //申请信息填充
                auditForm.$form.Fields.fillValues({
                    applyDate:mode.applyDate,
                    visOrg:mode.visOrg,
                    visDoctor:mode.visDoctor,
                    cardNo:mode.cardNo,
                    diagnosedResult:mode.diagnosedResult,
                    diagnosedProject:mode.diagnosedProject,
                    medicines:mode.medicines,
                    memo:mode.memo,
                    applyDateArchives:archives.applyDate,
                    visOrgArchives:archives.visOrg,
                    visDoctorArchives:archives.visDoctor,
                    cardNoArchives:archives.cardNo,
                    diagnosedResultArchives:archives.diagnosedResult,
                    diagnosedProjectArchives:archives.diagnosedProject,
                    medicinesArchives:archives.medicines,
                    memoArchives:archives.memo

                });
                //档案字段填充

            },bindEvents: function () {
                this.$btnOk.click(function () {
                    win.closeDialog();
                });
            }
        };
        pageInit();

    })(jQuery, window);
</script>