<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>

<script>
    var dataModel = $.DataModel.init();
    var detailDialog = null;
    var grid = null;

    $(function () {
        init();
    });

    function init() {
        initWidget();
        bindEvents();
    }

    function initWidget() {
        $('#searchNm').ligerTextBox({
            width: 200, isSearch: true, search: function () {
                reloadGrid();
            }
        });

        grid = $("#grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}/resource/report/search',
            columns: [
                {display: 'ID', name: 'id', hide: true},
                {display: '报表名称', name: 'name', width: '15%', isAllowHide: false, align: 'left'},
                {display: '报表编码', name: 'code', width: '15%', isAllowHide: false, align: 'left'},
                {display: '报表分类', name: 'reportCategory', width: '15%', isAllowHide: false, align: 'center'},
                {display: '状态', name: 'statusName', width: '5%', isAllowHide: false, align: 'center'},
                {display: '备注', name: 'remark', width: '15%', isAllowHide: false, align: 'left'},
                {display: '操作', name: 'operator', width: '35%', align: 'center',
                    render: function (row) {
                        var html = '';
                        html += '<sec:authorize url="/resource/report/detail"><a class="l-button u-btn u-btn-primary u-btn-small f-ib f-mb5 f-ml10" title="资源配置" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "resource:report:open", row.id) + '">资源配置</a></sec:authorize>';
                        html += '<sec:authorize url="/resource/report/detail"><a class="l-button u-btn u-btn-primary u-btn-small f-ib f-mb5 f-ml10" title="模版导入" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "resource:report:open", row.id) + '">模版导入</a></sec:authorize>';
                        html += '<sec:authorize url="/resource/report/detail"><a class="l-button u-btn u-btn-primary u-btn-small f-ib f-mb5 f-ml10" title="预览" href="javascript:void(0)" onclick="javascript:' + $.Util.format("$.publish('{0}',['{1}'])", "resource:report:open", row.id) + '">预览</a></sec:authorize>';
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
    }

    function bindEvents() {
        $.subscribe('resource:report:open', function (event, id, mode) {
            var title = '新增资源报表';
            if (mode == 'modify') {
                title = '修改资源报表';
            }
            detailDialog = $.ligerDialog.open({
                height: 560,
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

        $.subscribe('resource:report:delete', function (event, id) {
            $.Notice.confirm('确认要删除所选数据吗？', function (r) {
                if (r) {
                    var loading = $.ligerDialog.waitting("正在删除数据...");
                    dataModel.updateRemote('${contextRoot}/resource/report/delete', {
                        data: {id: parseInt(id)},
                        success: function (data) {
                            if (data.successFlg) {
                                $.Notice.success('删除成功！');
                                reloadGrid();
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        },
                        error: function () {
                            $.Notice.error('删除发生异常');
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
        var params = {codeName: $('#searchNm').val()};
        $.Util.reloadGrid.call(grid, '${contextRoot}/resource/report/search', params, currentPage);
    }

    /*-- 与 Dialog 页面间回调的函数 --*/
    window.reloadMasterGrid = function() {
        reloadGrid();
    };
    window.closeDetailDialog = function (type, msg) {
        detailDialog.close();
        msg && $.Notice.success(msg);
    };

</script>
