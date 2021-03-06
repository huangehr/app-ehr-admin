<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>


<script>
    (function ($, win) {
        $(function () {
            /* ************************** 全局变量定义 **************************** */

            var urls = {
                list: "${contextRoot}/template/list",
                gotoModify: "${contextRoot}/template/gotoModify",
                delete: "${contextRoot}/template/delete",
                uploadTplFile: "${contextRoot}/template/update_tpl_content"
            }
            var selectRow = null;
            var isSaveSelectStatus = false;
            var Util = $.Util;
            var retrieve = null;
            var master = null;
            var dataModel = '${dataModel}';
            debugger
            var staged;
            try {
                dataModel = eval('(' + dataModel + ')');
            } catch (e) {
                dataModel = {};
            }

            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                retrieve.init();

            }

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                $element: $('.m-retrieve-area'),
                $searchVersionDDL: $('#inp_searchVersion'),
                $searchOrgName: $('#inp_searchOrgName'),
                $addBtn: $('#btn_add'),

                init: function () {
                    if (dataModel.orgCode) {
                        $('#headerArea').css('height', '80px');
                        $('#conditionArea').show();
                        $('#h_org_type').val(dataModel.orgType);
                        $('#h_org_code').val(dataModel.orgCode);
                        $('#h_org_name').val(dataModel.orgName);
                        this.$searchOrgName.attr('placeholder', '请输入模版名称');
                    }
                    this.initVersionDDL(this.$searchVersionDDL);
                    this.$searchOrgName.ligerTextBox({
                        width: 240, isSearch: true, search: function () {
                            master.reloadGrid(1);
                        }
                    });
                    this.$element.show();
                    this.$element.attrScan();
                },
                initVersionDDL: function (target) {
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/adapter/versions", {
                        success: function (data) {

                            var versionData = data.detailModelList;

                            for (var i = 0; i < versionData.length; i++) {
                                if (versionData[i].inStage) {
                                    versionData.splice(i, 1);
                                }
                            }

                            target.ligerComboBox({
                                valueField: 'version',
                                textField: 'versionName',
                                data: [].concat(versionData),
                                onSelected: function (data) {
                                    var versionDatas = $("#inp_searchVersion").ligerComboBox().data
                                    for (var i = 0; i < versionDatas.length; i++) {
                                        if (Util.isStrEquals(versionDatas[i].version, data)) {
//                                            staged = versionDatas[i].inStage;
                                            staged = true;
                                        }
                                    }
                                    master.reloadGrid(1);
                                }
                            });

                            var manager = target.ligerGetComboBoxManager();
                            master.init();
                            manager.selectItemByIndex(0);
                        }
                    });
                },
                bindEvents: function () {
                }
            };

            master = {
                archiveTplInfoDialog: null,
                grid: null,
                $filePickerBtn: $('#div_file_picker'),
                init: function () {
                    retrieve.$element.attrScan();
                    var values = retrieve.$element.Fields.getValues();

                    this.grid = $("#div_tpl_info_grid").ligerGrid($.LigerGridEx.config({
                        url: urls.list,
                        parms: this.formatParms(values),
                        columns: [
                            {display: 'id', name: 'id', hide: true, isAllowHide: false},
                            {display: '模板', name: 'title', width: '20%', isAllowHide: false, align: 'left'},
                            {
                                display: '类别',
                                name: 'organizationName',
                                width: '30%',
                                isAllowHide: false,
                                align: 'left',
                                render: function (row) {
                                    if(row.type == 'clinic'){
                                        return "门诊";
                                    }else if(row.type == 'resident'){
                                        return "住院";
                                    }else if(row.type == 'medicalExam'){
                                        return "体检";
                                    }else if(row.type == 'universal') {
                                        return "通用";
                                    }
                                }
                            },
                            {display: 'CDA文档ID', name: 'cdaDocumentId', hide: true, isAllowHide: false},
//                            {
//                                display: 'CDA文档',
//                                name: 'cdaDocumentName',
//                                width: '25%',
//                                minColumnWidth: 60,
//                                align: 'left'
//                            },
                            {display: 'CDA版本ID', name: 'cdaVersion', hide: true, isAllowHide: false},
                            {
                                display: '导入模版',
                                name: 'checkStatus',
                                width: '20%',
                                minColumnWidth: 20,
                                render: function (row) {
                                    var html = ''
                                        <sec:authorize url="/template/update_tpl_content">
                                        + '<a href="#" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "tpl:tplUpload:open", row.id, 'pc') + '">PC</a> / '
                                        + '<a href="#" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}'])", "tpl:tplUpload:open", row.id, 'mobile') + '">移动</a>';
                                    </sec:authorize>
                                    return html;
                                }
                            },
                            {
                                display: '复制模版', name: 'operator', width: '20%', render: function (row) {

                                var html = ''
                                    <sec:authorize url="/template/updateCopy">
                                    + '<a href="#" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "tpl:tplInfo:open", row.id, 'copy', row.cdaVersion) + '">复制</a>';
                                </sec:authorize>

                                return html;
                            }
                            },
                            {
                                display: '操作',
                                name: 'checkStatus',
                                width: '10%',
                                minColumnWidth: 20,

                                render: function (row) {
                                    var html = ''
                                        <sec:authorize url="/template/update">
                                        + '<a href="#" onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}'])", "tpl:tplInfo:open", row.id, 'modify', row.cdaVersion) + '">修改</a>' + "/"
                                        + '<a href="#" onclick="javascript:' + Util.format("$.publish('{0}',['{1}'])", "tpl:tplInfo:delete", row.id) + '">删除</a>';
                                    </sec:authorize>

                                    return html;
                                }
                            }
                        ],
                        enabledEdit: true,
                        validate: true,
                        unSetValidateAttr: false,
                        delayLoad: true,
                        onSelectRow: function (data, rowindex, rowobj) {
                            selectRow = data;
                        },
                        onAfterShowData: function () {
                            if (selectRow != null && isSaveSelectStatus) {
                                isSaveSelectStatus = false;
                                master.grid.select(selectRow);
                            }
                        }
                    }));
                    this.$filePickerBtn.instance = this.$filePickerBtn.webupload({
                        auto: true,
                        server: urls.uploadTplFile,
                        accept: {
                            title: 'Html',
                            extensions: 'html',
                            mimeTypes: 'text/html'
                        }
                    });

                    this.bindEvents();
                    // 自适应宽度
                    this.grid.adjustToWidth();
                },
                formatParms: function (values) {
                    var ext = {
                        searchName: values.orgName
                    }
                    if (dataModel.orgCode) {
                        ext.orgCode = dataModel.orgCode;
                    }
                    return {
                        filters: "cdaVersion=" + values.version,
                        extParms: JSON.stringify(ext)
                    }
                },
                reloadGrid: function (curPage) {
                    var values = retrieve.$element.Fields.getValues();
                    Util.reloadGrid.call(this.grid, '', this.formatParms(values), curPage);
                },
                bindEvents: function () {
                    var self = this;
                    $.subscribe('tpl:tplInfo:open', function (event, id, mode, verId) {
                        var urlParms = {};
                        if (!Util.isStrEmpty(id))
                            urlParms['id'] = id;

                        var extParms = {staged: staged};

                        if (dataModel.orgCode)
                            extParms.orgCode = dataModel.orgCode;

                        urlParms['extParms'] = JSON.stringify(extParms);

                        urlParms['mode'] = mode;

                        urlParms['myFlag'] = !!dataModel.orgType;
                        var title = '新增模板';
                        if (mode == 'copy') {
                            title = '复制模板';
                        } else if (mode == 'modify') {
                            isSaveSelectStatus = true;
                            title = '修改模板';
                        }
                        urlParms['orgCode'] = dataModel.orgCode;
                        urlParms['versionNum'] = $('#inp_searchVersion').val();
                        urlParms['versionCode'] = $('#inp_searchVersion_val').val();


                        self.archiveTplInfoDialog = parent._LIGERDIALOG.open({
                            height: 370,
                            width: 450,
                            title: title,
                            url: urls.gotoModify,
                            urlParms: urlParms,
                            isHidden: false,
                            opener: true,
                            load: true
                        });
                    });
                    $.subscribe('tpl:tplInfo:delete', function (event, id) {
                        var dataModel = $.DataModel.init();
                        $.ligerDialog.confirm('确认删除？', function (yes) {
                            if (yes) {
                                dataModel.updateRemote("${contextRoot}/template/delete", {
                                    data: {ids:id},
                                    success: function (data) {
                                        if (data.successFlg) {
                                            parent._LIGERDIALOG.success('删除成功');
                                            master.reloadGrid();
                                        } else {
                                            parent._LIGERDIALOG.error(data.errorMsg);
                                        }
                                    },
                                    error:function (data) {
                                        parent._LIGERDIALOG.error(data.errorMsg);
                                    }
                                });
                            }
                        });
                    });
                    var uploader = self.$filePickerBtn.instance;
                    var templateId = '';
                    var tplMode = '';
                    uploader.on('beforeSend', function (file, data) {
                        data.templateId = templateId;
                        data.mode = tplMode;
                    });
                    uploader.on('success', function (file, data, b) {
                        if (data.successFlg)
                            parent._LIGERDIALOG.success('导入成功');
                        else if (data.errorMsg)
                            parent._LIGERDIALOG.error(data.errorMsg);
                        else
                            parent._LIGERDIALOG.error('导入失败');
                    });
                    uploader.on('error', function (file, data) {
                        if (file == 'Q_TYPE_DENIED')
                            parent._LIGERDIALOG.error('请上传html文件，并且文件大小不能为空！');
                        else
                            parent._LIGERDIALOG.error('导入失败');
                    });
                    $.subscribe('tpl:tplUpload:open', function (event, id, mode) {
                        if (!staged) {
                            return parent._LIGERDIALOG.error("已发布版本不可导入");
                        }
                        templateId = id;
                        tplMode = mode;
                        uploader.reset();
                        $(".webuploader-element-invisible", self.$filePickerBtn).trigger("click");
                    });
                },
            };

            /* *************************** 页面功能 **************************** */
            win.parent.getVersion = function () {
                var mgr = retrieve.$searchVersionDDL.ligerGetComboBoxManager();
                return {
                    v: mgr.getValue(),
                    n: mgr.getText()
                };
            }
            win.parent.reloadGrids = function () {
                master.reloadGrid();
            };
            win.parent.closeDialog = function (msg) {
                master.archiveTplInfoDialog.close();
                if (msg)
                    parent._LIGERDIALOG.success(msg);
            };
            pageInit();
        });
    })(jQuery, window);

//    增加 基础信息管理-->卫生机构-->模板配置 返回上一页跳转链接
    function getUrl() {
        $('#contentPage').empty();
        $('#contentPage').load('${contextRoot}/organization/initial');
    }

</script>