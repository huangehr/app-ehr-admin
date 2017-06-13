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
            var dictRetrieve = null;
            var dictMaster = null;
            var conditionArea = null;

            var entryRetrieve = null;
            var entryMater = null;

            var versionStage = null;
            var selectRowObj = null;
            var isSaveSelectStatus = false;
            /* *************************** 函数定义 ******************************* */
            function pageInit() {

                dictRetrieve.init();
                conditionArea.init();
                conditionArea.resizeContent();
                entryRetrieve.init();
                //versionStage=getStagedByValue();
            }

            function getStagedByValue()
            {
                var _value = $("#stdDictVersion").ligerGetComboBoxManager().getValue();
                if (!_value && _value == "") return false;
                var data = $("#stdDictVersion").ligerComboBox().data;
                for(var i =0;i<data.length;i++)
                {
                    if(data[i].version==_value)
                    {
                        return data[i].inStage;
                    }
                }
                return false;
            }

            /* *************************** 标准字典模块初始化 ***************************** */
            conditionArea = {
                $element: $('#conditionArea'),
                $stdDictVersion: $('#stdDictVersion'),

                init: function () {
                    this.initDDL(this.$stdDictVersion);
                    this.rendBarTools();
                },
                resizeContent:function(){
                    var contentW = $('#grid_content').width();
                    var leftW = $('#div_left').width();
                    $('#div_right').width(contentW - leftW - 20);
                },
                initDDL: function (target) {
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/cdaVersion/getVersionList", {
                        success: function (data) {
                            target.ligerComboBox({
                                valueField: 'version',
                                textField: 'versionName',
                                data: data.detailModelList,
                                initValue: 1,
                                allowBlank: false,
                                onSelected: function (value, text) {
                                    versionStage=getStagedByValue();
                                    dictMaster.init();
                                    $("#l_upd_form").attr("action","${contextRoot}/cdadict/importFromExcel?version="+value);
                                }
                            });
                            var manager = target.ligerGetComboBoxManager();
                            manager.selectItemByIndex(0);

                        }
                    });
                },
                //初始化工具栏
                rendBarTools : function(){
                    function onUploadSuccess(g, result){
                        if(result=='suc')
                            $.Notice.success("导入成功");
                        else{
                            result = eval('(' + result + ')')
                            var url = "${contextRoot}/resource/dict/downLoadErrInfo?f="+ result.eFile[1] + "&datePath=" + result.eFile[0];
                            $.ligerDialog.open({
                                height: 80,
                                content: "请下载&nbsp;<a target='diframe' href='"+ url +"'>导入失败信息</a><iframe id='diframe' name='diframe'> </iframe>",
                            });
                        }
                    }
                     function onDlgClose(){
                        dictMaster.reloadGrid();
                    }
                   function onBeforeUpload(){
                       if(!versionStage)
                       {
                           $.Notice.error("已发布版本不可新增，请确认!");
                           return false;
                       }else{
                           return true;
                       }
                   };
                    $('#upd').uploadFile({
                        url: "${contextRoot}/cdadict/importFromExcel",
                        onUploadSuccess: onUploadSuccess,
                        onDlgClose: onDlgClose,
                        onBeforeUpload:onBeforeUpload
                    });

                },
                event:function(){
                    $("#div_file_export").click(function(){
                        var versionCode = $("#stdDictVersion").ligerGetComboBoxManager().getValue();
                        var versionName = $("#stdDictVersion").ligerGetComboBoxManager().getText();
                        window.open("${contextRoot}/cdadict/exportToExcel?versionCode="+versionCode+"&versionName="+versionName,"标准字典导出");
                    });
                }
            };

            dictRetrieve = {
                $element: $('#dictRetrieve'),
                $searchNm: $('#searchNm'),
                $addBtn: $('#btn_create'),

                init: function () {

                    this.$searchNm.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            dictMaster.reloadGrid(1);
                        }
                    });
                    this.$element.show();
                    window.form = this.$element;
                }
            };

            dictMaster = {
                dictInfoDialog: null,
                detailDialog:null,
                grid: null,
                init: function () {
                    if (this.grid) {
                        this.reloadGrid(1);
                    }
                    else {
                        var searchNm = $("#searchNm").val();
                        var stdDictVersion = $("#stdDictVersion").ligerGetComboBoxManager().getValue();
                        this.grid = $("#div_stdDict_grid").ligerGrid($.LigerGridEx.config({
                            url: '${contextRoot}/cdadict/getCdaDictList',
                            parms: {
                                searchNm: searchNm,
                                strVersionCode: stdDictVersion
                            },
                            columns: [
                                {display: 'id', name: 'id', hide: true},
                                {display: '编码', name: 'code', width: '25%', isAllowHide: false, align: 'left'},
                                {display: '名称', name: 'name', width: '25%', isAllowHide: false, align: 'left'},
                                {display: '状态', name: 'name', width: '20%', isAllowHide: false, align: 'left'},
                                {
                                    display: '操作', name: 'operator', width: '30%', render: function (row) {
                                    var html = '';
                                    <sec:authorize url="/cdadict/saveDict">
                                    html += '<a class="grid_edit"  href="#" title="编辑" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "zhibiao:zhiBiaoInfo:open", row.id, 'modify') + '"></a>';
                                    </sec:authorize>

                                    <sec:authorize url="/cdadict/deleteDict">
                                    html +=  '<a class="grid_delete" href="#" title="删除" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "zhibiao:zhiBiaoGrid:delete", row.id) + '"></a>';
                                    </sec:authorize>

                                    <sec:authorize url="/cdadict/deleteDict">
                                    html += '<a class="grid_delete" style="width: 60px;line-height: 40px;background: none;position: absolute;text-decoration: underline;" href="javascript:void(0)" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "zhibiao:weidu:config", row.orgCode, row.id, row.fullName) + '">维度配置</a>';
                                    </sec:authorize>
                                    return html;
                                }
                                }
                            ],
                            //enabledEdit: true,
                            validate: true,
                            unSetValidateAttr: false,
                            allowHideColumn: false,
                            onBeforeShowData: function (data) {
                                if (data.totalCount == 0) {
                                    entryMater.reloadGrid(1, '');
                                }
                            },
                            onAfterShowData: function (data) {
                                if (selectRowObj != null && isSaveSelectStatus) {
                                    isSaveSelectStatus = false;
                                    dictMaster.grid.select(selectRowObj);
                                }else
                                    this.select(0);
                            },
                            onSelectRow: function (row) {
//                                selectRowObj = row;
//                                entryMater.reloadGrid(1);
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
                    var searchNm = $("#searchNm").val();
                    var stdDictVersion = $("#stdDictVersion").ligerGetComboBoxManager().getValue();
                    var values = {
                        searchNm: searchNm,
                        strVersionCode: stdDictVersion
                    };
                    Util.reloadGrid.call(this.grid, '${contextRoot}/cdadict/getCdaDictList', values, curPage);
                },
                bindEvents: function () {
                    $.subscribe('zhibiao:zhiBiaoInfo:open', function (event, id, mode) {
                        var title = '';
                        //只有new 跟 modify两种模式会到这个函数
                        if (mode == 'modify') {
                            title = '修改指标';
                        }
                        else {
                            title = '新增指标';
                        }
                        isSaveSelectStatus = true;
                        var stdDictVersion = $("#stdDictVersion").ligerGetComboBoxManager().getValue();
                        dictMaster.dictInfoDialog = $.ligerDialog.open({
                            height: 620,
                            width: 480,
                            title: title,
                            url: '${contextRoot}/zhibiao/zhiBiaoInfoDialog',
                            urlParms: {

                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });

                    $.subscribe('zhibiao:zhiBiaoGrid:delete', function (event, id) {

                        $.Notice.confirm('确认要删除所选数据？', function (r) {
                            if (r) {
                                var dataModel = $.DataModel.init();
                                var stdDictVersion = $("#stdDictVersion").ligerGetComboBoxManager().getValue();
                                dataModel.updateRemote('${contextRoot}/cdadict/deleteDict', {
                                    data: {dictId: id, cdaVersion: stdDictVersion},
                                    success: function (data) {
                                        if(data.successFlg){
                                            $.Notice.success('删除成功！');
                                            dictMaster.reloadGrid(Util.checkCurPage.call(dictMaster.grid, 1));
                                        }else{
                                            $.Notice.error(data.errorMsg);
                                        }


                                    }
                                });
                            }
                        })
                    });

                    $.subscribe('zhibiao:weidu:config', function (event, orgCode, id,fullName) {
                        dictMaster.detailDialog = $.ligerDialog.open({
                            title:'维度配置',
                            height: 625,
                            width: 800,
                            url: '${contextRoot}/zhibiao/zhiBiaoDetail',
                            isHidden: false,
                            opener: true,
                            load: true,
                            urlParms: {

                            },
                            onLoaded:function() {

                            }
                        });
                    });

                }
            };

            entryRetrieve = {
                $element: $('#entryRetrieve'),
                $searchNm: $('#searchNmEntry'),

                init: function () {
                    this.$searchNm.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            entryMater.reloadGrid(1);
                        }
                    });
                    this.$element.show();
                    window.form = this.$element;
                }
            };

            entryMater = {
                entryInfoDialog: null,
                grid: null,
                grid1: null,
                init: function (dictId) {
                    if (this.grid)
                        return;
                    this.grid = $("#div_relation_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/cdadict/searchDictEntryList',
                        width:" calc(55% - 20px)",
                        columns: [
                            {display: 'id', name: 'id', hide: true},
                            {display: 'dictId', name: 'dictId', hide: true},
                            {display: '编码', name: 'code', width: '33%', isAllowHide: false, align: 'left'},
                            {display: '名称', name: 'value', width: '33%', isAllowHide: false, align: 'left'},
                            {display: '维度', name: 'value', width: '34%', isAllowHide: false, align: 'left'}
                        ],
                        //delayLoad:true,
                        selectRowButtonOnly: false,
                        validate: true,
                        unSetValidateAttr: false,
                        allowHideColumn: false,
                        checkbox: true,
                        onDblClickRow: function (row) {
                            //$.publish('entry:dictInfo:open',[row.id, row.dictId, 'modify']);
                        }
                    }));

                    this.grid1 = $("#div_relation_grid1").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/cdadict/getCdaDictList',
                        parms: {
                            searchNm: "",
                            strVersionCode: "592814c2898a"
                        },
                        width:" calc(45% - 20px)",
                        columns: [
                            {display: 'id', name: 'id', hide: true},
                            {display: 'dictId', name: 'dictId', hide: true},
                            {display: '编码', name: 'code', width: '33%', isAllowHide: false, align: 'left'},
                            {display: '名称', name: 'name', width: '33%', isAllowHide: false, align: 'left'},
                            {display: '维度', name: 'name', width: '34%', isAllowHide: false, align: 'left'}
                        ],
                        //delayLoad:true,
                        selectRowButtonOnly: false,
                        validate: true,
                        unSetValidateAttr: false,
                        allowHideColumn: false,
                        onDblClickRow: function (row) {
                            //$.publish('entry:dictInfo:open',[row.id, row.dictId, 'modify']);
                        }
                    }));
                    this.bindEvents();
                    // 自适应宽度
                    this.grid.adjustToWidth();
                },
                reloadGrid: function (curPage, dictId) {
                    var searchNmEntry = $("#searchNmEntry").val();
                    var stdDictVersion = $("#stdDictVersion").ligerGetComboBoxManager().getValue();
                    var dictId = dictId == '' ? -1 : dictMaster.grid.getSelectedRow().id;
                    var values = {
                        searchNmEntry: searchNmEntry,
                        strVersionCode: stdDictVersion,
                        dictId: dictId
                    };
                    Util.reloadGrid.call(this.grid, '${contextRoot}/cdadict/searchDictEntryList', values, curPage);
                },
                bindEvents: function () {
                    //窗体改变大小事件
                    $(window).bind('resize', function () {
                        conditionArea.resizeContent();
                    });
                    //
                    $.subscribe('entry:dictInfo:open', function (event, id, dictId, mode) {
                        if (!dictMaster.grid.getSelectedRow()) {
                            $.Notice.warn('请先添加标准字典数据！');
                            return;
                        }
                        var title = '';
                        //只有new 跟 modify两种模式会到这个函数
                        if (mode == 'modify') {
                            title = '修改字典项';
                        }
                        else {

                            if(!versionStage)
                            {
                                $.Notice.error("已发布版本不可新增，请确认!");
                                return;
                            }
                            dictId = dictMaster.grid.getSelectedRow().id;
                            title = '新增字典项';
                        }
                        var stdDictVersion = $("#stdDictVersion").ligerGetComboBoxManager().getValue();
                        entryMater.entryInfoDialog = $.ligerDialog.open({
                            height: 360,
                            width: 460,
                            title: title,
                            url: '${contextRoot}/cdadict/template/dictEntryInfo',
                            urlParms: {
                                id: id,
                                dictId: dictId,
                                mode: mode,
                                strVersionCode: stdDictVersion,
                                staged:versionStage
                            },
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });

                    $.subscribe('entry:dictInfoGrid:delete', function (event, ids) {

                        if(!versionStage)
                        {
                            $.Notice.error("已发布版本不可删除，请确认!");
                            return;
                        }
                        var delLen = 1;
                        if (!ids) {
                            var rows = entryMater.grid.getSelectedRows();
                            if (rows.length == 0) {
                                $.Notice.warn('请选择要删除的数据行！');
                                return;
                            }
                            delLen = rows.length;
                            for (var i = 0; i < rows.length; i++) {
                                ids += ',' + rows[i].id;
                            }
                            ids = ids.length > 0 ? ids.substring(1, ids.length) : ids;
                        }

                        $.Notice.confirm('确认要删除所选数据？', function (r) {
                            if (r) {
                                var dataModel = $.DataModel.init();
                                var stdDictVersion = $("#stdDictVersion").ligerGetComboBoxManager().getValue();
                                dataModel.updateRemote('${contextRoot}/cdadict/deleteDictEntryList', {
                                    data: {id: ids, cdaVersion: stdDictVersion},
                                    success: function (data) {
                                        $.Notice.success('操作成功！');
                                        entryMater.reloadGrid(Util.checkCurPage.call(entryMater.grid, delLen));
                                    }
                                });
                            }
                        })

                    });
                },
                closeDl: function () {
                    this.entryInfoDialog.close();
                }
            };
            /* ******************Dialog页面回调接口****************************** */
            win.reloadMasterGrid = function () {
                dictMaster.reloadGrid();
            };
            win.getStrVersion = function () {
                return $("#stdDictVersion").ligerGetComboBoxManager().getValue();
            };
            win.reloadEntryMasterGrid = function () {
                entryMater.reloadGrid();
            };
            win.closeDialog = function (type, msg) {
                if (type == 'right')
                    entryMater.closeDl();
                else
                    dictMaster.dictInfoDialog.close();
                if (msg)
                    $.Notice.success(msg);
            };
            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>
