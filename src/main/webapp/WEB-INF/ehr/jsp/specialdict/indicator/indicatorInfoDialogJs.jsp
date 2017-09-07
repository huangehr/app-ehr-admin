<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var indicatorInfo = null;

		// 表单校验工具类
		var jValidation = $.jValidation;
		var mode = '${mode}';
		var codeCopy = '';
		var nameCopy = '';

		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			indicatorInfo.init();
		}

		/* *************************** 模块初始化 ***************************** */
		indicatorInfo = {
			$form: $("#div_indicator_info_form"),
			$indicatorCode: $("#inp_indicator_code"),
			$indicatorName: $('#inp_indicator_name'),
			$indicatorType: $('#inp_indicator_type'),
			$indicatorUnit: $('#inp_indicator_unit'),
			$indicatorUpperLimit: $('#inp_indicator_upperLimit'),
			$indicatorLowerLimit: $('#inp_indicator_lowerLimit'),
			$description: $('#inp_indicator_description'),

			$updateBtn: $("#btn_save"),
			$cancelBtn: $("#btn_cancel"),

			init: function () {
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				this.$indicatorCode.ligerTextBox({width:240});
				this.$indicatorName.ligerTextBox({width:240});
				this.$indicatorType.ligerComboBox({
					url: "${contextRoot}/dict/searchDictEntryList",
					valueField: 'code',
					textField: 'value',
					dataParmName: 'detailModelList',
					urlParms: {
						dictId: 23
					},
					onSuccess: function () {
					}
				})
				this.$indicatorUnit.ligerTextBox({width:240});
				this.$indicatorUpperLimit.ligerTextBox({width: 240});
				this.$indicatorLowerLimit.ligerTextBox({width: 240});
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
						unit: info.unit,
						upperLimit: info.upperLimit,
						lowerLimit: info.lowerLimit,
						description: info.description,
					});
				}
			},
			bindEvents: function () {
				var self = this;
				var validator =  new jValidation.Validation(self.$form, {immediate: true, onSubmit: false,
					onElementValidateForAjax: function (elm) {
						if (Util.isStrEquals($(elm).attr("id"), 'inp_indicator_code')) {
							var code = $("#inp_indicator_code").val();
							if(Util.isStrEmpty(codeCopy)||(!Util.isStrEmpty(codeCopy)&&!Util.isStrEquals(code,codeCopy))){
								return checkUnique("${contextRoot}/specialdict/indicator/isCodeExist",code,"字典编码不能重复！");
							}
						}
						if (Util.isStrEquals($(elm).attr("id"), 'inp_indicator_name')) {
							var name = $("#inp_indicator_name").val();
							if(Util.isStrEmpty(nameCopy)||(!Util.isStrEmpty(nameCopy)&&!Util.isStrEquals(name,nameCopy))){
								return checkUnique("${contextRoot}/specialdict/indicator/isNameExist",name,"字典名称不能重复！");
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
						var indicatorModel = self.$form.Fields.getValues();
                        var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
						dataModel.createRemote("${contextRoot}/specialdict/indicator/update", {
							data:  {dictJson:JSON.stringify(indicatorModel),mode:mode},
							success: function (data) {
                                waittingDialog.close();
								if(data.successFlg){
									reloadIndicatorInfoGrid();
									$.Notice.success('操作成功');
									win.closeIndicatorInfoDialog();
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
					win.closeIndicatorInfoDialog();
				});
			}
		};

		/* *************************** 页面初始化 **************************** */
		pageInit();

	})(jQuery, window);
</script>