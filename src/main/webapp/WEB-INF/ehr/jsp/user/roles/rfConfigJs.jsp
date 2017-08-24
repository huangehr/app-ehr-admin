<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/8/21
  Time: 15:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>

<script type="text/javascript">
    (function ($, win, u) {
        var intf = [
                '${contextRoot}/userRoles/categoriesAndReport',
                '${contextRoot}/userRoles/addRoleReportRelation'
        ];
        var roleId = '${id}';
        $(function () {
            var rfConfig = {
                $searchInp: $('#searchInp'),
                $saveBtn: $('#saveBtn'),
                $leftTree: $('#leftTree'),
                $rightTree: $('#rightTree'),
                leftTree: null,
                rightTree: null,
                leftTreeData: [],
                rightTreeData: [],
                selectData: [],
                init: function () {
                    var me = this;
                    me.$searchInp.ligerTextBox({width:233, isSearch: true, search: function () {
                        var val = me.$searchInp.val();
                        me.searchData(val);
                    }});
                    me.initLeftTree();
                    me.initRightTree();
                    me.getData();
                    me.bindEvent();
                },
                searchData: function (name) {
                    var me = this;
                    $.ajax({
                        url: intf[0],
                        type: 'GET',
                        data: {
                            roleId: roleId,
                            name: name
                        },
                        dataType: 'json',
                        success: function (data) {
                            if (data.successFlg) {
                                var leftData = data.detailModelList,
                                    leftArr = [];
                                if (leftData) {
                                    leftArr = me.formatData(leftData);
                                    me.leftTreeData = leftArr;
                                    me.reloadLeftTree();
                                }
                            }
                        }
                    });
                },
                getData: function () {
                    var me = this;
                    $.ajax({
                        url: intf[0],
                        type: 'GET',
                        data: {
                            roleId: roleId,
                            name: ''
                        },
                        dataType: 'json',
                        success: function (data) {
                            if (data.successFlg) {
                                var leftData = data.detailModelList,
                                    rightData = data.obj,
                                    leftArr = [],
                                    rightArr = [];
                                if (leftData) {
                                    leftArr = me.formatData(leftData);
                                    me.leftTreeData = leftArr;
                                    me.reloadLeftTree();
                                }
                                if (rightData) {
                                    rightArr = me.formatData(rightData);
                                    me.selectData = rightArr;
                                    me.rightTreeData = rightData;
                                    me.reloadRightree();
                                }
                            }
                        }
                    });
                },
                formatData: function (d) {
                    var arr = [];
                    //获取根节点
                    for (var i = 0; i < d.length; i++) {
                        //设置选中
                        if (d[i].reportList) {
                            for (var t = 0; t < d[i].reportList.length; t++) {
                                d[i].reportList[t].ischecked = d[i].reportList[t].flag;
                            }
                        }
                        d[i].children = d[i].reportList;
                        if (!d[i].pid) {
                            arr.push(d[i]);
                        }
                    }
                    //获取子节点
                    for (var j = 0; j < arr.length; j++) {
                        if (!arr[j].children) {
                            arr[j].children = [];
                        }
                        for (var k = 0; k < d.length; k++) {
                            if (arr[j].id == d[k].pid) {
                                arr[j].children.push(d[k]);
                            }
                        }
                    }
                    return arr;
                },
                reloadLeftTree: function () {
                    this.leftTree.setData(this.leftTreeData);
                },
                reloadRightree: function () {
                    this.rightTree.setData(this.rightTreeData);
                },
                initLeftTree: function () {
                    var me = this;
                    me.leftTree = me.$leftTree.ligerSearchTree({
                        nodeWidth: 240,
                        data: me.leftTreeData,
                        idFieldName: 'code',
                        textFieldName: 'name',
                        isExpand: true,
                        checkbox: true,
                        onCheck: function (e) {
                            setTimeout(function(){
                                var html= me.$leftTree.html();
                                me.$rightTree.html(html);
                                $("#rightTree .l-box.l-checkbox").hide();
                                $("#rightTree .l-checkbox-unchecked").closest("li").hide()
                            },300);
                        }
                    });
                },
                initRightTree: function () {
                    this.rightTree = this.$rightTree.ligerSearchTree({
                        nodeWidth: 240,
                        data: this.rightTreeData,
                        checkbox: false,
                        idFieldName: 'id',
                        textFieldName: 'name',
                        isExpand: false,
                        checkbox: false,
                        isExpand: true
                    });
                },
                bindEvent: function () {
                    var me = this;
                    me.$saveBtn.on('click', function () {
                        var wait = $.Notice.waitting("请稍后...");
                        var selData = me.leftTree.getChecked(),
                            dataArr = [],
                            jsonModel = [],
                            rd = '';
                        for (var i = 0; i < selData.length; i++) {
                            dataArr.push(selData[i].data);
                        }
                        for (var j = 0; j < dataArr.length; j++) {
                            if (!dataArr[j].reportList) {
                                jsonModel.push({
                                    roleId: roleId,
                                    rsReportId: dataArr[j].id
                                });
                            }
                        }
                        if (jsonModel.length == 0) {
                            rd = roleId;
                        }
                        $.ajax({
                            url: intf[1],
                            data: {
                                roleId: rd,
                                jsonModel: JSON.stringify(jsonModel)
                            },
                            type: 'GET',
                            success: function (data) {
                                wait.close();
                                var d = JSON.parse(data);
                                if (d.successFlg) {
                                    $.Notice.success('保存成功。');
                                    win.closeBBConfigDialogDialog();
                                } else {
                                    $.Notice.error(d.errorMsg);
                                }
                            }
                        });
                    });
                }
            };
            rfConfig.init();
        })
    })(jQuery, window);
</script>
