<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var rsInfoForm = null;
		var jValidation = $.jValidation;
		var mode = '${mode}';
		var categoryName='${categoryName}';
		var categoryIdOld = '${categoryId}';
		var categoryOrgId = '${categoryOrgId}';
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
			$userNames: $('#userName'),
			$userName: $('#inp_userId').val(),
			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),

			init: function () {
				var self = this;
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				var url = '${contextRoot}/deptMember/getOrgMemberList?orgId='+categoryOrgId;
                this.$userId.customCombo(url,{},null,null,null,
                    {
                        valueField: 'id',
                        textField: 'userName'
                    },
                    {
                        columns: [
                            { header: 'userName', name: 'userName', width: '100%' }
                        ]
                    });
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
				self.$userId.on('change',function () {
					var name = $(this).val();
					self.$userNames.val(name);
				});

				this.$btnSave.click(function () {
					if(validator.validate() == false){
						return
					}
debugger;
					var values = self.$form.Fields.getValues();
					var userId = values.userId;
					if(userId == categoryIdOld){
						$.Notice.error('不能选择自己作为下级！');
						return;
					}
					update(values);
				});

				function update(values){
					var dataModel = $.DataModel.init();
                    var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
					dataModel.updateRemote("${contextRoot}/upAndDownMember/updateOrgDeptMember", {
						data:{
							dataJson:JSON.stringify(values),
							pUserId:categoryIdOld,
							parentUserName:categoryName
						},
						success: function(data) {
                            waittingDialog.close();
							if (data.successFlg) {
								reloadMasterUpdateGrid(categoryIdOld);
								$.Notice.success('添加成功');
								win.closeRsInfoDialog();
							} else {
								$.Notice.error(data.errorMsg);
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