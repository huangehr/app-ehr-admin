<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var icd10Info = null;

		// 表单校验工具类
		var jValidation = $.jValidation;
		var mode = '${mode}';
		var codeCopy = '';
		var nameCopy = '';


		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			icd10Info.init();
		}

		/* *************************** 模块初始化 ***************************** */
		icd10Info = {
			$form: $("#div_drug_info_form"),
			$drugCode: $("#inp_drug_code"),
			$drugName: $('#inp_drug_name'),
			$drugType: $('#inp_drug_type'),
			$drugFlag: $('#inp_drug_flag'),
			$drugTradeName: $('#inp_drug_tradeName'),
			$drugUnit: $('#inp_drug_unit'),
			$specifications:$('#inp_drug_specifications'),
			$description: $('#inp_drug_description'),

			$updateBtn: $("#btn_save"),
			$cancelBtn: $("#btn_cancel"),

			init: function () {
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				this.$drugCode.ligerTextBox({width:240});
				this.$drugName.ligerTextBox({width:240});
				this.$drugType.ligerComboBox({
					url: "${contextRoot}/dict/searchDictEntryList",
					valueField: 'code',
					textField: 'value',
					dataParmName: 'detailModelList',
					urlParms: {
						dictId: 24
					},
					onSuccess: function () {
					}
				})
				this.$drugFlag.ligerComboBox({
					url: "${contextRoot}/dict/searchDictEntryList",
					valueField: 'code',
					textField: 'value',
					dataParmName: 'detailModelList',
					urlParms: {
						dictId: 25
					},
					onSuccess: function () {
					}
				})
				this.$drugTradeName.ligerTextBox({width:240});
				this.$drugType.ligerTextBox({width: 240});
				this.$drugUnit.ligerTextBox({width: 240});
				this.$specifications.ligerTextBox({width:240});
				this.$description.ligerTextBox({width: 240,height:120});
				if(mode != 'new'){
					var info = ${envelop}.obj;
					codeCopy = info.code;
					nameCopy = info.name;
					this.$form.attrScan();
					this.$form.Fields.fillValues({
						id: info.id,
						code: info.code,
						name: info.name,
						type: info.type,
						flag: info.flag,
						tradeName:info.tradeName,
						unit: info.unit,
						specifications:info.specifications,
						description: info.description,
					});
				}
			},
			bindEvents: function () {
				var self = this;
				var validator =  new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,
					onElementValidateForAjax: function (elm) {
						if (Util.isStrEquals($(elm).attr("id"), 'inp_drug_code')) {
							var code = $("#inp_drug_code").val();
							if(Util.isStrEmpty(codeCopy)||(!Util.isStrEmpty(codeCopy)&&!Util.isStrEquals(code,codeCopy))){
								return checkUnique("${contextRoot}/specialdict/drug/isCodeExist",code,"字典编码不能重复！");
							}
						}
						if (Util.isStrEquals($(elm).attr("id"), 'inp_drug_name')) {
							var name = $("#inp_drug_name").val();
							if(Util.isStrEmpty(nameCopy)||(!Util.isNum(nameCopy)&&!Util.isStrEquals(name,nameCopy))){
								return checkUnique("${contextRoot}/specialdict/drug/isNameExist",name,"字典名称不能重复！");
							}
						}
					}
				});
				//验证编码、名字不可重复
				function checkUnique(url, value, errorMsg) {
					var result = new jValidation.ajax.Result();
					var dataModel = $.DataModel.init();
					dataModel.fetchRemote(url, {
						data: {code:value,name:value},
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
				//新增、修改
				self.$updateBtn.click(function () {
					if(validator.validate()){
						var dataModel = $.DataModel.init();
						self.$form.attrScan();
						var drugModel = self.$form.Fields.getValues();
                        var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
						dataModel.createRemote("${contextRoot}/specialdict/drug/update", {
							data:  {dictJson:JSON.stringify(drugModel),mode:mode},
							success: function (data) {
                                waittingDialog.close();
								if(data.successFlg){
									reloadDrugInfoGrid();
									$.Notice.success('操作成功');
									win.closeDrugInfoDialog();
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
					win.closeDrugInfoDialog();
				});
			}
		};

		/* *************************** 页面初始化 **************************** */
		pageInit();

	})(jQuery, window);
</script>