<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var appInfoForm = null;
        // 表单校验工具类
        var jValidation = $.jValidation;
		var eventTypeDictId = 64;
        var typeDictId=66;
        var mode = '${mode}';

		/* *************************** 函数定义 ******************************* */
        function pageInit() {
            appInfoForm.init();
        }
        /* *************************** 模块初始化 ***************************** */
        var trees;
        appInfoForm = {
			$form: $("#div_cards_info_form"),

            $orgCode: $("#inp_orgCode"),
            $orgName: $("#inp_orgName"),
            $name: $("#inp_sname"),
            $idCardNo: $("#inp_idCardNo"),
			$cardType: $("#inp_cardType"),
            $cardNo: $("#inp_cardNo"),
			$eventNo: $("#inp_eventNo"),
            $eventDate: $("#inp_eventDate"),
            $eventType: $("#inp_eventType"),

			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),

            init: function () {
                this.initForm();
                this.bindEvents();
            },
            initForm: function () {
                this.$orgCode.ligerTextBox({width:240});
                this.$orgName.ligerTextBox({width:240});
                this.$name.ligerTextBox({width:240});
                this.$idCardNo.ligerTextBox({width:240});
                this.$cardNo.ligerTextBox({width:240});
                this.$eventNo.ligerTextBox({width:240});
                this.$eventDate.ligerDateEditor({format: "yyyy-MM-dd"});

                this.initDDL(typeDictId, this.$cardType);
                this.initDDL(eventTypeDictId, this.$eventType);


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
                    var archiveRelation =${allData}.obj;
                    this.$form.Fields.fillValues({
                        id:archiveRelation.id,
                        orgCode:archiveRelation.orgCode,
                        orgName:archiveRelation.orgName,
                        name:archiveRelation.name,
                        idCardNo:archiveRelation.idCardNo,
                        cardNo: archiveRelation.cardNo,
                        eventDate:archiveRelation.eventDate.substring(0,10),
                        eventNo:archiveRelation.eventNo
                    });

                    $("#inp_eventType").ligerGetComboBoxManager().setValue(archiveRelation.eventType);
                    $("#inp_eventType").ligerGetComboBoxManager().setText(archiveRelation.eventTypeName);

                    $("#inp_cardType").ligerGetComboBoxManager().setValue(archiveRelation.cardType);
                    $("#inp_cardType").ligerGetComboBoxManager().setText(archiveRelation.cardTypeName);
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
                        dataModel.updateRemote("${contextRoot}/userCards/updateArchiveRelationInfo", {
                            data:{
                                archiveRelationModelJsonData:JSON.stringify(values)
                            },

                            success: function(data) {
                                if (data.successFlg) {
                                    $.Notice.success('操作成功');
                                    win.closeDialog();
                                    win.reloadMasterGrid();
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