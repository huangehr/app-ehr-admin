<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>

    (function ($, win) {
        $(function () {
            var grid;
            var urls = {
                list: '${contextRoot}/doctorImport/importLs',
                userExistence: "${contextRoot}/doctorImport/userIsExistence",
                doctorExistence: "${contextRoot}/doctorImport/doctorIsExistence",
                batchSave: "${contextRoot}/doctorImport/batchSave",
                downLoad: "${contextRoot}/doctorImport/downLoadErrInfo",
                <%--dictCombo: "${contextRoot}/doctorImport/searchCombo"--%>
            }
            var files = ${files};
            var mode = 'eFile';


            //初始化工具栏
            var barTools = function(){

                function save(){
                    if(true){
                        if($form.Fields)
                            $form.removeData('propMap');
                        $form.attrScan();
                        var waitting = $.ligerDialog.waitting("正在保存中.....");
                        var formData = $form.Fields.getValues();
                        var model = [], f, m;

                        debugger;
                        for(var k in formData){
                            f = k.split('_');
                            m = model[f[1]] || {};
                            m[f[0]] = formData[k];
                            model[f[1]] = m;
                        }

                        var dataModel = $.DataModel.init();
                        dataModel.createRemote(urls.batchSave, {
                            data: {doctors: JSON.stringify(model), eFile: files.eFile[1], datePath: files.eFile[0]},
                            success: function (data) {
                                waitting.close();
                                if (data.successFlg) {
                                    $.Notice.success("保存成功!");
                                    searchFun();
                                } else {
                                    if (data.errorMsg)
                                        $.Notice.error(data.errorMsg);
                                    else
                                        $.Notice.error('出错了！');
                                }
                            },
                            error: function () {
                                waitting.close();
                            }
                        });
                    }else
                        $.Notice.warn("还有错误数据未修改正确！");
                }

                function downLoad(){
                    $('#downLoadIfm').attr('src', urls.downLoad + "?f=" + files.eFile[1] + "&datePath=" + files.eFile[0] + "&tim=" + new Date());
                }

                var btn = [
                    {type: '保存', clkFun: save, id: 'impSave'},
                    {type: '导出错误信息', clkFun: downLoad, downLoad: 'downLoad', id: 'downLoad'}];
                initBarBtn($('#sf-bar'), btn);
                $('#downLoad').addClass('u-btn-lar');
                //新增成功功能暂时不用
//                var $s_err = $('#switch_err'), $s_true = $('#switch_true'), $impSave = $('#impSave');
//                $s_err.click(function () {
//                    $s_err.addClass('btn-primary');
//                    $s_true.removeClass('btn-primary');
//                    $impSave.show();
//                    mode = 'eFile';
//                    searchFun();
//                });
//
//                $s_true.click(function () {
//                    $s_err.removeClass('btn-primary');
//                    $s_true.addClass('btn-primary');
//                    $impSave.hide();
//                    mode = 'tFile';
//                    searchFun();
//                });
            };

            function opratorRender(row){
                var vo = [];
                return initGridOperator(vo);
            }

            var $form =  $("#gridForm"), validator;
            function onAfterShowData(data){
                $('.l-grid-row-cell-inner').attr('title', '');
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

//                    if(field.indexOf('code')!=-1){
//                        return uniqValid(urls.existence, "code="+val, "该医生账户已存在！");
//                    }
                    if(field.indexOf('phone')!=-1){
                        return uniqValid(urls.doctorExistence, "phone="+val, "该联系电话在医生表中已存在！");
                    }
                    if(field.indexOf('phone')!=-1){
                        return uniqValid(urls.userExistence, "phone="+val, "该联系电话在账户表中已存在！");
                    }
                    if(field.indexOf('email')!=-1){
                        return uniqValid(urls.doctorExistence, "email="+val, "该邮箱在医生表中已存在！");
                    }
                    if(field.indexOf('email')!=-1){
                        return uniqValid(urls.userExistence, "email="+val, "该邮箱在账户表中已存在！");
                    }
//                    if(field.indexOf('officeTel')!=-1){
//                        return uniqValid(urls.existence, "code="+val, "该办公电话已存在！");
//                    }
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
//                    html += '<input type="hidden" id="'+ dictId +'" data-attr-scan="'+ dictId +'" value="'+ row.dictId +'">';
                    html += val;
                }  else{
                    var html = '<input type="text" data-old-val="'+ val +'" err-msg="'+ errMsg +'" id="'+ id +'" data-type="select" class="ajax" data-attr-scan="'+ id +'">';
//                    html += '<input type="hidden" id="'+ dictId +'" data-attr-scan="'+ dictId +'">';
                    html += '<script>initCombo("'+ id +'", '+ column.width +', "'+ val +'", '+ index +')<\/script>';
                }
                return html;
            }
//            win.initCombo = function(id, width, value, index){
//                var el = $('#' + id);
//                var g = el.customCombo(urls.dictCombo, {}, function () {
//                    var row = el.ligerGetComboBoxManager().grid.getSelectedRow();
//                    $('#dictId_' + index).val(row.id);
//                }, undefined, false, {selectBoxHeight: 280, selectBoxWidth: 240, width: width - 20, valueField: 'code'});
//                g.setText(value);
//            }


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
//                    if( column.name=='id') ajaxClz.push('validate-meta-id');
                    if( column.name=='email' || column.name=='phone') ajaxClz.push('ajax');
                    html = '<input data-old-val="'+ val +'" type="text" id="'+ id +'" err-msg="'+ errMsg +'" class="'+ ajaxClz.join(' ') +'" data-attr-scan="'+ id +'"/>';
                    html += '<script>initText("'+ id +'", '+ column.width +', "'+ val +'")<\/script>';
                }
                return html;
            }
            win.initText = function(id, width, value){
                $("#"+ id).ligerTextBox({width: width - 20, value: value});
            }

            function selRender(row, index, name, column){
                if(mode=='tFile')
                    return row[column.name];
                var errMsg = row['errorMsg'][column.name];
                var id = column.name + '_'+ index;
                var val = row[column.name];
                var html = '';
                if(!errMsg || errMsg=='' || errMsg=='undefined'){
                    html = '<input type="hidden" id="'+ id +'" data-attr-scan="'+ id +'" value="'+ val +'"/>';
                    html += val;
                }else{
                    html = '<input type="text" id="'+ id +'" class="required" data-attr-scan="'+ id +'" data-type="select"/>';
                    html += '<script>initSl("'+ id +'", "'+ column.name +'", '+ column.width +', "'+ val +'")<\/script>';
                }
                return html;
            }
//            win.initSl = function (id, columnName, width, value) {
//                var data;
//                if(columnName== 'domain')
//                    data = domainData;
//                else if(columnName== 'columnType')
//                    data = columnTypeData;
//                else
//                    data = ynData;
//                $("#"+ id ).ligerComboBox({width: width - 20, valueField: "code", textField: "value", data: data}).selectValue(value);
//            }

            //初始化表格
            var rendGrid = function(){
                var columns = [
                    {display: '排序号', name: 'excelSeq', hide: true, render: function (row, index) {
                        return '<input type="hidden" value="'+ row.excelSeq +'" data-attr-scan="excelSeq_'+ index +'">'
                    }},
//                    {display: '简介', name: 'introduction', hide: true, render: function (row, index) {
//                        return '<input type="hidden" value="'+ row.introduction +'" data-attr-scan="introduction'+ index +'">'
//                    }},
//                    {display: '教学职称', name: 'jxzc', hide: true, render: function (row, index) {
//                        return '<input type="hidden" value="'+ row.jxzc +'" data-attr-scan="jxzc'+ index +'">'
//                    }},
//                    {display: '临床职称', name: 'lczc', hide: true, render: function (row, index) {
//                        return '<input type="hidden" value="'+ row.lczc +'" data-attr-scan="lczc'+ index +'">'
//                    }},
//                    {display: '学历', name: 'xlzc', hide: true, render: function (row, index) {
//                        return '<input type="hidden" value="'+ row.xlzc +'" data-attr-scan="xlzc'+ index +'">'
//                    }},
//                    {display: '行政职称', name: 'xzzc', hide: true, render: function (row, index) {
//                        return '<input type="hidden" value="'+ row.xzzc +'" data-attr-scan="xzzc'+ index +'">'
//                    }},
                    {display: '医生账号', name: 'code', width: '141', align: 'left', render: textRender},
                    {display: '姓名', name: 'name', width: '93', align: 'left', render: textRender},
                    {display: '身份证号', name: 'idCardNo', width: '100', align: 'left', render: textRender},
                    {display: '性别', name: 'sex', width: '80', align: 'left', render: textRender},
                    {display: '医生专长', name: 'skill', width: '148', align: 'left', render: textRender},
                    {display: '邮箱', name: 'email', width: '150', align: 'left', render: textRender},
                    {display: '联系电话', name: 'phone', width: '140', align: 'left', render: textRender},
                    {display: '办公电话（固）', name: 'officeTel', width: '140', align: 'left', render: textRender},
                    {display: '医生门户首页',  hide: true,name: 'workPortal', width: '95', align: 'left', render: textRender},
                    {display: '教学职称',  hide: true,name: 'jxzc', width: '95', align: 'left', render: textRender},
                    {display: '临床职称',  hide: true,name: 'lczc', width: '95', align: 'left', render: textRender},
                    {display: '学历',  hide: true,name: 'xlzc', width: '95', align: 'left', render: textRender},
                    {display: '行政职称',  hide: true,name: 'xzzc', width: '95', align: 'left', render: textRender},
                    {display: '简介', hide: true, name: 'introduction', width: '95', align: 'left', render: textRender}];

                grid = initGrid($('#impGrid'), urls.list, {}, columns, {height: 520, pageSize:10, pageSizeOptions:[10, 15], delayLoad: true, checkbox: false, onAfterShowData: onAfterShowData});
                top.grid = grid;
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