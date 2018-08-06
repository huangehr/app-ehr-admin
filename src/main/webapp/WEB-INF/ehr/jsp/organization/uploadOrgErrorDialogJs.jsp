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
                            data: {orgs: JSON.stringify(model), eFile: files.eFile[1], datePath: files.eFile[0]},
                            success: function (data) {
                                waitting.close();
                                if (data.successFlg) {
                                    parent._LIGERDIALOG.success("保存成功!");
                                    parent._ErrorDio.close();
                                    searchFun();
                                } else {
                                    if (data.errorMsg)
                                        parent._LIGERDIALOG.error(data.errorMsg);
                                    else
                                        parent._LIGERDIALOG.error('出错了！');
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
                    {display: '机构ID',hide: true, name: 'id', width: '150', align: 'left', render: textRender},
                    {display: '机构名称', name: 'fullName', width: '160', align: 'left', render: textRender},
                    {display: '是否基层单位',hide: true, name: 'basicUnitFlag', width: '82', align: 'left', render: textRender},
                    {display: '上级机构ID',hide: true, name: 'parentHosId', width: '82', align: 'left', render: textRender},
                    {display: '是否启用', hide: true, name: 'activityFlag', width: '110', align: 'left', render: textRender},

                    {display: '机构变动情况',hide: true, name: 'orgChanges', width: '82', align: 'left', render: textRender},
                    {display: '组织机构代码',  name: 'orgCode', width: '120', align: 'left', render: textRender},
                    {display: '机构分类管理代码', hide: true,  name: 'hosManageType', width: '100', align: 'left', render: textRender},
                    {display: '经济类型代码',hide: true, name: 'hosEconomic', width: '95', align: 'left', render: textRender},
                    {display: '卫生机构类别代码',hide: true, name: 'hosTypeId', width: '125', align: 'left', render: textRender},

                    {display: '卫生机构类别代码名称', name: 'hosTypeName', width: '150', align: 'left', render: textRender},
                    {display: '行政区划代码', name: 'administrativeDivision', width: '80', align: 'left', render: textRender},
                    {display: '街道/乡镇代码',  hide: true,name: 'streetId', width: '95', align: 'left', render: textRender},
                    {display: '医院等级（级）',  hide: true,name: 'levelId', width: '95', align: 'left', render: textRender},
                    {display: '医院等级（等）',  hide: true,name: 'hosHierarchy', width: '95', align: 'left', render: textRender},

                    {display: '设置/主办单位(村卫生室不填)',  hide: true,name: 'hostUnit', width: '95', align: 'left', render: textRender},
                    {display: '政府办机构隶属关系',  hide: true,name: 'ascriptionType', width: '95', align: 'left', render: textRender},
                    {display: '是否填报出院病人表',  hide: true,name: 'dischargePatientFlag', width: '95', align: 'left', render: textRender},
                    {display: '是否代报诊所',hide: true,name: 'reportingClinicFlag', width: '80', align: 'left', render: textRender},
                    {display: '是否代报村卫生室',  hide: true,name: 'reportingVillageClinicFlag', width: '95', align: 'left', render: textRender},

                    {display: '诊所、村卫生室所属代报机构', hide: true, name: 'reportingOrg', width: '95', align: 'left', render: textRender},
                    {display: '单位开业/成立时间',  hide: true,name: 'foundingTime', width: '95', align: 'left', render: textRender},
                    {display: '注册资金(万元)',  hide: true,name: 'registeredCapital', width: '95', align: 'left', render: textRender},
                    {display: '法定代表人(负责人)',  hide: true,name: 'legalPerson', width: '95', align: 'left', render: textRender},
                    {display: '是否分支机构',  hide: true,name: 'branchOrgFlag', width: '95', align: 'left', render: textRender},

                    {display: '地址',  name: 'location', width: '190', align: 'left', render: textRender},
                    {display: '邮政编码',  hide: true,name: 'postalcode', width: '95', align: 'left', render: textRender},
                    {display: '电话号码', name: 'tel', width: '120', align: 'left', render: textRender},
                    {display: '电子邮箱',  name: 'email', width: '120', align: 'left', render: textRender},
                    {display: '单位网站域名',  hide: true,name: 'domainName', width: '95', align: 'left', render: textRender},

                    {display: '批准文号/注册号', hide: true, name: 'registrationNumber', width: '95', align: 'left', render: textRender},
                    {display: '登记批准机构',  hide: true,name: 'registrationRatificationAgency', width: '95', align: 'left', render: textRender},
                    {display: '办证日期',  hide: true,name: 'certificateDate', width: '95', align: 'left', render: textRender},
                    {display: '经办人',  hide: true,name: 'operator', width: '95', align: 'left', render: textRender},
                    {display: '录入人',  hide: true,name: 'entryStaff', width: '95', align: 'left', render: textRender},

                    {display: '新增机构创建时间',  hide: true,name: 'createTime', width: '95', align: 'left', render: textRender},
                    {display: '作废时间',  hide: true,name: 'cancelTime', width: '95', align: 'left', render: textRender},
                    {display: '最后修改时间',  hide: true,name: 'updateTime', width: '95', align: 'left', render: textRender},
                    {display: '有效期起',  hide: true,name: 'termValidityStart', width: '95', align: 'left', render: textRender},
                    {display: '有效期止',  hide: true,name: 'termValidityEnd', width: '95', align: 'left', render: textRender},

                    {display: '健康之路同步机构ID',  hide: true,name: 'jkzlOrgId', width: '95', align: 'left', render: textRender}
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