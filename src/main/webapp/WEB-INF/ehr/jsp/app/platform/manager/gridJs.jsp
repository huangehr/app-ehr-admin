<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>

    (function ($, win) {
        $(function () {
            var Util = $.Util;
            var openedDialog, curOprator;
            var p = '${dataModel}'.split(",");
            var contentH = $('.l-layout-center').height();

            var urls = {
                gotoModify: '${contextRoot}/app/feature/gotoModify',
                tree: '${contextRoot}/app/feature/tree',
                list: '${contextRoot}/app/feature/list',
                del: '${contextRoot}/app/feature/delete',
                existence: "${contextRoot}/app/feature/existence"
            };

            var initSub = function () {
                $('#btn_back').click(function () {
                    $('#contentPage').empty();
                    $('#contentPage').load('${contextRoot}/app/platform/initial', {dataModel: 1});
                });
            }();

            var master = {
                tree: undefined,
                dialog: undefined,
                init: function () {
                    var m = this;
                    m.rendTreeGrid();
                },
                rendTreeGrid: function () {
                    function collapse(grid, data){
                        for(var i=0;i<data.length;i++){
                            var row = data[i];
                            if(row.children && row.children.length>0){
                                grid.collapse(row);
                                collapse(grid, row.children)
                            }
                        }
                    }
                    this.tree = $("#treeMenu").ligerGrid($.LigerGridEx.config({
                        rownumbers: false,
                        allowAdjustColWidth: false,
                        usePager: false,
                        height: contentH - 12,
                        tree: {columnId: 'name', parentIDFieldName:'parentId'},
                        url: urls.tree,
                        parms: {appId: p[0], appName: p[1]},
                        columns: [
                            {
                                display: '组织结构名称', name: 'name', id: 'name', align: 'left', width: '290',
                                render: function (row) {
                                    var iconName = "";
                                    switch (parseInt(row.type)){
                                        case 0: iconName= '1ji_icon'; break;
                                        case 1: iconName= '2ji_icon'; break;
                                        case 2: iconName= '3ji_icon'; break;
                                        default : iconName= '3ji_icon';
                                    }
                                    return '<img src="${contextRoot}/develop/images/'+ iconName +'.png" class="row-icon">' +
                                            '<div id="t_'+ row.id +'">'+ row.name +'</div>';
                                }
                            },
                            {
                                display: '操作', name: 'operator', align: 'left', width: '70', render: function (row) {
                                    var html =
                                            '<a class="image-create" href="#" title="新增" ' +
                                            'onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}', '{5}'])", "app:plf:man:modify", row.id, 'new', row.type, 0, row.__id) + '"></a>';

                                    if(row.id>0){
                                        html +=  '<a class="grid_delete" href="#" style="width: 30px; margin-left:4px" title="删除" ' +
                                                'onclick="javascript:' + Util.format("$.publish('{0}',['{1}', '{2}', '{3}', '{4}'])", "app:plf:man:del", row.id, 0, row.__id, undefined, undefined, row.url) + '"></a>';
                                    }
                                    return html;
                                }
                            }
                        ],
                        onSelectRow: function (rowData, rowId, rowObj) {
                            em.find(rowData.id);
                        },
                        onDblClickRow: function (rowData, rowId, rowObj) {
                            if( rowData.id)
                                em.gotoModify(undefined, rowData.id, 'view', rowData.type, 0, rowId);
                        },
                        onAfterShowData:function(currentData){
                            var modules = currentData.detailModelList[0].children;
                            if(modules && modules.length>0)
                                collapse(this, modules);
//                                for(var i=0;i<modules.length;i++){
//                                    var row = modules[i];
//                                    if(row.children.length>0){
//                                        this.collapse(row);
//                                    }
//                                }
                        }
                    }));
                }
            }


            var em = {
                grid: undefined, dialog: undefined, params: {},
                //初始化
                init: function () {
                    var m = this;
                    m.rendGrid();
                    m.publishFunc();
                },
                //初始化表格
                rendGrid: function () {
                    var m = em;
                    var columns = [
                        {display: 'ID', name: 'id', hide: true},
                        {display: '名称', name: 'name', width: '20%', align: 'left'},
                        {display: '编码', name: 'code', width: '20%', align: 'left'},
                        {display: 'URL', name: 'url', width: '40%', align: 'left'},
                        {display: '操作', name: 'operator', width: '20%', render: m.opratorRender}];

                    m.grid = initGrid($('#rightGrid'), urls.list, {}, columns, {
                        delayLoad: true,
                        rownumbers: true,
                        usePager: false,
                        heightDiff: 20,
                        checkbox: false,
                        onDblClickRow: function (rowData, rowId, rowObj) {
                            em.gotoModify(undefined, rowData.id, 'view', rowData.type, 0, rowId);
                        }
                    });
                },
                //操作栏渲染器
                opratorRender: function (row) {
                    var vo = [
                        {
                            type: 'edit',
                            clkFun: "$.publish('app:plf:man:modify',['" + row['id'] + "', 'modify', '" + row['type'] + "', '1', '"+ row.__id +"'])"
                        },
                        {type: 'del',
                            clkFun: "$.publish('app:plf:man:del',['" + row['id'] + "', 1, '" + row.__id + "', '" + row.parentId + "', '" + row.type + "', '" + row.url + "'])"}
                    ];
                    return initGridOperator(vo);
                },
                //修改、新增点击事件
                gotoModify: function (event, id, mode, type, frm, rowId) {
                    var params;
                    if(mode == 'new'){
                        em.params = {upType: type, upId: id, frm: frm, appId: p[0], rowId: rowId}
                        params = {mode: mode}
                    }else{
                        em.params = {frm: frm,  rowId: rowId}
                        params = {id: id, mode: mode, rowId: rowId}
                    }
                    em.dialog = openedDialog = openDialog(urls.gotoModify, mode=='new'?'新增': mode=='modify'? '修改': '查看', 480, 600, params);
                },
                del: function (event, id, frm, rowId, parentId, type, url) {

                    function del(){
                        $.ligerDialog.confirm("确定删除?", function (yes) {
                            if (yes){
                                var dialog = $.ligerDialog.waitting('正在处理中,请稍候...');
                                var dataModel = $.DataModel.init();
                                var extParms = {url: url};
                                dataModel.updateRemote(urls.del, {
                                    data: {ids: id, idField: "id", type: "uniq", extParms: JSON.stringify(extParms)},
                                    success: function (data) {
                                        if (data.successFlg) {
                                            $.Notice.success('删除成功！');
                                            if(frm==0)
                                                master.tree.remove(master.tree.getRow(rowId));
                                            else{
                                                if(type==3){
                                                    em.grid.remove(em.grid.getRow( rowId ));
                                                }else{
                                                    var cell = $('#t_'+ id, $('#treeMenu')).parent().parent().parent().parent();
                                                    var treeRowId = $(cell).attr('id').split('|')[2];
                                                    master.tree.remove( master.tree.getRow( treeRowId ) );
                                                    cell = $('#t_'+ parentId, $('#treeMenu')).parent().parent().parent().parent();
                                                    treeRowId = $(cell).attr('id').split('|')[2];
                                                    master.tree.select( master.tree.getRow( treeRowId ) );
                                                }
                                            }
                                        } else {
                                            $.Notice.error(data.errorMsg);
                                        }
                                    },
                                    complete: function () {dialog.close();},
                                    error: function(){$.Notice.error('请求错误！');}
                                });
                            }
                        });
                    }
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote(urls.existence, {
                        data: {filters: "parentId="+id},
                        success: function (data) {
                            if (data.successFlg) {
                                if(!data.obj)
                                    del();
                                else
                                    $.Notice.error("该删除项存在子项，请先删除子项！");
                            } else {
                                $.Notice.error("验证错误！");
                            }
                        },
                        error: function(){$.Notice.error('请求出错！');}
                    });
                },
                //查询列表方法
                find: function (upId) {
                    var params = {filters: "appId="+ p[0] +";parentId=" + (upId || upId==0  ? upId : -1), page: 1, rows: 999}
                    reloadGrid(this.grid, 1, params);
                },
                //公开方法
                publishFunc: function () {
                    var m = em;
                    $.subscribe('app:plf:man:modify', m.gotoModify);
                    $.subscribe('app:plf:man:del', m.del);
                }
            }

            var resizeContent = function () {
                var contentW = $('#grid_content').width();
                var leftW = $('#div_left').width();
                $('#div_right').width(contentW - leftW - 20);

                $('#treeMenuWrap').height(contentH - 104);
                $('#treeMenu').height(contentH - 64);
            };

            resizeContent();
            //窗体改变大小事件
            $(window).bind('resize', resizeContent);

            em.init();
            master.init();

            win.closeDialog = function (msg, data) {
                openedDialog.close();
                if (msg) {
                    $.Notice.success(msg);
                    if(em.params.frm==0){
                        if(em.params.upType==2){
                            em.grid.appendRow(data.obj);
                        }else{
                            var parent = master.tree.getRow(em.params.rowId);
                            master.tree.appendRow(data.obj, parent);
                            master.tree.select(parent);
                        }
                    }else{
                        var rowDom = em.grid.getRow(em.params.rowId);
                        em.grid.updateRow(rowDom, data.obj);
                    }
                }
            }

            win.getEditParms = function () {
                return em.params;
            }
        });
    })(jQuery, window);

</script>