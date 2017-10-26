<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script>

    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            var adapterGrid = null;
            var adapterDataSet = null;
            var adapterType = 29;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();
                master.init();
            }
            function getSchemeAdapt(target, id, mode) {
                var title = '';
                var wait = $.ligerDialog.waitting("请稍后...");
                var height = null;
                //只有new 跟 modify两种模式会到这个函数
                if (mode == 'modify') {
                    title = '修改适配方案';
                    height = 520;
                } else if (mode == 'new') {
                    title = '新增适配方案';
                    height = 520;
                }
                target.adapterInfoDialog = $.ligerDialog.open({
                    height: height,
                    width: 440,
                    title: title,
                    load: true,
                    url: '${contextRoot}/schemeAdapt/gotoModify',
                    urlParms: {
                        id: id,
                        mode: mode
                    },
                    isHidden: false,
                    opener: true,
                    show:false,
                    onLoaded:function(){
                    	wait.close(),
                    	target.adapterInfoDialog.show()
                    }
                });
                target.adapterInfoDialog.hide();
            }

            function delSchemeAdapt(id) {
                var dialog = $.ligerDialog.waitting('正在删除中,请稍候...');
                var dataModel = $.DataModel.init();
                dataModel.updateRemote('${contextRoot}/schemeAdapt/delete', {
                    data: {schemeId: id},
                    success: function (data) {
                        if (data.successFlg) {
                            $.Notice.success('删除成功！');
                            master.reloadGrid(Util.checkCurPage.call(adapterGrid, id.split(',').length));
                        } else {
                            if (data.errorMsg)
                                $.Notice.error(data.errorMsg);
                            else
                                $.Notice.error('删除失败！');
                        }
                    },
                    complete: function () {
                        dialog.close();
                    }
                });
            }


            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchBox: $('#ipt_search'),
                $searchType: $('#ipt_search_type'),
                $searchBtn: $('#btn_search'),
                $addBtn: $('#btn_add'),
                $deleteBtn: $('#btn_del'),

                init: function () {
                    var self = this;
                    self.$searchBox.ligerTextBox({
                        width: 240
                    });
                    self.$searchType.ligerComboBox({
                        url: '${contextRoot}/dict/searchDictEntryList',
                        valueField: 'code',
                        textField: 'value',
                        dataParmName: 'detailModelList',
                        urlParms: {
                            page: 1,
                            rows: 1000,
                            dictId: adapterType
                        }
                    });
                    self.$element.show();
                    self.$element.attrScan();
                    window.form = self.$element;
                },
                bindEvents: function () {
                    //
                }
            };

            master = {
                adapterInfoDialog: null,
                adapterCustomize: null,
                init: function () {
                    adapterGrid = $("#div_adapter_info_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/schemeAdapt/list',
                        parms:{
                            name:"",
                            code:"",
                            type:""
                        },
                        columns: [
                            {display: 'ID', name: 'id', width: '0.1%', hide: true},
                            {display: 'adapterVersion', name: 'adapterVersion', width: '0.1%', hide: true},
                            {display: '方案类别', name: 'typeName', width: '15%', align: 'left'},
                            {display: '方案名称', name: 'name',  width: '15%', align: 'left'},
                            {display: '方案编码', name: 'code', width: '15%', minColumnWidth: 60, align: 'left'},
                            {display: '标准名称/版本号', name: 'adapterVersionName', width: '15%', align: 'left'},
                            {display: '说明', name: 'description', width: '25%', align: 'left'},
                            {
                                display: '操作', name: 'operator', minWidth: 125, render: function (row) {
                                var html = '<sec:authorize url="/schemeAdaptDataSet/initial"><a class="label_a" title="适配" style="margin-left:5px;" href="#" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "adapter:adapterScheme:adapter", row.id, row.adapterVersion) + '">适配</a></sec:authorize>';
								html += '<sec:authorize url="/schemeAdapt/gotoModify"><a class="grid_edit" title="编辑" href="#" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}',])", "adapter:adapterScheme:open", row.id, 'modify') + '"></a></sec:authorize>' +
								'<sec:authorize url="/schemeAdapt/delete"><a class="grid_delete" title="删除" href="#" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "adapter:adapterScheme:delete",row.id,row.status) + '"></a></sec:authorize>';
								return html;
                            }
                            }
                        ],
                        selectRowButtonOnly: false,
                        checkbox: true,
                        allowHideColumn: false
                    }));
                    this.bindEvents();
                    // 自适应宽度
                    adapterGrid.adjustToWidth();
                },
                reloadGrid: function (curPage) {
                    Util.reloadGrid.call(adapterGrid, "", retrieve.$element.Fields.getValues(), curPage);
                },
                bindEvents: function () {
                    var self = this;
                    //搜索适配方案
                    retrieve.$searchBtn.click(function () {
                        self.reloadGrid(1);
                    });
                    //新增适配方案
                    retrieve.$addBtn.click(function () {
                        getSchemeAdapt(self, '', 'new');
                    });

                    //修改适配方案
                    $.subscribe('adapter:adapterScheme:open', function (event, id, mode) {
                        getSchemeAdapt(self, id, mode);
                    });
                    //删除适配方案
                    $.subscribe('adapter:adapterScheme:delete', function (event, id,status) {
                        $.ligerDialog.confirm('确定删除该方案信息?', function (yes) {
                            if (yes) {
                                delSchemeAdapt(id);
                            }
                        });
                    });
                    //适配
                    $.subscribe('adapter:adapterScheme:adapter', function (event, id, adapterVersion) {
                        var url = '${contextRoot}/schemeAdaptDataSet/initial?dataModel=' + id+"&version="+adapterVersion;
                        $("#contentPage").empty();
                        $("#contentPage").load(url);
                    });
                }
            };

            /* ******************Dialog页面回调接口****************************** */
            win.reloadAdapterMasterGrid = function () {
                master.reloadGrid();
            };
            win.closeSchemeDialog = function (msg) {
                master.reloadGrid();
                master.adapterInfoDialog.close();
                if (msg)
                    $.Notice.success(msg);
            };
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);

</script>