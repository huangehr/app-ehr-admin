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
                list: '${contextRoot}/doctorImport/importLs',
                userExistence: "${contextRoot}/doctorImport/userIsExistence",
                doctorExistence: "${contextRoot}/doctorImport/doctorIsExistence",
                orgExistence: "${contextRoot}/doctorImport/orgCodeIsExistence",
                <%--orgDeptExistence: "${contextRoot}/doctorImport/deptIsExistence",--%>

                batchSave: "${contextRoot}/doctorImport/batchSave",
                downLoad: "${contextRoot}/doctorImport/downLoadErrInfo",
                <%--dictCombo: "${contextRoot}/doctorImport/searchCombo"--%>
            }
            var files = ${files}, ynData= [{code: '1', value: '男'},{code: '0', value: '女'}];
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
                                    if (data.errorMsg) {
                                    $.Notice.error(data.errorMsg);
                                    searchFun();
                                    }else{
                                        $.Notice.error('出错了！');
                                    }
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
                    var o= field.split('_');
                    var code='orgCode'+'_'+o[1];
                    var fullName='orgFullName'+'_'+o[1];
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
                    if(field.indexOf('idCardNo')!=-1){
                        return uniqValid(urls.doctorExistence, "idCardNo="+val, "该身份证号在医生表中已存在！");
                    }
                    if(field.indexOf('idCardNo')!=-1){
                        return uniqValid(urls.userExistence, "idCardNo="+val, "该身份证号在账户表中已存在！");
                    }
                    if(field.indexOf('orgCode')!=-1){
                        debugger;
                        var result=uniqValid(urls.orgExistence, "orgCode="+val+";fullName="+ $('#' + fullName).val(), "该机构代码或机构名称不正确！");
                        if(result.result){
                            $.jValidation.Validation.reset("#orgFullName_"+o[1]);
                        } else {
                            $.jValidation.Validation.showErrorMsg('ajax', "#orgFullName_"+o[1], "该机构代码或机构名称不正确！");
                        }
                        return result;
                    }
                    if(field.indexOf('orgFullName')!=-1){
                        debugger;
                        var result=uniqValid(urls.orgExistence, "orgCode="+$('#' + code).val()+";fullName="+val, "该机构代码或机构名称不正确！");
                        if(result.result){
                            $.jValidation.Validation.reset("#orgCode_"+o[1]);
                        } else {
                            $.jValidation.Validation.showErrorMsg('ajax', "#orgCode_"+o[1], "该机构代码或机构名称不正确！");
                        }
                        return result;

                    }
