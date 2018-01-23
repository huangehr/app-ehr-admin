<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script>
    //
    function changeQC (that,id) {
        var $that = $(that),
            val = $that.val(),
            $di = $("#div_main_relation").find(".div-item[data-code=" + ('div' + id) + "]");
        $di.attr('data-qchart', val);
        var qc = parseInt(val),
            cName = '';
        switch (qc) {
            case 1:
                cName = '柱状图';
                break;
            case 2:
                cName = '折线图';
                break;
//            case 3:
//                cName = '曲线图';
//                break;
            case 3:
                cName = '饼状图';
                break;
        }
        $di.children().eq(3).html(cName);
    }
    (function ($, win) {
        $(function () {

            /* ************************** 全局变量定义 **************************** */
            var Util = $.Util;
            var dictMaster = null;
            var entryMater = null;
            var jValidation = $.jValidation;  // 表单校验工具类
            var validator = null;
            var validator1 = null;
            var quotaId = null;
            var resourceId = '${resourceId}';
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                entryMater.init();
            }
            var domIdArr = [];

            /* *************************** 标准字典模块初始化 ***************************** */
            entryMater = {
                grid: null,
                $searchNm: $('#searchNmEntry'),
                $quotaCode:$("#inp_quotaCode").val(),
                init: function () {
                    var self = this;
                    quotaId = self.$quotaCode;
                    this.$searchNm.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            self.reloadGrid();
                        }
                    });
                    this.loadMainGrid();//加载主维度值
                    this.bindEvents();
                },
                loadMainGrid:function(){
                    var self = this;
                    this.grid = $("#div_relation_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/resource/resourceManage/getResourceQuotaInfo',
                        width:"380px",
                        height:"450px",
                        parms: {
                            resourceId: resourceId,
                            nameOrCode:""
                        },
                        columns: [
                            {display: '指标分类', name: 'quotaTypeName', width: '25%', isAllowHide: false, align: 'left'},
                            {display: '指标Code', name: 'quotaCode', width: '25%', isAllowHide: false, align: 'left'},
                            {display: '指标名称', name: 'quotaName', width: '25%', isAllowHide: false, align: 'left'},
                            {display: '图表选择', name: 'name', width: '25%', isAllowHide: false, align: 'left',                                          render:function (row) {
                                var domId = row.__id,
                                    chartTypeArr = (row.chartType).split(',');
                                var html = ['<select id="' + domId + '" style="width: 100%" onchange="changeQC(this,' + row.quotaId + ')">'];
                                for (var i = 0, len = chartTypeArr.length; i < len; i++) {
                                    var c = '';
                                    if (chartTypeArr[i] == row.quotaChart) {
                                        c = 'selected';
                                    }
                                    switch (chartTypeArr[i]) {
                                        case '1':
                                            html.push('<option value="1" ' + c + '>柱状图</option>');
                                            break;
                                        case '2':
                                            html.push('<option value="2" ' + c + '>折线图</option>');
                                            break;
                                        case '3':
                                            html.push('<option value="3" ' + c + '>饼状图</option>');
                                            break;
                                        case '4':
                                            html.push('<option value="4" ' + c + '>二维表</option>');
                                            break;
                                    }
                                }
                                html.push('</select>');
                                return html.join('');
                            }}
                        ],
                        //delayLoad:true,
                        selectRowButtonOnly: true,
                        validate: true,
                        unSetValidateAttr: false,
                        allowHideColumn: false,
                        checkbox: true,
                        rownumbers: false,
                        onSuccess:function(data){
//                            debugger
                            self.mainCheckedData(data.obj,"1");
                        },
                        //默认选中
                        isChecked:function(row){
                            if(row.flag)
                            {
                                return true;
                            }
                            else{
                                return false;
                            }
                        },
                        onToNext: function () {
                            domIdArr = [];
                        },
                        //选中修改值
                        onCheckRow:function(checked,data,rowid,rowdata)
                        {
                            //修改行checked值
//                            下拉框值
                            var selectVal = $('#'+data.__id).val();
                            if(checked){
                                if (selectVal) {
                                    data.checked ="1";
                                    data.quotaChart = selectVal;
                                    self.mainCheckedData([data],"1");
                                } else {
                                    $.Notice.error("请选择图表");
                                    this.unselect(rowid);
                                }
                            }else{
                                data.checked ="0";
                                data.quotaChart = '';
                                self.deleteMainData(data);
                            }
                        },
                        //全选事件
                        onCheckAllRow:function(){
                            var selectedData = self.grid.getSelectedRows();
//                            debugger
                            if(selectedData.length>0){
                                var selArr = [];
                                for (var k = 0; k < selectedData.length; k++) {
                                    var qc = $('#' + selectedData[k].__id).val();
                                    if (qc) {
                                        selectedData[k].quotaChart = qc;
                                        selArr.push(selectedData[k]);
                                    } else {
                                        self.grid.unselect(selectedData[k].__id);
                                    }
                                }
                                self.mainCheckedData(selArr,"1");
                            }else{

                                var currentData =  self.grid.getData();
                                for(var i=0;i<currentData.length;i++){
                                    if($("#div_main_relation").find(".div-item[data-code='" +
                                                    ('div' + currentData[i].quotaId) +"']").length>0){
                                        self.deleteMainData(currentData[i]);
                                    }
                                }
                            }

                        },
                    }));
                    // 自适应宽度
                    this.grid.adjustToWidth();
                },
