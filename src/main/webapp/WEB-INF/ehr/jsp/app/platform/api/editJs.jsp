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
            appapiLs: "${contextRoot}/app/api/list",//获取当前的api-传参数id
            apiParameterLs: "${contextRoot}/app/api/parameter/list",//获取当前api的请求参数-传参数appApiId
            apiResponseLs: "${contextRoot}/app/api/response/list"//获取当前api的返回值-传参数appApiId
        }
        var model = ${model};
        var mode = '${mode}';
        debugger
        var paramTypes = ${paramTypes}.detailModelList;
        var paramTypeMap = ls2map(paramTypes, 'code', 'value');
        var dataTypes = ${dataTypes}.detailModelList;
        var dataTypeMap = ls2map(dataTypes, 'code', 'value');
        var requiredTypes = ${requiredTypes}.detailModelList;
        var requiredTypeMap = ls2map(requiredTypes, 'code', 'value');
        //添加碎片
        function appendNav() {
            $('#navLink').html('应用信息<span class=""> <i class="glyphicon glyphicon-chevron-right"></i> <span style="color: #337ab7">API管理</span></span>');
            $('.go-back').remove();
            $('#div_nav_breadcrumb_bar').show().append('<div class="btn btn-default go-back"><i class="glyphicon glyphicon-chevron-left"></i>返回上一层</div>');
            $("#contentPage").css({
                'height': 'calc(100% - 40px)'
            }).empty().load('${contextRoot}/app/api/initial',{
                'dataModel': model.appId
            });
        }

        $(document).on('click', '.go-backa', function (e) {
            debugger
            $('.go-backa').remove();
            appendNav()
        });
        function back(){
            $('.go-backa').remove();
            appendNav()
//            window.location.reload();
            <%--$('#contentPage').empty();--%>
            <%--$('#contentPage').load('${contextRoot}/app/api/initial', {dataModel: 1});--%>
        }
        var initSub = function () {
            $('#btn_back').click(back);
        }();
        var reInit= function () {
            timer = 0;
            parmGrid.searchFun();
            resGrid.searchFun();
            fillForm(model, $('#infoContent'));
        }
        var init = function () {
            initForm();
            parmGrid.init();
            resGrid.init();
            initBtn();
            $.ajax({
                url: urls.appapiLs,
                data: {
                    filters: 'id='+model.id,
                    page: 1,
                    rows: 15
                },
                type: 'GET',
                dataType: 'json',
                success: function (res) {
                    if (res.successFlg) {
                        model = res.detailModelList[0];
                    }
                }
            })
            fillForm(model, $('#infoContent'));
            if(mode=='view'){
                $('#infoContent').addClass('m-form-readonly');
                $('#btn_save').hide();
                $('.l-button').hide();
            }
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
                    parent._LIGERDIALOG.error(msg, function () {
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
                {type: 'text', id: 'ipt_api_http', width: $('#div_http').width()-140},
                {type: 'text', id: 'ipt_api_port', width: $('#div_port').width()-140},
                {type: 'text', id: 'ipt_api_msMethodName', width: $('#div_msMethodName').width()-140},
                {type: 'text', id: 'ipt_api_microServiceName', width: $('#div_microServiceName').width()-140},

                {type: 'text', id: 'ipt_api_name', width: $('#div_name').width()-140},
                {type: 'text', id: 'ipt_api_methodName', width: $('#div_methodName').width()-140},
                {type: 'text', id: 'ipt_api_description', width: $('#div_des').width()-150},
                {type: 'select', id: 'ipt_api_type', dictId: 46, opts: {disabled: true, width: $('#div_type').width()-140}},
                {type: 'select', id: 'ipt_api_openLevel', dictId: 40, opts:{width: $('#div_open').width()-140}},
                {type: 'select', id: 'ipt_api_auditLevel', dictId: 41, opts: {width: $('#div_audit').width()-140}},
                {type: 'select', id: 'ipt_api_activityType', dictId: 43, opts: { width: $('#div_status').width()-140}},
                {type: 'text', id: 'ipt_api_version', width: $('#div_version').width()-140},
                {type: 'select', id: 'ipt_api_protocol', dictId: 44, opts: {width: $('#div_protocol').width()-140}},
                {type: 'select', id: 'ipt_api_method', dictId: 45, opts: {width: $('#div_method').width()-140}}
            ];
            initFormFields(vo);
        };
//        var timer=0;
        var initBtn = function () {
//            timer++;
//            if(timer!=2) return;
            var $form =  $("#infoContent");
            var validator = initValidate($form, function (elm) {
                var field = $(elm).attr('id');
                var val = $('#' + field).val();
                if(field=='ipt_api_name' && val!=model.name){
                    return uniqValid4List(urls.existence, "name="+val+" g1;parentId="+ model.parentId, "该应用代码已存在！");
                }
            });

            $('#btn_save').click(function () {
                if(!validator.validate()){
                    parent._LIGERDIALOG.warn("请确认数据填写正确！");
                    return;
                }

                var waittingDialog = parent._LIGERDIALOG.waitting('正在保存中,请稍候...');
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
                            win.parent._LIGERDIALOG.success('保存成功');
                            back();
                            <%--parent._LIGERDIALOG.confirm("保存成功, 是否继续新增？", function (y) {--%>
                                <%--&lt;%&ndash;if(y){&ndash;%&gt;--%>
                                    <%--&lt;%&ndash;model = {id: 0, appId: model.appId, type: "1", name: "", description:"",auditLevel:"", method: "", methodName: "",&ndash;%&gt;--%>
                                        <%--&lt;%&ndash;activityType:"",openLevel:"",parameterDemo:"",responseDemo:"", version: "", protocol: "", parentId: model.parentId};&ndash;%&gt;--%>
                                    <%--&lt;%&ndash;mode = 'new';&ndash;%&gt;--%>
                                    <%--&lt;%&ndash;reInit();&ndash;%&gt;--%>
                                <%--&lt;%&ndash;}else&ndash;%&gt;--%>
                                    <%--&lt;%&ndash;back();&ndash;%&gt;--%>
                            <%--});--%>
                        } else {
                            if (data.errorMsg)
                                parent._LIGERDIALOG.error(data.errorMsg);
                            else
                                parent._LIGERDIALOG.error('出错了！');
                        }
                    },
                    error: function () {
                        waittingDialog.close();
                        parent._LIGERDIALOG.error("请求出错！");
                    }
                });
            });
        };

        var onAfterShowData= function (data) {
            var g= this;
            var delData = g.getDeleted();
            g.options.height = 70 + 41*(data.detailModelList.length - (delData? delData.length: 0));
            g.setHeight(g.options.height);
        }

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
                    {display: '备注', name: 'memo', width: mode=='view'?'20%':'10%', align: 'left', editor: {type:"text"}}];
                if(mode!='view'){
                    columns.push({display: '操作', name: 'operator', width: '10%', render: this.opratorRender});
                }
                this.grid = initGridDef($('#parmsGrid'), urls.apiParameterLs, {}, columns,
                        {delayLoad: true, checkbox: false, usePager: false, height:70, rownumbers: false, enabledEdit: mode!='view', editorTopDiff: 0,
                            onBeforeSubmitEdit: onBeforeSubmitEdit,
                            onSuccess: function (data) {
                                if(data.successFlg) {
                                    if(data.detailModelList.length==0) {
                                        this.options.height = 70;
                                        this.setHeight(this.options.height);
                                    }
//                                    if(mode=='modify') initBtn();
                                }
                                else parent._LIGERDIALOG.error("参数列表加载失败！");
                            },
                            onAfterShowData: onAfterShowData
                        });
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
                    {display: '备注', name: 'memo', width: mode=='view'?'30%':'20%', align: 'left',
                        editor: {type:"text"}}
                    ];
                if(mode!='view'){
                    columns.push({display: '操作', name: 'operator', width: '10%', render: this.opratorRender});
                }
                this.grid = initGridDef($('#responseGrid'), urls.apiResponseLs, {}, columns, {delayLoad: true, checkbox: false, usePager: false, height: 70,
                    rownumbers: false, enabledEdit: mode!='view', editorTopDiff: 0, onBeforeSubmitEdit: onBeforeSubmitEdit,
                    onSuccess: function (data) {
                        if(data.successFlg) {
                            if(data.detailModelList.length==0) {
                                this.options.height = 70;
                                this.setHeight(this.options.height);
                            }
//                            if(mode=='modify') initBtn();
                        }
                        else parent._LIGERDIALOG.error("返回值列表加载失败！");
                    },onAfterShowData: onAfterShowData
                });
                this.searchFun();
                $('.l-scroll', $('#responseGrid')).css('overflow', 'hidden');
            },
            searchFun:  function () {
                var params = {filters: "appApiId="+ model.id , page: 1, rows: 999}
                reloadGrid(resGrid.grid, 1, params);
            },
            del: function (e, id, rowId) {
                var g= resGrid.grid;
                g.deleteRow(rowId);
            }
        }

        var publicFun = function (){
            $.subscribe('app:api:param:del', parmGrid.del);
            $.subscribe('app:api:res:del', resGrid.del);
        }();

        var contentH = $('.l-layout-center').height();
//        $('#infoContent').height(contentH - 60);
        init();

    })(jQuery, window);
</script>