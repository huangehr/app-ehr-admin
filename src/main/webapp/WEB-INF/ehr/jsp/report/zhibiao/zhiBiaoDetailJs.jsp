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
                slaveGrid: null,
                $searchNm: $('#searchNmEntry'),
                $slaSearchNm: $('#searchNmSlaEntry'),
                $quotaCode:$("#inp_quotaCode").val(),
                init: function () {
                    var self = this;
                    quotaId = self.$quotaCode;
                    this.$searchNm.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            self.reloadGrid();
                        }
                    });
                    this.$slaSearchNm.ligerTextBox({
                        width: 200, isSearch: true, search: function () {
                            self.reloadGrid();
                        }
                    });
                    $("#div_relation_grid").show()
                    $("#div_slave_grid").hide();
                    $(".div-slave-search").hide();
                    this.loadMainGrid();//加载主维度值
                    this.loadSlaveGrid();//加载细维度值
                    this.bindEvents();
                },
                loadMainGrid:function(){
                    var self = this;
                    this.grid = $("#div_relation_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/tjDimensionMain/getTjDimensionMainInfo',
                        width:" calc(35% - 20px)",
                        height:"450px",
                        parms: {
                            quotaCode: this.$quotaCode,
                            name:""
                        },
                        columns: [
                            {display: 'id', name: 'id', hide: true},
                            {display: '编码', name: 'code', width: '50%', isAllowHide: false, align: 'left'},
                            {display: '名称', name: 'name', width: '50%', isAllowHide: false, align: 'left'},
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
                            if(row.checked=="1")
                            {
                                return true;
                            }
                            else{
                                return false;
                            }
                        },
                        //选中修改值
                        onCheckRow:function(checked,data,rowid,rowdata)
                        {
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
                loadSlaveGrid:function(){
                    var self = this;
                    this.slaveGrid = $("#div_slave_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/tjDimensionSlave/getTjDimensionSlaveInfo',
                        width:" calc(35% - 20px)",
                        height:"450px",
                        parms: {
                            quotaCode: this.$quotaCode,
                            name:""
                        },
                        columns: [
                            {display: 'id', name: 'id', hide: true},
                            {display: '编码', name: 'code', width: '50%', isAllowHide: false, align: 'left'},
                            {display: '名称', name: 'name', width: '50%', isAllowHide: false, align: 'left'},
                        ],
                        //delayLoad:true,
                        selectRowButtonOnly: false,
                        validate: true,
                        unSetValidateAttr: false,
                        allowHideColumn: false,
                        checkbox: true,
                        onSuccess:function(data){
                            self.mainCheckedData(data.obj,"2");
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
                        //选中修改值
                        onCheckRow:function(checked,data,rowid,rowdata)
                        {
                            //修改行checked值
                            if(checked){
                                data.checked ="1";
                                self.mainCheckedData([data],"2");
                            }else{
                                data.checked ="0";
                                self.deleteSlaveData(data);
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
                                    if($("#div_slave_relation").find(".div-item[data-code='"+currentData[i].code+"']").length>0){
                                        self.deleteSlaveData(currentData[i]);
                                    }
                                }
                            }

                        },
                    }));
                    // 自适应宽度
                    this.slaveGrid.adjustToWidth();
                },
                deleteMainData:function(data){
                    $("#div_main_relation").find(".div-item[data-code="+data.code+"]").remove();
                },
                deleteSlaveData:function(data){
                    $("#div_slave_relation").find(".div-item[data-code="+data.code+"]").remove();
                },
                mainCheckedData:function(data,flag){
                    var resultHtml = "";
                    var appDom = flag=="1"?$("#div_main_relation"):$("#div_slave_relation");
                    for(var i=0;i<data.length;i++){
                        var item = data[i];
                        var mainCode = item.code || item.mainCode || item.slaveCode;
                        if(appDom.find(".div-item[data-code='"+mainCode+"']").length==0){
                            var dictSql = item.dictSql || "";
                            var keyVal = item.keyVal || "";
                            resultHtml+='<div class="h-40 div-item" data-id="'+item.id+'" data-code="'+mainCode+'"  data-name="'+item.name+'" >'+
                                    '<div class="div-main-content">'+mainCode+'</div>'+
                                    '<div class="div-main-content" title="'+item.name+'">'+item.name+'</div>'+
                                    '<div class="div-main-content">'+
                                    '<input type="text" value="'+dictSql+'" class="required inp-dictSql">'+
                                    '</div>'+
                                    '<div class="div-main-content">'+
                                    '<input type="text" value="'+keyVal+'" class="required inp-keyVal">'+
                                    '</div>'+
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
                    if($(".pop_tab li.cur").index()==1){//细维度
                        searchNmEntry = this.$slaSearchNm.val();
                        curGrid = this.slaveGrid;
                        reqUrl = '${contextRoot}/tjDimensionSlave/getTjDimensionSlaveInfo';
                    }
                    var values = {
                        quotaCode: this.$quotaCode,
                        name:searchNmEntry
                    };
                    Util.reloadGrid.call(curGrid,reqUrl, values, 1);
                },
                bindEvents: function () {
                    var self = this;
                    validator =  new jValidation.Validation($("#div_main_relation"), {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){

                    }});

                    validator1 =  new jValidation.Validation($("#div_slave_relation"), {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){

                    }});

                    $(".pop_tab ul").on("click","li",function(){
                        $(".pop_tab ul").find("li").removeClass("cur");
                        $(this).addClass("cur");
                        if($(this).index()==0){
                            $(".div-main-search").show();
                            $(".div-slave-search").hide();
                            $("#div_relation_grid").show();
                            $("#div_slave_grid").hide();
                            $("#div_main_relation").show();
                            $("#div_slave_relation").hide();
                            self.grid.setWidth("100%");
                            self.grid.adjustToWidth();
                        }else{
                            $(".div-main-search").hide();
                            $(".div-slave-search").show();
                            $("#div_relation_grid").hide();
                            $("#div_slave_grid").show();
                            $("#div_main_relation").hide();
                            $("#div_slave_relation").show();
                            self.slaveGrid.setWidth("100%");
                            self.slaveGrid.adjustToWidth();
                        }

                    });

                    $("#div_save").click(function(){
                            var validate = $(".pop_tab li.cur").index()==0?validator.validate():validator1.validate();
                            if(validate){
                                var wait = $.Notice.waitting('正在保存中,请稍候...');
                                var saveData = [];
                                var quotaCode = null
                                var reqUrl = '${contextRoot}/tjQuotaDimensionMain/addTjQuotaDimensionMain';
                                if($(".pop_tab li.cur").index()==0){
                                    var divItem = $("#div_main_relation").find(".div-item");
                                    $.each(divItem,function(key,value){
                                        var ob = {id:$(value).attr("data-id"),quotaCode:self.$quotaCode,mainCode:$(value).attr("data-code"),dictSql:$(value).find(".inp-dictSql").val(),keyVal:$(value).find(".inp-keyVal").val()}
                                        saveData.push(ob);
                                    })
                                }else{
                                     reqUrl = '${contextRoot}/tjQuotaDimensionMain/addTjQuotaDimensionSlave';
                                    var divItem = $("#div_slave_relation").find(".div-item");
                                    $.each(divItem,function(key,value){
                                        var ob = {id:$(value).attr("data-id"),quotaCode:self.$quotaCode,slaveCode:$(value).attr("data-code"),dictSql:$(value).find(".inp-dictSql").val(),keyVal:$(value).find(".inp-keyVal").val()}
                                        saveData.push(ob);
                                    })
                                }
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
                    })

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
                    })

                    $("#div_slave_relation").on("click",".grid_delete",function(){
                        var itemCode = $(this).closest(".div-item").attr("data-code");
                        var selectedData = self.slaveGrid.getSelectedRows();
                        var rowdata = null;
                        for(var i=0;i<selectedData.length;i++){
                            if(selectedData[i].code==itemCode){
                                rowdata = selectedData[i];
                                break;
                            }
                        }
                        if(rowdata) self.slaveGrid.unselect(rowdata);//取消选中行
                        $("#div_slave_relation").find(".div-item[data-code="+itemCode+"]").remove();
                    })
                },
            };
            /* ******************Dialog页面回调接口****************************** */

            /* *************************** 页面功能 **************************** */
            pageInit();
        });
    })(jQuery, window);
</script>
