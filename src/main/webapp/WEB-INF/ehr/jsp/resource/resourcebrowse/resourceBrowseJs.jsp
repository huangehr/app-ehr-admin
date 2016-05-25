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

            var resourceInfoGrid = null;

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

                //获取列名
                dataModel.fetchRemote("${contextRoot}/user/searchUsers", {
                    data: {
                        searchNm: '',
                        searchType: '',
                        page: 1,
                        rows: 15,
                    },
                    success: function (data) {
                        var columnModel;
                        for (var i = 0;i<data.detailModelList.length;i++){
//                            columnModel.
                        }
                    }
                });

            }

            function reloadGrid(url, params) {

                resourceInfoGrid.setOptions({parms: params});
                resourceInfoGrid.loadData(true);

            }


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

                    self.$search.ligerTextBox({width: 240, isSearch: true,});

                    self.initDDL(37, self.$defaultCondition);
                    self.initDDL(38, self.$logicalRelationship);
                    self.initDDL(37, self.$defualtParam);

                    self.getResourceBrowseTree();
                },

                //下拉框列表项初始化
                initDDL: function (dictId, target) {
                    dataModel.fetchRemote("${contextRoot}/dict/searchDictEntryList", {
                        data: {dictId: dictId},
                        success: function (data) {
                            target.ligerComboBox({
                                valueField: 'code',
                                textField: 'value',
                                data: data.detailModelList
                            });
                        }
                    });
                },

                getResourceBrowseTree: function () {
                    var typeTree = this.$resourceBrowseTree.ligerTree({
                        nodeWidth: 260,
                        url: '${contextRoot}/cdatype/getCDATypeListByParentId?ids=',
                        isLeaf: function (data) {
                        },
                        delay: function (e) {
                            var data = e.data;
                            return {url: '${contextRoot}/cdatype/getCDATypeListByParentId?ids=' + data.id}
                        },
                        checkbox: false,
                        idFieldName: 'id',
                        textFieldName: 'name',

                        onSelect: function (data) {
                            resourceBrowseMaster.init(data.data.id);
                        },
                        onSuccess: function (data) {
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

                    resourceInfoGrid = self.$resourceInfoGrid.ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/resourceBrowse/searchResource',
                        parms:{
                            searchNm: objectId,
                        },
                        columns: [
                            {name: 'id', hide: true, isAllowHide: false},
                            {display: '用户类型', name: 'userTypeName', width: '10%', align: 'left'},

                        ],
                    }));

                    this.bindEvents();

                },
                reloadResourcesGrid: function () {
                    reloadGrid.call(this, '${contextRoot}/resourceBrowse/searchResource', "");
//                    resourceBrowseMaster.init();
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
                        var cls = '.inp-model';

                        for (var i = 0; i < modelLength.length; i++) {
                            model.find(cls + i).attr('data-attr-scan', paramDatas[i]);
                            self.initDDL(dictId[i], model.find(cls + i));
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

                        var jsonData = defaultCondition.attr('data-attr-scan')+logicalRelationship.val()+defualtParam.val();

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