//                    if(field.indexOf('orgDeptName')!=-1){
//                        return uniqValid(urls.orgDeptExistence, "orgCode="+$('#' + code).val()+ ";orgFullName="+$('#' + fullName).val()+";deptName="+val, "该机构部门不存在！");
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
                    if( column.name=='idCardNo' || column.name=='email' || column.name=='phone'|| column.name=='orgCode'|| column.name=='orgFullName'|| column.name=='orgDeptName') ajaxClz.push('ajax');
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
                    if(val==1){
                        val="男";
                    }else{
                        val="女";
                    }
                    html += val;
                }else{
                    html = '<input type="text" id="'+ id +'" class="required" data-attr-scan="'+ id +'" data-type="select"/>';
                    html += '<script>initSl("'+ id +'", "'+ column.name +'", '+ column.width +', "'+ val +'")<\/script>';
                }
                return html;
            }
            win.initSl = function (id, columnName, width, value) {
                var data;
                if(columnName== 'sex')
//                    data = domainData;
//                else if(columnName== 'columnType')
//                    data = columnTypeData;
//                else
                    data = ynData;
                $("#"+ id ).ligerComboBox({width: width - 20, valueField: "code", textField: "value", data: data}).selectValue(value);
            }

            //初始化表格
            var rendGrid = function(){
                var columns = [
                    {display: '排序号', name: 'excelSeq', hide: true, render: function (row, index) {
                        return '<input type="hidden" value="'+ row.excelSeq +'" data-attr-scan="excelSeq_'+ index +'">'
                    }},
                    {display: '机构id',  hide: true,name: 'orgId', width: '110', align: 'left', render: textRender},
                    {display: '姓名', name: 'name', width: '93', align: 'left', render: textRender},
                    {display: '身份证号', name: 'idCardNo', width: '151', align: 'left', render: textRender},
                    {display: '性别',hide: true, name: 'sex', width: '40', align: 'left', render: selRender},
                    {display: '机构代码', name: 'orgCode', width: '110', align: 'left', render: textRender},

                    {display: '机构名称', name: 'orgFullName', width: '110', align: 'left', render: textRender},
                    {display: '科室名称', name: 'dept_name', width: '100', align: 'left', render: textRender},
                    {display: '身份证件种类', hide: true,name: 'sfzjzl', width: '148', align: 'left', render: textRender},
                    {display: '出生日期', name: 'csrq', width: '140', align: 'left', render: textRender},
                    {display: '手机号码', name: 'phone', width: '125', align: 'left', render: textRender},

                    {display: '民族代码',hide: true, name: 'mzdm', width: '140', align: 'left', render: textRender},
                    {display: '参加工作日期',  hide: true,name: 'cjgzrq', width: '95', align: 'left', render: textRender},

                    {display: '办公室电话号码',  hide: true,name: 'officeTel', width: '95', align: 'left', render: textRender},
                    {display: '所在科室代码',  hide: true,name: 'szksdm', width: '95', align: 'left', render: textRender},
                    {display: '从事专业类别代码',  hide: true,name: 'role_type', width: '95', align: 'left', render: textRender},
                    {display: '医师/卫生监督员执业证书编码',  hide: true,name: 'yszyzsbm', width: '95', align: 'left', render: textRender},
                    {display: '医师执业类别代码', hide: true, name: 'job_type', width: '95', align: 'left', render: textRender},


                    {display: '医师执业范围代码',  hide: true,name: 'job_scope', width: '95', align: 'left', render: textRender},
                    {display: '是否多地点执业医师',  hide: true,name: 'sfdddzyys', width: '95', align: 'left', render: textRender},
                    {display: '第2执业单位的机构类别',  hide: true,name: 'dezydwjglb', width: '95', align: 'left', render: textRender},
                    {display: '第3执业单位的机构类别',  hide: true,name: 'dszydwjglb', width: '95', align: 'left', render: textRender},
                    {display: '是否获得国家住院医师规范化培训合格证书',  hide: true,name: 'sfhdgjzs', width: '95', align: 'left', render: textRender},

                    {display: '住院医师规范化培训合格证书编码',  hide: true,name: 'zyyszsbm', width: '95', align: 'left', render: textRender},
                    {display: '行政/业务管理职务代码',  hide: true,name: 'xzzc', width: '95', align: 'left', render: textRender},
                    {display: '专业技术资格(评)代码',  hide: true,name: 'lczc', width: '95', align: 'left', render: textRender},
                    {display: '专业技术职务(聘)代码',  hide: true,name: 'zyjszwdm', width: '95', align: 'left', render: textRender},
                    {display: '学历代码',  hide: true,name: 'xldm', width: '95', align: 'left', render: textRender},

                    {display: '学位代码',  hide: true,name: 'xwdm', width: '95', align: 'left', render: textRender},
                    {display: '所学专业代码',  hide: true,name: 'szydm', width: '95', align: 'left', render: textRender},
                    {display: '专业特长1',  hide: true,name: 'zktc1', width: '95', align: 'left', render: textRender},
                    {display: '专业特长2',  hide: true,name: 'zktc2', width: '95', align: 'left', render: textRender},
                    {display: '专业特长3',  hide: true,name: 'zktc3', width: '95', align: 'left', render: textRender},

                    {display: '年内人员流动情况',  hide: true,name: 'nnryldqk', width: '95', align: 'left', render: textRender},
                    {display: '调入/调出时间',  hide: true,name: 'drdcsj', width: '95', align: 'left', render: textRender},
                    {display: '编制情况',  hide: true,name: 'bzqk', width: '95', align: 'left', render: textRender},
                    {display: '是否注册为全科医学专业',  hide: true,name: 'sfzcqkyx', width: '95', align: 'left', render: textRender},
                    {display: '全科医生取得培训合格证书情况',  hide: true,name: 'qdhgzs', width: '95', align: 'left', render: textRender},

                    {display: '是否由乡镇卫生院或社区卫生服务机构派驻村卫生室工作',  hide: true,name: 'xzsqpzgz', width: '95', align: 'left', render: textRender},
                    {display: '是否从事统计信息化业务工作',  hide: true,name: 'sfcstjgz', width: '95', align: 'left', render: textRender},
                    {display: '统计信息化业务工作',  hide: true,name: 'tjxxhgz', width: '95', align: 'left', render: textRender}];

                grid = initGrid($('#impGrid'), urls.list, {}, columns, {height: 520, pageSize:10, pageSizeOptions:[10, 15], delayLoad: true, checkbox: false, onAfterShowData: onAfterShowData});
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