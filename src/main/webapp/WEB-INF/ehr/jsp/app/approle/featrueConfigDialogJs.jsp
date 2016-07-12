<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            var obj = ${jsonStr};
            var treeType = ['apiFeatrueTree', 'functionFeatrueTree'];
            var gridUrl = ['${contextRoot}/appRole/searchFeatrueTree', '${contextRoot}/resourceBrowse/searchResource'];
            var dataModel = $.DataModel.init();

            function pageInit() {
                master.init();
            }

            master = {
                $functionFeatrueTree: $("#div_function_featrue_grid"),
                $apiFeatrueTree: $("#div_api_featrue_grid"),
                $appRoleGridScrollbar: $(".div-appRole-grid-scrollbar"),

                init: function () {
                    var self = this;
                    $(".lab-title-msg").html(obj.name+"权限");
                    self.$appRoleGridScrollbar.mCustomScrollbar({
                    });
//                    $(self.$appRoleGridScrollbar.children('div').children('div')[0]).css('margin-right', '0');
                    var ele = [self.$apiFeatrueTree,self.$functionFeatrueTree];
                    for (var i = 0; i < treeType.length; i++) {
                        var checkboxBo = Util.isStrEquals(i,1)?true:false;
                        var appRoleId = Util.isStrEquals(i,1)?obj.id:"";
                        treeType[i] = ele[i].ligerSearchTree({
//                            nodeWidth: 200,
                            url: '${contextRoot}/appRole/searchFeatrueTree',
                            parms:{searchNm: '',treeType:treeType[i],appRoleId:appRoleId},
                            idFieldName: 'id',
                            parentIDFieldName: 'pid',
                            textFieldName: 'name',
                            isExpand: false,
                            checkbox: checkboxBo,
                            async: false,
//                            isLeaf: function (data) {
//                                return !Util.isStrEmpty(data.resourceIds);
//                            },
                            onCheck:function (data,checked) {
                                if (!Util.isStrEmpty(data.data.children)){
                                    return;
                                }
                                dataModel.updateRemote("${contextRoot}/appRole/updateFeatureConfig", {
                                    data: {AppFeatureId: data.data.id,updateType:checked},
                                    success: function (data) {
                                    }
                                })

                            },
                            onSuccess: function (data) {
                                $("#div_function_featrue_grid li div span ,#div_api_featrue_grid li div span").css({
                                    "line-height": "22px",
                                    "height": "22px"
                                });
                            }
                        });
                    }
                    self.clicks();
                },
                clicks: function () {
                    //修改用户信息
                    var self = this;
                }
            };
            pageInit();
        })
    })(jQuery, window)
</script>