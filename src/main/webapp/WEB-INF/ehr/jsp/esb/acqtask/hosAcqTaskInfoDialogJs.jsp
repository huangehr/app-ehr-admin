<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/5/13
  Time: 17:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
	(function ($, win) {
			/* ************************** 变量定义 ******************************** */
			var Util = $.Util;
			var acqInfo = null;

			// 表单校验工具类
			var jValidation = $.jValidation;
			var mode = '${mode}';
			/* *************************** 函数定义 ******************************* */
			function pageInit() {
				acqInfo.init();
			}

			/* *************************** 模块初始化 ***************************** */
			acqInfo = {
				$form: $("#div_acq_info_form"),
				$orgCode: $("#inp_org_code"),
				$systemCode: $('#inp_system_code'),
				$startTime: $('#inp_start_time'),
				$endTime: $('#inp_end_time'),

				$updateBtn: $("#btn_save"),
				$cancelBtn: $("#btn_cancel"),

				init: function () {
					this.initForm();
					this.bindEvents();
				},
				initForm: function () {
					this.$orgCode.customCombo('${contextRoot}/esb/acqTask/orgCodes',{})
					this.$systemCode.ligerTextBox({width:240});
					this.$startTime.ligerDateEditor({format: "yyyy-MM-dd hh:mm:ss",showTime: true,labelWidth: 100, labelAlign: 'left',absolute:false});
					this.$endTime.ligerDateEditor({format: "yyyy-MM-dd hh:mm:ss",showTime: true,labelWidth: 100, labelAlign: 'left',absolute:false });
					if(mode != 'new'){
						var info = ${envelop}.obj;
						this.$form.attrScan();
						this.$form.Fields.fillValues({
							id: info.id,
							orgCode: info.orgCode,
							systemCode: info.systemCode,
							startTime: info.startTime,
							endTime: info.endTime
						});
						$("#inp_org_code").ligerGetComboBoxManager().setValue(info.orgCode);
						$("#inp_org_code").ligerGetComboBoxManager().setText(info.orgCode);
					}
				},

				bindEvents: function () {
					var self = this;
					//新增、修改
					self.$updateBtn.click(function () {
						var t = true;
						if(t){
							var dataModel = $.DataModel.init();
							self.$form.attrScan();
							var acqModel = self.$form.Fields.getValues();
							dataModel.createRemote("${contextRoot}/esb/acqTask/update", {
								data:  {dataJson:JSON.stringify(acqModel),mode:mode},
								success: function (data) {
									if(data.successFlg){
										parent.reloadAcqInfoGrid();
										parent.closeAcqInfoDialog("save");
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
						parent.closeAcqInfoDialog();
					});
				}
			};

			/* *************************** 页面初始化 **************************** */
			pageInit();
	})(jQuery, window);
</script>
