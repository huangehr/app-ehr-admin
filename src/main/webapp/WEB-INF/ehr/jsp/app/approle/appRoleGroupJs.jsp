<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            var roles = '${roles}';
            var type = '${type}';
            var selroles=[];
            var intf = [
                //获取所有权限
                '${contextRoot}/user/appRolesList','${contextRoot}/userRoles/user/getUserTypeById?userTypeId='+type,
            ];
            var funAndApiTree = 'fun';
            var apiTreeType = ['apiFeatrueTree', 'configApiFeatrueTree'];
            var functionFeatrueType = ['functionFeatrueTree', 'configFeatrueTree'];
            var apiFeatrueType = ['apiFeatrueTree', 'configapiTree'];
            var dataModel = $.DataModel.init();

            function pageInit() {
                master.apiInit();
                master.clicks();
            }

//            function reloadGrid(url, ps) {
//                apiFeatrueType[1].options(url, {parms: ps});
//                apiFeatrueType[1].loadData(true);
//            }

            master = {
                $apiFeatrueTree: $("#div_api_featrue_grid"),
                $configApiFeatrueTree: $("#div_configApi_featrue_grid"),
                $appRoleGridScrollbar: $(".div-appRole-grid-scrollbar"),
                $roleGroupbtn: $(".div-roleGroup-btn"),
                $featrueSaveBtn: $("#div_featrue_save_btn"),

                apiInit: function () {
                    var self = this;
                    self.$appRoleGridScrollbar.mCustomScrollbar({});
                    var apiEle = [self.$apiFeatrueTree, self.$configApiFeatrueTree];
                    this.getUserRole();
                    this.loadRightTree();
                    this.getAllData();
                },
                getAllData:function () {
                    var me = this;
                    apiTreeType[0] = me.$apiFeatrueTree.ligerSearchTree({
                        nodeWidth: 200,
                        url: intf[0],
                        parms: {},
                        idFieldName: 'id',
                        parentIDFieldName: 'pid',
                        textFieldName: 'name',
                        enabledCompleteCheckbox: false,
                        checkbox: true,
                        async: false,
                        onCheck: function (data, checked) {
                            setTimeout(function () {
                                var html = $("#div_api_featrue_grid").html();
                                $("#div_configApi_featrue_grid").html(html);
                                $("#div_configApi_featrue_grid .l-box.l-checkbox").hide();
                                $("#div_configApi_featrue_grid .l-checkbox-unchecked").closest("li").hide()
                            }, 300)
                        },
                        onSuccess: function (data) {
                            me.f_selectNode();
                            $("#div_configApi_featrue_grid").hide();
                            if (Util.isStrEquals(this.id, 'div_api_featrue_grid')) {
                                setTimeout(function () {
                                    var html = $("#div_api_featrue_grid").html();
                                    $("#div_configApi_featrue_grid").html(html).show();
                                    $("#div_configApi_featrue_grid .l-box.l-checkbox").hide();
                                    $("#div_configApi_featrue_grid .l-checkbox-unchecked").closest("li").hide()
                                }, 300)
                            }
                            $("#div_api_featrue_grid li div span ,#div_configApi_featrue_grid li div span").css({
                                "line-height": "22px",
                                "height": "22px",
                                "overflow": "hidden",
                                "text-overflow":"ellipsis",
                                "white-space": "nowrap",
                                "width":"276px"

                            });
                            $("#div_api_featrue_grid,#div_configApi_featrue_grid").css("width","377px");
                        }
                    });
                },
                loadRightTree:function () {
                    var me = this;
                    apiTreeType[1] = me.$configApiFeatrueTree.ligerTree({
                        nodeWidth: 270,
                        idFieldName: 'id',
                        textFieldName: 'name',
                        isExpand: false,
                        enabledCompleteCheckbox:false,
                        checkbox: false,
                        onSuccess: function () {
                        }
                    });
                },
                getUserRole:function () {
                    var me = this;
                    if(roles){
                        selroles=roles.split(',');
                    }else{
                        $.ajax({
                            type: "GET",
                            url: "${contextRoot}/userRoles/user/getUserTypeById",
                            data: {"userTypeId":type},
                            dataType: "json",
                            success: function(data) {
                                debugger
                                if(data.successFlg){
                                    selroles=_.map(data.detailModelList,function (item){
                                        return item.roleId
                                    })
                                }
                            }
                        });
                    }
                },
                f_selectNode:function () {
                    debugger
                    var me = this;
                    _.each(selroles,function (item) {
                        if(apiTreeType[0].getDataByID(item)){
                            $("li#"+item).find(".l-checkbox").click();
                        }
                    })
                },
                clicks: function () {
                    var self = this;

                    self.$featrueSaveBtn.click(function () {
                        var gridType = apiTreeType[1];
                        var datas = apiTreeType[0].getChecked();

                        var featureIds = '';
                        $.each(datas, function (key, value) {
                            if(/^[0-9]+$/.test(value.data.id)){
                                featureIds += Util.isStrEquals(datas.length-1,key)?value.data.id:value.data.id + ",";
                            }
                        });
                        win.roleIds = featureIds;
                        console.log(win.roleIds);
                        win.roleGroupDio.close();
                    })
                }

            };
            pageInit();
            //cyc
            var treeCyc = {
                CheckInit: function (e, tree) {
                    var self = this;
                    var obj = $(e.target);//当前对象
                    var objlevel = obj.attr("outlinelevel");//当前对象的层级
                    var objCheckbox = $(obj.find(".l-body")[0]).find(".l-checkbox")//当前对象的复选框
                    return self.treeClick(obj, objlevel, objCheckbox, tree)
                },//点击事件初始化
                treeClick: function (obj, objlevel, objCheckbox, tree) {//当前对象、当前对象的层级、当前对象的复选框
                    var self = this;
                    var parentItemCyc;//父节点
                    parentItemCyc = $(tree.getParentTreeItem(obj, objlevel - 1))//父节点
                    parentItemCheckboxCyc = $(parentItemCyc.find(".l-body")[0]).find(".l-checkbox")//父节点的复选框
                    if (objCheckbox.hasClass("l-checkbox-checked")) {//选中事件
                        if (self.isRrotherly(parentItemCyc, objlevel) && parentItemCheckboxCyc.hasClass("l-checkbox-unchecked")) {//如果没有被选中的同级就对父级进行选中操作
                            parentItemCheckboxCyc.click();
                            return false;
                        }
                        return true;
                    }
                },//点击事件处理
                isRrotherly: function (parentItemCyc, objlevel) {//父节点对象 和当前点击节点的 outlinelevel
                    var parentItemCyc = parentItemCyc;
                    var self = this;
                    if (parentItemCyc.find("li[outlinelevel=" + objlevel + "] > div .l-checkbox-checked").length == 1) {//如果同级未有被选中 则返回true
                        return true
                    } else {
                        return false
                    }
                },//是否有被选中的同级

            }
        })
    })(jQuery, window)
</script>