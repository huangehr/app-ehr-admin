<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            var obj = ${jsonStr};
            var apiTreeType = ['apiFeatrueTree', 'apiFeatrueTree'];
            var functionFeatrueType = ['functionFeatrueTree', 'configFeatrueTree'];
            var apiFeatrueType = ['apiFeatrueTree', 'configapiTree'];
            var gridUrl = ['${contextRoot}/appRole/searchFeatrueTree', '${contextRoot}/resourceBrowse/searchResource'];
            var dataModel = $.DataModel.init();

            function pageInit() {
                master.funInit();
//                master.apiInit();
                master.clicks();
            }

            master = {
                $functionFeatrueTree: $("#div_function_featrue_grid"),
                $configFeatrueTree: $("#div_configFun_featrue_grid"),
                $apiFeatrueTree: $("#div_api_featrue_grid"),
                $configApiFeatrueTree: $("#div_configApi_featrue_grid"),
                $appRoleGridScrollbar: $(".div-appRole-grid-scrollbar"),
                $roleGroupbtn: $(".div-roleGroup-btn"),
                $cancelRoleGroupBtn: $("#div_cancel_roleGroup_btn"),
                $addRoleGroupBtn: $("#div_add_roleGroup_btn"),

                funInit: function () {
                    var self = this;
                    $(".lab-title-msg").html(obj.name+"权限");
                    self.$appRoleGridScrollbar.mCustomScrollbar({
                    });
//                    $(self.$appRoleGridScrollbar.children('div').children('div')[0]).css('margin-right', '0');
                    var funEle = [self.$functionFeatrueTree,self.$configFeatrueTree];
                    var functionType = ["featrue","configFeatrue"];
                    for (var i = 0; i < functionFeatrueType.length; i++) {
                        var checkboxBo = Util.isStrEquals(i,0)?true:false;
//                        var appRoleId = Util.isStrEquals(i,1)?obj.id:"";
                        var appRoleId = obj.id;
                        functionFeatrueType[i] = funEle[i].ligerSearchTree({
                            url: '${contextRoot}/appRole/searchFeatrueTree',
                            parms:{searchNm: '',treeType:functionType[i],appRoleId:appRoleId},
                            idFieldName: 'id',
                            parentIDFieldName: 'parentId',
                            textFieldName: 'name',
                            isExpand: false,
                            checkbox: checkboxBo,
                            async: false,
//                            isLeaf: function (data) {
//                                return !Util.isStrEmpty(data.resourceIds);
//                            },
                            onCheck:function (data,checked) {
                                debugger
                                if (!Util.isStrEmpty(data.data.children)){
                                    return;
                                }
                                dataModel.updateRemote("${contextRoot}/appRole/updateFeatureConfig", {
                                    data: {AppFeatureId: data.data.id,roleId:obj.id,updateType:checked},
                                    success: function (data) {
                                        if (data.successFlg){
                                            functionFeatrueType[1].reload();
                                        }
                                    }
                                })
                            },
                            onSuccess: function (data) {
                                $("#div_function_featrue_grid li div span ,#div_configFun_featrue_grid li div span").css({
                                    "line-height": "22px",
                                    "height": "22px"
                                });
                            }
                        });
                    }
//                    self.clicks();
                },

                apiInit: function () {
                    var self = this;
                    $(".lab-title-msg").html(obj.name+"权限");
                    self.$appRoleGridScrollbar.mCustomScrollbar({
                    });
                    var apiEle = [self.$apiFeatrueTree,self.$configApiFeatrueTree];
                    for (var j = 0; j < apiTreeType.length; j++) {
                        var checkboxBo = Util.isStrEquals(j,0)?true:false;
                        var appRoleId = obj.id;
                        apiTreeType[j] = apiEle[j].ligerSearchTree({
                            url: '${contextRoot}/appRole/searchApiTree',
                            parms:{searchNm: '',treeType:apiFeatrueType[j],appRoleId:appRoleId},
                            idFieldName: 'id',
                            parentIDFieldName: 'parentId',
                            textFieldName: 'name',
                            isExpand: false,
                            checkbox: checkboxBo,
                            async: false,
                            onCheck:function (data,checked) {
                                if (!Util.isStrEmpty(data.data.children)){
                                    return;
                                }
                                dataModel.updateRemote("${contextRoot}/appRole/updateApiConfig", {
                                    data: {apiFeatureId: data.data.id,roleId:obj.id,updateType:checked},
                                    success: function (data) {
                                        if (data.successFlg){
                                            apiTreeType[1].reload();
                                        }
                                    }
                                })
                            },
                            onSuccess: function (data) {
                                $("#div_api_featrue_grid li div span ,#div_configApi_featrue_grid li div span").css({
                                    "line-height": "22px",
                                    "height": "22px"
                                });
                            }
                        });
                    }
                },
                clicks: function () {
                    //修改用户信息
                    var self = this;
                    self.$cancelRoleGroupBtn.click(function () {
                        $(this).removeClass('u-btn-cancel').addClass('u-btn-primary');
                        self.$addRoleGroupBtn.removeClass('u-btn-primary').addClass('u-btn-cancel');
                        if (Util.isStrEquals(apiTreeType[0],'apiFeatrueTree')){
                            master.apiInit();
                        }
                        apiTreeType[1].reload();
                        self.$functionFeatrueTree.hide();
                        self.$configFeatrueTree.hide();
                        self.$apiFeatrueTree.show();
                        self.$configApiFeatrueTree.show();
                    });
                    self.$addRoleGroupBtn.click(function () {
                        $(this).removeClass('u-btn-cancel').addClass('u-btn-primary');
                        self.$cancelRoleGroupBtn.removeClass('u-btn-primary').addClass('u-btn-cancel');
                        self.$functionFeatrueTree.show();
                        self.$configFeatrueTree.show();
                        self.$apiFeatrueTree.hide();
                        self.$configApiFeatrueTree.hide();
                    });
                }
            };
            pageInit();
        })
    })(jQuery, window)
</script>