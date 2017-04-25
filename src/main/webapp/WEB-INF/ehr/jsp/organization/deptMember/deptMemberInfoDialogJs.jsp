<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		console.log('aa');
		var Util = $.Util;
		var rsInfoForm = null;
		var jValidation = $.jValidation;
		var mode = '${mode}';

		var categoryIdOld = '${categoryId}';
		var categoryOrgId = '${categoryOrgId}';
		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			rsInfoForm.init();
			$("#div_rs_info_form").show();
		}
		/* *************************** 模块初始化 ***************************** */
		rsInfoForm = {
			$form: $("#div_rs_info_form"),
			$userId: $("#inp_userId"),
			$dutyName: $("#inp_dutyName"),
			$remark: $("#inp_remark"),
//			$deptId: $("#inp_deptId"),
			$parentUserId: $("#inp_parentUserId"),

			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),

			$orgIdstr: $("#orgIdstr"),

			init: function () {
				var self = this;
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {

				this.$dutyName.ligerTextBox({width:240});
				this.$remark.ligerTextBox({width:240, height: 120 });
				this.$userId.customCombo('${contextRoot}/deptMember/getUserList', p, undefined, undefined, false);
				var url = '${contextRoot}/deptMember/getOrgMemberList?orgId='+categoryOrgId;
				this.$parentUserId.customCombo(url, p, undefined, undefined, false);
				<%--this.$deptId.customCombo('${contextRoot}/deptMember/getDeptList');--%>

				var mode = '${mode}';
				if(mode == 'view'){
					rsInfoForm.$form.addClass('m-form-readonly');
					$("#btn_save").hide();
					$("#btn_cancel").hide();
				}

				this.$form.attrScan();


				if(mode !='new'){
					var info = ${envelop}.obj;
					this.$form.Fields.fillValues({
						id:info.id,
						dutyName:info.dutyName,
						remark:info.remark
					});

					$("#inp_userId").ligerGetComboBoxManager().setValue(info.userId);
					$("#inp_userId").ligerGetComboBoxManager().setText(info.userName);

					$("#inp_parentUserId").ligerGetComboBoxManager().setValue(info.parentUserId);
					$("#inp_parentUserId").ligerGetComboBoxManager().setText(info.parentUserName);


//					$("#inp_deptId").ligerGetComboBoxManager().setValue(info.deptId);
//					$("#inp_deptId").ligerGetComboBoxManager().setText(info.deptName);
				}
				this.$orgIdstr.val(categoryOrgId);
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
					var deptId = categoryIdOld;
//					if(Util.isStrEquals(categoryIdOld,deptId)){
						update(values,deptId)
						return
//					}
				});

				function update(values,deptId){
					var dataModel = $.DataModel.init();
					dataModel.updateRemote("${contextRoot}/deptMember/updateOrgDeptMember", {
						data:{dataJson:JSON.stringify(values),deptId:deptId,mode:mode},
						success: function(data) {
							if (data.successFlg) {
								parent.reloadMasterUpdateGrid(deptId);
								$.Notice.success('操作成功');
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