<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script src="${contextRoot}/develop/source/formFieldTools.js"></script>
<script src="${contextRoot}/develop/source/gridTools.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>
<script src="${contextRoot}/develop/lib/ligerui/custom/uploadFile.js"></script>
<script>
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
            /* *************************** 函数定义 ******************************* */
            function pageInit() {
                entryMater.init();
            }


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
                    this.loadMainGrid();//加载指标图表
                    this.bindEvents();
                },
                loadMainGrid:function(){
                    var self = this;
                    this.grid = $("#div_relation_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/tjQuota/getTjQuotaChartList',
                        width:"300px",
                        height:"450px",
                        parms: {
                            quotaCode:quotaId,
                            name:"",
                            dictId: 91
                        },
                        columns: [
                            {display: 'id', name: 'id', hide: true},
                            {display: '编号', name: 'code', width: '50%', isAllowHide: false, align: 'left'},
                            {display: '名称', name: 'value', width: '50%', isAllowHide: false, align: 'left'}
                        ],
                        //delayLoad:true,
                        selectRowButtonOnly: false,
                        validate: true,
                        unSetValidateAttr: false,
                        allowHideColumn: false,
                        checkbox: true,
                        onSuccess:function(data){
                            self.mainCheckedData(data.obj,"1");
                        },
                        //默认选中
                        isChecked:function(row){
                            if(row.checked=="1"){
                                return true;
                            }
                            else{
                                return false;
                            }
                        },
                        //选中修改值
                        onCheckRow:function(checked,data,rowid,rowdata){
                            //修改行checked值
                            if(checked){
                                data.checked ="1";
                                self.mainCheckedData([data],"1");
                            }else{
                                data.checked ="0";
                                self.deleteMainData(data);
                            }
                        },
                        //全选事件
                        onCheckAllRow:function(){
                            var selectedData = self.grid.getSelectedRows();
                            if(selectedData.length>0){
                                self.mainCheckedData(selectedData,"1");
                            }else{
                                var currentData =  self.grid.getData();
                                for(var i=0;i<currentData.length;i++){
                                    if($("#div_main_relation").find(".div-item[data-code='"+currentData[i].code+"']").length>0){
                                        self.deleteMainData(currentData[i]);
                                    }
                                }
                            }
                        },
                    }));
                    // 自适应宽度
                    this.grid.adjustToWidth();
                },
                deleteMainData:function(data){
                    $("#div_main_relation").find(".div-item[data-code="+data.code+"]").remove();
                },
                mainCheckedData:function(data,flag){
                    var resultHtml = "";
                    var appDom = flag=="1"?$("#div_main_relation"):$("#div_slave_relation");
                    for(var i=0;i<data.length;i++){
                        var item = data[i];
                        var mainCode = item.code;
                        if(appDom.find(".div-item[data-code='"+mainCode+"']").length==0){
                            debugger
                            resultHtml+='<div class="h-40 div-item" data-id="'+item.code+'" data-code="'+mainCode+'"  data-name="'+item.value+'" >'+
                                    '<div class="div-main-content">'+mainCode+'</div>'+
                                    '<div class="div-main-content" title="'+item.value+'">'+item.value+'</div>'+
                                    '<div class="div-delete-content">'+
                                    '<a class="grid_delete" href="#" title="删除"></a>'+
                                    '</div>'+
                                    '</div>';
                        }
                    }
                    appDom.append(resultHtml);
                },
                reloadGrid: function () {
                    var searchNmEntry = this.$searchNm.val();
                    var curGrid = this.grid;
                    var reqUrl = '${contextRoot}/tjQuota/getTjQuotaChartList';
                    var values = {
                        quotaCode: this.$quotaCode,
                        name:searchNmEntry,
                        dictId: 91
                    };
                    Util.reloadGrid.call(curGrid,reqUrl, values, 1);
                },
                bindEvents: function () {
                    var self = this;
                    validator =  new jValidation.Validation($("#div_main_relation"), {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){

                    }});

                    $("#div_save").click(function(){
                        debugger
                        var wait = $.Notice.waitting('正在加载中...');
                        var saveData = [];
                        var quotaCode = null
                        var reqUrl = '${contextRoot}/tjQuota/addTjQuotaChart';
                        var divItem = $("#div_main_relation").find(".div-item");
                        $.each(divItem,function(key,value){
                            var ob = {
                                chartId:$(value).attr("data-code"),
                                quotaCode : self.$quotaCode
                            }
                            saveData.push(ob);
                        })
                        var dataModel = $.DataModel.init();
                        dataModel.updateRemote(reqUrl, {data: {quotaCode : self.$quotaCode, jsonModel: JSON.stringify(saveData)},
                            success: function (data) {
                                wait.close();
                                if(data.successFlg){
                                    win.parent.closeChartConfigDialog();
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
//                        win.closeChartConfigDialog();
                        win.closeConfigDialog();
                    });
                }
            };
            /* ******************Dialog页面回调接口****************************** */

            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>
