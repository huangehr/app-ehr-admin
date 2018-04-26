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
            var master = null;
            var isFirstPage = false;
            var label = '';

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }

            function reloadGrid(params) {
                params = {
                    redicUrl:'/basic/api/v1.0/admin/surveyTemplate/list',
                    postOrGet:'get',
                    paramJson:'{"title":"","lable":"","page":"1","rows":"15"}',
                    title:retrieve.$searchNm.val(),
                    label:label
                };
                if (isFirstPage) {
                    this.grid.options.newPage = 1;
                }
                this.grid.setOptions({parms: params});
                this.grid.loadData(true);
            }

            /* *************************** 模块初始化 ***************************** */

            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchNm: $("#inp_searchNm"),//标题
                $status: $("#sel_status"),//状态
                $addBtn: $('.div-add-btn'),//新增问卷
                init: function () {
                    this.$searchNm.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            isFirstPage = true;
                            master.reloadGrid();//参数：标签/提交人+消息通知状态
                        }
                    });
                    this.loadLabel();
                    this.$element.show();
                    this.$element.attrScan();
                    window.form = this.$element;
                    this.bindEvents();
                },
                loadLabel:function(){
                    var self = this;
                    //获取所有问卷类型
                    $.ajax({
                        url: '${contextRoot}/survey/allMethod',
                        data: {
                            redicUrl:'/basic/api/v1.0/admin/surveyTemplate/getTemplateLabel/WJLX',
                            postOrGet:'post'
                        },
                        method: "post",
                        dataType: "json",
                        success: function (data) {
                            if (data.successFlg) {
                                self.$status.ligerComboBox({
                                    width: 180,
                                    data: data.detailModelList,
                                    initIsTriggerEvent: false,
                                    valueFieldID: 'value',
                                    valueField: 'value',
                                    textField:'value',
                                    onSelected: function (newvalue) {
                                        label = newvalue;
                                        if (!master || !master.grid) {
                                            return
                                        }
                                        isFirstPage = true;
                                        master.reloadGrid();//参数：标签/提交人+消息通知状态
                                    }
                                });
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
                    self.$addBtn.click(function () {
                        location.href ='${contextRoot}/survey/addTemplate?mode=add';
                    });

                }
            };
            master = {
                infoDialog: null,
                $divSeeQuestionDialog:$("#div-seeQuestionDialog"),
                grid: null,
                init: function () {
                    var data;
                    this.grid = $("#div_question_list").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/survey/allMethod',
                        method:'GET',
                        parms: {
                            redicUrl:'/basic/api/v1.0/admin/surveyTemplate/list',
                            postOrGet:'get',
                            paramJson:'{"title":"","lable":"","page":"1","rows":"15"}'
                        },
                        columns: [
                            {display: 'ID', name: 'id', hide: true},
                            {display: '标题', name: 'title', width: '25%', align: "center"},
                            {display: '标签', name: 'labelName', width: '20%', align: "center"},
                            {display: '说明', name: 'comment', width: '20%', align: "center"},
                            {display: '创建人', name: 'creater', width: '15%', align: "center"},
                            {
                                display: '操作', name: 'operator', width: '20%', align: "center", isSort: false,
                                render: function (row) {
                                    var html = '';
                                    html += '<a  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "info:view", row.id, row.labelName) + '">查看</a>';
                                    html += '<a  style="margin-left:10px;"href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "info:edit", row.id) + '">编辑</a>';
                                    html += '<a  style="margin-left:10px;" title="删除" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "info:del", row.id) + '">删除</a>';
                                    return html;
                                }
                            }
                        ],
                        //选中修改值
                        onCheckRow:function(checked,data,rowid,rowdata)
                        {
                            var checkRowsList = master.grid.getCheckedRows();
                            if(checkRowsList.length==0){
                                $(".div-pldelete-btn").removeClass("active");
                            }else{
                                $(".div-pldelete-btn").addClass("active");
                            }
                            //修改行checked值
                            if(checked)
                                data.checked ="1";
                            else
                                data.checked ="0";
                        },
                        onCheckAllRow:function(checked,gridElement){
                            if(checked){
                                $(".div-pldelete-btn").addClass("active");
                            }else{
                                $(".div-pldelete-btn").addClass("active");
                            }
                        },

                    }));
                    // 自适应宽度
                    this.grid.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function (msg) {
                    if (msg) {
                        //如果是新增，直接刷新页面
                        master.grid.loadData();
                    } else {
                        //如果是查询
                        retrieve.$element.attrScan();
                        var values = retrieve.$element.Fields.getValues();
                        reloadGrid.call(this, values);
                    }
                },
                bindEvents: function () {
                    var self = this;
                    $.subscribe('info:view', function (event, id, labelName) {
                        self.infoDialog = $.ligerDialog.open({
                            title: "查看模板",
                            width: 620,
                            urlParms:{
                                question:'',
                                id:id
                            },
                            height: 560,
                            target: self.$divSeeQuestionDialog
                        });
                        self.previewQuestion(id,labelName);//组装数据
                        $("#div-seeQuestionDialog").on("click","#appoint_btn",function(){//引用模板事件
                            location.href ='${contextRoot}/survey/addTemplate?mode=add&templateId='+id;
                        }).on("click","#inp_back_update",function(){//修改模板事件
                            location.href = '${contextRoot}/survey/addTemplate?mode=edit&templateId='+id;
                        }).on("click","#inp_close",function(){//关闭弹窗事件
                            self.infoDialog.close();
                        })
                    });

                    $.subscribe('info:edit', function (event, id) {
                        location.href = '${contextRoot}/survey/addTemplate?mode=edit&templateId='+id
                    });

                    $.subscribe('info:del', function (event, id) {
                        $.ligerDialog.confirm('是否确认删除该问卷？删除后无法恢复', function (yes) {
                            if (yes) {
                                self.delRecord(id);
                            }
                        });
                    })
                },
                delRecord: function (id) {
                    var self = this;
                    var parme = {
                        templateId : id
                    }
                    var value = JSON.stringify(parme);
                    $.ajax({
                        url: '${contextRoot}/survey/allMethod',
                        data: {
                            redicUrl:'/basic/api/v1.0/admin/surveyTemplate/delTemplate',
                            postOrGet:'post',
                            paramJson:value
                        },
                        method: "post",
                        dataType: "json",
                        success: function (data) {
                            if (data.successFlg) {
                                window.reloadMasterGrid(data.msg);
                            } else {
                                $.Notice.error(data.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                },
                getDetailData:function(templateId){
                    var resultData = null;
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
                        async: false,
                        success: function (data) {
                            if (data.successFlg) {
                                resultData =  data.obj
                            } else {
                                $.Notice.error(data.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                    return resultData;
                },
                previewQuestion:function(id,labelName){
                    var self = this;
                    var resultHtml = "";
                    var labelsName =labelName;//标签中文值
                    var resultData = self.getDetailData(id);
                    var Tquestions = resultData.questions;
                    var templateName = resultData.surveyTemplate.title;//问卷标题
                    var templateComment = resultData.surveyTemplate.comment;//问卷说明
                    for(var j=0;j<Tquestions.length;j++){
                        var titleData = Tquestions[j].question.title;//标题
                        var questionCodeNext =  Tquestions[j].question.questionCodeNext;
                        var questionCodeSort =  Tquestions[j].question.questionSortNext;
                        if(questionCodeNext!=""){
                            titleData = Tquestions[j].question.title;
                        }
                        var questionSort = Tquestions[j].question.sort;
                        var optionData = Tquestions[j].optipon;//选项
                        var comment = Tquestions[j].comment;
                        var isRequired =  Tquestions[j].isRequired==1?"*":"";
                        var questionType = Tquestions[j].question.questionType;//问题类型（0单选 1多选 2问答）
                        var minNum = (Tquestions[j].question.minNum==undefined || Tquestions[j].question.minNum=="")?null:Tquestions[j].question.minNum;
                        var maxNum = (Tquestions[j].question.maxNum==undefined || Tquestions[j].question.maxNum=="")?null:Tquestions[j].question.maxNum;
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
                            optionData = ["选项1"];
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

                    var previewHtml = '<div class="div-preview-content" style="margin:10px 20px 30px;font-size: 12px;height: 440px;overflow: auto;"><div style="font-weight: bold;text-align: center;">'+templateName+'</div>'+
                        '<div style="margin: 10px;">问卷说明：'+templateComment+'</div><div style="margin: 10px;">问卷标签：'+labelsName+'</div>';
                    $("#div-seeQuestionDialog").find(".div-see-content").html(previewHtml+resultHtml);
                    return resultData;
                }
            };

            /* ************************* Dialog页面回调接口 ************************** */
            win.reloadMasterGrid = function (msg) {
                if (isNoEmpty(msg)) {
                    $.Notice.success(msg);
                }
                master.reloadGrid(msg);
            };
            win.closeInfoDialog = function () {
                master.infoDialog.close();
            };
            win.closeParentInfoDialog = function () {
                location.href ='${contextRoot}/survey/addQuestion?mode=add'
            };
            /* *************************** 页面初始化 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>