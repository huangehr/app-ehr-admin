<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
	(function ($, win) {
		$(function () {
			var Util = $.Util;
			var authenticationId = '${id}';
			var imgPath = ${imgPath}.detailModelList;
			var dataModel = ${dataModel};
			function pageInit() {
				dataInfo.init();
			}
			var dataInfo = {
				$form:$('#div_content'),
				$footer:$('#div_btn'),
				init:function(){
					this.initForm();
					this.bindEvents();
				},
				initForm: function () {
					if(!Util.isStrEquals(dataModel.status,'0')){this.$footer.hide();}
					var info = ${envelop}.obj;
					if(!info){return}
					this.$form.attrScan();
					this.$form.Fields.fillValues({
						id: info.id,
						name: info.name,
						idCard:info.idCard,
						medicalCardType:info.medicalCardType,
						telephone:info.telephone,
						idCardEffective:info.idCardEffective,
						medicalCardNo:info.medicalCardNo,
					});
					$('#div_image_left').html('<img id="img_left" src="${contextRoot}/authentication/showImage?timestamp='+(new Date()).valueOf()+'&&imgPath='+encodeURI(imgPath[3])+'" alt="图片加载失败！" class="div_image"></img>');
					$('#div_image_right').html('<img src="${contextRoot}/authentication/showImage?timestamp='+(new Date()).valueOf()+'&&imgPath='+encodeURI(imgPath[4])+'" alt="图片加载失败！" class="div_image"></img>');
				},
				bindEvents:function(){
					//返回上一页
					$('#btn_back').click(function(){
						$('#contentPage').empty();
						$('#contentPage').load('${contextRoot}/authentication/initial?backParams='+encodeURI (JSON.stringify(dataModel.backParams)));
					});
					//审核通过、拒绝操作
					$('#btn_approve').click(function(){
						$.publish('authentication:status',[authenticationId,'1']);
					});
					$('#btn_refuse').click(function(){
						$.publish('authentication:status',[authenticationId,'2']);
					});
					$.subscribe('authentication:status', function (event, id,status) {
						var msg = "";
						if(Util.isStrEquals("1",status)){msg = "您同意了该认证，操作后无法修改，是否确认操作？";}
						if(Util.isStrEquals("2",status)){msg = "您拒绝了该认证，操作后无法修改，是否确认操作？";}
						if(Util.isStrEmpty(msg)){return;}
						$.ligerDialog.confirm(msg, function (yes) {
							if (yes) {
								var dataModel = $.DataModel.init();
								dataModel.updateRemote('${contextRoot}/authentication/updateStatus', {
									data: {id: id,status:status},
									success: function (data) {
										if (data.successFlg) {
											$.Notice.success('操作成功')
											dataInfo.$footer.hide()
										} else {
											$.Notice.error('操作失败')
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