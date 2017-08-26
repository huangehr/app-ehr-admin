<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script src="${contextRoot}/develop/lib/plugin/underscore/underscore.js"></script>
<script>
    (function ($, win, u) {
        // 通用工具类库
        var Util = $.Util;
        var pubInf = {
            //地区
            getDistrictByUserId: '${contextRoot}/user/getDistrictByUserId',
            //医疗机构
            getOrgByUserId: '${contextRoot}/user/getOrgByUserId',
            //检测字段
            getRsDictEntryList: '${contextRoot}/resourceBrowse/getRsDictEntryList'
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

                $treeCon: $('.tree-con'),
                $divLeftTree: $('#divLeftTree'),
                $divResourceInfoGrid: $('#divResourceInfoGrid'),

                dataModel: $.DataModel.init(),
                selTmp: $('#selTmp').html(),

                leftTree: null,
                resourceInfoGrid: null,
                selectData: [],
                type: 0,//0:档案数据；1：指标统计
                index: 0,
                masterArr: [],
                childArr: [],
                queryCondition: '',
                GridCloumnNamesData: [],
                init: function () {
                    //设置综合查询页面的高度
                    var queryMainH = this.WH - 128 - 25;
                    this.$queryMain.height(queryMainH);
                    this.initForm();
                    this.loadSelData();
                    this.loadTree();
                    this.bindEvent();
                },
                //初始化表单控件
                initForm: function () {
                    var me = this;
                    me.$searchInp.ligerTextBox({
                        width: 245,
                        isSearch: true,
                        search: function () {
                            self.reloadGrid(1);
                        }
                    });

                    me.$treeCon.mCustomScrollbar({
                        axis: "y"
                    });
                    me.$queryConc.mCustomScrollbar({
                        axis: "y"
                    });
                    me.$startDate.ligerDateEditor({
                        width: 180,
                        onChangeDate: function () {
                            var $parent = me.$startDate.closest('.sel-item');
                            $parent.attr('data-start-date', me.$startDate.val());
                        }
                    });
                    me.$endDate.ligerDateEditor({
                        width: 180,
                        onChangeDate: function () {
                            var $parent = me.$endDate.closest('.sel-item');
                            $parent.attr('data-end-date', me.$endDate.val());
                        }
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
                            o.pCode = k == 0 ? 'EHR_000241' : 'EHR_000021';
                            htm += me.render(me.selTmp, o, function (d, $1) {
                                var obj = d.obj || [],
                                    str = '';
                                for (var i = 0, len = obj.length; i < len; i++) {
                                    str += '<li class="con-item" data-code="' + (k == 0 ? obj[i].name : obj[i].fullName) + '">' + (k == 0 ? obj[i].name : obj[i].fullName) + '</li>';
                                }
                                o.content = str;
                            });
                        });
                        me.$pubSel.append(htm);
                    });
                },
                loadTree: function () {
                    var me = this;
                    me.leftTree = me.$divLeftTree.ligerSearchTree({
                        nodeWidth: 180,
                        url: conInf[me.type][0],
                        idFieldName: 'code',
                        textFieldName: 'name',
                        isExpand: false,
                        enabledCompleteCheckbox:false,
                        checkbox: true,
                        async: false,
                        onCheck:function (data,target) {
                            var ma = [], ca = [], sjyArr = [];
                            me.selectData = this.getChecked();
                            me.$scBtn.removeClass('show');
                            me.$selectCon.hide();
                            me.queryCondition = me.getSelCon();
                            if (me.selectData.length > 0) {
                                for (var i = 0, len = me.selectData.length; i < len; i++) {
                                    switch (me.selectData[i].data.level) {
                                        case '1':
                                            ma.push(me.selectData[i].data.code);
                                            break;
                                        case '2':
                                            sjyArr.push(me.selectData[i].data);
                                            ca.push(me.selectData[i].data.code);
                                            break;
                                    }
                                }
                                me.loadGrid();
                                me.masterArr = JSON.stringify(ma);
                                me.childArr = JSON.stringify(ca);
                                me.reloadResourcesGrid({
                                    metaData: me.childArr,
                                    resourcesCode: me.masterArr,
                                    searchParams: me.queryCondition
                                });
                                //初始化
                                me.index = 0;
                                me.$selMore.html('');
                                me.GridCloumnNamesData = sjyArr;
                                me.setSearchData();
                            } else {
                                me.resetDate();
                            }
                        },
                        onSuccess: function (data) {
                            var detailModelList = data.detailModelList,
                                    dmList = [];
                            if (detailModelList) {
                                if (me.type == 0) {
                                    for(var i = 0; i < detailModelList.length; i++){
                                        if (detailModelList[i].level == 0) {
                                            defArr = detailModelList[i].baseInfo;
                                        } else {
                                            var rsResourceslist = detailModelList[i].metaDataList;
                                            detailModelList[i].children = rsResourceslist;
                                            dmList.push(detailModelList[i]);
                                        }
                                    }
                                } else {
                                    debugger
                                    for(var i = 0; i < detailModelList.length; i++){
                                        var childOne = detailModelList[i].child;
                                        detailModelList[i].children = childOne;
                                        for ( var j = 0; j < childOne.length; j++) {
                                            detailModelList[i].children[j].children = childOne[j].detailList;
                                        }
                                        dmList.push(detailModelList[i]);
                                    }
                                }
                                me.leftTree.setData(dmList);
                            } else {
                                $.Notice.error('暂无数据');
                            }
                        },

                    });
                },
                resetDate: function () {
                    this.$scBtn.removeClass('show');
                    this.$selectCon.hide();
                    this.index = 0;
                    this.$selMore.html('');
                    this.GridCloumnNamesData = [];
                    this.masterArr = '';
                    this.childArr = '';
//                                me.queryCondition = '';
                    this.selectData = [];
                    this.loadGrid();
                },
                //筛选存在数据字典中的字段
                setSearchData: function (d) {
                    var me = this,
                        data = me.GridCloumnNamesData;
                    if (data[me.index].dictCode && !Util.isStrEquals(data[me.index].dictCode, 0) && data[me.index].dictCode != '') {

                        me.dataModel.fetchRemote(pubInf.getRsDictEntryList, {
                            data: {dictId: data[me.index].dictCode},
                            type: 'GET',
                            async: false,
                            success: function (d) {
                                if (d.successFlg) {
                                    d.label = data[me.index].name;
                                    d.pCode = data[me.index].code;
                                    me.resetSelHtml(d);
                                }
                            }
                        });
                    }
                    me.index++;
                    if (me.index < me.GridCloumnNamesData.length) {
                        me.setSearchData();
                    }
                },
                resetSelHtml: function (d) {
                    var me = this,
                        htm = '';
                    htm = me.render(me.selTmp, d, function (d, $1) {
                        var obj = d.detailModelList || [],
                            str = '';
                        for (var i = 0, len = obj.length; i < len; i++) {
                            str += '<li class="con-item" data-code="' + obj[i].code + '">' + obj[i].name + '</li>';
                        }
                        d.content = str;
                    });
                    me.$selMore.append(htm);
                },
                loadGrid: function () {
                    var me = this;
                    var columnModel = new Array();
                    if (me.selectData.length > 0) {
                        for (var j = 0, len = defArr.length; j < len; j++) {
                            columnModel.push({display: defArr[j].name, name: defArr[j].code, width: 100});
                        }
                    }
                    //获取列名
                    for (var i = 0, len = me.selectData.length; i < len; i++) {
                        if (me.selectData[i].data.level == '2') {
                            columnModel.push({display: me.selectData[i].data.name, name: me.selectData[i].data.code, width: 100});
                        }
                    }
                    me.resourceInfoGrid = me.$divResourceInfoGrid.ligerGrid($.LigerGridEx.config({
                        url: conInf[me.type][1],
                        parms: {searchParams: '', resourcesCode: '', metaData: ''},
                        columns: columnModel,
                        checkbox: true,
                        onSelectRow:function () {
                            if(Util.isStrEquals(me.resourceInfoGrid.getSelectedRows().length,0)){
//                                self.$outSelExcelBtn.css('background','#B9C8D2');
                            }else{
//                                self.$outSelExcelBtn.css('background','#2D9BD2');
                            }
                        },
                        onUnSelectRow:function () {
                            if(Util.isStrEquals(me.resourceInfoGrid.getSelectedRows().length,0)){
//                                self.$outSelExcelBtn.css('background','#B9C8D2');
                            }else{
//                                self.$outSelExcelBtn.css('background','#2D9BD2');
                            }
                        },
                        onAfterShowData:function () {
//                            self.$outAllExcelBtn.css('background','#B9C8D2');
                            if (me.resourceInfoGrid.data.detailModelList.length > 0){
//                                self.$outAllExcelBtn.css('background','#2D9BD2');
                            }
                        }
                    }));
                },
                reloadResourcesGrid: function (searchParams) {
//                    reloadGrid.call(this, conInf[this.type][1], searchParams);
                    this.resourceInfoGrid.setOptions({parms: searchParams});
                    this.resourceInfoGrid.loadData(true);
                },
                bindEvent: function () {
                    var me = this;
                    //切换数据
                    me.$changBtns.on('click', function () {
                        me.resetDate();
                        var $that = $(this),
                            index = $that.index();
                        if (me.type == index) {
                            return;
                        }
                        $that.addClass('active').siblings().removeClass('active');
                        me.type = index;
                        me.loadTree();
                        console.log(index);
                    });
                    //展开\收起筛选条件
                    me.$scBtn.on('click', function () {
                        var $that = $(this),
                            isTrue = $that.hasClass('show');
                        if (isTrue) {
                            $that.removeClass('show');
                            me.$selectCon.slideUp();
                        } else {
                            $that.addClass('show');
                            me.$selectCon.slideDown();
                            me.calLen();
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
                            console.log(codeArr.join(','));
                            $that.removeClass('active');
                        } else {
                            codeArr.push(code);
                            $parent.attr('data-code-list', codeArr.join(','));
                            console.log(codeArr.join(','));
                            $that.addClass('active');
                        }
                    });
                    //查询
                    me.$queryCon.on('click', function () {
                        me.queryCondition = me.getSelCon();
                        me.reloadResourcesGrid({
                            metaData: me.childArr,
                            resourcesCode: me.masterArr,
                            searchParams: me.queryCondition
                        });
                    });
                    //导出excel
                    me.$outExc.on('click', function () {
                        var rowData = me.resourceInfoGrid.data.detailModelList;
                        me.outExcel(rowData, me.resourceInfoGrid.currentData.totalPage * me.resourceInfoGrid.currentData.pageSize);
                    });
                    me.$genView.on('click', function () {
                        var sd = me.selectData,
                            qc = me.queryCondition;
                        if (sd.length <= 0) {
                            $.Notice.error('请先选择数据');
                            return;
                        }
                        $.ligerDialog.confirm("确认是否生成视图？", function (yes) {
                            var md = [];
                            if(yes){
                                if (sd.length > 0) {
                                    for (var i = 0, len = sd.length; i < len; i++) {
                                        var data = sd[i].data
                                        if (data.level == 2) {
                                            md.push({
                                                resourcesId: '',
                                                metadataId: data.code,
                                                groupType: data.groupType,
                                                groupData: data.groupData,
                                                description: data.description
                                            });
                                        }
                                    }

                                    var wait = $.Notice.waitting("请稍后...");
                                    rsInfoDialog = $.ligerDialog.open({
                                        height:550,
                                        width:500,
                                        title:'新增资源',
                                        url:'${contextRoot}/resourceBrowse/infoInitial',
                                        urlParms:{
                                            queryCondition: qc,
                                            type: me.type,
                                            metadatas: JSON.stringify(md)
                                        },
                                        load:true,
                                        show:false,
                                        isHidden:false,
                                        onLoaded:function(){
                                            wait.close(),
                                                    rsInfoDialog.show()
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
                    for (var i = 0, len = $selItems.length; i < len; i++) {
                        var pCode = $selItems.eq(i).attr('data-parent-code'),
                                codeList = $selItems.eq(i).attr('data-code-list');
                        if (codeList) {
                            var codeArr = codeList.length > 0 ? codeList.split(',') : [];
                            if (codeArr.length > 0) {
                                for (var j = 0, leng = codeArr.length; j < leng; j++) {
                                    var values = {andOr: '', condition: '', field: '', value: ''};
                                    values.andOr = 'Or';
                                    values.condition = '=';
                                    values.field = pCode;
                                    values.value = codeArr[j];
                                    jsonData.push(values);
                                }
                            }
                        } else {
                            var sT = $selItems.eq(i).attr('data-start-date'),
                                    eT = $selItems.eq(i).attr('data-end-date'),
                                    aArr = [];
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
                    console.log(JSON.stringify(jsonData));
                    return JSON.stringify(jsonData);
                },
                //导出excel
                outExcel: function (rowData, size) {
                    if (rowData.length <= 0) {
                        $.Notice.error('请先选择数据');
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
                    debugger
                    window.open("${contextRoot}/resourceIntegrated/outFileExcel?size=" + size + "&resourcesCode=" + this.masterArr + "&searchParams=" + this.queryCondition + "&metaData=" + JSON.stringify(metaData), "资源数据导出");
                },
                calLen: function () {
                    var $selItems = $('.select-con').find('.sel-item');
                    _.each($selItems, function (item, k) {
                        var $conList = $(item).find('.con-list'),
                            ciLen = $conList.find('.con-item').length,
                            $scBtn = $conList.next().find('.sc-btn'),
                            cW = $conList.width(),
                            ciW = 138;
//                        $conList.mCustomScrollbar({
//                            axis: "y"
//                        });
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
            win.closeRsInfoDialog = function (callback) {
                rsInfoDialog.close();
            };
        });

    })(jQuery, window);
</script>