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

            function reloadGrid(url, params) {

                resourceInfoGrid.setOptions({parms: params});
                resourceInfoGrid.loadData(true);

            }

            /* *************************** 检索模块初始化 ***************************** */

            paramModel = {
                <%--comUrl: '${contextRoot}/resourceBrowse/',--%>

                url: ["",'${contextRoot}/resourceBrowse/getGridCloumnNames',"${contextRoot}/resourceBrowse/searchDictEntryList","${contextRoot}/resourceBrowse/getRsDictEntryList"],
                dictId:[34,""],
                paramDatas: ["",{resourceCategoryId: resourceCategoryId},"",""],
                field:[{code:'code',value:'value'},{code:'metadataId',value:'name'}],
                andOrData: [{code: 'AND', value: '并且'}, {code: 'OR', value: '或者'}],

            }

            /* *************************** 检索模块初始化结束 ***************************** */


            /* *************************** 模块初始化 ***************************** */
            retrieve = {

                $resourceBrowseTree: $("#div_resource_browse_tree"),
                $defaultCondition: $("#inp_default_condition"),
                $logicalRelationship: $("#inp_logical_relationship"),
                $defualtParam: $("#inp_defualt_param"),
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
                    self.initDDL(0, 0,"",self.$defualtParam, 240);

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
                                dictId: paramModel.dictId[0],
                            },
                            width: width,
