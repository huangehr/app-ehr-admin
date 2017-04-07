<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var rsInfoForm = null;
		var jValidation = $.jValidation;
		var mode = '${mode}';

		var categoryIdOld = '${categoryId}';
		var type = '${type}'
		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			rsInfoForm.init();
			$("#div_rs_info_form").show();
		}
		/* *************************** 模块初始化 ***************************** */
		rsInfoForm = {
			$form: $("#div_rs_info_form"),
			$userId: $("#inp_userId"),

			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),

			init: function () {
				var self = this;
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {

				this.$userId.customCombo('${contextRoot}/upAndDownMember/getOrgMemberList');

				var mode = '${mode}';

				this.$form.attrScan();
				this.$form.show();
			},


			bindEvents: function () {
				var self = this;
				var validator = new jValidation.Validation(this.$form, {
					immediate: true,
					onSubmit: false,
					onElementValidateForAjax: function(elm){}
				});

				this.$btnSave.click(function () {
					if(validator.validate() == false){
						return
					}
					var values = self.$form.Fields.getValues();
					update(values);
				});

				function update(values){
					var dataModel = $.DataModel.init();
					dataModel.updateRemote("${contextRoot}/upAndDownMember/updateOrgDeptMember", {
						data:{
							dataJson:JSON.stringify(values),
							type:type,
							userId:categoryIdOld
						},
						success: function(data) {
							if (data.successFlg) {
								$.Notice.success('操作成功');
								win.closeRsInfoDialog();
							} else {
								$.Notice.error('操作失败！');
							}
						}
					});
				}

				this.$btnCancel.click(function () {
					win.closeRsInfoDialog();
				});
			}
		};
		/* *************************** 页面初始化 **************************** */
		pageInit();
	})(jQuery, window);
</script>