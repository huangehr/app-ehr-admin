<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2016/5/24
  Time: 9:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript">
	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var dataInfo = null;
		var jValidation = $.jValidation;
		var mode = '${mode}';
		var nameCopy = '';
		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			dataInfo.init();
		}
		/* *************************** 模块初始化 ***************************** */
		dataInfo = {
			$form: $("#div_data_info_form"),
			$name: $("#inp_name"),
			$resourceInterface: $('#inp_code'),
			$paramDescription: $('#inp_params'),
			$resultDescription: $('#inp_result_format'),
			$description: $('#inp_description'),

			$updateBtn: $("#btn_save"),
			$cancelBtn: $("#btn_cancel"),

			init: function () {
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				this.$name.ligerTextBox({width:350});
				this.$resourceInterface.ligerTextBox({width: 350,height:50});
				this.$paramDescription.ligerTextBox({width: 350,height:100});
				this.$resultDescription.ligerTextBox({width: 350,height:200});
				this.$description.ligerTextBox({width: 350,height:50});

				if(mode != 'new'){
					var info = ${envelop}.obj;
					nameCopy = info.name;
					this.$form.attrScan();
					this.$form.Fields.fillValues({
						id: info.id,
						name: info.name,
						resourceInterface: info.resourceInterface,
						paramDescription:info.paramDescription,
						resultDescription:info.resultDescription,
						description: info.description,
					});
				}
				if(mode == 'view'){
					$("#btn_save").hide();
					$("#btn_cancel").hide();
					$('#div_data_info_form input,textarea').attr("disabled","disabled")
					$('#div_data_info_form input,textarea').css("background-color","#EDF6FA")
				}
			},
			bindEvents: function () {
				var self = this;
				var validator =  new jValidation.Validation(self.$form, {immediate: true, onSubmit: false,
					onElementValidateForAjax: function (elm) {
						if (Util.isStrEquals($(elm).attr("id"), 'inp_name')) {
							var name = $("#inp_name").val();
							if(Util.isStrEmpty(nameCopy)||(!Util.isStrEmpty(nameCopy)&&!Util.isStrEquals(name,nameCopy))){
								return checkUnique("${contextRoot}/resource/resourceInterface/isNameExist",name,"资源接口名称不能重复！");
							}
						}
					}
				});
				//验证编码、名字不可重复
				function checkUnique(url, value, errorMsg) {
					var result = new jValidation.ajax.Result();
					var dataModel = $.DataModel.init();
					dataModel.fetchRemote(url, {
						data: {name:value},
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
						dataModel.createRemote("${contextRoot}/resource/resourceInterface/update", {
							data:  {dataJson:JSON.stringify(model),mode:mode},
							success: function (data) {
								if(data.successFlg){
									parent.reloadMasterUpdateGrid();
									$.Notice.success('操作成功');
									win.closeInterfaceInfoDialog();
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
					win.closeInterfaceInfoDialog();
				});
			}
		};

		/* *************************** 页面初始化 **************************** */
		pageInit();

	})(jQuery, window);
</script>