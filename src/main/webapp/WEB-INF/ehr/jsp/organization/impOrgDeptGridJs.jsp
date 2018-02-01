<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script>

    (function ($, win) {
        $(function () {
            var grid;
            var urls = {
                list: '${contextRoot}/orgDeptImport/importLs',
                <%--userExistence: "${contextRoot}/orgDeptImport/userIsExistence",--%>
                orgDeptExistence: "${contextRoot}/orgDeptImport/orgDeptIsExistence",
                <%--batchSave: "${contextRoot}/doctorImport/batchSave",--%>
                downLoad: "${contextRoot}/orgDeptImport/downLoadErrInfo",
                <%--dictCombo: "${contextRoot}/doctorImport/searchCombo"--%>
            }
            var files = ${files};
            var mode = 'eFile';


            //初始化工具栏
            var barTools = function(){


                function downLoad(){
                    $('#downLoadIfm').attr('src', urls.downLoad + "?f=" + files.eFile[1] + "&datePath=" + files.eFile[0] + "&tim=" + new Date());
                }

                var btn = [
                    {type: '导出错误信息', clkFun: downLoad, downLoad: 'downLoad', id: 'downLoad'}];
                initBarBtn($('#sf-bar'), btn);
                $('#downLoad').addClass('u-btn-lar');

            };

            function opratorRender(row){
                var vo = [];
                return initGridOperator(vo);
            }

            var $form =  $("#gridForm"), validator;
            function onAfterShowData(data){
//                $('.l-grid-row-cell-inner').attr('title', '');
                validator = initValidate($form, function (elm) {
                    var field = $(elm).attr('id');
                    var val = $('#' + field).val();
                    var oldVal = $(elm).attr('data-old-val');
                    var errMsg = $(elm).attr('err-msg');
                    if(oldVal==val && errMsg && errMsg!='undefined' && errMsg!=''){
                        var result = new $.jValidation.ajax.Result();
                        result.setResult(false);
                        result.setErrorMsg(errMsg);
//                        $(elm).attr('err-msg', '');
                        return result;
                    }

                    if(field.indexOf('code')!=-1){
                        return uniqValid(urls.orgDeptExistence, "code="+val, "该部门编号在部门表中已存在！");
                    }
                    if(field.indexOf('orgCode')!=-1){
                        return uniqValid(urls.orgDeptExistence, "orgCode<>"+val, "该机构代码不存在！");
                    }
                });
                validator.validate();
            }

            function textRender(row, index, name, column){
                if(mode=='tFile')
                    return row[column.name];

                var id = column.name + '_'+ index,
                        val = row[column.name] || '',
                        errMsg = row['errorMsg'][column.name];

                var html;
                if(!errMsg || errMsg=='' || errMsg=='undefined'){
                    html = '<input type="hidden" id="'+ id +'" data-attr-scan="'+ id +'" value="'+ val +'"/>';
                    html += '<label title="'+val+'" style="font-weight:initial;">'+val+'</label>';
                }
                else{
                    var ajaxClz = ['required'];
//                    if( column.name=='id') ajaxClz.push('validate-meta-id');
                    if( column.name=='code' || column.name=='orgCode' || column.name=='name') ajaxClz.push('ajax');
                    html = '<input data-old-val="'+ val +'" title="'+ val+'" type="text" id="'+ id +'" err-msg="'+ errMsg +'" class="'+ ajaxClz.join(' ') +'" data-attr-scan="'+ id +'"/>';
                    html += '<script>initText("'+ id +'"," '+ column.width +'", "'+ val +'")<\/script>';
                }
                return html;
            }
            win.initText = function(id, width, value){
                $("#"+ id).ligerTextBox({width: width - 20, value: value});
            }


            //初始化表格
            var rendGrid = function(){
                var columns = [
                    {display: '排序号', name: 'excelSeq', hide: true, render: function (row, index) {
                        return '<input type="hidden" value="'+ row.excelSeq +'" data-attr-scan="excelSeq_'+ index +'">'
                     }},
                    {display: '部门编号', name: 'code', width: '10%', align: 'left', render: textRender},
                    {display: '部门名称', name: 'name', width: '5%', align: 'left', render: textRender},
                    {display: '父级部门编号', name: 'parentDeptId', width: '7%',hide: true, align: 'left', render: textRender},
                    {display: '父级部门名称', name: 'parentDeptName', width: '7%',hide: true, align: 'left', render: textRender},
                    {display: '科室电话', name: 'phone', width: '12%', align: 'left', render: textRender},
                    {display: '科室荣誉(国家重点科室,省级重点科室,医院特色专科)', name: 'gloryId', width: '20%', align: 'left', render: textRender},
                    {display: '机构代码', name: 'orgCode', width: '10%', align: 'left', render: textRender},
                    {display: '所属机构', name: 'orgName', width: '10%', align: 'left', render: textRender},
                    {display: '科室介绍', name: 'introduction', width: '13%', align: 'left', render: textRender},
                    {display: '科室位置', name: 'place', width: '10%', align: 'left', render: textRender},
                    {display: '科室类型', name: 'pyCode', width: '10%', align: 'left', render: textRender}];

                grid = $('#impGrid').ligerGrid($.LigerGridEx.config({
                    url: urls.list,
                    columns:columns,
                    height: 520,
                    pageSize:10,
                    pageSizeOptions:[10, 15],
                    delayLoad: true,
                    checkbox: false,
                    onAfterShowData: onAfterShowData
                }))
                grid.adjustToWidth();
                    //initGrid($('#impGrid'), urls.list, {}, columns, {height: 520, pageSize:10, pageSizeOptions:[10, 15], delayLoad: true, checkbox: false, onAfterShowData: onAfterShowData});
                searchFun();
            };

            var searchFun = function () {
                find(1);
            }

            //初始化过滤
            var filters = function(){
                var vo = [];
//                initFormFields(vo, $('.m-retrieve-inner'));
            };

            //查询列表
            var find = function (curPage) {
                var vo = [];
                var params = {filenName: files[mode][1], datePath: files[mode][0]}
                reloadGrid(grid, curPage, params);
            }

            var publishFunc = function (){

            };


            var pageInit = function(){
                publishFunc();
                filters();
                barTools();
                rendGrid();
            }();
        });
    })(jQuery, window);

</script>