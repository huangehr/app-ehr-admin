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
                master.clicks();
            }
            function reloadGrid(url, ps) {
                
                functionFeatrueType[1].options(url,{parms: ps});
                functionFeatrueType[1].loadData(true);
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
                    var timeOutTree;
                    $(".lab-title-msg").html(obj.name+"权限");
                    self.$appRoleGridScrollbar.mCustomScrollbar({
                    });
                    var funEle = [self.$functionFeatrueTree,self.$configFeatrueTree];
                    var functionType = ["featrue","configFeatrue"];
                    for (var i = 0; i < functionFeatrueType.length; i++) {
                        var checkboxBo = Util.isStrEquals(i,0)?true:false;
                        var appRoleId = obj.id;
                        functionFeatrueType[i] = funEle[i].ligerSearchTree({
                            url: '${contextRoot}/appRole/searchFeatrueTree',
                            parms:{searchNm: '',treeType:functionType[i],appRoleId:appRoleId},
                            idFieldName: 'id',
                            parentIDFieldName: 'parentId',
                            textFieldName: 'name',
                            isExpand: false,
                            autoCheckboxEven:false,
                            checkbox: checkboxBo,
                            async: false,
                            onCheck:function (data,checked) {
                                debugger
                                var isReload = treeCyc.CheckInit(data,functionFeatrueType[0]);
                                dataModel.updateRemote("${contextRoot}/appRole/updateFeatureConfig", {
                                    data: {AppFeatureId: data.data.id,roleId:obj.id,updateType:checked},
                                    success: function (data) {
                                        clearTimeout(timeOutTree)
//                                        timeOutTree=setTimeout(function(){
//                                            functionFeatrueType[1].reload();
//                                        },1);
                                        if(isReload===false)return;
                                        functionFeatrueType[1].reload();
                                        /*if (data.successFlg){
                                            
//                                            functionFeatrueType[1].clear();
                                            if(count==0) {
                                                functionFeatrueType[1].reload();
                                            }

                                        }*/

                                    }
                                })

                            },
                            onSuccess: function (data) {

                                if (Util.isStrEquals(this.id,'div_configFun_featrue_grid')){
                                    var dataNew=[];
                                    for(var i=0;i<data.length;i++){
                                        if(data[i].parentId==0 ){
                                            dataNew.push(data[i])
                                        }else{
                                            for(var j=0;j<data.length;j++){
                                                if(data[i].parentId==data[j].id){
                                                    dataNew.push(data[i])
                                                    break;
                                                }else{
                                                    data[i]={};
                                                }
                                            }
                                        }

                                    }
                                    debugger
                                    functionFeatrueType[1].setData(dataNew);


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
//                    self.clicks();
                },
                reloadRoleGrid: function (appRoleId) {
                    
                        var searchParams = {searchNm: '',treeType:'featrue',appRoleId:appRoleId};
                    reloadGrid.call(this, '${contextRoot}/appRole/searchFeatrueTree',searchParams);
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
                            autoCheckboxEven:false,
                            checkbox: checkboxBo,
                            async: false,
                            onCheck:function (data,checked) {

                                
                                treeCyc.CheckInit(data);
/*
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
                                })*/
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
            //cyc
            var treeCyc={
                CheckInit:function(e,tree){
                    var self=this;
                    var obj=$(e.target);//当前对象
                    var objlevel=obj.attr("outlinelevel");//当前对象的层级
                    var objCheckbox= $(obj.find(".l-body")[0]).find(".l-checkbox")//当前对象的复选框
                    return self.treeClick(obj,objlevel,objCheckbox,tree)
                },//点击事件初始化
                treeClick:function(obj,objlevel,objCheckbox,tree){//当前对象、当前对象的层级、当前对象的复选框
                    var self=this;
                    var parentItemCyc;//父节点

                    parentItemCyc=$(tree.getParentTreeItem(obj, objlevel-1))//父节点
                    parentItemCheckboxCyc=$(parentItemCyc.find(".l-body")[0]).find(".l-checkbox")//父节点的复选框
                    if(objCheckbox.hasClass("l-checkbox-checked")){//选中事件
                        if(self.isRrotherly(parentItemCyc,objlevel) && parentItemCheckboxCyc.hasClass("l-checkbox-unchecked")){//如果没有被选中的同级就对父级进行选中操作
                                parentItemCheckboxCyc.click();
                            return false;
                        }
                       return true;
                    }



                },//点击事件处理
                isRrotherly:function(parentItemCyc,objlevel){//父节点对象 和当前点击节点的 outlinelevel
                    var parentItemCyc=parentItemCyc;
                    var self=this;
                    if(parentItemCyc.find("li[outlinelevel="+objlevel+"] > div .l-checkbox-checked").length==1){//如果同级未有被选中 则返回true
                        return true
                    }else{
                        return false
                    }


                },//是否有被选中的同级

            }
        })
    })(jQuery, window)
</script>