//                移除行（右侧表格）
                deleteMainData:function(data){
                    $("#div_main_relation").find(".div-item[data-code=" + ('div' + data.quotaId) + "]").remove();
                },
                mainCheckedData:function(data,flag){
                    if (data) {
                        var resultHtml = "";
                        var appDom = $("#div_main_relation");
                        for(var i=0;i<data.length;i++){
                            var item = data[i];
                            var mainCode = 'div' + item.quotaId;
                            if(appDom.find(".div-item[data-code='"+mainCode+"']").length==0){
                                var cName = '',
                                    qc = parseInt(item.quotaChart);
                                switch (qc) {
                                    case 1:
                                        cName = '柱状图';
                                        break;
                                    case 2:
                                        cName = '折线图';
                                        break;
                                    case 3:
                                        cName = '饼状图';
                                        break;
                                    case 4:
                                        cName = '二维表';
                                        break;
                                }
                                resultHtml+='<div class="h-40 div-item" data-id="'+item.quotaId+'" data-code="'+mainCode+'"  data-name="' + item.quotaTypeName +'"  data-quotaCode="' + item.quotaCode + '" data-qchart="' + item.quotaChart + '" >'+
                                            '<div class="div-main-content" style="width: 22%;" title="' + item.quotaTypeName + '">'+ item.quotaTypeName +'</div>'+
                                            '<div class="div-main-content" style="width: 22%;" title="' + item.quotaCode + '">'+ item.quotaCode +'</div>'+
                                            '<div class="div-main-content" style="width: 22%;" title="' + item.quotaName + '">'+ item.quotaName +'</div>'+
                                            '<div class="div-main-content" style="width: 22%;" title="' + cName + '">'+cName+'</div>'+
                                            '<div class="div-delete-content" style="width: 12%;">'+
                                                '<a class="grid_delete" href="#" title="删除"></a>'+
                                            '</div>'+
                                        '</div>';
                            }
                        }
                        appDom.append(resultHtml);
                    }
                },
                reloadGrid: function () {
                    var searchNmEntry = this.$searchNm.val();
                    var curGrid = this.grid;
                    var reqUrl = '${contextRoot}/resource/resourceManage/getResourceQuotaInfo';
                    var values = {
                        resourceId: resourceId,
                        nameOrCode:searchNmEntry
                    };
                    Util.reloadGrid.call(curGrid,reqUrl, values, 1);
                },
                bindEvents: function () {
                    var self = this;
                    validator =  new jValidation.Validation($("#div_main_relation"), {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){

                    }});

                    $("#div_save").click(function(){
                        var wait = $.Notice.waitting('正在保存中,请稍候...');
                        var saveData = [];
                        var thisResourceId = '';
                        var reqUrl = '${contextRoot}/resource/resourceManage/addResourceQuota';
                        var divItem = $("#div_main_relation").find(".div-item");
                        var lineOrbar = 0;
                        var pie = 0;
                        var lineOrBarFlag = true;
                        var pieFlag = true;
                        $.each(divItem,function(key,value){
                            var qchart = $(value).attr("data-qchart");
                            if(lineOrBarFlag && (qchart == 1 || qchart == 2)){
                                lineOrbar = 1;
                            }else if(pieFlag && qchart == 3){
                                pie = 1;
                            }
                            var ob = {
                                quotaId:$(value).attr("data-id"),
                                resourceId: resourceId,
                                quotaTypeName:$(value).attr("data-name"),
                                quotaCode:$(value).attr("data-quotaCode"),
                                quotaChart:$(value).attr("data-qchart")
                            }
                            saveData.push(ob);
                        });
                        if(lineOrbar + pie >1){
                            wait.close();
                            $.Notice.error('所选的指标展示图表类型不一致，目前支持同一种图表类型组合以及柱状+线型组合，其他组合暂不支持');
                            return;
                        }
                        if (saveData.length == 0) {
                            thisResourceId = resourceId;
                        }
                        var dataModel = $.DataModel.init();
                        dataModel.updateRemote(reqUrl, {data: {resourceId : thisResourceId, jsonModel: JSON.stringify(saveData)},
                            success: function (data) {
                                wait.close();
                                if(data.successFlg){
                                    $.Notice.success('保存成功！');
                                    win.closeZhibaioConfigueDialog();
                                }else{
                                    $.Notice.error(data.errorMsg);
                                }
                            }
                        });
                    });
                    //操作-删除
                    $("#div_main_relation").on("click",".grid_delete",function(){
                        var itemCode = $(this).closest(".div-item").attr("data-code");
                        var selectedData = self.grid.getSelectedRows();
                        var rowdata = null;
                        for(var i=0;i<selectedData.length;i++){
                            if(selectedData[i].code==itemCode){
                                rowdata = selectedData[i];
                                break;
                            }
                        }
                        if(rowdata) self.grid.unselect(rowdata);//取消选中行
                        $("#div_main_relation").find(".div-item[data-code="+itemCode+"]").remove();
                    });
                    $('#div_close').on('click',function () {
                        win.parent.closeZhibaioConfigueDialog();
                    });
                }
            };
            /* ******************Dialog页面回调接口****************************** */

            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>
