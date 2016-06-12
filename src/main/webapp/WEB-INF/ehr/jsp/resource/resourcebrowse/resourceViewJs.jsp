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
            //检索模块初始化
            var resourceData = ${dataModel};
            var resourcesCode = resourceData.resourceCode;
            var resourcesName = resourceData.resourceName;
            var resourcesSub = resourceData.resourceSub;

            var paramModel = null;
            var resourceInfoGrid = null;
            var resourceCategoryId = "";
            var resourceCategoryName = "";

            var dataModel = $.DataModel.init();

            /* *************************** 函数定义 ******************************* */
            /**
             * 页面初始化。
             * @type {Function}
             */
            function pageInit() {
                $("#sp_resourceSub").html(resourcesSub);
                $("#sp_resourceName").html(resourcesName);
                retrieve.init();
                resourceBrowseMaster.bindEvents();
                resourceBrowseMaster.init();
            }

            function reloadGrid(url, ps) {
                resourceInfoGrid.setOptions({parms: ps});
                resourceInfoGrid.loadData(true);

            }

            /* *************************** 检索模块初始化 ***************************** */

            paramModel = {
                <%--comUrl: '${contextRoot}/resourceBrowse/',--%>

                url: ["${contextRoot}/resourceView/searchDictEntryList", '${contextRoot}/resourceView/getGridCloumnNames', "${contextRoot}/resourceView/searchDictEntryList", "${contextRoot}/resourceView/getRsDictEntryList"],
                dictId: ['andOr', resourcesCode, '34', ''],
//                paramDatas: ["", {dictId: resourceCategoryId}, "", ""],
            }

            /* *************************** 检索模块初始化结束 ***************************** */

            /* *************************** 模块初始化 ***************************** */
            retrieve = {

                $resourceBrowseTree: $("#div_resource_browse_tree"),
                $defaultCondition: $("#inp_default_condition"),
                $logicalRelationship: $("#inp_logical_relationship"),
                $defualtParam: $(".inp_defualt_param"),
                $searchModel: $(".div_search_model"),
                $resourceInfoGrid: $("#div_resource_info_grid"),

                $newSearch: $("#div_new_search"),

                $newSearchBtn: $("#sp_new_search_btn"),
                $SearchBtn: $("#div_search_btn"),
                $delBtn: $(".sp-del-btn"),
                $resetBtn: $("#div_reset_btn"),
                $outSelExcelBtn: $("#div_out_sel_excel_btn"),
                $outAllExcelBtn: $("#div_out_all_excel_btn"),

                init: function () {
                    var self = this;
                    self.initDDL(1, 1, "", self.$defaultCondition, defaultWidth);
                    self.initDDL(2, 2, "", self.$logicalRelationship, defaultWidthAndOr);
                    self.initDDL('', '', "", self.$defualtParam, defaultWidth);

                },

                //下拉框列表项初始化
                initDDL: function (url, paramDatas, data, target, width) {
                        target.ligerComboBox({
                            url: paramModel.url[url],
                            valueField: 'code',
                            textField: 'value',
                            urlParms: {
                                dictId: paramModel.dictId[url]
                            },
                            width: width,
                            onSelected: function (value) {

                                var dataModels = this.data;
                                for (var i = 0; i < dataModels.length; i++) {
                                    //判断这个对象的值存不存在字典和判断类型

                                    if (Util.isStrEquals(dataModels[i].code, value)) {
                                        $("#" + this.element.id).attr('data-attr-scan', dataModels[i].code)
                                        if (Util.isStrEquals(this.element.id, 'inp_logical_relationship')) {
                                            return;
                                        }
                                        if (!Util.isStrEquals(dataModels[i].dict, 0)) {
                                            changeHtml($(".div-change-search"), '.inp_defualt_param', 'default', 'ligerComboBox', dataModels[i].dict, "");
                                        } else {

                                            switch (dataModels[i].type) {
                                                case 'S':
                                                    changeHtml($(".div-change-search"), '.inp_defualt_param', 'default', 'ligerTextBox', "", "");
                                                    break;
                                                case 'L':
                                                    changeHtml($(".div-change-search"), '.inp_defualt_param', 'default', 'ligerComboBox', 'boolean', "");
                                                    break;
                                                case 'N':
                                                    changeHtml($(".div-change-search"), '.inp_defualt_param', 'default', 'ligerTextBox', "", "");
                                                    break;
                                                case 'D':
                                                    changeHtml($(".div-change-search"), '.inp_defualt_param', 'default', 'ligerDateEditor', "", "");
                                                    break;
                                                case 'DT':
                                                    changeHtml($(".div-change-search"), '.inp_defualt_param', 'default', 'ligerDateEditor', "", "");
                                                    break;
                                                default:
                                                    changeHtml($(".div-change-search"), '.inp_defualt_param', 'default', 'ligerTextBox', "", "");
                                                    break;
                                            }
                                        }
                                    }
                                }
                            }
                        });
                }

            };
            resourceBrowseMaster = {
                init: function () {
                    var self = retrieve;
//                    var grid = null;
                    var columnModel = new Array();
                    //获取列名
                    if (!Util.isStrEmpty(resourcesCode)) {
                        dataModel.fetchRemote("${contextRoot}/resourceView/getGridCloumnNames", {
                            data: {
                                dictId: resourcesCode
                            },
                            success: function (data) {

                                for (var i = 0; i < data.length; i++) {
                                    columnModel.push({display: data[i].value, name: data[i].code, width: 100});
                                }

                                resourceInfoGrid = self.$resourceInfoGrid.ligerGrid($.LigerGridEx.config({
                                    url: '${contextRoot}/resourceView/searchResourceData',
                                    parms: {searchParams: '', resourcesCode: resourcesCode},
                                    columns: columnModel,
                                    height: 680,
                                    checkbox: true
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

                    //返回资源注册页面
                    $('#btn_back').click(function(){
                        $('#contentPage').empty();
                        $('#contentPage').load('${contextRoot}/resource/resourceManage/initial?backParams='+JSON.stringify(resourceData.backParams));
                    });

                    //新增一行查询条件
                    self.$newSearchBtn.click(function () {

                        $(".f-w-auto").width($(".div-and-or").width());
                        var searcHheight = $(".div-search-height").height();
                        resourceInfoGrid.setHeight(height-(searcHheight+290));
                        var model = self.$searchModel.clone(true);
                        self.$newSearch.append(model);

                        var modelLength = model.find("input");
                        var paramDatas = [0, 1, 2, 3];
                        var dictId = [10, 11, 12, 13];
                        var width = [defaultWidthAndOr, defaultWidth, defaultWidthAndOr, defaultWidth];
                        var cls = '.inp-model';

                        for (var i = 0; i < modelLength.length; i++) {
                            model.find(cls + i).attr('data-attr-scan', paramDatas[i]);
                            var code = 'code';
                            var value = 'value';
                            model.find(cls + i).ligerComboBox({
                                url: paramModel.url[i],
                                valueField: code,
                                textField: value,
                                urlParms: {
                                    dictId: paramModel.dictId[i]
                                },
                                width: width[i],
                                onSelected: function (value) {
                                    var dataModels = this.data;
                                    $(this.element).attr('data-attr-scan', value);
                                    var eleClass_model0 = $(this.element).attr('class').split('inp-model0');
                                    var eleClass_model2 = $(this.element).attr('class').split('inp-model2');
                                    var eleClass_model3 = $(this.element).attr('class').split('inp-model3');
                                    if (eleClass_model0.length >= 2 || eleClass_model2.length >= 2 || eleClass_model3.length >= 2) {
                                        return;
                                    }
                                    for (var i = 0; i < dataModels.length; i++) {
                                        //判断这个对象的值存不存在字典和判断类型
                                        if (Util.isStrEquals(dataModels[i].code, value)) {
                                            var $inpSearchType = $(this.element).parents('.div_search_model').find('.div-new-change-search')
                                            if (!Util.isStrEquals(dataModels[i].dict, 0)) {
                                                changeHtml($inpSearchType, '.inp-find-search', '', 'ligerComboBox', dataModels[i].dict, "");
                                            } else {
                                                switch (dataModels[i].type) {
                                                    case 'S1':
                                                        changeHtml($inpSearchType, '.inp-find-search', '', 'ligerTextBox', '', '');
                                                        break;
                                                    case 'L':
                                                        changeHtml($inpSearchType, '.inp-find-search', '', 'ligerComboBox', 'boolean', '');
                                                        break;
                                                    case 'N':
                                                        changeHtml($inpSearchType, '.inp-find-search', '', 'ligerTextBox', '', '');
                                                        break;
                                                    case 'D':
                                                        changeHtml($inpSearchType, '.inp-find-search', '', 'ligerDateEditor', '', '');
//                                                        changeHtml($inpSearchType, '.inp-find-search', '', 'ligerDateEditor', '', '');
                                                        break;
                                                    case 'DT':
                                                        changeHtml($inpSearchType, '.inp-find-search', '', 'ligerDateEditor', '', '');
                                                        break;
                                                    default:
                                                        changeHtml($inpSearchType, '.inp-find-search', '', 'ligerTextBox', '', '');
                                                        break;
                                                }
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
                        resourceInfoGrid.setHeight(height-(searcHheight+210));
                        $(this).parent().remove();
                    });

                    //检索
                    self.$SearchBtn.click(function () {

                        var jsonData = new Array();
                        var paramDatas = {};
                        var jsonDatass = '';
                        var defaultCondition = self.$defaultCondition;
                        var logicalRelationship = self.$logicalRelationship;
                        var defualtParam = $(".inp_defualt_param");
                        var pModel = $(self.$newSearch).find('.div_search_model');

                        var condition = defaultCondition.attr('data-attr-scan');

                        paramDatas = {
                            field: defaultCondition.attr('data-attr-scan'),
                            condition: logicalRelationship.attr('data-attr-scan'),
                            value: defualtParam.ligerGetComboBoxManager().getValue()
                        }
                        jsonData.push(paramDatas);

                        for (var i = 0; i < pModel.length; i++) {
                            var cModel = $(pModel[i]).find('.inp-find-search');
                            var paramDatass = {
                                andOr: $((cModel)[0]).ligerGetComboBoxManager().getValue(),
                                field: $((cModel)[1]).ligerGetComboBoxManager().getValue(),
                                condition: $((cModel)[2]).ligerGetComboBoxManager().getValue(),
                                value: $((cModel)[3]).ligerGetComboBoxManager().getValue()
                            };
                            jsonData.push(paramDatass);
                        }

                        resourceBrowseMaster.reloadResourcesGrid({
                            searchParams: JSON.stringify(jsonData),
                            resourcesCode: resourcesCode
                        });

                    })

                    //重置
                    self.$resetBtn.click(function () {
                        var defaultCondition = self.$defaultCondition;
                        var logicalRelationship = self.$logicalRelationship;
                        defaultCondition.attr('data-attr-scan', '');
                        logicalRelationship.attr('data-attr-scan', '');

                        $(".inp-reset").val('');
                    })

                    //导出选择结果
                    self.$outSelExcelBtn.click(function () {
                        var rowData = resourceInfoGrid.getSelectedRows();
                        if (rowData.length<=0){
                            return;
                        }
                        var dialog = $.ligerDialog.waitting('正在保存,请稍候...');


                        dataModel.fetchRemote("${contextRoot}/resourceView/outExcel", {
                            data: {rowData: JSON.stringify(rowData), resourceCategoryName: resourceCategoryName},
                            success: function (data) {
                                dialog.close();
                                if (data.successFlg) {
                                    $.Notice.success('保存成功');
                                } else
                                    $.Notice.error("保存失败");
                            }
                        });
                    })

                    //导出全部结果
                    self.$outAllExcelBtn.click(function () {
                        var rowData = resourceInfoGrid.data.detailModelList;
                        if (rowData.length<=0){
                            return;
                        }
                        var dialog = $.ligerDialog.waitting('正在保存,请稍候...');
                        dataModel.fetchRemote("${contextRoot}/resourceView/outExcel", {
                            data: {rowData: JSON.stringify(rowData), resourceCategoryName: resourceCategoryName},
                            success: function (data) {
                                dialog.close();
                                if (data.successFlg) {
                                    $.Notice.success('保存成功');
                                } else
                                    $.Notice.error("保存失败");
                            }
                        });
                    })
                },
            };

            //divEle  input的父节点,（jquery对象）例如：$("#inp_defualt_param")
            //inpEle  输入框input的id或class,例如：#inp_defualt_param
            //defHtml 是否默认搜索条件
            //ligerType liger控件类型
            //dict  是否是字典
            function changeHtml(divEle, inpEle, defHtml, ligerType, dictId, data) {

                var html = '<div class="f-fl"><input type="text" class="f-ml10 inp-reset inp-model3 inp-find-search" /></div>';
                if (Util.isStrEquals(defHtml, 'default')) {

                    html = '<div class="f-fl"><input type="text" data-sttr-scan="3" class="f-ml10 inp-reset inp_defualt_param"/></div>';

                    if (Util.isStrEquals(ligerType, 'ligerDateEditor')) {
                        html += '<div class="f-fr div-time-width"><span class="f-fl f-mt10 f-ml-20">～</span><div style="float: right"><input type="text"  data-sttr-scan="3" class="f-ml10 inp-reset inp_defualt_param"/></div></div>';
                    }

                } else if (Util.isStrEquals(ligerType, 'ligerDateEditor')) {
                    html += '<div class="f-fr div-time-width"><span class="f-fl f-mt10 f-ml-20">～</span><div style="float: right"><input type="text" class="f-ml10 inp-reset inp-model3 inp-find-search" /></div></div>';
                }

                divEle.html("");
                divEle.html(html);
                $(".div-time-width").width($(".div-change-search").width() - defaultWidth - 5);
                switch (ligerType) {
                    case 'ligerComboBox':
                        divEle.find(inpEle).ligerComboBox({
                            url: paramModel.url[3],
                            parms: {dictId: dictId},
                            valueField: 'code',
                            textField: 'name',
                            width: defaultWidth
                        });
                        break;
                    case 'ligerTextBox':
                        divEle.find(inpEle).ligerTextBox({
                            width: defaultWidth
                        });
                        break;
                    case 'ligerDateEditor':
                        divEle.find(inpEle).ligerDateEditor({
                            width: defaultWidth
                        });
                        break;
                }

            }

            /* ************************* 模块初始化结束 ************************** */

            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window)
</script>