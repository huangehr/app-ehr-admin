<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var addDoctorInfo = null;

        var dialog = frameElement.dialog;

        var source;
		var trees;

		var roleTypeDictId = 13;


        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        /**
         * 页面初始化。
         * @type {Function}
         */
        function pageInit() {
            addDoctorInfo.init();
            $("#div_addDoctor_form").show();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */

        addDoctorInfo = {
            $form: $("#div_addDoctor_form"),
            $incode: $("#inp_code"),
            $name: $('#inp_name'),
            $sex: $('input[name="sex"]', this.$form),
            $uploader: $("#div_doctor_img_upload"),
            //$inp_select_status: $("#inp_select_status"),
            $addBtn: $("#div_btn_add"),
            $cancelBtn: $("#div_cancel_btn"),
            $imageShow: $("#div_file_list"),
			$skill:$("#inp_skill"),
            $idCardNo:$("#inp_idCardNo"),
			$portal:$("#inp_portal"),
			$email:$("#inp_email"),
			$phone:$("#inp_phone"),
			$secondPhone:$("#inp_secondPhone"),
			$familyTel:$("#inp_familyTel"),
			$officeTel:$("#inp_officeTel"),
			$introduction:$("#inp_introduction"),
			$jxzc:$("#inp_jxzc"),
			$lczc:$("#inp_lczc"),
			$xlzc:$("#inp_xlzc"),
			$zxzc:$("#inp_zxzc"),
            $roleType:$("#inp_roleType"),

            init: function () {
                var self = this;
                self.$sex.eq(0).attr("checked", 'true');
                self.initForm();
                self.bindEvents();
                self.$uploader.instance = self.$uploader.webupload({
                    server: "${contextRoot}/doctor/updateDoctor",
                    pick: {id: '#div_file_picker'},
                    accept: {
                        title: 'Images',
                        extensions: 'gif,jpg,jpeg,bmp,png',
                        mimeTypes: 'image/*'
                    },
                    auto: false
                });
                self.$uploader.instance.on('uploadSuccess', function (file, resp) {
                    if(!resp.successFlg)
                        $.Notice.error(resp.errorMsg);
                    else
                        $.Notice.success('新增成功');
                        closeAddDoctorInfoDialog(function () {
                        });
                });
            },
            initForm: function () {
                this.$incode.ligerTextBox({width: 240});
                this.$name.ligerTextBox({width: 240});
                this.$idCardNo.ligerTextBox({width: 240});
                this.$email.ligerTextBox({width: 240});
                this.$skill.ligerTextBox({width: 240});
                this.$portal.ligerTextBox({width: 240});
                this.$phone.ligerTextBox({width: 240});
                this.$secondPhone.ligerTextBox({width: 240});
                this.$familyTel.ligerTextBox({width: 240});
                this.$officeTel.ligerTextBox({width: 240});
                this.$jxzc.ligerTextBox({width: 240});
                this.$lczc.ligerTextBox({width: 240});
                this.$xlzc.ligerTextBox({width: 240});
                this.$zxzc.ligerTextBox({width: 240});
                this.$introduction.ligerTextBox({width:600,height:100 });
                this.initDDL(roleTypeDictId, this.$roleType);
                this.$sex.ligerRadio();
                this.$form.attrScan();
            },
            initDDL: function (dictId, target) {
                target.ligerComboBox({
                    url: "${contextRoot}/dict/searchDictEntryList",
                    dataParmName: 'detailModelList',
                    urlParms: {dictId: dictId},
                    valueField: 'code',
                    textField: 'value'
                });
            },
            bindEvents: function () {
                var self = this;
                var validator = new jValidation.Validation(this.$form, {
                    immediate: true, onSubmit: false,
                    onElementValidateForAjax: function (elm) {
                        var checkObj = { result:true, errorMsg: ''};
                        if (Util.isStrEquals($(elm).attr("id"), 'inp_code')) {
                            var code = $("#inp_code").val();
                            checkObj= checkDataSourceName('code', code, "该账号已存在");
                        }
                        if (Util.isStrEquals($(elm).attr("id"), 'inp_idCardNo')) {
                            var CardNo = $("#inp_idCardNo").val();
                            checkObj= checkDataSourceName('idCardNo', CardNo, "该身份证号已存在");
                        }
                        if (Util.isStrEquals($(elm).attr("id"), 'inp_phone')) {
                            var phone = $("#inp_phone").val();
                            checkObj= checkDataSourceName('phone', phone, "该电话号码已存在");
                        }
                        if (Util.isStrEquals($(elm).attr("id"), 'inp_email')) {
                            var email = $("#inp_email").val();
                            checkObj= checkDataSourceName('email', email, "该邮箱已存在");
                        }
                        if (!checkObj.result) {
                            return checkObj;
                        } else {
                            return checkObj.result;
                        }
                    }
                });
                //唯一性验证--账号(字段名、输入值、提示信息）
                function checkDataSourceName(type, inputValue, errorMsg) {
                    var result = new jValidation.ajax.Result();
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/doctor/existence", {
                        data: {existenceType: type, existenceNm: inputValue},
                        async: false,
                        success: function (data) {
                            if (data.successFlg) {
                                result.setResult(false);
                                result.setErrorMsg(errorMsg);
                            } else {
                                result.setResult(true);
                            }
                        }
                    });
                    return result;
                }

                //新增的点击事件
                this.$addBtn.click(function () {
                    var imgHtml = self.$imageShow.children().length;
                    var addDoctor = self.$form.Fields.getValues();
                    if (validator.validate()) {
                        if (imgHtml == 0) {
                            update(addDoctor);
                        } else {
                            var upload = self.$uploader.instance;
                            var image = upload.getFiles().length;
                            if (image) {
                                upload.options.formData.doctorModelJsonData = encodeURIComponent(JSON.stringify(addDoctor));
                                upload.upload();
                            } else {
                                update(addDoctor);
                            }
                        }

                    } else {
                        return;
                    }


                });

                function update(doctorModel) {
                    var doctorModelJsonData = JSON.stringify(doctorModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/doctor/updateDoctor", {
                        data: {doctorModelJsonData: doctorModelJsonData},
                        success: function (data) {
                            if (data.successFlg) {
                                win.parent.reloadMasterUpdateGrid();
                                win.parent.showAddSuccPop();
                                win.parent.closeAddDoctorInfoDialog();
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    })
                }

                self.$cancelBtn.click(function () {
                    win.parent.closeAddDoctorInfoDialog();
                });
            }
        };
        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */

        pageInit();

        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
</script>