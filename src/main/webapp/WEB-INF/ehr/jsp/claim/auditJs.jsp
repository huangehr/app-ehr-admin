<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var recordInfo = null;
            var recordGrid = null;
            var reloadData = null;
            var unrelevanceDialog = null;
            var claimModel = ${claimModel};
//            delete claimModel.obj['statusName'];
//            delete claimModel.obj['visOrgName'];
//            claimModel.obj.applyDate = new Date(claimModel.obj.applyDate);
//            claimModel.obj.auditDate = new Date(claimModel.obj.auditDate);
//            claimModel.obj.applyDate = '2016-06-22T13:41:11Z+0800';

            var ApplyStrModel = ${ApplyStr};
            var auditHeight = $(".div-audit-msg").height();
            var windowHeight = $(window).height();
            var dataModel = $.DataModel.init();
            // 页面表格条件部模块

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                recordInfo.init();
                recordInfo.recordGridInfo();
            }


            /* *************************** 检索模块初始化 ***************************** */
            recordInfo = {
                $applyForm: $("#div_apply_form"),
                $matchingAnalyseTime: $("#inp_matching_analyse_time"),
                $matchingAnalyseOrg: $("#inp_matching_analyse_org"),
                $matchingAnalyseDoctor: $("#inp_matching_analyse_doctor"),
                $matchingCardNmuber: $("#inp_matching_card_nmuber"),
                $matchingAnalyseOut: $("#inp_matching_analyse_out"),
                $matchingExaminePro: $("#inp_matching_examine_pro"),
                $matchingAnalyseDrug: $("#inp_matching_analyse_drug"),
                $matchingRemark: $("#inp_matching_remark"),

                $matchingForm: $("#div_matching_form"),
                $applyAnalyseTime: $("#inp_apply_analyse_time"),
                $applyAnalyseOrg: $("#inp_apply_analyse_org"),
                $applyAnalyseDoctor: $("#inp_apply_analyse_doctor"),
                $applyCardNmuber: $("#inp_apply_card_nmuber"),
                $applyAnalyseOut: $("#inp_apply_analyse_out"),
                $applyExaminePro: $("#inp_apply_examine_pro"),
                $applyAnalyseDrug: $("#inp_apply_analyse_drug"),
                $applyRemark: $("#inp_apply_remark"),

                $matchingRecordGrid: $("#div_matching_record_grid"),
                $relevanceBtn: $("#div_relevance_btn"),
                $unrelevanceBtn: $("#div_unrelevance_btn"),
                $matchingChangeBtn: $(".sp-matching-change-btn"),

                init: function () {
                    var self = this;
                    self.$matchingAnalyseTime.ligerTextBox({width: 200, height: 25});
                    self.$matchingAnalyseOrg.ligerTextBox({width: 200, height: 25});
                    self.$matchingAnalyseDoctor.ligerTextBox({width: 200, height: 25});
                    self.$matchingCardNmuber.ligerTextBox({width: 200, height: 25});
                    self.$matchingAnalyseOut.ligerTextBox({width: 200, height: 25});
                    self.$matchingExaminePro.ligerTextBox({width: 200, height: 25});
                    self.$matchingAnalyseDrug.ligerTextBox({width: 200, height: 25});
                    self.$matchingRemark.ligerTextBox({width: 200, height: 25});

                    self.$applyAnalyseTime.ligerTextBox({width: 200, height: 25});
                    self.$applyAnalyseOrg.ligerTextBox({width: 200, height: 25});
                    self.$applyAnalyseDoctor.ligerTextBox({width: 200, height: 25});
                    self.$applyCardNmuber.ligerTextBox({width: 200, height: 25});
                    self.$applyAnalyseOut.ligerTextBox({width: 200, height: 25});
                    self.$applyExaminePro.ligerTextBox({width: 200, height: 25});
                    self.$applyAnalyseDrug.ligerTextBox({width: 200, height: 25});
                    self.$applyRemark.ligerTextBox({width: 200, height: 25});


//                    $($('.sp-matching-change-btn')[0]).addClass('f-dn');
                    $('.sp-lift-btn').css('background','url()');
                    reloadData.reloadAuditData(claimModel.obj, self.$applyForm);
                    reloadData.reloadAuditData(ApplyStrModel.detailModelList[0], self.$matchingForm);

                },

                recordGridInfo: function () {
                    var self = this;
                    recordGrid = self.$matchingRecordGrid.ligerGrid($.LigerGridEx.config({
                        data: ApplyStrModel,
                        <%--url: '${contextRoot}/user/searchUsers',--%>
                        width: $(window).width() - 210,
                        height: windowHeight - (auditHeight + 185),
                        columns: [
                            {display: '就诊时间', name: 'visDate', width: '25%', align: 'left'},
                            {display: '就诊机构', name: 'visOrg', width: '25%', isAllowHide: false, align: 'left'},
                            {display: '医生', name: 'visDoctor', width: '25%', align: 'left'},
                            {
                                display: '操作', name: 'operator', width: '25%', render: function (row) {
                                var jsonStr = JSON.stringify(row);
                                var html = '<a class="" title="详细对比" href="javascript:void(0)" onclick=javascript:' + Util.format("$.publish('{0}',['{1}'])", "audit:auditInfo:open", jsonStr) + '>详细对比</a>';
                                return html;
                            }
                            }
                        ]

                    }));
                    self.clicks();
                },
                clicks: function () {
                    var self = this;
                    var claimId = ApplyStrModel.detailModelList[0].id;
                    var cont = 0;

                    self.$relevanceBtn.click(function () {
                        self.$matchingForm.attrScan();
                        var data = self.$matchingForm.Fields.getValues();
                        var relationModel = {idCard:claimModel.obj.idCard,arApplyId:claimModel.obj.id,archiveId:data.id,status:'0'}
                        $.ligerDialog.confirm('是否确认关联？<br>是否确认关联？操作后无法更改。', function (yes) {
                            if (yes) {
                                var dialog = $.ligerDialog.waitting('正在保存,请稍候...');
                                dataModel.updateRemote("${contextRoot}/audit/addArRelations", {
                                    data: {relationModel:JSON.stringify(relationModel)},
                                    async: true,
                                    success: function (data) {
                                        dialog.close();
                                        if (data.successFlg) {
                                            $.Notice.success('关联成功。');
                                        } else {
                                            $.Notice.error('关联失败。');
                                        }
                                    }
                                });
                            }
                        });
                    });

                    self.$unrelevanceBtn.click(function () {
                        unrelevanceDialog = $.ligerDialog.open({
                            height: 330,
                            width: 400,
                            title: '请选择不通过的原意',
//                            load:true,
                            url: '${contextRoot}/audit/auditDialog',
                            urlParms: {
                                jsonModel:JSON.stringify(claimModel.obj)
                            }
                        });
                    });

                    self.$matchingChangeBtn.click(function () {
                        var dataModel = ApplyStrModel.detailModelList;
                        var eleId = $(this).attr('id');
                        switch (eleId) {
                            case 'sp_lift':
                                cont--;
                                if (cont<=0) {
                                    $('.sp-lift-btn').css('background','url()');
                                    $('.sp-right-btn').css('background','url(${staticRoot}/images/Right_btn_pre.png)');
//                                    $($('.sp-matching-change-btn')[0]).addClass('f-dn');
//                                    $($('.sp-matching-change-btn')[1]).removeClass('f-dn');
                                    cont = 0;
                                }
                                break;
                            default:
                                cont++;
                                if (dataModel.length<=cont+1) {
//                                    $($('.sp-matching-change-btn')[1]).addClass('f-dn');
                                    $('.sp-lift-btn').css('background','url(${staticRoot}/images/Left_btn_pre.png)');
                                    $('.sp-right-btn').css('background','url()');
//                                    $($('.sp-matching-change-btn')[0]).removeClass('f-dn');
                                    cont = dataModel.length-1;
                                }
                                break;
                        }
                        reloadData.reloadAuditData(dataModel[cont], self.$matchingForm);
                    });
                    $.subscribe('audit:auditInfo:open', function (event, jsonStr) {
                        var jsonObj = JSON.parse(jsonStr);
                        claimId = jsonObj.id;
                        reloadData.reloadAuditData(jsonObj, self.$matchingForm);
                    })
                }
            };

            reloadData = {
                reloadAuditData: function (data, ele) {
                    ele.attrScan();
                    ele.Fields.fillValues({
                        id:data.id,
                        visDate: data.visDate,
                        visOrg: data.visOrg,
                        visDoctor: data.visDoctor,
                        cardNo: data.cardNo,
                        diagnosedResult: data.diagnosedResult,
                        diagnosedProject: data.diagnosedProject,
                        medicines: data.medicines,
                        memo: data.memo
                    });
                }
            };
            win.closeAuditDialog = function (msg) {
                unrelevanceDialog.close();
                $.Notice.success(msg);
            };
            /* *************************** 检索模块初始化结束 ***************************** */

            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window);
</script>