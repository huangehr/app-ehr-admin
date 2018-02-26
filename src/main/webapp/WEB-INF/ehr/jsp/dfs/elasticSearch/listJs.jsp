<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script>
    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var dictMaster = null;
            var myIndex = null;
            var myType = null;

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                dictMaster.init();
            }

            /* *************************** 标准字典模块初始化 ***************************** */
            dictMaster = {
                elasticInfoDialog: null,
                detailDialog:null,
                grid: null,
                $indexNm: $('#indexNm'),
                $indexType: $('#indexType'),
                $quotaCode: $('#quotaCode'),
                $begin: $('#begin'),
                $end: $('#end'),
                $searchBtn: $('#btn_search'),
                init: function () {
                    var self = this;
                    this.$indexNm.ligerTextBox({width: 200});
                    this.$indexType.ligerTextBox({width: 200});
                    this.$quotaCode.ligerTextBox({width: 200});
                    this.$begin.ligerTextBox({width: 100});
                    this.$end.ligerTextBox({width: 100});
                    if (this.grid) {
                        this.reloadGrid(1);
                    }
                    else {
                        this.grid = $("#elasticSearch").ligerGrid($.LigerGridEx.config({
                            url:  '${contextRoot}/elasticSearch/getElasticList',
                            parms: {
                                indexNm: "medical_service_index",
                                indexType: "medical_service",
                                quotaCode: ""
                            },
                            columns: [
                                {display: 'id', name: '_id', width: '0.1%', hide: true},
                                {display: '编码', name: 'quotaCode', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '名称', name: 'quotaName', width: '20%', isAllowHide: false, align: 'left'},
                                {display: '区县', name: 'townName', width: '10%', isAllowHide: false, align: 'left'},
                                {display: '机构', name: 'orgName', width: '15%', isAllowHide: false, align: 'left'},
                                {display: '结果', name: 'result', width: '10%', isAllowHide: false, align: 'left'},
                                {
                                    display: '操作', name: 'operator', minWidth: 120, align: 'center',render: function (row) {
                                        var html = '';
                                        html += '<sec:authorize url="/elasticSearch/editElasticSearch"><a class="grid_edit" style="margin-left:10px;" title="编辑" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}'])", "elastic:elasticInfo:open", myIndex, myType, row._id, 'modify') + '"></a></sec:authorize>';
                                        html += '<sec:authorize url="/elasticSearch/deleteElasticSearch"><a class="grid_delete" style="margin-left:0px;" title="删除" href="javascript:void(0)"  onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "elastic:elasticInfo:delete", myIndex, myType, row._id) + '"></a></sec:authorize>';
                                        return html;
                                    }
                                }
                            ],
                            //enabledEdit: true,
                            validate: true,
                            unSetValidateAttr: false,
                            allowHideColumn: false,
                            onBeforeShowData: function (data) {
                                if (data.obj) {
                                    myIndex = data.obj[0];
                                    myType = data.obj[1];
                                    console.log(myIndex + ":" + myType);
                                }
                            },
                            onAfterShowData: function (data) {
                            },
                            onSelectRow: function (row) {
//
                            },
                            onDblClickRow: function (row) {

                            }
                        }));
                        this.bindEvents();
                        // 自适应宽度
                        this.grid.adjustToWidth();
                    }
                },
                reloadGrid: function (curPage) {
                    var indexNm = $("#indexNm").val();
                    var indexType = $("#indexType").val();
                    var quotaCode = $("#quotaCode").val();
                    var begin = $("#begin").val();
                    var end = $("#end").val();
                    var values = {
                        indexNm: indexNm,
                        indexType: indexType,
                        quotaCode: quotaCode,
                        begin: begin.length > 0 ? parseFloat(begin) : "",
                        end: end.length > 0 ? parseFloat(end) : ""
                    };
                    Util.reloadGrid.call(this.grid, '${contextRoot}/elasticSearch/getElasticList', values, curPage);
                },
                bindEvents: function () {
                    var self = this;
                    self.$searchBtn.click(function () {
                        dictMaster.grid.options.newPage = 1;
                        dictMaster.reloadGrid(1);
                    });
                    $.subscribe('elastic:elasticInfo:open', function (event, myIndex, myType, id, mode) {
                        var title = '';
                        var height = 800;
                        if (mode == 'modify') {
                            title = '修改ElasticSearch';
                        }
                        else {
                            title = '新增ElasticSearch';
                            height = 150;
                        }
                        dictMaster.elasticInfoDialog = parent._LIGERDIALOG.open({
                            height: height,
                            width: 480,
                            title: title,
                            url: '${contextRoot}/elasticSearch/getPage',
                            urlParms: {
                                indexNm: myIndex,
                                indexType: myType,
                                id: id
                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });

                    $.subscribe('elastic:elasticInfo:delete', function (event, myIndex, myType, id) {

                        parent._LIGERDIALOG.confirm('确认要删除所选数据？', function (r) {
                            if (r) {
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote('${contextRoot}/elasticSearch/deleteElastic', {
                                    data: {
                                        indexNm: myIndex,
                                        indexType: myType,
                                        id: id
                                    },
                                    success: function (data) {
                                        if(data.successFlg){
                                            parent._LIGERDIALOG.success('删除成功！');
                                            dictMaster.reloadGrid(Util.checkCurPage.call(dictMaster.grid, 1));
                                        }else{
                                            parent._LIGERDIALOG.error(data.errorMsg);
                                        }
                                    }
                                });
                            }
                        })
                    });

                }
            };

            /* ******************Dialog页面回调接口****************************** */
            win.parent.reloadMasterGrid = function () {
                dictMaster.reloadGrid();
            };
            win.parent.closeDialog = function (type, msg) {
                dictMaster.elasticInfoDialog.close();
                if (msg)
                    parent._LIGERDIALOG.success(msg);
            };
            win.parent.closeZhiBiaoInfoDialog = function (callback) {
                if(callback){
                    callback.call(win);
                    dictMaster.reloadGrid();
                }
                dictMaster.elasticInfoDialog.close();
            };

            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>
