<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var retrieve = null;
            var questionId = '${questionId}';
            var type = '${type}';
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
            }

            /* *************************** 模块初始化 ***************************** */

            retrieve = {
                $editQuestionBtn: $("#btn_edit-question"),//编辑问题
                $closeBtn: $('#btn_close'),//关闭弹窗
                infoDialog: null,
                init: function () {
                    this.getQuestion();
                    this.bindEvents();
                },
                getQuestion:function(){
                    var self = this;
                    var parmes = JSON.stringify({id:questionId})
                    $.ajax({
                        url: "${contextRoot}/survey/allMethod",
                        data: {
                            redicUrl:'/basic/api/v1.0/admin/surveyQuestion/getById',
                            postOrGet:'get',
                            paramJson:parmes
                        },
                        method: "get",
                        dataType: "json",
                        success: function (data) {
                            console.log(data);
                            if (data.successFlg) {
                                self.seeQuestion(data.obj);
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                },
                seeQuestion:function(resultData){
                    var resultHtml = "";
                    var titleData = resultData.question.title;//标题
                    var optionData = resultData.options;//选项
                    var comment = resultData.question.comment;
                    var questionType = resultData.question.questionType;//问题类型（0单选 1多选 2问答）
                    var minNum = resultData.question.minNum;
                    var maxNum = resultData.question.maxNum;
                    var duoXuanText = "";
                    if(minNum!=null && maxNum==null){
                        duoXuanText = "(至少选择"+minNum+"项)";
                    }else if(minNum==null && maxNum!=null){
                        duoXuanText = "(最多选择"+maxNum+"项)";
                    }else if(minNum!=null && maxNum!=null){
                        duoXuanText = "(选择"+minNum+"~"+maxNum+"项)";
                    }
                    var titleHtml = '<div class="topic-type-content topic-type-question after-clear" data-type="'+questionType+'">'+
                        '<div class="question-title preview-question-title">'+
                        '<span class="required">'+duoXuanText+'</span>'+
                        '<div class="position-relative" style="width: calc(100% - 85px);">'+
                        '<div class="qs-content edit-area edit-title">'+
                        titleData +
                        '</div>'+
                        '</div>'+
                        '</div>';
                    var optionHtml = '<ul class="question-choice" style="padding-top:0;">';
                    var itemHtml = "";
                    var remarkHtml = "";
                    //问题选项
                    if(optionData.length==0){
                        optionData = ["选项1"];
                    }
                    for(var j = 0;j<optionData.length;j++){
                        var haveComment = optionData[j].haveComment;
                        var isRequired = optionData[j].isRequired;
                        var content = optionData[j].content;
                        if(questionType=="0" || questionType=="1"){//单选题或多选题
                            var remark = "";
                            if(haveComment==1 && isRequired==1){
                                remark = '<div class="mrb10">'+
                                    '<input type="text" class="input-text preview-input-text"><span>（必填）</span>'+
                                    '</div>';
                            }
                            if(haveComment==1 && isRequired==0){
                                remark = '<div class="mrb10">'+
                                    '<input type="text" class="input-text preview-input-text">'+
                                    '</div>';
                            }
                            var imgClass = questionType=="0"?"div-radio-img":"div-checkbox-img";
                            itemHtml+='<li class="choice">'+
                                '<div class="'+imgClass+'"></div>'+
                                '<div class="position-relative">'+
                                '<div class="edit-area edit-child-element">'+
                                content +
                                '</div>'+
                                '</div>'+
                                remark+
                                '</li>';
                        }else{//问答题
                            itemHtml = '<li class="choice">'+
                                '<div style="padding:10px 0px;">'+
                                '<textarea placeholder="" class="div-textarea"></textarea>'+
                                '</div>'+
                                '</li>';
                        }
                    }
                    optionHtml+= itemHtml+"</ul>";
                    if(comment!=null){//选项说明
                        remarkHtml = '<div class="div-padding c-border-top f-mr20">'+
                            '<input placeholder="说明：这是题目的具体说明文字内容" class="max-input-text" value="'+comment+'">'+
                            '</div>';
                    }

                    resultHtml+=titleHtml+optionHtml+remarkHtml+"</div>";

                    $(".div-see-question-content").html(resultHtml);
                },
                bindEvents: function () {
                    var self = this;
                    self.$editQuestionBtn.click(function () {
                        var questionId = parseInt($("#questionId").val());
                        self.infoDialog = $.ligerDialog.open({
                            height: 430,
                            width: 600,
                            urlParms: {"id": questionId},
                            title: '编辑问题',
                            url: ctx + '/admin/surveyQuestion/editQuestion'
                        });

                    });

                    self.$closeBtn.click(function(){
                        parent.window.closeInfoDialog();
                    })
                }
            };

            /* ************************* Dialog页面回调接口 ************************** */



            /* *************************** 页面初始化 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>