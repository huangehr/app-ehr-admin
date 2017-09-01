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
            var h = $(window).height();
            // 页面主模块，对应于用户信息表区域
            var master = null;
            var resourceDatas = null;
            var sourceData = ${dataModel};
            $("#sp_resourceName").html(sourceData.resourceName);
            $("#sp_resourceSub").html(sourceData.resourceSub);
            $(".sp-resource-configuration-name").html('<h3>' + sourceData.resourceName + '_资源配置</3>');
            var addRowDatas = new Array();
            var delRowDatas = new Array();
            var comUrl = '${contextRoot}/resourceConfiguration';
            var resourceConfigurationUrl = [comUrl + '/searchResourceConfiguration', comUrl + '/searchSelResourceConfiguration?resourcesId=' + sourceData.resourceId];
            var elmParams = ['resourceConfigurationInfoGrid', 'resourceConfigurationInfoGridTrue'];
            var dataModel = $.DataModel.init();

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }

            function reloadGrid(url, params, searchType) {
                $("#infoMsg").val(false);
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
                    var mateDataElm = this.$mateDataSearch;
                    var seMetaDataElm = this.$mateDataSearchTrue;
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
                }
            };
            master = {
                init: function () {
                    var self = retrieve;
                    var columnDatas = [
                        {name: 'id', hide: true, isAllowHide: false},
                        {
                            display: '资源标准编码', name: 'stdCode', width: '25%', align: 'left', render: function (row) {
                            return Util.isStrEquals(this.id, 'div_resource_configuration_info_grid') ? row.id : row.stdCode;
                        }
                        },
                        {display: '数据元名称', name: 'name', width: '25%', align: 'left'},
                        {display: '类型', name: 'columnType', width: '25%', align: 'left'},
                        {display: '说明', name: 'description', width: '25%', align: 'left'}
                    ];

                    var elm = [self.$resourceConfigurationInfoGrid, self.$resourceConfigurationInfoGridTrue];
                    for (var i = 0; i < resourceConfigurationUrl.length; i++) {
                        elmParams[i] = elm[i].ligerGrid($.LigerGridEx.config({
                            url: resourceConfigurationUrl[i],
                            columns: columnDatas,
                            checkbox: true,
                            height: h - 315,
                            async: false,
                            isChecked: function (row) {
                                var bo = false;
                                if (Util.isStrEquals(this.url.split("resourcesId").length, 1)) {
                                    resourceDatas = elmParams[1].data.detailModelList;
                                    for (var i = 0; i < resourceDatas.length; i++) {
                                        if (Util.isStrEquals(resourceDatas[i].stdCode, row.id)) {
                                            bo = true;
                                            return bo;
                                        } else {
                                            bo = false;
                                        }
                                    }
                                }
                                return bo
                            },
                            onCheckAllRow: function (checked, element) {
                                if (Util.isStrEquals(this.id, "div_resource_configuration_info_grid")) {
                                    var rowAll = elmParams[0].data.detailModelList;
                                    if (checked) {
                                        $.each(rowAll, function (key, value) {
                                            addRows(value);
                                        })
                                    } else {
                                        $.each(rowAll, function (key, value) {
                                            deleteRows(value);
                                        })
                                    }
                                }
                            },
                            parms: {
                                searchNm: ''
                            },
                            onBeforeCheckRow: function (checked, data, rowid, rowdata) {
                                for (var i = 0; i < sessionStorage.length; i++) {
                                    if (Util.isStrEquals(sessionStorage.getItem("elmParams_1" + i), data.stdCode)) {
                                        $("#infoMsg").val(false);
                                        return;
                                    }
                                    else
                                        $("#infoMsg").val(true);
                                }
                            },
                            onSelectRow: function (rowdata) {
                                var infoMsg = $("#infoMsg").val();
                                if (Util.isStrEquals(this.id, 'div_resource_configuration_info_grid') && Util.isStrEquals(infoMsg, 'true')) {
                                    addRows(rowdata);
                                }
                            },
                            onUnSelectRow: function (rowdata, rowid, rowobj) {
                                if (Util.isStrEquals(this.id, 'div_resource_configuration_info_grid')) {
                                    deleteRows(rowdata);
                                }
                            },
                            onAfterShowData: function () {
                                $("#infoMsg").val(false);
                            }
                        }));
                    }
                    function addRows(rowdata) {
                        var metaData_rowData = {
                            resourcesId: sourceData.resourceId,
                            metadataId: rowdata.id,
                            groupType: "",
                            groupData: "",
                            description: rowdata.description
                        };
                        var bo = true;
                        $.each(addRowDatas, function (key, value) {
                            if (Util.isStrEquals(rowdata.id, value.metadataId)) {
                                bo = false;
                            }
                        });
                        if (bo) {
                            addRowDatas.push(metaData_rowData);
                        }
                        elmParams[1].addRow({
                            id: rowdata.stdCode,
                            stdCode: rowdata.id,
                            name: rowdata.name,
                            columnType: rowdata.columnType,
                            description: rowdata.description
                        });
                        var elmParams_1 = elmParams[1].data.detailModelList;
                        for (var i = 0; i < elmParams_1.length; i++) {
                            sessionStorage.setItem("elmParams_1" + i, elmParams_1[i].stdCode)
                        }
                    }

                    function deleteRows(rowdata) {
                        var rowParm = rowdata.id;
                        $.each(addRowDatas, function (key, value) {
                            if (!Util.isStrEmpty(value) && Util.isStrEquals(rowParm, value.metadataId)) {
                                addRowDatas.splice(key, 1);
                            }
                        });
                        var rows = elmParams[1].data.detailModelList;
                        for (var i = 0; i < rows.length; i++) {
                            var rowData = rows[i].stdCode;
                            if (Util.isStrEquals(rowData, rowParm)) {
                                delRowDatas.push(rows[i].id);
                                elmParams[1].deleteRow(rows[i].__id);
                            }
                            sessionStorage.removeItem("elmParams_1" + i);
                        }
                    }

                    this.bindEvents();
                },
                reloadResourceConfigurationGrid: function (url, value, searchType) {
                    reloadGrid.call(this, url, {searchNm: value}, searchType);
                },
                bindEvents: function () {
                    //返回资源注册页面
                    $('#btn_back').click(function () {
                        $('#contentPage').empty();
                        $('#contentPage').load('${contextRoot}/resource/resourceManage/initial');
                    });
                    retrieve.$saveBtn.click(function () {
                        if (Util.isStrEmpty(addRowDatas) && Util.isStrEmpty(delRowDatas)) {
                            return;
                        }
                        var dialog = $.ligerDialog.waitting('正在保存,请稍候...');
                        dataModel.updateRemote(comUrl + "/saveResourceConfiguration", {
                            data: {addRowDatas: JSON.stringify(addRowDatas), delRowDatas: delRowDatas.toString()},
                            async: true,
                            success: function (data) {
                                dialog.close();
                                addRowDatas = new Array();
                                delRowDatas = new Array();
                                if (data.successFlg) {
                                    $.Notice.success('保存成功');
                                    master.reloadResourceConfigurationGrid(resourceConfigurationUrl[0], retrieve.$mateDataSearchTrue.liger().getValue(), "");
                                    master.reloadResourceConfigurationGrid(resourceConfigurationUrl[1], retrieve.$mateDataSearch.liger().getValue(), "mateData");
                                } else
                                    $.Notice.error("保存失败");
                            }
                        })
                    });
                    $("#a-back").click(function () {
                        history.back();
                    })
                }
            };
            /* ************************* 模块初始化结束 ************************** */
            var resizeContent = function () {
                var contentW = $('.div-resource-configuration').width();
                var leftW = $('.f-bd-configuration').width();
                $('.f-bd-configurationtest').width(contentW - leftW - 20);
            }();
            $(window).bind('resize', function () {
                resizeContent();
            });
            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        })
    })(jQuery, window)
</script>