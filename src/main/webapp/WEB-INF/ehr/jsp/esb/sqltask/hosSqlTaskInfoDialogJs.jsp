<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/5/13
  Time: 17:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">
	(function ($, win) {
		/* ************************** 变量定义 ******************************** */
		var Util = $.Util;
		var hisInfo = null;

		// 表单校验工具类
		var jValidation = $.jValidation;
		/* *************************** 函数定义 ******************************* */
		function pageInit() {
			hisInfo.init();
		}

		/* *************************** 模块初始化 ***************************** */
		hisInfo = {
			$form: $("#div_his_info_form"),
			$orgCode: $("#inp_org_code"),
			$systemName: $('#inp_system_code'),
			$querySql: $('#inp_query_sql'),

			$updateBtn: $("#btn_save"),
			$cancelBtn: $("#btn_cancel"),

			init: function () {
				this.initForm();
				this.bindEvents();
			},
			initForm: function () {
				this.$orgCode.customCombo('${contextRoot}/esb/acqTask/orgCodes',{})
				this.$systemName.ligerTextBox({width:240});
				this.$querySql.ligerTextBox({width: 240,height:150});
			},
			bindEvents: function () {
				var self = this;
				//新增、修改
				self.$updateBtn.click(function () {
					var validate = true;
					if(validate){
						var dataModel = $.DataModel.init();
						self.$form.attrScan();
						var hisModel = self.$form.Fields.getValues();
						dataModel.createRemote("${contextRoot}/esb/sqlTask/create", {
							data:  {dataJson:JSON.stringify(hisModel)},
							success: function (data) {
								if(data.successFlg){
									parent.reloadMasterUpdateGrid();
									parent.closeHisInfoDialog('1');
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
					parent.closeHisInfoDialog();
				});
			}
		};
		/* *************************** 页面初始化 **************************** */
		pageInit();
	})(jQuery, window);
</script>
