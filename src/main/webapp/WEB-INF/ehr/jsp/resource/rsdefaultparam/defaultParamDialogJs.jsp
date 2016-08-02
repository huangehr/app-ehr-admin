<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript">
	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var paramDataInfo = null;
		var jValidation = $.jValidation;
		var mode = '${mode}';
		var paramValueCopy = '';
		var rowIndex = '${rowIndex}';
		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			paramDataInfo.initForm();
		}
		/* *************************** 模块初始化 ***************************** */
		paramDataInfo = {
			$form: $("#div_data_info_form"),
			$paramKey: $('#inp_paramKey'),
			$paramValue: $('#inp_paramValue'),

			$updateBtn: $("#btn_save"),
			$cancelBtn: $("#btn_cancel"),

//			init: function () {
//				this.initForm();
//				this.bindEvents();
//			},
			initForm: function () {
				this.$paramKey.ligerComboBox({
					url: "${contextRoot}/dict/searchDictEntryList",
					dataParmName: 'detailModelList',
					urlParms: {dictId: 51},
					valueField: 'code',
					textField: 'value'
				});
				this.$paramValue.ligerTextBox({width: 240});
				$("#sourceId").val('${resourcesId}');
				$("#sourceCode").val('${resourcesCode}');
				if(mode != 'new'){
					var info = ${info}.obj;
					paramValueCopy = info.paramValue;
					this.$form.attrScan();
					this.$form.Fields.fillValues({
						id: info.id,
						resourcesId: info.resourcesId,
						resourcesCode: info.resourcesCode,
						paramKey:info.paramKey,
						paramValue:info.paramValue,
					});
				}
				this.bindEvents();
			},
			bindEvents: function () {
				var self = this;
				var validator =  new jValidation.Validation(self.$form, {immediate: true, onSubmit: false,
					onElementValidateForAjax: function (elm) {
						if (Util.isStrEquals($(elm).attr("id"), 'inp_paramValue')) {
							var paramValue = $("#inp_paramValue").val();
							var paramKey = $("#inp_paramKey").val()
							if(Util.isStrEmpty(paramValueCopy)||(!Util.isStrEmpty(paramValueCopy)&&!Util.isStrEquals(paramValue,paramValueCopy))){
								return checkUnique("${contextRoot}/resource/rsDefaultParam/isKeyValueExistence",paramKey,paramValue,"同个资源同个参数名的值不能重复！");
							}
						}
					}
				});

				function checkUnique(url,paramKey,paramValue, errorMsg) {
					var result = new jValidation.ajax.Result();
					var resourcesId = $("#sourceId").val();;
					var dataModel = $.DataModel.init();
					dataModel.fetchRemote(url, {
						data: {resourcesId:resourcesId,paramKey:paramKey,paramValue:paramValue},
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
						var model = self.$form.Fields.getValues();
						dataModel.createRemote("${contextRoot}/resource/rsDefaultParam/update", {
							data:  {dataJson:JSON.stringify(model),mode:mode},
							success: function (data) {
								if(data.successFlg){
									if(!Util.isStrEquals(mode,'new')){
										parent.updateParamMasterInfo(rowIndex,data.obj);
										win.closeParamMasterInfoDialog();
										return
									}
									parent.addParamMasterInfo(data.obj);
									win.closeParamMasterInfoDialog();
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
					win.closeParamMasterInfoDialog();
				});
			}
		};

		/* *************************** 页面初始化 **************************** */
		pageInit();

	})(jQuery, window);
</script>