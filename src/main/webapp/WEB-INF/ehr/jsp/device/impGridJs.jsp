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
                list: '${contextRoot}/device/importLs',
                isOrgExistence: "${contextRoot}/device/isOrgExistence",
                batchSave: "${contextRoot}/device/batchSave",
                downLoad: "${contextRoot}/device/downLoadErrInfo",
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
                        var waitting = parent._LIGERDIALOG.waitting("正在保存中.....");
                        var formData = $form.Fields.getValues();
                        var model = [], f, m;

                        for(var k in formData){
                            debugger
                            f = k.split('_');
                            m = model[f[1]] || {};
                            m[f[0]] = formData[k];
                            model[f[1]] = m;
                        }

                        var dataModel = $.DataModel.init();
                        dataModel.createRemote(urls.batchSave, {
                            data: {device: JSON.stringify(model), eFile: files.eFile[1], datePath: files.eFile[0]},
                            success: function (data) {
                                waitting.close();
                                if (data.successFlg) {
                                    parent._LIGERDIALOG.success("保存成功!");
                                    searchFun();
                                } else {
                                    if (data.errorMsg)
                                        parent._LIGERDIALOG.error(data.errorMsg);
                                    else
                                        parent._LIGERDIALOG.error('保存失败！');
                                }
                            },
                            error: function () {
                                waitting.close();
                            }
                        });
                    }else {
                        parent._LIGERDIALOG.warn("还有错误数据未修改正确！");
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
                    debugger

                    var code='orgCode'+'_'+o[1];
                    var orgName='orgName'+'_'+o[1];
                    if(oldVal==val && errMsg && errMsg!='undefined' && errMsg!=''){
                        var result = new $.jValidation.ajax.Result();
                        result.setResult(false);
                        result.setErrorMsg(errMsg);
                        return result;
                    }

                    if(field.indexOf('orgCode')!=-1){
                        var result=uniqValid(urls.isOrgExistence+"?orgCode="+val+"&orgName="+ $('#' + orgName).val(), undefined,"该机构代码或机构名称不正确！");
                        if(result.result){
                            $.jValidation.Validation.reset("#orgName"+o[1]);
                        } else {
                            $.jValidation.Validation.showErrorMsg('ajax', "#orgName"+o[1], "该机构代码或机构名称不正确！");
                        }
                        return result;
                    }
                    if(field.indexOf('orgName')!=-1){
                        debugger;
                        var result=uniqValid(urls.isOrgExistence+"?orgCode="+$('#' + code).val()+"&orgName="+val, "该机构代码或机构名称不正确！");
                        if(result.result){
                            $.jValidation.Validation.reset("#orgCode_"+o[1]);
                        } else {
                            $.jValidation.Validation.showErrorMsg('ajax', "#orgCode_"+o[1], "该机构代码或机构名称不正确！");
                        }
                        return result;

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
//                    html += '<input type="hidden" id="'+ dictId +'" data-attr-scan="'+ dictId +'" value="'+ row.dictId +'">';
                    html += val;
                }  else{
                    var html = '<input type="text" data-old-val="'+ val +'" err-msg="'+ errMsg +'" id="'+ id +'" data-type="select" class="ajax" data-attr-scan="'+ id +'">';
//                    html += '<input type="hidden" id="'+ dictId +'" data-attr-scan="'+ dictId +'">';
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
                    if( column.name=='orgCode' || column.name=='orgName') ajaxClz.push('ajax');
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
                    {display: '设备名称', name: 'deviceName', width: '120', align: 'left', render: textRender},
                    {display: '机构代码', name: 'orgCode', width: '80', align: 'left', render: textRender},
                    {display: '机构名称', name: 'orgName', width: '120', align: 'left', render: textRender},
                    {display: '设备代号', name: 'deviceType', width: '80', align: 'left', render: textRender},
                    {display: '采购数量', name: 'purchaseNum', width: '80', align: 'left', render: textRender},
                    {display: '产地', name: 'originPlace', width: '80', align: 'left', render: textRender},
                    {display: '厂家', name: 'manufacturerName', width: '120', align: 'left', render: textRender},
                    {display: '设备型号', name: 'deviceModel', width: '80', align: 'left', render: textRender},
                    {display: '采购时间', name: 'purchaseTime', width: '80', align: 'left', render: textRender},
                    {display: '新旧情况', name: 'isNew', width: '80', align: 'left', render: textRender},
                    {display: '设备价格', name: 'devicePrice', width: '80', align: 'left', render: textRender},
                    {display: '使用年限', name: 'yearLimit', width: '80', align: 'left', render: textRender},
                    {display: '状态', name: 'status', width: '80', align: 'left', render: textRender},
                    {display: '是否配置GPS', name: 'isGps', width: '120', align: 'left', render: textRender},
                    {display: '创建者',hide:true, name: 'creator', width: '80', align: 'left', render: textRender}];

                grid = initGrid($('#impGrid'), urls.list, {}, columns, {height: 520,width:1360 ,pageSize:10, pageSizeOptions:[10, 15], delayLoad: true, checkbox: false, onAfterShowData: onAfterShowData});
                grid.adjustToWidth();
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