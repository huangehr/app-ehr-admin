<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;

            debugger
            var userTypeJson = JSON.parse('${userTypeJson}');
            var type = userTypeJson.type;
            var olddata = userTypeJson.jsonStr;
            var newdata = {};
            var selroles=[];
            var newselroles=[];
            var typeRolesJson={};
            var intf = [
                //获取所有权限
                '${contextRoot}/user/appRolesList','${contextRoot}/userRoles/user/getUserTypeById?userTypeId='+olddata.id,
            ];
            var apiTreeType = ['apiFeatrueTree', 'configApiFeatrueTree'];
            var dataModel = $.DataModel.init();

            // 表单校验工具类
            var jValidation = $.jValidation;

            function pageInit() {
                master.apiInit();
                master.clicks();
            }

            master = {
                $apiFeatrueTree: $("#div_api_featrue_grid"),
                $configApiFeatrueTree: $("#div_configApi_featrue_grid"),
                $appRoleGridScrollbar: $(".div-appRole-grid-scrollbar"),

                $form: $("#div_user_type_form"),
                $addUserBtn: $("#div_btn_add"),
                $cancelBtn: $("#div_cancel_btn"),

                $userTypeId: $("#inp_Id"),
                $userTypeCode: $("#inp_Code"),
                $userTypeName: $('#inp_Name'),
                $userTypeMemo: $('#inp_Memo'),
                $userTypeActiveFlag: $('#inp_activeFlag'),


                apiInit: function () {
                    var self = this;

                    self.$apiFeatrueTree.css("height","300px");

                    self.$appRoleGridScrollbar.mCustomScrollbar({});
                    var apiEle = [self.$apiFeatrueTree, self.$configApiFeatrueTree];
                    this.$userTypeCode.ligerTextBox({width: 240});
                    this.$userTypeName.ligerTextBox({width: 240});
                    this.$userTypeMemo.ligerTextBox({width: 600});

                    this.$form.attrScan();
                    if(type!="add") {
                        this.$form.Fields.fillValues({
                            id: olddata.id,
                            code: olddata.code,
                            name: olddata.name,
                            memo: olddata.memo,
                            activeFlag: olddata.activeFlag,
                        });
                        self.resetRoles();
                    }else{
                        this.$form.Fields.fillValues({
                            activeFlag: "1",
                        });
                    }

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
                            if(checked){
                                newselroles.push(data.data.id)
                            }else{
                                newselroles.splice($.inArray(data.data.id,newselroles),1);
                            }
                            console.log(newselroles.join(","))
                            setTimeout(function () {
                                var html = $("#div_api_featrue_grid").html();
                                $("#div_configApi_featrue_grid").html(html);
                                $("#div_configApi_featrue_grid .l-box.l-checkbox").hide();
                                $("#div_configApi_featrue_grid .l-checkbox-unchecked").closest("li").hide()
                            }, 300)
                        },
                        onSuccess: function (data) {
                            me.$apiFeatrueTree.css("height","");
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
                resetRoles:function () {
                    var me = this;
                    me.f_selectNode()
                    $.ajax({
                        type: "GET",
                        url: "${contextRoot}/userRoles/user/getUserTypeById",
                        data: {"userTypeId":olddata.id},
                        dataType: "json",
                        success: function(data) {
                            if(data.successFlg){
                                selroles=_.map(data.detailModelList,function (item){
                                    return item.roleId
                                })
                                me.f_selectNode()
                            }
                        }
                    });
                },
                f_selectNode:function () {
                    var me = this;
                    if(newselroles.length>0){
                        selroles=newselroles;
                        newselroles=[];
                    }
                    _.each(selroles,function (item) {
                        if(apiTreeType[0].getDataByID(item)){
                            $("li#"+item).find(".l-checkbox").click();
                        }
                    })
                },
                getRoles:function () {
                    var gridType = apiTreeType[1];
                    var datas = apiTreeType[0].getChecked();
                    typeRolesJson=_.map(datas, function (key, value) {
                        if(/^[0-9]+$/.test(key.data.id)){
                            key.data.roleId=key.data.id;
                            key.data.roleName=key.data.name;
                            key.data.clientId=key.data.pid;
                            key.data.typeName=newdata.name;
                            return key.data;
                        }
                    });
                    typeRolesJson=_.compact(typeRolesJson);
                },
                saveRoles:function () {
                    $.ajax({
                        type: "POST",
                        url: "${contextRoot}/userRoles/user/saveUserTypeRoles",
                        data: {userTypeJson :JSON.stringify(newdata) ,typeRolesJson :JSON.stringify(typeRolesJson) },
                        dataType: "json",
                        success: function(data) {
                            if (data.successFlg) {
                               win.closeAppRoleGroupInfoDialog();
                               win.reloadMasterUpdateGrid();
                                $.Notice.success('保存成功');
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    });
                },
                clicks: function () {
                    var self = this;

                    var validator = new jValidation.Validation(this.$form, {
                        immediate: true, onSubmit: false,
                        onElementValidateForAjax: function (elm) {
                            var checkObj = { result:true, errorMsg: ''};
                            if (Util.isStrEquals($(elm).attr("id"), 'inp_Code')) {
                                var Code = $("#inp_Code").val();
                                checkObj=isChinese(Code);
                            }
                            if (Util.isStrEquals($(elm).attr("id"), 'inp_Name')) {
                                var Name = $("#inp_Name").val();
                                checkObj=checkSpecialChar(Name);
                            }
                            if (!checkObj.result) {
                                return checkObj;
                            } else {
                                return checkObj.result;
                            }
                        }
                    });

                    //新增的点击事件
                    this.$addUserBtn.click(function () {
                        self.getRoles();
                        if(typeRolesJson.length==0){
                            $.Notice.warn("请选择关联的角色组");
                            return;
                        }
                        if (validator.validate()) {
                            newdata = self.$form.Fields.getValues();
                            newdata.code=newdata.code.replace(/[\u4e00-\u9fa5]/g,'');
                            newdata.name=stripscript(newdata.name);
                            newdata.memo=stripscript(newdata.memo);
                            if(type=="copyUserType"){newdata.id="";newdata.activeFlag="1"}
                            self.saveRoles();
                        } else {
                            return;
                        }


                    });

                    self.$cancelBtn.click(function () {
                        win.parent.closeAppRoleGroupInfoDialog();
                    });
                }

            };
            pageInit();

            function stripscript(value) {
                debugger
                var pattern = new RegExp("[`~!@#%$^&*+()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]")
                var rs = "";
                for (var i = 0; i < value.length; i++) {
                    rs = rs+value.substr(i, 1).replace(pattern, '');
                }
                rs=rs.replace(/\"/g, "");
                rs=rs.replace(/\s+/g,"");
                $("#inp_userName").val(rs)
                return rs;
            }

            function checkSpecialChar(value) {
                var result=new jValidation.ajax.Result();
                var pattern = new RegExp("[`~!@#%$^&*-+()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]")
                if(pattern.test(value)){
                    result.setResult(false);
                    result.setErrorMsg("请不要输入特殊字符");
                }else{
                    result.setResult(true);
                    result.setErrorMsg('');
                }
                return result;
            }

            function isChinese(str){
                var result=new jValidation.ajax.Result();
                var patrn=/[\u4E00-\u9FA5]|[\uFE30-\uFFA0]/gi;
                if(!patrn.exec(str)){
                    result.setResult(true);
                    result.setErrorMsg('');
                }else{
                    result.setResult(false);
                    result.setErrorMsg("请不要输入汉字");
                }
                return result;
            }

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