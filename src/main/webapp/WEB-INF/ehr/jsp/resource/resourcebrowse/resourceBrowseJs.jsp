<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
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
            var defaultWidth = $("#div-f-w1").width();
            var defaultWidthAndOr = $("#div-f-w2").width();
            var windowWidth = $(window).width();
            var windowHeight = $(window).height();
            //检索模块初始化
            var paramModel = null;
            var resourceInfoGrid = null;
            var resourceCategoryId = "";
            var resourceCategoryName = "";
            var resourcesCode = "";
            var typeTree = "";
            var inpTypes = "";
            var conditionBo = false;
            var searchBo = false;
            var jsonData = new Array();
            var dataModel = $.DataModel.init();

            /* *************************** 函数定义 ******************************* */

            function pageInit() {
                retrieve.init();
                resourceBrowseMaster.bindEvents();

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
                url: ["${contextRoot}/resourceBrowse/searchDictEntryList", '${contextRoot}/resourceBrowse/getGridCloumnNames', "${contextRoot}/resourceBrowse/searchDictEntryList", "${contextRoot}/resourceBrowse/getRsDictEntryList"],
                dictId: ['andOr', resourceCategoryId, '34', '']
            };

            /* *************************** 检索模块初始化结束 ***************************** */

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $resourceBrowseTree: $("#div_resource_browse_tree"),
                $defaultCondition: $("#inp_default_condition"),
                $logicalRelationship: $("#inp_logical_relationship"),
                $defualtParam: $(".inp_defualt_param"),
                $searchModel: $(".div_search_model"),
                $resourceInfoGrid: $("#div_resource_info_grid"),
                $resourceBrowseMsg: $("#div_resource_browse_msg"),
                $search: $("#inp_search"),
                $newSearch: $("#div_new_search"),
                $newSearchBtn: $("#sp_new_search_btn"),
                $SearchBtn: $("#div_search_btn"),
                $delBtn: $(".sp-del-btn"),
                $resetBtn: $("#div_reset_btn"),
                $outSelExcelBtn: $("#div_out_sel_excel_btn"),
                $outAllExcelBtn: $("#div_out_all_excel_btn"),
                $resourceTree: $(".div-resource-tree"),
                init: function () {
                    var self = this;
                    self.$resourceBrowseMsg.height(windowHeight - 170);

                    var width = $(".f-of-hd").width();
                    var searchs = self.$search.ligerTextBox({
                        width: width / 1.4, isSearch: true, search: function () {
                            var categoryName = searchs.getValue();
                            typeTree.s_search(categoryName);
                            if (categoryName == '') {
                                typeTree.collapseAll();
                            } else {
                                typeTree.expandAll();
                            }
                        }
                    });

                    self.initDDL(1, self.$defaultCondition, defaultWidth);
                    self.initDDL(2, self.$logicalRelationship, defaultWidthAndOr);
                    self.initDDL('', self.$defualtParam, defaultWidth);
                    self.getResourceBrowseTree();
                    self.$resourceTree.mCustomScrollbar({
                        axis: "yx"
                    });
                    $(".div-resource-treess").mCustomScrollbar({
                        axis: "y"
                    });
                    $($("#div_resource_browse_msg").children('div').children('div')[0]).css('margin-right','0');
                    self.$resourceTree.height(windowHeight - 240);
                    $(".f-w-auto").width($(".div-and-or").width());
                },

                //下拉框列表项初始化
                initDDL: function (url, target, width) {
                    target.ligerComboBox({
                        url: paramModel.url[url],
                        valueField: 'code',
                        textField: 'value',
                        dataParmName: 'detailModelList',
                        urlParms: {
                            dictId: paramModel.dictId[url]
                        },
                        width: width,
                        onSelected: function (value) {
                            var dataModels = this.data;
                            var eleType = $(this.element).parents('#div_default_search');
                            for (var i = 0; i < dataModels.length; i++) {
                                //判断这个对象的值存不存在字典和判断类型
                                if (Util.isStrEquals(dataModels[i].code, value)) {
                                    if (Util.isStrEquals(this.element.id, 'inp_logical_relationship')) {
                                        conditionBo = Util.isStrEquals(this.selectedValue, 'RANGE') || Util.isStrEquals(this.selectedValue, 'NOTRANGE');
                                        switchType(getEleType(eleType, 'inpType'), $(".div-change-search"), '.inp_defualt_param', 'default', conditionBo, getEleType(eleType, 'dict'));
                                        return;
                                    }
                                    if (!Util.isStrEquals(dataModels[i].dict, 0)) {
                                        switchType('dict', $(".div-change-search"), '.inp_defualt_param', 'default', conditionBo, dataModels[i].dict);
                                    } else {
                                        switchType(dataModels[i].type, $(".div-change-search"), '.inp_defualt_param', 'default', conditionBo, '');
                                    }
                                }
                            }
                        }
                    });
                },

                getResourceBrowseTree: function (data) {
                    typeTree = this.$resourceBrowseTree.ligerSearchTree({
                        nodeWidth: 200,
                        url: '${contextRoot}/resourceBrowse/searchResource',
                        checkbox: false,
                        idFieldName: 'id',
                        parentIDFieldName: 'pid',
                        textFieldName: 'name',
                        isExpand: false,
                        isLeaf: function (data) {
                            return !Util.isStrEmpty(data.resourceIds);
                        },
                        onSelect: function (data) {
                            searchBo = true;
                            $(".inp-reset").val('');
                            resourceCategoryName = data.data.name;
                            resourceCategoryId = data.data.resourceIds;
                            resourcesCode = data.data.resourceCode;  //根据resourcesCode查询表结构
                            if (Util.isStrEmpty(resourceCategoryId)) {
                                return;
                            }
                            paramModel.dictId[1] = resourcesCode;
                            dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {
                                data: {dictId: resourcesCode},
                                success: function (data) {
                                    var reloadSelects = $("#div-search-data-role-form").children('div');
                                    for (var i = 0; i < reloadSelects.length; i++) {
                                        var inputElm = $($(reloadSelects)[i]).find('.div-table-colums');
                                        inputElm.ligerComboBox({
                                            valueField: 'code',
                                            textField: 'value',
                                            width: defaultWidth,
                                            data: data.detailModelList
                                        });
                                    }
                                }
                            });
                            resourceBrowseMaster.init(resourceCategoryId, resourcesCode);
                        },
                        onSuccess: function (data) {
                            resourceBrowseMaster.init(data[0].id);
                            $("#div_resource_browse_tree li div span").css({
                                "line-height": "22px",
                                "height": "22px"
                            });
                        }
                    });
                }
            };
            resourceBrowseMaster = {
                init: function (objectId, resourcesCode) {
                    var self = retrieve;
                    var columnModel = new Array();
                    var sh = $(".div-search-height").height();
                    //获取列名
                    if (!Util.isStrEmpty(objectId)) {
                        dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {
                            data: {
                                dictId: resourcesCode
                            },
                            success: function (data) {
                                var data = data.detailModelList;
                                for (var i = 0; i < data.length; i++) {
                                    columnModel.push({display: data[i].value, name: data[i].code, width: 100});
                                }
                                self.$outAllExcelBtn.css('background','#B9C8D2');
                                resourceInfoGrid = self.$resourceInfoGrid.ligerGrid($.LigerGridEx.config({
                                    url: '${contextRoot}/resourceBrowse/searchResourceData',
                                    parms: {searchParams: '', resourcesCode: resourcesCode},
                                    columns: columnModel,
//                                    height: 700,
                                    height: windowHeight - (sh + 230),
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
                                        if (resourceInfoGrid.data.detailModelList.length > 0){
                                            self.$outAllExcelBtn.css('background','#2D9BD2');
                                        }
                                    }
                                }));
                                resourceInfoGrid.options.newPage = 1;
                                resourceInfoGrid.reload(true);
                            }
                        });
                    }
                },
                reloadResourcesGrid: function (searchParams) {
                    reloadGrid.call(this, '${contextRoot}/resourceBrowse/searchResourceData', searchParams);
                },
                bindEvents: function () {

                    var self = retrieve;
                    //新增一行查询条件
                    self.$newSearchBtn.click(function () {
                        $(".f-w-auto").width($(".div-and-or").width());
                        var searcHheight = $(".div-search-height").height();
//                        resourceInfoGrid.setHeight(windowHeight - (searcHheight + 290));
                        var model = self.$searchModel.clone(true);
                        $("#div-search-data-role-form").append(model);
                        var modelLength = model.find("input");
                        var width = [defaultWidthAndOr, defaultWidth, defaultWidthAndOr, defaultWidth];
                        var cls = '.inp-model';

                        for (var i = 0; i < modelLength.length; i++) {
                            model.find(cls + i).ligerComboBox({
                                url: paramModel.url[i],
                                valueField: 'code',
                                textField: 'value',
                                dataParmName: 'detailModelList',
                                urlParms: {
                                    dictId: paramModel.dictId[i]
                                },
                                width: width[i],
                                onSelected: function (value) {
                                    var dataModels = this.data;
                                    var eleType = $(this.element).parents('.div_search_model');
                                    var $inpSearchType = $(this.element).parents('.div_search_model').find('.div-new-change-search');
                                    var eleClass_model0 = $(this.element).attr('class').split('inp-model0');
                                    var eleClass_model2 = $(this.element).attr('class').split('inp-model2');
                                    var eleClass_model3 = $(this.element).attr('class').split('inp-model3');
                                    if (eleClass_model0.length >= 2 || eleClass_model3.length >= 2) {
                                        return;
                                    } else {
                                        conditionBo = Util.isStrEquals(this.selectedValue, 'RANGE') || Util.isStrEquals(this.selectedValue, 'NOTRANGE');
                                        switchType(getEleType(eleType, 'inpType'), $inpSearchType, '.inp-find-search', '', conditionBo, getEleType(eleType, 'dict'));
                                        return;
                                    }

                                    for (var i = 0; i < dataModels.length; i++) {
                                        //判断这个对象的值存不存在字典和判断类型
                                        if (Util.isStrEquals(dataModels[i].code, value)) {
                                            if (!Util.isStrEquals(dataModels[i].dict, 0)) {
                                                switchType('dict', $inpSearchType, '.inp-find-search', '', conditionBo, dataModels[i].dict);
                                            } else {
                                                switchType(dataModels[i].type, $inpSearchType, '.inp-find-search', conditionBo);
                                            }
                                        }
                                    }
                                }
                            });
                        }
                        model.show();
                    });
                    //删除一行查询条件
                    self.$delBtn.click(function () {
                        var searcHheight = $(".div-search-height").height();
//                        resourceInfoGrid.setHeight(windowHeight - (searcHheight + 210));
                        $(this).parent().parent().remove();
                    });

                    //检索
                    self.$SearchBtn.click(function () {
                        jsonData = [];
                        var defualtParam = $(".inp_defualt_param");
                        var pModel = $("#div-search-data-role-form").children('div');
                        for (var i = 0; i < pModel.length; i++) {
                            var pModel_child = $(pModel[i]);
                            pModel_child.attrScan();
                            var values = pModel_child.Fields.getValues();
                            if (i == 0) {
                                values.value = defualtParam.ligerGetComboBoxManager().getValue();
                                if (defualtParam.ligerGetComboBoxManager().options.format == "yyyy-MM-dd"){
                                    values.value = Util.isStrEmpty(values.value)?"":values.value.format('yyyy-MM-dd');
                                }
                                else if (defualtParam.ligerGetComboBoxManager().options.format == "yyyy-MM-dd hh:mm:ss"){
                                    values.value = Util.isStrEmpty(values.value)?"":values.value.format('yyyy-MM-ddTHH:mm:ssZ');
                                }
                            } else {
                                values.value = $(pModel_child.find('.inp-find-search')[3]).ligerGetComboBoxManager().getValue();
                                if ($(pModel_child.find('.inp-find-search')[3]).ligerGetComboBoxManager().options.format == "yyyy-MM-dd"){
                                    values.value = Util.isStrEmpty(values.value)?"":values.value.format('yyyy-MM-dd');
                                }
                                else if ($(pModel_child.find('.inp-find-search')[3]).ligerGetComboBoxManager().options.format == "yyyy-MM-dd hh:mm:ss"){
                                    values.value = Util.isStrEmpty(values.value)?"":values.value.format('yyyy-MM-ddTHH:mm:ssZ');
                                }
                            }
                            if (!Util.isStrEmpty(values.time)) {
                                if ($(pModel_child.find('.inp-com-param')[0]).ligerGetComboBoxManager().options.format == "yyyy-MM-dd"){
                                    values.value = $(pModel_child.find('.inp-com-param')[0]).ligerGetComboBoxManager().getValue().format('yyyy-MM-dd')+ "," + $(pModel_child.find('.inp-com-param')[1]).ligerGetComboBoxManager().getValue().format('yyyy-MM-dd');
                                }
                                else if ($(pModel_child.find('.inp-com-param')[0]).ligerGetComboBoxManager().options.format == "yyyy-MM-dd hh:mm:ss"){
                                    values.value = $(pModel_child.find('.inp-com-param')[0]).ligerGetComboBoxManager().getValue().format('yyyy-MM-ddTHH:mm:ssZ')+ "," + $(pModel_child.find('.inp-com-param')[1]).ligerGetComboBoxManager().getValue().format('yyyy-MM-ddTHH:mm:ssZ');
                                }
                                delete values['time'];
                            }
                            jsonData.push(values);
                        }
                        if (Util.isStrEquals(jsonData.length, 1) && Util.isStrEmpty(jsonData[0].value)) {
                            searchBo = true;
                        }
                        jsonData = searchBo ? '' : JSON.stringify(jsonData);
                        searchBo = false;
                        resourceBrowseMaster.reloadResourcesGrid({
                            searchParams: jsonData,
                            resourcesCode: resourcesCode
                        });
                    });
                    //重置
                    self.$resetBtn.click(function () {
                        searchBo = true;
                        $(".inp-reset").val('');
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
                        outExcel(rowData, resourceInfoGrid.currentData.totalPage * resourceInfoGrid.currentData.pageSize,"");
                    });
                    function outExcel(rowData, size,param) {
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
                        window.open("${contextRoot}/resourceBrowse/outExcel?codes=" + JSON.stringify(codes) + "&names=" + JSON.stringify(names) +"&size=" + size + "&resourcesCode=" + resourcesCode + "&searchParams=" + param, "资源数据导出");
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

            /* ************************* 模块初始化结束 ************************** */
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        });

    })(jQuery, window);
</script>