<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var rolesInfo = null;
		// 表单校验工具类
		var jValidation = $.jValidation;
		var nameCopy = '';
		var codeCopy = '';
		//用户角色组类型为"1"
		$('#roleType').val('1');
		var appId = '${appId}';
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

			$inpMechanism: $('#inpMechanism'),
			dataModel: $.DataModel.init(),//ajax初始化

			init: function () {
				this.$code.ligerTextBox({width:240});
				this.$name.ligerTextBox({width:240});
				this.$description.ligerTextBox({width:240, height: 120 });
				this.$form.attrScan();

				this.$form.show();
				this.bindEvents();
				$('#appId').val(appId);
				this.loadSelData();
			},

			//加载默认筛选条件
			loadSelData: function () {
				var me = this;
				me.loadOrgData().then(function (res) {
					//机构
					if (res.successFlg) {
						var d = res.obj;
						var mechanisms = [];
						for (var i = 0, len = d.length; i < len; i++) {
							mechanisms.push({
								text: d[i].fullName,
								id: d[i].orgCode
							});
						}
						me.$inpMechanism.ligerComboBox({
							isShowCheckBox: true,
							width: '240',
							data: mechanisms,
							isMultiSelect: true,
							valueFieldID: 'orgCodes'
						});
					} else {
						me.$inpMechanism.ligerComboBox({width: '240'});
					}
				});
			},
			//医疗机构
			loadOrgData: function () {
				return this.loadPromise("${contextRoot}/organization/getAllorgCodes", {});
			},
			loadPromise: function (url, d) {
				var me = this;
				return new Promise(function (resolve, reject) {
					me.dataModel.fetchRemote(url, {
						data: d,
						type: 'GET',
						success: function (data) {
							resolve(data);
						}
					});
				});
			},

			bindEvents: function () {
				var self = this;
				//验证编码、名字不可重复
				function checkUnique(url,appId, value,orgCode, errorMsg) {
					var result = new jValidation.ajax.Result();
					var dataModel = $.DataModel.init();
					dataModel.fetchRemote(url, {
						data: {appId:appId,name:value,code:value,orgCode:orgCode},
						async: false,
						success: function (data) {
							if (data.successFlg) {
								result.setResult(false);
								result.setErrorMsg(data.errorMsg);
							} else {
								result.setResult(true);
							}
						}
					});
					return result;
				}

				$("#btn_save").click(function () {
					var validator =  new jValidation.Validation(self.$form, {immediate: true, onSubmit: false,
						onElementValidateForAjax: function (elm) {
							var name = $("#inp_roles_name").val();
							var orgCode = $("#orgCodes").val();
							debugger
							if(!Util.isStrEmpty(name) && !Util.isStrEmpty(orgCode)){
								return checkUnique("${contextRoot}/userRoles/isNameExistence",appId,name,orgCode,"角色组名称已被使用！");
							}
							var code = $("#inp_roles_code").val();
							if(!Util.isStrEmpty(code) && !Util.isStrEmpty(orgCode)){
								return checkUnique("${contextRoot}/userRoles/isCodeExistence",appId,code,orgCode,"角色组编码已被使用！");
							}
						}
					});
					if(validator.validate() == false){return}
					var values = self.$form.Fields.getValues();
					update(values)
				});

				function update(values){
                    var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
                    var dataModel = $.DataModel.init();
					var orgCodes = $("#orgCodes").val();
					dataModel.updateRemote("${contextRoot}/userRoles/batchAdd", {
						data:{dataJson:JSON.stringify(values),orgCodes:orgCodes},
						success: function(data) {
                            waittingDialog.close();
							if (data.successFlg) {
								reloadRolesGrid();
								$.Notice.success('操作成功');
								win.rolesBatchAddDialog();
							} else {
								$.Notice.error('操作失败！');
							}
						}
					});
				}
				$("#btn_cancel").click(function () {
					win.rolesBatchAddDialog();
				});
			}
		};
		/* *************************** 页面初始化 **************************** */
		pageInit();
	})(jQuery, window);
</script>