<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var userCardInfo = null;
		/* *************************** 函数定义 ******************************* */
        function pageInit() {
            userCardInfo.init();
        }
        /* *************************** 模块初始化 ***************************** */
        userCardInfo = {
			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),
            $btnRelative: $("#btn_relative"),
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
//                        $("#otherGroup").css('display','none');
                    }
                });

                $("#reason").change(function(){
                    var val = $("#reason").val();
                    if(val==0){
//                        $("#otherGroup").css('display','block');
                    }
                });

                $("#btn_relative").click(function(){
                    var cardNo =   $("#cardNo").val();
                    var name =  $("#ownerName").val();
                    var idCardNo = $("#idCardNo").val(); ;
                    userCardInfo.$btnRelative = $.ligerDialog.open({
                        height:540,
                        width: 1100,
                        title : "关联档案",
                        url: '${contextRoot}/userCards/archiveRelationInitial',
                        urlParms: {
                            cardNo: cardNo,
                            name:name,
                            idCardNo:idCardNo,
                            mode:'show',
                            id:'',
                            auditStatus:'',
                            reason:''
                        },
                        isHidden: false,
                        opener: true,
                        load:true,
                        isResize:true
                    });
                });


                this.$btnSave.click(function () {
                    var id = $("#id").val();
                    var auditVal = $("#audit").val();
                    var reasonTxt='';
                    var reasonVal = $("#reason").val();
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
                            reasonTxt = $("#reason").text();
                        }
                    }

                    if(auditVal=='2'){
                        var dataModel = $.DataModel.init();
                        dataModel.updateRemote("${contextRoot}/userCards/audit", {
                            data:{
                                id:id,
                                auditStatus:auditVal,
                                reason:reasonTxt,
                                archiveRelationIds:''
                            },
                            success: function(data) {
                                if (data.successFlg) {
                                    $.Notice.success('审核成功');
                                    win.closeDialog();
                                } else {
                                    $.Notice.error(data.errorMsg);
                                }
                            }
                        });
                    }else{//通过
                        var cardNo =   $("#cardNo").val();
                        var name =  $("#ownerName").val();
                        var idCardNo = $("#idCardNo").val(); ;
                        userCardInfo.$btnRelative = $.ligerDialog.open({
                            height:540,
                            width: 1100,
                            title : "关联档案保存",
                            url: '${contextRoot}/userCards/archiveRelationInitial',
                            urlParms: {
                                name:name,
                                idCardNo:idCardNo,
                                cardNo: cardNo,
                                mode:'save',
                                id:id,
                                auditStatus:auditVal,
                                reason:reasonTxt
                            },
                            isHidden: false,
                            opener: true,
                            load:true,
                            isResize:true
                        });
                        win.closeDialog();
                    }

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