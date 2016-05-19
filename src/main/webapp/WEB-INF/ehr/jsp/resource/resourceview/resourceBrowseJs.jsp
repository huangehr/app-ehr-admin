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
            var master = null;

            var dataModel = $.DataModel.init();


            /* *************************** 函数定义 ******************************* */
            /**
             * 页面初始化。
             * @type {Function}
             */
            function pageInit() {
                retrieve.init();
                master.init();
            }


            /* *************************** 模块初始化 ***************************** */
            retrieve = {

                $resourceBrowseTree: $("#div_resource_browse_tree"),
                $defaultCondition: $("#inp_default_condition"),
                $logicalRelationship: $("#inp_logical_relationship"),
                $defualtParam: $("#inp_defualt_param"),
                $searchModel: $(".div_search_model"),


                $search: $("#inp_search"),
                $newSearch: $("#div_new_search"),


                $newSearchBtn: $("#sp_new_search_btn"),
                $SearchBtn: $("#div_search_btn"),
                $delBtn: $(".sp-del-btn"),

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
//                    var target = $(target);
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
                        url: '${contextRoot}/cdatype/getCDATypeListByParentId?ids=',//参数ids值为测试值
                        isLeaf: function (data) {
//                            debugger
//                            if (!data) return false;
//                            return data.type == "employee";
                        },
                        delay: function (e) {

                            var data = e.data;
                            return {url: '${contextRoot}/cdatype/getCDATypeListByParentId?ids=' + data.id}
                        },
                        checkbox: false,
                        idFieldName: 'id',
                        textFieldName: 'name',
                        slide: false,
                        onSelect: function (data) {

                        },
                        onSuccess: function (data) {
                            $("#div_resource_browse_tree li div span").css({
                                "line-height": "22px",
                                "height": "22px"
                            });
                        }

                    });
                },

            };
            master = {

                init:function () {

                    this.bindEvents();

                },
                bindEvents:function () {

                    var self = retrieve;

                    self.$newSearchBtn.click(function () {
                        var model = self.$searchModel.clone(true);
                        self.$newSearch.append(model);

                        var modelLength = model.find("input");
                        var paramDatas = [1,2,3,4];
                        var dictId = [10,11,12,13];
                        var cls = '.inp-model';

                        for (var i = 0;i< modelLength.length ; i++){
                            model.find(cls+i).attr('data-attr-scan',paramDatas[i]);
                            self.initDDL(dictId[i], model.find(cls+i));
                        }


//                        model.find(".inp-model1").attr("data-attr-scan",(new Date()).valueOf());
//                        model.find(".inp-model2").attr("data-attr-scan",(new Date()).valueOf());
//                        model.find(".inp-model3").attr("data-attr-scan",(new Date()).valueOf());
//                        model.find(".inp-model4").attr("data-attr-scan",(new Date()).valueOf());
////                        self.$newSearch.append(model);
//                        self.initDDL(37, model.find(".inp-model1"));
//                        self.initDDL(37, model.find(".inp-model2"));
//                        self.initDDL(37, model.find(".inp-model3"));
//                        self.initDDL(37, model.find(".inp-model4"));
                        model.show();
//                        model.children('span').attr('id',(new Date()).valueOf());
//                        for (var i = 0;i<model.find('input').length;i++){
//                            model.find('input')[i].id = (new Date().valueOf());
//                            debugger
//
//                        }
//                        self.$newSearch.append(model);
//                        self.initDDL(37, $("#"+model.find('input')[i].id));
                    });
                    self.$delBtn.click(function () {
                        $(this).parent().remove();
                    });

                    self.$SearchBtn.click(function () {
                        var pModel = $(self.$newSearch).find('.div_search_model');
                        var jsonData = "";
                        for (var i = 0;i<pModel.length;i++){
                            var cModel = pModel.find('.inp-find-search');
                            for (var j = 0;j<cModel.length;j++){
                                var params = $((cModel)[j]);
                                jsonData += params.attr('data-attr-scan')+params.ligerGetComboBoxManager().getValue();
                            }
                            debugger
                        }
//                        $(self.$newSearch.find('.inp-find-search')[0]).ligerGetComboBoxManager().getValue()

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