<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            // 页面表格条件部模块
            var retrieve = null;
            // 页面主模块，对应于用户信息表区域
            var resourceBrowseMaster = null;
            var height = $(window).height();
            var defaultWidth = $("#div-f-w1").width();
            var defaultWidthAndOr = $("#div-f-w2").width();
            var windowHeight = $(window).height();
            var searcHheight = $(".div-search-height").height();
            //检索模块初始化
            var resourceData = {};
//            var resourcesCode = resourceData.resourceCode;
            var resourcesCode = null;
            var resourcesName = resourceData.resourceName;
            var resourcesSub = resourceData.resourceSub;
            var jsonData = new Array();
            // 查询参数
            var queryParam = {};

            var paramModel = null;
            var resourceInfoGrid = null;
            var resourceCategoryName = "";
            var inpTypes = "";
            var conditionBo = false;
            var RSsearchParams = null;

            var dataModel = $.DataModel.init();

            /* *************************** 函数定义 ******************************* */
            /**
             * 页面初始化。
             * @type {Function}
             */
            function pageInit() {
//                $("#sp_resourceSub").html(resourcesSub);
//                $("#sp_resourceName").html(resourcesName);
                retrieve.init();
                resourceBrowseMaster.bindEvents();
                resourceBrowseMaster.init();

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
                }
            }
            function reloadGrid(url, ps) {
                resourceInfoGrid.setOptions({parms: ps});
                resourceInfoGrid.loadData(true);
            }
            /* *************************** 检索模块初始化 ***************************** */
            paramModel = {
                url: ["${contextRoot}/resourceView/searchDictEntryList", '${contextRoot}/resourceView/getGridCloumnNames', "${contextRoot}/resourceView/searchDictEntryList", "${contextRoot}/resourceBrowse/getRsDictEntryList"],
                dictId: ['andOr', resourcesCode, '34', '']
            };
            /* *************************** 检索模块初始化结束 ***************************** */

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $resourceBrowseTree: $("#div_resource_browse_tree"),
                $defaultCondition: $("#inp_default_condition"),
                $logicalRelationship: $("#inp_logical_relationship"),
                $defualtParam: $(".inp_defualt_param"),
                $resourceBrowseMsg: $("#div_resource_browse_msg"),
                $searchModel: $(".div_search_model"),
                $resourceInfoGrid: $("#div_resource_info_grid"),
                $newSearch: $("#div_search_data_role_form"),
                $newSearchBtn: $("#sp_new_search_btn"),
                $SearchBtn: $("#div_search_btn"),
                $delBtn: $(".sp-del-btn"),
                $resetBtn: $("#div_reset_btn"),
                $outSelExcelBtn: $("#div_out_sel_excel_btn"),
                $outAllExcelBtn: $("#div_out_all_excel_btn"),
                $resourceBrowse: $(".div-resource-browse"),
                $resourceSub: $('#sp_resourceSub'),
                $resourceName: $('#sp_resourceName'),

                $ddSeach: $('#ddSeach'),
                $sjIcon: $('.sj-icon'),
                $popSCon: $('.pop-s-con'),
                $popMain: $('.pop-main'),

                $inpRegion: $('#inpRegion'),
                $inpMechanism: $('#inpMechanism'),
                $inpStarTime: $('#inpStarTime'),
                $inpEndTime: $('#inpEndTime'),
                $addSearchDom: $('#addSearchDom'),
                GridCloumnNamesData: [],
                index: 0,

                init: function () {
                    var self = this;
                    //还没选择时给默认值保持样式不变
                    self.$resourceName.ligerComboBox().setValue("");
                    self.$defaultCondition.ligerComboBox({
                        width: 186,
                        initValue:0
                    });
                    self.$logicalRelationship.ligerComboBox({
                        width: 93,
                        initValue:0
                    });
                    self.$defualtParam.ligerComboBox({
                        width: 186,
                        initValue:0
                    });

                    self.$resourceBrowseMsg.height(windowHeight - 185);
                    self.$resourceBrowse.mCustomScrollbar({
                        axis: "y"
                    });
                    self.$resourceSub.ligerComboBox({
                        url: '${contextRoot}/resourceBrowse/searchResourceList',
                        valueField: 'id',
                        textField: 'name',
                        dataParmName: 'detailModelList',
                        urlParms: {
                            page: 1,
                            rows: 1000
                        },
                        onSelected: function (value)
                        {
                            debugger
                            queryParam.resourceSub = this.selectedText;
                            self.$resourceName.ligerComboBox({
                                url: '${contextRoot}/resource/resourceManage/resources',
                                ajaxType: 'post',
                                valueField: 'id',
                                textField: 'name',
                                dataParmName: 'detailModelList',
                                urlParms: {
                                    categoryId: value,
                                    page: 1,
                                    rows: 100000
                                },
                                onSelected: function (value){
                                    queryParam.resourceId = value;
                                    queryParam.resourceName = this.selectedText;
                                    queryParam.resourceCode = this.selected.code;
                                    resourcesCode = queryParam.resourceCode;
                                    resourceBrowseMaster.init();
                                    console.log(resourceInfoGrid);
                                    if(resourceInfoGrid){
                                        resourceBrowseMaster.reloadResourcesGrid({
                                            searchParams: queryParam,
                                            resourcesCode: resourcesCode
                                        });
                                        paramModel.dictId[1] = resourcesCode;
                                        self.initDDL();
//                                        self.initDDL(1, 1, "", self.$defaultCondition, defaultWidth);
//                                        self.initDDL(2, 2, "", self.$logicalRelationship, defaultWidthAndOr);
//                                        self.initDDL('', '', "", self.$defualtParam, defaultWidth);
                                    }
                                }
                            });
                        }
                    });


                    $($("#div_resource_browse_msg").children('div').children('div')[0]).css('margin-right','0');
//                    self.initDDL(1, 1, "", self.$defaultCondition, defaultWidth);
//                    self.initDDL(2, 2, "", self.$logicalRelationship, defaultWidthAndOr);
//                    self.initDDL('', '', "", self.$defualtParam, defaultWidth);
                    //地区
                    var regions = [];
                    $.ajax({
                        url: '${contextRoot}/user/getDistrictByUserId',
                        data: {},
                        type: 'GET',
                        dataType: 'json',
                        success: function (data) {
                            if (data.successFlg == true) {
                                var d = data.obj;
                                for (var i = 0, len = d.length; i < len; i++) {
                                    regions.push({
                                        text: d[i].name,
                                        id: d[i].name
                                    });
                                }
                                self.$inpRegion.ligerComboBox({
                                    isShowCheckBox: true,
                                    isMultiSelect: true,
                                    width: '240',
                                    data: regions,
                                    valueFieldID: 'inpRegions'
                                });
                            }
                        }
                    });
                    //医疗机构
                    var mechanisms = [];

                    $.ajax({
                        url: '${contextRoot}/user/getOrgByUserId',
                        data: {},
                        type: 'GET',
                        dataType: 'json',
                        success: function (data) {
                            if (data.successFlg) {
                                var d = data.obj;
                                for (var i = 0, len = d.length; i < len; i++) {
                                    mechanisms.push({
                                        text: d[i].fullName,
                                        id: d[i].fullName
                                    });
                                }
                                self.$inpMechanism.ligerComboBox({
                                    isShowCheckBox: true,
                                    width: '240',
                                    isMultiSelect: true,
                                    data: mechanisms,
                                    valueFieldID: 'mechanism'
                                });
                            }
                        }
                    });
                    //期间
                    self.$inpStarTime.ligerDateEditor({
                        format: 'yyyy-MM-dd'
                    });
                    self.$inpEndTime.ligerDateEditor({
                        format: 'yyyy-MM-dd'
                    });
                    self.$inpStarTime.attr('readonly',true);
                    self.$inpEndTime.attr('readonly',true);

                },
                //下拉框列表项初始化//url, paramDatas, data, target, width
                initDDL: function () {
                    var me = this;
                    //初始化
                    me.index = 0;
                    me.$addSearchDom.html('');
                    $.ajax({
                        url: paramModel.url[1],
                        data: {
                            dictId: paramModel.dictId[1]
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

//                    target.ligerComboBox({
//                            url: paramModel.url[url],
//                            valueField: 'code',
//                            textField: 'value',
//                            urlParms: {
//                                dictId: paramModel.dictId[url]
//                            },
//                            width: width,
//                            onSelected: function (value) {
//                                var dataModels = this.data;
//                                var eleType = $(this.element).parents('#div_default_search');
//                                for (var i = 0; i < dataModels.length; i++) {
//                                    //判断这个对象的值存不存在字典和判断类型
//                                    if (Util.isStrEquals(dataModels[i].code, value)) {
//                                        if (Util.isStrEquals(this.element.id, 'inp_logical_relationship')) {
//                                            conditionBo = Util.isStrEquals(this.selectedValue, 'RANGE') || Util.isStrEquals(this.selectedValue, 'NOT RANGE');
//                                            switchType(getEleType(eleType, 'inpType'), $(".div-change-search"), '.inp_defualt_param', 'default', conditionBo, getEleType(eleType, 'dict'));
//                                            return;
//                                        }
//                                        if (!Util.isStrEquals(dataModels[i].dict, 0)) {
//                                            switchType('dict', $(".div-change-search"), '.inp_defualt_param', 'default', conditionBo, dataModels[i].dict);
//                                        } else {
//                                            switchType(dataModels[i].type, $(".div-change-search"), '.inp_defualt_param', 'default', conditionBo, '');
//                                        }
//                                    }
//                                }
//                            }
//                        });
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
                            url: paramModel.url[3],
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
                }
            };
            resourceBrowseMaster = {
                init: function () {
                    var self = retrieve;
                    var columnModel = new Array(),
                            //基本信息
                            defArr = [
                                {"key": 'patient_name', "name": "病人姓名"},
                                {"key": 'event_type', "name": "就诊类型"},
                                {"key": 'org_name', "name": "机构名称"},
                                {"key": 'org_code', "name": "机构编号"},
                                {"key": 'event_date', "name": "时间"},
                                {"key": 'demographic_id', "name": "病人身份证号码"}
                            ];
                    //获取列名
                    if (!Util.isStrEmpty(resourcesCode)) {
                        dataModel.fetchRemote("${contextRoot}/resourceView/getGridCloumnNames", {
                            data: {
                                dictId: resourcesCode
                            },
                            async: false,
                            success: function (data) {
                                if (data.length > 0) {
                                    for (var j = 0, len = defArr.length; j < len; j++) {
                                        columnModel.push({display: defArr[j].name, name: defArr[j].key, width: 100});
                                    }
                                }
                                for (var i = 0; i < data.length; i++) {
                                    columnModel.push({display: data[i].value, name: data[i].code, width: 100});
                                }
                                resourceInfoGrid = self.$resourceInfoGrid.ligerGrid($.LigerGridEx.config({
                                    url: '${contextRoot}/resourceBrowse/searchResourceData',
                                    parms: {searchParams: '', resourcesCode: resourcesCode},
                                    columns: columnModel,
                                    height: windowHeight - (searcHheight + 235),
                                    checkbox: true,
                                    onSelectRow:function () {
                                        if(Util.isStrEquals(resourceInfoGrid.getSelectedRows().length,0)){
                                            self.$outSelExcelBtn.css('background','#B9C8D2');
                                        }else{
                                            self.$outSelExcelBtn.css('background','#2D9BD2');
                                        }
                                    },
                                    onUnSelectRow:function () {
                                        if(Util.isStrEquals(resourceInfoGrid.getSelectedRows().length,0)){
                                            self.$outSelExcelBtn.css('background','#B9C8D2');
                                        }else{
                                            self.$outSelExcelBtn.css('background','#2D9BD2');
                                        }
                                    },
                                    onAfterShowData:function () {
                                        self.$outAllExcelBtn.css('background','#B9C8D2');
                                        if (resourceInfoGrid.data.detailModelList.length > 0){
                                            self.$outAllExcelBtn.css('background','#2D9BD2');
                                        }
                                    }
                                }));
                            }
                        });
                    }
                },
                reloadResourcesGrid: function (searchParams) {
                    reloadGrid.call(this, '${contextRoot}/resourceView/searchResourceData', searchParams);
                },
                getQuerySearchData: function () {
                    var self = retrieve;
                    var pModel = self.$newSearch.children('div'),
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
                    jsonData = RSsearchParams = Util.isStrEquals(jsonData.length, 0) ? "" : JSON.stringify(jsonData);
                    return jsonData;
                },

                bindEvents: function () {
                    var self = retrieve;
                    var searchBo = false;

                    //返回资源注册页面
                    $('#btn_back').click(function(){
                        $('#contentPage').empty();
                        $('#contentPage').load('${contextRoot}/resource/resourceManage/initial');
                    });

                    //检索
                    self.$SearchBtn.click(function (e) {
                        e.stopPropagation();
                        e.preventDefault();
                        self.index = 0;
                        var queryCondition = resourceBrowseMaster.getQuerySearchData();
                        resourceBrowseMaster.reloadResourcesGrid({
                            searchParams: queryCondition,
                            resourcesCode: resourcesCode
                        });

                        self.$popMain.css('display', 'none');
                    });

                    self.$ddSeach.on('click', function (e) {
                        e.stopPropagation();
                        if (self.$resourceInfoGrid.html() == '') {
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
                        if (self.$popMain.css('display') == 'none') {
                            self.$popMain.css('display', 'block');
                            self.$sjIcon.css('display', 'block');
                            self.$popSCon.css('display', 'block');
                        } else {
                            self.$popMain.css('display', 'none');
                            self.$sjIcon.css('display', 'none');
                            self.$popSCon.css('display', 'none');
                        }
                    });
                    //新增一行查询条件
//                    self.$newSearchBtn.click(function () {
//
//                        $(".f-w-auto").width($(".div-and-or").width());
//                        var searcHheight = $(".div-search-height").height();
////                        resourceInfoGrid.setHeight(height-(searcHheight+290));
//                        var model = self.$searchModel.clone(true);
//                        self.$newSearch.append(model);
//
//                        var modelLength = model.find("input");
//                        var width = [defaultWidthAndOr, defaultWidth, defaultWidthAndOr, defaultWidth];
//                        var cls = '.inp-model';
//
//                        for (var i = 0; i < modelLength.length; i++) {
//                            var code = 'code';
//                            var value = 'value';
//                            model.find(cls + i).ligerComboBox({
//                                url: paramModel.url[i],
//                                valueField: code,
//                                textField: value,
//                                urlParms: {
//                                    dictId: paramModel.dictId[i]
//                                },
//                                width: width[i],
//                                onSelected: function (value) {
//                                    var dataModels = this.data;
//                                    var eleType = $(this.element).parents('.div_search_model');
//                                    var $inpSearchType = $(this.element).parents('.div_search_model').find('.div-new-change-search');
//                                    var eleClass_model0 = $(this.element).attr('class').split('inp-model0');
//                                    var eleClass_model2 = $(this.element).attr('class').split('inp-model2');
//                                    var eleClass_model3 = $(this.element).attr('class').split('inp-model3');
//                                    if (eleClass_model0.length >= 2 || eleClass_model3.length >= 2) {
//                                        return;
//                                    }else {
//                                        conditionBo = Util.isStrEquals(this.selectedValue, 'RANGE') || Util.isStrEquals(this.selectedValue, 'NOT RANGE');
//                                        switchType(getEleType(eleType, 'inpType'), $inpSearchType, '.inp-find-search', '', conditionBo, getEleType(eleType, 'dict'));
//                                        return;
//                                    }
//                                    for (var i = 0; i < dataModels.length; i++) {
//                                        //判断这个对象的值存不存在字典和判断类型
//                                        if (Util.isStrEquals(dataModels[i].code, value)) {
//                                            if (!Util.isStrEquals(dataModels[i].dict, 0)) {
//                                                switchType('dict', $inpSearchType, '.inp-find-search', '', conditionBo, dataModels[i].dict);
//                                            } else {
//                                                switchType(dataModels[i].type, $inpSearchType, '.inp-find-search', conditionBo);
//                                            }
//                                        }
//                                    }
//                                }
//                            });
//                        }
//                        model.show();
//                    });
                    //删除一行查询条件
//                    self.$delBtn.click(function () {
//                        var searcHheight = $(".div-search-height").height();
//                        $(this).parent().parent().remove();
//                    });
                    //检索
//                    self.$SearchBtn.click(function () {
//                        var pModel = self.$newSearch.children('div');
//
//                        jsonData = [];
////                        var defualtParam = $(".inp_defualt_param");
//                        var value = null;
//                        for (var i = 0; i < pModel.length; i++) {
//                            var pModel_child = $(pModel[i]);
//                            pModel_child.attrScan();
//                            var values = pModel_child.Fields.getValues();
//                            values.value = value = pModel_child.find('.inp-com-param').liger().getValue();
//                            if (pModel_child.find('.inp-com-param').liger().options.format == "yyyy-MM-dd") {
//                                values.value = Util.isStrEmpty(value) ? "" : value.format('yyyy-MM-dd');
//                            }
//                            else if (pModel_child.find('.inp-com-param').liger().options.format == "yyyy-MM-dd hh:mm:ss") {
//                                values.value = Util.isStrEmpty(value) ? "" : value.format('yyyy-MM-ddTHH:mm:ssZ');
//                            }
//                            if (!Util.isStrEmpty(values.time)) {
//                                var rangeLigerElm = $(pModel_child.find('.inp-com-param')[0]).liger();
//                                var rangeLigerElm1 = $(pModel_child.find('.inp-com-param')[1]).liger();
//                                values.value = rangeLigerElm.getValue() + "," + rangeLigerElm1.getValue();
//                                if (rangeLigerElm.options.format == "yyyy-MM-dd") {
//                                    values.value = (Util.isStrEmpty(rangeLigerElm.getValue()) ? "" : rangeLigerElm.getValue().format('yyyy-MM-dd')) + "," + (Util.isStrEmpty(rangeLigerElm1.getValue()) ? "" : rangeLigerElm1.getValue().format('yyyy-MM-dd'));
//                                }
//                                else if (rangeLigerElm.options.format == "yyyy-MM-dd hh:mm:ss") {
//                                    values.value = (Util.isStrEmpty(rangeLigerElm.getValue()) ? "" : rangeLigerElm.getValue().format('yyyy-MM-ddTHH:mm:ssZ')) + "," + (Util.isStrEmpty(rangeLigerElm1.getValue()) ? "" : rangeLigerElm1.getValue().format('yyyy-MM-ddTHH:mm:ssZ'));
//                                }
//                                delete values['time'];
//                            }
//                            jsonData.push(values);
//                        }
//                        for (var j = 0; j < jsonData.length; j++) {
//                            if (Util.isStrEmpty(jsonData[j].value) || Util.isStrEmpty(jsonData[j].field)) {
//                                jsonData.splice(j, 1);
//                                j--;
//                            }
//                        }
//                        jsonData = RSsearchParams = Util.isStrEquals(jsonData.length, 0) ? "" : JSON.stringify(jsonData);
//                        console.log(Util.isStrEmpty(jsonData)?"查询条件为空或查询的值为空":jsonData);
//                        resourceBrowseMaster.reloadResourcesGrid({
//                            searchParams: jsonData,
//                            resourcesCode: resourcesCode
//                        });
//
//                    });

                    //重置
                    self.$resetBtn.click(function () {
//                        searchBo = true;
//                        $(".inp-reset").val('');
                        resetSearch();
                    });
                    //导出选择结果
                    self.$outSelExcelBtn.click(function () {
                        var jsonDatas = [];
                        var rowData = resourceInfoGrid.getSelectedRows();
                        $.each(rowData,function (key,value) {
                            var jsonParam = {andOr: "OR", field: "rowkey", condition: "=", value: ""};
                            jsonParam.value = value.rowkey;
                            jsonDatas.push(jsonParam);
                        });
                        outExcel(rowData, rowData.length,JSON.stringify(jsonDatas));
                    });
                    //导出全部结果
                    self.$outAllExcelBtn.click(function () {
                        var rowData = resourceInfoGrid.data.detailModelList;
                        outExcel(rowData, resourceInfoGrid.currentData.totalPage * resourceInfoGrid.currentData.pageSize,RSsearchParams);
                    });
                    function outExcel(rowData, size,RSsearchParams) {
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
                        window.open("${contextRoot}/resourceBrowse/outExcel?size=" + size + "&resourcesCode=" + resourcesCode + "&searchParams=" + RSsearchParams, "资源数据导出");
                    }
                }
            };
            function switchType(columnTypes, inpSearchType, chlidEle, def, condition, dictId) {
                inpTypes = columnTypes;
                switch (columnTypes) {
                    case 'S1':
                        changeHtml(inpSearchType, chlidEle, def, 'ligerTextBox', dictId, '', condition);
                        break;
                    case 'L':
                        changeHtml(inpSearchType, chlidEle, def, 'ligerComboBox', 'boolean', '', condition);
                        break;
                    case 'N':
                        changeHtml(inpSearchType, chlidEle, def, 'ligerTextBox', dictId, '', condition);
                        break;
                    case 'D':
                        changeHtml(inpSearchType, chlidEle, def, 'ligerDateEditor', dictId, 'D', condition);
                        break;
                    case 'DT':
                        changeHtml(inpSearchType, chlidEle, def, 'ligerDateEditor', dictId, 'DT', condition);
                        break;
                    case 'dict':
                        changeHtml(inpSearchType, chlidEle, def, 'ligerComboBox', dictId, 'DT', condition);
                        break;
                    default:
                        changeHtml(inpSearchType, chlidEle, def, 'ligerTextBox', '', dictId, condition);
                        break;
                }
            }
            //divEle  input的父节点,（jquery对象）例如：$("#inp_defualt_param")
            //inpEle  输入框input的id或class,例如：#inp_defualt_param
            //defHtml 是否默认搜索条件
            //ligerType liger控件类型
            //dict  是否是字典
            function changeHtml(divEle, inpEle, defHtml, ligerType, dictId, data, condition) {
                var html = '<div class="f-fl"><input type="text" class="f-ml10 inp-reset inp-model3 inp-com-param inp-find-search" data-type="select" data-attr-scan="value" /></div>';
                if (Util.isStrEquals(defHtml, 'default')) {
                    html = '<div class="f-fl"><input type="text" class="f-ml10 inp-reset inp-com-param inp_defualt_param" data-type="select" data-attr-scan="value" /></div>';
                    if (condition) {
                        html += '<div class="f-fr div-time-width"><span class="f-fl f-mt10 f-ml-20">～</span><div style="float: right"><input type="text" class="f-ml10 inp-reset inp-com-param inp_defualt_param" data-type="select" data-attr-scan="time" /></div></div>';
                    }
                }
                else if (condition) {
                    html += '<div class="f-fr div-time-value div-time-width"><span class="f-fl f-mt10 f-ml-20">～</span><div style="float: right"><input type="text" class="f-ml10 inp-reset inp-model3 inp-com-param inp-find-search" data-type="select" data-attr-scan="time" /></div></div>';
                }
                divEle.html("");
                divEle.html(html);
                $(".div-time-width").width($(".div-change-search").width() - defaultWidth - 5);
                if (!Util.isStrEquals(ligerType, 'ligerComboBox')) {
                    divEle.find(inpEle).attr('data-type', '');
                }
                switch (ligerType) {
                    case 'ligerComboBox':
                        divEle.find(inpEle).ligerComboBox({
                            url: paramModel.url[3],
                            parms: {dictId: dictId},
                            valueField: 'code',
                            textField: 'name',
                            width: defaultWidth,
                            dataParmName: 'detailModelList',
                            onSelected: function (value) {
                            }
                        });
                        break;
                    case 'ligerTextBox':
                        divEle.find(inpEle).ligerTextBox({width: defaultWidth});
                        break;
                    case 'ligerDateEditor':
                        var format = '';
                        if (Util.isStrEquals(data, 'D')) {
                            format = 'yyyy-MM-dd';
                        } else {
                            format = 'yyyy-MM-dd hh:mm:ss';
                        }
                        divEle.find(inpEle).ligerDateEditor({width: defaultWidth, format: format, showTime: true});
                        break;
                }
            }
            function getEleType(ele, type) {
                var obj = ele.find('.div-table-colums').liger().selected;
                var value = obj.dict;
                if (Util.isStrEquals(type, 'inpType')) {
                    value = Util.isStrEmpty(obj.dict) ? obj.type : 'dict';
                }
                return value;
            }
            function resetSearch() {
                var pModel = retrieve.$newSearch.children('div');
                var resetInp = $(pModel.find('.inp-reset'));
                for (var i = 1; i < resetInp.length; i++) {
                    $(resetInp[i]).liger().setValue('');
                }
            }
            /* ************************* 模块初始化结束 ************************** */

            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window)
</script>