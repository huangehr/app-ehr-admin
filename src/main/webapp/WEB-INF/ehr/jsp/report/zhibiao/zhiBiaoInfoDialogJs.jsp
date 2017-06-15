<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript" src="${staticRoot}/Scripts/homeRelationship.js"></script>
<script>
    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 页面主模块，对应于用户信息表区域
        var zhiBiaoInfo = null;
        var weekDialog = null;
        var initCode = "";
        var initName = "";
        var jValidation = $.jValidation;  // 表单校验工具类
        var dataModel = $.DataModel.init();
        var dataSourceSelectedVal = "";
        var dataStorageSelectedVal = "";

        /* ************************** 变量定义结束 ******************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            zhiBiaoInfo.init();
        }

        /* *************************** 函数定义结束******************************* */

        /* *************************** 模块初始化 ***************************** */
        zhiBiaoInfo = {
            $form: $("#div_patient_info_form"),
            $inpCode: $("#inp_code"),
            $inpName: $("#inp_name"),
            $inpCycle: $("#inp_cycle"),
            $inpObjectClass: $("#inp_object_class"),
            $inpDataSourceJson: $("#inp_dataSource_json"),
            $inpDataStorageJson: $("#inp_dataStorage_json"),
            $inpDataSource: $("#inp_data_source"),
            $inpDataStorage: $("#inp_data_storage"),
            $introduction:$("#inp_introduction"),
            $dataLevel: $('input[name="dataLevel"]', this.$form),
            $status: $('input[name="status"]', this.$form),
            $jobType: $('input[name="jobType"]', this.$form),
            $intervalType: $('input[name="interval_type"]', this.$form),
            $updateBtn:$("#div_update_btn"),
            $cancelBtn:$("#div_cancel_btn"),
            $weekDialog:$("#div_weekDialog"),
            $zhixingDate:$("#inp_zhixing_date"),
            $zhiBiaoId:$("#inp_zhiBiaoId"),
            init: function () {
                this.initForm();
                this.bindEvents();
            },
            dataSourceSelected:function(code, name){
                dataSourceSelectedVal = code;
            },
            dataStorageSelected:function(code, name){
                dataStorageSelectedVal = code;
            },
            initForm: function () {
                var self = this;
                self.$dataLevel.eq(0).attr("checked",'true');
                self.$status.eq(0).attr("checked",'true');
                self.$inpCode.ligerTextBox({width: 240});
                self.$inpName.ligerTextBox({width: 240});
                self.$inpCycle.ligerTextBox({width: 240});
                self.$inpObjectClass.ligerTextBox({width: 240});
                var combo1 = self.$inpDataSource.customCombo('${contextRoot}/tjDataSource/getTjDataSource',null,self.dataSourceSelected,null,null,{valueField: 'code',
                    textField: 'name'});
                self.$inpDataSource.parent().css({
                    width:'240'
                }).parent().css({
                    display:'inline-block',
                    width:'240px'
                });
                var combo2 = self.$inpDataStorage.customCombo('${contextRoot}/tjDataSave/getTjDataSave',null,self.dataStorageSelected,null,null,{valueField: 'code',
                    textField: 'name'});
                self.$inpDataStorage.parent().css({
                    width:'240'
                }).parent().css({
                    display:'inline-block',
                    width:'240px'
                });
                this.$inpDataSourceJson.ligerTextBox({width:240,height:100 });
                this.$inpDataStorageJson.ligerTextBox({width:240,height:100 });
                this.$introduction.ligerTextBox({width:240,height:100 });
                self.$dataLevel.ligerRadio();
                self.$status.ligerRadio();
                self.$jobType.ligerRadio();
                self.$intervalType.ligerRadio();
                self.$zhixingDate.ligerDateEditor({format: "yyyy-MM-dd"});
                $("#txtM").ligerSpinner({width: 208,type: 'int',minValue:1});
                $("#txtH").ligerSpinner({width: 208,type: 'int',minValue:1});
                $("#txtD").ligerSpinner({width: 208,type: 'int',minValue:1});
                $("#txtMD").ligerSpinner({width: 160,type: 'int',minValue:1});
                $('input[name="week_day"]').ligerCheckBox();
                $('input[name="month_day"]').ligerRadio();
                self.$form.attrScan();
            },
            //根据周期类型显示周期面板
            showInterval:function(tab){
                $('input[name="interval_type"]').ligerRadio("setValue", tab);
                $(".divIntervalOption").hide();
                $("#divIntervalOption"+tab).show();
            },
            //初始化时间间隔
            initInterval:function(){
                var me = this;
                var val= $("#txtCronExpression").val();
                if(val!=null&&val.length>0)
                {
                    try {
                        //反解析cron表达式
                        var arry = val.split(' ');
                        if (arry[5] !="?") //周
                        {
                            $('input[name="interval_type"]').ligerRadio("setValue", "3");
                            me.showInterval(3);
                            $('input[name="week_day"]').ligerCheckBox("setValue", arry[5]);
                        }
                        else{
                            if (arry[3] !="*")
                            {
                                var v = arry[3];
                                if(v.indexOf('/')>0) //天
                                {
                                    me.showInterval(2);
                                    var varry = v.split('/');
                                    $("#txtD").val(varry[1]);
                                }
                                else{//月
                                    me.showInterval(4);
                                    if(v=="1")
                                    {
                                        $('input[name="month_day"]').ligerRadio("setValue", "0");
                                    }
                                    else if(v=="L"){
                                        $('input[name="month_day"]').ligerRadio("setValue", "1");
                                    }
                                    else{
                                        $('input[name="month_day"]').ligerRadio("setValue", "2");
                                        $("#txtMD").val(v);
                                    }
                                }
                            }
                            else{
                                var v1 = arry[1];
                                var v2 = arry[2];
                                if(v1.indexOf('/')>0) //分
                                {
                                    me.showInterval(0);
                                    var varry = v1.split('/');
                                    $("#txtM").val(varry[1]);
                                }
                                else{ //时
                                    me.showInterval(1);
                                    var varry = v2.split('/');
                                    $("#txtH").val(varry[1]);
                                }
                            }
                        }

                    }
                    catch(e){
                        return;
                    }
                }
                else{
                    //清空数据
                    $("#txtM").val("");
                    $("#txtH").val("");
                    $("#txtD").val("");
                    $("#txtMD").val("");
                    $('input[name="week_day"]').ligerCheckBox("setValue",null);
                    $('input[name="month_day"]').ligerRadio("setValue",null);
                }
            },
            //设置时间间隔
            setInterval:function(){
                var val = "";
                //解析cron表达式
                var interval_type =  $('input[name="interval_type"]').ligerRadio("getValue");
                var cronTime  = new Date($("#dateNextTime").ligerDateEditor('getValue'));
                var minute = cronTime.getMinutes(),hour = cronTime.getHours();

                if(interval_type =="0") //分钟
                {
                    var num = $("#txtM").val();
                    if(num!=null && num.length>0) {
                        val = "0 0/" + num + " * * * ?";
                    }
                }
                else if(interval_type =="1"){ //时钟
                    var num = $("#txtH").val();
                    if(num!=null && num.length>0) {
                        val = "0 "+ minute +" 0/" + num + " * * ?";
                    }
                }
                else if(interval_type =="2"){ //天
                    var num = $("#txtD").val();
                    if(num!=null && num.length>0) {
                        val = "0 "+ minute +" "+ hour +" 1/" + num + " * ?";
                    }
                }
                else if(interval_type =="3"){ //周
                    var week_day = $('input[name="week_day"]').ligerCheckBox("getValue");
                    if(week_day!=null && week_day.length>0) {
                        val = "0 "+ minute +" "+ hour +" ? * " + week_day;
                    }
                }
                else if(interval_type =="4"){ //月
                    var month_day = $('input[name="month_day"]').ligerRadio("getValue");
                    if(month_day == "0") //每月第一天
                    {
                        val = "0 "+ minute +" "+ hour +" 1 * ?";
                    }
                    else if(month_day == "1") //每月最后一天
                    {
                        val = "0 "+ minute +" "+ hour +" L * ?";
                    }
                    else{
                        var num = $("#txtMD").val();
                        if(num!=null && num.length>0)
                        {
                            val = "0 "+ minute +" "+ hour +" "+num+" * ?";
                        }
                    }
                }

                $("#txtCronExpression").val(val);
            },
            //设置数据集选中值
            setCheckVal:function(){
                var me = this;
                var selected = me.$listDataset.getSelectedRows();
                if(selected!=null)
                {
                    $("#txtJobDataset").val(JSON.stringify(selected));
                }
                else{
                    $("#txtJobDataset").val("");
                }
            },
            bindEvents: function () {
                var self = this;
                self.$inpCycle.click(function(){
                    weekDialog = $.ligerDialog.open({
                        title: "周期配置",
                        width: 416,
                        height: 320,
                        target: self.$weekDialog
                    });

                    $(document).on('click','input[name="jobType"]',function(){
                        var value = $(this).val();
//                    me.setAchiveUploadType(value);
                    });
                    $(document).on('click','input[name="interval_type"]',function(){
                        //清空数据
                        $("#txtCronExpression").val("");
                        self.initInterval();

                        $(".divIntervalOption").hide();
                        $("#divIntervalOption"+$(this).val()).show();
                    });
                    $(document).on('click','input[name="month_day"]',function(){
                        var val = $(this).val();
                        if(val=="2")
                        {
                            $("#txtMD").removeAttr("disabled");
                        }
                        else
                        {
                            $("#txtMD").attr("disabled",true);
                        }
                    });

                })

                var validator =  new jValidation.Validation(this.$form, {immediate: true, onSubmit: false,onElementValidateForAjax:function(elm){
                    if(Util.isStrEquals($(elm).attr('id'),'inp_code')){
                        var result = new jValidation.ajax.Result();
                        var code = self.$inpCode.val();
                        if(code==initCode){
                            result.setResult(true);
                            return result;
                        }
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/tjQuota/hasExistsCode", {
                            data: {code:code},
                            async: false,
                            success: function (data) {
                                if (!data) {
                                    result.setResult(true);
                                } else {
                                    result.setResult(false);
                                    result.setErrorMsg("编码已存在");
                                }
                            }
                        });
                        return result;
                    }
                    if(Util.isStrEquals($(elm).attr('id'),'inp_name')){
                        var result = new jValidation.ajax.Result();
                        var name = self.$inpName.val();
                        if(name==initName){
                            result.setResult(true);
                            return result;
                        }
                        var dataModel = $.DataModel.init();
                        dataModel.fetchRemote("${contextRoot}/tjQuota/hasExistsName", {
                            data: {name:name},
                            async: false,
                            success: function (data) {
                                if (!data) {
                                    result.setResult(true);
                                } else {
                                    result.setResult(false);
                                    result.setErrorMsg("名称已存在");
                                }
                            }
                        });
                        return result;
                    }
                }});

                //新增/修改指标
                zhiBiaoInfo.$updateBtn.click(function () {
                    if(validator.validate()){
                        var values = self.$form.Fields.getValues();
                        values.execType = "1";
                        values.execTime = "2017-06-16";
                        values.tjquotaDataSourceModel = {sourceCode:dataSourceSelectedVal,configJson:self.$inpDataSourceJson.val()};
                        values.tjQuotaDataSaveModel = {saveCode:dataSourceSelectedVal,configJson:self.$inpDataStorageJson.val()};
                        debugger
                        dataModel.fetchRemote("${contextRoot}/tjQuota/updateTjDataSource", {
                            data: {tjQuotaModelJsonData:JSON.stringify(values)},
                            async: false,
                            success: function (data) {
                                if (data.successFlg) {
                                    win.parent.closeZhiBiaoInfoDialog(function () {
                                        if(self.$zhiBiaoId.val()!="" && self.$zhiBiaoId.val()!=undefined){//修改
                                            win.parent.$.Notice.success('修改成功');
                                        }else{
                                            win.parent.$.Notice.success('新增成功');
                                        }
                                    });
                                } else {
                                    window.top.$.Notice.error(data.errorMsg);
                                }
                            }
                        });
                    }else{
                        return
                    }
                });

                //关闭dailog的方法
                zhiBiaoInfo.$cancelBtn.click(function(){

                })
            }
        };

        /* *************************** 模块初始化结束 ***************************** */

        /* *************************** 页面初始化 **************************** */
        pageInit();
        /* *************************** 页面初始化结束 **************************** */


    })(jQuery, window);
</script>