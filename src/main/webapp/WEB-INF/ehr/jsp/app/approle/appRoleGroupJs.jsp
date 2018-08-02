<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script src="${contextRoot}/develop/lib/plugin/underscore/underscore.js"></script>

<script>
    (function ($, w, u) {
        $(function(){
            var intf = [
                //获取所有权限
                '${contextRoot}/user/appRolesList',
            ];
            var userId = '${loginCode}';
            var type = '${type}';
            var selroles=[];

            var SelOD = {
                $allTree: $('#allTree'),
                $selTree: $('#selTree'),
                $selSaveBtn: $('#selSaveBtn'),
                $selCloseBtn: $('#selCloseBtn'),
                $selBottom: $('.sel-bottom'),
                leftTree: null,
                rightTree: null,
                treeNodeTmp: $('#treeNodeTmp').html(),
                treeChildNodeTmp: $('#treeChildNodeTmp').html(),
                init: function() {
                    var me = this;
                    this.getUserRole();
                    this.getAllData();
                    this.loadRightTree();
                    this.bindEvent();
                    this.$selBottom.mCustomScrollbar({
                        axis: "yx"
                    }).mCustomScrollbar("scrollTo", "left");
                    if (type == 'view') {
                        this.$selSaveBtn.hide();
                    }
                },
                getAllData:function () {
                    var me = this;
                    me.leftTree = me.$allTree.ligerSearchTree({
                        nodeWidth: 270,
                        url: intf[0],
                        idFieldName: 'id',
                        textFieldName: 'name',
                        isExpand: false,
                        enabledCompleteCheckbox:false,
                        checkbox: true,
                        async: false,
                        onCheck:function (data,isCheck) {
                            debugger
                            var target=data.target;
                            if(data.data.pid){
                                data.target=$("li#"+data.data.pid);
                                data.data=me.leftTree.getDataByID(data.data.pid);
                                data.target.remove();
                            }
                            me.$selTree.append(data.target, data.data);
                            me.rightTree.expandAll();
                        },
                        onSuccess: function (res) {
//                            me.leftTree.selectNode(selroles.join(","));
                              me.f_selectNode();
//                            me.leftTree.getChecked();
                        },
                    })
                },
                loadRightTree:function () {
                    var me = this;
                    me.rightTree = me.$selTree.ligerTree({
                        nodeWidth: 270,
                        idFieldName: 'id',
                        textFieldName: 'name',
                        isExpand: false,
                        enabledCompleteCheckbox:false,
                        checkbox: true,
                        onSuccess: function () {

                        }
                    });
                },
                getUserRole:function () {
                    var me = this;
                    if(userId){

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
                        if(me.leftTree.getDataByID(item)){
                            var nodedata={
                                data:me.leftTree.getDataByID(item),target:$("li#"+item)
                            }
                            if(nodedata.data.pid){
                                nodedata.target=$("li#"+nodedata.data.pid);
                                nodedata.data=me.leftTree.getDataByID(nodedata.data.pid);
                                nodedata.target.remove();
                            }
                            me.$selTree.append(nodedata.target, nodedata.data);
                            me.rightTree.expandAll();
                        }
                        me.$selTree.find("#"+item+" .l-checkbox").removeClass("l-checkbox-unchecked").addClass("l-checkbox-checked")
                    })
                },
                bindEvent:function () {
                    var me = this;
                    me.$selSaveBtn.on('click', function () {
                        var checkData = me.rightTree.getChecked();
                        if (checkData.length > 0) {
                            $.each(checkData, function (k, obj) {
                                var $target = $(obj.target),
                                    level = $target.attr('outlinelevel');
                                if (level == '1') {
                                    var $childrens = $target.find('li'),
                                        selroles = [];
                                    $.each($childrens, function (key, o) {
                                        var cLen = $(o).find('.l-checkbox-checked').length;
                                        if (cLen > 0) {
                                            selroles.push($(o).attr('id'));
                                        }
                                    });
                                }
                            });
                        }
                        w.roleIds = selroles.join(",");
                        w.roleGroupDio.close();
                    });
                    me.$selCloseBtn.on('click', function () {
                        w.roleGroupDio.close();
                    });
                },
            };
            SelOD.init();
        });

    })(jQuery, window);
</script>