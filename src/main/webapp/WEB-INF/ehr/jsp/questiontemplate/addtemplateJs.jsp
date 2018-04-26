<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<link rel="stylesheet" href="${staticRoot}/lib/plugin/select/select.min.css">
<script src="${contextRoot}/develop/lib/plugin/select/select.js"></script>


<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            var retrieve = null;
            var jValidation = $.jValidation;
            var moodelId = '${templateId}';
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
            }

            /* *************************** 模块初始化 ***************************** */

            retrieve = {
                $selWenJuan: $("#sel_wenjuan"),//选择问卷
                init: function () {
                    var self = this;
                    if(moodelId!=""){
                        $(".div-next").show();
                        self.loadTemplateContent();
                    }else{
                        self.selectBind();
                        $(".div-prev").show();
                    }
                    this.loadLabel();
                    this.bindEvents();
                },
                selectBind:function(){
                    var self = this;
                    var wenjuanSelect2 =  self.$selWenJuan.select2({
                        placeholder: "请选择模板",//只显示前15条结果
                        ajax: {
                            async:false,
                            dataType : "json",
                            url: "${contextRoot}/survey/allMethod",
                            data: {
                                redicUrl:'/basic/api/v1.0/admin/surveyTemplate/list',
                                postOrGet:'get',
                                paramJson:'{"title":"","lable":"","page":"1","rows":"15"}'
                            },
                            processResults: function (data, page) {
                                if(data.successFlg){
                                    return {
                                        results:  data.detailModelList
                                    };
                                }else{
                                    $.ligerDialog.error(data.msg);
                                }
                                //                cache: true
                            },
                            escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
                            minimumInputLength: 1,
                        }
                    })
                    self.$selWenJuan.show();
                    return wenjuanSelect2;
                },
                loadLabel:function(){
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
                                var list = data.detailModelList;
                                var labelStr = "";
                                for(var i=0;i<list.length;i++){
                                    labelStr += '<div class="f-pr f-mr5 div-label" data-id="'+list[i].code+'">'+
                                        '<div class="div-checkbox-img"></div>'+
                                        '<div class="position-relative">'+
                                        '<div>'+list[i].value+'</div>'+
                                        '</div>'+
                                        '</div>'
                                }
                                $(".div-label-content").html(labelStr);
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
                    var validator = new jValidation.Validation($("#div-form"), {
                        immediate: true, onSubmit: false,
                        onElementValidateForAjax: function (elm) {
                            if(Util.isStrEquals($(elm).attr('id'),'inp_wenjuan_name') && $("#inp_mode").val()=="add"){//判断问卷名称是否存在
                                var result = new jValidation.ajax.Result();
                                var wenjuanName = $("#inp_wenjuan_name").val();
                                var value = {
                                    title:wenjuanName
                                };
                                var parme = JSON.stringify(value);
                                $.ajax({
                                    url: "${contextRoot}/survey/allMethod",
                                    data: {
                                        redicUrl:'/basic/api/v1.0/template/title',
                                        postOrGet:'get',
                                        paramJson:parme
                                    },
                                    method: "get",
                                    dataType: "json",
                                    async: false,
                                    success: function (data) {
                                        if (data.successFlg) {
                                            if(data.obj!=null){
                                                result.setResult(false);
                                                result.setErrorMsg("问卷名称已存在");
                                            }else{
                                                result.setResult(true);
                                            }
                                        } else {
                                            $.Notice.error(data.msg);
                                        }
                                    },
                                    error: function (data) {
                                        $.Notice.error("系统异常,请联系管理员！");
                                    }
                                })
                                return result;

                            }
                        }
                    });

                    $("#inp_wenjuan_name").ligerTextBox({width: 240})

                    $("#div_wrapper").on("click",".div-radio-img",function(){
                        $(".div-prev .div-radio-img").removeClass("active");
                        $(this).addClass("active");
                    }).on("click",".div-checkbox-img",function(){
                        $(this).toggleClass("active");
                    }).on("click","#pre_btn",function(){//上一步事件
                        $(this).hide();
                        $("#next_btn").show();
                        $(".div-prev").show();
                        $(".div-next").hide();
                    }).on("click","#next_btn",function(){//下一步事件
                        if($(".div-prev").is(":hidden")){//上一步内容显示
                            if (!validator.validate()) {
                                return;
                            }
                            if($(".div-label-content .div-checkbox-img.active").length==0){
                                $.Notice.error("请选择问卷标签");
                                return false;
                            }
                            sessionStorage.removeItem("templateData");
                            //取出所有标签值
                            var allLabel = $(".div-label-content .div-label");
                            var labelArr = [];
                            var labelsName = "";
                            for(var i=0;i<allLabel.length;i++){
                                if($(allLabel[i]).find(".div-checkbox-img.active").length>0){
                                    labelArr.push({useType:"0",label:$(allLabel[i]).attr("data-id")});
                                    labelsName += $(allLabel[i]).find(".position-relative div").html()+"、";
                                }
                            }
                            labelsName = labelsName.substring(0,labelsName.length-1);
                            var type = $(".div-prev").find(".div-radio-img.active").closest(".div-type").attr("data-type");
                            var templateId = (self.$selWenJuan.val()==null || type=="1")? $("#inp_template_id").val():self.$selWenJuan.val();
                            var templateData = {templateId:templateId,title:$("#inp_wenjuan_name").val(),comment:$("#tea_wenjuan_instruction").val(),labels:JSON.stringify(labelArr),labelsName:labelsName};
                            sessionStorage.setItem("templateData", JSON.stringify(templateData));
                            location.href ='${contextRoot}/survey/editTemplate?templateId='+templateId+'&mode='+$("#inp_mode").val();
                        }else{//上一步内容隐藏
                            var type = $(".div-prev").find(".div-radio-img.active").closest(".div-type").attr("data-type");//1:空白模板 2：已有模板
                            if(type=="2" && (self.$selWenJuan.val()=="" || self.$selWenJuan.val()==null)){
                                $.Notice.error("请选择模板");
                                return false;
                            }
                            self.clearValue();
                            if(type=="2"){
                                self.loadTemplateContent();
                            }
                            $("#pre_btn").show();
                            $(".div-prev").hide();
                            $(".div-next").show();
                        }
                    })
                },
                clearValue:function(){//清空原来的值
                    $("#inp_wenjuan_name").val("");
                    $("#tea_wenjuan_instruction").val("");
                    var allLabel = $(".div-label-content .div-label");
                    for(var i=0;i<allLabel.length;i++){
                        $(allLabel[i]).find(".div-checkbox-img").removeClass("active");
                    }
                },
                loadTemplateContent:function(){//加载模板内容
                    var templateId = this.$selWenJuan.val()==null? moodelId:this.$selWenJuan.val();
                    var self = this;
                    var value = {
                        "id": templateId,question:"0"
                    }
                    var params = JSON.stringify(value);
                    $.ajax({
                        url: '${contextRoot}/survey/allMethod',
                        data: {
                                redicUrl:'/basic/api/v1.0/admin/surveyTemplate/getTemplateById',
                                postOrGet:'get',
                                paramJson:params
                            },//question 是否加载问题：1加载 0 不加载
                        method: "get",
                        dataType: "json",
                        success: function (res) {
                            if (res.successFlg) {
                                var data = res.obj;
                                var labels = data.labels;
                                $("#inp_wenjuan_name").val(data.title);
                                $("#tea_wenjuan_instruction").val(data.comment);
                                var allLabel = $(".div-label-content .div-label");
                                for(var i=0;i<allLabel.length;i++){
                                    var labelId = $(allLabel[i]).attr("data-id");
                                    for(var j=0;j<labels.length;j++){
                                        if(labelId==labels[j].label.toString()){
                                            $(allLabel[i]).find(".div-checkbox-img").addClass("active");
                                            break;
                                        }
                                    }
                                }
                            } else {
                                $.Notice.error(res.msg);
                            }
                        },
                        error: function (data) {
                            $.Notice.error("系统异常,请联系管理员！");
                        }
                    })
                },

            };

            /* ************************* Dialog页面回调接口 ************************** */



            /* *************************** 页面初始化 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>