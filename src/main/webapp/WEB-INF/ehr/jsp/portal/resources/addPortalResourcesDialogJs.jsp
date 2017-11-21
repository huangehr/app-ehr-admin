<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
$(function () {
    

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 表单校验工具类
        var jValidation = $.jValidation;
        var addResourcesInfo = null;
        var dialog = frameElement.dialog;
        var source;
        var trees;


        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        /**
         * 页面初始化。
         * @type {Function}
         */
        function pageInit() {
            addResourcesInfo.init();
            $("#div_addResources_form").show();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */

        addResourcesInfo = {
            $form: $("#div_addResources_form"),
            $addBtn: $("#div_btn_add"),
            $cancelBtn: $("#div_cancel_btn"),
            $imageShow: $("#div_file_list"),
            $uploader: $("#div_resources_img_upload"),
            $name:$("#inp_name"),
            $version:$("#inp_version"),
            $description:$("#inp_description"),
            $selectPlatformType: $("#inp_select_platform_type"),
            $selectDevelopLanType: $("#inp_select_portal_develop_lan"),
            $apkUrl:$("#apkUrl"),
            $androidUrl:$("#androidUrl"),
            $iosUrl:$("#iosUrl"),

//            $uploadApk: $("#apkUploadButton"),

            $inpFileAndroid: $('#inp_file_android'),
            $inpFileIosUrl: $('#inp_file_iosUrl'),
            $inpFileApk: $("#inp_file_apk"),


//
//            $uploadAndroid: $("#androidUploadButton"),
//            $uploadIos: $("#iosUploadButton"),

            init: function () {
                var self = this;
                self.initForm();
                self.bindEvents();
                self.$uploader.instance = self.$uploader.webupload({
                    server: "${contextRoot}/portalResources/updatePortalResources",
                    pick: {id: '#div_file_picker'},
//                    accept: {
//                        title: 'Images',
//                        extensions: 'gif,jpg,jpeg,bmp,png',
//                        mimeTypes: 'image/*'
//                    },
                auto: false
            });
            self.$uploader.instance.on('uploadSuccess', function (file, resp) {
                if(!resp.successFlg)
                    $.Notice.error(resp.errorMsg);
                else
                   $.Notice.success('新增成功');
                   win.top.closeAddPortalResourcesInfoDialog(function () {
                });
            });
        },
        initForm: function () {
            this.$name.ligerTextBox({width: 240});
            this.$version.ligerTextBox({width:240 });
            this.$description.ligerTextBox({width:240,height:50 });

            var platformType = this.$selectPlatformType.ligerComboBox({
            url: '${contextRoot}/dict/searchDictEntryList',
                valueField: 'code',
                textField: 'value',
                dataParmName: 'detailModelList',
                urlParms: {
                    dictId: 57
                },
                autocomplete: true,
                onSuccess: function (data) {
                    if (data.length > 0) {
                        platformType.setValue(data[0].code);
                    }
                }
            });

            var developLanType = this.$selectDevelopLanType.ligerComboBox({
                url: '${contextRoot}/dict/searchDictEntryList',
                valueField: 'code',
                textField: 'value',
                dataParmName: 'detailModelList',
                urlParms: {
                    dictId: 58
                },
                autocomplete: true,
                onSuccess: function (data) {
                    if (data.length > 0) {
                        developLanType.setValue(data[0].code);
                    }
                }
            });


            this.$form.attrScan();
        },

            bindEvents: function () {
                var self = this;
                var validator = new jValidation.Validation(this.$form, {
                    immediate: true, onSubmit: false,
                    onElementValidateForAjax: function (elm) {  }
                });

                //新增的点击事件
                this.$addBtn.click(function () {
                    var imgHtml = self.$imageShow.children().length;
                    var portalResources = self.$form.Fields.getValues();
                    if (validator.validate()) {
                        if (imgHtml == 0) {
                            update(portalResources);
                        } else {
                            var upload = self.$uploader.instance;
                            var image = upload.getFiles().length;
                            if (image) {
                                upload.options.formData.portalResourcesModelJsonData = encodeURIComponent(JSON.stringify(portalResources));
                                upload.upload();
                            } else {
                                update(portalResources);
                            }
                        }

                    } else {
                        return;
                    };
                });

                function update(ResourcesModel) {
                    var modelJsonData = JSON.stringify(ResourcesModel);
                    var dataModel = $.DataModel.init();

                    var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
                    dataModel.updateRemote("${contextRoot}/portalResources/updatePortalResources", {
                        data: {portalResourcesModelJsonData: modelJsonData},
                        success: function (data) {
                            waittingDialog.close();
                            if (data.successFlg) {
                                parent.closeAddPortalResourcesInfoDialog(function () {
                                    $.Notice.success('新增成功');
                                });
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    })
                }


                //change事件
                this.$inpFileApk.on( 'change', function () {
                    var url = '${contextRoot}/portalResources/portalResourcesFileUpload';
                    self.$apkUrl.val(doUpload(url, this));
                });
                this.$inpFileAndroid.on( 'change', function () {
                    var url = '${contextRoot}/portalResources/portalResourcesFileUploadAndriod';
                    self.$androidUrl.val(doUpload(url, this));
                });
                this.$inpFileIosUrl.on( 'change',function () {
                    var url = '${contextRoot}/portalResources/portalResourcesFileUploadIos';
                    self.$iosUrl.val( doUpload(url, this));
                });







                <%--this.$uploadApk.click(function () {--%>
                    <%--var url = '${contextRoot}/portalResources/portalResourcesFileUpload';--%>
                    <%--self.$apkUrl.val(doUpload(url));--%>
                <%--});--%>
                <%--this.$uploadAndroid.click(function () {--%>
                  <%--var url = '${contextRoot}/portalResources/portalResourcesFileUploadAndriod';--%>
                    <%--self.$androidUrl.val(doUpload(url));--%>
                <%--});--%>
                <%--this.$uploadIos.click(function () {--%>
                  <%--var url = '${contextRoot}/portalResources/portalResourcesFileUploadIos';--%>
                    <%--self.$iosUrl.val( doUpload(url));--%>
                <%--});--%>

                function doUpload(url, that) {
                    debugger
                    var fileType = $(that)[0].files[0].type;
                    if (fileType == 'image/png' || fileType == 'image/jpeg' || fileType == 'image/jpg' || fileType == 'image/x-png' || fileType == 'image/bmp') {
                        var formData = new FormData($( "#uploadForm" )[0]);
                        var fileUrl;
                        $.ajax({
                            url: url ,
                            type: 'POST',
                            data: formData,
                            async: false,
                            cache: false,
                            contentType: false,
                            processData: false,
                            success: function (returndata) {
                                if(returndata != "fail"){
    //                                alert("上传成功");
                                    $.Notice.success('上传成功');
                                    fileUrl = returndata;
                                }else{
    //                                alert("上传失败");
                                    $.Notice.error('上传失败');
                                }
                            },
                            error: function (returndata) {
    //                            alert("上传失败");
                                $.Notice.error('上传失败');
                            }
                        });
                        return fileUrl;
                    } else {
                        $.Notice.error('上传的图片文件格式不正确');
                        return '';
                    }
                }

                self.$cancelBtn.click(function () {
                    dialog.close();
                });

                self.$cancelBtn.click(function () {
                    dialog.close();
                });
            }
        };

        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */

        pageInit();

        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
});
</script>