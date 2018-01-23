<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>

<script>
    var dataModel = $.DataModel.init();
    var detailDialog, grid, tree, tmpSettingDialog;
    var reportCategoryId = '', reportId = '';
    var $filePickerBtn = $('#filePickerBtn');

    $(function () {
        init();
    });

    function init() {
//        resize();
        initWidget();
        bindEvents();
    }

    function initWidget() {
        $('#treeContainer').mCustomScrollbar({ axis: "yx"});

        $('#searchCategoryNm').ligerTextBox({
            width: 200, isSearch: true, search: function () {
                tree.s_search($('#searchCategoryNm').val());
                reportCategoryId = '';
                reloadGrid();
            }
        });

        tree = $('#tree').ligerSearchTree({
            url: '${contextRoot}/resource/reportCategory/getComboTreeData',
            width: 240,
            idFieldName: 'id',
            parentIDFieldName :'pid',
            textFieldName: 'name',
            checkbox: false,
            isExpand: false,
            childIcon:null,
            parentIcon:null,
            onSelect: function (e) {
                reportCategoryId = e.data.id;
                reloadGrid();
            },
            onCancelselect: function (e) {
                reportCategoryId = '';
                reloadGrid();
            }
        });

        $('#searchNm').ligerTextBox({
            width: 200, isSearch: true, search: function () {
                reloadGrid();
            }
        });

        grid = $("#grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/resource/report/search',
            parms: { reportCategoryId: reportCategoryId },
            columns: [
                {display: 'ID', name: 'id', width: '0.1%', hide: true},
                {display: 'status', name: 'status', width: '0.1%', hide: true},
                {display: '报表名称', name: 'name', width: '15%', isAllowHide: false, align: 'left'},
                {display: '报表编码', name: 'code', width: '15%', isAllowHide: false, align: 'left'},
                {display: '状态', name: 'statusName', width: '5%', isAllowHide: false, align: 'center'},
                {display: '报表模板', name: 'templatePath', width: '20%', isAllowHide: false, align: 'center'},
                {display: '备注', name: 'remark', width: '15%', isAllowHide: false, align: 'left'},
                {display: '操作', name: 'operator', minWidth: 250, align: 'center',
                    render: function (row) {
                        var html = '';
                        html += '<sec:authorize url="/resource/report/tmpViewSetting"><a class="label_a f-ml10" title="视图配置" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}', '{2}'])", "resource:report:tmpViewSetting", row.id, row.code) + '">模板视图配置</a></sec:authorize>';
                        <%--html += '<sec:authorize url="/resource/report/setting"><a class="label_a f-ml10" title="视图配置" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "resource:report:setting", row.id) + '">视图配置</a></sec:authorize>';--%>
                        <%--html += '<sec:authorize url="/resource/report/upload"><a class="label_a f-ml10" title="模版导入" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "resource:report:upload", row.id) + '">模版导入</a></sec:authorize>';--%>
                        <%--html += '<sec:authorize url="/resource/report/preview"><a class="label_a f-ml10" title="预览" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}', '{2}'])", "resource:report:preview", row.code, row.templatePath) + '">预览</a></sec:authorize>';--%>
                        html += '<sec:authorize url="/resource/report/detail"><a class="grid_edit f-ml10" title="编辑" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}','{2}'])", "resource:report:open", row.id, 'modify') + '"></a></sec:authorize>';
                        html += '<sec:authorize url="/resource/report/delete"><a class="grid_delete" title="删除" href="javascript:void(0)"  onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "resource:report:delete", row.id) + '"></a></sec:authorize>';
                        return html;
                    }
                }
            ],
            allowHideColumn: false,
            usePager: true
        }));
        grid.adjustToWidth();

        $filePickerBtn.instance = $filePickerBtn.webupload({
            pick: {id: '#filePickerBtn'},
            auto: true,
            server: '${contextRoot}/resource/report/upload',
            accept: {
                title: 'Html',
                extensions: 'html',
                mimeTypes: 'text/html'
            }
        });
    }

    function bindEvents() {
//        $(window).bind('resize', function() {
//            resize();
//        });

        // 视图配置
        $.subscribe('resource:report:setting', function (event, id) {
            detailDialog = parent._LIGERDIALOG.open({
                height: 700,
                width: 800,
                title: '报表视图配置',
                url: '${contextRoot}/resource/report/setting',
                urlParms: {id: id},
                opener: true,
                load: true
            });
        });


        // 模板视图配置
        $.subscribe('resource:report:tmpViewSetting', function (event, id, code) {
            var wait = parent._LIGERDIALOG.waitting("请稍后...");
            tmpSettingDialog = parent._LIGERDIALOG.open({
                height: 700,
                width: 1000,
                title: '模板视图配置',
                url: '${contextRoot}/resource/report/tmpViewSetting',
                urlParms: {id: id, code: code},
                opener: true,
                load: true,
                onLoaded: function () {
                    wait.close();
                    tmpSettingDialog.show();
                }
            });
            tmpSettingDialog.hide();
        });

        // 模版导入
        var uploader = $filePickerBtn.instance;
        $.subscribe('resource:report:upload', function (event, id) {
            reportId = id;
            uploader.reset();
            $(".webuploader-element-invisible", $filePickerBtn).trigger("click");
        });
        uploader.on('beforeSend', function (file, data) {
            data.id = reportId;
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
                parent._LIGERDIALOG.error('请上传html的非空文件！');
            else
                parent._LIGERDIALOG.error('导入失败');
        });

        // 预览
        $.subscribe('resource:report:preview', function (event, code, templatePath) {
            if(!templatePath) {
                parent._LIGERDIALOG.warn('请先导入报表模版！');
                return;
            }

            detailDialog = parent._LIGERDIALOG.open({
                height: 700,
                width: 1100,
                title: '报表预览',
                url: '${contextRoot}/resource/report/preview',
                urlParms: {code: code},
                opener: true,
                load: true
            });
        });

        // 新增/修改
        $.subscribe('resource:report:open', function (event, id, mode) {
            var title = '新增资源报表';
            if (mode == 'modify') {
                title = '修改资源报表';
            }
            detailDialog = parent._LIGERDIALOG.open({
                height: 600,
                width: 480,
                title: title,
                url: '${contextRoot}/resource/report/detail',
                urlParms: {
                    id: id,
                    mode: mode
                },
                opener: true,
                load: true
            });
        });

        // 删除
        $.subscribe('resource:report:delete', function (event, id) {
            parent._LIGERDIALOG.confirm('确认要删除所选数据吗？', function (r) {
                if (r) {
                    var loading = parent._LIGERDIALOG.waitting("正在删除数据...");
                    dataModel.updateRemote('${contextRoot}/resource/report/delete', {
                        data: {id: parseInt(id)},
                        success: function (data) {
                            if (data.successFlg) {
                                parent._LIGERDIALOG.success('删除成功！');
                                reloadGrid();
                            } else {
                                parent._LIGERDIALOG.error(data.errorMsg);
                            }
                        },
                        error: function () {
                            parent._LIGERDIALOG.error('删除发生异常');
                        },
                        complete: function () {
                            loading.close();
                        }
                    });
                }
            })
        });
    }

    function reloadGrid(currentPage) {
        currentPage = currentPage || 1;
        var params = {
            reportCategoryId: reportCategoryId,
            codeName: $('#searchNm').val()
        };
        $.Util.reloadGrid.call(grid, '${contextRoot}/resource/report/search', params, currentPage);
    }
    /*-- 与 Dialog 页面间回调的函数 --*/
    window.parent.reloadMasterGrid = function() {
        reloadGrid();
    };
    window.parent.closeDetailDialog = function (type, msg) {
        detailDialog.close();
        msg && parent._LIGERDIALOG.success(msg);
    };
    window.parent.closeTmpSettingDialogDialog = function (type, msg) {
        tmpSettingDialog.close();
        tmpSettingDialog = null;
        msg && parent._LIGERDIALOG.success(msg);
    };

</script>
