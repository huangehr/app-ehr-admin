<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
	(function ($, win) {
		$(function () {

			var Util = $.Util;
			var master = null;
			var obj = ${obj};
			var functionFeatrueType = ['functionFeatrueTree', 'configFeatrueTree'];
			var dataModel = $.DataModel.init();
			function pageInit() {
				master.funInit();
				master.clicks();
			}
			function reloadGrid(url, ps) {
				functionFeatrueType[1].options(url,{parms: ps});
				functionFeatrueType[1].loadData(true);
			}
			master = {

				$funFeatrueSearch: $("#inp_fun_featrue_search"),
				$functionFeatrueTree: $("#div_function_featrue_grid"),
				$configFeatrueTree: $("#div_configFun_featrue_grid"),
				$apiFeatrueTree: $("#div_api_featrue_grid"),
				$configApiFeatrueTree: $("#div_configApi_featrue_grid"),
				$appRoleGridScrollbar: $(".div-appRole-grid-scrollbar"),
				$roleGroupbtn: $(".div-roleGroup-btn"),
				$addRoleGroupBtn: $("#div_add_roleGroup_btn"),
                $featrueSaveBtn: $("#div_featrue_save_btn"),
				funInit: function () {
					var self = this;
					self.$appRoleGridScrollbar.mCustomScrollbar({
					});
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
					var funEle = [self.$functionFeatrueTree,self.$configFeatrueTree];
					var functionType = ["featrue","configFeatrue"];
					for (var i = 0; i < functionFeatrueType.length; i++) {
						var checkboxBo = Util.isStrEquals(i,0)?true:false;
						var appRoleId = obj.id;
						functionFeatrueType[i] = funEle[i].ligerSearchTree({
                            nodeWidth: 200,
							url: '${contextRoot}/appRole/searchFeatrueTree',
							parms:{searchNm: '',treeType:functionType[i],appRoleId:appRoleId,appId:obj.appId},
							idFieldName: 'id',
							parentIDFieldName: 'parentId',
							textFieldName: 'name',
//							isExpand: false,
                            enabledCompleteCheckbox:false,
							checkbox: checkboxBo,
							async: false,
							onCheck:function (data,checked) {
                                setTimeout(function(){
                                    var html= $("#div_function_featrue_grid").html();
                                    $("#div_configFun_featrue_grid").html(html);
                                    $("#div_configFun_featrue_grid .l-box.l-checkbox").hide();
                                    $("#div_configFun_featrue_grid .l-checkbox-unchecked").closest("li").hide()
                                },300)
							},
							onSuccess: function (data) {
                                $("#div_configFun_featrue_grid").hide();
                                if (Util.isStrEquals(this.id, 'div_function_featrue_grid')) {
                                    setTimeout(function () {
                                        var html = $("#div_function_featrue_grid").html();
                                        $("#div_configFun_featrue_grid").html(html).show();
                                        $("#div_configFun_featrue_grid .l-box.l-checkbox").hide();
                                        $("#div_configFun_featrue_grid .l-checkbox-unchecked").closest("li").hide()
                                    }, 300)
                                }
								$("#div_function_featrue_grid li div span ,#div_configFun_featrue_grid li div span").css({
									"line-height": "22px",
									"height": "22px"
								});
							},
							onAfterAppend:function(){
								$(functionFeatrueType[0].element).find(".l-checkbox-incomplete").attr("class","l-box l-checkbox l-checkbox-unchecked")
							}
						});
					}
				},
				reloadRoleGrid: function (appRoleId) {
					var searchParams = {searchNm: '',treeType:'featrue',appRoleId:appRoleId};
					reloadGrid.call(this, '${contextRoot}/appRole/searchFeatrueTree',searchParams);
				},
				clicks: function () {
					//修改用户信息
					var self = this;
                    self.$featrueSaveBtn.click(function () {
                        var url = "${contextRoot}/appRole/updateFeatureConfig";
                        var gridType = functionFeatrueType[1];
                        var datas = functionFeatrueType[0].getChecked();
                        var featureIds = '';
                        $.each(datas,function (key,value) {
                            featureIds += Util.isStrEquals(datas.length-1,key)?value.data.id:value.data.id + ",";
                        });
                        dataModel.updateRemote(url, {
                            data: {featureIds: featureIds, roleId: obj.id},
                            success: function (data) {
                                if (data.successFlg)
                                    $.Notice.success('保存成功');
                                else
                                    $.Notice.error('保存失败');
                            }
                        })
                    })
				}
			};
			pageInit();
		})
	})(jQuery, window)
</script>