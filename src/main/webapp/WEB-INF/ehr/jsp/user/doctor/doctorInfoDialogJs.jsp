<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;
        var doctorInfo = null;

        //修改变量
        var doctorModel = null;

        var dialog = null;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var allData = ${allData};
        var doctor = allData.obj;

        var roleTypeDictId = 15;

        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            doctorInfo.init();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */
        doctorInfo = {
            $form: $("#div_info_form"),
            $incode: $("#inp_code"),
            $name: $('#inp_name'),
            $idCardNo:$("#inp_idCardNo"),
            $sex: $('input[name="sex"]', this.$form),
            $uploader: $("#div_doctor_img_upload"),
            $skill:$("#inp_skill"),
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
            $filePicker: $("#div_file_picker"),
            $imageShow: $("#div_file_list"),
            $updateDtn: $("#div_update_btn"),
            $cancelBtn: $("#div_cancel_btn"),
            $roleType:$("#inp_roleType"),

            init: function () {
				var self = this;

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
                    auto: false,
                    async:false
                });
                self.$uploader.instance.on('uploadSuccess', function (file, resp) {
                    if(!resp.successFlg)
                        $.Notice.error(resp.errorMsg);
                    else
                        $.Notice.success('修改成功');
                    closeAddDoctorInfoDialog(function () {});
                });
            },//树形结构todo
            initForm: function () {
                var self = this;
                this.$form.removeClass("m-form-readonly");
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
                $imageShow: $('#div_file_list'),
                this.$form.attrScan();
                this.$form.Fields.fillValues({
                    id: doctor.id,
                    code: doctor.code,
                    name: doctor.name,
                    idCardNo: doctor.idCardNo,
                    sex: doctor.sex,
                    email: doctor.email,
                    skill: doctor.skill,
                    workPortal: doctor.workPortal,
                    introduction: doctor.introduction,
                    phone: doctor.phone,
                    secondPhone: doctor.secondPhone,
                    familyTel: doctor.familyTel,
                    officeTel: doctor.officeTel,
                    jxzc: doctor.jxzc,
                    lczc: doctor.lczc,
                    xlzc: doctor.xlzc,
                    xzzc: doctor.xzzc,
                    roleType: doctor.roleType
                });


                var pic = doctor.photo;
                if (!Util.isStrEmpty(pic)) {
                    self.$imageShow.html('<img src="${contextRoot}/doctor/showImage?timestamp='+(new Date()).valueOf()+'" class="f-w88 f-h110"></img>');
                }
                if ('${mode}' == 'view') {
                    this.$form.addClass("m-form-readonly");
                    this.$cancelBtn.hide();
                    this.$updateDtn.hide();
                    this.$filePicker.hide();
                }
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
                    onElementValidateForAjax: function (elm) {    }
                });

                //修改的点击事件
                this.$updateDtn.click(function () {

                    var imgHtml = self.$imageShow.children().length;
                    if (validator.validate()) {
                        doctorModel = self.$form.Fields.getValues();
                        if (imgHtml == 0) {
                            update(doctorModel);
                        } else {
                            var upload = self.$uploader.instance;
                            var image = upload.getFiles().length;
                            if (image) {
                                upload.options.formData.doctorModelJsonData = encodeURIComponent(JSON.stringify(doctorModel));
                                upload.upload();
                                win.reloadMasterUpdateGrid();
                            } else {
                                update(doctorModel);
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
                                win.closeDoctorInfoDialog();
                                win.reloadMasterUpdateGrid();
                                $.Notice.success('修改成功');
                            } else {
                                $.Notice.error('修改失败');
                            }
                        }
                    })
                }

                this.$cancelBtn.click(function () {
                    win.closeDoctorInfoDialog();
                });
            }

        };

        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */

        pageInit();
        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
</script>