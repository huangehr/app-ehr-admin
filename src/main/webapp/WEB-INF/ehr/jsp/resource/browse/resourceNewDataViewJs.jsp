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
            var leftTree = null;

            var dataModel = $.DataModel.init();

            /* *************************** 函数定义 ******************************* */
            /**
             * 页面初始化。
             * @type {Function}
             */
            function pageInit() {
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
                $resourceInfoGrid: $("#div_resource_info_grid"),
                $newSearch: $("#div_search_data_role_form"),
                $SearchBtn: $("#div_search_btn"),
                $resetBtn: $("#div_reset_btn"),
                $outSelExcelBtn: $("#div_out_sel_excel_btn"),
                $outAllExcelBtn: $("#div_out_all_excel_btn"),
                $resourceBrowse: $(".div-resource-browse"),
                $resourceSub: $('#sp_resourceSub'),
                $resourceName: $('#sp_resourceName'),
                $searchNm:$("#searchNm"),

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
//                    self.$resourceName.ligerComboBox().setValue("");
                    self.$searchNm.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            var categoryName = self.$searchNm.val();
                            leftTree.s_search(categoryName);
                            if (categoryName == '') {
                                var html= $("#div-left-tree").html();
                                $("#div-left-tree").html(html);
                                $("#div-left-tree .l-box.l-checkbox").hide();
                                $("#div-left-tree .l-checkbox-unchecked").closest("li").hide();
                                $("#div-left-tree .l-checkbox-checked").closest("li").show();
                                leftTree.collapseAll();
                            } else {
                                leftTree.expandAll();
                            }
                        }
                    });

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

                    self.$resourceBrowseMsg.height(windowHeight);
                    self.$resourceBrowse.mCustomScrollbar({
                        axis: "y"
                    });
                    $("#div-left-scroller").mCustomScrollbar({
                        axis: "y"
                    });
                    $($("#div_resource_browse_msg").children('div').children('div')[0]).css('margin-right','0');
                    self.loadTree();
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
                },
                loadTree:function(){
                    var self = this;
                    leftTree = $("#div-left-tree").ligerSearchTree({
                        nodeWidth: 180,
                        url: '${contextRoot}/resourceBrowse/resourceBrowseTree',
//                        parms:{},
                        idFieldName: 'id',
//                        parentIDFieldName: 'parent_hos_id',
                        textFieldName: 'name',
                        isExpand: false,
                        enabledCompleteCheckbox:false,
                        checkbox: false,
                        async: false,
                        onSelect:function (data,target) {
                            if(data.data.pid!=""){//二级节点，才查询
                                var resultData  = data.data;
                                queryParam.resourceSub = resultData.name;
                                queryParam.resourceId = resultData.id;
                                queryParam.resourceName = $($(data.target.parentElement.parentElement).find(".l-body span")[0]).html();
                                queryParam.resourceCode = resultData.code;
                                resourcesCode = queryParam.resourceCode;
                                resourceBrowseMaster.init();
                                console.log(resourceInfoGrid);
                                if(resourceInfoGrid){
                                    resourceBrowseMaster.reloadResourcesGrid({
                                        searchParams: queryParam,
                                        resourcesCode: resourcesCode
                                    });
                                    paramModel.dictId[1] = resourcesCode;
                                    self.getSearchData(1, 1);
                                }
                            }
                        },
                        onSuccess: function (data) {
                            var detailModelList = data.detailModelList;
                            for(var i=0;i<detailModelList.length;i++){
                                var rsResourceslist = detailModelList[i].rsResourceslist;
                                detailModelList[i].children = rsResourceslist;
                            }
                            leftTree.setData(detailModelList);
                            $("#div-left-tree li div span ,#div_configFun_featrue_org_grid li div span").css({
                                "line-height": "22px",
                                "height": "22px"
                            });

                        },

                    });
                },
                //获取列表字段
                getSearchData: function (url, paramDatas) {
                    var me = this;
                    $.ajax({
                        url: paramModel.url[url],
                        dataType: 'json',
                        type: 'GET',
                        data:{
                            dictId: paramModel.dictId[url]
                        },
                        success: function (data) {
                            if (data && data.length > 0) {
                                //初始化
                                me.index = 0;
                                me.$addSearchDom.html('');
                                me.GridCloumnNamesData = data;
                                me.setSearchData();
                            }
                        }
                    })
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
                                for (var j = 0, len = defArr.length; j < len; j++) {
                                    columnModel.push({display: defArr[j].name, name: defArr[j].key, width: 100});
                                }
                                for (var i = 0; i < data.length; i++) {
                                    columnModel.push({display: data[i].value, name: data[i].code, width: 100});
                                }
                                resourceInfoGrid = self.$resourceInfoGrid.ligerGrid($.LigerGridEx.config({
                                    url: '${contextRoot}/resourceBrowse/searchResourceData',
                                    parms: {searchParams: '', resourcesCode: resourcesCode},
                                    columns: columnModel,
                                    height: windowHeight - 110,
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

                bindEvents: function () {
                    var self = retrieve;
                    var searchBo = false;


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
//                    self.$ddSeach.on('mouseout', '.pop-s-con', function (e) {
//                        console.log($(e.target).attr('class'));
//                        if ($(e.target).hasClass('l-table-checkbox') ||
//                                $(e.target).hasClass('l-trigger-icon') ||
//                                $(e.target).hasClass('l-box-dateeditor-absolute') ||
//                                $(e.target).hasClass('l-text-field') ||
//                                $(e.target).hasClass('j-text-wrapper') ||
//                                $(e.target).hasClass('u-btn-large') ||
//                                $(e.target).hasClass('inp-label') ||
//                                $(e.target).hasClass('pop-s-con') ||
//                                $(e.target).hasClass('f-mt6') ||
//                                $(e.target).hasClass('clear-s')) {
//                            return;
//                        }
//                        self.$popMain.css('display', 'none');
//                        self.$sjIcon.css('display', 'none');
//                        self.$popSCon.css('display', 'none');
//                    });

                    //返回资源注册页面
                    $('#btn_back').click(function(){
                        $('#contentPage').empty();
                        $('#contentPage').load('${contextRoot}/resource/resourceManage/initial');
                    });

                    //检索
                    self.$SearchBtn.click(function (e) {
                        e.stopPropagation();
                        e.preventDefault();
                        var pModel = self.$newSearch.children('div'),
                            jsonData = [],
                            value = null;
                        var resetInp = $(pModel.find('.inp-reset'));
                        for (var i = 0; i < resetInp.length; i++) {
                            var code = $(resetInp[i]).attr('data-code'),
                                value = $(resetInp[i]).liger().getValue(),
                                valArr = [];
                            if (typeof value != 'string' && value instanceof Date) {
                                value = value.format('yyyy-MM-dd');
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
                        console.log(Util.isStrEmpty(jsonData)?"查询条件为空或查询的值为空":jsonData);
                        resourceBrowseMaster.reloadResourcesGrid({
                            searchParams: jsonData,
                            resourcesCode: resourcesCode
                        });

                        self.$popMain.css('display', 'none');
                    });

                    //重置
                    self.$resetBtn.click(function () {
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

            function resetSearch() {
                var pModel = retrieve.$newSearch.children('div');
                var resetInp = $(pModel.find('.inp-reset'));
                for (var i = 0; i < resetInp.length; i++) {
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