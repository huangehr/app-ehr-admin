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
			$form: $("#div_icd_info_form"),
			$icd10Code: $("#inp_icd10_code"),
			$icd10Name: $('#inp_icd10_name'),
			$chronicFlag: $('#inp_chronicFlag'),
			$infectiousFlag: $('#inp_infectiousFlag'),
			//$icd10Flag: $('input[name="gender"]', this.$form),
			$dataSet:$('#inp_data_set'),
			$metaData:$('#inp_meta_data'),
			$description: $('#inp_icd10_description'),

			$updateBtn: $("#btn_save"),
			$cancelBtn: $("#btn_cancel"),

			init: function () {
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				this.$icd10Code.ligerTextBox({width: 240});
				this.$icd10Name.ligerTextBox({width: 240});
				this.$chronicFlag.ligerCheckBox({});
				this.$infectiousFlag.ligerCheckBox({});
				this.$dataSet.ligerComboBox({
					url: '${contextRoot}/dict/searchDictEntryList',
					valueField: 'code',
					textField: 'value',
					dataParmName: 'detailModelList',
					urlParms: {
						dictId: 4
					},
					onSuccess: function () {

					}
				});
				this.$metaData.ligerComboBox({
					url: '${contextRoot}/dict/searchDictEntryList',
					valueField: 'code',
					textField: 'value',
					dataParmName: 'detailModelList',
					urlParms: {
						dictId: 4
					},
					onSuccess: function () {
					}
				});
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
						chronicFlag:info.chronicFlag,
						infectiousFlag:info.infectiousFlag,
						description: info.description,
					});
				}
			},
			bindEvents: function () {
				var self = this;
				var validator =  new jValidation.Validation(self.$form, {immediate: true, onSubmit: false,
					onElementValidateForAjax: function (elm) {
						if (Util.isStrEquals($(elm).attr("id"), 'inp_icd10_code')) {
							var code = $("#inp_icd10_code").val();
							if(Util.isStrEmpty(codeCopy)||(!Util.isStrEmpty(codeCopy)&&!Util.isStrEquals(code,codeCopy))){
								return checkUnique("${contextRoot}/specialdict/icd10/isCodeExist",code,"字典编码不能重复！");
							}
						}
						if (Util.isStrEquals($(elm).attr("id"), 'inp_icd10_name')) {
							var name = $("#inp_icd10_name").val();
							if(Util.isStrEmpty(nameCopy)||(!Util.isStrEmpty(nameCopy)&&!Util.isStrEquals(name,nameCopy))){
								return checkUnique("${contextRoot}/specialdict/icd10/isNameExist",name,"字典名称不能重复！");
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
						var icd10Model = self.$form.Fields.getValues();
						var chronicFlags = icd10Model.chronicFlag;
						var infectiousFlags = icd10Model.infectiousFlag;
						icd10Model.chronicFlag = chronicFlags[0];
						icd10Model.infectiousFlag = infectiousFlags[0];
                        var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
						dataModel.createRemote("${contextRoot}/specialdict/icd10/update", {
							data:  {icd10JsonData:JSON.stringify(icd10Model),mode:mode},
							success: function (data) {
                                waittingDialog.close();
								if(data.successFlg){
									reloadIcd10InfoGrid();
									$.Notice.success('操作成功');
									win.closeIcd10InfoDialog();
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
					win.closeIcd10InfoDialog();
				});
			}
		};

		/* *************************** 页面初始化 **************************** */
		pageInit();

	})(jQuery, window);
</script>