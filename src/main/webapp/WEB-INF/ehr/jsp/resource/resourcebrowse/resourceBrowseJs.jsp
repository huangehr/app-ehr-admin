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
            //检索模块初始化
            var paramModel = null;
            var resourceInfoGrid = null;
            var resourceCategoryId = "";
            var resourcesCode = "";
            var columns = null;

            var dataModel = $.DataModel.init();

            /* *************************** 函数定义 ******************************* */
            /**
             * 页面初始化。
             * @type {Function}
             */
            function pageInit() {
                retrieve.init();
                resourceBrowseMaster.bindEvents();
//                resourceBrowseMaster.init();
            }

            function reloadGrid(url, ps) {
                resourceInfoGrid.setOptions({parms: ps});
                resourceInfoGrid.loadData(true);

            }

            /* *************************** 检索模块初始化 ***************************** */

            paramModel = {
                <%--comUrl: '${contextRoot}/resourceBrowse/',--%>

                url: ["${contextRoot}/resourceBrowse/searchDictEntryList",'${contextRoot}/resourceBrowse/getGridCloumnNames',"${contextRoot}/resourceBrowse/searchDictEntryList","${contextRoot}/resourceBrowse/getRsDictEntryList"],
                dictId:['andOr',resourceCategoryId,resourcesCode,''],
                paramDatas: ["",{dictId: resourceCategoryId},"",""],
                field:[{code:'code',value:'value'},{code:'metadataId',value:'name'}],
                andOrData: [{code: 'AND', value: '并且'}, {code: 'OR', value: '或者'}],

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

                $search: $("#inp_search"),
                $newSearch: $("#div_new_search"),

                $newSearchBtn: $("#sp_new_search_btn"),
                $SearchBtn: $("#div_search_btn"),
                $delBtn: $(".sp-del-btn"),
                $resetBtn: $("#div_reset_btn"),
                $outSelExcelBtn: $("#div_out_sel_excel_btn"),
                $outAllExcelBtn: $("#div_out_all_excel_btn"),

                init: function () {
                    var self = this;
                    self.$search.ligerTextBox({
                        width: 240, isSearch: true, search: function (data) {
                            self.getResourceBrowseTree();
                        }
                    });

                    self.initDDL(1, 1,"",self.$defaultCondition, "");
                    self.initDDL(2, 2,"",self.$logicalRelationship, 100);
                    self.initDDL('','',"",self.$defualtParam, 240);

                    self.getResourceBrowseTree();
                },

                //下拉框列表项初始化
                initDDL: function (url, paramDatas,data,target, width) {
                    loadSelect(data,paramModel.field[0].code,paramModel.field[0].value);
                    function loadSelect(data,valueField,textField) {
                        target.ligerComboBox({
                            url: paramModel.url[url],
                            valueField: 'code',
                            textField: 'value',
                            urlParms: {
                                dictId: paramModel.dictId[2],
                            },
                            width: width,
                            onSelected:function (value) {

                                var dataModels = this.data;
                                for (var i = 0; i<dataModels.length;i++){
debugger
                                    //判断这个对象的值存不存在字典和判断类型

                                    if (Util.isStrEquals(dataModels[i].code,value)){
                                        $("#"+this.element.id).attr('data-attr-scan',dataModels[i].code)
                                        if (Util.isStrEquals(this.element.id,'inp_logical_relationship')){
                                            return;
                                        }
                                        if(!Util.isStrEquals(dataModels[i].dict,0)){

                                            changeHtml($(".div-change-search"),'.inp_defualt_param','default','ligerComboBox',dataModels[i].dict,"");
                                            <%--dataModel.fetchRemote("${contextRoot}/resourceBrowse/getRsDictEntryList", {--%>
//                                                data: {dictId: dataModels[i].dictId},
//                                                async:true,
//                                                success: function (data) {
//                                                    changeHtml($(".div-change-search"),$("#inp_defualt_param"),'default','ligerComboBox',dataModels[i].dictId,data.detailModelList);
//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//
//                                                    $("#inp_defualt_param").ligerComboBox({
//                                                        valueField: 'code',
//                                                        textField: 'name',
//                                                        width: 240,
//                                                        data: data.detailModelList
//                                                    });
//                                                }
//                                            });

                                        }else{

                                            switch (dataModels[i].type){
                                                case 'S':
                                                    changeHtml($(".div-change-search"),'.inp_defualt_param','default','ligerTextBox',"","");

//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
                                                    break;
                                                case 'L':
                                                    changeHtml($(".div-change-search"),'.inp_defualt_param','default','ligerComboBox','boolean',"");
//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
                                                    break;
                                                case 'N':
                                                    changeHtml($(".div-change-search"),'.inp_defualt_param','default','ligerTextBox',"","");
//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
                                                    break;
                                                case 'D':
                                                    changeHtml($(".div-change-search"),'.inp_defualt_param','default','ligerDateEditor',"","");
//                                                    changeHtml($(".div-change-search"),'#inp_defualt_param','default','ligerDateEditor',"","");
//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
//                                                    $("#inp_defualt_param").ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                                                    break ;
                                                case 'DT':
                                                    changeHtml($(".div-change-search"),'.inp_defualt_param','default','ligerDateEditor',"","");
//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
//                                                    $("#inp_defualt_param").ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                                                    break ;
                                                default:
                                                    changeHtml($(".div-change-search"),'.inp_defualt_param','default','ligerTextBox',"","");
//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
                                                    break;
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    }
                },

                getResourceBrowseTree: function (data) {
                    var typeTree = this.$resourceBrowseTree.ligerTree({
                        nodeWidth: 260,
                        url: '${contextRoot}/resourceBrowse/searchResource?ids=',
                        isLeaf: function (data) {
                            return !Util.isStrEmpty(data.resourceIds);
                        },
                        delay: function (e) {
                            var data = e.data;
                            return {url: '${contextRoot}/resourceBrowse/searchResource?ids=' + data.id}
                        },
                        checkbox: false,
                        isExpand: function (e) {
                        },
                        idFieldName: 'id',
                        parentIDFieldName:'pid',
                        textFieldName: 'name',

                        onSelect: function (data) {
                            resourceCategoryId = data.data.resourceIds;
                            resourcesCode = data.data.resourceCode;

                            if(Util.isStrEmpty(resourceCategoryId)){
                                return;
                            }
                            paramModel.dictId[1] = resourceCategoryId;
                            paramModel.dictId[2] = resourcesCode;
                            dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {
//                                data: {dictId: resourceCategoryId},
                                data: {dictId: resourcesCode},
                                success: function (data) {
                                    debugger
                                    retrieve.$defaultCondition.ligerComboBox({
                                        valueField: 'code',
                                        textField: 'value',
                                        width: 240,
                                        data:data,
                                    });
                                }
                            });
                            debugger
                            resourceBrowseMaster.init(resourceCategoryId,resourcesCode);
                        },
                        onSuccess: function (data) {
                            resourceBrowseMaster.init(data[0].id);
                            $("#div_resource_browse_tree li div span").css({
                                "line-height": "22px",
                                "height": "22px"
                            });
                        },
                    });
                },
            };
            resourceBrowseMaster = {
                init: function (objectId,resourcesCode) {
                    var self = retrieve;
                    var columnModel = new Array();
                    //获取列名
                    if (!Util.isStrEmpty(objectId)) {
                        dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {
                            data: {
                                dictId: objectId
                            },
                            success: function (data) {

                                for (var i = 0; i < data.length; i++) {
                                    columnModel.push({display: data[i].value, name: data[i].code,width:100});
                                }
                                resourceInfoGrid = self.$resourceInfoGrid.ligerGrid($.LigerGridEx.config({
                                    url: '${contextRoot}/resourceBrowse/searchResourceData',
                                    parms: {searchParams: '',resourcesCode:resourcesCode},
                                    columns: columnModel,
                                    height:680,
                                    checkbox:true,
                                }));
                            }
                        });
                    }
                },
                reloadResourcesGrid: function (searchParams) {
                    reloadGrid.call(this, '${contextRoot}/resourceBrowse/searchResourceData',searchParams);
                },

                bindEvents: function () {

                    var self = retrieve;

                    //新增一行查询条件
                    self.$newSearchBtn.click(function () {
                        var model = self.$searchModel.clone(true);
                        self.$newSearch.append(model);

                        var modelLength = model.find("input");
                        var paramDatas = [0, 1, 2, 3];
                        var dictId = [10, 11, 12, 13];
                        var width = [100, 240, 100, 240];
                        var cls = '.inp-model';

                        for (var i = 0; i < modelLength.length; i++) {
                            model.find(cls + i).attr('data-attr-scan', paramDatas[i]);
//                            self.initDDL(i,i,"", model.find(cls + i), width[i]);

                            var code = 'code';
                            var value = 'value';
//                            if (Util.isStrEquals(i,1)){
//                                 code = 'metadataId';
//                                 value = 'name';
//                            }
                            model.find(cls + i).ligerComboBox({
                                url:paramModel.url[i],
                                valueField: code,
                                textField: value,
                                urlParms: {
                                    dictId: paramModel.dictId[i],
                                },
                                width: width[i],
                                onSelected:function (value) {
                                    var dataModels = this.data;
                                    $(this.element).attr('data-attr-scan',value);
//                                    if($('.inp-model0')[0] == this.element||$('.inp-model2')[0] == this.element||$('.inp-model3')[0] == this.element){
//                                        return;
//                                    }
                                    for (var i = 0; i<dataModels.length;i++){
                                        //判断这个对象的值存不存在字典和判断类型

                                        if (Util.isStrEquals(dataModels[i].code,value)) {
                                            var $inpSearchType = $(this.element).parents('.div_search_model').find('.div-new-change-search')
                                            if (!Util.isStrEquals(dataModels[i].dict, 0)) {

//                                                            var $inpSearchType = $(this.element).parents('.div_search_model').find('.div-new-change-search')

                                                changeHtml($inpSearchType, '.inp-find-search', '', 'ligerComboBox', dataModels[i].dict, "");
//                                                        $inpSearchType.html("");
//                                                        $(this.element).parents('.div_search_model').find('.div-new-change-search').html("");
//                                                        var $inpSearchType = $($(".div-new-change-search")[0]);
//                                                        $inpSearchType.html('<input type="text" class="f-ml10 inp-reset inp-model3 inp-find-search">')
//                                                        if(!Util.isStrEquals(dataModels[i].dictId,0)){

                                                <%--dataModel.fetchRemote("${contextRoot}/resourceBrowse/getRsDictEntryList", {--%>
                                                <%--data: {dictId: dataModels[i].dictId},--%>
                                                <%--success: function (data) {--%>
                                                <%--debugger--%>
                                                <%--$inpSearchType.find('.inp-find-search').ligerComboBox({--%>
                                                <%--valueField: 'code',--%>
                                                <%--textField: 'name',--%>
                                                <%--width: 240,--%>
                                                <%--data: data.detailModelList--%>
                                                <%--});--%>
                                                <%--}--%>
                                                <%--});--%>
//                                                        }else{
//
//                                                        }

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
                            <%--if (!Util.isStrEmpty(paramModel.url[i])) {--%>
                                <%--dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {--%>
                                    <%--data: {resourceCategoryId: resourceCategoryId},--%>
                                    <%--async:false,--%>
                                    <%--success: function (data) {--%>
                                        <%--model.find(cls + i).ligerComboBox({--%>
                                            <%--valueField: 'metadataId',--%>
                                            <%--textField: 'name',--%>
                                            <%--width: width[i],--%>
                                            <%--data: data.detailModelList,--%>
                                            <%--onSelected:function (value) {--%>

                                                <%--var dataModels = this.data;--%>
                                                <%--for (var i = 0; i<dataModels.length;i++){--%>

                                                    <%--debugger--%>
                                                    <%--//判断这个对象的值存不存在字典和判断类型--%>
                                                    <%--if (Util.isStrEquals(dataModels[i].metadataId,value)) {--%>
                                                        <%--var $inpSearchType = $(this.element).parents('.div_search_model').find('.div-new-change-search')--%>

                                                        <%--if (!Util.isStrEquals(dataModels[i].dictId, 0)) {--%>

<%--//                                                            var $inpSearchType = $(this.element).parents('.div_search_model').find('.div-new-change-search')--%>

                                                            <%--changeHtml($inpSearchType, '.inp-find-search', '', 'ligerComboBox', dataModels[i].dictId, "");--%>
<%--//                                                        $inpSearchType.html("");--%>
<%--//                                                        $(this.element).parents('.div_search_model').find('.div-new-change-search').html("");--%>
<%--//                                                        var $inpSearchType = $($(".div-new-change-search")[0]);--%>
<%--//                                                        $inpSearchType.html('<input type="text" class="f-ml10 inp-reset inp-model3 inp-find-search">')--%>
<%--//                                                        if(!Util.isStrEquals(dataModels[i].dictId,0)){--%>

                                                            <%--&lt;%&ndash;dataModel.fetchRemote("${contextRoot}/resourceBrowse/getRsDictEntryList", {&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;data: {dictId: dataModels[i].dictId},&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;success: function (data) {&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;debugger&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;$inpSearchType.find('.inp-find-search').ligerComboBox({&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;valueField: 'code',&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;textField: 'name',&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;width: 240,&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;data: data.detailModelList&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;});&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;}&ndash;%&gt;--%>
                                                            <%--&lt;%&ndash;});&ndash;%&gt;--%>
<%--//                                                        }else{--%>
<%--//--%>
<%--//                                                        }--%>

                                                        <%--} else {--%>
                                                            <%--switch (dataModels[i].columnType) {--%>
                                                                <%--case 'S1':--%>
                                                                    <%--changeHtml($inpSearchType, '.inp-find-search', '', 'ligerTextBox', '', '');--%>
                                                                    <%--break;--%>
                                                                <%--case 'L':--%>
                                                                    <%--changeHtml($inpSearchType, '.inp-find-search', '', 'ligerComboBox', 'boolean', '');--%>
                                                                    <%--break;--%>
                                                                <%--case 'N':--%>
                                                                    <%--changeHtml($inpSearchType, '.inp-find-search', '', 'ligerTextBox', '', '');--%>
                                                                    <%--break;--%>
                                                                <%--case 'D':--%>
                                                                    <%--changeHtml($inpSearchType, '.inp-find-search', '', 'ligerDateEditor', '', '');--%>
                                                                    <%--break;--%>
                                                                <%--case 'DT':--%>
                                                                    <%--changeHtml($inpSearchType, '.inp-find-search', '', 'ligerDateEditor', '', '');--%>
                                                                    <%--break;--%>
                                                                <%--default:--%>
                                                                    <%--changeHtml($inpSearchType, '.inp-find-search', '', 'ligerTextBox', '', '');--%>
                                                                    <%--break;--%>
                                                            <%--}--%>
                                                        <%--}--%>
                                                    <%--}--%>
                                                <%--}--%>
                                            <%--}--%>
                                        <%--});--%>
                                    <%--}--%>
                                <%--});--%>
                            <%--} else {--%>
//                                var data = null;
//
//                                if (Util.isStrEquals(i,0)){
//                                    data = paramModel.andOrData;
//                                }
//                                if (Util.isStrEquals(i,2)){
//                                    data = paramModel.searchType;
//                                }

//                                model.find(cls + i).ligerComboBox({
//                                    valueField: paramModel.field[0].code,
//                                    textField: paramModel.field[0].value,
//                                    width: width[i],
//                                    data: data
//                                });
//                            }
                        }
                        model.show();

                    });
                    //删除一行查询条件
                    self.$delBtn.click(function () {
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

                        var condition = defaultCondition.attr('data-attr-scan')

                        paramDatas = {
                            field:defaultCondition.attr('data-attr-scan'),
                            condition:logicalRelationship.attr('data-attr-scan'),
                            value:defualtParam.val()
                        }
//                        jsonDatass = "[{field:"+defaultCondition.attr('data-attr-scan')+",condition:"+logicalRelationship.attr('data-attr-scan')+",value:"+defualtParam.val()+"},";
                        jsonData.push(paramDatas);
//                        paramDatas = defaultCondition.attr('data-attr-scan') + logicalRelationship.attr('data-attr-scan') + defualtParam.val();

                        for (var i = 0; i < pModel.length; i++) {
                            var cModel = $(pModel[i]).find('.inp-find-search');
//                            $(pModel[0]).find('.inp-find-search').length
//                            for (var j = 0; j < cModel.length; j++) {
//                                var params = $((cModel)[j]);
//                        var params = $((cModel)[0]);


//                                paramDatas = {
//                                    andOr:params.ligerGetComboBoxManager().getValue(),
//                                    field:defaultCondition.attr('data-attr-scan'),
//                                    condition:logicalRelationship.attr('data-attr-scan'),
//                                    value:defualtParam.val()
//                                }
//                                jsonData.push(paramDatas);


//                                [{"andOr":"AND","field":"字段名","condition":"=","value":"值"}]
//                                if (Util.isStrEquals(j%4,0)){
//                                    jsonData += " ";
//                                }

//                                jsonData += params.attr('data-attr-scan') + params.ligerGetComboBoxManager().getValue();
                                var paramDatass = {
                                    andOr:$((cModel)[0]).ligerGetComboBoxManager().getValue(),
                                    field:$((cModel)[1]).ligerGetComboBoxManager().getValue(),
                                    condition:$((cModel)[2]).ligerGetComboBoxManager().getValue(),
                                    value:$((cModel)[3]).ligerGetComboBoxManager().getValue(),
                                };
                        jsonData.push(paramDatass);
//                                paramDatass
//                                switch (j){
//                                    case 0:
//                                        paramDatass.andOr = params.ligerGetComboBoxManager().getValue();
//                                        jsonDatass += "[{andOr:";
//                                        break;
//                                    case 1:
//                                        paramDatass.field = params.ligerGetComboBoxManager().getValue();
//                                        jsonDatass += "field:";
//                                        break;
//                                    case 2:
//                                        paramDatass.condition = params.ligerGetComboBoxManager().getValue();
//                                        jsonDatass += "condition:";
//                                        break;
//                                    case 3:
//                                        paramDatass.value = params.ligerGetComboBoxManager().getValue();
//                                        jsonData.push(paramDatass);
//                                        jsonDatass += "value:";
//                                        break;
//                                }

//                                if (Util.isStrEquals(j%4,0)&&!Util.isStrEquals(j,0)){

//                                    jsonDatass += params.ligerGetComboBoxManager().getValue()+"}]";
//                                    jsonData.push(jsonDatass);
//                                    jsonDatass = "";

//                                }
//                                else{
//                                    jsonDatass += params.ligerGetComboBoxManager().getValue()+",";
//                                }
//                            }

                        }

                        resourceBrowseMaster.reloadResourcesGrid({searchParams:JSON.stringify(jsonData),resourcesCode:resourcesCode});

                    })

                    //重置
                    self.$resetBtn.click(function () {
                        $(".inp-reset").val('');
                    })
                },
            };

            //divEle  input的父节点,（jquery对象）例如：$("#inp_defualt_param")
            //inpEle  输入框input的id或class,例如：#inp_defualt_param
            //defHtml 是否默认搜索条件
            //ligerType liger控件类型
            //dict  是否是字典
            function changeHtml(divEle,inpEle,defHtml,ligerType,dictId,data) {

                var html = '<div class="f-fl"><input type="text" class="f-ml10 inp-reset inp-model3 inp-find-search" /></div>';
                if(Util.isStrEquals(defHtml,'default')){

                    html = '<div class="f-fl"><input type="text" data-sttr-scan="3" class="f-ml10 inp-reset inp_defualt_param"/></div>';

                    if (Util.isStrEquals(ligerType,'ligerDateEditor')){
                        html += '<div class="f-fr f-ml30"><span class="f-fl f-mt10 f-ml-20">～</span><input type="text"  data-sttr-scan="3" class="f-ml10 inp-reset inp_defualt_param"/></div>';
                    }

                }else if (Util.isStrEquals(ligerType,'ligerDateEditor')){
                    html += '<div class="f-fr f-ml30"><span class="f-fl f-mt10 f-ml-20">～</span><input type="text" class="f-ml10 inp-reset inp-model3 inp-find-search" /></div>';
                }

                divEle.html("");
                divEle.html(html);
                switch (ligerType){
                    case 'ligerComboBox':
                        divEle.find(inpEle).ligerComboBox({
                            url:paramModel.url[3],
                            parms: {dictId: dictId},
                            valueField: 'code',
                            textField: 'name',
                            width: 240,
                        });
                        break;
                    case 'ligerTextBox':
                        divEle.find(inpEle).ligerTextBox({
                            valueField: 'code',
                            textField: 'name',
                            width: 240,
                        });
                        break;
                    case 'ligerDateEditor':
                        divEle.find(inpEle).ligerDateEditor({
                            valueField: 'code',
                            textField: 'name',
                            width: 240,
                        });
                        break;
                }

            }

            /* ************************* 模块初始化结束 ************************** */


            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window);
</script>