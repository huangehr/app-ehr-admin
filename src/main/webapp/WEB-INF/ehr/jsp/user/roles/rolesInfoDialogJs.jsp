<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var rolesInfo = null;
		// 表单校验工具类
		var jValidation = $.jValidation;
		var mode = '${mode}';
		var nameCopy = '';
		var codeCopy = '';
		var appId = '${appId}';
		//用户角色组类型为"1"
		$('#roleType').val('1');
		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			rolesInfo.init();
		}
		/* *************************** 模块初始化 ***************************** */
		rolesInfo = {
			$form: $("#div_roles_info_form"),

			$type:$('#roleType'),
			$code: $("#inp_roles_code"),
			$name: $("#inp_roles_name"),
			$description: $("#inp_description"),
			init: function () {
				this.$code.ligerTextBox({width:240});
				this.$name.ligerTextBox({width:240});
				this.$description.ligerTextBox({width:240, height: 120 });
				if(mode == 'view'){
					rolesInfo.$form.addClass('m-form-readonly');
					$("#btn_save").hide();
					$("#btn_cancel").hide();
				}
				this.$form.attrScan();
				if(mode !='new'){
					var info = ${envelop}.obj;
					nameCopy = info.name;
					codeCopy = info.code;
					this.$form.Fields.fillValues({
						id:info.id,
						appId:info.appId,
						code:info.code,
						name:info.name,
						description:info.description
					});
				}
				if(mode == 'new'){
					$('#appId').val(appId);
				}
				this.$form.show();
				this.bindEvents();
			},
			bindEvents: function () {
				var self = this;
				var validator =  new jValidation.Validation(self.$form, {immediate: true, onSubmit: false,
					onElementValidateForAjax: function (elm) {
						if (Util.isStrEquals($(elm).attr("id"), 'inp_roles_name')) {
							var name = $("#inp_roles_name").val();
							if(Util.isStrEmpty(nameCopy)||(!Util.isStrEmpty(nameCopy)&&!Util.isStrEquals(name,nameCopy))){
								return checkUnique("${contextRoot}/userRoles/isNameExistence",appId,name,"角色组名称已被使用！");
							}
						}
						if (Util.isStrEquals($(elm).attr("id"), 'inp_roles_code')) {
							var code = $("#inp_roles_code").val();
							if(Util.isStrEmpty(codeCopy)||(!Util.isStrEmpty(codeCopy)&&!Util.isStrEquals(code,codeCopy))){
								return checkUnique("${contextRoot}/userRoles/isCodeExistence",appId,code,"角色组编码已被使用！");
							}
						}
					}
				});
				//验证编码、名字不可重复
				function checkUnique(url,appId, value, errorMsg) {
					var result = new jValidation.ajax.Result();
					var dataModel = $.DataModel.init();
					dataModel.fetchRemote(url, {
						data: {appId:appId,name:value,code:value},
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

				$("#btn_save").click(function () {
					if(validator.validate() == false){return}
					var values = self.$form.Fields.getValues();
					update(values)
				});
				function update(values){
					var dataModel = $.DataModel.init();
					dataModel.updateRemote("${contextRoot}/userRoles/update", {
						data:{dataJson:JSON.stringify(values),mode:mode},
						success: function(data) {
							if (data.successFlg) {
								parent.reloadRolesGrid();
								$.Notice.success('操作成功');
								win.closeRolesInfoDialog();
							} else {
								$.Notice.error('操作失败！');
							}
						}
					});
				}
				$("#btn_cancel").click(function () {
					win.closeRolesInfoDialog();
				});
			}
		};
		/* *************************** 页面初始化 **************************** */
		pageInit();
	})(jQuery, window);
</script>