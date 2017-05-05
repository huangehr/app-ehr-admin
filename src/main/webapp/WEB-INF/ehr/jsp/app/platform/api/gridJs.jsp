<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/searchTree.js"></script>
<script>

    (function ($, win) {
        $(function () {
            var Util = $.Util;
            var openedDialog;
            var appId = '${dataModel}';
            var contentH = $('.l-layout-center').height();
            var parms = {appId:appId};
            var urls = {
                gotoModify: '${contextRoot}/app/api/gotoModify',
                tree: '${contextRoot}/app/api/tree',
                list: '${contextRoot}/app/api/list',
                del: '${contextRoot}/app/api/delete',
                apiEdit: "${contextRoot}/app/api/edit",
                existence: "${contextRoot}/app/api/existence"
            };

            function searchParent(searchDoms){
                var parent = [], p = null;
                $.each(searchDoms, function (i, v) {
                    $(v).removeClass('l-grid-row-hide');
                    if(( p = master.tree.getParent( v )))
                        parent.push(master.tree.getRowObj(p));
                })
                if(parent.length>0)
                    searchParent(parent);
            }

            var master = {
                tree: undefined,
                dialog: undefined,
                init: function () {
                    var m = this;
                    m.filters();
                    m.rendTreeGrid();
                },
                searchFun: function (t) {

                    var name = $('#l_search_name').val();
                    sessionStorage.setItem("appApiTreeParm", name);

                    var treeDom = master.tree.grid;
                    var allrow =  $('.l-grid-row', treeDom);
                    if(name==''){
                        allrow.removeClass('l-grid-row-hide');
                        allrow.show();
                        $('.l-grid-body.l-grid-body2.l-scroll', treeDom).height($('.l-grid-row:visible', treeDom).length * 41);
                    }else{
                        master.tree.expandAll();
                        allrow.addClass('l-grid-row-hide');

                        var searchDoms = $('.l-grid-row-cell-inner[title*="'+ name +'"]', treeDom).parent().parent();
                        searchParent(searchDoms);
                    }
                    if(!t){
                        $('.l-grid-body-inner', $('#rightGrid')).empty();
                        $('.l-grid-body.l-grid-body1', $('#rightGrid')).empty();
                    }
                },
                filters: function(){
                    var vo = [{type: 'text', id: 'l_search_name', searchFun: master.searchFun}];
                    initFormFields(vo, $('.l-tools'));
                },
                rendTreeGrid: function () {
                    this.tree = $("#treeMenu").ligerGrid($.LigerGridEx.config({
                        rownumbers: false,
                        allowAdjustColWidth: false,
                        usePager: false,
                        height: contentH - 12,
                        tree: {columnId: 'name'},
                        url: urls.tree,
                        parms: parms,
                        columns: [
                            {
                                display: '组织结构名称', name: 'name', id: 'name', align: 'left', width: '290',
                                render: function (row) {
                                    var iconName = "";
                                    switch (parseInt(row.type)){
                                        case -1: iconName= '1ji_icon'; break;
                                        case 0: iconName= '3ji_icon'; break;
                                        case 2: iconName= '2ji_icon'; break;
                                        default : iconName= '3ji_icon';
                                    }
                                    return '<img src="${contextRoot}/develop/images/'+ iconName +'.png" class="row-icon">'
                                            +'<div id="t_'+ row.id +'">'+ row.name +'</div>';
                                }
                            },
                            {
                                display: '操作', name: 'operator', align: 'left', width: '70', render: function (row) {
                                    var html =
                                            '<sec:authorize url="/app/api/create"><a class="image-create" href="#" title="新增" ' +
                                            'onclick="javascript:' + Util.format("$.publish('{0}',['{1}','{2}','{3}','{4}', '{5}', '{6}'])", "app:plf:api:modify", row.id, 'new', row.type, 0, row.__id, row.appId) + '"></a></sec:authorize>';

                                    if(row.id>0){
                                        html +=  '<sec:authorize url="/app/api/delete"><a class="grid_delete" href="#" style="width: 30px; margin-left:4px" title="删除" ' +
                                                'onclick="javascript:' + Util.format("$.publish('{0}',['{1}', '{2}', '{3}'])", "app:plf:api:del", row.id, 0, row.__id) + '"></a></sec:authorize>';
                                    }
                                    return html;
                                }
                            }
                        ],
                        onSelectRow: function (rowData, rowId, rowObj) {
                            sessionStorage.setItem("appApiTreeSelId", rowData.id);
                            em.find(rowData.id);
                        },
                        onDblClickRow: function (rowData, rowId, rowObj) {
                            if( rowData.id &&  rowData.id>0)
                                em.gotoModify(undefined, rowData.id, 'view', rowData.type, 0, rowId);
                        },
                        onAfterShowData: function () {
                            if(p==1){
                                var appApiEm = sessionStorage.getItem("appApiEm");
                                if(appApiEm){
                                    appApiEm = eval('('+appApiEm +')');
                                    fillForm(appApiEm, $('#r_searchForm'));
                                }

                                $('#l_search_name').val(sessionStorage.getItem("appApiTreeParm") || '');
                                master.searchFun(1);
                                var selId = sessionStorage.getItem("appApiTreeSelId");
                                if(selId){
                                    var rowDom = $('#t_'+selId, master.tree.tree).parent().parent().parent().parent().parent();
                                    master.tree.select(rowDom.attr('id').split('|')[2]);
                                }
                            }
                        }
                    }));
                }
            }


            var em = {
                grid: undefined, dialog: undefined, params: {},
                //初始化
                init: function () {
                    var m = this;
                    m.filters();
                    m.rendGrid();
                    m.publishFunc();
                },
                filters: function(){
                    var vo = [
                        {type: 'text', id: 'r_search_name'},
                        {type: 'select', id: 'r_search_open_lv', opts:{width: 140}, dictId: 40},
                        {type: 'searchBtn', id: 'search_btn', searchFun: em.find}
                    ];
                    initFormFields(vo, $('.r-tools'));
                },
                //初始化表格
                rendGrid: function () {
                    var m = em;
                    var columns = [
                        {display: 'ID', name: 'id', hide: true},
                        {display: '名称', name: 'name', width: '35%', align: 'left'},
                        {display: '描述', name: 'description', width: '35%', align: 'left'},
                        {display: '开放程度', name: 'openLevelName', width: '10%', align: 'left'},
                        {display: '操作', name: 'operator', width: '20%', render: m.opratorRender}];

                    m.grid = initGrid($('#rightGrid'), urls.list, {}, columns, {
                        delayLoad: true,
                        rownumbers: true,
                        usePager: false,
                        heightDiff: 20,
                        checkbox: false,
                        onDblClickRow: function (rowData, rowId, rowObj) {
                            if( rowData.id &&  rowData.id>0)
                                em.gotoModify(undefined, rowData.id, 'view', rowData.type, 0, rowId);
                        }
                    });
                },
                //操作栏渲染器
                opratorRender: function (row) {
                    var vo = [
						<sec:authorize url="/app/api/update">
                        {
                            type: 'edit',
                            clkFun: "$.publish('app:plf:api:modify',['" + row['id'] + "', 'modify', '" + row['type'] + "', '1', '"+ row.__id +"'])"
                        },
						</sec:authorize>
						<sec:authorize url="/app/api/delete">
                        {type: 'del', clkFun: "$.publish('app:plf:api:del',['" + row['id'] + "', 1, '" + row.__id + "', '" + row.parentId + "', '" + row.type + "'])"}
						</sec:authorize>
					];
                    return initGridOperator(vo);
                },
                //修改、新增点击事件
                gotoModify: function (event, id, mode, type, frm, rowId, appId) {
                    if(type==1){
                        var obj = em.grid.getRow(rowId);
                        var url = urls.apiEdit + '?treePid=1&treeId=11&mode='+ mode;
                        $("#contentPage").empty();
                        $("#contentPage").load(url, obj);
                    }else{
                        var params;
                        if(mode == 'new'){
                            em.params = {upType: type, upId: id, frm: frm, rowId: rowId, appId: appId}
                            params = {mode: mode}
                        }else{
                            em.params = {frm: frm,  rowId: rowId}
                            params = {id: id, mode: mode, rowId: rowId}
                        }
                        em.dialog = openedDialog = openDialog(urls.gotoModify,
                                mode == 'new'?'新增': mode == 'modify'? '修改': '查看', 480, 650, params);
                    }
                },
                del: function (event, id, frm, rowId, parentId, type) {

                    function del(){
                        $.ligerDialog.confirm("确定删除?", function (yes) {
                            if (yes){
                                var dialog = $.ligerDialog.waitting('正在处理中,请稍候...');
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote(urls.del, {
                                    data: {ids: id, idField: "id", type: "uniq"},
                                    success: function (data) {
                                        if (data.successFlg) {
                                            $.Notice.success('删除成功！');
                                            if(frm==0)
                                                master.tree.remove(master.tree.getRow(rowId));
                                            else{
                                                if(type==1){
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
                                if(data.detailModelList.length==0)
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
                find: function (parentId) {
                    if(parentId>=0 || parentId==-1)
                        $('#parentId').val(parentId);
                    var vo = [
                        {name: 'name', logic: '?'},
                        {name: 'openLevel', logic: '='},
                        {name: 'parentId', logic: '='}];
                    var $form = $('#r_searchForm');
                    $form.attrScan();
                    sessionStorage.setItem("appApiEm", JSON.stringify($form.Fields.getValues()));
                    var params = {filters: covertFilters(vo, $form), page: 1, rows: 999};
                    reloadGrid(em.grid, 1, params);
                },
                publishFunc: function () {
                    var m = em;
                    $.subscribe('app:plf:api:modify', m.gotoModify);
                    $.subscribe('app:plf:api:del', m.del);
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
                if (msg)
                    $.Notice.success(msg);

                if(data){
                    if(em.params.frm==0){
                        if(data.obj.type==1){
                            em.grid.appendRow(data.obj);
                        }else{
                            var parent = master.tree.getRow(em.params.rowId);
                            master.tree.appendRow(data.obj, parent);
                            master.tree.select(parent);
                        }
                    }else{
                        var rowDom = em.grid.getRow(em.params.rowId);
                        em.grid.updateRow(rowDom, data.obj);
                        if(data.obj.type!=1){
                            rowDom = master.tree.getRow($('#t_'+ data.obj.id, $('#treeMenu')).parent().parent().parent().parent().attr('id').split('|')[2]);
                            master.tree.updateRow(rowDom, data.obj);
                        }
                    }
                }
            }

            win.getEditParms = function () {
                return em.params;
            }
        });
    })(jQuery, window);

</script>