<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript" src="${staticRoot}/Scripts/homeRelationship.js"></script>
<script>
    (function ($, win) {

        debugger
        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 页面主模块，对应于用户信息表区域
        var healthBusinessInfo = null;
        var jValidation = $.jValidation;  // 表单校验工具类
        var dataModel = $.DataModel.init();
        var parentSelectedVal = "";
        var validator = null;


        /* ************************** 变量定义结束 ******************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            healthBusinessInfo.init();
        }

        /* *************************** 函数定义结束******************************* */

        /* *************************** 模块初始化 ***************************** */
        healthBusinessInfo = {
            $form: $("#div_patient_info_form"),
            $inpFileIosUrl: $('#inp_file_iosUrl'),
            $iosUrl:$("#iosUrl"),
            weekDialog: null,
            init: function () {
                this.initForm();
                this.bindEvents();
            },
            parentSelected:function(pid, name){
                parentSelectedVal = pid;
            },
            initForm: function () {
                var self = this;
                self.$form.attrScan();
            },

            bindEvents: function () {
                var self = this;
                this.$inpFileIosUrl.on( 'change',function () {
                var url = '${contextRoot}/elasticSearch/addElastic';
                self.$iosUrl.val(doUpload(url, this));
                });

                function doUpload(url, that) {
                    debugger
                    var fileName = $(that)[0].files[0].name;
                    var suffix = fileName.substring(fileName.lastIndexOf(".")+1);
                    if ("json" == suffix) {
                        var formData = new FormData($( "#uploadForm" )[0]);
                        var fileUrl;
                        $.ajax({
                            url: url,
                            type: 'POST',
                            data: formData,
                            async: false,
                            cache: false,
                            contentType: false,
                            processData: false,
                            success: function (returndata) {
                                if(returndata != "fail"){
//                                    $.Notice.success('成功');
                                    fileUrl = returndata;
                                }else{
                                    $.Notice.error('失败');
                                }
                            },
                            error: function (returndata) {
                                $.Notice.error('失败');
                            }
                        });
                        return fileUrl;
                    } else {
                        $.Notice.error('文件格式不正确');
                        return '';
                    }
                }

                //关闭dailog的方法
                healthBusinessInfo.$cancelBtn.click(function(){
                    closeDialog();
                })
            }
        };

        /* *************************** 模块初始化结束 ***************************** */

        /* ******************Dialog页面回调接口****************************** */
        win.weekDialogBack = function (execTypeBack,execTimeBack,cronBack) {
            win.execTypeB = execTypeBack;
            win.execTimeB = execTimeBack;
            win.cronB = cronBack;
            zhiBiaoInfo.weekDialog.close();
        };

        win.closeWeekDialog = function () {
            zhiBiaoInfo.weekDialog.close();
        };

        /* *************************** 页面初始化 **************************** */
        pageInit();
        /* *************************** 页面初始化结束 **************************** */


    })(jQuery, window);
</script>