//                            data: data,
                            onSelected:function (value) {
                                var dataModels = this.data;
                                for (var i = 0; i<dataModels.length;i++){

                                    //判断这个对象的值存不存在字典和判断类型
                                    if (Util.isStrEquals(dataModels[i].metadataId,value)){
                                        if(!Util.isStrEquals(dataModels[i].dictId,0)){
                                            debugger
                                            changeHtml($(".div-change-search"),$("#inp_defualt_param"),'default','ligerComboBox',dataModels[i].dictId,data.detailModelList);

                                            <%--dataModel.fetchRemote("${contextRoot}/resourceBrowse/getRsDictEntryList", {--%>
//                                                data: {dictId: dataModels[i].dictId},
//                                                async:true,
//                                                success: function (data) {
//                                                    debugger
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

                                            switch (dataModels[i].columnType){
                                                case 'S':
                                                    changeHtml($(".div-change-search"),$("#inp_defualt_param"),'default','ligerTextBox',"","");

//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
                                                    break;
                                                case 'L':
                                                    changeHtml($(".div-change-search"),$("#inp_defualt_param"),'default','ligerComboBox','boolean',"");
//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
                                                    break;
                                                case 'N':
                                                    changeHtml($(".div-change-search"),$("#inp_defualt_param"),'default','ligerTextBox',"","");
//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
                                                    break;
                                                case 'D':
                                                    changeHtml($(".div-change-search"),$("#inp_defualt_param"),'default','ligerDateEditor',"","");
//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
//                                                    $("#inp_defualt_param").ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                                                    break ;
                                                case 'DT':
                                                    changeHtml($(".div-change-search"),$("#inp_defualt_param"),'default','ligerDateEditor',"","");
//                                                    $(".div-change-search").html("");
//                                                    $(".div-change-search").html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
//                                                    $("#inp_defualt_param").ligerTextBox({width: 240})
//                                                    $("#inp_defualt_param").ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                                                    break ;
                                                default:
                                                    changeHtml($(".div-change-search"),$("#inp_defualt_param"),'default','ligerTextBox',"","");
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
                        },
                        delay: function (e) {
                            var data = e.data;
                            return {url: '${contextRoot}/resourceBrowse/searchResource?ids=' + data.id}
                        },
                        checkbox: false,
                        isExpand: function (e) {
                        },
                        idFieldName: 'id',
                        textFieldName: 'name',

                        onSelect: function (data) {
                            resourceCategoryId = data.data.id
                            dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {
                                data: {resourceCategoryId: resourceCategoryId},
                                success: function (data) {
                                    retrieve.$defaultCondition.ligerComboBox({
                                        valueField: 'metadataId',
                                        textField: 'name',
                                        width: 240,
                                        data: data.detailModelList
                                    });
                                }
                            });
                            resourceBrowseMaster.init(resourceCategoryId);
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
                init: function (objectId) {
                    var self = retrieve;
                    var columnModel = new Array();

                    //获取列名
                    if (!Util.isStrEmpty(objectId)) {
                        dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {
//                            async: true,
                            data: {
                                resourceCategoryId: objectId
                            },
                            success: function (data) {
                                var dataList = data.detailModelList;

                                for (var i = 0; i < dataList.length; i++) {
                                    columnModel.push({display: dataList[i].name, name: 'name', width: '10%'});
                                }
                                resourceInfoGrid = self.$resourceInfoGrid.ligerGrid($.LigerGridEx.config({
                                    url: '${contextRoot}/resourceBrowse/searchResource',
                                    parms: {ids: objectId},
                                    columns: columnModel,
                                }));
                            }
                        });
//                        this.bindEvents();
                    }


                },
                reloadResourcesGrid: function () {
                    reloadGrid.call(this, '${contextRoot}/resourceBrowse/searchResource', "");
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

                            if (!Util.isStrEmpty(paramModel.url[i])) {
                                dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {
                                    data: {resourceCategoryId: resourceCategoryId},
                                    async:false,
                                    success: function (data) {
                                        model.find(cls + i).ligerComboBox({
                                            valueField: 'metadataId',
                                            textField: 'name',
                                            width: width[i],
                                            data: data.detailModelList,
                                            onSelected:function (value) {

                                                var dataModels = this.data;
                                                for (var i = 0; i<dataModels.length;i++){

                                                    //判断这个对象的值存不存在字典和判断类型
                                                    if (Util.isStrEquals(dataModels[i].metadataId,value)){

                                                        debugger
                                                        var $inpSearchType =  $(this.element).parents('.div_search_model').find('.div-new-change-search')
                                                        $inpSearchType.html("");
//                                                        $(this.element).parents('.div_search_model').find('.div-new-change-search').html("");
//                                                        var $inpSearchType = $($(".div-new-change-search")[0]);
                                                        $inpSearchType.html('<input type="text" class="f-ml10 inp-reset inp-model3 inp-find-search">')
                                                        debugger
                                                        if(!Util.isStrEquals(dataModels[i].dictId,0)){

                                                            dataModel.fetchRemote("${contextRoot}/resourceBrowse/getRsDictEntryList", {
                                                                data: {dictId: dataModels[i].dictId},
                                                                success: function (data) {
                                                                    debugger
                                                                    $inpSearchType.find('.inp-find-search').ligerComboBox({
                                                                        valueField: 'code',
                                                                        textField: 'name',
                                                                        width: 240,
                                                                        data: data.detailModelList
                                                                    });
                                                                }
                                                            });
                                                        }else{
                                                            switch (dataModels[i].columnType){
                                                                case 'S1':
                                                                    $inpSearchType.html("");
                                                                    $inpSearchType.html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
                                                                    $inpSearchType.find('.inp-find-search').ligerTextBox({width: 240})
                                                                    break;
                                                                case 'L':
                                                                    $inpSearchType.html("");
                                                                    $inpSearchType.html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
                                                                    $inpSearchType.find('.inp-find-search').ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                                                                    break ;
                                                                case 'N':
                                                                    $inpSearchType.html("");
                                                                    $inpSearchType.html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
                                                                    $inpSearchType.find('.inp-find-search').ligerTextBox({width: 240})
                                                                    break;
                                                                case 'D':
                                                                    $inpSearchType.html("");
                                                                    $inpSearchType.html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
                                                                    $inpSearchType.find('.inp-find-search').ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                                                                    break ;
                                                                case 'DT':
                                                                    $inpSearchType.html("");
                                                                    $inpSearchType.html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
                                                                    $inpSearchType.find('.inp-find-search').ligerDateEditor({format:'yyyy-MM-dd hh:mm:ss',showTime: true,labelWidth: 50, labelAlign: 'center',absolute:false,cancelable:true});
                                                                    break ;
                                                                default:
                                                                    $inpSearchType.html("");
                                                                    $inpSearchType.html('<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>');
                                                                    $inpSearchType.find('.inp-find-search').ligerTextBox({width: 240})
                                                                    break;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        });
                                    }
                                });
                            } else {
                                var data = null;

                                if (Util.isStrEquals(i,0)){
                                    data = paramModel.andOrData;
                                }
                                if (Util.isStrEquals(i,2)){
                                    data = paramModel.searchType;
                                }

                                model.find(cls + i).ligerComboBox({
                                    valueField: paramModel.field[0].code,
                                    textField: paramModel.field[0].value,
                                    width: width[i],
                                    data: data
                                });
                            }
                        }



                        model.show();

                    });
                    //删除一行查询条件
                    self.$delBtn.click(function () {
                        $(this).parent().remove();
                    });

                    //检索
                    self.$SearchBtn.click(function () {

                        var defaultCondition = self.$defaultCondition;
                        var logicalRelationship = self.$logicalRelationship;
                        var defualtParam = self.$defualtParam;
                        var pModel = $(self.$newSearch).find('.div_search_model');

                        var jsonData = defaultCondition.attr('data-attr-scan') + logicalRelationship.val() + defualtParam.val();

                        for (var i = 0; i < pModel.length; i++) {
                            var cModel = pModel.find('.inp-find-search');
                            for (var j = 0; j < cModel.length; j++) {
                                var params = $((cModel)[j]);
                                jsonData += params.attr('data-attr-scan') + params.ligerGetComboBoxManager().getValue();
                            }

                        }

                        resourceBrowseMaster.reloadResourcesGrid();

                    })

                    //重置
                    self.$resetBtn.click(function () {
                        $(".inp-reset").val('');
                    })
                },
            };

            //divEle  input的父节点,（jquery对象）例如：$("#inp_defualt_param")
            //inpEle  输入框input的id或class,（jquery对象）例如：$("#inp_defualt_param")
            //defHtml 是否默认搜索条件
            //ligerType liger控件
            //dict  是否是字典
            function changeHtml(divEle,inpEle,defHtml,ligerType,dictId,data) {

                debugger
                var html = '';
                if(Util.isStrEquals(defHtml,'default')){
                    html = '<input type="text" id="inp_defualt_param" data-sttr-scan="3" class="f-ml10 inp-reset"/>';
                }else {
                    html = '<input type="text" class="f-ml10 inp-reset inp-model3 inp-find-search>';
                }
                divEle.html("");
                divEle.html(html);
                switch (ligerType){
                    case 'ligerComboBox':
                        divEle.find("#inp_defualt_param").ligerComboBox({
                            url:paramModel.url[3],
                            parms: {dictId: dictId},
                            valueField: 'code',
                            textField: 'name',
                            width: 240,
//                            data:paramModel.andOrData,
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