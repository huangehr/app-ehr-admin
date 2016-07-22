<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            var obj = ${jsonStr};
            var funAndApiTree = 'fun';
            var apiTreeType = ['apiFeatrueTree', 'configApiFeatrueTree'];
            var functionFeatrueType = ['functionFeatrueTree', 'configFeatrueTree'];
            var apiFeatrueType = ['apiFeatrueTree', 'configapiTree'];
            var dataModel = $.DataModel.init();

            function pageInit() {
                master.funInit();
                master.clicks();
            }

            function reloadGrid(url, ps) {
                functionFeatrueType[1].options(url, {parms: ps});
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
                $apiFeatrueBtn: $("#div_api_featrue_btn"),
                $funFeatrueBtn: $("#div_fun_featrue_btn"),
                $featrueSaveBtn: $("#div_featrue_save_btn"),

                funInit: function () {
                    var self = this;
//                    var timeOutTree;
                    self.$appRoleGridScrollbar.mCustomScrollbar({});
                    self.$funFeatrueSearch.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            var categoryName = self.$funFeatrueSearch.val();
                            var treeType = Util.isStrEquals(funAndApiTree, 'fun') ? functionFeatrueType[0] : apiTreeType[0];
                            treeType.s_search(categoryName);
                            if (categoryName == '') {
                                treeType.collapseAll();
                            } else {
                                treeType.expandAll();
                            }
                        }
                    });
                    var funEle = [self.$functionFeatrueTree, self.$configFeatrueTree];
                    var functionType = ["featrue", "configFeatrue"];
                    for (var i = 0; i < functionFeatrueType.length; i++) {
                        var checkboxBo = Util.isStrEquals(i, 0) ? true : false;
                        var appRoleId = obj.id;
                        functionFeatrueType[i] = funEle[i].ligerSearchTree({
                            url: '${contextRoot}/appRole/searchFeatrueTree',
                            parms: {searchNm: '', treeType: functionType[0], appRoleId: appRoleId, appId: obj.appId},
                            idFieldName: 'id',
                            parentIDFieldName: 'parentId',
                            textFieldName: 'name',
                            isExpand: true,
                            checkbox: checkboxBo,
//                            enabledCompleteCheckbox:false,
                            async: false,
//                            render:function(data,ele,t,r){
//                                debugger
//                                functionFeatrueType[1]
//                                debugger
//                            },
                            onCheck: function (data, checked) {
                                setTimeout(function(){
                                    var html= $("#div_function_featrue_grid").html()
                                    $("#div_configFun_featrue_grid").html(html)
                                    $("#div_configFun_featrue_grid .l-box.l-checkbox").hide();
                                    $("#div_configFun_featrue_grid .l-checkbox-unchecked").closest("li").hide()
                                },300)

                                //functionFeatrueType[1].setData(functionFeatrueType[0].nodes);
                                //$("#div_configFun_featrue_grid .l-checkbox-unchecked").closest("li").remove()
                                <%--var isReload = treeCyc.CheckInit(data, functionFeatrueType[0]);--%>
                                <%--dataModel.updateRemote("${contextRoot}/appRole/updateFeatureConfig", {--%>
                                    <%--data: {AppFeatureId: data.data.id, roleId: obj.id, updateType: checked},--%>
                                    <%--success: function (data) {--%>
<%--//                                        clearTimeout(timeOutTree)--%>
<%--//                                        timeOutTree=setTimeout(function(){--%>
<%--//                                            functionFeatrueType[1].reload();--%>
<%--//                                        },1);--%>
                                        <%--if (isReload === false)--%>
                                            <%--return;--%>
                                        <%--functionFeatrueType[1].reload();--%>
                                    <%--}--%>
                                <%--})--%>
                            },
                            onSuccess: function (data) {
//                                console.log(functionFeatrueType[0]);
                                $("#div_configFun_featrue_grid").hide()
                                if (Util.isStrEquals(this.id, 'div_function_featrue_grid')) {
                                    debugger
                                    setTimeout(function () {
                                        debugger
                                        var html = $("#div_function_featrue_grid").html()
                                        $("#div_configFun_featrue_grid").html(html).show();
                                        $("#div_configFun_featrue_grid .l-box.l-checkbox").hide();
                                        $("#div_configFun_featrue_grid .l-checkbox-unchecked").closest("li").hide()
                                    }, 300)
                                }
//                                if (Util.isStrEquals(this.id, 'div_configFun_featrue_grid')) {
//                                    var eleHtmls = $("#div_configFun_featrue_grid .l-body");
//                                    $.each(eleHtmls,function (key,value) {
//
//                                        if (!data.ischecked){
//                                            //$(eleHtmls).css({"display":"none"})
//                                        }
//                                    })
//
////                                        $("#div_configFun_featrue_grid .l-checkbox-unchecked").closest("li").remove()
////                                    var coun = [];
////                                    for (var i = 0; i < data.length; i++) {
////                                        var bo = true;
////                                        for (var j = 0; j < data.length; j++) {
////                                            if (Util.isStrEquals(data[i].parentId, data[j].id) || Util.isStrEquals(data[i].parentId, 0)) {
////                                                bo = false;
////                                            }
////                                        }
////                                        if (bo) {
////                                            coun.push(i);
////                                        }
////                                        delete data[i].children;
////                                    }
////                                    for (var k = 0; k < coun.length; k++) {
////                                        data.splice([coun[k]], 1);
////                                    }
////                                    functionFeatrueType[1].setData(data);
//                                }
                                $("#div_function_featrue_grid li div span ,#div_configFun_featrue_grid li div span").css({
                                    "line-height": "22px",
                                    "height": "22px"
                                });
                            },
//                            onAfterAppend: function () {
////                                $(functionFeatrueType[0].element).find(".l-checkbox-incomplete").attr("class", "l-box l-checkbox l-checkbox-unchecked")
//                            }
                        });
                    }
                },
                apiInit: function () {
                    var self = this;
                    self.$appRoleGridScrollbar.mCustomScrollbar({});
                    var apiEle = [self.$apiFeatrueTree, self.$configApiFeatrueTree];
                    for (var j = 0; j < apiTreeType.length; j++) {
                        var checkboxBo = Util.isStrEquals(j, 0) ? true : false;
                        var appRoleId = obj.id;
                        apiTreeType[j] = apiEle[j].ligerSearchTree({
                            url: '${contextRoot}/appRole/searchApiTree',
                            parms: {searchNm: '', treeType: apiFeatrueType[j], appRoleId: appRoleId, appId: obj.appId},
                            idFieldName: 'id',
                            parentIDFieldName: 'parentId',
                            textFieldName: 'name',
                            isExpand: false,
//                            autoCheckboxEven: false,
                            checkbox: checkboxBo,
                            async: false,
                            onCheck: function (data, checked) {
                                <%--var isReload = treeCyc.CheckInit(data, apiTreeType[0]);--%>
                                <%--dataModel.updateRemote("${contextRoot}/appRole/updateApiConfig", {--%>
                                    <%--data: {apiFeatureId: data.data.id, roleId: obj.id, updateType: checked},--%>
                                    <%--success: function (data) {--%>
                                        <%--if (isReload === false)return;--%>
                                        <%--apiTreeType[1].reload();--%>
                                    <%--}--%>
                                <%--})--%>
                            },
                            onSuccess: function (data) {
//                                if (Util.isStrEquals(this.id, 'div_configApi_featrue_grid')) {
//                                    var coun = [];
//                                    for (var i = 0; i < data.length; i++) {
//                                        var bo = true;
//                                        for (var j = 0; j < data.length; j++) {
//                                            if (Util.isStrEquals(data[i].parentId, data[j].id) || Util.isStrEquals(data[i].parentId, 0)) {
//                                                bo = false;
//                                            }
//                                        }
//                                        if (bo) {
//                                            coun.push(i);
//                                        }
//                                        delete data[i].children;
//                                    }
//                                    for (var k = 0; k < coun.length; k++) {
//                                        data.splice([coun[k]], 1);
//                                    }
//                                    apiTreeType[1].setData(data);
//                                }
                                $("#div_api_featrue_grid li div span ,#div_configApi_featrue_grid li div span").css({
                                    "line-height": "22px",
                                    "height": "22px"
                                });
                            },
                            onAfterAppend: function () {
//                                $(apiTreeType[0].element).find(".l-checkbox-incomplete").attr("class", "l-box l-checkbox l-checkbox-unchecked")
                            }
                        });
                    }
                },
                reloadRoleGrid: function (appRoleId) {
                    var searchParams = {searchNm: '', treeType: 'featrue', appRoleId: appRoleId, appId: obj.appId};
                    reloadGrid.call(this, '${contextRoot}/appRole/searchFeatrueTree', searchParams);
                },
                clicks: function () {
                    var self = this;
                    self.$funFeatrueBtn.click(function () {
                        funAndApiTree = 'fun';
                        $(".lab-title-msg").html("功能权限：");
                        $(this).removeClass('u-btn-cancel').addClass('u-btn-primary');
                        self.$apiFeatrueBtn.removeClass('u-btn-primary').addClass('u-btn-cancel');
                        self.$functionFeatrueTree.show();
                        self.$configFeatrueTree.show();
                        self.$apiFeatrueTree.hide();
                        self.$configApiFeatrueTree.hide();
                    });
                    self.$apiFeatrueBtn.click(function () {
                        funAndApiTree = 'api';
                        $(".lab-title-msg").html("api权限：");
                        $(this).removeClass('u-btn-cancel').addClass('u-btn-primary');
                        self.$funFeatrueBtn.removeClass('u-btn-primary').addClass('u-btn-cancel');
                        if (Util.isStrEquals(apiTreeType[0], 'apiFeatrueTree')) {
                            master.apiInit();
                        }
                        apiTreeType[1].reload();
                        self.$functionFeatrueTree.hide();
                        self.$configFeatrueTree.hide();
                        self.$apiFeatrueTree.show();
                        self.$configApiFeatrueTree.show();
                    });

                    self.$featrueSaveBtn.click(function () {
                        var url = "${contextRoot}/appRole/updateFeatureConfig";
                        var gridType = functionFeatrueType[1];
                        var datas = functionFeatrueType[0].getChecked();
                        if (Util.isStrEquals(funAndApiTree,'api')){
                            url = "${contextRoot}/appRole/updateApiConfig";
                            gridType = apiTreeType[1];
                            datas = apiTreeType[0].getChecked();
                        }
                        var featureIds = '';
                        $.each(datas,function (key,value) {
                            featureIds += value.data.id+","
                        });
                        dataModel.updateRemote(url, {
                            data: {featureIds: featureIds, roleId: obj.id},
                            success: function (data) {
                                gridType.reload();
                            }
                        })
                    })
                }

//                feaTrueChanges: function (type) {
//                    var self = this;
//                    var titleMsg = '功能权限';
//                    if(Util.isStrEquals(type,'api')){
//                        titleMsg = 'api权限';
//                    }
//                    $(".lab-title-msg").html(titleMsg);
//                    $(this).removeClass('u-btn-cancel').addClass('u-btn-primary');
//                    self.$funFeatrueBtn.removeClass('u-btn-primary').addClass('u-btn-cancel');
//                    if (Util.isStrEquals(apiTreeType[0], 'apiFeatrueTree')) {
//                        master.apiInit();
//                    }
//                    apiTreeType[1].reload();
//                    self.$functionFeatrueTree.hide();
//                    self.$configFeatrueTree.hide();
//                    self.$apiFeatrueTree.show();
//                    self.$configApiFeatrueTree.show();
//                }
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