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

            var idCardNo = '${idCardNo}';
            var type = '${type}';

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
                cd:"",
                orgId:"",
                deptIds:"",
                init: function () {
                    var me = this;
                    this.getOrgAllData();
                    this.loadRightTree();
                    this.bindEvent();
                    this.$selBottom.mCustomScrollbar({
                        axis: "yx"
                    }).mCustomScrollbar("scrollTo","left");
                    if (type == 'view') {
                        this.$selSaveBtn.hide();
                    }
                    if($("#divBtnShow span").attr("data-cd")!=undefined){
                        this.cd=$("#divBtnShow span").attr("data-cd")
                        var jsoncd=JSON.parse(this.cd);
                        $.each(jsoncd,function (k,obj) {
                            me.orgId+=obj.orgId+",";
                            me.deptIds+=obj.deptIds+",";
                        })
                        console.log(me.orgId,me.deptIds)
                    }
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
                            debugger
                            if(me.cd!=""){
                                if(res.successFlg){
                                    res=res.detailModelList
                                }
                                me.leftTree.setData(res);
                                $.each(res, function (k, obj) {
                                    if (me.orgId.indexOf(obj.id)!=-1) {
                                        me.leftTree.selectNode(obj.id);
                                        me.getDeptData(obj.id);
                                    }
                                })
                            }else if (idCardNo != '') {
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
                                    if(me.cd!=""){
                                        $(".sel-r #"+id +" .l-checkbox").addClass("l-checkbox-checked").removeClass("l-checkbox-unchecked")
                                        $(".sel-r  #"+id +" .l-children  .l-checkbox").removeClass("l-checkbox-checked").addClass("l-checkbox-unchecked")
                                        $.each(children, function (k , o ) {
                                            if (me.deptIds.indexOf(o.id)!=-1) {
                                                $(".sel-r .l-children #"+o.id +" .l-checkbox").addClass("l-checkbox-checked").removeClass("l-checkbox-unchecked")
                                            }
                                        })
                                    }
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
                            selectName = [],
                            cd = [];
                        if (checkData.length > 0) {
                            $.each(checkData, function (k, obj) {
                                var $target = $(obj.target),
                                    level = $target.attr('outlinelevel');
                                if (level == '1') {
                                    var $childrens = $target.find('li'),
                                        deptIds = [];
                                    $.each($childrens, function (key, o) {
                                        var cLen = $(o).find('.l-checkbox-checked').length;
                                        if (cLen > 0) {
                                            deptIds.push($(o).attr('id'));
                                            selectName.push($(o).find('span').text());
                                        }
                                    });
                                    cd.push({
                                        orgId: $target.attr('id'),
                                        deptIds: deptIds.join(',')
                                    });
                                }
                            });
                        }
                        w.ORGDEPTVAL = cd;
                        me.cd=JSON.stringify(cd)
                        if(selectName.length>0){
                            $('#divBtnShow').html("<span data-cd='"+me.cd+"'>"+selectName.join(',')+"</sapn>")
                        }
                        w.orgDeptDio.close();
                    });
                    me.$selCloseBtn.on('click', function () {
                        w.orgDeptDio.close();
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