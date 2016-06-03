<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var rsInfoForm = null;
		// 表单校验工具类
		var jValidation = $.jValidation;
		var mode = '${mode}';
		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			rsInfoForm.init();
		}
		/* *************************** 模块初始化 ***************************** */
		rsInfoForm = {
			$form: $("#div_rs_info_form"),
			$catalogId: $("#inp_categoryId"),
			$catalogName: $("#inp_categoryName"),
			$name: $("#inp_name"),
			$code: $("#inp_code"),
			$interface: $("#inp_interface"),
			$description: $("#inp_description"),
			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),

			init: function () {
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				this.initDDL();
				this.$name.ligerTextBox({width:240});
				this.$code.ligerTextBox({width:240});
				this.$description.ligerTextBox({width:240, height: 120 });
				var mode = '${mode}';
				if(mode == 'view'){
					rsInfoForm.$form.addClass('m-form-readonly');
					$("#btn_save").hide();
					$("#btn_cancel").hide();
				}
				this.$form.attrScan();
				if(mode == 'new'){
					$("#inp_categoryId").val('${categoryId}');
					$("#inp_categoryName").val('${categoryName}');
					<%--$("#inp_category").ligerGetComboBoxManager().setValue('${categoryId}');--%>
					<%--$("#inp_category").ligerGetComboBoxManager().setText('${categoryName}');--%>
				}
				if(mode !='new'){
					var info = ${envelop}.obj;
					this.$form.Fields.fillValues({
						id:info.id,
						code:info.code,
						name:info.name,
						categoryId:info.categoryId,
						rsInterface:info.rsInterface,
						grantType:info.grantType,
						description:info.description
					});
					$("#inp_categoryId").val('${categoryId}');
					$("#inp_categoryName").val('${categoryName}');
					<%--$("#inp_category").ligerGetComboBoxManager().setValue('${categoryId}');--%>
					<%--$("#inp_category").ligerGetComboBoxManager().setText('${categoryName}');--%>
				}
				this.$form.show();
			},
			initDDL: function () {
				//this.$catalog.customCombo('${contextRoot}/resource/resourceManage/rsCategory',{})
				this.$interface.ligerComboBox({
					url: "${contextRoot}/resource/resourceInterface/searchRsInterfaces",
					dataParmName: 'detailModelList',
					urlParms: {
						searchNm: '',
						page:1,
						rows:15
					},
					valueField: 'resourceInterface',
					textField: 'name',
					width:240
				});
			},

			bindEvents: function () {
				var self = this;
				var validator =  new jValidation.Validation(this.$form, {immediate:true,onSubmit:false,
					onElementValidateForAjax:function(elm){
						//TODO 资源名称不重复验证
					}
				});

				this.$btnSave.click(function () {
					if(validator.validate()){
						var values = self.$form.Fields.getValues();
						var dataModel = $.DataModel.init();
						dataModel.updateRemote("${contextRoot}/resource/resourceManage/update", {
							data:{dataJson:JSON.stringify(values),mode:mode},
							success: function(data) {
								if (data.successFlg) {
									parent.reloadMasterUpdateGrid();
									$.Notice.success('操作成功');
									win.closeRsInfoDialog();
								} else {
									$.Notice.error('操作失败！');
								}
							}
						});
					}
				});
				this.$btnCancel.click(function () {
					win.closeRsInfoDialog();
				});
			}
		};
		/* *************************** 页面初始化 **************************** */
		pageInit();
	})(jQuery, window);
</script>