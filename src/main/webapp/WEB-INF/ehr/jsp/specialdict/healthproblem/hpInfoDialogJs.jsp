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
			$hpCode: $("#inp_hp_code"),
			$hpName: $('#inp_hp_name'),
			$description: $('#inp_hp_description'),

			$updateBtn: $("#btn_save"),
			$cancelBtn: $("#btn_cancel"),

			init: function () {
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				this.$hpCode.ligerTextBox({width:240});
				this.$hpName.ligerTextBox({width:240});
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
						description: info.description,
					});
				}
			},
			bindEvents: function () {
				var self = this;
				var validator =  new jValidation.Validation(self.$form, {immediate: true, onSubmit: false,
					onElementValidateForAjax: function (elm) {
						if (Util.isStrEquals($(elm).attr("id"), 'inp_hp_code')) {
							var code = $("#inp_hp_code").val();
							if(Util.isStrEmpty(codeCopy)||(!Util.isStrEmpty(codeCopy)&&!Util.isStrEquals(code,codeCopy))){
								return checkUnique("${contextRoot}/specialdict/hp/isCodeExist",code,"字典编码不能重复！");
							}
						}
						if (Util.isStrEquals($(elm).attr("id"), 'inp_hp_name')) {
							var name = $("#inp_hp_name").val();
							if(Util.isStrEmpty(nameCopy)||(!Util.isStrEmpty(nameCopy)&&!Util.isStrEquals(name,nameCopy))){
								return checkUnique("${contextRoot}/specialdict/hp/isNameExist",name,"字典名称不能重复！");
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
						var hpgModel = self.$form.Fields.getValues();
						dataModel.createRemote("${contextRoot}/specialdict/hp/update", {
							data:  {dictJson:JSON.stringify(hpgModel),mode:mode},
							success: function (data) {
								if(data.successFlg){
									parent.reloadHpInfoGrid();
									$.Notice.success('操作成功');
									win.closeHpInfoDialog();
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
					win.closeHpInfoDialog();
				});
			}
		};

		/* *************************** 页面初始化 **************************** */
		pageInit();

	})(jQuery, window);
</script>