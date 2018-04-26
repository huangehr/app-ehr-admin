<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/plugin/jquery-ui/jquery-ui.js"></script>

<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var retrieve = null;
            var preview = null;
            var master = null;
            var isFirstPage = false;
            var divMoreDialog = null;
            var divPatchDialog = null;
            var divInstructionDialog = null;
            var divDuoXuanSettingDialog = null;
            var divpatchAddQuestionDialog = null;
            var divpreviewQuestionDialog = null;
            var divSeeQuestionDialog = null;
            var divRequredDialog = null;
            var divImportQuesDialog = null;
            var divLuojiSettingDialog = null;
            var questionType = "";
            var templateData = JSON.parse(sessionStorage.getItem("templateData"));//上一个页面（新增或编辑模板页传过来的信息：问卷名称、问卷说明、问卷标签）
            console.log(templateData)
            debugger
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                $(".div-template-name").html(templateData.title);
                $(".div-template-comment").html(templateData.comment);
                if(templateData.templateId!=""){
                    var  value = {
                        id:templateId,
                        question:"1"
                    }
                    var params =  JSON.stringify(value);
                    $.ajax({
                        url: '${contextRoot}/survey/allMethod',
                        data: {
                            redicUrl:'/basic/api/v1.0/admin/surveyTemplate/getTemplateById',
                            postOrGet:'get',
                            paramJson:params
                        },//question 是否加载问题：1加载 0 不加载
                        method: "get",
                        dataType: "json",
                        success: function (data) {
                            if (data.successFlg) {
                                retrieve.importedQuestion(data.obj.questions,false);
                            } else {
                                $.Notice.error(data.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                }
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
                $divSeeQuestionDialog:$("#div-seeQuestionDialog"),
                $divRequredDialog:$("#div_requred_Dialog"),
                $divImportQuesDialog:$("#div-importQuesDialog"),
                $divLuojiSettingDialog:$("#div-luojiSettingDialog"),
                init: function () {

                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                    //左侧题型选择事件
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
                        self.clearButtonsActive();
                        if($(this).html().trim()==$(this).attr("data-value")){
                            $(this).html("");
                        }
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
                        var dataInput = activeItem.attr("data-input");//0：没有文本框 1 有文本框
                        var dataInputRequired = activeItem.attr("data-input-required");//0：非必输 1：必输
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
                    }).on("click",".question-choice .edit-img .remove-child-element",function(){//删除选项事件
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

                    //移动事件
                    $("#question_box").sortable({
                        cursor: "move",
                        connectWith: "#question_box",
                        handle: ".drag-area",
                        opacity: 0.8, //拖动时，透明度为0.8
                        revert: true, //释放时，增加动画
                        start: function( event, ui ) {
                            var item = ui.item;
                            var checkQuestionLogic = item.attr("data-logicdata");//是否有逻辑规则设置
                            if(checkQuestionLogic!="" && checkQuestionLogic!=undefined){//该题已设置逻辑规则
                                $.ligerDialog.confirm('该题有关联的逻辑规则，移动题目会导致规则失效，确认移动？', function (yes) {
                                    if(yes){//确定
                                        self.sortQuestions();
                                        item.attr("data-logicdata","");
                                    }else{//取消
                                        $("#question-box").sortable("cancel");
                                        $("#question_box").find(".topic-type-question[data-code="+item.attr("data-code")+"]").remove();
                                        $("#question_box").find(".topic-type-question:first").before(item);
                                        self.sortQuestions();
                                    }
                                });
                            }else{
                                $("#question-box").sortable({
                                    stop: function() {
                                        self.sortQuestions();
                                    }
                                })
                            }
                        },
                        stop: function() {
                            self.sortQuestions();
                        }
                    });

                    $("#question_box").on("click",".topic-type-question .add-area .add-choice",function(){//增加选项事件
                        self.clearButtonsActive();
                        var appendItem = $(this).closest(".topic-type-question").find(".question-choice");
                        var prevItemCount = appendItem.find(".choice").length+1;
                        var classz = $(this).closest(".topic-type-question").attr("data-type")=="0"?"div-radio-img":"div-checkbox-img";
                        var optionCode = self.getUUID();//选项code
                        var item = '<li class="choice" data-input="0" data-input-required="0" data-code="'+optionCode+'">'+
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
                            var prevItemCount = appendItem.find(".choice").length;
                            var classz = questionItem.attr("data-type")=="0"?"div-radio-img":"div-checkbox-img";
                            var itemStr = "";
                            var optionCode = self.getUUID();//选项code
                            for(var i=0;i<patchItemArr.length;i++){
                                if(patchItemArr[i]){
                                    prevItemCount = prevItemCount+1;
                                    itemStr += '<li class="choice" data-input="0" data-input-required="0" data-code="'+optionCode+'">'+
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
                    }).on("click",".question-setting",function(){//逻辑设置事件
                        self.clearButtonsActive();
                        var questionSettingItem = $(this).closest(".topic-type-question");
                        var questionType = questionSettingItem.attr("data-type");//问题类型0：单选题 1：多选题 2：问答题
                        var questionCode = questionSettingItem.attr("data-code");
                        var dataLogic = (questionSettingItem.attr("data-logicdata")==undefined || questionSettingItem.attr("data-logicdata")=="") ?"":JSON.parse(questionSettingItem.attr("data-logicdata"));//逻辑设置保存的数据
                        //添加题目选项
                        var allQuestions = $("#question_box").find(".topic-type-question");//所有问题值
                        var questionsStr = '<option value="-1">请选择题目</option>';//所有问题
                        for(var i=0;i<allQuestions.length;i++){
                            if(questionCode!=$(allQuestions[i]).attr("data-code")){
                                questionsStr += '<option value="'+$(allQuestions[i]).attr("data-code")+'" data-sort="'+i+'">'+$(allQuestions[i]).find(".question-title .edit-title").html()+'</option>';
                            }
                        }
                        questionsStr+= '<option value="0">提前结束</option>';
                        //添加单选题或多选题的当前问题选项值
                        var optionsStr = '<option value="-1">请选择选项</option>';//所有选项
                        if(questionType=="0" || questionType=="1"){
                            var curAllOptions = $(this).closest(".topic-type-question").find(".question-choice .choice");//当前问题所有选项值
                            for(var i=0;i<curAllOptions.length;i++){
                                optionsStr += '<option value="'+$(curAllOptions[i]).attr("data-code")+'">'+$(curAllOptions[i]).find(".edit-child-element").html()+'</option>';
                            }
                            optionsStr+= '<option value="0">任意项</option>';
                        }
                        if(dataLogic==""){
                            var optionItem = '<div>'+
                                '<span class="mr8">如果本题中选中/填写</span>'+
                                '<select class="allOptions">'+optionsStr+'</select>'+
                                '<span class="mr8 ml7">则跳转到</span>'+
                                '<select class="allQuestions">'+questionsStr+'</select>'+
                                '</div>'+
                                '<div  class="delete-img f-dn"></div>';
                            if(questionType=="1" || questionType=="2"){//多选题或问答题
                                optionItem =  '<div>'+
                                    '<span class="mr8">如果本题中填写任意内容，则跳转到</span>'+
                                    '<select class="allQuestions">'+questionsStr+'</select>'+
                                    '</div>';
                            }
                            var addItem = '<div class="m-form-group f-mt10 div-setting-item">'+
                                '<div class="m-form-control f-fs12 f-ml10" style="position: relative;">'+
                                optionItem +
                                '</div>'+
                                '</div>';
                            self.$divLuojiSettingDialog.find(".m-form-group").not(".div-add-setting-bottom").not(".div-bottom-group").remove();
                            self.$divLuojiSettingDialog.find(".m-retrieve-area").find(".div-add-setting-bottom").before(addItem);
                            if(questionType=="0"){//单选题
                                self.$divLuojiSettingDialog.find(".div-add-setting-bottom").show();
                            }
                        }else{
                            self.$divLuojiSettingDialog.find(".m-form-group").not(".div-add-setting-bottom").remove();
                            var questionsItemData = dataLogic.questionsItemData;
                            var options = dataLogic.options;
                            if(questionsItemData.length>0 || options.length>0){
                                var settingData = questionsItemData;
                                if(options.length>0){
                                    settingData = options;
                                }
                                self.$divLuojiSettingDialog.find(".m-form-group").not(".div-add-setting-bottom").not(".div-bottom-group").remove();
                                for(var i=0;i<settingData.length;i++){
                                    var optionItem = '<div>'+
                                        '<span class="mr8">如果本题中选中/填写</span>'+
                                        '<select class="allOptions">'+optionsStr+'</select>'+
                                        '<span class="mr8 ml7">则跳转到</span>'+
                                        '<select class="allQuestions">'+questionsStr+'</select>'+
                                        '</div>'+
                                        '<div  class="delete-img f-dn"></div>';
                                    if(questionType=="1" || questionType=="2"){//多选题或问答题
                                        optionItem =  '<div>'+
                                            '<span class="mr8">如果本题中填写任意内容，则跳转到</span>'+
                                            '<select class="allQuestions">'+questionsStr+'</select>'+
                                            '</div>';
                                    }
                                    var addItem = '<div class="m-form-group f-mt10 div-setting-item">'+
                                        '<div class="m-form-control f-fs12 f-ml10" style="position: relative;">'+
                                        optionItem +
                                        '</div>'+
                                        '</div>';
                                    self.$divLuojiSettingDialog.find(".m-retrieve-area").find(".div-add-setting-bottom").before(addItem);
                                    if(questionsItemData.length>0){
                                        self.$divLuojiSettingDialog.find(".m-retrieve-area").find(".allOptions").val("0");
                                        self.$divLuojiSettingDialog.find(".m-retrieve-area").find(".allQuestions").val(questionsItemData[0].questionCodeNext);
                                    }else{
                                        self.$divLuojiSettingDialog.find(".m-retrieve-area").find(".div-setting-item").eq(i).find(".allOptions").val(settingData[i].optionItem);
                                        self.$divLuojiSettingDialog.find(".m-retrieve-area").find(".div-setting-item").eq(i).find(".allQuestions").val(settingData[i].questionCodeNext);
                                    }
                                    if(questionType=="0"){
                                        //1、当当前已有条件少于选项数时，有新增按钮;2、当当前已有条件大于1时，条件右侧有删除按钮
                                        var conditionCount = self.$divLuojiSettingDialog.find(".div-setting-item").length;//条件数
                                        var optionCount = curAllOptions.length;//选项数(不包含请选择选项、任意性)
                                        if(conditionCount<optionCount){//单选题才有添加按钮
                                            self.$divLuojiSettingDialog.find(".div-add-setting-bottom").show();
                                        }
                                        if(conditionCount>1){
                                            self.$divLuojiSettingDialog.find(".div-setting-item").find(".delete-img").show();
                                        }
                                    }
                                }
                            }
                        }
                        divLuojiSettingDialog = $.ligerDialog.open({
                            title: "逻辑设置",
                            width: 620,
                            height: 400,
                            target: self.$divLuojiSettingDialog
                        });

                        $("#div-luojiSettingDialog").on("click",".btn_confirm",function(){//[逻辑设置]框的确认按钮事件
                            var logicData = {};
                            var renyiOption = 0;//计算选择任意项的个数
                            var otherOption = 0;//计算选择其他项的个数
                            var noOption = 0;//计算没有选择项的个数
                            var isSameOption = [];

                            var renyiQuestion = 0;//计算选择任意项的个数
                            var otherQuestion = 0;//计算选择其他项的个数
                            var noQuestion = 0;//计算没有选择项的个数
                            self.$divLuojiSettingDialog.find(".allOptions").each(function() {
                                if($(this).val()=="0"){//选择了任意项
                                    renyiOption++;
                                }else if($(this).val()=="-1"){//未选中项
                                    noOption++;
                                }else{
                                    otherOption++;
                                }
                                isSameOption.push($(this).val());
                            });
                            var questionItem =  self.$divLuojiSettingDialog.find(".div-setting-item").find(".allQuestions");
                            questionItem.each(function() {
                                if($(this).val()=="0"){//选择了提前结束
                                    renyiQuestion++;
                                }else if($(this).val()=="-1"){//未选中问题项
                                    noQuestion++;
                                }else{
                                    otherQuestion++;
                                }
                            });
                            if(noOption!=0 || noQuestion!=0){//有未选择的项
                                $.Notice.error('请选择项！');
                                return false;
                            }
                            if(renyiOption>0 && otherOption>0){//选择了任意项，同时选了其他选项
                                $.Notice.error('已选任意项，不可同时选择选其他项！');
                                return false;
                            }
                            if(self.unique(isSameOption).length!=self.$divLuojiSettingDialog.find(".allOptions").length){
                                $.Notice.error('条件不可同时选一个选项！');
                                return false;
                            }
                            var options = [];
                            var questionsItemData= [];
                            if(renyiOption>0){//逻辑设置只设置了一个条件
                                var questionValueItem = self.$divLuojiSettingDialog.find(".div-setting-item").find(".allQuestions");
                                var questionSortName = "";
                                if(questionValueItem.val()=="0"){
                                    questionSortName = "（问卷结束）";
                                }else{
                                    questionSortName = "（跳转至第"+parseInt(questionValueItem.find("option:selected").attr("data-sort"))+1+"题）";
                                }
                                questionsItemData.push({questionCodeNext:questionValueItem.val(),questionSortNext:questionSortName});
                            }else{
                                if(questionType=="0"){//单选题
                                    var allOptions = self.$divLuojiSettingDialog.find(".allOptions");
                                    var allQuestions = self.$divLuojiSettingDialog.find(".div-setting-item").find(".allQuestions");
                                    for(var i=0;i<allOptions.length;i++){
                                        var questionSortName = "";
                                        if($(allQuestions[i]).val()=="0"){
                                            questionSortName = "（问卷结束）";
                                        }else{
                                            questionSortName = "（跳转至第"+(parseInt($(allQuestions[i]).find("option:selected").attr("data-sort"))+1)+"题）";
                                        }
                                        options.push({optionItem:$(allOptions[i]).val(),questionCodeNext:$(allQuestions[i]).val(),questionSortNext:questionSortName});
                                    }
                                }else{//多选题或问答题
                                    var questionValueItem = self.$divLuojiSettingDialog.find(".div-setting-item").find(".allQuestions");
                                    var questionSortName = "";
                                    if(questionValueItem.val()=="0"){
                                        questionSortName = "（问卷结束）";
                                    }else{
                                        questionSortName = "（跳转至第"+(parseInt(questionValueItem.find("option:selected").attr("data-sort"))+1)+"题）";
                                    }
                                    questionsItemData.push({questionCodeNext:questionValueItem.val(),questionSortNext:questionSortName});
                                }
                            }
                            logicData = {questionsItemData:questionsItemData,options:options};
                            questionSettingItem.attr("data-logicData",JSON.stringify(logicData));
                            divLuojiSettingDialog.close();
                        }).on("click",".btn_cancle",function(){//[逻辑设置]框的弹框取消事件
                            divLuojiSettingDialog.close();
                        }).on("click",".delete-img",function(){//[逻辑设置]框的弹框删除项事件
                            $(this).closest(".div-setting-item").remove();
                            var conditionCount = self.$divLuojiSettingDialog.find(".div-setting-item").length;//条件数
                            self.$divLuojiSettingDialog.find(".div-setting-item").find(".delete-img").hide();
                            if(conditionCount>1){
                                self.$divLuojiSettingDialog.find(".div-setting-item").find(".delete-img").show();
                            }
                        }).on("click",".add-img",function(){//[逻辑设置]框的添加项事件
                            var optionItem = '<div>'+
                                '<span class="mr8">如果本题中选中/填写</span>'+
                                '<select class="allOptions">'+optionsStr+'</select>'+
                                '<span class="mr8 ml7">则跳转到</span>'+
                                '<select class="allQuestions">'+questionsStr+'</select>'+
                                '</div>'+
                                '<div  class="delete-img f-dn"></div>';
                            if(questionType=="1" || questionType=="2"){//多选题或问答题
                                optionItem =  '<div>'+
                                    '<span class="mr8">如果本题中填写任意内容，则跳转到</span>'+
                                    '<select class="allQuestions">'+questionsStr+'</select>'+
                                    '</div>';
                            }
                            var addItem = '<div class="m-form-group f-mt10 div-setting-item">'+
                                '<div class="m-form-control f-fs12 f-ml10" style="position: relative;">'+
                                optionItem +
                                '</div>'+
                                '</div>';
                            self.$divLuojiSettingDialog.find(".div-setting-item:last").after(addItem);
                            self.$divLuojiSettingDialog.find(".div-luoji-content").scrollTop(self.$divLuojiSettingDialog.find(".div-luoji-content")[0].scrollHeight);
                            var conditionCount = self.$divLuojiSettingDialog.find(".div-setting-item").length;//条件数
                            if(conditionCount>1){
                                self.$divLuojiSettingDialog.find(".div-setting-item").find(".delete-img").show();
                            }
                        })
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
                            if(self.$divInstructionDialog.find(".batch-choices").val().trim()==""){
                                if(questionItem.find(".div-instruction-text").length>0){
                                    questionItem.find(".div-instruction-text").remove();
                                }
                            }else{
                                var instruceVal = self.$divInstructionDialog.find(".batch-choices").val();
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
                                    questionItem.find(".question-title .required").html("");
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
                            var minValue = self.$divDuoXuanSettingDialog.find(".inp-min-value").val();
                            var maxValue = self.$divDuoXuanSettingDialog.find(".inp-max-value").val();
                            if(minValue!="" &&　minValue>currentItemCount){
                                self.$divDuoXuanSettingDialog.find(".div-errorInfo").html("最少数不能超过当前选项数");
                                return false;
                            }
                            if(maxValue!="" &&　maxValue>currentItemCount){
                                self.$divDuoXuanSettingDialog.find(".div-errorInfo").html("最多数不能超过当前选项数");
                                return false;
                            }
                            if(minValue!="" && maxValue!="" && maxValue<minValue){//最多数不能少于最少数
                                self.$divDuoXuanSettingDialog.find(".div-errorInfo").html("最多数不能少于最少数");
                                return false;
                            }
                            self.$divDuoXuanSettingDialog.find(".div-errorInfo").html("");
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
                    }).on("click",".operate .question-required",function(){//问题必答设置事件
                        self.clearButtonsActive();
                        var questionItem = $(this).closest(".topic-type-question");
                        if(questionItem.find(".wt-required").html()!=""){
                            self.$divRequredDialog.find(".div-select-checkbox img").attr("src","${ctx}/static/develop/images/yigouxuan_icon.png").addClass("active");
                        }else{
                            self.$divRequredDialog.find(".div-select-checkbox img").attr("src","${ctx}/static/develop/images/weigouxuan_icon.png").removeClass("active");
                        }

                        divRequredDialog = $.ligerDialog.open({
                            title: "问题必答设置",
                            width: 320,
                            height: 180,
                            target: self.$divRequredDialog
                        });

                        //问题必答设置框的各个按钮操作
                        $("#div_requred_Dialog").on("click",".btn_confirm",function(){//[问题必答设置]框的确认按钮事件
                            if(self.$divRequredDialog.find(".div-select-checkbox img").hasClass("active")){
                                questionItem.find(".wt-required").html("*");
                            }else{
                                questionItem.find(".wt-required").html("");
                            }
                            divRequredDialog.close();
                        }).on("click",".btn_cancle",function(){//[多选设置框]框的弹框取消事件
                            divRequredDialog.close();
                        }).on("click",".div-select-checkbox",function(){
                            if(!self.$divRequredDialog.find(".div-select-checkbox img").hasClass("active")){
                                self.$divRequredDialog.find(".div-select-checkbox img").attr("src","${ctx}/static/develop/images/yigouxuan_icon.png").addClass("active");
                            }else{
                                self.$divRequredDialog.find(".div-select-checkbox img").attr("src","${ctx}/static/develop/images/weigouxuan_icon.png").removeClass("active");
                            }
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
                            self.sortQuestions();
                        });
                    })

                    //底部各个按钮事件
                    $(".div-bottom").on("click","#import_btn",function(){//问题库导入事件
                        self.clearButtonsActive();
                        divImportQuesDialog = $.ligerDialog.open({
                            title: "问题库导入",
                            width: 650,
                            height: 630,
                            url: ctx + '/admin/surveyTemplate/importQuestion'
                        });

                    }) .on("click","#patch_add_btn",function(){//批量添加问题事件
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
                    }).on("click","#preview_btn",function(){//预览模板事件
                        self.clearButtonsActive();

                        if($("#question_box").find(".topic-type-question").length==0){
                            $.Notice.success('当前没有问题，请添加后再预览！');
                            return false;
                        }
                        if($(".div-wenjuan-title").find(".div-template-name").html().trim()=="这是问卷名称，点击可编辑"){
                            $.Notice.success('请填写问卷名称');
                            return false;
                        }
                        if($(".div-wenjuan-title").find(".div-template-comment").html().trim()=="这是问卷说明文字，点击可编辑"){
                            $.Notice.success('请填写问卷说明文字');
                            return false;
                        }
                        divpreviewQuestionDialog = $.ligerDialog.open({
                            title: "预览模板",
                            width: 620,
                            height: 600,
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
                                var resultData = self.getSaveingData();
                                self.saveQuestion(resultData);
                            }
                        });

                    });

                },
                sortQuestions:function(){//排序问题
                    var orderCount = 0;
                    $('#question_box .question-title .span-order').each(function() {
                        orderCount++;
                        $(this).html("Q"+orderCount);
                    })
                },
                getUUID:function(){//生成全局唯一标识符
                    var d = new Date().getTime();
                    var uuid = 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                        var r = (d + Math.random()*16)%16 | 0;
                        d = Math.floor(d/16);
                        return (c=='x' ? r : (r&0x3|0x8)).toString(16);
                    });
                    return uuid;
                },
                saveQuestion:function(resultData){
                    var resData = JSON.stringify(resultData);
                    var turn = {
                        jsonData:resData,
                        userId:""
                    }
                    var parms = JSON.stringify(turn);
                    $.ajax({
                        url: "${contextRoot}/survey/allMethod",
                        data: {
                            redicUrl:'/basic/api/v1.0/admin/surveyTemplate/saveTemplate',
                            postOrGet:'post',
                            paramJson:parms
                        },
                        method: "post",
                        dataType: "json",
                        success: function (data) {
                            if (data.successFlg) {
                                $.Notice.success(data.msg);
                                location.href ='${contextRoot}/survey/templateList';
                            } else {
                                $.Notice.error(data.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                },
                unique:function(arr){
                    // 遍历arr，把元素分别放入tmp数组(不存在才放)
                    var tmp = new Array();
                    for(var i in arr){
                        //该元素在tmp内部不存在才允许追加
                        if(tmp.indexOf(arr[i])==-1){
                            tmp.push(arr[i]);
                        }
                    }
                    return tmp;
                },
                clearButtonsActive:function(){//移除选项选中框
                    if($(".position-relative").find(".edit-img").length>0) $(".position-relative").find(".edit-img").remove();//移除选项选中框
                    $(".question-title .qs-content").removeClass("edit-area-active");
                    $(".question-choice .edit-area").removeClass("edit-area-active");
                },
                addMutipleQuestion: function(data,type){//单个或批量添加选项
                    var self = this;
                    var resultHtml = "";
                    var questionCount = $("#question_box").find(".topic-type-question").length;
                    for(var i=0;i<data.length;i++){
                        questionCount++;
                        var titleData = data[i].title;//标题
                        var optionData = data[i].optionData;//选项
                        var questionCode = self.getUUID();//问题code
                        var titleHtml = '<div class="topic-type-content topic-type-question after-clear" data-type="'+type+'" data-code="'+questionCode+'">'+
                            '<div class="question-title">'+
                            '<span class="span-order">Q'+questionCount+'</span>'+
                            '<span class="wt-required">*</span>'+
                            '<span class="required"></span>'+
                            '<div class="position-relative" style="width: calc(100% - 100px);">'+
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
                            var optionCode = self.getUUID();//选项code
                            if(type=="0" || type=="1"){//单选题或多选题
                                var imgClass = type=="0"?"div-radio-img":"div-checkbox-img";
                                itemHtml+='<li class="choice" data-input="0" data-input-required="0" data-code="'+optionCode+'">'+
                                    '<div class="'+imgClass+'"></div>'+
                                    '<div class="position-relative">'+
                                    '<div class="edit-area edit-child-element" contenteditable="true" data-value="">'+
                                    optionData[j] +
                                    '</div>'+
                                    '</div>'+
                                    '</li>';
                            }else{//问答题
                                itemHtml = '<li class="choice" data-input="0" data-input-required="0" data-code="'+optionCode+'">'+
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
                                    '<li class="drag-area" title="移动"></li>'+
                                    '<li class="question-setting" title="逻辑设置"></li>'+
                                    '<li class="question-instruction" title="说明"></li>'+
                                    '<li class="question-transform" title="转换"></li>'+
                                    '<li class="question-required" title="必填"></li>'+
                                    '<li class="question-delete" title="删除"></li>'+
                                    '</ul>'+
                                    '</div>';
                            }else{//多选题
                                operateHtml = '<div class="operate visible-show">'+
                                    '<ul>'+
                                    '<li class="drag-area" title="移动"></li>'+
                                    '<li class="question-setting" title="逻辑设置"></li>'+
                                    '<li class="question-instruction" title="说明"></li>'+
                                    '<li class="question-transform" title="转换"></li>'+
                                    '<li class="question-duoxuan" title="多选设置"></li>'+
                                    '<li class="question-required" title="必填"></li>'+
                                    '<li class="question-delete" title="删除"></li>'+
                                    '</ul>'+
                                    '</div>';
                            }
                        }else{//问答题
                            operateHtml = '<div class="operate visible-show">'+
                                '<ul>'+
                                '<li class="drag-area" title="移动"></li>'+
                                '<li class="question-setting" title="逻辑设置"></li>'+
                                '<li class="question-instruction" title="说明"></li>'+
                                '<li class="question-required" title="必填"></li>'+
                                '<li class="question-delete" title="删除"></li>'+
                                '</ul>'+
                                '</div>';
                        }

                        resultHtml+=titleHtml+optionHtml+addAreaHtml+operateHtml+"</div>";
                    }
                    $("#question_box").append(resultHtml);

                },
                importedQuestion: function(data,isScrollToBottom){//问题库导入-导出的问题
                    var self = this;
                    var resultHtml = "";
                    $(".div-right-empty").hide();
                    $("#question_box").show();
                    var questionCount = $("#question_box").find(".topic-type-question").length;
                    if(data.length==undefined) data = [data];
                    for(var i=0;i<data.length;i++){
                        questionCount++;
                        var logicData = null;
                        var questionsItemData = [];
                        var options = [];
                        var titleData = data[i].title;//标题
                        if(data[i].questionCodeNext!="" && data[i].questionCodeNext!=undefined){
                            questionsItemData.push({questionCodeNext:data[i].questionCodeNext,questionSortNext:data[i].questionSortNext});
                        }
                        var optionData = data[i].options;//选项
                        var questionCode = $("#inp_mode").val()=="edit"?data[i].code:self.getUUID();//问题code
                        var type = data[i].questionType;
                        var questionSort = data[i].sort==undefined?questionCount:data[i].sort;
                        var comment = data[i].comment;
                        var isRequired = isScrollToBottom?"*":data[i].isRequired==1?"*":"";
                        var minNum = data[i].minNum==undefined?null:data[i].minNum;
                        var maxNum = data[i].maxNum==undefined?null:data[i].maxNum;
                        var duoXuanText = "";
                        if(minNum!=null && maxNum==null){
                            duoXuanText = "(至少选择"+minNum+"项)";
                        }else if(minNum==null && maxNum!=null){
                            duoXuanText = "(最多选择"+maxNum+"项)";
                        }else if(minNum!=null && maxNum!=null){
                            duoXuanText = "(选择"+minNum+"~"+maxNum+"项)";
                        }

                        var optionHtml = '<ul class="question-choice">';
                        var itemHtml = "";
                        var addAreaHtml = "";
                        var operateHtml = "";
                        var remarkHtml = "";
                        //问题选项
                        if(optionData.length==0){
                            optionData = ["选项1","选项2"];
                        }
                        for(var j = 0;j<optionData.length;j++){
                            var optionCode = $("#inp_mode").val()=="edit"?optionData[j].code:self.getUUID();//选项code
                            var haveComment = optionData[j].haveComment;
                            var optionIsRequired = optionData[j].isRequired;
                            var content = optionData[j].content;
                            if(optionData[j].questionCodeNext!="" && optionData[j].questionCodeNext!=undefined){
                                options.push({optionItem:optionCode,questionCodeNext:optionData[j].questionCodeNext,questionSortNext:optionData[j].questionSortNext});
                            }
                            if(type=="0" || type=="1"){//单选题或多选题
                                var imgClass = type=="0"?"div-radio-img":"div-checkbox-img";
                                var remark = "";
                                if(haveComment==1 && optionIsRequired==1){
                                    remark = '<div class="mrb10">'+
                                        '<input type="text" class="input-text preview-input-text other-content"><span class="other-required">（必填）</span>'+
                                        '</div>';
                                }
                                if(haveComment==1 && optionIsRequired==0){
                                    remark = '<div class="mrb10">'+
                                        '<input type="text" class="input-text preview-input-text other-content">'+
                                        '</div>';
                                }
                                itemHtml+='<li class="choice" data-input="'+optionData[j].isRequired+'" data-input-required="'+optionData[j].haveComment+'" data-code="'+optionCode+'">'+
                                    '<div class="'+imgClass+'"></div>'+
                                    '<div class="position-relative">'+
                                    '<div class="edit-area edit-child-element"  contenteditable="true">'+
                                    content +
                                    '</div>'+
                                    '</div>'+
                                    remark+
                                    '</li>';
                            }else{//问答题
                                itemHtml = '<li class="choice" data-code="'+optionCode+'">'+
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
                                    '<li class="drag-area" title="移动"></li>'+
                                    '<li class="question-setting" title="逻辑设置"></li>'+
                                    '<li class="question-instruction" title="说明"></li>'+
                                    '<li class="question-transform" title="转换"></li>'+
                                    '<li class="question-required" title="必填"></li>'+
                                    '<li class="question-delete" title="删除"></li>'+
                                    '</ul>'+
                                    '</div>';
                            }else{//多选题
                                operateHtml = '<div class="operate visible-show">'+
                                    '<ul>'+
                                    '<li class="drag-area" title="移动"></li>'+
                                    '<li class="question-setting" title="逻辑设置"></li>'+
                                    '<li class="question-instruction" title="说明"></li>'+
                                    '<li class="question-transform" title="转换"></li>'+
                                    '<li class="question-duoxuan" title="多选设置"></li>'+
                                    '<li class="question-required" title="必填"></li>'+
                                    '<li class="question-delete" title="删除"></li>'+
                                    '</ul>'+
                                    '</div>';
                            }
                        }else{//问答题
                            operateHtml = '<div class="operate visible-show">'+
                                '<ul>'+
                                '<li class="drag-area" title="移动"></li>'+
                                '<li class="question-setting" title="逻辑设置"></li>'+
                                '<li class="question-instruction" title="说明"></li>'+
                                '<li class="question-required" title="必填"></li>'+
                                '<li class="question-delete" title="删除"></li>'+
                                '</ul>'+
                                '</div>';
                        }
                        if(comment!=null){//选项说明
                            remarkHtml = '<div class="div-padding c-border-top f-mr20 div-instruction-text">'+
                                '<input placeholder="说明：这是题目的具体说明文字内容" class="max-input-text" value="'+comment+'">'+
                                '</div>';
                        }
                        if(questionsItemData.length>0 || options.length>0){
                            logicData = JSON.stringify({questionsItemData:questionsItemData,options:options});//逻辑设置数据
                        }else{
                            logicData = "";
                        }
                        var titleHtml = '<div class="topic-type-content topic-type-question after-clear" data-type="'+type+'" data-code="'+questionCode+'" data-minvalue="'+data[i].minNum+'" data-maxvalue="'+data[i].maxNum+'" data-logicdata='+logicData+'>'+
                            '<div class="question-title">'+
                            '<span class="span-order">Q'+questionSort+'</span>'+
                            '<span class="wt-required">'+isRequired+'</span>'+
                            '<span class="required">'+duoXuanText+'</span>'+
                            '<div class="position-relative" style="width: calc(100% - 100px);">'+
                            '<div class="qs-content edit-area edit-title"  contenteditable="true" data-value="">'+
                            titleData +
                            '</div>'+
                            '</div>'+
                            '</div>';
                        resultHtml+=titleHtml+optionHtml+remarkHtml+addAreaHtml+operateHtml+"</div>";
                    }
                    $("#question_box").append(resultHtml);
                    if(isScrollToBottom==true) $("#question_box").scrollTop($("#question_box")[0].scrollHeight);
                },
                getSaveingData:function(){
                    var resultData = [];
                    var questions = [];
                    var templateName = $(".div-wenjuan-title").find(".div-template-name").html();//问卷标题
                    var templateComment = $(".div-wenjuan-title").find(".div-template-comment").html();//问卷说明
                    var labels = JSON.parse(templateData.labels);//上一个页面已勾选的标签
                    var labelsName = templateData.labelsName;//标签中文值
                    var topicTypeQuestion =   $("#question_box").find(".topic-type-question");
                    for(var i=0;i<topicTypeQuestion.length;i++){
                        var item = $(topicTypeQuestion[i]);
                        var title = item.find(".edit-title").html();//问题标题
                        var questionCode = item.attr("data-code");//问题code
                        var logicdata = (item.attr("data-logicdata")==undefined || item.attr("data-logicdata")=="")?"":JSON.parse(item.attr("data-logicdata"));
                        var comment = item.find(".div-instruction-text input").length>0?item.find(".div-instruction-text input").val():null;//问题说明
                        var questionType = parseInt(item.attr("data-type"));//问题类型（0单选 1多选 2问答）
                        var isRequired = item.find(".wt-required").html()!=""?1:0;//问题是否必填（0否 1是）
                        var minNum = (item.attr("data-minvalue")=="" || item.attr("data-minvalue")=="undefined")?"": item.attr("data-minvalue");//最小答案个数（多选有效）
                        var maxNum = (item.attr("data-maxvalue")=="" || item.attr("data-minvalue")=="undefined")?"": item.attr("data-maxvalue");//最大答案个数（多选有效）
                        var optionData = [];
                        var questionSort = i+1;
                        var questionCodeNext = "";
                        var questionCodeSort = "";
                        if(logicdata!=""){
                            if(logicdata.questionsItemData.length>0){
                                questionCodeNext = logicdata.questionsItemData[0].questionCodeNext;//跳转到下一题的问题code
                                questionCodeSort = logicdata.questionsItemData[0].questionSortNext;
                            }
                        }
                        if(questionType!=2){
                            var optionItem = item.find(".question-choice").find(".choice");
                            for(var j=0;j<optionItem.length;j++){
                                var haveComment = $(optionItem[j]).find(".other-content").length>0?1:0;//是否有选项说明（0没有 1有）
                                var optionIsRequired =  $(optionItem[j]).find(".other-required").length>0?1:0;////选项说明是否必填（0否 1是）
                                var content = $(optionItem[j]).find(".edit-child-element").html();//选项内容
                                var optionSort = j+1;//单题内排序
                                var optionCode = $(optionItem[j]).attr("data-code");
                                var optionQuestionCodeNext = "";//选项的下一个跳转code
                                var optionQuestionCodeSort = "";
                                if(logicdata!=""){
                                    for(var z=0;z<logicdata.options.length;z++){
                                        if(logicdata.options[z].optionItem==optionCode){
                                            optionQuestionCodeNext = logicdata.options[z].questionCodeNext;//跳转到下一题的问题code
                                            optionQuestionCodeSort =  logicdata.options[z].questionSortNext;
                                            break;
                                        }
                                    }

                                }
                                optionData.push({"haveComment": haveComment,"content": content,"isRequired": optionIsRequired,"sort": optionSort,"code":optionCode,"questionCodeNext":optionQuestionCodeNext,"questionSortNext":optionQuestionCodeSort});
                            }
                        }
                        questions.push({"title": title,"code": questionCode,"comment": comment,"questionType": questionType,"isRequired":isRequired,"minNum": minNum,"maxNum": maxNum,"sort": questionSort,"questionCodeNext": questionCodeNext,"questionSortNext":questionCodeSort,"options": optionData})
                    }
                    if($("#inp_mode").val()=="add"){
                        resultData.push({title:templateName,comment:templateComment,labels:labels,questions:questions});
                    }else{
                        resultData.push({id:templateData.templateId,title:templateName,comment:templateComment,labels:labels,questions:questions});
                    }
                    return resultData;
                },
                previewQuestion:function(){
                    var self = this;
                    var resultHtml = "";
                    var templateName = $(".div-wenjuan-title").find(".div-template-name").html();//问卷标题
                    var templateComment = $(".div-wenjuan-title").find(".div-template-comment").html();//问卷说明
                    var labels = JSON.parse(templateData.labels);//上一个页面已勾选的标签值
                    var labelsName = templateData.labelsName;//标签中文值
                    var resultData = self.getSaveingData();
                    for(var i=0;i<resultData.length;i++){
                        var Tquestions = resultData[i].questions;
                        for(var j=0;j<Tquestions.length;j++){
                            var titleData = Tquestions[j].title;//标题
                            var questionCodeNext =  Tquestions[j].questionCodeNext;
                            var questionCodeSort =  Tquestions[j].questionSortNext;
                            if(questionCodeNext!=""){
                                titleData = Tquestions[j].title+questionCodeSort;
                            }
                            var questionSort = Tquestions[j].sort;
                            var optionData = Tquestions[j].options;//选项
                            var comment = Tquestions[j].comment;
                            var isRequired =  Tquestions[j].isRequired==1?"*":"";
                            var questionType = Tquestions[j].questionType;//问题类型（0单选 1多选 2问答）
                            var minNum = (Tquestions[j].minNum==undefined || Tquestions[j].minNum=="")?null:Tquestions[j].minNum;
                            var maxNum = (Tquestions[j].maxNum==undefined || Tquestions[j].maxNum=="")?null:Tquestions[j].maxNum;
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
                                '<span class="span-order">Q'+questionSort+'</span>'+
                                '<span class="wt-required">'+isRequired+'</span>'+
                                '<span class="required">'+duoXuanText+'</span>'+
                                '<div class="position-relative" style="width: calc(100% - 110px);">'+
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
                            }
                            for(var k = 0;k<optionData.length;k++){
                                var haveComment = optionData[k].haveComment;
                                var optionIsRequired = optionData[k].isRequired;
                                var content = optionData[k].content;
                                var optionquestionCodeNext =  optionData[k].questionCodeNext;
                                var optionquestionCodeSort =  optionData[k].questionSortNext;
                                if(optionquestionCodeNext!=""){
                                    content = optionData[k].content+optionquestionCodeSort;
                                }
                                if(questionType=="0" || questionType=="1"){//单选题或多选题
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

                    }
                    var previewHtml = '<div class="div-preview-content"><div style="font-weight: bold;text-align: center;">'+templateName+'</div>'+
                        '<div style="margin: 10px;">问卷说明：'+templateComment+'</div><div style="margin: 10px;">问卷标签：'+labelsName+'</div>';
                    $("#div-previewQuestionDialog").find(".div-preview-content").html(previewHtml+resultHtml);
                    return resultData;
                },
            };

            preview = {
                infoDialog: null,
                init: function (questionId) {
                    this.getQuestion(questionId);
                },
                getQuestion:function(questionId){
                    var self = this;
                    $.ajax({
                        url: ctx + "/admin/surveyQuestion/getQuestion",
                        data: {"id": questionId},
                        method: "get",
                        dataType: "json",
                        success: function (result) {
                            if (result.status == 200) {
                                self.seeQuestion(result.data);
                            } else {
                                $.Notice.error(result.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                },
                seeQuestion:function(resultData){
                    var resultHtml = "";
                    var titleData = resultData.title;//标题
                    var optionData = resultData.options;//选项
                    var comment = resultData.comment;
                    var questionType = resultData.questionType;//问题类型（0单选 1多选 2问答）
                    var minNum = resultData.minNum;
                    var maxNum = resultData.maxNum;
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
                        '<div class="position-relative" style="width: calc(100% - 100px);">'+
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

            };

            /* ************************* Dialog页面回调接口 ************************** */
            win.importedQuestion = function (data,isScrollToBottom) {
                retrieve.importedQuestion(data,isScrollToBottom);
            };

            /* *************************** 页面初始化 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>