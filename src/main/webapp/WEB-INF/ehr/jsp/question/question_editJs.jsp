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
            var divMoreDialog = null;
            var divPatchDialog = null;
            var divInstructionDialog = null;
            var divDuoXuanSettingDialog = null;
            var questionId = '${questionId}';
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
            }

            /* *************************** 模块初始化 ***************************** */

            retrieve = {
                $saveQuestionBtn: $("#btn_save-question"),//保存问题
                $closeBtn: $('#btn_close'),//关闭弹窗
                $editChildElementContent:$(".edit-child-element-content"),//更多操作图标
                $divMoreDialog:$("#div_MoreDialog"),
                $divPatchDialog:$("#div-patchDialog"),
                $divInstructionDialog:$("#div-instructionDialog"),
                $divDuoXuanSettingDialog:$("#div-duoxuanSettingDialog"),
                init: function () {
                    this.getQuestion();
                    this.bindEvents();
                },
                getQuestion:function(){
                    var self = this;
                    var parmes = JSON.stringify({id:questionId});
                    $.ajax({
                        url:"${contextRoot}/survey/allMethod",
                        data: {
                            redicUrl:'/basic/api/v1.0/admin/surveyQuestion/getById',
                            postOrGet:'get',
                            paramJson:parmes
                        },
                        method: "get",
                        dataType: "json",
                        success: function (data) {
                            if (data.successFlg) {
                                self.editQuestion(data.obj);
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                },
                editQuestion: function(data){
                    var resultHtml = "";
                    var titleData = data.question.title;//标题
                    var optionData = data.options;//选项
                    var type = data.question.questionType;
                    var minNum = data.question.minNum==undefined?"":data.minNum;
                    var maxNum = data.question.maxNum==undefined?"":data.maxNum;
                    var comment = data.question.comment;
                    var duoXuanText = "";
                    if(minNum!="" && maxNum==""){
                        duoXuanText = "(至少选择"+minNum+"项)";
                    }else if(minNum=="" && maxNum!=""){
                        duoXuanText = "(最多选择"+maxNum+"项)";
                    }else if(minNum!="" && maxNum!=""){
                        duoXuanText = "(选择"+minNum+"~"+maxNum+"项)";
                    }
                    var titleHtml = '<div class="topic-type-content topic-type-question after-clear" data-type="'+type+'" data-minvalue="'+minNum+'" data-maxvalue="'+maxNum+'">'+
                        '<div class="question-title">'+
                        '<span class="required">'+duoXuanText+'</span>'+
                        '<div class="position-relative" style="width: calc(100% - 85px);">'+
                        '<div class="qs-content edit-area edit-title"  contenteditable="true" data-value="">'+
                        titleData +
                        '</div>'+
                        '</div>'+
                        '</div>';
                    var optionHtml = '<ul class="question-choice">';
                    var itemHtml = "";
                    var addAreaHtml = "";
                    var operateHtml = "";
                    var remarkHtml = "";
                    if(optionData.length==0){
                        optionData = ["选项1"];
                    }
                    //问题选项
                    for(var j = 0;j<optionData.length;j++){
                        if(type=="0" || type=="1"){//单选题或多选题
                            var haveComment = optionData[j].haveComment;
                            var isRequired = optionData[j].isRequired;
                            var optionIsRequired = optionData[j].isRequired;
                            var imgClass = type=="0"?"div-radio-img":"div-checkbox-img";
                            var remark = "";
                            if(haveComment==1 && optionIsRequired==1){
                                remark = '<div class="mrb10">'+
                                    '<input type="text" class="input-text preview-input-text"><span>（必填）</span>'+
                                    '</div>';
                            }
                            if(haveComment==1 && optionIsRequired==0){
                                remark = '<div class="mrb10">'+
                                    '<input type="text" class="input-text preview-input-text">'+
                                    '</div>';
                            }

                            itemHtml+='<li class="choice" data-input="'+haveComment+'" data-input-required="'+isRequired+'" data-id="">'+
                                '<div class="'+imgClass+'"></div>'+
                                '<div class="position-relative">'+
                                '<div class="edit-area edit-child-element" contenteditable="true" data-value="">'+
                                optionData[j].content +
                                '</div>'+
                                '</div>'+
                                remark+
                                '</li>';
                        }else{//问答题
                            itemHtml = '<li class="choice" data-input="'+haveComment+'" data-input-required="'+isRequired+'" data-id="">'+
                                '<div style="padding:10px 0px;">'+
                                '<textarea placeholder="" class="div-textarea"></textarea>'+
                                '</div>'+
                                '</li>';
                        }
                    }
                    optionHtml+= itemHtml+"</ul>";
                    //以下是各个操作按钮
                    if(type=="0" || type=="1"){//单选题、多选题
                        addAreaHtml = '<div class="add-area visible-show">'+
                            '<ul>'+
                            '<li class="add-choice" title="增加"></li>'+
                            '<li class="batch-add-choice" title="批量增加"></li>'+
                            '</ul>'+
                            '</div>';
                        if(type=="0"){//单选题
                            operateHtml = '<div class="operate visible-show">'+
                                '<ul>'+
                                '<li class="question-instruction" title="说明"></li>'+
                                '<li class="question-transform" title="转换"></li>'+
                                '</ul>'+
                                '</div>';
                        }else{//多选题
                            operateHtml = '<div class="operate visible-show">'+
                                '<ul>'+
                                '<li class="question-instruction" title="说明"></li>'+
                                '<li class="question-transform" title="转换"></li>'+
                                '<li class="question-duoxuan" title="多选设置"></li>'+
                                '</ul>'+
                                '</div>';
                        }
                    }else{//问答题
                        operateHtml = '<div class="operate visible-show">'+
                            '<ul>'+
                            '<li class="question-instruction" title="说明"></li>'+
                            '</ul>'+
                            '</div>';
                    }
                    if(comment!=null){//选项说明
                        remarkHtml = '<div class="div-padding c-border-top f-mr20 div-instruction-text">'+
                            '<input placeholder="说明：这是题目的具体说明文字内容" class="max-input-text" value="'+comment+'">'+
                            '</div>';
                    }
                    resultHtml+=titleHtml+optionHtml+remarkHtml+addAreaHtml+operateHtml+"</div>";

                    $(".div-edit-question-content").html(resultHtml);

                },
                saveQuestion:function(resultData){//保存问题
                    var resData = JSON.stringify(resultData);
                    var turn = {
                        jsonData:resData,
                    }
                    var parms = JSON.stringify(turn);
                    $.ajax({
                        url: '${contextRoot}/survey/allMethod',
                        data: {
                            redicUrl:'/basic/api/v1.0/admin/surveyQuestion/save',
                            postOrGet:'post',
                            paramJson:parms
                        },
                        method: "post",
                        success: function (data) {
                            if (data.successFlg) {
                                debugger
                                $.Notice.success(data.msg);
                                parent.window.closeParentInfoDialog();
                            } else {
                                $.Notice.error(data.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                },
                bindEvents: function () {
                    var self = this;
                    self.$saveQuestionBtn.click(function () {
                        //parent.window.closeParentInfoDialog();
                        var questionId = parseInt($("#questionId").val());
                        var resultData = [];
                        var topicTypeQuestion =  $(".div-edit-question-content").find(".topic-type-question");
                        for(var i=0;i<topicTypeQuestion.length;i++){
                            var item = $(topicTypeQuestion[i]);
                            var title = item.find(".edit-title").html();//问题标题
                            var comment = item.find(".div-instruction-text input").length>0?item.find(".div-instruction-text input").val():null;//问题说明
                            var questionType = parseInt(item.attr("data-type"));//问题类型（0单选 1多选 2问答）
                            var minNum = item.attr("data-minvalue")==""?null: item.attr("data-minvalue");//最小答案个数（多选有效）
                            var maxNum = item.attr("data-maxvalue")==""?null: item.attr("data-maxvalue");//最大答案个数（多选有效）
                            var optionData = [];
                            if(questionType!=2){
                                var optionItem = item.find(".question-choice").find(".choice");
                                var sortCount = 0;
                                for(var j=0;j<optionItem.length;j++){
                                    sortCount++;
                                    var haveComment = $(optionItem[j]).find(".other-content").length>0?1:0;//是否有选项说明（0没有 1有）
                                    var isRequired =  $(optionItem[j]).find(".other-required").length>0?1:0;////选项说明是否必填（0否 1是）
                                    var content = $(optionItem[j]).find(".edit-child-element").html();//选项内容
                                    var sort = sortCount;//单题内排序
                                    optionData.push({"haveComment": haveComment,"content": content,"isRequired": isRequired,"sort": sort});
                                }
                            }
                            resultData.push({"id":questionId,"title": title,"comment": comment,"questionType": questionType,"minNum": minNum,"maxNum": maxNum,"optionData": optionData})
                        }
                        self.saveQuestion(resultData);
                    });

                    self.$closeBtn.click(function(){
                        parent.window.closeInfoDialog();
                    })
                    //点击问题选项事件
                    $(".div-edit-question-content").on("click",".question-title .qs-content,.question-choice .edit-area",function() {
                        if($(".position-relative").find(".edit-img")) $(".position-relative").find(".edit-img").remove();
                        if($(this).html().trim()==$(this).attr("data-value")){
                            $(this).html("");
                        }
                        $(".question-title .qs-content").removeClass("edit-area-active");
                        $(".question-choice .edit-area").removeClass("edit-area-active");
                        $(this).addClass("edit-area-active");
                        if(!$(this).hasClass("edit-title")){
                            $(this).closest(".position-relative").append(self.$editChildElementContent.html());
                        }
                    }).on("blur",".question-title .qs-content,.question-choice .edit-area",function() {
                        if($(this).html().trim()==""){
                            $(this).html($(this).attr("data-value"));
                        }
                        var val = $(this).html().replace(/<[^>]+>/g,"");//去掉所有的html标记
                        $(this).html(val);
                    });

                    //更多操作事件
                    var activeItem = "";
                    $(".div-edit-question-content").on("click",".question-choice .edit-img .handle-child-element",function() {
                        activeItem =  $(this).closest(".choice").find(".edit-area-active").closest(".choice");
                        var dataInput = $(this).closest(".choice").attr("data-input");//0：没有文本框 1 有文本框
                        var dataInputRequired = $(this).closest(".choice").attr("data-input-required");//0：非必输 1：必输
                        if(dataInput=="1" && dataInputRequired=="1"){
                            self.$divMoreDialog.find(".div-select-checkbox").addClass("active");
                            self.$divMoreDialog.find(".div-input-checkbox").find("img").attr("src","${ctx}/static/develop/images/yigouxuan_icon.png");
                            self.$divMoreDialog.find(".div-input-checkbox").show().addClass("active");
                        }else if(dataInput=="0" && dataInputRequired=="0"){
                            self.$divMoreDialog.find(".div-select-checkbox").removeClass("active");
                            self.$divMoreDialog.find(".div-select-checkbox").find("img").attr("src","${ctx}/static/develop/images/weigouxuan_icon.png");
                            self.$divMoreDialog.find(".div-input-checkbox").hide().removeClass("active");
                        }else if(dataInput=="1" && dataInputRequired=="0"){
                            self.$divMoreDialog.find(".div-select-checkbox").addClass("active");
                            self.$divMoreDialog.find(".div-input-checkbox").find("img").attr("src","${ctx}/static/develop/images/weigouxuan_icon.png");
                            self.$divMoreDialog.find(".div-input-checkbox").show().removeClass("active");
                        }

                        divMoreDialog = $.ligerDialog.open({
                            title: "选项设置",
                            width: 320,
                            height: 176,
                            target: self.$divMoreDialog
                        });

                        //更多操作的各个按钮操作
                        $("#div_MoreDialog").on("click",".btn_more_confirm",function(){//[更多操作]框的确认按钮事件
                            var inputContent = '<input type="text" class="other-content" style="width: 200px;height: 30px;vertical-align: middle;">';
                            var inputRequiredContent = '<span class="other-required">（必填）</span>';
                            if(self.$divMoreDialog.find(".div-select-checkbox").hasClass("active")){
                                activeItem.attr("data-input","1");//有文本框
                                if(activeItem.find(".other-content").length==0){
                                    activeItem.append(inputContent);
                                }
                                if(self.$divMoreDialog.find(".div-input-checkbox").hasClass("active")){
                                    activeItem.attr("data-input-required","1");//文本框必输
                                    if(activeItem.find(".other-required").length==0){
                                        activeItem.append(inputRequiredContent);
                                    }
                                }else{
                                    activeItem.attr("data-input-required","0");//文本框不必输
                                    if(activeItem.find(".other-required")){
                                        activeItem.find(".other-required").remove();
                                    }
                                }
                            }else{
                                activeItem.attr("data-input","0");//无文本框
                                activeItem.attr("data-input-required","0");//文本框非必输
                                if(activeItem.find(".other-content")){
                                    activeItem.find(".other-content").remove();
                                }
                                if(activeItem.find(".other-required")){
                                    activeItem.find(".other-required").remove();
                                }
                            }
                            divMoreDialog.close();

                        }).on("click",".btn_more_cancle",function(){//[更多操作]框的弹框取消事件
                            divMoreDialog.close();
                        }).on("click",".div-select-checkbox",function(){//[更多操作]框的弹框[选项后添加选择框]事件
                            if(!$(this).hasClass("active")){
                                $(this).find("img").attr("src","${ctx}/static/develop/images/yigouxuan_icon.png");
                                $(this).addClass("active");
                                self.$divMoreDialog.find(".div-input-checkbox").find("img").attr("src","${ctx}/static/develop/images/yigouxuan_icon.png");
                                self.$divMoreDialog.find(".div-input-checkbox").show().addClass("active");
                            }else{
                                $(this).find("img").attr("src","${ctx}/static/develop/images/weigouxuan_icon.png");
                                $(this).removeClass("active");
                                self.$divMoreDialog.find(".div-input-checkbox").hide();
                            }
                        }).on("click",".div-input-checkbox",function(){//[更多操作]框的弹框[填空框是否必填]事件
                            if(!$(this).hasClass("active")){
                                $(this).find("img").attr("src","${ctx}/static/develop/images/yigouxuan_icon.png");
                                $(this).addClass("active");
                            }else{
                                $(this).find("img").attr("src","${ctx}/static/develop/images/weigouxuan_icon.png");
                                $(this).removeClass("active");
                            }
                        })

                    })

                    //删除操作事件
                    $(".div-edit-question-content").on("click",".question-choice .edit-img .remove-child-element",function(){
                        if($(this).closest(".question-choice").find(".choice").length==2){
                            $.Notice.error('需至少有一个选项');
                        }else{
                            $(this).closest(".choice").remove();
                        }
                    }).on("click",".edit-img .up-child-element",function(){//上移操作事件
                        var currentLi = $(this).closest(".choice");
                        var prevLi = currentLi.prev("li");
                        if (prevLi.length > 0) {
                            var _temp = currentLi.html();
                            currentLi.empty().append(prevLi.html());
                            prevLi.empty().append(_temp);
                        }
                    }).on("click",".edit-img .down-child-element",function(){//下移操作事件
                        var currentLi = $(this).closest(".choice");
                        var prevLi = currentLi.next("li");
                        if (prevLi.length > 0) {
                            var _temp = currentLi.html();
                            currentLi.empty().append(prevLi.html());
                            prevLi.empty().append(_temp);
                        }
                    });


                    $(".div-edit-question-content").on("click",".topic-type-question .add-area .add-choice",function(){//增加选项事件
                        var appendItem = $(this).closest(".topic-type-question").find(".question-choice");
                        var prevItemCount = appendItem.find(".choice").length+1;
                        var classz = $(this).closest(".topic-type-question").attr("data-type")=="0"?"div-radio-img":"div-checkbox-img";
                        var item = '<li class="choice" data-input="0" data-input-required="0" data-id="">'+
                            '<div class="'+classz+'"></div>'+
                            '<div class="position-relative">'+
                            '<div class="edit-area edit-child-element" contenteditable="true" data-value="选项'+prevItemCount+'">'+
                            '选项'+prevItemCount+
                            '</div>'+
                            '</div>'+
                            '</li>';
                        appendItem.append(item);
                    }).on("click",".add-area .batch-add-choice",function(){//批量增加选项事件
                        var questionItem = $(this).closest(".topic-type-question");
                        self.$divPatchDialog.find(".batch-choices").val("");//清空原来的值

                        divPatchDialog = $.ligerDialog.open({
                            title: "批量添加选项框",
                            width: 320,
                            height: 280,
                            target: self.$divPatchDialog
                        });

                        //批量添加选项框的各个按钮操作
                        $("#div-patchDialog").on("click",".btn_patch_confirm",function(){//[批量添加选项框]框的确认按钮事件
                            if($("#div-patchDialog").find(".batch-choices").val().trim()==""){
                                $("#div-patchDialog").find(".div-errorInfo").html('输入内容不能为空!');
                                return false;
                            }
                            $("#div-patchDialog").find(".div-errorInfo").html('');
                            var appendItem = questionItem.find(".question-choice");
                            var patchItemArr = $("#div-patchDialog").find(".batch-choices").val().replace(/\n/g,",").split(",");
                            var prevItemCount = appendItem.find("li").length;
                            var classz = questionItem.attr("data-type")=="0"?"div-radio-img":"div-checkbox-img";
                            var itemStr = "";
                            for(var i=0;i<patchItemArr.length;i++){
                                if(patchItemArr[i]){
                                    prevItemCount = prevItemCount+1;
                                    itemStr += '<li class="choice" data-input="0" data-input-required="0" data-id="">'+
                                        '<div class="'+classz+'"></div>'+
                                        '<div class="position-relative">'+
                                        '<div class="edit-area edit-child-element" contenteditable="true" data-value="选项'+prevItemCount+'">'+
                                        patchItemArr[i]+
                                        '</div>'+
                                        '</div>'+
                                        '</li>';
                                }
                            }
                            appendItem.append(itemStr);
                            divPatchDialog.close();
                        }).on("click",".btn_patch_cancle",function(){//[批量添加选项框]框的弹框取消事件
                            divPatchDialog.close();
                        }).on("click",".a-clear-text",function(){//清空文本框
                            $("#div-patchDialog").find(".batch-choices").val("");
                        });
                    }).on("click",".operate .question-instruction",function(){//选项说明事件
                        var questionItem = $(this).closest(".topic-type-question");
                        self.$divInstructionDialog.find(".batch-choices").val(questionItem.find(".div-instruction-text input").val());//清空原来的值

                        divInstructionDialog = $.ligerDialog.open({
                            title: "问题说明",
                            width: 320,
                            height: 250,
                            target: self.$divInstructionDialog
                        });

                        //问题说明框的各个按钮操作
                        $("#div-instructionDialog").on("click",".btn_confirm",function(){//[问题说明框]框的确认按钮事件
                            if(self.$divInstructionDialog.find(".batch-choices").val().trim()==""){
                                if(questionItem.find(".div-instruction-text").length>0){
                                    questionItem.find(".div-instruction-text").remove();
                                }
                            }else{
                                var instruceVal =self.$divInstructionDialog.find(".batch-choices").val();
                                if(questionItem.find(".div-instruction-text").length>0){
                                    questionItem.find(".div-instruction-text input").val(instruceVal);
                                }else{
                                    var appendItem = questionItem.find(".add-area");
                                    if(appendItem.length==0){//填空题
                                        appendItem =  questionItem.find(".operate");
                                    }
                                    var instruceHtml = '<div class="div-padding c-border-top div-instruction-text"><input placeholder="说明：这是题目的具体说明文字内容" class="max-input-text" value="'+instruceVal+'"></div>';
                                    appendItem.before(instruceHtml);
                                }
                            }
                            divInstructionDialog.close();
                        }).on("click",".btn_cancle",function(){//[批量添加选项框]框的弹框取消事件
                            divInstructionDialog.close();
                        })
                    }).on("click",".operate .question-transform",function(){//选项转换事件
                        var questionItem = $(this).closest(".topic-type-question");
                        var type = questionItem.attr("data-type");//0：单选题 1：多选题
                        var typeStr = type=="0"?"问题当前为单选题，是否确认将问题转换为多选题？":"问题当前为多选题，是否确认将问题转换为单选题？";
                        $.ligerDialog.confirm(typeStr, function (yes) {
                            if(yes){
                                if(type=="0"){//单选题确认转换为多选题，则题目变更为多选题，选项内容各种属性不变
                                    questionItem.find(".div-radio-img").removeClass("div-radio-img").addClass("div-checkbox-img");
                                    if(questionItem.find(".operate .question-duoxuan").length==0){
                                        questionItem.find(".operate .question-transform").after('<li class="question-duoxuan" title="多选设置"></li>');
                                    }
                                    questionItem.attr("data-type","1");
                                }else if(type=="1"){//多选题转换为单选题，则题目变更为单选题，选项内容各种属性不变，多选设置清空
                                    questionItem.find(".div-checkbox-img").removeClass("div-checkbox-img").addClass("div-radio-img");
                                    if(questionItem.find(".operate .question-duoxuan").length>0){
                                        questionItem.find(".operate .question-duoxuan").remove();
                                    }
                                    questionItem.attr("data-type","0");
                                    questionItem.find(".question-title .required").html("");
                                    questionItem.attr("data-minValue","");//当前问题多选选项最小值
                                    questionItem.attr("data-maxValue","");//当前问题多选选项最大值
                                }
                            }

                        });
                    }).on("click",".operate .question-duoxuan",function(){//多选设置选项事件
                        var questionItem = $(this).closest(".topic-type-question");
                        var currentItemCount = questionItem.find(".question-choice li").length;//当前问题选项数
                        var minValue = questionItem.attr("data-minValue")=="undefined" || questionItem.attr("data-minValue")==undefined?"":questionItem.attr("data-minValue");
                        var maxValue = questionItem.attr("data-maxValue")=="undefined" || questionItem.attr("data-maxValue")==undefined?"":questionItem.attr("data-maxValue");
                        self.$divDuoXuanSettingDialog.find(".inp-min-value").val(minValue);
                        self.$divDuoXuanSettingDialog.find(".inp-max-value").val(maxValue);

                        divDuoXuanSettingDialog = $.ligerDialog.open({
                            title: "多选设置",
                            width: 320,
                            height: 250,
                            target: self.$divDuoXuanSettingDialog
                        });

                        //多选设置框的各个按钮操作
                        $("#div-duoxuanSettingDialog").on("click",".btn_confirm",function(){//[多选设置框]框的确认按钮事件
                            var minValue = $("#div-duoxuanSettingDialog").find(".inp-min-value").val();
                            var maxValue = $("#div-duoxuanSettingDialog").find(".inp-max-value").val();
                            if(minValue!="" &&　minValue>currentItemCount){
                                $("#div-duoxuanSettingDialog").find(".div-errorInfo").html("最少数不能超过当前选项数");
                                return false;
                            }
                            if(maxValue!="" &&　maxValue>currentItemCount){
                                $("#div-duoxuanSettingDialog").find(".div-errorInfo").html("最多数不能超过当前选项数");
                                return false;
                            }
                            if(minValue!="" && maxValue!="" && maxValue<minValue){//最多数不能少于最少数
                                $("#div-duoxuanSettingDialog").find(".div-errorInfo").html("最多数不能少于最少数");
                                return false;
                            }
                            $("#div-duoxuanSettingDialog").find(".div-errorInfo").html("");
                            questionItem.attr("data-minValue",minValue);
                            questionItem.attr("data-maxValue",maxValue);
                            var duoXuanItem = questionItem.find(".question-title").find(".required");
                            var duoXuanText = "";
                            if(minValue!="" && maxValue==""){
                                duoXuanText = "(至少选择"+minValue+"项)";
                            }else if(minValue=="" && maxValue!=""){
                                duoXuanText = "(最多选择"+maxValue+"项)";
                            }else if(minValue!="" && maxValue!=""){
                                duoXuanText = "(选择"+minValue+"~"+maxValue+"项)";
                            }
                            duoXuanItem.html(duoXuanText);
                            divDuoXuanSettingDialog.close();
                        }).on("click",".btn_cancle",function(){//[多选设置框]框的弹框取消事件
                            divDuoXuanSettingDialog.close();
                        })
                    })
                }
            };

            /* ************************* Dialog页面回调接口 ************************** */



            /* *************************** 页面初始化 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>