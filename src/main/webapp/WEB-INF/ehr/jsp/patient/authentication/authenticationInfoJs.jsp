<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
	(function ($, win) {
		$(function () {
			var Util = $.Util;
			var authenticationId = '';
			var dataModel = ${dataModel};
			function pageInit() {
				dataInfo.init();
			}
			var dataInfo = {
				init:function(){
					this.initForm();
					this.bindEvents();
				},
				initForm: function () {
					this.$form = $('#div_content')
					var info = ${info}.obj;
					authenticationId = info.id;
					this.$form.attrScan();
					this.$form.Fields.fillValues({
						id: info.id,
						name: info.orgCode,
						idCard:info.systemCode,
						medicalCardType:info.orgCode,
						telephone:info.startTime,
						time:info.createTime,
						medicalCardNo:info.systemCode,
					});
				},
				bindEvents:function(){
					//返回上一页
					$('#btn_back').click(function(){
						$('#contentPage').empty();
						$('#contentPage').load('${contextRoot}/authentication/initial?backParams='+encodeURI (JSON.stringify(dataModel.backParams)));
					});
					//审核通过、拒绝操作
					$('#btn_approve').click(function(){
						$.publish('authentication:operate',[authenticationId,'approve']);
					});
					$('#btn_refuse').click(function(){
						$.publish('authentication:operate',[authenticationId,'refuse']);
					});
					$.subscribe('authentication:operate', function (event, id,operate) {
						var msg = "";
						if(Util.isStrEquals("approve",operate)){msg = "您同意了该认证，操作后无法修改，是否确认操作？";}
						if(Util.isStrEquals("refuse",operate)){msg = "您拒绝了该认证，操作后无法修改，是否确认操作？";}
						if(Util.isStrEmpty(msg)){return;}
						$.ligerDialog.confirm(msg, function (yes) {
							if (yes) {
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/authentication/operate', {
									data: {id: id,status:operate},
									success: function (data) {
										if (data.successFlg) {
											isFirstPage = false;
											master.reloadGrid();
										} else {
										}
									}
								});
							}
						});
					});
				}
			}
			pageInit();
			/* ************************* 页面初始化结束 ************************** */
		});
	})(jQuery, window);
</script>