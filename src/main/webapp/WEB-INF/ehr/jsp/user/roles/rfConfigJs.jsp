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
                leftTreeData: [],
                rightTreeData: [],
                init: function () {
                    this.$searchInp.ligerTextBox({width:233, isSearch: true, search: function () {

                    }});
                    this.initLeftTree();
                    this.initRightTree();
                    this.getData();
                },
                getData: function () {
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
                                var d = data.detailModelList;
                                if (d) {
                                    me.leftTreeData = d;
                                    me.reloadLeftTree();
                                } else {

                                }
                            }
                        }
                    });
                },
                reloadLeftTree: function () {
                    this.leftTree.setData(this.leftTreeData);
                },
                reloadLeftTree: function () {
                    this.rightTree.setData(this.rightTreeData);
                },
                initLeftTree: function () {
                    var me = this;
                    me.leftTree = me.$leftTree.ligerSearchTree({
                        nodeWidth: 240,
                        data: me.leftTreeData,
                        idFieldName: 'id',
                        parentIDFieldName:'pid',
                        textFieldName: 'name',
                        isExpand: false,
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
