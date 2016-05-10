<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var diagnoseInfo = null;
		// 表单校验工具类
		var jValidation = $.jValidation;
		var mode = '${mode}';
		var icd10Id = '${icd10Id}'
		var nameCopy = '';


		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			diagnoseInfo.init();
		}

		/* *************************** 模块初始化 ***************************** */
		diagnoseInfo = {
			$form: $("#div_diagnose_info_form"),
			$diagnoseName: $('#inp_diagnose_name'),
			$description: $('#inp_diagnose_description'),
			$updateBtn: $("#btn_save"),
			$cancelBtn: $("#btn_cancel"),

			init: function () {
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				this.$diagnoseName.ligerTextBox({width:240});
				this.$description.ligerTextBox({width: 240,height:120});
				if(mode != 'view'){
					$(".my-footer").show();
				}
				if(mode == 'view'){
					diagnoseInfo.$form.addClass('m-form-readonly')
				}
				if(mode != 'new'){
					var info = ${envelop}.obj;
					nameCopy = info.name;
					this.$form.attrScan();
					this.$form.Fields.fillValues({
						id: info.id,
						icd10Id:info.icd10Id,
						name: info.name,
						description: info.description,
					});
				}
			},
			bindEvents: function () {
				var self = this;
				var validator =  new jValidation.Validation(self.$form, {immediate: true, onSubmit: false,
					onElementValidateForAjax: function (elm) {
						if (Util.isStrEquals($(elm).attr("id"), 'inp_diagnose_name')) {
							var name = $("#inp_diagnose_name").val();
							if(Util.isStrEmpty(nameCopy)||(!Util.isStrEmpty(nameCopy)&&!Util.isStrEquals(name,nameCopy))){
								var result = new jValidation.ajax.Result();
								var dataModel = $.DataModel.init();
								dataModel.fetchRemote("${contextRoot}/specialdict/icd10/diagnose/isNameExist", {
									data: {name:name,icd10Id:icd10Id},
									async: false,
									success: function (data) {
										if (data.successFlg) {
											result.setResult(false);
											result.setErrorMsg("同个icd10关联的诊断名称不能重复！");
										} else {
											result.setResult(true);
										}
									}
								});
								return result;
							}
						}
					}
				});
				//新增、修改
				self.$updateBtn.click(function () {
					if(validator.validate()){
						var dataModel = $.DataModel.init();
						self.$form.attrScan();
						var diagnoseModel = self.$form.Fields.getValues();
						if(Util.isStrEquals('new',mode)){
							diagnoseModel.icd10Id = icd10Id;
						}
						dataModel.createRemote("${contextRoot}/specialdict/icd10/diagnose/update", {
							data:  {dataJson:JSON.stringify(diagnoseModel),mode:mode},
							success: function (data) {
								if(data.successFlg){
									$.Notice.success('操作成功');
									parent.reloadRelationInfoDialog();
									win.closeCreateRelationDialog();
								}else{
									$.Notice.error(data.errorMsg);
								}
							}
						})
					}else{
						return;
					}
				});
				self.$cancelBtn.click(function(){
					win.closeCreateRelationDialog();
				});
			}
		};

		/* *************************** 页面初始化 **************************** */
		pageInit();

	})(jQuery, window);
</script>