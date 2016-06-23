<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script>

    (function ($, win) {
        $(function () {
            var grid, editDialog;
            var urls = {
                list: '${contextRoot}/resource/meta/list',
                del: '${contextRoot}/resource/meta/delete',
                gotoModify: '${contextRoot}/resource/meta/gotoModify',
                upload: "${contextRoot}/resource/meta/import",
                gotoImportLs: "${contextRoot}/resource/meta/gotoImportLs"
            }

            //跳转新增修改
            var gotoModify = function (event, id, mode) {
                mode = mode || 'new';
                id = id || '';
                editDialog = openDialog(urls.gotoModify, mode=='new'?'新增':'修改', 440, 560, {id: id, mode: mode});
            }


            var del = function (event, id) {
                batchDel(grid, find, urls.del, id, undefined, undefined, '失效', '确定进行失效操作？');
            }

            var uploadDialog;
            //初始化工具栏
            var barTools = function(){

                var btn = [
                    {type: 'edit', clkFun: gotoModify}
                ];
                initBarBtn($('.m-retrieve-inner'), btn)

                function onUploadSuccess(g, result){
                    openDialog(urls.gotoImportLs, "导入错误信息", 1000, 640, {result: result});
                }

                $('#upd').uploadFile({url: "${contextRoot}/resource/meta/import", onUploadSuccess: onUploadSuccess});

            };


            function opratorRender(row){
                var vo = [
                    {type: 'edit', clkFun: "$.publish('meta:modify',['"+ row['id'] +"', 'modify'])"},
                    {type: 'lock', clkFun: "$.publish('meta:del',['"+ row['id'] +"'])"},
                ];
                return initGridOperator(vo);
            }

            //初始化表格
            var rendGrid = function(){
                var columns = [
                    {display: '资源标准编码', name: 'id', width: '20%', align: 'left'},
                    {display: '业务领域', name: 'domainName', width: '10%', align: 'left'},
                    {display: '内部标识符', name: 'stdCode', width: '15%', align: 'left'},
                    {display: '数据元名称', name: 'name', width: '10%', align: 'left'},
                    {display: '类型', name: 'columnTypeName', width: '10%', align: 'left'},
                    {display: '关联字典', name: 'dictName', width: '10%', align: 'left'},
                    {display: '是否可为空', name: 'nullAble', width: '10%', align: 'left', render: function (row) {
                        return row.nullAble ==1 ? '是' : '否';
                    }},
                    {display: '操作', name: 'operator', width: '15%', render: opratorRender}];

                grid = initGrid($('#gtGrid'), urls.list, {}, columns, {delayLoad: true, checkbox: false});
                searchFun();
            };

            var searchFun = function () {
                find(1);
            }

            //初始化过滤
            var filters = function(){
                var vo = [
                    {type: 'text', id: 'ipt_search'},
                    {type: 'select', id: 'ipt_search_type', opts:{width: 140}, dictId: 30},
                    {type: 'select', id: 'ipt_search_null_able', opts:{width: 140}, dictId: 18},
                    {type: 'select', id: 'ipt_search_is_valid', opts:{width: 140}, dictId: 18},
                    {type: 'searchBtn', id: 'search_btn', searchFun: searchFun}
                ];
                initFormFields(vo, $('.m-retrieve-inner'));
            };

            //查询列表
            var find = function (curPage) {
                var vo = [
                    {name: 'stdCode', logic: '?', fields: 'id,name'},
                    {name: 'columnType', logic: '='},
                    {name: 'nullAble', logic: '=', cover: function (v) {
                        if(v=='true')
                            return 1;
                        return 0;
                    }},
                    {name: 'valid', logic: '=', cover: function (v) {
                        if(v=='true')
                            return 0;
                        return 1;
                    }}
                ];
                var f = covertFilters(vo, $('#searchForm'));
                var valid = "valid";
                if($.Util.isStrEquals(f.indexOf(valid),-1)){
                    f += valid+"=1";
                }
                var params = {filters: f};
                reloadGrid(grid, curPage, params);
            };

            var publishFunc = function (){
                $.subscribe('meta:modify', gotoModify);
                $.subscribe('meta:del', del);
            };

            win.closeDialog = function(msg){
                if(editDialog){
                    editDialog.close();
                    if(msg){
                        $.Notice.success(msg);
                        find();
                    }
                }
            }

            var pageInit = function(){
                publishFunc();
                filters();
                barTools();
                rendGrid();
            }();
        });
    })(jQuery, window);

</script>