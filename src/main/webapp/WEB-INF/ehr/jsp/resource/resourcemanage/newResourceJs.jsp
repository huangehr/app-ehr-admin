<%--
  Created by IntelliJ IDEA.
  User: JKZL-A
  Date: 2017/9/19
  Time: 14:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/plugin/underscore/underscore.js"></script>
<script type="text/javascript" src="${contextRoot}/develop/lib/zTree/js/jquery.ztree.core.min.js"></script>
<script type="text/javascript" src="${contextRoot}/develop/lib/zTree/js/jquery.ztree.excheck.min.js"></script>
<script type="text/javascript" src="${contextRoot}/develop/lib/zTree/js/jquery.ztree.exedit.min.js"></script>

<script>
    (function (w, $) {
        $(function () {
//            接口
            var inf = [
                '${contextRoot}/resource/resourceManage/resources/tree',
                '${contextRoot}/resource/resourceManage/resources'
            ];
            var switchUrl = {
                configUrl:'${contextRoot}/resourceConfiguration/initial',
                grantUrl:'${contextRoot}/resource/grant/initial',//授权
                viewUrl:'${contextRoot}/resourceView/initial'//浏览-
            };
            var infa = {
                searchResourceList: "${contextRoot}/resourceBrowse/searchResourceList",//获取资源分类
                resources: "${contextRoot}/resource/resourceManage/resources",//获取资源名称
                getDistrictByUserId :"${contextRoot}/user/getDistrictByUserId",//获取地区
                getOrgByUserId: "${contextRoot}/user/getOrgByUserId",//获取医疗机构
                searchResourceData: "${contextRoot}/resourceBrowse/searchResourceData",//获取档案数据
                searchQuotaResourceData: "${contextRoot}/resourceBrowse/searchQuotaResourceData",//获取指标统计
                searchDictEntryList :"${contextRoot}/resourceView/searchDictEntryList",
                getGridCloumnNames: "${contextRoot}/resourceBrowse/getGridCloumnNames",//获取表头-档案数据
                getRsDictEntryList: "${contextRoot}/resourceBrowse/getRsDictEntryList",
                searchQuotaResourceParam: "${contextRoot}/resourceBrowse/searchQuotaResourceParam",//指标资源检索条件获取
                updateResourceQuery: "${contextRoot}/resourceIntegrated/updateResourceQuery"//保存搜索条件
            };
            //档案数据基本数据
            var defauleColumnModel = [
                {"key": 'patient_name', "name": "病人姓名"},
                {"key": 'event_type', "name": "就诊类型"},
                {"key": 'org_name', "name": "机构名称"},
                {"key": 'org_code', "name": "机构编号"},
                {"key": 'event_date', "name": "时间"},
                {"key": 'demographic_id', "name": "病人身份证号码"}
            ];
            var Util = $.Util,
                rsInfoDialog = null,//视图弹窗（增、改）
                rsParamDialog = null,//默认参数配置
                dataElementDialog = null,//数据元配置
                zhibaioConfigueDialog = null,//指标设置
                zhibaioShowDialog = null;//指标预览
            var nr = {
                //维度弹窗
                $ddSeach: $('#ddSeach'),
                $sjIcon: $('.sj-icon'),
                $popSCon: $('.pop-s-con'),
                $popMain: $('.pop-main'),
                $inpRegion: $('#inpRegion'),
                $inpMechanism: $('#inpMechanism'),
                $inpStarTime: $('#inpStarTime'),
                $inpEndTime: $('#inpEndTime'),
                $addSearchDom: $('#addSearchDom'),
                $radDataType: $('input[name=dataType]'),
                $SearchBtn: $("#div_search_btn"),
                $resetBtn: $("#div_reset_btn"),
                $saveSearchBtn: $('#save_search_btn'),
                $inpStarTime: $('#inpStarTime'),
                $inpEndTime: $('#inpEndTime'),
                $newSearch: $("#div_search_data_role_form"),
                GridCloumnNamesData: [],
                index: 0,
                $nrDy: $('.nr-dy'),
                //维度弹窗
                $divTree: $('#divTree'),
                $treeDom: $('#treeDom'),//树- 档案数据
                $treeDomZB: $('#treeDomZB'),//树- 指标统计
                $inpSearch: $('#inpSearch'),//搜索
                $divResourceInfoGrid: $('#divResourceInfoGrid'),//表格-档案数据
                $divQutoResourceInfoGrid: $('#divQutoResourceInfoGrid'),//表格-指标统计
                $nrCon: $('.nr-con'),
                $daBtns: $('#daBtns'),
                $zbBtns: $('#zbBtns'),
                $autBtn: $('#autBtn'),//授权
                $norBtn: $('#norBtn'),//默认参数配置
                $dataBtn: $('#dataBtn'),//数据元配置
                $zbConfigBtn: $('#zbConfigBtn'),//指标配置
                $zbShowBtn: $('#zbShowBtn'),//指标预览
                $outBtn: $('#outBtn'),//导出
                resourceInfoGrid: null,//表格-档案数据
                qutoResourceInfoGrid: null,//表格-指标统计
                type: 1,//1:档案数据;2:指标统计
                categoryId: '',
                dataModel: $.DataModel.init(),//ajax初始化
                queryCondition: '',
                queryQutoCondition: '{}',
                daSelData: null,
                zbSelData: null,
                treeAddNode: null,
                operation: '',
                searchVal: '',//搜索条件-树
                init: function () {
                    Date.prototype.format = function (fmt) {
                        var o = {
                            "M+": this.getMonth() + 1, //月份
                            "d+": this.getDate(), //日
                            "H+": this.getHours(), //小时
                            "m+": this.getMinutes(), //分
                            "s+": this.getSeconds(), //秒
                            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
                            "S": this.getMilliseconds() //毫秒
                        };
                        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
                        for (var k in o)
                            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                        return fmt;
                    };
                    var me = this;
                    me.initForm();
                    me.loadTree();
                    me.bindEvent();
                },
                initForm: function () {
                    var me = this;
                    //搜索-树
                    me.$inpSearch.ligerTextBox({
                        width: 217,
                        isSearch: true,
                        search: function (v) {
                            var zTree = $.fn.zTree.getZTreeObj(me.type == 1 ? "treeDom" : "treeDomZB");
                            me.searchVal = me.$inpSearch.ligerGetTextBoxManager().getValue();
                            zTree.destroy();
                            me.loadTree();
                        }
                    });
                    me.$divTree.mCustomScrollbar({
                        axis:"yx"
                    });
                    //期间
                    me.$inpStarTime.ligerDateEditor({
                        format: 'yyyy-MM-dd'
                    });
                    me.$inpEndTime.ligerDateEditor({
                        format: 'yyyy-MM-dd'
                    });
                    me.$inpStarTime.attr('readonly',true);
                    me.$inpEndTime.attr('readonly',true);
                    me.loadSelData();
                },
                //地区
                loadDistrictData: function () {
                    return this.loadPromise(infa.getDistrictByUserId,{});
                },
                //医疗机构
                loadOrgData: function () {
                    return this.loadPromise(infa.getOrgByUserId, {});
                },
                //加载默认筛选条件
                loadSelData: function () {
                    var me = this;
                    me.loadAllPromise([
                        me.loadDistrictData(),
                        me.loadOrgData()
                    ]).then(function (res) {
                        //地区
                        if (res[0].successFlg == true) {
                            var regions = [];
                            var d = res[0].obj;
                            for (var i = 0, len = d.length; i < len; i++) {
                                regions.push({
                                    text: d[i].name,
                                    id: d[i].id
                                });
                            }
                            me.$inpRegion.ligerComboBox({
                                isShowCheckBox: true,
                                isMultiSelect: true,
                                width: '240',
                                data: regions,
                                valueFieldID: 'inpRegions'
                            });
                        }
                        //机构
                        if (res[1].successFlg) {
                            var d = res[1].obj;
                            var mechanisms = [];
                            for (var i = 0, len = d.length; i < len; i++) {
                                mechanisms.push({
                                    text: d[i].fullName,
                                    id: d[i].fullName
                                });
                            }
                            me.$inpMechanism.ligerComboBox({
                                isShowCheckBox: true,
                                width: '240',
                                data: mechanisms,
                                isMultiSelect: true,
                                valueFieldID: 'mechanism'
                            });
                        } else {
                            me.$inpRegion.ligerComboBox({width: '240'});
                            me.$inpMechanism.ligerComboBox({width: '240'});
                        }
                    });
                },
                loadTree: function () {//加载数据-树
                    var me = this;
                    $.ajax({
                        url: inf[0],
                        type: 'GET',
                        data: {
                            filters: me.searchVal,
                            dataSource: me.type
                        },
                        dataType: 'json',
                        success: function (res) {
                            me.addTreeAjaxFun.call(this, res, me);
                        }
                    });
                },
                getZTreeOption: function () {//参数-树
                    var me = this;
                    var option = {
                        view: {
                            addHoverDom: function (treeId, treeNode) {
                                me.addHoverDom.call(this, treeId, treeNode, me);
                            },
                            removeHoverDom: me.removeHoverDom,
                            selectedMulti: false
                        },
                        check: {
                            enable: false
                        },
                        data: {
                            simpleData: {
                                idKey: 'id',
                                enable: true
                            }
                        },
                        edit: {
                            enable: true,
                            renameTitle: '修改视图',
                            removeTitle: '删除视图',
                            showRenameBtn: true,
                            showRemoveBtn: true
                        },
                        callback: {
                            beforeRemove: function (treeId, treeNode) {
                                var msg = '确认删除该视图信息<br>如果是请点击确认按钮，否则请点击取消按钮？';
                                parent._LIGERDIALOG.confirm(msg, function (yes) {
                                    if (yes) {
                                        var dataModel = $.DataModel.init();
                                        dataModel.updateRemote("${contextRoot}/resource/resourceManage/delete",{
                                            data:{id: treeNode.id},
                                            async:true,
                                            success: function(data) {
                                                if(data.successFlg){
                                                    parent._LIGERDIALOG.success('删除成功');
                                                    var zTree = $.fn.zTree.getZTreeObj(me.type == 1 ? "treeDom" : "treeDomZB");
                                                    zTree.removeNode(treeNode);
                                                }else{
                                                    parent._LIGERDIALOG.error(data.errorMsg);
                                                }
                                            }
                                        });
                                    }
                                });
                                return false;
                            },
                            beforeEditName: function (treeId, treeNode) {
                                me.treeAddNode = treeNode;
                                me.operation = 'edit';
                                $.publish("rs:info:open",[treeNode.id, 'modify', treeNode.category_id, treeNode.category_name, treeNode.data_source]);
                                return false;
                            },
                            onClick: function (e, id, data) {
                                me.initDDL(me.type == 1 ? data.code : data.id);
                                me.addClickTreeNode.call(this, e, id, data, me);
                            }
                        }
                    };
                    return option;
                },
                addTreeAjaxFun: function (data, me) {//初始化树
                    if (data.successFlg && data.detailModelList) {
                        var zNodes = data.detailModelList;
                        $.each(zNodes, function (k, obj) {
                            obj.children = obj.detailList;
                        });
                        $.fn.zTree.init(me.type == 1 ? me.$treeDom : me.$treeDomZB, me.getZTreeOption(), zNodes);
                        if (me.searchVal) {
                            var zTree = $.fn.zTree.getZTreeObj(me.type == 1 ? "treeDom" : "treeDomZB");
                            zTree.expandAll(true);
                        }
                    } else {
                        parent._LIGERDIALOG.error('数据获取失败');
                    }
                },
                addHoverDom: function (treeId, treeNode, me) {//树-添加节点
                    var sObj = $("#" + treeNode.tId + "_span");
                    var delObj = $("#" + treeNode.tId + "_remove");
                    var editObj = $("#" + treeNode.tId + "_edit");
                    if (treeNode.level == 0) {
                        delObj.hide();
                        editObj.hide();
                        if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
                        var addStr = "<span class='button add' id='addBtn_" +
                            treeNode.tId +
                            "' title='新增视图' onfocus='this.blur();'></span>";
                        sObj.after(addStr);
                        var btn = $("#addBtn_"+treeNode.tId);
                        if (btn) btn.on("click", function(){
                            me.treeAddNode = treeNode;
                            me.operation = 'add';
                            $.publish("rs:info:open",['', 'new', treeNode.id, treeNode.name, me.type]);
                        });
                    }
                },
                removeHoverDom: function (treeId, treeNode) {//树-删除节点
                    $("#addBtn_"+treeNode.tId).unbind().remove();
                },
                addClickTreeNode: function (e, id, data, me) {//点击树节点
                    if (data.level != 0) {
                        switch (data.data_source) {
                            case 1:
                                me.daSelData = data;
                                me.$daBtns.show();
                                me.$zbBtns.hide();
                                if (data.grant_type == '0') {
                                    me.$autBtn.show();
                                } else {
                                    me.$autBtn.hide();
                                }
                                me.loadDAGridData(data.code);
                                break;
                            case 2:
                                me.zbSelData = data;
                                me.$daBtns.hide();
                                me.$zbBtns.show();
                                me.loadZBGridData(data.id);
                                break;
                        }
                    }
                },
                //加载档案数据-表格
                loadDAGridData: function (resourcesCode) {
                    var me = this;
                    var columnModel = new Array();
                    //获取列名
                    if (!Util.isStrEmpty(resourcesCode)) {
                        if (me.resourceInfoGrid) {
                            me.reloadDAGridData(resourcesCode);
                        } else {
                            columnModel = me.daColumn(resourcesCode);
                            me.resourceInfoGrid = me.$divResourceInfoGrid.ligerGrid($.LigerGridEx.config({
                                url: infa.searchResourceData,
                                parms: {
                                    searchParams: me.queryCondition,
                                    resourcesCode: resourcesCode
                                },
                                columns: columnModel,
                                height: '100%',
                                checkbox: true
                            }));
                            me.resourceInfoGrid.adjustToWidth();
                        }
                    }
                },
                daColumn: function (resourcesCode) {
                    var me = this,
                        columnModel = [];
                    me.dataModel.fetchRemote( infa.getGridCloumnNames, {
                        data: {
                            dictId: resourcesCode
                        },
                        async: false,
                        success: function (data) {
                            //添加档案数据基本信息表头
                            if (data.length > 0) {
                                if(resourcesCode.indexOf('$')<0){
                                    for (var j = 0, len = defauleColumnModel.length; j < len; j++) {
                                        columnModel.push({
                                            display: defauleColumnModel[j].name,
                                            name: defauleColumnModel[j].key,
                                            width: 100
                                        });
                                    }
                                }
                            }
                            for (var i = 0; i < data.length; i++) {
                                columnModel.push({display: data[i].value, name: data[i].code, width: 100});
                            }
                        }
                    });
                    columnModel.push({
                        display: '操作',
                        width: 80,
                        render: function (row) {
                            return '<a href="#" data-key="'+ row.rowkey +'" data-version="' + row.cda_version + '" class="show-info">查看详情</a>'
                        }
                    });
                    return columnModel;
                },
                reloadDAGridData: function (resourcesCode) {
                    if (resourcesCode) {
                        this.resourceInfoGrid.setOptions({parms: {
                            searchParams: this.queryCondition,
                            resourcesCode: resourcesCode
                        }, columns: this.daColumn(resourcesCode)});
                        this.resourceInfoGrid.loadData(true);
                    }
                },
                //加载指标统计表格
                loadZBGridData: function (resourcesId) {
                    var me = this;
                    var columnModel = new Array();
                    //获取列名
                    if (!Util.isStrEmpty(resourcesId)) {
//                        if (me.qutoResourceInfoGrid) {
//                            me.reloadZBGridData(resourcesId);
//                        } else {
                        //获取表头和数据使用的是同一个接口
                        me.dataModel.fetchRemote( infa.searchQuotaResourceData, {
                            data: {
                                page: 1,
                                rows: 15,
                                searchParams: me.queryQutoCondition,
                                resourcesId: resourcesId
                            },
                            async: false,
                            type: 'GET',
                            success: function (data) {
                                if (data.successFlg) {
                                    var titArr = data.obj;
                                    for (var i = 0; i < titArr.length; i++) {
                                        columnModel.push({display: titArr[i].name, name: titArr[i].key, width: 100});
                                    }
                                    me.qutoResourceInfoGrid = me.$divQutoResourceInfoGrid.ligerGrid($.LigerGridEx.config({
                                        url: infa.searchQuotaResourceData,
                                        parms: {
                                            searchParams: me.queryQutoCondition,
                                            resourcesId: resourcesId,
                                            page: 1,
                                            rows: 15
                                        },
                                        columns: columnModel,
                                        height: '100%',
                                        checkbox: true,
                                        usePager: false
                                    }));
                                    me.qutoResourceInfoGrid.adjustToWidth();
                                } else {
                                    parent._LIGERDIALOG.error(data.errorMsg);
                                }
                            }
                        });
//                        }
                    }
                },
                reloadZBGridData: function (resourcesId) {
                    this.qutoResourceInfoGrid.setOptions({parms: {
                        page: 1,
                        rows: 15,
                        searchParams: this.queryQutoCondition,
                        resourcesId: resourcesId
                    }});
                    this.qutoResourceInfoGrid.loadData(true);
                },
                addChangeTypeFun: function (v) {
                    var me = this;
                    me.type = parseInt(v);
                    var zTree = $.fn.zTree.getZTreeObj(me.type == 1 ? "treeDom" : "treeDomZB");
                    switch (v) {
                        case '1':
                            me.$nrDy.show();
                            me.$nrCon.eq(0).css({'z-index': 2});
                            me.$nrCon.eq(1).css({'z-index': 1});
                            me.$treeDom.show();
                            me.$treeDomZB.hide();
                            if (me.daSelData) {
                                me.$daBtns.show();
                                me.$zbBtns.hide();
                            } else {
                                me.$daBtns.hide();
                            }
                            break;
                        case '2':
                            me.$nrDy.hide();
                            me.$nrCon.eq(0).css({'z-index': 1});
                            me.$nrCon.eq(1).css({'z-index': 2});
                            me.$treeDom.hide();
                            me.$treeDomZB.show();
                            if (me.zbSelData) {
                                me.$daBtns.hide();
                                me.$zbBtns.show();
                            } else {
                                me.$daBtns.hide();
                            }
                            if (!zTree) {
                                me.loadTree();
                            }
                            break;
                    }
                },
                bindEvent: function () {
                    var me = this;
                    //数据切换
                    me.$radDataType.on('change', function () {
                        var thisType = $(this).val();
                        me.addChangeTypeFun(thisType);
                    });
                    $(document).on('click', '.show-info', function () {
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        var k = $(this).attr('data-key'),
                            v = $(this).attr('data-version');
                        $.ajax({
                            url: '${contextRoot}/resourceBrowse/searchResourceSubData',
                            data: {
                                rowKey: k,
                                version: v
                            },
                            type: 'get',
                            timeout:30000,
                            error:function(){
                                wait.close();
                                parent._LIGERDIALOG.error('请求失败');
                            },
                            success: function (res) {
                                wait.close()
                                if(res.successFlg){
                                    var htmlStr = '',
                                        secondStr = '',
                                        threeStr = '',
                                        list = res.detailModelList,
                                        num = list.length;
                                    if(num>0){
                                        for(var i=0;i<num;i++){
                                            secondStr = ''
                                            var keyArr = Object.keys(list[i]);
                                            var val = list[i][keyArr[0]];
                                            for(var j=0;j<val.data.length;j++){
                                                threeStr = ''
                                                for(var key in val.data[j]){
                                                    threeStr += '<div style="padding: 0px 0px 10px 25px;"><span style="color:#333">'+key+'：</span>'+val.data[j][key]+'</div>'
                                                }
                                                secondStr += '<div>'+threeStr+'</div>'
                                            }
                                            htmlStr += '<div style="color:#333;margin-bottom:10px;font-size: 13px;font-weight: 600;padding-left:10px;">'+val.name+'</div><div>'+secondStr+'</div>'
                                        }
                                    }
                                    parent._LIGERDIALOG.open({
                                        title: '详情信息',
                                        isResize: true,
                                        width:500,
                                        height:350,
                                        content: htmlStr,
                                    });
                                }else{
                                    parent._LIGERDIALOG.error(res.errorMsg);
                                }
                            }
                        })
                    });
                    //视图管理
                    $.subscribe("rs:info:open",function(event, resourceId, mode, categoryId, name, dataSource){
                        var title = "";
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        var height = 580;
                        if(mode == "modify"){title = "修改视图";}
                        if(mode == "view"){title = "查看视图";}
                        if(mode == "new"){title = "新增视图";}
                        if (dataSource == 2) {
                            height = 630;
                        }
                        rsInfoDialog = parent._LIGERDIALOG.open({
                            height:height,
                            width:500,
                            title:title,
                            url:'${contextRoot}/resource/resourceManage/infoInitial',
                            urlParms:{
                                id:resourceId,
                                mode:mode,
                                categoryId:categoryId,
                                name: name,
                                dataSource: dataSource
                            },
                            load:true,
                            show:false,
                            isHidden:false,
                            onLoaded:function(){
                                wait.close();
                                rsInfoDialog.show();
                            }
                        });
                        rsInfoDialog.hide();
                    });
                    //配置默认参数
                    me.$norBtn.on('click', function () {
                        var resourcesId = me.daSelData.id,
                            resourcesCode = me.daSelData.code;
                        rsParamDialog = parent._LIGERDIALOG.open({
                            height:500,
                            width:600,
                            title:"配置默认参数",
                            url:'${contextRoot}/resource/rsDefaultParam/initial',
                            urlParms:{
                                resourcesId: resourcesId,
                                resourcesCode: resourcesCode,
                            },
                            load:true
                        });
                    });
                    //数据元配置
                    me.$dataBtn.on('click', function () {
                        var wait = parent._LIGERDIALOG.waitting("请稍后..."),
                            data = {
                                'resourceId': me.daSelData.id,
                                'resourceName': me.daSelData.name,
                                'resourceSub': me.daSelData.category_name,
                                'resourceCode': me.daSelData.code,
                                'dataSource': me.daSelData.data_source
                            };
                        dataElementDialog = parent._LIGERDIALOG.open({
                            height: 700,
                            width: 800,
                            title: "数据元配置",
                            url: switchUrl.configUrl,
                            urlParms:{
                                dataModel: JSON.stringify(data)
                            },
                            load:true,
                            show:false,
                            isHidden:false,
                            onLoaded:function(){
                                wait.close();
                            }
                        });
                    });
                    //授权
                    me.$autBtn.on('click', function () {
                        var wait = parent._LIGERDIALOG.waitting("请稍后..."),
                            data = {
                                'resourceId': me.daSelData.id,
                                'resourceName': me.daSelData.name,
                                'resourceSub': me.daSelData.category_name,
                                'resourceCode': me.daSelData.code,
                                'dataSource': me.daSelData.data_source
                            };
                        dataElementDialog = parent._LIGERDIALOG.open({
                            height: 650,
                            width: 1000,
                            title: "授权",
                            url: switchUrl.grantUrl,
                            urlParms: {
                                dataModel: JSON.stringify(data)
                            },
                            load: true,
                            show: false,
                            isHidden: false,
                            onLoaded: function () {
                                wait.close();
                            }
                        });
                    });

                    //指标配置
                    me.$zbConfigBtn.on('click', function () {
                        var title = "指标配置";
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        zhibaioConfigueDialog = parent._LIGERDIALOG.open({
                            height:700,
                            width:900,
                            title:title,
                            url:'${contextRoot}/resource/resourceManage/resourceConfigue',
                            urlParms:{
                                id: me.zbSelData.id
                            },
                            load:true,
                            show:false,
                            isHidden:false,
                            onLoaded:function(){
                                wait.close();
                                zhibaioConfigueDialog.show();
                            }
                        });
                        zhibaioConfigueDialog.hide();
                    });

                    //指标预览
                    me.$zbShowBtn.on('click', function () {
                        var title = "指标预览";
                        var wait = parent._LIGERDIALOG.waitting("请稍后...");
                        zhibaioShowDialog = parent._LIGERDIALOG.open({
                            height:650,
                            width:800,
                            title:title,
                            url:'${contextRoot}/resource/resourceManage/resourceShow',
                            urlParms:{
                                id: me.zbSelData.id,
                                quotaId: '',
                                dimension: '',
                                quotaFilter: ''
                            },
                            load:false,
                            show:false,
                            isHidden:false,
                            onLoaded:function(){
                                wait.close();
                                zhibaioShowDialog.show();
                            }
                        });
                        zhibaioShowDialog.hide();
                    });

                    me.$ddSeach.on('click', function (e) {
                        e.stopPropagation();
                        if ($(e.target).hasClass('l-table-checkbox') ||
                            $(e.target).hasClass('l-trigger-icon') ||
                            $(e.target).hasClass('l-box-dateeditor-absolute') ||
                            $(e.target).hasClass('l-text-field') ||
                            $(e.target).hasClass('j-text-wrapper') ||
                            $(e.target).hasClass('u-btn-large') ||
                            $(e.target).hasClass('inp-label') ||
                            $(e.target).hasClass('pop-s-con') ||
                            $(e.target).hasClass('f-mt6') ||
                            e.target.tagName.toLocaleLowerCase() == 'span' ||
                            $(e.target).hasClass('clear-s')) {
                            return;
                        }
                        if (me.$popMain.css('display') == 'none') {
                            me.$popMain.css('display', 'block');
                            me.$sjIcon.css('display', 'block');
                            me.$popSCon.css('display', 'block');
                        } else {
                            me.$popMain.css('display', 'none');
                            me.$sjIcon.css('display', 'none');
                            me.$popSCon.css('display', 'none');
                        }
                    });
                    //重置
                    me.$resetBtn.click(function () {
                        me.resetSearch();
                    });
                    //检索
                    me.$SearchBtn.click(function (e) {
                        e.stopPropagation();
                        e.preventDefault();
                        me.index = 0;
                        me.$popMain.css('display', 'none');
                        if (me.type == 1) {
                            me.queryCondition = me.getQuerySearchData();
                            me.reloadDAGridData(me.daSelData.code);
                        } else {
                            me.queryQutoCondition = me.getZBSearchData();
                            me.reloadZBGridData(me.zbSelData.id);
                        }
                    });
                    me.$outBtn.on('click', function () {
                        if (me.type == '1') {
                            if (me.resourceInfoGrid) {
                                var rowData = me.resourceInfoGrid.data.detailModelList;
                                me.outExcel(rowData, me.resourceInfoGrid.currentData.totalPage * me.resourceInfoGrid.currentData.pageSize, me.queryCondition);
                            } else {
                                parent._LIGERDIALOG.error('无数据');
                            }
                        } else {
                            if (me.qutoResourceInfoGrid) {
                                me.outZBWxcel();
                            } else {
                                parent._LIGERDIALOG.error('无数据');
                            }
                        }
                    });
                    //更新搜索条件
                    me.$saveSearchBtn.on('click', function () {
                        var qc = {
                            resourceId: me.type == 1 ? me.daSelData.id : me.zbSelData.id,
                            queryCondition: me.type == 1 ?  me.getQuerySearchData() : me.getZBSearchData()
                        };
                        var waittingDialog = parent._LIGERDIALOG.waitting('正在保存中,请稍候...');
                        me.dataModel.fetchRemote(infa.updateResourceQuery, {
                            data: {
                                dataJson: JSON.stringify(qc)
                            },
                            type: 'POST',
                            success: function (data) {
                                waittingDialog.close();
                                me.$popMain.css('display', 'none');
                                if (data.successFlg) {
                                    parent._LIGERDIALOG.success('更新成功');
                                } else {
                                    parent._LIGERDIALOG.error('更新失败');
                                }
                            }
                        });
                    });
                },
                //导出指标统计excel
                outZBWxcel: function () {
                    window.open("${contextRoot}/resourceBrowse/outQuotaExcel?resourcesId=" + this.zbSelData.id + "&searchParams=" + '{}', "指标统计导出");
                },
                outExcel: function (rowData, size,RSsearchParams) {
                    if (rowData.length <= 0) {
                        parent._LIGERDIALOG.error('无数据');
                        return;
                    }
                    var columnNames = this.resourceInfoGrid.columns;
                    var codes = [];
                    var names = [];
                    var values = [];
                    var valueList = [];
                    for (var i = 0; i < rowData.length; i++) {
                        $.each(rowData[i], function (key, value) {
                            for (var j = 0; j < columnNames.length; j++) {
                                var code = columnNames[j].columnname;
                                if (Util.isStrEquals(code, key)) {
                                    if (Util.isStrEquals($.inArray(code, codes), -1)) {
                                        codes.push(code);
                                        names.push(columnNames[j].display);
                                    }
                                }
                            }
                            if (!Util.isStrEquals($.inArray(key, codes), -1)) {
                                values.push(value);
                            }
                        });
                        valueList.push(values);
                        values = [];
                    }
                    window.open("${contextRoot}/resourceBrowse/outExcel?size=" + size + "&resourcesCode=" + this.daSelData.code + "&searchParams=" + RSsearchParams, "视图数据导出");
                },
                //下拉框列表项初始化
                initDDL: function (v) {
                    var me = this;
                    var url = me.type == 1 ? infa.getGridCloumnNames : infa.searchQuotaResourceParam,
                        param =  me.type == 1 ? (function () {
                            return {
                                dictId: v
                            }
                        })() : (function () {
                            return {
                                resourcesId: v
                            }
                        })();
                    //初始化
                    me.index = 0;
                    me.$addSearchDom.html('');
                    $.ajax({
                        url: url,
                        data: param,
                        type: 'GET',
                        dataType: 'json',
                        success: function (data) {
                            if (me.type == 1) {
                                if (data.length > 0) {
                                    me.GridCloumnNamesData = data;
                                    me.setSearchData();
                                }
                            } else {
                                me.setZBSearchData(data);
                            }
                        }
                    });
                },
                setZBSearchData: function (data) {
                    var me = this;
                    if (data.successFlg) {
                        var d = data.obj;
                        $.each(d, function (k, obj) {
                            var da = [];
                            var $div = $('<div class="f-fl f-mr10 f-ml10 f-mt6">'),
                                html = ['<label class="inp-label" for="inp' + k + '">' + obj.name + ': </label>',
                                    '<div class="inp-text">',
                                    '<input type="text" id="inp' + k + '" data-code="' + obj.key + '" data-type="select" data-attr-scan="field" style="width: 238px" class="f-pr0 f-ml10 inp-reset div-table-colums "/>',
                                    '</div>'].join('');
                            $div.append(html)
                            for (var i = 0; i < obj.value.length; i++) {
                                da.push({
                                    code: obj.value[i],
                                    name: obj.value[i]
                                });
                            }
                            var inp = $div.find('input').ligerComboBox({
                                valueField: 'code',
                                textField: 'name',
                                width: '240',
                                isShowCheckBox: true,
                                isMultiSelect: true,
                                data: da
                            });
                            me.$addSearchDom.append($div);
                        });
                    }
                },
                getZBSearchData: function () {
                    var me = this;
                    var pModel = me.$newSearch.children('div'),
                        jsonData = {};
                    var resetInp = $(pModel.find('.inp-reset'));
                    for (var i = 0; i < resetInp.length; i++) {
                        var code = $(resetInp[i]).attr('data-code'),
                            value = $(resetInp[i]).liger().getValue();
                        if (code != 'EHR_000241' || code != 'EHR_000021') {
                            if (value && value != '') {
                                if (($(resetInp[i]).attr('id')).indexOf('inpStarTime') > -1) {
                                    jsonData['startDate'] = value;
                                } else if (($(resetInp[i]).attr('id')).indexOf('inpEndTime') > -1) {
                                    jsonData['endDate'] = value;
                                } else {
                                    jsonData[code] = (value.split(';')).join(',');
                                }
                            }
                        }
                    }
                    return JSON.stringify(jsonData);
                },
                //筛选存在数据字典中的字段
                setSearchData: function () {
                    var me = this,
                        data = me.GridCloumnNamesData;
                    if (data[me.index].dict && !Util.isStrEquals(data[me.index].dict, 0) && data[me.index].dict != '') {
                        if (data[me.index].dict == 'DATECONDITION') {
                            var $div1 = $('<div class="f-fl f-mr10 f-ml10 f-mt6">'),
                                html1 = ['<label class="inp-label" for="inpStarTime' + me.index + '">' +
                                data[me.index].value + '(开始日期): </label>',
                                    '<div class="inp-text">',
                                    '<input type="text" id="inpStarTime' +
                                    me.index + '" data-code="' +
                                    data[me.index].code + '" data-type="select" data-attr-scan="field" style="width: 238px" class="f-pr0 f-ml10 inp-reset div-table-colums "/>',
                                    '</div>'].join('');
                            var $div2 = $('<div class="f-fl f-mr10 f-ml10 f-mt6">'),
                                html2 = ['<label class="inp-label" for="inpEndTime' + me.index + '">' +
                                data[me.index].value + '(结束日期): </label>',
                                    '<div class="inp-text">',
                                    '<input type="text" id="inpEndTime' +
                                    me.index + '" data-code="' +
                                    data[me.index].code +
                                    '" data-type="select" data-attr-scan="field" style="width: 238px" class="f-pr0 f-ml10 inp-reset div-table-colums "/>',
                                    '</div>'].join('');
                            $div1.append(html1);
                            $div2.append(html2);
                            $div1.find('input').ligerDateEditor({
                                format: 'yyyy-MM-dd'
                            });
                            $div2.find('input').ligerDateEditor({
                                format: 'yyyy-MM-dd'
                            });
                            $div1.find('input').attr('readonly',true);
                            $div2.find('input').attr('readonly',true);
                            me.$addSearchDom.append($div1);
                            me.$addSearchDom.append($div2);
                        } else {
                            var $div = $('<div class="f-fl f-mr10 f-ml10 f-mt6">'),
                                html = ['<label class="inp-label" for="inp' + me.index + '">' + data[me.index].value + ': </label>',
                                    '<div class="inp-text">',
                                    '<input type="text" id="inp' + me.index + '" data-code="' + data[me.index].code + '" data-type="select" data-attr-scan="field" style="width: 238px" class="f-pr0 f-ml10 inp-reset div-table-colums "/>',
                                    '</div>'].join('');
                            $div.append(html);
                            var inp = $div.find('input').ligerComboBox({
                                url: infa.getRsDictEntryList,
                                parms: {dictId: data[me.index].dict},
                                valueField: 'code',
                                textField: 'name',
                                width: '240',
                                dataParmName: 'detailModelList',
                                isShowCheckBox: true,
                                isMultiSelect: true
                            });
                            me.$addSearchDom.append($div);
                        }
                    }
                    me.index++;
                    if (me.index < me.GridCloumnNamesData.length) {
                        me.setSearchData();
                    }
                },
                //获取查询条件
                getQuerySearchData: function () {
                    var me = this;
                    var pModel = me.$newSearch.children('div'),
                        jsonData = [];
                    var resetInp = $(pModel.find('.inp-reset'));
                    for (var i = 0; i < resetInp.length; i++) {
                        var code = $(resetInp[i]).attr('data-code'),
                            value = $(resetInp[i]).liger().getValue(),
                            valArr = [];
                        if (typeof value != 'string' && value instanceof Date) {
                            value = value.format('yyyy-MM-dd') + 'T00:00:00Z';
                        }
                        valArr = value ? value.split(';') : [];
                        for (var j = 0, len = valArr.length; j < len; j++) {
                            var values = {andOr: '', condition: '', field: '', value: ''};
                            values.field = code;
                            if (valArr[j] && valArr[j] != '') {
                                values.andOr = 'OR';
                                values.condition = '=';
                                if (($(resetInp[i]).attr('id')).indexOf('inpStarTime') > -1) {
                                    values.andOr = 'AND';
                                    values.condition = '>';
                                }
                                if (($(resetInp[i]).attr('id')).indexOf('inpEndTime') > -1) {
                                    values.andOr = 'AND';
                                    values.condition = '<';
                                }
                                values.value = valArr[j];
                                jsonData.push(values);
                            }
                        }
                    }
                    for (var j = 0; j < jsonData.length; j++) {
                        if (Util.isStrEmpty(jsonData[j].value) || Util.isStrEmpty(jsonData[j].field)) {
                            jsonData.splice(j, 1);
                            j--;
                        }
                    }
                    jsonData = Util.isStrEquals(jsonData.length, 0) ? "" : JSON.stringify(jsonData);
                    console.log(jsonData);
                    return jsonData;
                },
                resetSearch: function () {
                    var pModel = this.$newSearch.children('div');
                    var resetInp = $(pModel.find('.inp-reset'));
                    for (var i = 1; i < resetInp.length; i++) {
                        $(resetInp[i]).liger().setValue('');
                    }
                },
                loadAllPromise: function (arr) {
                    return Promise.all(_.map(arr, function (o) {
                        return o;
                    }));
                },
                loadPromise: function (url, d) {
                    var me = this;
                    return new Promise(function (resolve, reject) {
                        me.dataModel.fetchRemote(url, {
                            data: d,
                            type: 'GET',
//                            async: false,
                            success: function (data) {
                                resolve(data);
                            }
                        });
                    });
                }
            };
            nr.init();
            //关闭视图管理窗口
            w.parent._closeRsInfoDialog = function (callback) {
                var zTree = $.fn.zTree.getZTreeObj(nr.type == 1 ? "treeDom" : "treeDomZB");
                if (callback) {
                    if (nr.operation == 'add') {
                        var name = callback.name,
                            id = callback.id;
                        $.fn.extend(callback, nr.treeAddNode);
                        var obj = {
                            id: id,
                            category_id: nr.treeAddNode.id,
                            category_name: nr.treeAddNode.name,
                            code: callback.code,
                            data_source: nr.type,
                            pId: nr.treeAddNode.pId,
                            level: 1,
                            name: name,
                        };
                        var addDomNode = zTree.addNodes(nr.treeAddNode, obj);
                        $('#' +addDomNode[0].tId + '_span').on('click', function (e) {
                            nr.addClickTreeNode.call(this, e, id, obj, nr);
                        });
                    } else {
                        zTree.editName(nr.treeAddNode);
                        zTree.cancelEditName(callback.name);
                    }
                }
                rsInfoDialog.close();
            };
            //关闭数据元配置窗口
            w.parent._closeDataElementDialog = function () {
                var $selDom = $('#' + nr.daSelData.tId + '_span');
                dataElementDialog.close();
                $selDom.trigger('click');
            }
            w.parent.closeZhibaioConfigueDialog = function (callback) {
                zhibaioConfigueDialog.close();
            };

        });
    })(window, jQuery);
</script>