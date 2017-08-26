<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/8/21
  Time: 15:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript" src="${contextRoot}/develop/lib/plugin/underscore/underscore.js"></script>
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
                $rfTree: $('.rf-tree'),
                leftTree: null,
                rightTree: null,
                leftTreeData: [],
                rightTreeData: [],
                selectData: [],
                init: function () {
                    var me = this;
                    //搜索
                    me.$searchInp.ligerTextBox({width:233, isSearch: true, search: function () {
                        var val = me.$searchInp.val();
                        me.searchData(val);
                    }});
                    me.$rfTree.mCustomScrollbar({
                        axis: "y"
                    });
//                    me.$rfTree.mCustomScrollbar({
//                        axis: "y"
//                    });
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
//                                    rightArr = me.formatData(rightData);
                                    rightArr = _.sortBy(me.formatData(rightData), function(item) {
                                        return item.id;
                                    });
                                    me.selectData = rightArr;
                                    me.rightTreeData = rightArr;
                                    me.reloadRightree();
                                }
                            }
                        }
                    });
                },
                formatData: function (d) {
                    var arr = [],
                        leve1 = [];
                    //获取根节点
                    for (var i = 0; i < d.length; i++) {
                        if (!d[i].children) {
                            d[i].children = [];
                        }
                        //设置选中
                        if (d[i].reportList) {
                            for (var t = 0; t < d[i].reportList.length; t++) {
                                d[i].reportList[t].ischecked = d[i].reportList[t].flag;
                            }
                        }
                        d[i].ischecked = d[i].flag;
                        if (d[i].children.length <= 0) {
                            d[i].children = d[i].reportList;
                        } else {
                            d[i].children.concat(d[i].reportList);
                        }
                        if (!d[i].pid) {
                            arr.push(d[i]);
                        } else {
                            leve1.push(d[i]);
                        }
                    }
                    for (var w = 0; w < leve1.length; w++) {
                        for (var h = 0; h < leve1.length; h++) {
                            if (leve1[w].id == leve1[h].pid) {
                                if (!leve1[w].children) {
                                    leve1[w].children = [];
                                }
                                leve1[w].children.push(leve1[h]);
                            }
                        }
                    }
                    //获取子节点
                    for (var j = 0; j < arr.length; j++) {
                        if (!arr[j].children) {
                            arr[j].children = [];
                        }
                        for (var k = 0; k < leve1.length; k++) {
                            if (arr[j].id == leve1[k].pid) {
                                arr[j].children.push(leve1[k]);
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
                //初始化树
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
                            var data = e.data,
                                selData = this.getChecked();
                            if (data.children && data.children.length <= 0) {
                                $.Notice.error('该分类暂无可选项！');
                                this.cancelSelect(e.target);
                                return;
                            }
                            for (var i = 0; i < selData.length; i++) {
                                if (selData[i].data.children && selData[i].data.children.length <= 0) {
                                    this.cancelSelect(selData[i].target);
                                }
                            }
                            setTimeout(function(){
                                var html= me.$leftTree.html();
                                me.$rightTree.html(html);
                                $("#rightTree .l-box.l-checkbox").hide();
                                $("#rightTree .l-checkbox-unchecked").closest("li").hide();
                                var lChild = $("#rightTree .l-children");
                                $.each(lChild, function (index, dom) {
                                    var $that = $(dom);
                                    if ($that.html() == '') {
                                        $that.prev().hide();
                                    }
                                });
                            },300);
                        }
                    });
                },
                //初始化树
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
                    //保存数据
                    me.$saveBtn.on('click', function () {
                        var wait = $.Notice.waitting("请稍后...");
                        var selData = me.leftTree.getChecked(),
                            dataArr = [],
                            jsonModel = [],
                            rd = '';
                        for (var i = 0; i < selData.length; i++) {
                            dataArr.push(selData[i].data);
                        }
                        //获取数据元
                        for (var j = 0; j < dataArr.length; j++) {
                            if (!dataArr[j].reportList) {
                                jsonModel.push({
                                    roleId: roleId,
                                    rsReportId: dataArr[j].id
                                });
                            }
                        }
                        //无数据元
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
