<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>

    (function ($, win) {
        $(function () {
            var grid;
            var urls = {
                list: '${contextRoot}/scheduleImport/importLs',
                idOrPhoneIsExistence: "${contextRoot}/scheduleImport/idOrPhoneIsExistence",
                batchSave: "${contextRoot}/scheduleImport/batchSave",
                downLoad: "${contextRoot}/scheduleImport/downLoadErrInfo",
            }
            var files = ${files};
            var mode = 'eFile';


            //初始化工具栏
            var barTools = function(){

                function save(){
                    if(validator.validate()){
                        if($form.Fields)
                            $form.removeData('propMap');
                        $form.attrScan();
                        var waitting = $.ligerDialog.waitting("正在保存中.....");
                        var formData = $form.Fields.getValues();
                        var model = [], f, m;

                        for(var k in formData){
                            f = k.split('_');
                            m = model[f[1]] || {};
                            m[f[0]] = formData[k];
                            model[f[1]] = m;
                        }

                        var dataModel = $.DataModel.init();
                        dataModel.createRemote(urls.batchSave, {
                            data: {schedules: JSON.stringify(model), eFile: files.eFile[1], datePath: files.eFile[0]},
                            success: function (data) {
                                waitting.close();
                                if (data.successFlg) {
                                    $.Notice.success("保存成功!");
                                    searchFun();
                                } else {
                                    if (data.errorMsg)
                                        $.Notice.error(data.errorMsg);
                                    else
                                        $.Notice.error('保存失败！');
                                }
                            },
                            error: function () {
                                waitting.close();
                            }
                        });
                    }else {
                        $.Notice.warn("还有错误数据未修改正确！");
                    }
                }

                function downLoad(){
                    $('#downLoadIfm').attr('src', urls.downLoad + "?f=" + files.eFile[1] + "&datePath=" + files.eFile[0] + "&tim=" + new Date());
                }

                var btn = [
                    {type: '保存', clkFun: save, id: 'impSave'},
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
                $('.l-grid-row-cell-inner').attr('title', '');
                validator = initValidate($form, function (elm) {
                    debugger;
                    var field = $(elm).attr('id');
                    var val = $('#' + field).val();
                    var oldVal = $(elm).attr('data-old-val');
                    var errMsg = $(elm).attr('err-msg');
                    var o= field.split('_');
                    if(oldVal==val && errMsg && errMsg!='undefined' && errMsg!=''){
                        var result = new $.jValidation.ajax.Result();
                        result.setResult(false);
                        result.setErrorMsg(errMsg);
                        return result;
                    }
                    if(field.indexOf('carId')!=-1){
                        debugger
                        return uniqValid(urls.idOrPhoneIsExistence+"?type=id&values="+val,undefined, "该车牌号不存在！");
                    }
                });
                validator.validate();
            }

            function comboRender(row, index, name, column){
                if(mode=='tFile')
                    return row[column.name];
                var id = column.name + '_'+ index,
                        val = row[column.name] || '',
                        errMsg = row['errorMsg'][column.name];

                var html;
                if(!errMsg || errMsg=='' || errMsg=='undefined'){
                    html = '<input type="hidden" id="'+ id +'" data-attr-scan="'+ id +'" value="'+ val +'"/>';
                    html += val;
                }  else{
                    var html = '<input type="text" data-old-val="'+ val +'" err-msg="'+ errMsg +'" id="'+ id +'" data-type="select" class="ajax" data-attr-scan="'+ id +'">';
                    html += '<script>initCombo("'+ id +'", '+ column.width +', "'+ val +'", '+ index +')<\/script>';
                }
                return html;
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
                    html += val;
                }
                else{
                    var ajaxClz = ['required'];
                    if( column.name=='carId' || column.name=='dutyName' || column.name=='dutyNum'|| column.name=='dutyPhone'|| column.name=='start'|| column.name=='end'|| column.name=='main') ajaxClz.push('ajax');
                    html = '<input data-old-val="'+ val +'" type="text" id="'+ id +'" err-msg="'+ errMsg +'" class="'+ ajaxClz.join(' ') +'" data-attr-scan="'+ id +'"/>';
                    html += '<script>initText("'+ id +'", '+ column.width +', "'+ val +'")<\/script>';
                }
                return html;
            }
            win.initText = function(id, width, value){
                $("#"+ id).ligerTextBox({width: width - 20, value: value});
            }

            win.initSl = function (id, columnName, width, value) {
                var data;
                $("#"+ id ).ligerComboBox({width: width - 20, valueField: "code", textField: "value", data: data}).selectValue(value);
            }

            //初始化表格
            var rendGrid = function(){
                var columns = [
                    {display: '排序号', name: 'excelSeq', hide: true, render: function (row, index) {
                        return '<input type="hidden" value="'+ row.excelSeq +'" data-attr-scan="excelSeq_'+ index +'">'
                    }},
                    {display: '姓名', name: 'dutyName', width: '90', align: 'left', render: textRender},
                    {display: '性别', name: 'gender', width: '70', align: 'left', render: textRender},
                    {display: '工号', name: 'dutyNum', width: '110', align: 'left', render: textRender},
                    {display: '角色', name: 'dutyRole', width: '80', align: 'left', render: textRender},
                    {display: '手机号', name: 'dutyPhone', width: '100', align: 'left', render: textRender},
                    {display: '车牌号', name: 'carId', width: '120', align: 'left', render: textRender},
                    {display: '开始时间', name: 'start', width: '150', align: 'left', render: textRender},
                    {display: '结束时间', name: 'end', width: '150', align: 'left', render: textRender},
                    {display: '创建者',hide:true, name: 'creator', width: '130', align: 'left', render: textRender},
                    {display: '主班/副班', name: 'main', width: '80', align: 'left', render: textRender}];

                grid = initGrid($('#impGrid'), urls.list, {}, columns, {height: 520, pageSize:10, pageSizeOptions:[10, 15], delayLoad: true, checkbox: false, onAfterShowData: onAfterShowData});
                searchFun();
            };

            var searchFun = function () {
                find(1);
            }

            //初始化过滤
            var filters = function(){
                var vo = [];
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