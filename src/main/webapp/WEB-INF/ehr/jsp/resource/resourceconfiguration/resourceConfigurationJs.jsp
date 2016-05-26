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
            var resourceConfigurationUrl = [comUrl+'/searchResourceconfiguration', comUrl+'/searchSelResourceconfiguration']
            var elmParams = ['resourceConfigurationInfoGrid', 'resourceConfigurationInfoGridTrue'];

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

            function reloadGrid(url, params, searchType) {
                var grif = null;
                if (Util.isStrEquals(searchType, "mateData"))
                    grif = elmParams[0];
                else
                    grif = elmParams[1];

                grif.setOptions({parms: params});
                grif.loadData(true);

            }

            /* *************************** 模块初始化 ***************************** */
            retrieve = {

                $mateDataSearch: $("#inp_mateData_search"),
                $mateDataSearchTrue: $("#inp_mateData_search_true"),
                $resourceConfigurationInfoGrid: $("#div_resource_configuration_info_grid"),
                $resourceConfigurationInfoGridTrue: $("#div_resource_configuration_info_grid_true"),

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
                        {display: '数据元编码', name: 'userTypeName', width: '25%', align: 'left'},
                        {display: '数据元名称', name: 'userTypeName', width: '25%', align: 'left'},
                        {display: '类型', name: 'userTypeName', width: '25%', align: 'left'},
                        {display: '说明', name: 'userTypeName', width: '25%', align: 'left'},  //test_name
                    ];

                    var elm = [self.$resourceConfigurationInfoGrid, self.$resourceConfigurationInfoGridTrue];

                    for (var i = 0; i < resourceConfigurationUrl.length; i++) {
                        elmParams[i] = elm[i].ligerGrid($.LigerGridEx.config({
                            url: resourceConfigurationUrl[i],
                            columns: columnDatas,
                            checkbox: true,
                            parms: {
                                searchNm: '',
                            },
                            onSelectRow: function (rowdata, rowid, rowobj) {
                                debugger
                                if (Util.isStrEquals(this.id, 'div_resource_configuration_info_grid')) {
                                    addRows(rowdata);
                                }
                            },
                            onUnSelectRow: function (rowdata, rowid, rowobj) {
                                if (Util.isStrEquals(this.id, 'div_resource_configuration_info_grid')) {
                                    deleteRows(rowdata);//test
                                } else {
                                    deleteRows(rowdata);//test
                                }
                            }
                        }));
                    }

                    function addRows(rowdata) {
                        addRowDatas.push(
                                {id: 12, userTypeName: '1'},
                                {id: 13, userTypeName: '2'},
                                {userTypeName: '3'}  //test_data
                        );
                        elmParams[1].addRow(addRowDatas);
                    }

                    function deleteRows(rowdata) {
                        debugger
                        for (var i = 0; i < addRowDatas.length; i++) {

                            if (Util.isStrEquals(addRowDatas[i].id, rowdata.id)) {
                                addRowDatas.splice(i, 1);
                            }
                        }
                    }

                    this.bindEvents();

                },
                reloadResourceConfigurationGrid: function (url, value, searchType) {
                    reloadGrid.call(this, url, {searchNm:value}, searchType);
                },
                bindEvents: function () {

                    if (Util.isStrEmpty(addRowDatas) && Util.isStrEmpty(delRowDatas)) {
                        return;
                    }

                    retrieve.$saveBtn.click(function () {
                        dataModel.updateRemote(comUrl+"/saveResourceconfiguration", {
                            data: {addRowDatas: JSON.stringify(addRowDatas),delRowDatas:JSON.stringify(delRowDatas)},
                            async: true,
                            success: function (data) {
                                if (data.successFlg)
                                    $.Notice.success('保存成功');
                                else
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