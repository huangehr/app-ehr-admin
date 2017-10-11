<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/10/10
  Time: 10:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script src="${contextRoot}/develop/lib/plugin/underscore/underscore.js"></script>

<script>
    (function ($, w, u) {
        $(function () {
            var intf = [
                    //获取所有机构
                    '${contextRoot}/upAndDownOrg/categories',
                    //根据orgId获取部门列表
                    '${contextRoot}/doctor/getOrgDeptsDate',
                    //编辑时回显
                    '${contextRoot}/doctor/getOrgDeptInfoList'
                ];

            var idCardNo = '${idCardNo}'

            var SelOD = {
                $orgTree: $('#orgTree'),
                $deptTree: $('#deptTree'),
                $selSaveBtn: $('#selSaveBtn'),
                $selCloseBtn: $('#selCloseBtn'),
                $selBottom: $('.sel-bottom'),
                leftTree: null,
                rightTree: null,
                treeNodeTmp: $('#treeNodeTmp').html(),
                treeChildNodeTmp: $('#treeChildNodeTmp').html(),
                index:0,
                init: function () {
                    this.getOrgAllData();
                    this.loadRightTree();
                    this.bindEvent();
                    this.$selBottom.mCustomScrollbar({
                        axis: "xy"
                    });
                },
                getOrgAllData: function () {
                    var me = this;
                    me.leftTree = me.$orgTree.ligerSearchTree({
                        nodeWidth: 270,
                        url: idCardNo == '' ? intf[0] : intf[2] + '?idCardNo=' + idCardNo,
                        idFieldName: 'id',
                        textFieldName: 'fullName',
                        isExpand: false,
                        enabledCompleteCheckbox:false,
                        checkbox: true,
                        async: false,
                        onCheck:function (data,isCheck) {
                            var id = data.data.id;
                            if (id) {
                                if (isCheck) {
                                    me.getDeptData(id);
                                } else {
                                    me.$deptTree.find('#' + id).remove();
                                }
                            } else {
                                $.Notice.error('数据有误');
                            }
                        },
                        onSuccess: function (res) {
                            if (idCardNo != '') {
                                if (res.successFlg) {
                                    me.leftTree.setData(res.detailModelList);
                                    $.each(res.detailModelList, function (k, obj) {
                                        if (obj.checked) {
                                            me.leftTree.selectNode(obj.id);
                                        }
                                    })
                                    me.rightTree.setData(res.obj);
                                    $.each(res.obj, function (k, obj) {
                                        var cLen = obj.children.length,
                                                num = 0;
                                        $.each(obj.children, function (key,o) {
                                            if (o.checked) {
                                                num++;
                                                me.rightTree.selectNode(o.id);
                                            }
                                        });
                                        me.rightTree.selectNode(obj.id);
//                                        if (cLen == num) {
//                                        }
                                    });
                                }
                            }
                        }
                    });
                },
                loadRightTree: function () {
                    var me = this;
                    me.rightTree = me.$deptTree.ligerTree({
                        nodeWidth: 270,
                        idFieldName: 'id',
                        textFieldName: 'name',
                        isExpand: false,
                        enabledCompleteCheckbox:false,
                        checkbox: true
                    });
                },
                getDeptData: function (id) {
                    var me = this;
                    $.ajax({
                        url: intf[1],
                        data: {
                            orgId: id
                        },
                        type: 'GET',
                        dataType: 'json',
                        success: function (res) {
                            if ($.isArray(res)) {
                                var obj = res[0],
                                    children = obj.children,
                                    html = '';
                                if (children.length > 0) {
                                    html = me.render(me.treeNodeTmp, obj, function (d, $1) {
                                        if ($1 === 'index') {
                                            d[$1] = me.index;
                                        }
                                        if ($1 === 'childCon') {
                                            var ul = '<ul class="l-children">',
                                                str = '';
                                            $.each(children, function (k, obj) {
                                                str += me.render(me.treeChildNodeTmp, obj, function (d, $1) {
                                                    if ($1 === 'index') {
                                                        d[$1] = k;
                                                    }
                                                });
                                            });
                                            d[$1] = ul + str + '</ul>';
                                        }
                                    });
                                    me.index++;
                                    me.$deptTree.append(html);
                                } else {
                                    $.Notice.error('该机构暂无部门');
                                }
                            } else {
                                $.Notice.error('数据有误');
                            }
                        }
                    });
                },
                bindEvent: function () {
                    var me = this;
                    me.$selSaveBtn.on('click', function () {
                        var checkData = me.rightTree.getChecked(),
                            cd = [];
                        if (checkData.length > 0) {
                            $.each(checkData, function (k, obj) {
                                debugger
                                var $target = $(obj.target),
                                    level = $target.attr('outlinelevel');
                                if (level == '1') {
                                    var $childrens = $target.find('li'),
                                        deptIds = [];
                                    $.each($childrens, function (key, o) {
                                        var cLen = $(o).find('.l-checkbox-checked').length;
                                        if (cLen > 0) {
                                            deptIds.push($(o).attr('id'));
                                        }
                                    });
                                    cd.push({
                                        orgId: $target.attr('id'),
                                        deptIds: deptIds.join(',')
                                    });
                                }
                            });
                        }
                        w.parent.orgDeptDio.hide();
                        w.parent.ORGDEPTVAL = cd;
                    });
                    me.$selCloseBtn.on('click', function () {
                        w.parent.orgDeptDio.hide();
                    });
                },
                render: function(tmpl, data, cb){
                    return tmpl.replace(/\{\{(\w+)\}\}/g, function(m, $1){
                        cb && cb.call(this, data, $1);
                        return data[$1];
                    });
                }
            };
            SelOD.init();
        });
    })(jQuery, window);
</script>