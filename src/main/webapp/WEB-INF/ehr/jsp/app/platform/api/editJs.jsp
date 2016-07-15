<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script type="text/javascript">

    (function ($, win) {
        var urls = {
            update: "${contextRoot}/app/api/update",
            existence: "${contextRoot}/app/api/existence",
            apiParameterLs: "${contextRoot}/app/api/parameter/list",
            apiResponseLs: "${contextRoot}/app/api/response/list"
        }
        var model = ${model};
        var mode = 'modify';
        var paramTypes = ${paramTypes}.detailModelList;
        var paramTypeMap = ls2map(paramTypes, 'code', 'value');
        var dataTypes = ${dataTypes}.detailModelList;
        var dataTypeMap = ls2map(dataTypes, 'code', 'value');
        var requiredTypes = ${requiredTypes}.detailModelList;
        var requiredTypeMap = ls2map(requiredTypes, 'code', 'value');

        function back(){
            $('#contentPage').empty();
            $('#contentPage').load('${contextRoot}/app/api/initial', {dataModel: 1});
        }
        var initSub = function () {
            $('#btn_back').click(back);
        }();
        var reInit= function () {
            parmGrid.searchFun();
            resGrid.searchFun();
            fillForm(model, $('#infoContent'));
        }
        var init = function () {
            initForm();
            parmGrid.init();
            resGrid.init();
            initBtn();
            fillForm(model, $('#infoContent'));
        };

        //数据验证
        function onBeforeSubmitEdit(e){
            var m= this, editorReg = true;
            var reg = e.column.editor.reg;
            var v = e.value;
            if(reg){
                var msg = '';
                if(reg=='required'){
                    if(((v == null) || (v.length == 0) || /^[\s|\u3000]+$/.test(v))){
                        msg = "该项必填！";
                        editorReg = false;
                    }
                }else if(!reg.test(v)){
                    msg= e.column.editor.regText;
                    editorReg = false;
                }

                if(!editorReg){
                    $.Notice.error(msg, function () {
                        setTimeout(function () {
                            $(m.grid).find('tr[id$="'+ e.record.__id +'"]').find('td[id$="'+ e.column.__id +'"]').click();
                        }, 100);
                    });
                }
            }
            return editorReg ;
        }
        //获取列表数据
        function getChanges(g) {
            var delLs = [], addLs = [], updateLs= [], status;
            $.each(g.getChanges(), function(i, v){
                status = v.__status;
                delete v.__status;
                if(status=='delete' && v.id!=0)
                    delLs.push(v);
                else if(status=='add')
                    addLs.push(v);
                else if(status=='update'){
                    if(v.id==0)
                        addLs.push(v);
                    else
                        updateLs.push(v);
                }
            });
            return {delLs: delLs, addLs: addLs, updateLs: updateLs};
        }

        var initForm = function () {
            var vo = [
                {type: 'text', id: 'ipt_api_name'},
                {type: 'text', id: 'ipt_api_description'},
                {type: 'select', id: 'ipt_api_type', dictId: 46, opts: {disabled: true}},
                {type: 'select', id: 'ipt_api_openLevel', dictId: 40},
                {type: 'select', id: 'ipt_api_auditLevel', dictId: 41},
                {type: 'select', id: 'ipt_api_activityType', dictId: 43},
                {type: 'text', id: 'ipt_api_version'},
                {type: 'select', id: 'ipt_api_protocol', dictId: 44},
                {type: 'select', id: 'ipt_api_method', dictId: 45}
            ];
            initFormFields(vo);
        };

        var initBtn = function () {
            var $form =  $("#infoContent");
            var validator = initValidate($form, function (elm) {
                var field = $(elm).attr('id');
                var val = $('#' + field).val();
//                if(field=='ipt_af_name' && val!=model.name)
//                    return uniqValid(urls.existence, "name="+val+" g1;type=1;appId="+model.appId, "该类型下名称已存在！");
            });

            $('#btn_save').click(function () {
                if(!validator.validate()){
                    $.Notice.warn("请确认数据填写正确！");
                    return;
                }

                var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
                $form.attrScan();
                var saveModel = $form.Fields.getValues();
                var extParms = {apiParms: JSON.stringify(parmGrid.grid.getChanges()),
                    apiResponse: JSON.stringify( resGrid.grid.getChanges())}
                var dataModel = $.DataModel.init();
                dataModel.createRemote(urls.update, {
                    data: {id: saveModel.id, model: JSON.stringify(saveModel), extParms: JSON.stringify(extParms)},
                    success: function (data) {
                        waittingDialog.close();
                        if (data.successFlg) {
                            $.Notice.confirm("保存成功, 是否继续新增？", function (y) {
                                if(y){
                                    model = {id: 0, appId: model.appId, type: "1", name: "", description:"",auditLevel:"", method: "",
                                        activityType:"",openLevel:"",parameterDemo:"",responseDemo:"", version: "", protocol: "", parentId: model.parentId};
                                    mode = 'new';
                                    reInit();
                                }else
                                    back();
                            });
                        } else {
                            if (data.errorMsg)
                                $.Notice.error(data.errorMsg);
                            else
                                $.Notice.error('出错了！');
                        }
                    },
                    error: function () {
                        waittingDialog.close();
                        $.Notice.error("请求出错！");
                    }
                });
            });
        };

        //参数列表
        var parmGrid = {
            grid: undefined,
            init: function () {
                this.barTools();
                this.rendGrid();
            },
            barTools: function(){
                var m = this;
                var btn = [{type: 'edit', clkFun: function () {
                    m.grid.append({id:0, name: 'param', type: '0', dataType: 'DATE', required: '0', defaultValue: '', description: '', memo: ''});
                    m.grid.setHeight(m.grid.options.height+=41);
                }}];
                initBarBtn($('#parmsForm'), btn);
            },
            opratorRender: function (row){
                var vo = [
                    {type: 'del', clkFun: "$.publish('app:api:param:del',["+ row['id'] +", '"+ row['__id'] +"'])"}];
                return initGridOperator(vo);
            },
            rendGrid: function(){

                var columns = [
                    {display: '参数名', name: 'name', width: '20%', align: 'left',
                        editor: {type:"text", reg: 'required'}},
                    {display: '参数类型', name: 'type', width: '10%', align: 'left', render: function (record) {
                        return paramTypeMap[record.type];
                    }, editor: {type:"select", data: paramTypes, valueField: 'code', textField: 'value',  reg: 'required'}},
                    {display: '数据类型', name: 'dataType', width: '10%', align: 'left',render: function (record) {
                        return dataTypeMap[record.dataType];
                    }, editor: {type:"select", data: dataTypes, valueField: 'code', textField: 'value',  reg: 'required'}},
                    {display: '是否必填', name: 'required', width: '10%', align: 'left',render: function (record) {
                        return requiredTypeMap[record.required];
                    }, editor: {type:"select", data: requiredTypes, valueField: 'code', textField: 'value',  reg: 'required'}},
                    {display: '默认值', name: 'defaultValue', width: '10%', align: 'left', editor: {type:"text"}},
                    {display: '说明', name: 'description', width: '20%', align: 'left', editor: {type:"text"}},
                    {display: '备注', name: 'memo', width: '10%', align: 'left', editor: {type:"text"}},
                    {display: '操作', name: 'operator', width: '10%', render: this.opratorRender}];

                this.grid = initGridDef($('#parmsGrid'), urls.apiParameterLs, {}, columns,
                        {delayLoad: true, checkbox: false, usePager: false, height:70, rownumbers: false, enabledEdit: true, editorTopDiff: 0,
                            onBeforeSubmitEdit: onBeforeSubmitEdit});
                this.searchFun();
                $('.l-scroll', $('#parmsGrid')).css('overflow', 'hidden');
            },
            searchFun: function () {
                var params = {filters: "appApiId="+ model.id , page: 1, rows: 999}
                reloadGrid(parmGrid.grid, 1, params);
            },
            del: function (e, id, rowId) {
                var g= parmGrid.grid;
                g.deleteRow(rowId);
                g.setHeight(g.options.height-= 41);
            }
        }

        //返回值列表
        var resGrid = {
            init: function () {
                var m = this;
                m.barTools();
                m.rendGrid();
            },
            barTools: function(){
                var m = this;
                var btn = [{type: 'edit', clkFun: function () {
                    m.grid.append({id: 0, name:"name", dataType: "DATE", description: "", memo: ""});
                    m.grid.setHeight(m.grid.options.height+=41);
                }}];
                initBarBtn($('#responseForm'), btn);
            },
            opratorRender: function(row){
                var vo = [
                    {type: 'del', clkFun: "$.publish('app:api:res:del',['"+ row['id'] +"', '"+ row['__id'] +"'])"}];
                return initGridOperator(vo);
            },
            rendGrid: function(){
                var columns = [
                    {display: '名称', name: 'name', width: '30%', align: 'left',
                        editor: {type:"text", reg: 'required'}},
                    {display: '数据类型', name: 'dataType', width: '10%', align: 'left',
                        editor: {type:"select", data: dataTypes,  valueField: 'code', textField: 'value',  reg: 'required'}},
                    {display: '说明', name: 'description', width: '30%', align: 'left',
                        editor: {type:"text"}},
                    {display: '备注', name: 'memo', width: '20%', align: 'left',
                        editor: {type:"text"}},
                    {display: '操作', name: 'operator', width: '10%', render: this.opratorRender}];

                this.grid = initGridDef($('#responseGrid'), urls.apiResponseLs, {}, columns, {delayLoad: true, checkbox: false, usePager: false, height: 70,
                    rownumbers: false, enabledEdit: true, editorTopDiff: 0, onBeforeSubmitEdit: onBeforeSubmitEdit});
                this.searchFun();
                $('.l-scroll', $('#responseGrid')).css('overflow', 'hidden');
            },
            searchFun:  function () {
                var params = {filters: "appApiId="+ model.id , page: 1, rows: 999}
                reloadGrid(resGrid.grid, 1, params);
            },
            del: function (id, rowId) {
                var g= resGrid.grid;
                g.deleteRow(rowId);
                g.setHeight(g.options.height-= 41);
            }
        }

        var publicFun = function (){
            $.subscribe('app:api:param:del', parmGrid.del);
            $.subscribe('app:api:res:del', resGrid.del);
        }();

        var contentH = $('.l-layout-center').height();
        $('#infoContent').height(contentH - 60);
        init();

    })(jQuery, window);
</script>