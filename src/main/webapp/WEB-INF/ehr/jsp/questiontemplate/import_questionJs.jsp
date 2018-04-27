<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var master = null;
            var preview = null;
            var questionType = "";
            var isFirstPage = false;
            var divSeeQuestionDialog = null;

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                master.init();
            }

            function reloadGrid(params) {
                params = {title:$("#inp_searchNm").val(),questionType:questionType};
                if (isFirstPage) {
                    master.grid.options.newPage = 1;
                }
                master.grid.setOptions({parms: params});
                master.grid.loadData(true);
            }

            /* *************************** 模块初始化 ***************************** */

            //问题库导入的表格数据
            master = {
                infoDialog: null,
                $divSeeQuestionDialog:$("#div-seeQuestionDialog"),
                $patchImportBtn:$("#patch_import_btn"),
                grid: null,
                $divQuestionList:$("#div_question_list"),
                $searchNm: $("#inp_searchNm"),//标题
                $status: $("#sel_status"),//状态
                init: function () {
                    this.grid = this.$divQuestionList.ligerGrid($.LigerGridEx.config({
                        width:'600px',
                        height:'500px',
                        checkbox: true,
                        url: '${contextRoot}/survey/allMethod',
                        checkbox: true,
                        parms: {
                            redicUrl:'/basic/api/v1.0/admin/surveyQuestion/list',
                            postOrGet:'post',
                            paramJson:'{"title":"","lable":"","page":"1","rows":"15"}'
                        },
                        columns: [
                            {display: 'ID', name: 'id', hide: true},
                            {display: '标题', name: 'title', width: '30%', align: "center"},
                            {display: '类型', name: 'questionType', width: '10%', align: "center",
                                render: function (row) {
                                    if (Util.isStrEquals(row.questionType, 0)) {
                                        return "单选";
                                    } else if (Util.isStrEquals(row.questionType, 1)) {
                                        return "多选";
                                    }
                                    return "问答";
                                }
                            },
                            {display: '问题说明', name: 'comment', width: '40%', align: "center"},
                            {
                                display: '操作', name: 'operator', width: '20%', align: "center", isSort: false,
                                render: function (row) {
                                    var html = '';
                                    html += '<a  href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "info:view", row.id, row.type) + '">预览</a>';
                                    html += '<a  style="margin-left:10px;"href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "info:import", row.id) + '">导出</a>';
                                    return html;
                                }
                            }
                        ],
                        //选中修改值
                        onCheckRow:function(checked,data,rowid,rowdata)
                        {
                            var checkRowsList = master.grid.getCheckedRows();
                            if(checkRowsList.length==0){
                                $(".div-plimport-btn").removeClass("active");
                            }else{
                                $(".div-plimport-btn").addClass("active");
                            }
                            //修改行checked值
                            if(checked)
                                data.checked ="1";
                            else
                                data.checked ="0";
                        },
                        onCheckAllRow:function(checked,gridElement){
                            if(checked){
                                $(".div-plimport-btn").addClass("active");
                            }else{
                                $(".div-plimport-btn").addClass("active");
                            }
                        },

                    }));
                    // 自适应宽度
                    this.grid.adjustToWidth();
                    this.bindEvents();
                },
                bindEvents: function () {
                    var self = this;
                    self.$searchNm.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            isFirstPage = true;
                            reloadGrid();
                        }
                    })
                    //状态复选框，选择时也刷新列表
                    self.$status.ligerComboBox({
                        width: 180,
                        data: [
                            {text: '全部', statusId: ''},
                            {text: '单选', statusId: '0'},
                            {text: '多选', statusId: '1'},
                            {text: '问答', statusId: '2'}
                        ],
                        initIsTriggerEvent: false,
                        valueFieldID: 'statusId',
                        valueField: 'statusId',
                        onSelected: function (newvalue) {
                            questionType = newvalue;
                            if (!master || !master.grid) {
                                return
                            }
                            reloadGrid();
                        },
                    });

                    //批量导出
                    self.$patchImportBtn.on("click",function(){
                        var checkRowsList = master.grid.getCheckedRows();
                        if(checkRowsList.length==0){
                            $.Notice.error("请选择问题！");
                            return false;
                        }
                        $.ligerDialog.confirm("是否确认将选择问题导出到问卷？", function (yes) {
                            if (yes) {
                                var ids = "";
                                for(var i=0;i<checkRowsList.length;i++){
                                    ids+=checkRowsList[i].id+",";
                                }
                                $.ajax({
                                    url: ctx + "/admin/surveyQuestion/getQuestions",
                                    data: {"ids": ids},
                                    method: "get",
                                    dataType: "json",
                                    success: function (result) {
                                        if (result.status == 200) {
                                            parent.window.importedQuestion(result.data,true);
                                            $.Notice.success("导出成功");
                                        } else {
                                            $.Notice.error("导出失败");
                                        }
                                    },
                                    error: function (data) {
                                        $.Notice.error("系统异常,请联系管理员！");
                                    }
                                })
                            }
                        });

                    })

                    //问题预览
                    $.subscribe('info:view', function (event, id, type) {
                        preview.init(id);
                        divSeeQuestionDialog = $.ligerDialog.open({
                            title: "问题预览",
                            height: 430,
                            width: 600,
                            target: preview.$divSeeQuestionDialog
                        });

                        $("#div-seeQuestionDialog").on("click","#btn_close",function(){//关闭弹窗事件
                            divSeeQuestionDialog.close();
                        })
                    });
                    //问题导出
                    $.subscribe('info:import', function (event, id) {
                        $.ajax({
                            url: ctx + "/admin/surveyQuestion/getQuestion",
                            data: {"id": id},
                            method: "get",
                            dataType: "json",
                            success: function (result) {
                                if (result.status == 200) {
                                    parent.window.importedQuestion(result.data,true);
                                    $.Notice.success("导出成功");
                                } else {
                                    $.Notice.error("导出失败");
                                }
                            },
                            error: function (data) {
                                $.Notice.error("系统异常,请联系管理员！");
                            }
                        })
                    });


                },
                delRecord: function (id, code) {
                    var self = this;
                    $.ajax({
                        url: ctx + "/admin/user/delete",
                        data: {"id": id},
                        method: "post",
                        dataType: "json",
                        success: function (result) {
                            if (result.status == '200') {
                                window.reloadMasterGrid(result.msg);
                            } else {
                                $.Notice.error(result.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                }
            };

            preview = {
                infoDialog: null,
                $divSeeQuestionDialog:$("#div-seeQuestionDialog"),
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

            };

            /* ************************* Dialog页面回调接口 ************************** */



            /* *************************** 页面初始化 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>