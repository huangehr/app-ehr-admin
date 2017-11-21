<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/plugin/underscore/underscore.js"></script>

<script type="text/javascript">
    (function ($, win, u) {
        var waittingDialog = $.ligerDialog.waitting('正在加载...');
        var resourceData = ${dataModel};
        $(function () {
            var Util = $.Util;
//            接口
            var inf = {
                searchResourceList: "${contextRoot}/resourceBrowse/searchResourceList",//获取资源分类
                resources: "${contextRoot}/resource/resourceManage/resources",//获取资源名称
                getDistrictByUserId :"${contextRoot}/user/getDistrictByUserId",//获取地区
                getOrgByUserId: "${contextRoot}/user/getOrgByUserId",//获取医疗机构
                searchResourceData: "${contextRoot}/resourceBrowse/searchResourceData",//获取档案数据
                searchQuotaResourceData: "${contextRoot}/resourceBrowse/searchQuotaResourceData",//获取指标统计
                searchDictEntryList :"${contextRoot}/resourceView/searchDictEntryList",
                getGridCloumnNames: "${contextRoot}/resourceView/getGridCloumnNames",//获取表头
                getRsDictEntryList: "${contextRoot}/resourceBrowse/getRsDictEntryList",
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


            var rv = {
                //form
                $spResourceSub: $('#sp_resourceSub'),//资源分类
                $spResourceName: $('#sp_resourceName'),//资源名称
                $resourceSub: $('#sp_resourceSub'),
                $resourceName: $('#sp_resourceName'),
                $SearchBtn: $("#div_search_btn"),
                $resetBtn: $("#div_reset_btn"),
                $saveSearchBtn: $('#save_search_btn'),
                $resourceBrowse: $(".div-resource-browse"),
                $newSearch: $("#div_search_data_role_form"),
                $resourceInfoGrid: $("#div_resource_info_grid"),
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
                //导出数据
                $outSelExcelBtn: $("#div_out_sel_excel_btn"),
                $outAllExcelBtn: $("#div_out_all_excel_btn"),
                //表格
                $infoGrid: $('#div_resource_info_grid'),
                InfoGrid: null,
                //ajax初始化
                dataModel: $.DataModel.init(),
                GridCloumnNamesData: [],
                index: 0,
                isTrue: false,
                resourcesCode: resourceData.resourceCode,
                resourceName: resourceData.resourceName,
                resourceSub: resourceData.resourceSub,
                type: resourceData.dataSource,//1：档案数据；2：指标统计
                resourcesId: resourceData.resourceId,
                queryCondition: '',
                windowHeight: $(window).height(),
                searcHheight: $(".div-search-height").height(),
                params: {},
                getDataUrl: '',
                //初始化
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
                    me.$spResourceSub.html(me.resourceSub);
                    me.$spResourceName.html(me.resourceName);
                    if (me.type == '1') {
                        me.getDataUrl = inf.searchResourceData;
                    } else {
                        me.getDataUrl = inf.searchQuotaResourceData;
                    }
                    me.getParams();
                    me.initGrid()
                    if(me.InfoGrid){
                        if (me.type == '1') {
                            me.reloadResourcesGrid(me.params);
                            me.initDDL();
                        } else {
                            me.initZBGrid();
                        }
                    }
                    me.initForm();
                    me.bindEvents();
                },
                initForm: function () {
                    var me = this;
                    //还没选择时给默认值保持样式不变
                    me.$resourceBrowse.mCustomScrollbar({
                        axis: "y"
                    });
                    me.loadSelData();
                    //期间
                    me.$inpStarTime.ligerDateEditor({
                        format: 'yyyy-MM-dd'
                    });
                    me.$inpEndTime.ligerDateEditor({
                        format: 'yyyy-MM-dd'
                    });
                    me.$inpStarTime.attr('readonly',true);
                    me.$inpEndTime.attr('readonly',true);
                },
                initValue: function () {
                    this.index = 0;
                    this.$addSearchDom.html('');
                    this.GridCloumnNamesData = [];
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
                                    id: d[i].name
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
                        }
                    });
                },
                formatData: function (date) {
                    var thisDate = new Date(date);
                    var year = thisDate.getFullYear();
                    var month = this.resetVal(thisDate.getMonth() + 1);
                    var da = this.resetVal(thisDate.getDate());
                    var hours = this.resetVal(thisDate.getHours());
                    var minutes = this.resetVal(thisDate.getMinutes());
                    var seconds = this.resetVal(thisDate.getSeconds());
                    return year + '-' + month + '-' + da + ' ' + hours + ':' + minutes + ':' + seconds;
                },
                resetVal: function (val) {
                    return val < 9 ? '0' + val : val;
                },
                //初始化表格
                initGrid: function () {
                    var me = this;
                    var columnModel = new Array();
                    //获取列名
                    if (!Util.isStrEmpty(me.resourcesCode)) {
                        me.dataModel.fetchRemote( inf.getGridCloumnNames, {
                            data: {
                                dictId: me.resourcesCode
                            },
                            async: false,
                            success: function (data) {
                                waittingDialog.close();
                                //添加档案数据基本信息表头
                                if (data.length > 0) {
                                    for (var j = 0, len = defauleColumnModel.length; j < len; j++) {
                                        columnModel.push({
                                            display: defauleColumnModel[j].name,
                                            name: defauleColumnModel[j].key,
                                            width: 100,
                                            render: function (row, key, val, rowData) {
                                                if (rowData.columnname == 'event_date') {
                                                    return me.formatData(val);
                                                }
                                                if (rowData.columnname == 'event_type') {
                                                    if (val == '0') {
                                                        return '门诊';
                                                    }
                                                    if (val == '1') {
                                                        return '住院';
                                                    }
                                                }
                                                return val;
                                            }
                                        });
                                    }
                                }
                                for (var i = 0; i < data.length; i++) {
                                    columnModel.push({display: data[i].value, name: data[i].code, width: 100});
                                }
                                me.InfoGrid = me.$infoGrid.ligerGrid($.LigerGridEx.config({
                                    url: me.getDataUrl,
                                    parms: me.params,
                                    columns: columnModel,
                                    height: me.windowHeight - (me.searcHheight + 235),
                                    checkbox: true,
                                    onSelectRow:function () {
                                        if(Util.isStrEquals(me.InfoGrid.getSelectedRows().length,0)){
                                            me.$outSelExcelBtn.css('background','#B9C8D2');
                                        }else{
                                            me.$outSelExcelBtn.css('background','#2D9BD2');
                                        }
                                    },
                                    onUnSelectRow:function () {
                                        if(Util.isStrEquals(me.InfoGrid.getSelectedRows().length,0)){
                                            me.$outSelExcelBtn.css('background','#B9C8D2');
                                        }else{
                                            me.$outSelExcelBtn.css('background','#2D9BD2');
                                        }
                                    },
                                    onAfterShowData:function () {
                                        me.$outAllExcelBtn.css('background','#B9C8D2');
                                        if (me.InfoGrid.data.detailModelList.length > 0){
                                            me.$outAllExcelBtn.css('background','#2D9BD2');
                                        }
                                    }
                                }));
                            }
                        });
                    }
                },
                initZBGrid: function () {
                    var me = this;
                    var columnModel = new Array();
                    //获取列名
                    if (!Util.isStrEmpty(me.resourcesId)) {
                        me.dataModel.fetchRemote( me.getDataUrl, {
                            data: {
                                page: 1,
                                rows: 15,
                                searchParams: me.params.searchParams,
                                resourcesId: me.params.resourcesId
                            },
                            async: false,
                            type: 'GET',
                            success: function (data) {
                                waittingDialog.close();
                                var dataArr = data.detailModelList,
                                        titArr = data.obj;
                                for (var i = 0; i < titArr.length; i++) {
                                    columnModel.push({display: titArr[i].name, name: titArr[i].key, width: 100});
                                }
                                me.InfoGrid = me.$infoGrid.ligerGrid($.LigerGridEx.config({
                                    url: me.getDataUrl,
                                    parms: {
//                                        page: 1,
//                                        rows: 15,
                                        searchParams: me.params.searchParams,
                                        resourcesId: me.params.resourcesId
                                    },
                                    columns: columnModel,
                                    height: me.windowHeight - (me.searcHheight + 235),
                                    checkbox: true
                                }));
                            }
                        });
                    }
                },
                //地区
                loadDistrictData: function () {
                    return this.loadPromise(inf.getDistrictByUserId,{});
                },
                //医疗机构
                loadOrgData: function () {
                    return this.loadPromise(inf.getOrgByUserId, {});
                },
                //下拉框列表项初始化
                initDDL: function () {
                    var me = this;
                    //初始化
                    me.index = 0;
                    me.$addSearchDom.html('');
                    $.ajax({
                        url: inf.getGridCloumnNames,
                        data: {
                            dictId: me.resourcesCode
                        },
                        type: 'GET',
                        dataType: 'json',
                        success: function (data) {
                            if (data.length > 0) {
                                me.GridCloumnNamesData = data;
                                me.setSearchData();
                            }
                        }
                    });
                },
                reloadResourcesGrid: function (searchParams) {
                    this.InfoGrid.setOptions({parms: searchParams});
                    this.InfoGrid.loadData(true);
                },
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
                                if ($(resetInp[i]).attr('id') == 'inpStarTime') {
                                    values.andOr = 'AND';
                                    values.condition = '>';
                                }
                                if ($(resetInp[i]).attr('id') == 'inpEndTime') {
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
                    return jsonData;
                },
                //筛选存在数据字典中的字段
                setSearchData: function () {
                    var me = this,
                            data = me.GridCloumnNamesData;
                    if (data[me.index].dict && !Util.isStrEquals(data[me.index].dict, 0) && data[me.index].dict != '') {
                        var $div = $('<div class="f-fl f-mr10 f-ml10 f-mt6">'),
                                html = ['<label class="inp-label" for="inp' + me.index + '">' + data[me.index].value + ': </label>',
                                    '<div class="inp-text">',
                                    '<input type="text" id="inp' + me.index + '" data-code="' + data[me.index].code + '" data-type="select" data-attr-scan="field" style="width: 238px" class="f-pr0 f-ml10 inp-reset div-table-colums "/>',
                                    '</div>'].join('');
                        $div.append(html);
                        var inp = $div.find('input').ligerComboBox({
                            url: inf.getRsDictEntryList,
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
                    me.index++;
                    if (me.index < me.GridCloumnNamesData.length) {
                        me.setSearchData();
                    }
                },
                resetSearch: function () {
                    var pModel = this.$newSearch.children('div');
                    var resetInp = $(pModel.find('.inp-reset'));
                    for (var i = 1; i < resetInp.length; i++) {
                        $(resetInp[i]).liger().setValue('');
                    }
                },
                getParams: function () {
                    var me = this;
                    if (me.type == '1') {
                        me.params = {
                            searchParams: me.queryCondition,
                            resourcesCode: me.resourcesCode
                        };
                    } else {
                        me.params = {
                            searchParams: me.queryCondition,
                            resourcesId: me.resourcesId
                        };
                    }
                },
                bindEvents: function () {
                    var me = this;
                    //检索
                    me.$SearchBtn.click(function (e) {
                        e.stopPropagation();
                        e.preventDefault();
                        me.index = 0;
                        me.queryCondition = me.getQuerySearchData();
                        me.getParams();
                        me.reloadResourcesGrid(me.params);
                        me.$popMain.css('display', 'none');
                    });
                    //更新搜索条件
                    me.$saveSearchBtn.on('click', function () {
                        var qc = {
                            resourceId: me.resourcesId,
                            queryCondition: JSON.parse(me.getQuerySearchData())
                        };
                        var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
                        me.dataModel.fetchRemote(inf.updateResourceQuery, {
                            data: {
                                dataJson: JSON.stringify(qc)
                            },
                            type: 'POST',
                            success: function (data) {
                                waittingDialog.close();
                                me.$popMain.css('display', 'none');
                                if (data.successFlg) {
                                    $.Notice.success('更新成功');
                                } else {
                                    $.Notice.error('更新失败');
                                }
                            }
                        });
                    });

                    me.$ddSeach.on('click', function (e) {
                        e.stopPropagation();
                        if (me.$resourceInfoGrid.html() == '') {
                            return;
                        }
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
                    //导出选择结果
                    me.$outSelExcelBtn.click(function () {
                        var jsonDatas = [];
                        var rowData = resourceInfoGrid.getSelectedRows();
                        $.each(rowData,function (key,value) {
                            var jsonParam = {andOr: "OR", field: "rowkey", condition: "=", value: ""};
                            jsonParam.value = value.rowkey;
                            jsonDatas.push(jsonParam);
                        });
                        me.outExcel(rowData, rowData.length,JSON.stringify(jsonDatas));
                    });
                    //导出全部结果
                    me.$outAllExcelBtn.click(function () {
                        if (me.type == '1') {
                            var rowData = resourceInfoGrid.data.detailModelList;
                            me.outExcel(rowData, resourceInfoGrid.currentData.totalPage * resourceInfoGrid.currentData.pageSize,RSsearchParams);
                        } else {
                            me.outZBWxcel();
                        }
                    });

                    //返回资源注册页面
                    $('#btn_back').click(function(){
                        $('#contentPage').empty();
                        $('#contentPage').load('${contextRoot}/resource/resourceManage/initial');
                    });
                },
                //导出指标统计excel
                outZBWxcel: function () {
                    window.open("${contextRoot}/resourceBrowse/outQuotaExcel?resourcesId=" + this.resourcesId + "&searchParams=" + '{}', "指标统计导出");
                },
                outExcel: function (rowData, size,RSsearchParams) {
                    if (rowData.length <= 0) {
                        $.Notice.error('请先选择数据');
                        return;
                    }
                    var columnNames = resourceInfoGrid.columns;
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
                    window.open("${contextRoot}/resourceBrowse/outExcel?size=" + size + "&resourceCode=" + resourcesCode + "&searchParams=" + RSsearchParams, "视图数据导出");
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
            rv.init();
        });
    })(jQuery, window);
</script>








<%--<script>--%>
    <%--(function ($, win) {--%>
        <%--$(function () {--%>
            <%--/* ************************** 变量定义 ******************************** */--%>
            <%--// 通用工具类库--%>
            <%--var Util = $.Util;--%>
            <%--// 页面表格条件部模块--%>
            <%--var retrieve = null;--%>
            <%--// 页面主模块，对应于用户信息表区域--%>
            <%--var resourceBrowseMaster = null;--%>
            <%--var height = $(window).height();--%>
            <%--var defaultWidth = $("#div-f-w1").width();--%>
            <%--var defaultWidthAndOr = $("#div-f-w2").width();--%>
            <%--var windowHeight = $(window).height();--%>
            <%--var searcHheight = $(".div-search-height").height();--%>
            <%--//检索模块初始化--%>
            <%--var resourceData = ${dataModel};--%>
            <%--var resourcesCode = resourceData.resourceCode;--%>
            <%--var resourcesName = resourceData.resourceName;--%>
            <%--var resourcesSub = resourceData.resourceSub;--%>
            <%--var dataSource = resourceData.dataSource;--%>
            <%--var jsonData = new Array();--%>
<%--debugger--%>
            <%--var paramModel = null;--%>
            <%--var resourceInfoGrid = null;--%>
            <%--var resourceCategoryName = "";--%>
            <%--var inpTypes = "";--%>
            <%--var conditionBo = false;--%>
            <%--var RSsearchParams = null;--%>

            <%--var dataModel = $.DataModel.init();--%>

            <%--/* *************************** 函数定义 ******************************* */--%>
            <%--/**--%>
             <%--* 页面初始化。--%>
             <%--* @type {Function}--%>
             <%--*/--%>
            <%--function pageInit() {--%>
                <%--$("#sp_resourceSub").html(resourcesSub);--%>
                <%--$("#sp_resourceName").html(resourcesName);--%>
                <%--retrieve.init();--%>
                <%--resourceBrowseMaster.bindEvents();--%>
                <%--resourceBrowseMaster.init();--%>

                <%--Date.prototype.format = function (fmt) {--%>
                    <%--var o = {--%>
                        <%--"M+": this.getMonth() + 1, //月份--%>
                        <%--"d+": this.getDate(), //日--%>
                        <%--"H+": this.getHours(), //小时--%>
                        <%--"m+": this.getMinutes(), //分--%>
                        <%--"s+": this.getSeconds(), //秒--%>
                        <%--"q+": Math.floor((this.getMonth() + 3) / 3), //季度--%>
                        <%--"S": this.getMilliseconds() //毫秒--%>
                    <%--};--%>
                    <%--if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));--%>
                    <%--for (var k in o)--%>
                        <%--if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));--%>
                    <%--return fmt;--%>
                <%--}--%>
            <%--}--%>

            <%--function reloadGrid(url, ps) {--%>
                <%--resourceInfoGrid.setOptions({parms: ps});--%>
                <%--resourceInfoGrid.loadData(true);--%>
            <%--}--%>
            <%--/* *************************** 检索模块初始化 ***************************** */--%>
            <%--paramModel = {--%>
                <%--url: ["${contextRoot}/resourceView/searchDictEntryList", '${contextRoot}/resourceView/getGridCloumnNames', "${contextRoot}/resourceView/searchDictEntryList", "${contextRoot}/resourceBrowse/getRsDictEntryList"],--%>
                <%--dictId: ['andOr', resourcesCode, '34', '']--%>
            <%--};--%>
            <%--/* *************************** 检索模块初始化结束 ***************************** */--%>

            <%--/* *************************** 模块初始化 ***************************** */--%>
            <%--retrieve = {--%>
                <%--$resourceBrowseTree: $("#div_resource_browse_tree"),--%>
                <%--$defaultCondition: $("#inp_default_condition"),--%>
                <%--$logicalRelationship: $("#inp_logical_relationship"),--%>
                <%--$defualtParam: $(".inp_defualt_param"),--%>
                <%--$resourceBrowseMsg: $("#div_resource_browse_msg"),--%>
                <%--$searchModel: $(".div_search_model"),--%>
                <%--$resourceInfoGrid: $("#div_resource_info_grid"),--%>
                <%--$newSearch: $("#div_search_data_role_form"),--%>
                <%--$newSearchBtn: $("#sp_new_search_btn"),--%>
                <%--$SearchBtn: $("#div_search_btn"),--%>
                <%--$delBtn: $(".sp-del-btn"),--%>
                <%--$resetBtn: $("#div_reset_btn"),--%>
                <%--$outSelExcelBtn: $("#div_out_sel_excel_btn"),--%>
                <%--$outAllExcelBtn: $("#div_out_all_excel_btn"),--%>
                <%--$resourceBrowse: $(".div-resource-browse"),--%>

                <%--$ddSeach: $('#ddSeach'),--%>
                <%--$sjIcon: $('.sj-icon'),--%>
                <%--$popSCon: $('.pop-s-con'),--%>
                <%--$popMain: $('.pop-main'),--%>

                <%--$inpRegion: $('#inpRegion'),--%>
                <%--$inpMechanism: $('#inpMechanism'),--%>
                <%--$inpStarTime: $('#inpStarTime'),--%>
                <%--$inpEndTime: $('#inpEndTime'),--%>
                <%--$addSearchDom: $('#addSearchDom'),--%>
                <%--GridCloumnNamesData: [],--%>
                <%--index: 0,--%>

                <%--init: function () {--%>
                    <%--var self = this;--%>
                    <%--self.$resourceBrowseMsg.height(windowHeight - 185);--%>
                    <%--self.$resourceBrowse.mCustomScrollbar({--%>
                        <%--axis: "y"--%>
                    <%--});--%>

                    <%--$($("#div_resource_browse_msg").children('div').children('div')[0]).css('margin-right','0');--%>
                    <%--self.initDDL();--%>
                    <%--//地区--%>
                    <%--var regions = [];--%>
                    <%--$.ajax({--%>
                        <%--url: '${contextRoot}/user/getDistrictByUserId',--%>
                        <%--data: {},--%>
                        <%--type: 'GET',--%>
                        <%--dataType: 'json',--%>
                        <%--success: function (data) {--%>
                            <%--if (data.successFlg == true) {--%>
                                <%--var d = data.obj;--%>
                                <%--for (var i = 0, len = d.length; i < len; i++) {--%>
                                    <%--regions.push({--%>
                                        <%--text: d[i].name,--%>
                                        <%--id: d[i].name--%>
                                    <%--});--%>
                                <%--}--%>
                                <%--self.$inpRegion.ligerComboBox({--%>
                                    <%--isShowCheckBox: true,--%>
                                    <%--isMultiSelect: true,--%>
                                    <%--width: '240',--%>
                                    <%--data: regions,--%>
                                    <%--valueFieldID: 'inpRegions'--%>
                                <%--});--%>
                            <%--}--%>
                        <%--}--%>
                    <%--});--%>
                    <%--//医疗机构--%>
                    <%--var mechanisms = [];--%>

                    <%--$.ajax({--%>
                        <%--url: '${contextRoot}/user/getOrgByUserId',--%>
                        <%--data: {},--%>
                        <%--type: 'GET',--%>
                        <%--dataType: 'json',--%>
                        <%--success: function (data) {--%>
                            <%--if (data.successFlg) {--%>
                                <%--var d = data.obj;--%>
                                <%--for (var i = 0, len = d.length; i < len; i++) {--%>
                                    <%--mechanisms.push({--%>
                                        <%--text: d[i].fullName,--%>
                                        <%--id: d[i].fullName--%>
                                    <%--});--%>
                                <%--}--%>
                                <%--self.$inpMechanism.ligerComboBox({--%>
                                    <%--isShowCheckBox: true,--%>
                                    <%--width: '240',--%>
                                    <%--isMultiSelect: true,--%>
                                    <%--data: mechanisms,--%>
                                    <%--valueFieldID: 'mechanism'--%>
                                <%--});--%>
                            <%--}--%>
                        <%--}--%>
                    <%--});--%>
                    <%--//期间--%>
                    <%--self.$inpStarTime.ligerDateEditor({--%>
                        <%--format: 'yyyy-MM-dd'--%>
                    <%--});--%>
                    <%--self.$inpEndTime.ligerDateEditor({--%>
                        <%--format: 'yyyy-MM-dd'--%>
                    <%--});--%>
                    <%--self.$inpStarTime.attr('readonly',true);--%>
                    <%--self.$inpEndTime.attr('readonly',true);--%>

                <%--},--%>
                <%--//下拉框列表项初始化--%>
                <%--initDDL: function () {--%>
                    <%--var me = this;--%>
                    <%--debugger--%>
                    <%--$.ajax({--%>
                        <%--url: paramModel.url[1],--%>
                        <%--data: {--%>
                            <%--dictId: paramModel.dictId[1]--%>
                        <%--},--%>
                        <%--type: 'GET',--%>
                        <%--dataType: 'json',--%>
                        <%--success: function (data) {--%>
                            <%--if (data.length > 0) {--%>
                                <%--me.GridCloumnNamesData = data;--%>
                                <%--me.setSearchData();--%>
                            <%--}--%>
                        <%--}--%>
                    <%--});--%>
                <%--},--%>
                <%--//筛选存在数据字典中的字段--%>
                <%--setSearchData: function () {--%>
                    <%--var me = this,--%>
                            <%--data = me.GridCloumnNamesData;--%>
                    <%--if (data[me.index].dict && !Util.isStrEquals(data[me.index].dict, 0) && data[me.index].dict != '') {--%>
                        <%--var $div = $('<div class="f-fl f-mr10 f-ml10 f-mt6">'),--%>
                                <%--html = ['<label class="inp-label" for="inp' + me.index + '">' + data[me.index].value + ': </label>',--%>
                                    <%--'<div class="inp-text">',--%>
                                    <%--'<input type="text" id="inp' + me.index + '" data-code="' + data[me.index].code + '" data-type="select" data-attr-scan="field" style="width: 238px" class="f-pr0 f-ml10 inp-reset div-table-colums "/>',--%>
                                    <%--'</div>'].join('');--%>
                        <%--$div.append(html);--%>
                        <%--var inp = $div.find('input').ligerComboBox({--%>
                            <%--url: paramModel.url[3],--%>
                            <%--parms: {dictId: data[me.index].dict},--%>
                            <%--valueField: 'code',--%>
                            <%--textField: 'name',--%>
                            <%--width: '240',--%>
                            <%--dataParmName: 'detailModelList',--%>
                            <%--isShowCheckBox: true,--%>
                            <%--isMultiSelect: true--%>
                        <%--});--%>
                        <%--me.$addSearchDom.append($div);--%>
                    <%--}--%>
                    <%--me.index++;--%>
                    <%--if (me.index < me.GridCloumnNamesData.length) {--%>
                        <%--me.setSearchData();--%>
                    <%--}--%>
                <%--}--%>
            <%--};--%>
            <%--resourceBrowseMaster = {--%>
                <%--init: function () {--%>
                    <%--var self = retrieve;--%>
                    <%--var columnModel = new Array(),--%>
                        <%--//基本信息--%>
                        <%--defArr = [--%>
                                  <%--{"key": 'patient_name', "name": "病人姓名"},--%>
                                  <%--{"key": 'event_type', "name": "就诊类型"},--%>
                                  <%--{"key": 'org_name', "name": "机构名称"},--%>
                                  <%--{"key": 'org_code', "name": "机构编号"},--%>
                                  <%--{"key": 'event_date', "name": "时间"},--%>
                                  <%--{"key": 'demographic_id', "name": "病人身份证号码"}--%>
                        <%--];--%>
                    <%--//获取列名--%>
                    <%--if (!Util.isStrEmpty(resourcesCode)) {--%>
                        <%--dataModel.fetchRemote("${contextRoot}/resourceView/getGridCloumnNames", {--%>
                            <%--data: {--%>
                                <%--dictId: resourcesCode--%>
                            <%--},--%>
                            <%--success: function (data) {--%>
                                <%--if (data.length > 0) {--%>
                                    <%--for (var j = 0, len = defArr.length; j < len; j++) {--%>
                                        <%--columnModel.push({display: defArr[j].name, name: defArr[j].key, width: 100});--%>
                                    <%--}--%>
                                <%--}--%>
                                <%--for (var i = 0; i < data.length; i++) {--%>
                                    <%--columnModel.push({display: data[i].value, name: data[i].code, width: 100});--%>
                                <%--}--%>
                                <%--resourceInfoGrid = self.$resourceInfoGrid.ligerGrid($.LigerGridEx.config({--%>
                                    <%--url: '${contextRoot}/resourceBrowse/searchResourceData',--%>
                                    <%--parms: {searchParams: '', resourcesCode: resourcesCode},--%>
                                    <%--columns: columnModel,--%>
                                    <%--height: windowHeight - (searcHheight + 235),--%>
                                    <%--checkbox: true,--%>
                                    <%--onSelectRow:function () {--%>
                                        <%--if(Util.isStrEquals(resourceInfoGrid.getSelectedRows().length,0)){--%>
                                            <%--self.$outSelExcelBtn.css('background','#B9C8D2');--%>
                                        <%--}else{--%>
                                            <%--self.$outSelExcelBtn.css('background','#2D9BD2');--%>
                                        <%--}--%>
                                    <%--},--%>
                                    <%--onUnSelectRow:function () {--%>
                                        <%--if(Util.isStrEquals(resourceInfoGrid.getSelectedRows().length,0)){--%>
                                            <%--self.$outSelExcelBtn.css('background','#B9C8D2');--%>
                                        <%--}else{--%>
                                            <%--self.$outSelExcelBtn.css('background','#2D9BD2');--%>
                                        <%--}--%>
                                    <%--},--%>
                                    <%--onAfterShowData:function () {--%>
                                        <%--self.$outAllExcelBtn.css('background','#B9C8D2');--%>
                                        <%--if (resourceInfoGrid.data.detailModelList.length > 0){--%>
                                            <%--self.$outAllExcelBtn.css('background','#2D9BD2');--%>
                                        <%--}--%>
                                    <%--}--%>
                                <%--}));--%>
                            <%--}--%>
                        <%--});--%>
                    <%--}--%>
                <%--},--%>
                <%--reloadResourcesGrid: function (searchParams) {--%>
                    <%--reloadGrid.call(this, '${contextRoot}/resourceView/searchResourceData', searchParams);--%>
                <%--},--%>
                <%--getQuerySearchData: function () {--%>
                    <%--var self = retrieve;--%>
                    <%--var pModel = self.$newSearch.children('div'),--%>
                            <%--jsonData = [];--%>
                    <%--var resetInp = $(pModel.find('.inp-reset'));--%>
                    <%--for (var i = 0; i < resetInp.length; i++) {--%>
                        <%--var code = $(resetInp[i]).attr('data-code'),--%>
                                <%--value = $(resetInp[i]).liger().getValue(),--%>
                                <%--valArr = [];--%>
                        <%--if (typeof value != 'string' && value instanceof Date) {--%>
                            <%--value = value.format('yyyy-MM-dd') + 'T00:00:00Z';--%>
                        <%--}--%>
                        <%--valArr = value ? value.split(';') : [];--%>
                        <%--for (var j = 0, len = valArr.length; j < len; j++) {--%>
                            <%--var values = {andOr: '', condition: '', field: '', value: ''};--%>
                            <%--values.field = code;--%>
                            <%--if (valArr[j] && valArr[j] != '') {--%>
                                <%--values.andOr = 'OR';--%>
                                <%--values.condition = '=';--%>
                                <%--if ($(resetInp[i]).attr('id') == 'inpStarTime') {--%>
                                    <%--values.andOr = 'AND';--%>
                                    <%--values.condition = '>';--%>
                                <%--}--%>
                                <%--if ($(resetInp[i]).attr('id') == 'inpEndTime') {--%>
                                    <%--values.andOr = 'AND';--%>
                                    <%--values.condition = '<';--%>
                                <%--}--%>
                                <%--values.value = valArr[j];--%>
                                <%--jsonData.push(values);--%>
                            <%--}--%>
                        <%--}--%>
                    <%--}--%>
                    <%--for (var j = 0; j < jsonData.length; j++) {--%>
                        <%--if (Util.isStrEmpty(jsonData[j].value) || Util.isStrEmpty(jsonData[j].field)) {--%>
                            <%--jsonData.splice(j, 1);--%>
                            <%--j--;--%>
                        <%--}--%>
                    <%--}--%>
                    <%--jsonData = RSsearchParams = Util.isStrEquals(jsonData.length, 0) ? "" : JSON.stringify(jsonData);--%>
                    <%--return jsonData;--%>
                <%--},--%>

                <%--bindEvents: function () {--%>
                    <%--var self = retrieve;--%>
                    <%--var searchBo = false;--%>

                    <%--//返回资源注册页面--%>
                    <%--$('#btn_back').click(function(){--%>
                        <%--$('#contentPage').empty();--%>
                        <%--$('#contentPage').load('${contextRoot}/resource/resourceManage/initial');--%>
                    <%--});--%>

                    <%--//检索--%>
                    <%--self.$SearchBtn.click(function (e) {--%>
                        <%--e.stopPropagation();--%>
                        <%--e.preventDefault();--%>
                        <%--debugger--%>
                        <%--self.index = 0;--%>
                        <%--var queryCondition = resourceBrowseMaster.getQuerySearchData();--%>
                        <%--resourceBrowseMaster.reloadResourcesGrid({--%>
                            <%--searchParams: queryCondition,--%>
                            <%--resourcesCode: resourcesCode--%>
                        <%--});--%>

                        <%--self.$popMain.css('display', 'none');--%>
                    <%--});--%>

                    <%--self.$ddSeach.on('click', function (e) {--%>
                        <%--e.stopPropagation();--%>
                        <%--if (self.$resourceInfoGrid.html() == '') {--%>
                            <%--return;--%>
                        <%--}--%>
                        <%--if ($(e.target).hasClass('l-table-checkbox') ||--%>
                                <%--$(e.target).hasClass('l-trigger-icon') ||--%>
                                <%--$(e.target).hasClass('l-box-dateeditor-absolute') ||--%>
                                <%--$(e.target).hasClass('l-text-field') ||--%>
                                <%--$(e.target).hasClass('j-text-wrapper') ||--%>
                                <%--$(e.target).hasClass('u-btn-large') ||--%>
                                <%--$(e.target).hasClass('inp-label') ||--%>
                                <%--$(e.target).hasClass('pop-s-con') ||--%>
                                <%--$(e.target).hasClass('f-mt6') ||--%>
                                <%--e.target.tagName.toLocaleLowerCase() == 'span' ||--%>
                                <%--$(e.target).hasClass('clear-s')) {--%>
                            <%--return;--%>
                        <%--}--%>
                        <%--if (self.$popMain.css('display') == 'none') {--%>
                            <%--self.$popMain.css('display', 'block');--%>
                            <%--self.$sjIcon.css('display', 'block');--%>
                            <%--self.$popSCon.css('display', 'block');--%>
                        <%--} else {--%>
                            <%--self.$popMain.css('display', 'none');--%>
                            <%--self.$sjIcon.css('display', 'none');--%>
                            <%--self.$popSCon.css('display', 'none');--%>
                        <%--}--%>
                    <%--});--%>
                    <%--//重置--%>
                    <%--self.$resetBtn.click(function () {--%>
                        <%--resetSearch();--%>
                    <%--});--%>
                    <%--//导出选择结果--%>
                    <%--self.$outSelExcelBtn.click(function () {--%>
                        <%--var jsonDatas = [];--%>
                        <%--var rowData = resourceInfoGrid.getSelectedRows();--%>
                        <%--$.each(rowData,function (key,value) {--%>
                            <%--var jsonParam = {andOr: "OR", field: "rowkey", condition: "=", value: ""};--%>
                            <%--jsonParam.value = value.rowkey;--%>
                            <%--jsonDatas.push(jsonParam);--%>
                        <%--});--%>
                        <%--outExcel(rowData, rowData.length,JSON.stringify(jsonDatas));--%>
                    <%--});--%>
                    <%--//导出全部结果--%>
                    <%--self.$outAllExcelBtn.click(function () {--%>
                        <%--var rowData = resourceInfoGrid.data.detailModelList;--%>
                        <%--outExcel(rowData, resourceInfoGrid.currentData.totalPage * resourceInfoGrid.currentData.pageSize,RSsearchParams);--%>
                    <%--});--%>
                    <%--function outExcel(rowData, size,RSsearchParams) {--%>
                        <%--if (rowData.length <= 0) {--%>
                            <%--$.Notice.error('请先选择数据');--%>
                            <%--return;--%>
                        <%--}--%>
                        <%--var columnNames = resourceInfoGrid.columns;--%>
                        <%--var codes = [];--%>
                        <%--var names = [];--%>
                        <%--var values = [];--%>
                        <%--var valueList = [];--%>
                        <%--for (var i = 0; i < rowData.length; i++) {--%>
                            <%--$.each(rowData[i], function (key, value) {--%>
                                <%--for (var j = 0; j < columnNames.length; j++) {--%>
                                    <%--var code = columnNames[j].columnname;--%>
                                    <%--if (Util.isStrEquals(code, key)) {--%>
                                        <%--if (Util.isStrEquals($.inArray(code, codes), -1)) {--%>
                                            <%--codes.push(code);--%>
                                            <%--names.push(columnNames[j].display);--%>
                                        <%--}--%>
                                    <%--}--%>
                                <%--}--%>
                                <%--if (!Util.isStrEquals($.inArray(key, codes), -1)) {--%>
                                    <%--values.push(value);--%>
                                <%--}--%>
                            <%--});--%>
                            <%--valueList.push(values);--%>
                            <%--values = [];--%>
                        <%--}--%>
                        <%--window.open("${contextRoot}/resourceBrowse/outExcel?size=" + size + "&resourcesCode=" + resourcesCode + "&searchParams=" + RSsearchParams, "资源数据导出");--%>
                    <%--}--%>
                <%--}--%>
            <%--};--%>
            <%--function resetSearch() {--%>
                <%--var pModel = retrieve.$newSearch.children('div');--%>
                <%--var resetInp = $(pModel.find('.inp-reset'));--%>
                <%--for (var i = 1; i < resetInp.length; i++) {--%>
                    <%--$(resetInp[i]).liger().setValue('');--%>
                <%--}--%>
            <%--}--%>
            <%--/* ************************* 模块初始化结束 ************************** */--%>

            <%--/* *************************** 页面初始化 **************************** */--%>
            <%--pageInit();--%>
            <%--/* ************************* 页面初始化结束 ************************** */--%>
        <%--});--%>
    <%--})(jQuery, window)--%>
<%--</script>--%>