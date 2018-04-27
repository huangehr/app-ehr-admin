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
            var divpatchAddQuestionDialog = null;
            var divpreviewQuestionDialog = null;

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
            }

            /* *************************** 模块初始化 ***************************** */

            retrieve = {
                $divItem: $('.div-item'),//新增问题
                $editChildElementContent:$(".edit-child-element-content"),//更多操作图标
                $divMoreDialog:$("#div_MoreDialog"),
                $divPatchDialog:$("#div-patchDialog"),
                $divInstructionDialog:$("#div-instructionDialog"),
                $divDuoXuanSettingDialog:$("#div-duoxuanSettingDialog"),
                $divpatchAddQuestionDialog:$("#div-patchAddQuestionDialog"),
                $divpreviewQuestionDialog:$("#div-previewQuestionDialog"),
                init: function () {

                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                    //点击问题选项事件
                    $(".div-header").on("click",".div-item",function() {
                        var type = $(this).attr("data-type");//0:单选题,1：多选题 2：问答题
                        var questionData = [];
                        if(type=="0"){//单选题
                            questionData = [{title:"单选题",optionData:["选项1","选项2"]}];
                        }else if(type=="1"){//多选题
                            questionData = [{title:"多选题",optionData:["选项1","选项2"]}]
                        }else{//问答题
                            questionData = [{title:"问答题",optionData:[]}]
                        }
                        self.addMutipleQuestion(questionData,type);//添加题目
                        $(".div-right-empty").hide();
                        $("#question_box").show();
                        $("#question_box").scrollTop($("#question_box")[0].scrollHeight);
                    });

                    //点击问题选项事件
                    $("#question_box").on("click",".question-title .qs-content,.question-choice .edit-area",function() {
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
                    $("#question_box").on("click",".question-choice .edit-img .handle-child-element",function() {
                        var activeItem =  $(this).closest(".edit-img").closest(".choice");
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
                    $("#question_box").on("click",".question-choice .edit-img .remove-child-element",function(){
                        if($(this).closest(".question-choice").find(".choice").length==2){
                            $.Notice.error('需至少有两个选项');
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

                    $("#question_box").on("click",".topic-type-question .add-area .add-choice",function(){//增加选项事件
                        self.clearButtonsActive();
                        var appendItem = $(this).closest(".topic-type-question").find(".question-choice");
                        var prevItemCount = appendItem.find("li").length+1;
                        var classz = $(this).closest(".topic-type-question").attr("data-type")=="0"?"div-radio-img":"div-checkbox-img";
                        var item = '<li class="choice" data-input="0" data-input-required="0" data-id="'+prevItemCount+'">'+
                            '<div class="'+classz+'"></div>'+
                            '<div class="position-relative">'+
                            '<div class="edit-area edit-child-element" contenteditable="true" data-value="">'+
                            '选项'+prevItemCount+
                            '</div>'+
                            '</div>'+
                            '</li>';
                        appendItem.append(item);
                    }).on("click",".add-area .batch-add-choice",function(){//批量增加选项事件
                        self.clearButtonsActive();
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
                                    itemStr += '<li class="choice" data-input="0" data-input-required="0" data-id="'+prevItemCount+'">'+
                                        '<div class="'+classz+'"></div>'+
                                        '<div class="position-relative">'+
                                        '<div class="edit-area edit-child-element" contenteditable="true" data-value="">'+
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
                        self.clearButtonsActive();
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
                            debugger
                            if($("#div-instructionDialog").find(".batch-choices").val().trim()==""){
                                if(questionItem.find(".div-instruction-text").length>0){
                                    questionItem.find(".div-instruction-text").remove();
                                }
                            }else{
                                var instruceVal = $("#div-instructionDialog").find(".batch-choices").val();
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
                        self.clearButtonsActive();
                        var questionItem = $(this).closest(".topic-type-question");
                        var type = questionItem.attr("data-type");//0：单选题 1：多选题
                        var typeStr = type=="0"?"问题当前为单选题，是否确认将问题转换为多选题？":"问题当前为多选题，是否确认将问题转换为单选题？";
                        $.ligerDialog.confirm(typeStr, function (yes) {
                            if(yes){
                                if(type=="0"){//单选题确认转换为多选题，则题目变更为多选题，选项内容各种属性不变
                                    questionItem.find(".div-radio-img").removeClass("div-radio-img").addClass("div-checkbox-img");
                                    if(questionItem.find(".operate .question-duoxuan").length==0){
                                        questionItem.find(".operate .question-delete").before('<li class="question-duoxuan" title="多选设置"></li>');
                                    }
                                    questionItem.attr("data-type","1");
                                }else if(type=="1"){//多选题转换为单选题，则题目变更为单选题，选项内容各种属性不变，多选设置清空
                                    questionItem.find(".div-checkbox-img").removeClass("div-checkbox-img").addClass("div-radio-img");
                                    if(questionItem.find(".operate .question-duoxuan").length>0){
                                        questionItem.find(".operate .question-duoxuan").remove();
                                    }
                                    questionItem.attr("data-type","0");
                                    questionItem.attr("data-minValue","");//当前问题多选选项最小值
                                    questionItem.attr("data-maxValue","");//当前问题多选选项最大值
                                }
                            }

                        });
                    }).on("click",".operate .question-duoxuan",function(){//多选设置选项事件
                        self.clearButtonsActive();
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
                    }).on("click",".operate .question-delete",function(){//删除选项事件
                        self.clearButtonsActive();
                        var item = $(this).closest(".topic-type-question");
                        $.ligerDialog.confirm('删除此题？', function (yes) {
                            item.remove();
                            if($("#question_box").find(".topic-type-question").length==0){
                                $(".div-right-empty").show();
                                $("#question_box").hide();
                            }
                        });
                    })

                    $(".inp-min-value,.inp-max-value").on("keyup",function() {//多选设置框的最大值和最小值输入事件
                        var str = $(this).val();
                        if(/^[0-9]\d*$/.test(str)){ //验证是否纯数字
                            str = str.replace(/^0*/g,''); //把开头的N个0替换成空
                            $(this).val(str)
                        }else{
                            str = str.replace(/[^\d]/g,'');//把不是数字的替换成空
                            $(this).val(str);
                        }
                    });

                    $(".div-bottom").on("click","#patch_add_btn",function(){//批量添加问题事件
                        self.clearButtonsActive();
                        var patchTextAreaVal = self.$divpatchAddQuestionDialog.find(".div-patch-textarea");
                        patchTextAreaVal.val("");
                        if(patchTextAreaVal.val()==""){
                            patchTextAreaVal.val("单选题题目\n选项1\n选项2");
                        }
                        divpatchAddQuestionDialog = $.ligerDialog.open({
                            title: "批量添加问题",
                            width: 620,
                            height: 560,
                            target: self.$divpatchAddQuestionDialog
                        });

                        $("#div-patchAddQuestionDialog").on("click",".btn_confirm",function(){//[批量添加问题]框的弹框确定事件
                            if($("#div-patchAddQuestionDialog").find(".div-patch-textarea").val().trim()==""){
                                return false;
                            }
                            var patchQuestion = $("#div-patchAddQuestionDialog").find(".div-patch-textarea").val().split("\n");
                            var questionStr = "";
                            for(var i=0;i<patchQuestion.length;i++){
                                var item = patchQuestion[i];
                                if(item==""){//空行，表示问题的结束
                                    questionStr+=item+"END";
                                }else{
                                    questionStr+=item+"@@";
                                }
                            }
                            var questionArr = questionStr.split("END");
                            var radioButtonList = [];//单选题
                            var multipleChoiceQuestion = [];//多选题
                            var questionAndAnswer = [];//问答题
                            for(var i=0;i<questionArr.length;i++){
                                if(questionArr[i]==""){
                                    continue;
                                }
                                var itemArr = questionArr[i].split("@@");
                                itemArr.splice(itemArr.length-1,1);
                                var optionData = [];
                                var title = "";
                                for(var j=0;j<itemArr.length;j++){
                                    if(j==0) {title = itemArr[j];}
                                    else {optionData.push(itemArr[j]);}
                                }
                                //以下进行题目归类
                                var questionItem = {title:title,optionData:optionData};
                                if(questionArr[i].indexOf("[单选题]")>0 || questionArr[i].indexOf("【单选题】")>0){//单选题
                                    questionItem.title=questionItem.title.toString().replace("[单选题]","").replace("【单选题】","");
                                    radioButtonList.push(questionItem);
                                }else if(questionArr[i].indexOf("[多选题]")>0 || questionArr[i].indexOf("【多选题】")>0){//多选题
                                    questionItem.title=questionItem.title.toString().replace("[多选题]","").replace("【多选题】","");
                                    multipleChoiceQuestion.push(questionItem);
                                }else if((questionArr[i].indexOf("[问答题]")>0 || questionArr[i].indexOf("【问答题】")>0) && itemArr.length==1){//问答题
                                    questionItem.title=questionItem.title.toString().replace("[问答题]","").replace("【问答题】","");
                                    questionAndAnswer.push(questionItem);
                                }else{//单选题或问答题
                                    if(optionData.length>0){
                                        radioButtonList.push(questionItem);
                                    }else{
                                        questionAndAnswer.push(questionItem);
                                    }
                                }
                            }
                            self.addMutipleQuestion(radioButtonList,"0");//添加单选题
                            self.addMutipleQuestion(multipleChoiceQuestion,"1");//添加多选题
                            self.addMutipleQuestion(questionAndAnswer,"2");//添加问答题
                            $(".div-right-empty").hide();
                            $("#question_box").show();
                            divpatchAddQuestionDialog.close();
                        }).on("click",".a-clear-text",function(){//清空文本框
                            $("#div-patchAddQuestionDialog").find(".div-patch-textarea").val("");
                        });

                    }).on("click","#preview_btn",function(){//预览问题事件
                        self.clearButtonsActive();
                        if($("#question_box").find(".topic-type-question").length==0){
                            $.Notice.success('当前没有问题，请添加后再预览！');
                            return false;
                        }
                        divpreviewQuestionDialog = $.ligerDialog.open({
                            title: "问题预览",
                            width: 620,
                            height: 560,
                            target: self.$divpreviewQuestionDialog
                        });
                        var previewData = self.previewQuestion();

                        $("#div-previewQuestionDialog").on("click","#inp_back_update",function(){//返回修改事件
                            divpreviewQuestionDialog.close();
                        }).on("click","#inp_save",function(){//保存问题事件
                            self.saveQuestion(previewData);
                        })
                    }).on("click","#save_btn",function(){//保存问题事件
                        self.clearButtonsActive();
                        if($("#question_box").find(".topic-type-question").length==0){
                            $.Notice.success('当前没有问题，请添加后再保存！');
                            return false;
                        }
                        $.ligerDialog.confirm('是否确认保存当前编辑所有问题？', function (yes) {
                            if(yes){
                                var resultData = [];
                                var topicTypeQuestion =   $("#question_box").find(".topic-type-question");
                                for(var i=0;i<topicTypeQuestion.length;i++){
                                    var item = $(topicTypeQuestion[i]);
                                    var title = item.find(".edit-title").html();//问题标题
                                    var comment = item.find(".div-instruction-text input").length>0?item.find(".div-instruction-text input").val():null;//问题说明
                                    var questionType = parseInt(item.attr("data-type"));//问题类型（0单选 1多选 2问答）
                                    var minNum = item.attr("data-minvalue")==""?null: item.attr("data-minvalue");//最小答案个数（多选有效）
                                    var maxNum = item.attr("data-maxvalue")==""?null: item.attr("data-maxvalue");//最大答案个数（多选有效）
                                    var optionData = [];
                                    if(questionType!=2){
                                        var optionItem = item.find(".question-choice").find("li");
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
                                    resultData.push({"title": title,"comment": comment,"questionType": questionType,"minNum": minNum,"maxNum": maxNum,"optionData": optionData})
                                }

                                self.saveQuestion(resultData);
                            }
                        });

                    });

                },
                clearButtonsActive:function(){//移除选项选中框
                    if($(".position-relative").find(".edit-img").length>0) $(".position-relative").find(".edit-img").remove();//移除选项选中框
                    $(".question-title .qs-content").removeClass("edit-area-active");
                    $(".question-choice .edit-area").removeClass("edit-area-active");
                },
                saveQuestion:function(resultData){
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
                        dataType: "json",
                        success: function (data) {
                            debugger
                            if (data.successFlg) {
                                $.Notice.success(data.msg);
//                                跳转问题列表
                                location.href = '${contextRoot}/survey/questionList';
                            } else {
                                $.Notice.error(data.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                },
                addMutipleQuestion: function(data,type){
                    var questionId = "";
                    var resultHtml = "";
                    for(var i=0;i<data.length;i++){
                        var titleData = data[i].title;//标题
                        var optionData = data[i].optionData;//选项
                        var titleHtml = '<div class="topic-type-content topic-type-question after-clear" data-type="'+type+'">'+
                            '<div class="question-title">'+
                            '<span class="required"></span>'+
                            '<div class="position-relative" style="width: calc(100% - 75px);">'+
                            '<div class="qs-content edit-area edit-title"  contenteditable="true" data-value="">'+
                            titleData +
                            '</div>'+
                            '</div>'+
                            '</div>';
                        var optionHtml = '<ul class="question-choice">';
                        var itemHtml = "";
                        var addAreaHtml = "";
                        var operateHtml = "";
                        if(optionData.length==0){
                            optionData = ["选项1","选项2"];
                        }else if(optionData.length==1){
                            optionData.push("选项2");
                        }
                        //问题选项
                        for(var j = 0;j<optionData.length;j++){
                            questionId = j+1;
                            if(type=="0" || type=="1"){//单选题或多选题
                                var imgClass = type=="0"?"div-radio-img":"div-checkbox-img";
                                itemHtml+='<li class="choice" data-input="0" data-input-required="0" data-id="'+questionId+'">'+
                                    '<div class="'+imgClass+'"></div>'+
                                    '<div class="position-relative">'+
                                    '<div class="edit-area edit-child-element" contenteditable="true" data-value="">'+
                                    optionData[j] +
                                    '</div>'+
                                    '</div>'+
                                    '</li>';
                            }else{//问答题
                                itemHtml = '<li class="choice" data-input="0" data-input-required="0" data-id="'+questionId+'">'+
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
                                    '<li class="question-delete" title="删除"></li>'+
                                    '</ul>'+
                                    '</div>';
                            }else{//多选题
                                operateHtml = '<div class="operate visible-show">'+
                                    '<ul>'+
                                    '<li class="question-instruction" title="说明"></li>'+
                                    '<li class="question-transform" title="转换"></li>'+
                                    '<li class="question-duoxuan" title="多选设置"></li>'+
                                    '<li class="question-delete" title="删除"></li>'+
                                    '</ul>'+
                                    '</div>';
                            }
                        }else{//问答题
                            operateHtml = '<div class="operate visible-show">'+
                                '<ul>'+
                                '<li class="question-instruction" title="说明"></li>'+
                                '<li class="question-delete" title="删除"></li>'+
                                '</ul>'+
                                '</div>';
                        }

                        resultHtml+=titleHtml+optionHtml+addAreaHtml+operateHtml+"</div>";
                    }
                    $("#question_box").append(resultHtml);

                },
                previewQuestion:function(){
                    var resultHtml = "";
                    var resultData = [];
                    var topicTypeQuestion =   $("#question_box").find(".topic-type-question");
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
                        resultData.push({"title": title,"comment": comment,"questionType": questionType,"minNum": minNum,"maxNum": maxNum,"optionData": optionData})
                    }

                    for(var i=0;i<resultData.length;i++){
                        var titleData = resultData[i].title;//标题
                        var optionData = resultData[i].optionData;//选项
                        var comment = resultData[i].comment;
                        var questionType = resultData[i].questionType;//问题类型（0单选 1多选 2问答）
                        var minNum = resultData[i].minNum;
                        var maxNum = resultData[i].maxNum;
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
                            optionData = ["选项1","选项2"];
                        }else if(optionData.length==1){
                            optionData.push("选项2");
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
                    }

                    $("#div-previewQuestionDialog").find(".div-preview-content").html(resultHtml);
                    return resultData;
                }





            };

            /* ************************* Dialog页面回调接口 ************************** */


            /* *************************** 页面初始化 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>