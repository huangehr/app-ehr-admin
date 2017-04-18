<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var appInfoForm = null;
        // 表单校验工具类
        var jValidation = $.jValidation;
		var dictId = 43;
        var typeDictId=66;
        var mode = '${mode}';
        var oldCardNo = '';

		/* *************************** 函数定义 ******************************* */
        function pageInit() {
            appInfoForm.init();
        }
        /* *************************** 模块初始化 ***************************** */
        var trees;
        appInfoForm = {
			$form: $("#div_cards_info_form"),

			$cardType: $("#inp_card_type"),
            $cardNo: $("#inp_card_no"),
			$releaseOrg:$('#inp_release_org'),
			$releaseDate: $("#inp_release_date"),
			$validityDateBegin: $("#inp_validity_date_begin"),
            $validityDateEnd: $("#inp_validity_date_end"),
            $description: $("#inp_description"),
            $status: $("#inp_status"),

			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),

            init: function () {
                this.initForm();
                this.bindEvents();
            },
            initForm: function () {
                this.$cardNo.ligerTextBox({width:240});
				this.initDDL(dictId, this.$status);
                this.initDDL(typeDictId, this.$cardType);

                this.$releaseOrg.ligerTextBox({width:240});
                this.$releaseDate.ligerDateEditor({format: "yyyy-MM-dd"});
                this.$validityDateBegin.ligerDateEditor({format: "yyyy-MM-dd"});
                this.$validityDateEnd.ligerDateEditor({format: "yyyy-MM-dd"});
                this.$description.ligerTextBox({width:240, height: 120 });


				if(mode != 'view'){
					$(".my-footer").show();
				}
				if(mode == 'view'){
					appInfoForm.$form.addClass('m-form-readonly');
                    $(".m-form-control .l-text-trigger-cancel").remove();
					$("#btn_save").hide();
					$("#btn_cancel").hide();
				}
                this.$form.attrScan();
                if(mode != 'new'){
                    var medicalCards =${allData}.obj;
                    this.$form.Fields.fillValues({
                        id:medicalCards.id,
                        cardNo: medicalCards.cardNo,
                        releaseOrg:medicalCards.releaseOrg,
                        releaseDate:medicalCards.releaseDate.substring(0,10),
                        validityDateBegin:medicalCards.validityDateBegin.substring(0,10),
                        validityDateEnd:medicalCards.validityDateEnd.substring(0,10),
                        description:medicalCards.description
                    });
					$("#inp_status").ligerGetComboBoxManager().setValue(medicalCards.status);
                    if(medicalCards.status==1){
                        $("#inp_status").ligerGetComboBoxManager().setText('有效');
                    }else if(medicalCards.status==0){
                        $("#inp_status").ligerGetComboBoxManager().setText('无效');
                    }

                    $("#inp_card_type").ligerGetComboBoxManager().setValue(medicalCards.cardType);
                    $("#inp_card_type").ligerGetComboBoxManager().setText(medicalCards.cardTypeName);
                    oldCardNo = medicalCards.cardNo;
                }
                this.$form.show();
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
                var validator =  new jValidation.Validation(this.$form, {immediate:true,onSubmit:false,
                });
                this.$btnSave.click(function () {
                    if(validator.validate()){
                        var values = self.$form.Fields.getValues();
                        var dataModel = $.DataModel.init();
                        dataModel.updateRemote("${contextRoot}/medicalCards/updateMedicalCards", {
                            data:{
                                medicalCardsModelJsonData:JSON.stringify(values),
                                oldCardNo:oldCardNo
                            },

                            success: function(data) {
                                if (data.successFlg) {
                                    $.Notice.success('操作成功');
                                    win.reloadMasterGrid();
                                    win.closeDialog();
                                } else {
                                    $.Notice.error(data.errorMsg);
                                }
                            }
                        });
                    }else{
                        return;
                    }
                });

                this.$btnCancel.click(function () {
					win.closeDialog();
                });
            }

        };

        /* *************************** 页面初始化 **************************** */
        pageInit();

    })(jQuery, window);
</script>