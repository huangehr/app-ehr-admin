<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript">
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            // 页面表格条件部模块
            var retrieve = null;
            // 页面主模块，对应于用户信息表区域
            var master = null;

            var addRowDatas = new Array();
            var delRowDatas = new Array();

            var comUrl = '${contextRoot}/resourceConfiguration';
            var resourceConfigurationUrl = [comUrl + '/searchResourceconfiguration',comUrl + '/searchSelResourceconfiguration?resourcesId=testId']
            var elmParams = ['resourceConfigurationInfoGrid','resourceConfigurationInfoGridTrue'];

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

            function getResource(page,size) {
                dataModel.fetchRemote(resourceConfigurationUrl[1], {
                    data: {searchNm: "",page:page,rows:size},
//                    async: true,
                    success: function (data) {
                        if(Util.isStrEquals(data.obj.id,row.id)){
                            return true;
                        }else {
                            return false;
                        }
                    }
                })
            }
            function reloadGrid(url, params, searchType) {
                var grif = null;
                if (Util.isStrEquals(searchType, "mateData"))
                    grif = elmParams[0];
                else
                    grif = elmParams[1];

                grif.options.newPage = 1;
                grif.setOptions({parms: params});
                grif.loadData(true);

            }

            /* *************************** 模块初始化 ***************************** */
            retrieve = {

                $mateDataSearch: $("#inp_mateData_search"),
                $mateDataSearchTrue: $("#inp_mateData_search_true"),
                $resourceConfigurationInfoGridTrue: $("#div_resource_configuration_info_grid_true"),
                $resourceConfigurationInfoGrid: $("#div_resource_configuration_info_grid"),

                $saveBtn: $("#div_save_btn"),

                init: function () {

                    var mateDataElm = this.$mateDataSearch
                    var seMetaDataElm = this.$mateDataSearchTrue

                    mateDataElm.ligerTextBox({
                        width: 240, isSearch: true, search: function (data) {
                            master.reloadResourceConfigurationGrid(resourceConfigurationUrl[0], mateDataElm.val(), "mateData");
                        }
                    });
                    seMetaDataElm.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            master.reloadResourceConfigurationGrid(resourceConfigurationUrl[1], seMetaDataElm.val(), "seMetaData");
                        }
                    });
                },
            };
            master = {

                init: function () {
                    var self = retrieve;

                    var columnDatas = [
                        {name: 'id', hide: true, isAllowHide: false},
                        {display: '数据元编码', name: 'stdCode', width: '25%', align: 'left'},
                        {display: '数据元名称', name: 'name', width: '25%', align: 'left'},
                        {display: '类型', name: 'columnType', width: '25%', align: 'left'},
                        {display: '说明', name: 'description', width: '25%', align: 'left'},
                    ];

                    var elm = [self.$resourceConfigurationInfoGrid,self.$resourceConfigurationInfoGridTrue];
                    var count = 0;
                    for (var i = 0; i < resourceConfigurationUrl.length; i++) {
                        elmParams[i] = elm[i].ligerGrid($.LigerGridEx.config({
                            url: resourceConfigurationUrl[i],
                            columns: columnDatas,
                            checkbox: true,
                            height: 600,
                            async:true,
                            isChecked: function (row) {
                                var bo = false;
                                if (Util.isStrEquals(this.url.split("resourcesId").length,1)){
                                    dataModel.fetchRemote(resourceConfigurationUrl[1], {
                                        data: {searchNm: "",page:1,rows:15},
                                        async: false,
                                        success: function (data) {
                                            var resourceDatas = data.detailModelList;
                                            for (var i = 0;i<resourceDatas.length;i++){
                                                if(Util.isStrEquals(resourceDatas[i].metadataId,row.id)){
                                                    bo = true;
                                                    return;
                                                }else {
                                                    bo = false;
                                                }
                                            }
                                        }
                                    })
                                }
                                return bo
                            },
                            parms: {
                                searchNm: '',
                            },
                            onSelectRow: function (rowdata) {
                                debugger
                                var infoMsg = $("#infoMsg").val();
                                if (Util.isStrEquals(this.id, 'div_resource_configuration_info_grid')&&Util.isStrEquals(infoMsg,true)) {
                                    addRows(rowdata);
                                }
                            },
                            onUnSelectRow: function (rowdata, rowid, rowobj) {
                                if (Util.isStrEquals(this.id, 'div_resource_configuration_info_grid')) {
                                    deleteRows(rowdata);
                                }
                            },
                            onAfterShowData:function () {
                                $("#infoMsg").val(true);
                            }
                        }));
                    }

                    function addRows(rowdata) {
                        var metaData_rowData = {
                            resourcesId: "testId",
                            metadataId: rowdata.id,
                            groupType: "testType",
                            groupData: "testdata",
                            description: rowdata.description
                        };
                        addRowDatas.push(metaData_rowData);
                        elmParams[1].addRow({
                            id: rowdata.id,
                            stdCode: rowdata.stdCode,
                            name: rowdata.name,
                            columnType: rowdata.columnType,
                            description: rowdata.description
                        });
                    }

                    function deleteRows(rowdata) {
                        debugger
                        var metaData_rowData = {
                            metadataId: rowdata.id,
                        };
                        elmParams[1].deleteRow({
                            id: rowdata.id,
                            stdCode: rowdata.stdCode,
                            name: rowdata.name,
                            columnType: rowdata.columnType,
                            description: rowdata.description
                        });
                        delRowDatas.push(metaData_rowData);

//                        for (var i = 0; i < addRowDatas.length; i++) {
//
//                            if (Util.isStrEquals(addRowDatas[i].id, rowdata.id)) {
//                                addRowDatas.splice(i, 1);
//                            }
//                        }
                    }

                    this.bindEvents();
                },
                reloadResourceConfigurationGrid: function (url, value, searchType) {
                    reloadGrid.call(this, url, {searchNm: value}, searchType);
                },
                bindEvents: function () {

                    retrieve.$saveBtn.click(function () {
                        if (Util.isStrEmpty(addRowDatas) && Util.isStrEmpty(delRowDatas)) {
                            return;
                        }
                        dataModel.updateRemote(comUrl + "/saveResourceconfiguration", {
                            data: {addRowDatas: JSON.stringify(addRowDatas), delRowDatas: JSON.stringify(delRowDatas)},
                            async: true,
                            success: function (data) {
                                if (data.successFlg) {
                                    $.Notice.success('保存成功');
                                    debugger
                                    master.reloadResourceConfigurationGrid(resourceConfigurationUrl[0], "", "mateData");

                                } else
                                    $.Notice.error("保存失败");
                            }
                        })
                    })


                },
            };

            /* ************************* 模块初始化结束 ************************** */


            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        })
    })(jQuery, window)
</script>