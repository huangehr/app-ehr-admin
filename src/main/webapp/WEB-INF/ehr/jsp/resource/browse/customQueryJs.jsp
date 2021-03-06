<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script src="${contextRoot}/develop/lib/plugin/underscore/underscore.js"></script>
<script>
    (function ($, win, u) {
        // 通用工具类库
        var Util = $.Util;
        //接口
        var pubInf = {
            //地区
            getDistrictByUserId: '${contextRoot}/user/getDistrictByUserId',
            //医疗机构
            getOrgByUserId: '${contextRoot}/user/getOrgByUserId',
            //检测字段
            getRsDictEntryList: '${contextRoot}/resourceBrowse/getRsDictEntryList',
            //获取指标维度
            searchQuotaParam: '${contextRoot}/resourceIntegrated/searchQuotaParam'
        };
        var conInf = [
            //档案数据
            [
                '${contextRoot}/resourceIntegrated/getMetadataList',//树
                '${contextRoot}/resourceIntegrated/searchMetadataData'//表格
            ],
            //指标统计
            [
                '${contextRoot}/resourceIntegrated/getQuotaList',//树
                '${contextRoot}/resourceIntegrated/searchQuotaData'//表格
            ]
        ];
        var rsInfoDialog = null,
            waitSelect = '',
            defArr = [];

        $(function () {
            var cunQue = {
                WH: $(window).height(),
//                btns
                $changBtns: $('.chang-btn'),//tab
                $queryCon: $('.query-con'),//查询
                $genView: $('.gen-view'),//生成视图
                $outExc: $('.out-exc'),//导出
                $scBtn: $('.sc-btn'),//展开\收起筛选
                $queryConc: $('.query-conc'),
                $queryMain: $('.query-main'),
                $selectCon: $('.select-con'),
                $pubSel: $('.pub-sel'),
                $selMore: $('.sel-more'),
                $searchInp: $('#searchInp'),
                $startDate: $('#startDate'),
                $endDate: $('#endDate'),
                $treeCon: $('.tree-con-zhcx'),
                $divLeftTree1: $('#divLeftTree1'),
                $divLeftTree2: $('#divLeftTree2'),
                $divResourceInfoGrid: $('#divResourceInfoGrid'),
                $zbGrid: $('#zbGrid'),
                dataModel: $.DataModel.init(),
                selTmp: $('#selTmp').html(),
                selDateTmp: $('#selDateTmp').html(),
                leftTree: null,
                filters: '',
                //档案数据参数
                resourceInfoGrid: null,
                selectData: [],
                type: 0,//0:档案数据；1：指标统计
                index: 0,
                masterArr: [],
                change:0,
                childArr: [],
                queryCondition: '',
                GridCloumnNamesData: [],
                //指标统计参数
                zbGrid: null,
                tjQuotaIds: [],
                tjQuotaCodes: [],
                ZBCloumnNamesData: [],
                selDataName: [],
                params: {},
                init: function () {
                    //设置综合查询页面的高度
//                    var queryMainH = this.WH - 128 - 25;
//                    this.$queryMain.height(queryMainH);
                    this.initForm();
                    this.loadEventType();
                    this.loadSelData();
                    this.loadTree();
                    this.bindEvent();
                    this.loadGrid();

                    this.$treeCon.mCustomScrollbar({
                        axis: "xy"
                    });
                },
                //初始化表单控件
                initForm: function () {
                    var me = this;
                    me.$startDate.ligerDateEditor({
                        width: 180
                    });
                    me.$endDate.ligerDateEditor({
                        width: 180
                    });
                },
                //地区
                loadDistrictData: function () {
                    return this.loadPromise(pubInf.getDistrictByUserId,{});
                },
                //医疗机构
                loadOrgData: function () {
                    return this.loadPromise(pubInf.getOrgByUserId, {});
                },
                //医疗机构
                loadRsDictEntryListData: function (p) {
                    return this.loadPromise(pubInf.getRsDictEntryList, p);
                },
                loadEventType: function () {
                    var html = '',
                        eObj = {
                            pCode: 'event_type',
                            label: '事件类型',
                            obj: [
                                {id: 0, name: '门诊'},
                                {id: 1, name: '住院'},
                                {id: 2, name: '线上'}
                            ]
                        };
                    html = this.render(this.selTmp, eObj, function (d, $1) {
                        var obj = d.obj || [],
                            str = '';
                        for (var i = 0, len = obj.length; i < len; i++) {
                            str += '<li class="con-item" data-code="' + obj[i].id + '">' + obj[i].name + '</li>';
                        }
                        eObj.content = str;
                    });
                    this.$pubSel.append(html);
                },
                //加载默认筛选条件
                loadSelData: function () {
                    var me = this;
                    me.loadAllPromise([
                        me.loadDistrictData(),
                        me.loadOrgData()
                    ]).then(function (res) {
                        var htm = '';
                        _.each(res, function (o, k) {
                            o.label = k == 0 ? '地区' : '医疗机构';
                            o.pCode = k == 0 ? 'org_area' : 'org_name';
                            htm += me.render(me.selTmp, o, function (d, $1) {
                                var obj = d.obj || [],
                                    str = '';
                                for (var i = 0, len = obj.length; i < len; i++) {
                                    str += '<li class="con-item" data-code="' + (k == 0 ? obj[i].id : obj[i].fullName) + '">' + (k == 0 ? obj[i].name : obj[i].fullName) + '</li>';
                                }
                                o.content = str;
                            });
                        });
                        me.$pubSel.append(htm);
                    });
                },
                //加载树
                loadTree: function () {
                    var me = this;
                    var num = 0;
                    if(me.type==0){//档案数据
                       me.leftTree = me.$divLeftTree1.ligerTree({
                            nodeWidth: 300,
                            url: '${contextRoot}/resourceIntegrated/category',
                            isLeaf : function(data)
                            {
                                if (!data) return false;
                                return data.level == "3";
                            },
                            delay: function(e)
                            {
                                var data = e.data;
                                if (data.level == "1")
                                {
                                    return { url: '${contextRoot}/resourceIntegrated/metadata?categoryId=' + data.id }
                                }
                                return false;
                            },
                           onSuccess: function (data) {
                               var detailModelList = [];
                                if(data.successFlg){
                                    detailModelList = data.detailModelList;
                                    for(var i = 0; i < detailModelList.length; i++){
//                                        detailModelList[i].ischecked = false;
                                        detailModelList[i].children = [];
                                    }
                                    if(detailModelList.length>0 && detailModelList[0].level=="1"){
                                        defArr = data.obj.baseInfo;
                                        me.leftTree.setData(detailModelList);
                                    }
                                }
                           },
                           onCheck:function (data,target) {
                               me.selectData = this.getChecked();
                               me.$scBtn.removeClass('show');
                               me.$selectCon.hide();
                               if (me.selectData.length > 0) {
                                   if (me.type == 0) {
                                       var ma = [], ca = [], sjyArr = [];
                                       if (me.selectData[0].data.level == 3 && me.selectData.length == 1) {
                                           me.selectData.push({data:this.getDataByNode(this.getParentTreeItem(me.selectData[0].target))});
                                       }
                                       for (var i = 0, len = me.selectData.length; i < len; i++) {
                                           switch (me.selectData[i].data.level) {
                                               case '2':
                                                   ma.push(me.selectData[i].data.code);
                                                   break;
                                               case '3':
                                                   sjyArr.push(me.selectData[i].data);
                                                   ca.push(me.selectData[i].data.code);
                                                   break;
                                           }
                                       }
                                       me.masterArr = JSON.stringify(ma);
                                       me.childArr = JSON.stringify(ca);
                                       //初始化
                                       me.index = 0;
                                       me.$selMore.html('');
                                       me.GridCloumnNamesData = sjyArr;
                                       me.change = 1;//改变标志
//                                    console.log(sjyArr)
//                                    me.setSearchData();
                                   }
                               } else {
                                   me.resetDate();
                               }
                           },
                           idFieldName: 'code',
                           textFieldName: 'name',
                           isExpand: false,
                           enabledCompleteCheckbox:false,
                           checkbox: true,
                            slide: false
                        });
                    }else if(me.type==1){//指标统计
                        me.leftTree = me.$divLeftTree2.ligerSearchTree({
                            nodeWidth: 180,
                            url: conInf[me.type][0],
                            parms: {
                                filters: me.filters
                            },
                            idFieldName: 'code',
                            textFieldName: 'name',
                            isExpand: false,
                            enabledCompleteCheckbox:false,
                            checkbox: true,
                            async: false,
                            onCheck:function (data,target) {
                                me.selectData = this.getChecked();
                                me.$scBtn.removeClass('show');
                                me.$selectCon.hide();
                                if (me.selectData.length > 0) {
                                    if (me.type == 0) {
                                        var ma = [], ca = [], sjyArr = [];
                                        if (me.selectData[0].data.level == 3 && me.selectData.length == 1) {
                                            me.selectData.push({data:this.getDataByNode(this.getParentTreeItem(me.selectData[0].target))});
                                        }
                                        for (var i = 0, len = me.selectData.length; i < len; i++) {
                                            switch (me.selectData[i].data.level) {
                                                case '2':
                                                    ma.push(me.selectData[i].data.code);
                                                    break;
                                                case '3':
                                                    sjyArr.push(me.selectData[i].data);
                                                    ca.push(me.selectData[i].data.code);
                                                    break;
                                            }
                                        }
                                        me.masterArr = JSON.stringify(ma);
                                        me.childArr = JSON.stringify(ca);
                                        //初始化
                                        me.index = 0;
                                        me.$selMore.html('');
                                        me.GridCloumnNamesData = sjyArr;
                                        me.change = 1;//改变标志
//                                    console.log(sjyArr)
//                                    me.setSearchData();
                                    } else {
                                        me.tjQuotaIds = [];
                                        me.tjQuotaCodes = [];
                                        for (var k = 0, len = me.selectData.length; k < len; k++) {
                                            if (me.selectData[k].data.level == 2) {
                                                me.tjQuotaIds.push(me.selectData[k].data.id);
                                                me.tjQuotaCodes.push(me.selectData[k].data.code);
                                            }
                                        }
                                        me.ZBCloumnNamesData = [];
                                        me.setZBSearchData();
                                    }
                                } else {
                                    me.resetDate();
                                }
                            },
                            onSuccess: function (data) {
                                var detailModelList = data.detailModelList,
                                    dmList = [];
                                if (detailModelList) {
                                    if (me.type == 0) {
//                                    for(var i = 0; i < detailModelList.length; i++){
//                                        if (detailModelList[i].level == 0) {
//                                            defArr = detailModelList[i].baseInfo;
//                                        } else {
//                                            var rsResourceslist = detailModelList[i].metaDataList;
//                                            detailModelList[i].children = rsResourceslist;
//                                            dmList.push(detailModelList[i]);
//                                        }
//                                    }
                                        defArr = detailModelList[0].baseInfo;
                                        me.leftTree.setData(detailModelList[1]);
                                    } else {
                                        for(var i = 0; i < detailModelList.length; i++){
                                            var childOne = detailModelList[i].child;
                                            detailModelList[i].children = childOne;
                                            for ( var j = 0; j < childOne.length; j++) {
                                                detailModelList[i].children[j].children = childOne[j].detailList;
                                            }
                                            dmList.push(detailModelList[i]);
                                        }
                                        me.leftTree.setData(dmList);
                                    }
                                } else {
                                    if (num == 0) {
                                        parent._LIGERDIALOG.error('暂无数据');
                                    }
                                    num++;
                                }
                            }
                        });
                    }
                },
                resetDate: function () {
                    this.$scBtn.removeClass('show');
                    this.$selectCon.hide();
                    this.index = 0;
                    this.filters = '';
                    $('#searchInp').val('');
                    this.$selMore.html('');
                    this.GridCloumnNamesData = [];
                    this.masterArr = '';
                    this.change = 0;
                    this.childArr = '';
                    this.tjQuotaIds = [];
                    this.tjQuotaCodes = [];
                    this.ZBCloumnNamesData = [];
//                                me.queryCondition = '';
                    this.selectData = [];
                    if (this.type == 0) {
                        this.loadGrid();
                    } else {
                        this.loadZBGrid();
                    }
                },
                //档案数据-筛选存在数据字典中的字段
                setSearchData: function () {
                    var me = this,
                        data = me.GridCloumnNamesData;
                    if (me.type == 1) {
                        return
                    }
                    if (data.length>0 && data[me.index].dictCode && !Util.isStrEquals(data[me.index].dictCode, 0) && data[me.index].dictCode != '') {
                        if (data[me.index].dictCode == 'DATECONDITION') {
                            me.resetSelHtml(data[me.index], 'date',me.index);
                        } else {
                            me.dataModel.fetchRemote(pubInf.getRsDictEntryList, {
                                data: {dictId: data[me.index].dictCode},
                                type: 'GET',
                                async: false,
                                success: function (da) {
                                    if (da.successFlg) {
                                        da.label = data[me.index].name;
                                        da.pCode = data[me.index].code;
                                        me.resetSelHtml(da, 'list',me.index);
                                    }
                                }
                            });
                        }
                    }
                    me.index++;
                    if (me.index < me.GridCloumnNamesData.length) {
                        me.setSearchData();
                    }else{
                        me.resetSelHtml({}, 'list',me.index);
                    }
                },
                //添加查询条件
                resetSelHtml: function (d, t,num) {
                    var me = this,
                        htm = '';
                    if(! $.isEmptyObject(d)){
                        if (t == 'list') {
                            htm = me.render(me.selTmp, d, function (dd, $1) {
                                var obj = d.detailModelList || [],
                                    str = '';
                                for (var i = 0, len = obj.length; i < len; i++) {
                                    str += '<li class="con-item" data-code="' + obj[i].code + '">' + obj[i].name + '</li>';
                                }
                                dd.content = str;
                            });
                            me.$selMore.append(htm);
                        } else {
                            htm = me.render(me.selDateTmp, d, function (dd, $1) {
                                var str = ['<li class="con-item ci-inp">',
                                    '<input type="text" id="startDate' + d.code + '">',
                                    '</li>',
                                    '<li class="con-item ci-inp">',
                                    '<input type="text" id="endDate' + d.code + '">',
                                    '</li>'].join('');
                                if ($1 == 'label') {
                                    dd.label = d.name;
                                }
                                if ($1 == 'content') {
                                    dd.content = str;
                                }
                            });
                            me.$selMore.append(htm);
                            me.loadLirderDate(d.code);
                        }
                    }
                    if(num == me.GridCloumnNamesData.length){
                        me.$scBtn.addClass('show');
                        me.$selectCon.slideDown();
                        me.calLen();
                        setTimeout(function(){
                            waitSelect.close();
                        },200)
                    }
                },
                setZBSearchData: function () {
                    var me = this;
                    me.dataModel.fetchRemote(pubInf.searchQuotaParam, {
                        data: {
                            tjQuotaCodes: (me.tjQuotaCodes).join(',')
                        },
                        success: function (data) {
                            if (data.successFlg) {
                                var d = data.obj,
                                    htm = '';
                                if (d) {
                                    $.each(d, function (k, obj) {
                                        htm += me.render(me.selTmp, obj, function (dd, $1) {
                                            var str = '';
                                            if ($1 == 'label') {
                                                dd.label = dd.name;
                                            }
                                            if ($1 == 'pCode') {
                                                dd.pCode = dd.key;
                                            }
                                            if ($1 == 'content') {
                                                for (var i = 0, len = dd.value.length; i < len; i++) {
                                                    str += '<li class="con-item" data-code="' + dd.value[i]+ '">' + dd.value[i] + '</li>';
                                                }
                                                dd.content = str;
                                            }
                                        });
                                    });
                                }
                                me.$pubSel.html(htm);
                            }
                        }
                    });
                },
                loadLirderDate: function (code) {
                    var sT = $('#startDate' + code),
                        eT = $('#endDate' + code);
                    sT.ligerDateEditor({
                        width: 180
                    });
                    eT.ligerDateEditor({
                        width: 180
                    });
                },
                //加载档案数据表格
                loadGrid: function () {
                    var me = this;
                    var columnModel = new Array();
                    //档案数据时添加基本信息
                    if (me.selectData.length > 0 && me.type == 0) {
                        for (var j = 0, len = defArr.length; j < len; j++) {
                            columnModel.push({display: defArr[j].name, name: defArr[j].code, width: 100});
                        }
                        //获取列名
                        for (var i = 0, len = me.selectData.length; i < len; i++) {
                            if (me.selectData[i].data.level == '3') {
                                columnModel.push({display: me.selectData[i].data.name, name: me.selectData[i].data.code, width: 100});
                            }
                        }
                    }
                    //初始化表格
                    me.resourceInfoGrid = me.$divResourceInfoGrid.ligerGrid($.LigerGridEx.config({
                        url: conInf[me.type][1],
                        parms: {searchParams: '', resourcesCode: '', metaData: ''},
                        columns: columnModel,
                        checkbox: true
                    }));
                },
                //加载指标统计表格
                loadZBGrid: function () {
                    var me = this,
                        columnModel = [];
                    columnModel = me.ZBCloumnNamesData;
                    //初始化表格
                    me.zbGrid = me.$zbGrid.ligerGrid($.LigerGridEx.config({
                        url: conInf[me.type][1],
                        parms: {
                            tjQuotaIds: '',
                            tjQuotaCodes: '',
//                                        searchParams: me.queryCondition
                        },
                        columns: columnModel,
                        checkbox: true
                    }));
                },
                //获取指标统计表头
                loadZBCol: function (params) {
                    var me = this;
                    me.selDataName = [];
                    $.ajax({
                        data: params,
                        async: false,
                        url: conInf[me.type][1],
                        success: function (data) {
                            if (data.successFlg) {
                                var rd = data.detailModelList,
                                    cd = data.obj;
                                if (rd) {
                                    for (var n = 0; n < cd.length; n++) {
                                        me.ZBCloumnNamesData.push({display: cd[n].name,name: cd[n].key,width: 100});
                                    }
                                }
                            } else {
                                parent._LIGERDIALOG.error(data.errorMsg);
                            }
                        }
                    });
                },
                //加载档案数据
                reloadResourcesGrid: function (searchParams) {
                    this.loadGrid();
                    this.resourceInfoGrid.setOptions({parms: searchParams});
                    this.resourceInfoGrid.loadData(true);
                },
                //加载指标统计
                reloadZBGrid: function (searchParams) {
                    this.zbGrid.setOptions({parms: searchParams});
                    this.zbGrid.loadData(true);
                },
                bindEvent: function () {
                    var me = this;
                    //切换数据
                    me.$changBtns.on('click', function (e) {
                        var $that = $(this),
                            index = $that.index();
                        if (me.type == index) {
                            return;
                        }
                        if (index == 0) {
                            me.$divLeftTree1.show();
                            me.$divLeftTree2.hide();
                            me.$searchInp.hide();
                            $(".l-text").hide();
                            me.loadSelData();
                            me.$divResourceInfoGrid.show();
                            me.$zbGrid.hide();
                        } else {
                            me.$searchInp.ligerTextBox({
                                width: 245,
                                isSearch: true,
                                search: function () {
                                    var serVal = $('#searchInp').val();
                                    me.filters = serVal;
                                    me.loadTree();
                                }
                            });
                            me.$divLeftTree1.hide();
                            me.$divLeftTree2.show();
                            $(".l-text").show();
                            me.$searchInp.show();
                            me.$pubSel.html('');
                            me.$divResourceInfoGrid.hide();
                            me.$zbGrid.show();
                        }
                        $that.addClass('active').siblings().removeClass('active');
                        me.type = index;
                        me.resetDate();
                        me.loadTree();
                        e.stopPropagation();
                        e.preventDefault();
                    });
                    //展开\收起筛选条件
                    me.$scBtn.on('click', function () {
                        var $that = $(this),
                            isTrue = $that.hasClass('show');
                        if (isTrue) {
                            $that.removeClass('show');
                            me.$selectCon.slideUp();
                        } else {
                            if(me.change == 1 && me.GridCloumnNamesData.length>0){
                                waitSelect = parent._LIGERDIALOG.waitting("请稍后...");
                                me.change = 0;
                                setTimeout(function(){
                                    me.setSearchData();
                                },200);
                            }else {
                                me.$scBtn.addClass('show');
                                me.$selectCon.slideDown();
                                me.calLen();
                            }
                        }
                    });
                    //展开\收起筛选条件
                    me.$selectCon.on('click', '.sc-btn', function () {
                        var $that = $(this),
                            isTrue = $that.hasClass('show'),
                            $conList = $that.parent().prev();
                        if (isTrue) {
                            $that.removeClass('show');
                            $conList.css({
                                height: '30px',
                                overflow: 'hidden'
                            });
                        } else {
                            $that.addClass('show');
                            $conList.css({
                                height: 'auto',
                                'max-height': '120px',
                                overflow: 'auto'
                            });
                        }
                    }).on('click', '.con-item', function () {
                        //选择条件
                        var $that = $(this),
                            $parent = $that.closest('.sel-item');
                        if ($parent.hasClass('time')) {
                            return;
                        }
                        var code = $that.attr('data-code'),
                            codeList = $parent.attr('data-code-list'),
                            codeArr = codeList.length > 0 ? codeList.split(',') : [],
                            isTrue = $that.hasClass('active');
                        if (isTrue) {
                            var index = codeArr.indexOf(code);
                            if (index > -1) {
                                codeArr.splice(index, 1);
                            }
                            $parent.attr('data-code-list', codeArr.join(','));
                            $that.removeClass('active');
                        } else {
                            codeArr.push(code);
                            $parent.attr('data-code-list', codeArr.join(','));
                            $that.addClass('active');
                        }
                    });
                    //查询
                    me.$queryCon.on('click', function () {
                        debugger
                        me.$scBtn.removeClass('show');
                        me.$selectCon.hide();
                        if (me.type == 0) {
                            me.queryCondition = me.getSelCon();
                            me.reloadResourcesGrid({
                                metaData: me.childArr,
                                resourcesCode: me.masterArr,
                                searchParams: me.queryCondition
                            });
                        } else {
                            me.queryCondition = me.getZBSelCon();
                            var p = {
                                tjQuotaIds: me.tjQuotaIds.join(','),
                                tjQuotaCodes: me.tjQuotaCodes.join(','),
                                searchParams: me.queryCondition
                            };
                            me.loadZBCol(p);
                            me.loadZBGrid();
                            me.reloadZBGrid(p);
                        }
                    });
                    //导出excel
                    me.$outExc.on('click', function () {
                        if (me.type == 0) {
                            var rgd = me.resourceInfoGrid.getData();
                            if (rgd && rgd.length > 0) {
                                var rowData = me.resourceInfoGrid.data.detailModelList;
                                me.outExcel(rowData, me.resourceInfoGrid.currentData.pageSize);
                            } else {
                                parent._LIGERDIALOG.error('请先选择数据！');
                            }
                        } else {
                            var zbd = me.zbGrid.getData();
                            if (zbd && zbd.length > 0) {
                                me.outZBWxcel();
                            } else {
                                parent._LIGERDIALOG.error('请先选择数据！');
                            }
                        }
                    });
                    me.$genView.on('click', function () {
                        var sd = me.selectData,
                            qc = me.queryCondition;
                        if (sd.length <= 0) {
                            parent._LIGERDIALOG.error('请先选择数据');
                            return;
                        }
                        parent._LIGERDIALOG.confirm("确认是否生成视图？", function (yes) {
                            var md = [];
                            if(yes){
                                if (sd.length > 0) {
                                    //档案数据
                                    if (me.type == 0) {
                                        for (var i = 0, len = sd.length; i < len; i++) {
                                            var data = sd[i].data
                                            if (data.level == 3) {
                                                md.push({
                                                    resourcesId: '',
                                                    metadataId: data.code,
                                                    groupType: data.groupType,
                                                    groupData: data.groupData,
                                                    description: data.description
                                                });
                                            }
                                        }
                                    } else {
                                        //指标统计
                                        for (var i = 0, len = sd.length; i < len; i++) {
                                            var data = sd[i].data,
                                                name = '';
//                                            if (data.level == 0 || data.level == 1) {
//                                                name = data.name;
//                                                for (var l = 0, len = sd.length; l < len; l++) {
//                                                    var chilData = sd[l].data;
//                                                    if (chilData.level == 2 && data.id == chilData.quota_type) {
//                                                        md.push({
//                                                            resourceId: '',
//                                                            quotaTypeName: name,
//                                                            quotaChart: 1,
//                                                            quotaCode: chilData.code,
//                                                            quotaId: chilData.id
//                                                        });
//                                                    }
//                                                }
//                                            } else
                                            if (data.level == 2) {
                                                var chilData = data;
                                                name = data.name;
                                                md.push({
                                                    resourceId: '',
                                                    quotaTypeName: name,
                                                    quotaChart: 1,
                                                    quotaCode: chilData.code,
                                                    quotaId: chilData.id
                                                });
                                            }
                                        }
                                        qc = JSON.stringify({});
                                    }

                                    var wait = parent._LIGERDIALOG.waitting("请稍后...");
                                    var height = 550;
                                    if (me.type == 1) {
                                        height = 600;
                                    }

                                    sessionStorage.setItem("customQueryDialog_resourceBrowse", JSON.stringify({
                                        queryCondition: qc,
                                        type: me.type,
                                        metadatas: JSON.stringify(md)
                                    }))

                                    rsInfoDialog = parent._LIGERDIALOG.open({
                                        height:height,
                                        width:500,
                                        title:'新增视图',
                                        url:'${contextRoot}/resourceBrowse/infoInitial',
                                        urlParms:{ },
                                        show:false,
                                        isHidden:false,
                                        onLoaded:function(){
                                            wait.close();
                                            rsInfoDialog.show();
                                        }
                                    });
                                    rsInfoDialog.hide();
                                }
                            }
                        })
                    });
                },
                //获取搜索条件
                getSelCon: function () {
                    var me = this;
                    var $selItems = me.$selectCon.find('.sel-item'),
                            jsonData = [];
                    debugger
                    for (var i = 0, len = $selItems.length; i < len; i++) {
//                        debugger
                        var pCode = $selItems.eq(i).attr('data-parent-code'),
                            codeList = $selItems.eq(i).attr('data-code-list');
                        if (!$selItems.eq(i).hasClass('time')) {
                            var codeArr = codeList.length > 0 ? codeList.split(',') : [];
                            if (codeArr.length > 0) {
                                for (var j = 0, leng = codeArr.length; j < leng; j++) {
                                    var values = {andOr: '', condition: '', field: '', value: ''};
                                    values.andOr = 'OR';
                                    values.condition = '=';
                                    values.field = pCode;
                                    values.value = codeArr[j];
                                    jsonData.push(values);
                                }
                            }
                        } else {
                            //时间条件
                            var sT = $selItems.eq(i).find('[id^=startDate]').val(),
                                eT = $selItems.eq(i).find('[id^=endDate]').val(),
                                aArr = [];

//                            var sT = $selItems.eq(i).attr('data-start-date'),
//                                    eT = $selItems.eq(i).attr('data-end-date'),
//                                    aArr = [];
                            if (sT && sT != '') {
                                aArr.push({
                                    type: '0',
                                    data: sT + 'T00:00:00Z'
                                });
                            }
                            if (eT && eT != '') {
                                aArr.push({
                                    type: '1',
                                    data: eT + 'T00:00:00Z'
                                });
                            }
                            for (var n = 0, nLen = aArr.length; n < nLen; n++) {
                                var values = {andOr: '', condition: '', field: '', value: ''};
                                values.andOr = 'AND';
                                values.field = pCode;
                                values.value = aArr[n].data;
                                if (aArr[n].type == '0') {
                                    values.condition = '>';
                                }
                                if (aArr[n].type == '1') {
                                    values.condition = '<';
                                }
                                jsonData.push(values);
                            }
                        }
                    }
                    return JSON.stringify(jsonData);
                },
                getZBSelCon: function () {
                    var me = this;
                    var $selItems = me.$selectCon.find('.sel-item'),
                        jsonData = {};
                    for (var i = 0, len = $selItems.length; i < len; i++) {
                        var pCode = $selItems.eq(i).attr('data-parent-code'),
                            codeList = $selItems.eq(i).attr('data-code-list');
                        if (!$selItems.eq(i).hasClass('time')) {
                            if (codeList) {
                                jsonData[pCode] = codeList;
                            }
                        } else {
                            //时间条件
                            var sT = $selItems.eq(i).find('[id^=startDate]').val(),
                                eT = $selItems.eq(i).find('[id^=endDate]').val();
                            if (sT) {
                                jsonData['startDate'] = sT;
                            }
                            if (eT) {
                                jsonData['endDate'] = eT;
                            }
                        }
                    }
                    console.log(JSON.stringify(jsonData));
                    return JSON.stringify(jsonData);
                },
                //导出指标统计excel
                outZBWxcel: function () {
                    window.open("${contextRoot}/resourceIntegrated/outQuotaExcel?tjQuotaIds=" + this.tjQuotaIds.join(',') + "&tjQuotaCodes=" + this.tjQuotaCodes.join(',') + "&searchParams=" + '{}' + '&size=' + this.$zbGrid.find('.l-bar-selectpagesize').find('select').val() + '&page=' + this.$zbGrid.find('.pcontrol').find('input').val(), "指标统计导出");
                },
                //导出档案数据excel
                outExcel: function (rowData, size) {
//                    if (rowData.length <= 0) {
//                        parent._LIGERDIALOG.error('请先选择数据');
//                        return;
//                    }
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
                    var metaData = [];
                    for (var i = 0, len = this.selectData.length; i < len; i++) {
                        var data = this.selectData[i].data
                        if (data.level == 2) {
                            metaData.push({
                                code: data.code,
                                name: data.name
                            });
                        }
                    }

                    window.open("${contextRoot}/resourceIntegrated/outFileExcel?size=" + this.$divResourceInfoGrid.find('.l-bar-selectpagesize').find('select').val() + "&resourcesCode=" + this.masterArr + "&searchParams=" + this.queryCondition + "&metaData=" + JSON.stringify(metaData) + '&page=' + this.$divResourceInfoGrid.find('.pcontrol').find('input').val(), "档案数据导出");
                },
                calLen: function () {
                    var $selItems = $('.select-con').find('.sel-item');
                    _.each($selItems, function (item, k) {
                        var $conList = $(item).find('.con-list'),
                            ciLen = $conList.find('.con-item').length,
                            $scBtn = $conList.next().find('.sc-btn'),
                            cW = $conList.width(),
                            ciW = 138;
                        if (cW < (ciW * ciLen)) {
                            $scBtn.show();
                        }
                    });
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
                },
                render: function(tmpl, data, cb){
                    return tmpl.replace(/\{\{(\w+)\}\}/g, function(m, $1){
                        cb && cb.call(this, data, $1);
                        return data[$1];
                    });
                }
            };
            cunQue.init();
            win.parent.closeRsInfoDialog = function (callback) {
                rsInfoDialog.close();
            };
        });

    })(jQuery, window);
</script>