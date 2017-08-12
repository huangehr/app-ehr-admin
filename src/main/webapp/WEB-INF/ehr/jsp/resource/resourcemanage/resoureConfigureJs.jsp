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
                            name:""
                        },
                        columns: [
                            {display: '指标分类', name: 'id', width: '35%', isAllowHide: false, align: 'left'},
                            {display: '指标名称', name: 'code', width: '35%', isAllowHide: false, align: 'left'},
                            {display: '图表选择', name: 'name', width: '30%', isAllowHide: false, align: 'left',                                          render:function (row) {
                                var domId = row.__id;
                                var html = ['<select id="' + domId + '" style="width: 100%">',
                                    '<option value="1">选项1</option>',
                                    '<option value="2">选项2</option>',
                                    '</select>'].join('');
                                return html;
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
                            debugger
                            self.mainCheckedData(data.obj,"1");
                        },
                        //默认选中
                        isChecked:function(row){
                            if(row.checked=="1")
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
                                data.checked ="1";
                                data.selVal = selectVal;
                                self.mainCheckedData([data],"1");
                            }else{
                                data.checked ="0";
                                data.selVal = '';
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
//                移除行（右侧表格）
                deleteMainData:function(data){
                    $("#div_main_relation").find(".div-item[data-code="+data.code+"]").remove();
                },
                mainCheckedData:function(data,flag){
                    var resultHtml = "";
                    var appDom = flag=="1"?$("#div_main_relation"):$("#div_slave_relation");
                    for(var i=0;i<data.length;i++){
                        var item = data[i];
                        var mainCode = item.code || item.mainCode || item.slaveCode;
                        if(appDom.find(".div-item[data-code='"+mainCode+"']").length==0){
                            resultHtml+='<div class="h-40 div-item" data-id="'+item.id+'" data-code="'+mainCode+'"  data-name="'+item.name+'" >'+
                                    '<div class="div-main-content">'+mainCode+'</div>'+
                                    '<div class="div-main-content">'+item.name+'</div>'+
                                    '<div class="div-main-content">'+item.selVal+'</div>'+
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
                    var reqUrl = '${contextRoot}/tjDimensionMain/getTjDimensionMainInfo';
                    var values = {
                        resourceId: resourceId,
                        name:searchNmEntry
                    };
                    Util.reloadGrid.call(curGrid,reqUrl, values, 1);
                },
                bindEvents: function () {
                    var self = this;
                    validator =  new jValidation.Validation($("#div_main_relation"), {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){

                    }});

                    $("#div_save").click(function(){
                        var validate = $(".pop_tab li.cur").index()==0?validator.validate():validator1.validate();
                        if(validate){
                            var wait = $.Notice.waitting('正在加载中...');
                            var saveData = [];
                            var quotaCode = null
                            var reqUrl = '${contextRoot}/tjQuotaDimensionMain/addTjQuotaDimensionMain';
                            var divItem = $("#div_main_relation").find(".div-item");
                            $.each(divItem,function(key,value){
                                var ob = {id:$(value).attr("data-id"),quotaCode:self.$quotaCode,mainCode:$(value).attr("data-code"),dictSql:$(value).find(".inp-dictSql").val(),keyVal:$(value).find(".inp-keyVal").val()}
                                saveData.push(ob);
                            })
                            var dataModel = $.DataModel.init();
                            if (saveData.length == 0) {
                                quotaCode = quotaId;
                            }
                            dataModel.updateRemote(reqUrl, {data: {quotaCode : quotaCode, jsonModel: JSON.stringify(saveData)},
                                success: function (data) {
                                    wait.close();
                                    if(data.successFlg){
                                        $.Notice.success('保存成功！');
                                    }else{
                                        $.Notice.error(data.errorMsg);
                                    }
                                }
                            });
                        }
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
