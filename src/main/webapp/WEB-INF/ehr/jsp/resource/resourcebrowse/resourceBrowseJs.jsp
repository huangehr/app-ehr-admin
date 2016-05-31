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
                resourceBrowseMaster.init();

            }

            function reloadGrid(url, params) {

                resourceInfoGrid.setOptions({parms: params});
                resourceInfoGrid.loadData(true);

            }

            /* *************************** 检索模块初始化 ***************************** */

            paramModel = {
                comUrl: '${contextRoot}/resourceBrowse/',

                url: ["",this.comUrl + 'getGridCloumnNames',"",""],
                paramDatas: ["",{resourceCategoryId: resourceCategoryId},"",""],
                field:[{code:'code',value:'value'},{code:'metadataId',value:'name'}],
                andOrData: [{code: 'AND', value: '并且'}, {code: 'OR', value: '或者'}],
                searchType: [
                    {code: '=', value: '等于'},
                    {code: '!=', value: '不等于'},
                    {code: '>', value: '大于'},
                    {code: '>=', value: '大于等于'},
                    {code: '<', value: '小于'},
                    {code: '<=', value: '小于等于'},
                    {code: 'LIKE', value: '包含'},
                    {code: '><', value: '介于'},
                    {code: '<>', value: '不介于'}
                ]

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
                    self.initDDL(2, 2,paramModel.searchType,self.$logicalRelationship, 100);
                    self.initDDL(0, 0,"",self.$defualtParam, 240);

                    self.getResourceBrowseTree();
                },

                //下拉框列表项初始化
                initDDL: function (url, paramDatas,data,target, width) {
//                    dict/searchDictEntryList
                    <%--if (!Util.isStrEmpty(paramModel.url[url])) {--%>
                        <%--debugger--%>
                        <%--dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {--%>
                            <%--data: {resourceCategoryId: resourceCategoryId},--%>
                            <%--success: function (data) {--%>
                                <%--debugger--%>
                                <%--loadSelect(data.detailModelList,paramModel.field[1].code,paramModel.field[1].value);--%>
                            <%--}--%>
                        <%--});--%>
                    <%--} else {--%>
                        <%--debugger--%>
                        <%--loadSelect(data,paramModel.field[0].code,paramModel.field[0].value);--%>
                    <%--}--%>

                    loadSelect(data,paramModel.field[0].code,paramModel.field[0].value);
                    function loadSelect(data,valueField,textField) {
                        target.ligerComboBox({
                            valueField: valueField,
                            textField: textField,
                            width: width,
                            data: data
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
                                async:true,
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

                    self.$defaultCondition.bind('input propertychange',function () {

                        debugger
                        this.val();
                    })
                    var columnModel = new Array();

                    //获取列名
                    if (!Util.isStrEmpty(objectId)) {
                        dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {
                            async: true,
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
                    }
                    this.bindEvents();

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
                                debugger
                                dataModel.fetchRemote("${contextRoot}/resourceBrowse/getGridCloumnNames", {
                                    data: {resourceCategoryId: resourceCategoryId},
                                    async:false,
                                    success: function (data) {
                                        debugger
                                        model.find(cls + i).ligerComboBox({
                                            valueField: 'metadataId',
                                            textField: 'name',
                                            width: width[i],
                                            data: data.detailModelList
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

            /* ************************* 模块初始化结束 ************************** */


            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window);
</script>