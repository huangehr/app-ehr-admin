<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var userCardInfo = null;
        var mode = '${mode}';

		/* *************************** 函数定义 ******************************* */
        function pageInit() {
            userCardInfo.init();
        }
        /* *************************** 模块初始化 ***************************** */
        userCardInfo = {
			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),
            $audit: $("#audit"),

            init: function () {
                this.bindEvents();
            },

            bindEvents: function () {
                var self = this;

                this.$audit.change(function(){
                    var auditVal = this.value;
                    if(auditVal==2){
                        $("#refuseReasonGroup").css('display','block');
                    }
                    if(auditVal==1){
                        $("#refuseReasonGroup").css('display','none');
                        $("#otherGroup").css('display','none');
                    }


                });


                $("#reason").change(function(){
                    var val = $("#reason").val();
                    if(val==0){
                        $("#otherGroup").css('display','block');
                    }


                });

                this.$btnSave.click(function () {
                    debugger
                    var id = $("#id").val();
                    var auditVal =$("#audit").val();
                    var reasonTxt='';
                    var reasonVal = $("#reason").val();
                    var otherResonVal = $("#otherReason").val();
                    if(auditVal=='' || auditVal==undefined){
                        $.Notice.error('审核不能为空');
                        return;
                    }else if(auditVal=='2'){
                        if(reasonVal==''){
                            $.Notice.error('不通过原因不能为空');
                            return;
                        }else if(reasonVal=='0'){
                            if(otherResonVal=='' || otherResonVal==undefined){
                                $.Notice.error('其他原因不能为空');
                                return;
                            }else{
                                reasonTxt = otherResonVal;
                            }
                        }else{
                            reasonTxt = $("#reason").text();
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
                            if (data) {
                                $.Notice.success('审核成功');
                                win.reloadMasterGrid();
                                win.closeDialog();
                            } else {
                                $.Notice.error("审核失败");
                            }
                        }
                    });
                });

                this.$btnCancel.click(function () {
                    win.closeDialog();
                });

                this.$btnCancel.click(function () {
					win.closeDialog();
                });
            }

        };

        /* *************************** 页面初始化 **************************** */
        pageInit();

    })(jQuery, window);
</script>