<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script>

    (function ($, win) {
        $(function () {
            var grid;
            var urls = {
                list: '${contextRoot}/orgImport/importLs',
                orgIsExistence: "${contextRoot}/orgImport/orgIsExistence",
                batchSave: "${contextRoot}/orgImport/batchSave",
                downLoad: "${contextRoot}/orgImport/downLoadErrInfo",
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
                    var o= field.split('_');
                    var code='orgCode'+'_'+o[1];
                    var fullName='orgFullName'+'_'+o[1];
                    if(oldVal==val && errMsg && errMsg!='undefined' && errMsg!=''){
                        var result = new $.jValidation.ajax.Result();
                        result.setResult(false);
                        result.setErrorMsg(errMsg);
                        return result;
                    }

                    if(field.indexOf('orgCode')!=-1){
                        return uniqValid(urls.orgIsExistence,val, "该机构代码已存在！");
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
                    if( column.name=='orgCode'|| column.name=='hosTypeId' || column.name=='ascriptionType'|| column.name=='orgType' || column.name=='settledWay'|| column.name=='zxy' ) ajaxClz.push('ajax');
                    html = '<input data-old-val="'+ val +'" type="text" id="'+ id +'" err-msg="'+ errMsg +'" class="'+ ajaxClz.join(' ') +'" data-attr-scan="'+ id +'"/>';
                    html += '<script>initText("'+ id +'", '+ column.width +', "'+ val +'")<\/script>';
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
                    {display: '机构代码', name: 'orgCode', width: '150', align: 'left', render: textRender},
                    {display: '机构全名', name: 'fullName', width: '200', align: 'left', render: textRender},
                    {display: '医院类型', name: 'hosTypeId', width: '82', align: 'left', render: textRender},
                    {display: '医院归属', name: 'ascriptionType', width: '82', align: 'left', render: textRender},
                    {display: '机构简称', hide: true, name: 'shortName', width: '110', align: 'left', render: textRender},
                    {display: '机构类型', name: 'orgType', width: '82', align: 'left', render: textRender},
                    {display: '医院等级',hide: true,  name: 'levelId', width: '100', align: 'left', render: textRender},

                    {display: '医院法人', hide: true,  name: 'legalPerson', width: '100', align: 'left', render: textRender},
                    {display: '联系人', name: 'admin', width: '95', align: 'left', render: textRender},
                    {display: '联系方式', name: 'phone', width: '125', align: 'left', render: textRender},
                    {display: '中西医标识', name: 'zxy', width: '80', align: 'left', render: textRender},

                    {display: '床位',hide: true, name: 'berth', width: '70', align: 'left', render: textRender},
                    {display: '机构地址--省',  hide: true,name: 'provinceName', width: '95', align: 'left', render: textRender},
                    {display: '机构地址--市',  hide: true,name: 'cityName', width: '95', align: 'left', render: textRender},
                    {display: '机构地址--县',  hide: true,name: 'district', width: '95', align: 'left', render: textRender},
                    {display: '机构地址--镇',  hide: true,name: 'town', width: '95', align: 'left', render: textRender},
                    {display: '机构地址--街道',  hide: true,name: 'street', width: '95', align: 'left', render: textRender},
                    {display: '交通路线',  hide: true,name: 'traffic', width: '95', align: 'left', render: textRender},
                    {display: '入驻方式',name: 'settledWay', width: '80', align: 'left', render: textRender},
                    {display: '经度',  hide: true,name: 'ing', width: '95', align: 'left', render: textRender},
                    {display: '纬度', hide: true, name: 'lat', width: '95', align: 'left', render: textRender},
                    {display: '标签',  hide: true,name: 'tags', width: '95', align: 'left', render: textRender},
                    {display: '医院简介',  hide: true,name: 'introduction', width: '95', align: 'left', render: textRender}
//                    {display: '资质信息',  hide: true,name: 'qualification', width: '95', align: 'left', render: textRender},
                ];
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