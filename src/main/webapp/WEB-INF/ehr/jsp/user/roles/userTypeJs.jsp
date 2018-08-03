<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>
    (function ($, win) {
        $(function () {

            var Util = $.Util;
            var master = null;
            var userTypeGrid = null;
            var userTypeId = null;
            var userTypeName="";
            var RoleGroupInfoDialog = null;
            var url = "${contextRoot}/userRoles/user/searchUserType";
            var appRolesListurl = '${contextRoot}/user/appRolesList';
            var apiTreeType = ['apiFeatrueTree', 'configApiFeatrueTree'];
            var dataModel = $.DataModel.init();

            var selroles=[];
            var newselroles=[];
            var userTypeJsonData={};

            function pageInit() {
                master.init();
            }

            master = {
                $userTypeComSearch: $(".inp_userType_com_search"),
                $userTypeGrid: $("#div_userType_grid"),
                $userTypeSearch: $("#inp_userType_search"),
                $RoleGroupI: $("#div_Role_group_grid"),
                $appBrowseMsg: $("#div_app_browse_msg"),
                $apiFeatrueTree: $("#div_api_featrue_grid"),
                $configApiFeatrueTree: $("#div_configApi_featrue_grid"),
                $appRoleGridScrollbar: $(".div-appRole-grid-scrollbar"),
                $roleGroupbtn: $(".div-roleGroup-btn"),
                $featrueSaveBtn: $("#div_featrue_save_btn"),
                $newuserTypeBtn: $("#div_new_userType"),

                init: function () {
                    var self = this;

                    self.$featrueSaveBtn.hide();

                    self.$appRoleGridScrollbar.mCustomScrollbar({});
                    var apiEle = [self.$apiFeatrueTree, self.$configApiFeatrueTree];
                    this.loadRightTree();
                    this.getAllData();

                    self.$userTypeComSearch.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            debugger
                            userTypeName=this.find('input').val();
                            userTypeGrid.setOptions({parms: {
                                searchParm: userTypeName}
                            });
                            userTypeGrid.reload();
                        }
                    });

                    userTypeGrid = self.$userTypeGrid.ligerGrid($.LigerGridEx.config({
                        url: url,
                        parms: {searchParm: userTypeName},
                        isScroll: true,
                        columns: [
                            {display: '用户类别编码', name: 'code', width: '25%'},
                            {display: '用户类别名称', name: 'name', width: '25%'},
                            {display: '状态', name: 'activeFlag', width: '15%',render:function (row) {
                                var activeFlag="<span>生效中</span>";
                                if(row.activeFlag==0){
                                    activeFlag="<span class='c-909090'>已失效</span>";
                                }
                                return activeFlag;
                            }},
                            {
                                display: '操作', name: 'operator', width: '35%', render: function (row) {
                                var activerow={"id": row.id,"code": row.code,"name": row.name,"activeFlag": row.activeFlag,"memo": row.memo};
                                var copyrow={"code": row.code,"name": row.name,"activeFlag": row.activeFlag,"memo": row.memo};
                                var html = '<sec:authorize url="/user/updateUserType"><a class="label_a" title="失效" href="javascript:void(0)" onclick=javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:userType", JSON.stringify(activerow), 'activeFlag') + '>失效</a>&nbsp;&nbsp;</sec:authorize>';
                                if(row.activeFlag==0){
                                    html = '<sec:authorize url="/user/updateUserType"><a class="label_a" title="生效" href="javascript:void(0)" onclick=javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:userType", JSON.stringify(activerow), 'activeFlag') + '>生效</a>&nbsp;&nbsp;</sec:authorize>';
                                }
                                html += '<sec:authorize url="/user/updateUserType"><a class="label_a" title="复制用户类别" href="javascript:void(0)" onclick=javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "app:userType", JSON.stringify(copyrow), 'copyUserType') + '>复制用户类别</a></sec:authorize>';
                                return html;
                            }
                            }
                        ],
                        onSelectRow: function (data) {
                            userTypeJsonData=data;
                            self.resetRoles(data.id);
                            self.$featrueSaveBtn.show();
                        },
                    }));
                    
                    self.clicks();
                },
                clicks: function () {
                    var self = this;

                    $.subscribe('app:userType', function (event, jsonStr, type) {
                        switch (type) {
                            case 'activeFlag':
                                var model = JSON.parse(jsonStr);
                                var content="生效";
                                if(model.activeFlag=="1"){content="失效";model.activeFlag="0"}else{model.activeFlag="1"}
                                parent._LIGERDIALOG.confirm('请问您是否确认'+content+'此用户类别（'+model.name+'）？', function (yes) {
                                    if (yes) {
                                        self.updateUserType(model,type);
                                    }
                                });
                                break;
                            case 'delete':
                                parent._LIGERDIALOG.confirm('确认删除该行信息？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {
                                    if (yes) {
                                        dataModel.updateRemote(url+"deleteAppRoleGroup", {
                                            data: {appGroupId: jsonStr},
                                            async: true,
                                            success: function (data) {
                                                if (data.successFlg) {
                                                    parent._LIGERDIALOG.success('删除成功。');
                                                    master.reloadAppRoleGrid('appRoleGroup', userTypeId, self.$appRoleGroupSearch.val());
                                                } else {
                                                    parent._LIGERDIALOG.error(data.errorMsg);
                                                }
                                            }
                                        });
                                    }
                                });
                                break;
                            case 'copyUserType':
                                self.ligerDialogOpen(jsonStr, type, "复制用户类别", 800, 620);
                                break;
                            case 'edit':
                                self.ligerDialogOpen(jsonStr, type, "修改角色组", 400, 500);
                                break;
                            default:
                                break;
                        }
                    });

                    self.$featrueSaveBtn.click(function () {
                        var gridType = apiTreeType[1];
                        var datas = apiTreeType[0].getChecked();
                        var typeRolesJson=_.map(datas, function (key, value) {
                            if(/^[0-9]+$/.test(key.data.id)){
                                key.data.roleId=key.data.id;
                                key.data.roleName=key.data.name;
                                return key.data;
                            }
                        });
                        typeRolesJson=_.compact(typeRolesJson);
                        debugger
                        $.ajax({
                            type: "POST",
                            url: "${contextRoot}/userRoles/user/saveUserTypeRoles",
                            data: {userTypeJson :JSON.stringify(userTypeJsonData) ,typeRolesJson :JSON.stringify(typeRolesJson) },
                            dataType: "json",
                            success: function(data) {
                                if (data.successFlg) {
                                    $.Notice.success('修改成功');
                                } else {
                                    $.Notice.error(data.errorMsg);
                                }
                            }
                        });
                    });

                    self.$newuserTypeBtn.click(function () {
                        self.ligerDialogOpen("", "add", "新增用户类别", 800, 620);
                    });
                },
                ligerDialogOpen: function (jsonStr, type, title, width, height) {
                    var wait = parent._LIGERDIALOG.waitting("请稍后...");
                    var _model={jsonStr: jsonStr,type: type}
                    RoleGroupInfoDialog = parent._LIGERDIALOG.open({
                        title: title,
                        height: width,
                        width: height,
                        url: '${contextRoot}/userRoles/addUserTypeInfoDialog',
                        load: true,
                        isHidden: false,
                        show: false,
                        urlParms: {
                            json:JSON.stringify(_model)
                        },
                        onLoaded:function() {
                            wait.close();RoleGroupInfoDialog.show();
                        }
                    });
                    RoleGroupInfoDialog.hide();
                },
                updateUserType:function (jsonStr,mode) {
                    $.ajax({
                        type: "POST",
                        url: "${contextRoot}/userRoles/user/updateUserType",
                        data: {userTypeJson :JSON.stringify(jsonStr)},
                        dataType: "json",
                        success: function(data) {
                            var content="成功";
                            if(mode=="copyUserType"){
                                content="复制用户类别"+content;
                            }else if(mode=="activeFlag"){
                                if(jsonStr.activeFlag=="1"){content="设置失效"+content;}else{content="设置生效"+content;}
                            }else if(mode=="addUserType"){content="新增用户类别"+content;}
                            if (data.successFlg) {
                                parent._LIGERDIALOG.success(content);
                                userTypeGrid.reload();
                            } else {
                                parent._LIGERDIALOG.error(data.errorMsg);
                            }
                        }
                    });
                },
                //关联角色组
                getAllData:function () {
                    var me = this;
                    apiTreeType[0] = me.$apiFeatrueTree.ligerSearchTree({
                        nodeWidth: 200,
                        url: appRolesListurl,
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
                resetRoles:function (type) {
                    var me = this;
                    me.f_selectNode()
                    $.ajax({
                        type: "GET",
                        url: "${contextRoot}/userRoles/user/getUserTypeById",
                        data: {"userTypeId":type},
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
            };

            win.parent.closeAppRoleGroupInfoDialog = function (callback) {
                RoleGroupInfoDialog.close();
                master.reloadAppRoleGrid("appRoleGroup", userTypeId, "");
            };
            pageInit();
            $(window).resize(function(){
                master.$appBrowseMsg.width($(window).width()-420);
            });

        })
    })(jQuery, window)
</script>