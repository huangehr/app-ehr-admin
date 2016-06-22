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
            var auditHeight = $(".div-audit-msg").height();
            var windowHeight = $(window).height();
            // 页面表格条件部模块

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                recordInfo.init();
                recordInfo.recordGridInfo();
            }

            function reloadGrid(url, ps) {

            }

            /* *************************** 检索模块初始化 ***************************** */
            recordInfo = {
                $matchingAnalyseTime:$("#inp_matching_analyse_time"),
                $matchingAnalyseOrg:$("#inp_matching_analyse_org"),
                $matchingAnalyseDoctor:$("#inp_matching_analyse_doctor"),
                $matchingCardNmuber:$("#inp_matching_card_nmuber"),
                $matchingAnalyseOut:$("#inp_matching_analyse_out"),
                $matchingExaminePro:$("#inp_matching_examine_pro"),
                $matchingAnalyseDrug:$("#inp_matching_analyse_drug"),
                $matchingRemark:$("#inp_matching_remark"),

                $applyAnalyseTime:$("#inp_apply_analyse_time"),
                $applyAnalyseOrg:$("#inp_apply_analyse_org"),
                $applyAnalyseDoctor:$("#inp_apply_analyse_doctor"),
                $applyCardNmuber:$("#inp_apply_card_nmuber"),
                $applyAnalyseOut:$("#inp_apply_analyse_out"),
                $applyExaminePro:$("#inp_apply_examine_pro"),
                $applyAnalyseDrug:$("#inp_apply_analyse_drug"),
                $applyRemark:$("#inp_apply_remark"),

                $matchingRecordGrid:$("#div_matching_record_grid"),
                $relevanceBtn:$("#div_relevance_btn"),
                $unrelevanceBtn:$("#div_unrelevance_btn"),

                init:function () {
                    var self = this;
                    self.$matchingAnalyseTime.ligerTextBox({width: 240,height:25});
                    self.$matchingAnalyseOrg.ligerTextBox({width: 240,height:25});
                    self.$matchingAnalyseDoctor.ligerTextBox({width: 240,height:25});
                    self.$matchingCardNmuber.ligerTextBox({width: 240,height:25});
                    self.$matchingAnalyseOut.ligerTextBox({width: 240,height:25});
                    self.$matchingExaminePro.ligerTextBox({width: 240,height:25});
                    self.$matchingAnalyseDrug.ligerTextBox({width: 240,height:25});
                    self.$matchingRemark.ligerTextBox({width: 240,height:25});

                    self.$applyAnalyseTime.ligerTextBox({width: 240,height:25});
                    self.$applyAnalyseOrg.ligerTextBox({width: 240,height:25});
                    self.$applyAnalyseDoctor.ligerTextBox({width: 240,height:25});
                    self.$applyCardNmuber.ligerTextBox({width: 240,height:25});
                    self.$applyAnalyseOut.ligerTextBox({width: 240,height:25});
                    self.$applyExaminePro.ligerTextBox({width: 240,height:25});
                    self.$applyAnalyseDrug.ligerTextBox({width: 240,height:25});
                    self.$applyRemark.ligerTextBox({width: 240,height:25});
                },

                recordGridInfo:function () {
                    var self = this;
                    recordGrid = self.$matchingRecordGrid.ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/user/searchUsers',
                        width:$(window).width()-210,
                        height:windowHeight-(auditHeight+185),
                        columns: [
                            {display: '就诊时间', name: 'realName', width: '25%',align:'left'},
                            {display: '就诊机构',name: 'loginCode', width:'25%', isAllowHide: false,align:'left'},
                            {display: '医生', name: 'organizationName', width: '25%',align:'left'},
                            {display: '操作', name: 'operator', width: '25%', render: function (row) {
                                var html = '<a class="" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "user:userInfoModifyDialog:open", row.id, 'modify') + '">详细对比</a>';
                                return html;
                            }}
                        ]

                    }));
                    self.clicks();
                },
                clicks:function () {
                    var self = this;
                    self.$relevanceBtn.click(function () {
                        $.ligerDialog.confirm('是否确认关联？<br>是否确认关联？操作后无法更改。',function(yes){
                            if(yes){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote("${contextRoot}/user/deleteUser",{
//                                    data:{userId:userId},
                                    async:true,
                                    success: function(data) {
                                        if(data.successFlg){
                                            $.Notice.success('删除成功。');
                                        }else{
                                            $.Notice.error('删除失败。');
                                        }
                                    }
                                });
                            }
                        });
                    });
                    self.$unrelevanceBtn.click(function () {
                        $.ligerDialog.confirm('是否确认关联？<br>是否确认关联？操作后无法更改。',function(yes){
                            if(yes){
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote("${contextRoot}/user/deleteUser",{
//                                    data:{userId:userId},
                                    async:true,
                                    success: function(data) {
                                        if(data.successFlg){
                                            $.Notice.success('删除成功。');
                                        }else{
                                            $.Notice.error('删除失败。');
                                        }
                                    }
                                });
                            }
                        });
                    })
                }
            };

            /* *************************** 检索模块初始化结束 ***************************** */

            /* *************************** 模块初始化 ***************************** */

            /* ************************* 模块初始化结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window);
</script>