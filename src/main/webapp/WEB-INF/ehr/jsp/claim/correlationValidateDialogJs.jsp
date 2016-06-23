<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var validateForm = null;
		var msg = '${msg}';
        var mode = '${mode}'
        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            validateForm.init();
        }
        /* *************************** 模块初始化 ***************************** */
        validateForm = {
            $btnReject: $("#btn_reject"),
            $btnCancel: $("#btn_cancel"),
            init: function () {
                this.bindEvents();
              },bindEvents: function () {
                this.$btnReject.click(function () {
                    var dialog = $.ligerDialog.waitting("正在驳回申请...");
                    validateForm.$btnReject.attr('disabled','disabled');
                    //赋值拒绝不通过
                    mode = eval("(" + mode + ")");
                    mode.auditReason = msg;
                    mode.status="2";
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/correlation/updateCorrelationMode",{
                        data:{
                            correlationMode:JSON.stringify(mode),
                        },
                        success: function(data) {
                            if(data.successFlg){
                                win.closeDialog("驳回成功！");
                            }else{
                                $.Notice.error(data.errorMsg);
                            }
                        },
                        error: function () {
                            $.Notice.error( '驳回失败！');
                            validateForm.$btnSave.removeAttr('disabled');
                        },complete:function(){
                            dialog.close();
                        }
                    });
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