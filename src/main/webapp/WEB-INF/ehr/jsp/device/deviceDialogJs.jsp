<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var infoForm = null;
        // 表单校验工具类
        var jValidation = $.jValidation;
        var model = {};
		/* *************************** 函数定义 ******************************* */
        function pageInit() {
            infoForm.init();
        }
        /* *************************** 模块初始化 ***************************** */
        var trees;
        infoForm = {
			$form: $("#div_info_form"),
            $device_name: $("#device_name"),
            $org_code: $("#org_code"),
            $device_type: $("#device_type"),
			$purchase_num:$('#purchase_num'),
			$origin_place: $("#origin_place"),
			$manufacturer_name: $("#manufacturer_name"),
			$device_model: $("#device_model"),
			$purchase_time: $("#purchase_time"),
			$is_new: $("#is_new"),
			$device_price: $("#device_price"),
			$year_limit: $("#year_limit"),
			$status: $("#status"),
			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),
            $is_gps: $("#is_gps"),
            init: function () {
                this.initForm();
                this.bindEvents();
            },
            initForm: function () {
                this.$device_name.ligerTextBox({width:240});
                this.$org_code.customCombo('${contextRoot}/organization/orgCodes',{filters: "activityFlag=1;"});
                this.$device_type.customCombo('${contextRoot}/dict/searchDictForSelect',{dictId:"181"});
                this.$purchase_num.ligerTextBox({width:240});
				this.$manufacturer_name.ligerTextBox({width:240});
				this.$device_model.ligerTextBox({width:240});
                this.$purchase_time.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                    if(value){
                        $(".div-head").find(".div-item.active").trigger("click");
                    }
                }});
				this.$device_price.ligerTextBox({width:240});
                this.$year_limit.ligerTextBox({width:240 });
                this.$is_new.ligerComboBox({
                    valueField: 'code',
                    textField: 'value',
                    width: '240',
                    data:[{
                        code: '1',
                        value: '新设备'
                    },{
                        code: '2',
                        value: '二手设备'
                    }]
                });
                this.$origin_place.ligerComboBox({
                    valueField: 'code',
                    textField: 'value',
                    width: '240',
                    data:[{
                        code: '1',
                        value: '进口'
                    },{
                        code: '2',
                        value: '国产/合资'
                    }]
                });
                this.$status.ligerComboBox({
                    valueField: 'code',
                    textField: 'value',
                    width: '240',
                    data:[{
                        code: '1',
                        value: '启用'
                    },{
                        code: '2',
                        value: '未启用'
                    },{
                        code: '3',
                        value: '报废'
                    }]
                });
                this.$is_gps.ligerComboBox({
                    valueField: 'code',
                    textField: 'value',
                    width: '240',
                    data:[{
                        code: '1',
                        value: '是'
                    },{
                        code: '0',
                        value: '否'
                    }]
                });
                var mode = '${mode}';
				if(mode != 'view'){
					$(".my-footer").show();
				}
				if(mode == 'view'){
					infoForm.$form.addClass('m-form-readonly');
                    $(".m-form-control .l-text-trigger-cancel").remove();
					$("#btn_save").hide();
					$("#btn_cancel").hide();
				}
                this.$form.attrScan();
                if(mode !='new'){
                    model = ${model};
                    this.$form.Fields.fillValues({
                        deviceName: model.deviceName,
                        orgCode:model.orgCode,
                        deviceType:model.deviceType,
                        purchaseNum:model.purchaseNum,
                        originPlace: model.originPlace,
                        manufacturerName:model.manufacturerName,
                        deviceModel:model.deviceModel,
                        purchaseTime:model.purchaseTime,
                        isNew:model.isNew,
                        devicePrice:model.devicePrice,
                        yearLimit:model.yearLimit,
                        status:model.status,
                        isGps: model.isGps,
                        id:model.id
                    });
					$("#org_code").ligerGetComboBoxManager().setValue(model.orgCode);
					$("#org_code").ligerGetComboBoxManager().setText(model.orgName);
                    $("#device_type").ligerGetComboBoxManager().setValue(model.deviceType);
                    $("#device_type").ligerGetComboBoxManager().setText(model.deviceType);
                }
                this.$form.show();
            },
            bindEvents: function () {
                var self = this;
                var validator =  new jValidation.Validation(this.$form, {immediate:true,onSubmit:false,
                    onElementValidateForAjax:function(elm){
                        var field = $(elm).attr('id');
                        var val = $('#' + field).val();
                    }
                });
                this.$btnSave.click(function () {
                    if(validator.validate()){
                        var wait = $.ligerDialog.waitting('正在保存中,请稍候...');
                        var values = self.$form.Fields.getValues();
                        values.orgName = $("#org_code").val();
                        values.id = $("#id").val();
                        var dataModel = $.DataModel.init();
                        dataModel.updateRemote("${contextRoot}/device/save",{
                            data: {device: JSON.stringify(values)},
                            success: function(data) {
                                wait.close();
                                if (data.successFlg) {
                                    $.Notice.success('新增成功！');
                                    closeDialog();
                                } else {
                                    $.Notice.error(data.errorMsg);
                                }
                            }
                        });
                    }else{
                        return;
                    }
                });

                this.$btnCancel.click(function () {
					win.closeDialog();
                });
            }
        };

        /* *************************** 页面初始化 **************************** */
        pageInit();

    })(jQuery, window);
</script>