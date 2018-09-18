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
                    <%--'${contextRoot}/upAndDownOrg/categories',--%>
                    '${contextRoot}/user/AddressDictByPid',
                    //根据orgId获取部门列表
                    '${contextRoot}/doctor/getOrgDeptsDate',
                    //根据机构id获取机构
                    '${contextRoot}/organization/getOrganizationById',
                    //根据地区id和机构名获取机构列表
                    '${contextRoot}/organization/getAllOrgByAdministrativeDivision',
                    //根据orgId获取职务列表
                    '${contextRoot}/resource/dict/entry/getDictEntryByDictCode',
                ];

            var idCardNo = '${idCardNo}';
            var type = '${type}';
            var origin = '${origin}';

            var SelOD = {
                $orgComSearch: $(".inp_org_com_search"),
                $orgTree: $('#orgTree'),
                $deptTree: $('#deptTree'),
                $titleTree: $('#titleTree'),
                $selSaveBtn: $('#selSaveBtn'),
                $selCloseBtn: $('#selCloseBtn'),
                $selBottom: $('.sel-bottom'),
                $selBottomHalf: $('.sel-bottom-half'),
                leftTree: null,
                rightTree: null,
                rightTree_title: null,
                treeNodeTmp: $('#treeNodeTmp').html(),
                treeChildNodeTmp: $('#treeChildNodeTmp').html(),
                treeAddressNodeTmp1: $('#treeAddressNodeTmp1').html(),
                treeAddressNodeTmp2: $('#treeAddressNodeTmp2').html(),
                treeAddressChildNodeTmp1: $('#treeAddressChildNodeTmp1').html(),
                treeAddressChildNodeTmp2: $('#treeAddressChildNodeTmp2').html(),
                index:0,
                cd:"",
                orgId:"",
                orgName:"",
                deptIds:"",
                zhiwuList:{},
                dutyId:[],
                init: function () {
                    var me = this;
                    this.loadALLTree();
                    this.getAddressData(156,0);
//                    this.getOrgAllData();
                    this.bindEvent();
                    this.$selBottom.mCustomScrollbar({
                        axis: "yx"
                    }).mCustomScrollbar("scrollTo","left");
                    this.$selBottomHalf.mCustomScrollbar({
                        axis: "yx"
                    }).mCustomScrollbar("scrollTo","left");
                    if (type == 'view') {
                        this.$selSaveBtn.hide();
                    }
                    if($("#divBtnShow span").attr("data-cd")!=undefined){
                        this.cd=$("#divBtnShow span").attr("data-cd")
//                        this.orgName=$("#divBtnShow span").attr("title").split(',');
                        var jsoncd=JSON.parse(this.cd);
                        $.each(jsoncd,function (k,obj) {
                            me.orgId+=obj.orgId+",";
                            me.deptIds+=obj.deptIds+",";
                            me.dutyId.push({"orgId":obj.orgId,titleId:obj.dutyId});
                        })
                        $.each(me.orgId.split(','),function (k,obj) {
                            setTimeout(function () {
                                if(obj){
                                    me.selAddressData('',obj);
                                }
                            },200)
                        })
                    }

                    me.$orgComSearch.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                                var fullName=this.find('input').val();
//                            fullName="郸城县人民医院";
                            if(fullName){
                                me.selAddressData(fullName);
                            }
                        }
                    });
                },
                //搜索机构
                selAddressData:function (fullName,orgid) {
                    var me = this;
                    $.ajax({
                        url:orgid?intf[2]:intf[3],
                        data: {
                            areaId:'',
                            fullName:fullName,
                            orgId:orgid,
                        },
                        type: 'GET',
                        dataType: 'json',
                        success: function (res) {
                            if(res.successFlg){
                                var list=[];
                                var list=res.detailModelList?res.detailModelList:list.concat(res.obj);
                                if(list.length>0){
                                    _.each(list,function (item,index) {
                                        var aid=item.administrativeDivision.toString();
                                        var pid=aid.substring(0,2)+"0000";
                                        var cid=aid.substring(0,4)+"00";
                                        $("#"+pid+">.l-body .l-expandable-close").click();
                                        setTimeout(function () {
                                            $("#"+cid+">.l-body .l-expandable-close").click();
                                            setTimeout(function () {
                                                $("#"+aid+">.l-body .l-expandable-close").click();
                                                setTimeout(function () {
                                                    if(list.length==1){
                                                        var top=me.$orgTree.find("#"+item.id).position().top-50
                                                        me.$orgTree.parent().css("top","-"+top+"px");
                                                        if(me.$orgTree.find("#"+item.id+">.l-body .l-checkbox").hasClass("l-checkbox-unchecked")){
                                                            me.$orgTree.find("#"+item.id+">.l-body .l-checkbox").click();
                                                        }
                                                    }
                                                },200)
                                            },200)
                                        },200)
                                    })
                                }else{
                                    $.Notice.error('查无此医疗机构');
                                }
                            }else{
                                $.Notice.error(res.errorMsg);
                            }
                        },
                    })
                },
                //获取左侧树地区和机构
                getAddressData:function (pid,level) {
                    var me = this;
                    $.ajax({
                        url:level==3? intf[level]: intf[0],
                        data: {
                            cityPid: pid,
                            areaId:pid,
                            fullName:""
                        },
                        type: 'GET',
                        dataType: 'json',
                        success: function (res) {
                            var data=res.detailModelList;
                            if ($.isArray(data)) {
                                var html = '';
                                if (data.length > 0) {
                                    if(level==3){
                                        _.each(data,function (item,index) {
                                            html += me.render(me.treeAddressChildNodeTmp1, item, function (d, $1) {
                                                if ($1 === 'index') {
                                                    d[$1] = index;
                                                }
                                            });
                                            for(var i=0;i<level;i++){
                                                html +='<div class="l-box"></div>';
                                            }
                                            html += me.render(me.treeAddressChildNodeTmp2, item, function (d, $1) {
                                                if ($1 === 'index') {
                                                    d[$1] = index;
                                                }
                                            });
                                        })
                                        html = '<ul class="l-children">'+html+'</ul>';
                                        me.$orgTree.find("#"+pid).append(html);
                                    }else{
                                        _.each(data,function (item,index) {
                                            html += me.render(me.treeAddressNodeTmp1, item, function (d, $1) {
                                                if ($1 === 'index') {
                                                    d[$1] = index;
                                                }
                                            });
                                            for(var i=0;i<level;i++){
                                                html +='<div class="l-box"></div>';
                                            }
                                            html += me.render(me.treeAddressNodeTmp2, item, function (d, $1) {
                                                if ($1 === 'index') {
                                                    d[$1] = index;
                                                }
                                            });
                                        })
                                        if(level==0){
                                            me.$orgTree.append(html);
                                        }else{
                                            html = '<ul class="l-children">'+html+'</ul>';
                                            me.$orgTree.find("#"+pid).append(html);
                                        }
                                    }
                                } else {
                                    if(level==3){
                                        $.Notice.error('无该地区医疗机构记录');
                                    }else{
                                        $.Notice.error('无该地区下级记录');
                                    }
                                }
                            } else {
                                $.Notice.error(res.errorMsg);
                            }
                        },
                    })
                },
                //初始化三棵树
                loadALLTree: function () {
                    var me = this;
                    me.leftTree = me.$orgTree.ligerTree({
                        nodeWidth: 270,
                        idFieldName: 'id',
                        textFieldName: 'name',
                        isExpand: false,
                        enabledCompleteCheckbox:false,
                        onBeforeExpand:function (data) {
                            var id=$(data.target).attr("id");
                            var level=$(data.target).attr("outlinelevel");
                            if(!$(data.target).children().hasClass("l-children")){
                                me.getAddressData(id,level);
                            }
                        },
                        onCheck:function (data,isCheck) {
                            var id = $(data.target).attr("id");
                            if (id) {
                                if (isCheck) {
                                    me.getDeptData(id,1);
                                    me.getDeptData(id,4,$(data.target).children(".l-body").find("span").html());
                                } else {
                                    me.$deptTree.find('#' + id).remove();
                                    me.$titleTree.find('#' + id).remove();
                                }
                            } else {
                                $.Notice.error('数据有误');
                            }
                        },
                    });
                    me.rightTree = me.$deptTree.ligerTree({
                        nodeWidth: 270,
                        idFieldName: 'id',
                        textFieldName: 'name',
                        isExpand: false,
                        enabledCompleteCheckbox:false,
                        checkbox: true,
                        onCheck:function (data,isCheck) {
                            me.singleCheck(data,isCheck)
                        },

                    });
                    me.rightTree_title = me.$titleTree.ligerTree({
                        nodeWidth: 270,
                        idFieldName: 'id',
                        textFieldName: 'name',
                        isExpand: false,
                        enabledCompleteCheckbox:false,
                        checkbox: true,
                        onCheck:function (data,isCheck) {
                            me.singleCheck(data,isCheck)
                        },
                    });
                },
                //获取机构下的科室和职务树，并选中已选项
                getDeptData: function (id,type,name) {
                    var me = this;
                    if(type==4 && me.zhiwuList.length>0){
                        var obj={};
                        obj.id=id;
                        obj.name=name;
                        obj.children=me.zhiwuList;
                        me.fillRightTree(id,type,obj)
                    }else{
                        $.ajax({
                            url: intf[type],
                            data: {
                                orgId: id
                            },
                            type: 'GET',
                            dataType: 'json',
                            success: function (res) {
                                if($.isArray(res)){
                                    var obj = res[0];
                                    if(obj.checked==undefined){
                                        me.zhiwuList=res;
                                        var newobj={};
                                        newobj.id=id;
                                        newobj.name=name;
                                        newobj.children=_.map(res,function (item,index) {
                                            item.id=item.code
                                            return item;
                                        });
                                        obj=newobj;
                                    }
                                    me.fillRightTree(id,type,obj)
                                } else {
                                     $.Notice.error(res.errorMsg);
                                }
                            }
                        });
                    }
                },
                //选中已选的科室和职务
                fillRightTree:function (id,type,obj) {
                    var me = this;
                    var children = obj.children,
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
                        if(type==1){
                            me.$deptTree.append(html);
                            if(me.cd!=""){
                                $("#deptTree #"+id +" .l-checkbox").addClass("l-checkbox-checked").removeClass("l-checkbox-unchecked")
                                $("#deptTree  #"+id +" .l-children  .l-checkbox").removeClass("l-checkbox-checked").addClass("l-checkbox-unchecked")
                                $.each(children, function (k , o ) {
                                    if (me.deptIds.indexOf(o.id)!=-1) {
                                        $(".sel-r .l-children #"+o.id +" .l-checkbox").addClass("l-checkbox-checked").removeClass("l-checkbox-unchecked")
                                    }
                                })
                            }
                        }else{
                            me.$titleTree.append(html);
                            if(me.cd!=""){
                                $("#titleTree #"+id +" .l-checkbox").addClass("l-checkbox-checked").removeClass("l-checkbox-unchecked")
                                $("#titleTree  #"+id +" .l-children  .l-checkbox").removeClass("l-checkbox-checked").addClass("l-checkbox-unchecked")
                                var titleId = _.filter(me.dutyId, function(item){
                                    return item.orgId==id?item.titleId:"";
                                });
                                if(titleId.length>0){
                                    $.each(children, function (k , o ) {
                                        if (titleId[0].titleId.indexOf(o.id)!=-1) {
                                            $("#titleTree #"+id +" .l-children #"+o.id +" .l-checkbox").addClass("l-checkbox-checked").removeClass("l-checkbox-unchecked")
                                        }
                                    })
                                }
                            }
                        }
                    } else {
                        if(type==1){
                            $.Notice.error('该机构暂无部门');
                        }else{
                            $.Notice.error('该机构暂无职称');
                        }
                    }
                },
                //保存和取消按钮事件
                bindEvent: function () {
                    var me = this;
                    me.$selSaveBtn.on('click', function () {
                        var isgo=true;
                        var checkData = me.rightTree.getChecked(),
                            checkData_title = me.rightTree_title.getChecked(),
                            selectName = "",titleName="",selectorgName = [],
                            cd = [];
                        if (checkData.length > 0) {
                            $.each(checkData, function (k, obj) {
                                if(isgo){
                                    var $target = $($(obj)[0].target),
                                        level = $target.attr('outlinelevel'),
                                        id= $($(obj)[0].target).attr("id"),
                                        name=$target.children(".l-body").find("span").html();
                                    if (level == '1') {
                                        var $childrens = $target.find('li'),
                                            deptIds = [],
                                            titleIds = [];
                                        $.each($childrens, function (key, o) {
                                            var cLen = $(o).find('.l-checkbox-checked').length;
                                            if (cLen > 0) {
                                                deptIds.push($(o).attr('id'));
                                                selectName=$(o).find('span').text();
                                            }
                                        });
                                        var $target_t=me.$titleTree.find("#"+id);
                                        if(me.$titleTree.find("#"+id+">.l-body .l-checkbox").hasClass('l-checkbox-checked')){
                                            var $childrens_t = $target_t.find('li');
                                            $.each($childrens_t, function (key, o) {
                                                var cLen = $(o).find('.l-checkbox-checked').length;
                                                if (cLen > 0) {
                                                    titleIds.push($(o).attr('id'));
                                                    titleName=$(o).find('span').text();
                                                }
                                            });
                                        }else{
//                                            $.Notice.error(name+'的职务未选择');
//                                            isgo=false;
//                                            return;
                                        }
                                        cd.push({
                                            orgId: $target.attr('id'),
                                            deptIds: deptIds.join(','),
                                            dutyId: titleIds.join(',')
                                        });
                                        selectorgName.push(name+"/"+selectName+"/"+titleName);
                                    }
                                }
                            });
                        }
                        if(isgo){
                            w.ORGDEPTVAL = cd;
                            me.cd=JSON.stringify(cd);
                            if(selectorgName.length>0){
                                debugger
                                var spanname=selectorgName[0];
                                if(selectorgName.length>1){
                                    spanname+="……"
                                }
                                $('#divBtnShow').html("<span data-cd='"+me.cd+"' title='"+selectorgName.join(',')+"'>"+spanname+"</sapn>")
                            }
                            w.orgDeptDio.close();
                        }
                    });
                    me.$selCloseBtn.on('click', function () {
                        w.orgDeptDio.close();
                    });
                },
                //机构的科室和职务只能单选
                singleCheck:function (data,isCheck) {
                    var id = $(data.target).attr("id");
                    if (id) {
                        if (isCheck) {
                            if($(data.target).hasClass("l-first")){
                                $(data.target).children(".l-children").find(".l-checkbox.l-checkbox-checked").removeClass("l-checkbox-checked").addClass("l-checkbox-unchecked");
                                $(data.target).children(".l-children>li").removeClass("l-checkbox-unchecked").addClass("l-checkbox-checked");
                            }else{
                                $(data.target).siblings("li").find(".l-checkbox.l-checkbox-checked").removeClass("l-checkbox-checked").addClass("l-checkbox-unchecked");
                            }
                        }
                    } else {
                        $.Notice.error('数据有误');
                    }
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