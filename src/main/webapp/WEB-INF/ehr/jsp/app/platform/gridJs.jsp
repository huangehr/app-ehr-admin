<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script>

    (function ($, win) {
        $(function () {
            var grid, editDialog;
            var dataModel = '${dataModel}';
            var urls = {
                list: '${contextRoot}/app/platform/list',
                del: '${contextRoot}/app/platform/delete',
                gotoModify: '${contextRoot}/app/platform/gotoModify',
                manager: '${contextRoot}/app/feature/initial'
            }

            //跳转新增修改
            var gotoModify = function (event, id, mode) {
                mode = mode || 'new';
                id = id || '';
                editDialog = openDialog(urls.gotoModify, mode=='new'?'新增':'修改', 500, 560, {id: id, mode: mode});
            }

            var del = function (event, id) {
                batchDel(grid, find, urls.del, id);
            }

            //跳转新增修改
            var manager = function (event, id, name) {
                var url = urls.manager + '?treePid=1&treeId=11';
                $("#contentPage").empty();
                $("#contentPage").load(url, {"dataModel": id+","+name});
            }

            //初始化工具栏
            var barTools = function(){
                var btn = [{type: 'edit', clkFun: gotoModify}];
                initBarBtn($('.m-retrieve-inner'), btn);
            };

            function opratorRender(row){
                var vo = [
                    {type: '功能管理', clkFun: "$.publish('app:platform:manager',['"+ row['id'] +"','"+ row['name'] +"'])"},
                    {type: 'edit', clkFun: "$.publish('app:platform:modify',['"+ row['id'] +"', 'modify'])"}];
                return initGridOperator(vo);
            }

            //初始化表格
            var rendGrid = function(){
                var columns = [
                    {display: '应用名称', name: 'name', width: '20%', align: 'left'},
                    {display: '应用代码', name: 'code', width: '10%', align: 'left'},
                    {display: '应用密钥', name: 'secret', width: '10%', align: 'left'},
                    {display: '机构名称', name: 'orgName', width: '15%', align: 'left'},
                    {display: '应用类型', name: 'catalogName', width: '10%', align: 'left'},
                    {display: '回调URL', name: 'url', width: '20%', align: 'left'},
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
                    {type: 'select', id: 'ipt_search_type', opts:{width: 140}, dictId: 1},
                    {type: 'searchBtn', id: 'search_btn', searchFun: searchFun}
                ];
                initFormFields(vo, $('.m-retrieve-inner'));
            };

            //查询列表
            var $parmsForm =  $('#searchForm');
            var find = function (curPage) {
                var params = {};
                if(dataModel=='1'){
                    dataModel = '0';
                    var cacheParms = eval('('+ sessionStorage.getItem("platformParms") +')');
                    sessionStorage.removeItem("platformParms");
                    params = cacheParms.params;
                    curPage = cacheParms.curPage;
                    $parmsForm.attrScan();
                    $parmsForm.Fields.fillValues(cacheParms.parmsForm);
                }else{
                    var vo = [
                        {name: 'name', logic: '?'},
                        {name: 'sourceType', logic: '='},
                        {name: 'catalog', logic: '='}
                    ];
                    params = {filters: covertFilters(vo, $parmsForm), sorts: "name"};
                    sessionStorage.setItem("platformParms", JSON.stringify({params: params, curPage: curPage, parmsForm:  $parmsForm.Fields.getValues()}));
                }
                reloadGrid(grid, curPage, params);
            };

            var publishFunc = function (){
                $.subscribe('app:platform:modify', gotoModify);
                $.subscribe('app:platform:del', del);
                $.subscribe('app:platform:manager', manager);
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