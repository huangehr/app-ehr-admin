<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
	(function ($, win) {
		$(function () {

			var Util = $.Util;
			var master = null;
			var functionFeatrueType = ['functionFeatrueTree','functionFeatrueOrgTree'];////加载区域和机构的左树
			var functionFeatrueRigthType = ['configFeatrueTree','configFeatrueOrgTree'];////加载区域和机构的右树
			var dataModel = $.DataModel.init();
			function pageInit() {
				master.funInit();
			}
			master = {

				$funFeatrueSearch: $("#inp_fun_featrue_search"),//区域授权搜索框
				$functionFeatrueTree: $("#div_function_featrue_grid"),//区域授权左树
				$configFeatrueTree: $("#div_configFun_featrue_grid"),//区域授权右树
				$funFeatrueOrgSearch: $("#inp_fun_featrue_org_search"),//机构授权搜索框
				$functionFeatrueOrgTree: $("#div_function_featrue_org_grid"),//机构授权左树
				$configFeatrueOrgTree: $("#div_configFun_featrue_org_grid"),//机构授权右树
				$appRoleGridScrollbar: $(".div-appRole-grid-scrollbar"),
				$divGrantBtn:$(".div-grant-btn"),
				$featrueSaveBtn: $("#div_featrue_save_btn"),
				funInit: function () {
					var self = this;
					self.$appRoleGridScrollbar.mCustomScrollbar({
					});
					self.clicks();
					self.areaOrgGrantInit();
				},
				areaOrgGrantInit:function(){//区域、机构授权初始化
					var self = this;
					//区域搜索框
					self.$funFeatrueSearch.ligerTextBox({
						width: 200, isSearch: true, search: function () {
							var categoryName = self.$funFeatrueSearch.val();
							functionFeatrueType[0].s_search(categoryName);
							if (categoryName == '') {
								functionFeatrueType[0].collapseAll();
							} else {
								functionFeatrueType[0].expandAll();
							}
						}
					});

					//机构搜索框
					self.$funFeatrueOrgSearch.ligerTextBox({
						width: 200, isSearch: true, search: function () {
							var categoryName = self.$funFeatrueOrgSearch.val();
							functionFeatrueType[1].s_search(categoryName);
							if (categoryName == '') {
								functionFeatrueType[1].collapseAll();
							} else {
								functionFeatrueType[1].expandAll();
							}
						}
					});

					var funLeftEle = [self.$functionFeatrueTree,self.$functionFeatrueOrgTree];//加载区域和机构的左树
					var funRightEle = [self.$configFeatrueTree,self.$configFeatrueOrgTree];//加载区域和机构的右树
					for (var i = 0; i < functionFeatrueType.length; i++) {
						var type = Util.isStrEquals(i,0)?"1":"2";//1区域 2机构
						functionFeatrueType[i] = funLeftEle[i].ligerSearchTree({
							nodeWidth: 200,
							url: '${contextRoot}/orgSaas/getOrgSaas',
							parms:{saasName: '',orgCode:$("#inp_orgCode").val(),type:type},
							idFieldName: 'id',
							parentIDFieldName: 'parent_hos_id',
							textFieldName: 'saasName',
							isExpand: false,
							enabledCompleteCheckbox:false,
							checkbox: true,
							async: false,
							onCheck:function (data,checked) {
								debugger
								if (Util.isStrEquals(this.id, 'div_function_featrue_grid')) {//区域数据
									setTimeout(function(){
										var html= $("#div_function_featrue_grid").html();
										$("#div_configFun_featrue_grid").html(html);
										$("#div_configFun_featrue_grid .l-box.l-checkbox").hide();
										$("#div_configFun_featrue_grid .l-checkbox-unchecked").closest("li").hide();
										$(".div-grant-btn.div-quyu").attr("data-saved","true");
									},300);
								}else{//机构数据
									setTimeout(function(){
										var html= $("#div_function_featrue_org_grid").html();
										$("#div_configFun_featrue_org_grid").html(html);
										$("#div_configFun_featrue_org_grid .l-box.l-checkbox").hide();
										$("#div_configFun_featrue_org_grid .l-checkbox-unchecked").closest("li").hide();
										$(".div-grant-btn.div-jigou").attr("data-saved","true");
									},300)
								}

							},
							onSuccess: function (data) {
								if (Util.isStrEquals(this.id, 'div_function_featrue_grid')) {//加载区域数据
									$("#div_configFun_featrue_grid").hide();
									functionFeatrueType[0].setData(data.detailModelList);
									//加载区域右树
									functionFeatrueRigthType[0] = funRightEle[0].ligerSearchTree({
										nodeWidth: 200,
										data:data.obj,
										idFieldName: 'saasCode',
										parentIDFieldName: 'parent_hos_id',
										textFieldName: 'saasName',
										isExpand: false,
										enabledCompleteCheckbox:false,
										checkbox: false,
										async: false,
										onCheck:function (data,checked) {

										}
									});

									setTimeout(function () {
										var html = $("#div_function_featrue_grid").html();
										$("#div_configFun_featrue_grid").html(html).show();
										$("#div_configFun_featrue_grid .l-box.l-checkbox").hide();
										$("#div_configFun_featrue_grid .l-checkbox-unchecked").closest("li").hide();
										$("#div_configFun_featrue_grid .l-checkbox-checked").closest("li").show();
									}, 300);

									$("#div_function_featrue_grid li div span ,#div_configFun_featrue_grid li div span").css({
										"line-height": "22px",
										"height": "22px"
									});
								}else{//加载机构数据
									$("#div_configFun_featrue_org_grid").hide();
									debugger
									functionFeatrueType[1].setData(data.detailModelList);
									//加载区域右树
									functionFeatrueRigthType[1] = funRightEle[1].ligerSearchTree({
										nodeWidth: 200,
										data:data.obj,
										idFieldName: 'saasCode',
										parentIDFieldName: 'parent_hos_id',
										textFieldName: 'saasName',
										isExpand: false,
										enabledCompleteCheckbox:false,
										checkbox: false,
										async: false,
										onCheck:function (data,checked) {

										}
									});
									setTimeout(function () {
										var html = $("#div_function_featrue_org_grid").html();
										$("#div_configFun_featrue_org_grid").html(html).show();
										$("#div_configFun_featrue_org_grid .l-box.l-checkbox").hide();
										$("#div_configFun_featrue_org_grid .l-checkbox-unchecked").closest("li").hide();
										$("#div_configFun_featrue_org_grid .l-checkbox-checked").closest("li").show();
									}, 300);

									$("#div_function_featrue_org_grid li div span ,#div_configFun_featrue_org_grid li div span").css({
										"line-height": "22px",
										"height": "22px"
									});
								}

							},
							onAfterAppend:function(){//追加数据后事件
								if (Util.isStrEquals(this.id, 'div_function_featrue_grid')) {//区域数据
									$(functionFeatrueType[0].element).find(".l-checkbox-incomplete").attr("class","l-box l-checkbox l-checkbox-unchecked");
								}else{//机构数据
									$(functionFeatrueType[1].element).find(".l-checkbox-incomplete").attr("class","l-box l-checkbox l-checkbox-unchecked");
								}
							}
						});
					}

				},
				clicks: function () {
					var self = this;
					//切换区域和机构
					self.$divGrantBtn.click(function(){
						if($(".div-quyu.active").attr("data-saved")=="true") {//区域数据已更新，是否保存
							$.Notice.success('区域数据已更新，请先保存数据，再进行其他操作？',function () {
								self.saveArea();
							});
						}else if($(".div-quyu.active").attr("data-saved")=="true"){//机构数据已更新，是否保存
							$.Notice.success('区域数据已更新，请先保存数据，再进行其他操作？',function () {
								self.saveOrg();
							});
						}else{
							var isQuyu = $(this).hasClass("div-quyu");
							$(".div-grant-btn").removeClass("active");
							$(this).addClass("active");
							if(isQuyu){//显示区域
								$(".div-area-grant").show();
								$(".div-org-grant").hide();
							}else{//显示机构
								$(".div-area-grant").hide();
								$(".div-org-grant").show();
							}
						}
					});

					//修改用户信息
					self.$featrueSaveBtn.click(function () {
						debugger
						if($(".div-quyu.active").length>0){//保存区域数据
							self.saveArea();
						}else{//保存机构数据
							self.saveOrg();
						}
					})
				},
				saveArea:function(){//保存区域数据
					var self = this;
					var orgCode = $("#inp_orgCode").val();
					var type = "1";
					var areaData = [];
					var areaCheckedDatas = functionFeatrueType[0].getChecked();
					//区域数据
					$.each(areaCheckedDatas,function (key,value) {
						areaData.push({orgCode:orgCode,type:type,saasCode:value.data.saasCode,saasName:value.data.saasName});
					});
					var jsonData = JSON.stringify(areaData);
					self.saveData(orgCode,type,jsonData);
				},
				saveOrg:function(){//保存机构数据
					var self = this;
					var orgCode = $("#inp_orgCode").val();
					var type = "2";
					var orgData = [];
					var orgCheckedDatas = functionFeatrueType[1].getChecked();
					//机构数据
					$.each(orgCheckedDatas,function (key,value) {
						orgData.push({orgCode:orgCode,type:type,saasCode:value.data.saasCode,saasName:value.data.saasName});
					});
					var jsonData = JSON.stringify(orgData);
					self.saveData(orgCode,type,jsonData);
				},
				saveData:function(orgCode,type,jsonData){
					dataModel.updateRemote("${contextRoot}/orgSaas/orgSaasSave", {
						data: {orgCode:orgCode,type:type,jsonData: jsonData},
						success: function (data) {
							if (data.successFlg){
								$(".div-quyu.active").attr("data-saved","false");
								$(".div-jigou.active").attr("data-saved","false");
								$.Notice.success('保存成功');
							}else
								$.Notice.error('保存失败');
						}
					});
				}
			};
			pageInit();
		})
	})(jQuery, window)
</script>