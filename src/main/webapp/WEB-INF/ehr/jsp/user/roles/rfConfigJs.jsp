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
        var intf = ['${contextRoot}/userRoles/categoriesAndReport'];
        var id = '${id}';
        $(function () {
            var rfConfig = {
                $searchInp: $('#searchInp'),
                $saveBtn: $('#saveBtn'),
                $leftTree: $('#leftTree'),
                $rightTree: $('#rightTree'),
                leftTree: null,
                rightTree: null,
                rightTreeData: [],
                init: function () {
                    this.$searchInp.ligerTextBox({width:233, isSearch: true, search: function () {

                    }});
                    this.initLeftTree();
                    this.initRightTree();
                },
                initLeftTree: function () {
                    var me = this;
                    $.ajax({
                        url: intf[0],
                        type: 'GET',
                        data: {
                            roleId: id
                        },
                        dataType: 'json',
                        success: function (data) {
                            if (data.successFlg) {
                                for (var i = 0; i < data.length; i++) {
                                    if (data[i].children) {
                                        delete data[i].children;
                                    }
                                }
                                me.leftTree = me.$leftTree.ligerSearchTree({
                                    nodeWidth: 240,
                                    data: data,
                                    checkbox: false,
                                    idFieldName: 'id',
                                    parentIDFieldName:'pid',
                                    textFieldName: 'name',
                                    isExpand: false,
                                    checkbox: true,
                                    enabledCompleteCheckbox:false,
                                    onCheck: function (e) {
                                        debugger
                                        var selData = this.getChecked();
                                        console.log('a');
                                    },
//                                onSuccess: function (data) {
//
//                                }
                                });
                            }
                        }
                    });
                },
                reloadRightTree: function () {
                    this.rightTree.setData(this.rightTreeData);
                },
                initRightTree: function () {
                    this.rightTree = this.$rightTree.ligerSearchTree({
                        nodeWidth: 240,
                        data: this.rightTreeData,
                        checkbox: false,
                        idFieldName: 'id',
                        parentIDFieldName:'pid',
                        textFieldName: 'name',
                        isExpand: false,
                        checkbox: false,
                        enabledCompleteCheckbox:false
                    });
                }
            };
            rfConfig.init();
        })
    })(jQuery, window);
</script>
