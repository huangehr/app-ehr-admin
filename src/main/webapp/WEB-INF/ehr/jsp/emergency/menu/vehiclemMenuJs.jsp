<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript" src="${staticRoot}/Scripts/homeRelationship.js"></script>
<script>


    (function ($,win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 页面主模块，对应于用户信息表区域
        var menuInfo = null;
        var initCode = "";
        var initName = "";
        var initList = "";
        var jValidation = $.jValidation;  // 表单校验工具类
        var dataModel = $.DataModel.init();
        var id = '${id}';
        var parentSelectedVal = "";
        var validator = null;

        /* ************************** 变量定义结束 ******************************** */


        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            menuInfo.init();

        }

        /* *************************** 函数定义结束******************************* */

        /* *************************** 模块初始化 ***************************** */
        menuInfo={
            $new_Dialogue :$('.new_Dialogue'),
            $head_Img :$('.head_Img'),
            $license_Plate_input :$('#license_Plate_input'),
            $inpStatus: $('input[name="inp_status"]', this.$new_Dialogue),
            $personnel_phone_input :$('#personnel_phone_input'),
            $area:$('#inpMonitorType'),
            $updateBtn:$("#div_update_btn"),
            $cancelBtn:$("#div_cancel_btn"),
            ambulance:{},
            global:null,
            dataModel: $.DataModel.init(),//ajax初始化
            $uploader:$('#div_file_picker'),
            $imageShow: $("#div_file_list"),
            $div_doctor_img_upload:$('#div_doctor_img_upload'),
            $location:null,

            init:function () {
                var self  = this;
                self.initForm();
                self.bindEvents();
                self.loadSelData();
                if (id!='-1'){//不等于-1 从编辑按钮过来的弹窗
                    self.$div_doctor_img_upload.empty()
                    this.getInfo(this.setInfo, this)
                }
                //初始化上传头像
                self.$uploader.instance = self.$uploader.webupload({
                    method:'POST',
                    server: "${contextRoot}/ambulance/save",
                    pick: {id: '#div_file_picker'},
                    accept: {
                        title: 'Images',
                        extensions: 'gif,jpg,jpeg,bmp,png',
                        mimeTypes: 'image/*'
                    },
                    auto: false,
                });
                self.$uploader.instance.on('uploadSuccess', function (file, resp) {
                    if(!resp.successFlg){
                        $.Notice.error(resp.errorMsg);
                    }
                    else{
                        $.Notice.success('新增成功');
                    }
                });
            },
            //加载默认筛选调条件(归属地点的接口)
            loadSelData:function (p) {
                var self = this;
                self.loadReportMonitorTypeDate().then(function (res) {
                    if(res.successFlg){
                        var d = res.detailModelList;
                        //下拉插件初始化
                        self.$area.ligerComboBox({
                            url: '${contextRoot}/location/list',
                            ajaxType:'GET',
                            parms: {page:1,size:100},
                            isShowCheckBox: true,
                            width: '240',
                            valueField: 'id',
                            textField: 'initAddress',
                            valueFieldID: 'ids',
                            dataParmName: 'detailModelList',
                            isMultiSelect: false
                        });
//                        var aaa = '';
//                        $.each(d, function (k, obj) {
//                            obj.flag && (aaa += (obj.id + ';'));
//                        })
//                        self.$area.liger().selectValue(aaa);

                        $.each(d, function (k, v) {
                            if(p == v.id){
//                                console.log(v.id);
//                                self.$area.attr("placeholder",v.initAddress)
                                self.$area.liger().selectValue(v.id);
                            }
                        })
                    }else {
                        self.$area.ligerComboBox({width: '240'});
                    }
                })
            },
            //资源报表监测类型
            loadReportMonitorTypeDate: function () {
                return this.loadPromise("${contextRoot}/location/list", {page:1,size:100});
            },
            loadPromise: function (url, d) {
                var self = this;
                return new Promise(function (resolve, reject) {
                    self.dataModel.fetchRemote(url, {
                        data: d,
                        type: 'GET',
                        success: function (data) {
                            resolve(data);
                        }
                    });
                });
            },
            setInfo: function (res, me) {
                var self = this;
                initList = res.obj;
                me.$license_Plate_input.attr("disabled",'disabled')
                me.$license_Plate_input.val(initList.id);
                me.$personnel_phone_input.val(initList.phone);
                me.$location = initList.location;
                me.loadSelData(me.$location);
                if (initList.status == 'wait') {
                    me.$inpStatus.eq(0).ligerRadio("setValue",'1');
                    me.$inpStatus.eq(1).ligerRadio("setValue",'');
                } else if (initList.status == 'arrival') {
                    me.$inpStatus.eq(0).ligerRadio("setValue",'');
                    me.$inpStatus.eq(1).ligerRadio("setValue",'0');
                }
            },
            getInfo: function (cb, me) {
                $.ajax({
                    url: '${contextRoot}/ambulance/findById',
                    data: {
                        id: id
                    },
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        if (data) {
                            cb && cb.call( this, data, me);

                        } else {
                            $.Notice.error("信息获取失败");
                        }
                    }
                });
            },
            initForm: function () {
                var self = this;
                self.$inpStatus.eq(0).attr("checked","true");
                self.$inpStatus.eq(0).ligerRadio();
                self.$inpStatus.eq(1).ligerRadio();
            },
            bindEvents:function () {
                var self = this;
                var parameter = null;
                var resultOne = false;
                var resultTwo = false;
                //保存按钮
                menuInfo.$updateBtn.click(function () {
                    if(id!='-1'){//不等于-1 从编辑按钮过来的
                        var $license_Plate_input = self.$license_Plate_input.val();
                        var $personnel_phone_input = self.$personnel_phone_input.val();
                        var $inpStatus =  $('input[name=inp_status]:checked').val();
                        var $id = self.$area.ligerGetComboBoxManager().getValue();
                        var judge = false;
                        var judgePhone = self.checkMobile($personnel_phone_input);
                        self.ambulance ={
                            "img": null,
                            "id": $license_Plate_input,
                            "phone": $personnel_phone_input,
                            "status": $inpStatus,
                            "location":$id||self.$location
                        };
                        parameter = JSON.stringify(self.ambulance);
                        if(judgePhone){
                            debugger
                            $.ajax({
                                type:"POST",
                                url: '${contextRoot}/ambulance/update',
                                data:{
                                    ambulance:parameter
                                },
                                dataType:"json",
                                error: function(XMLHttpRequest, textStatus, errorThrown) {

                                },
                                success:function (data) {
                                    if(data.successFlg){
                                        closeMenuInfoDialog(function () {
                                            $.Notice.success('更新成功');
                                        });
                                    }else {
                                        closeMenuInfoDialog(function () {
                                            window.top.$.Notice.error(data.errorMsg);
                                        });
                                    }
                                }
                            })
                        }else {
                            $.Notice.error("您输入的手机号码有误");
                        }
                    }else {// 从新增按钮过来的
                        var $license_Plate_input = self.$license_Plate_input.val();
                        var $personnel_phone_input = self.$personnel_phone_input.val();
                        var $inpStatus =  $('input[name=inp_status]:checked').val();
                        var $id = self.$area.ligerGetComboBoxManager().getValue();
                        self.ambulance ={
                            "img": null,
                            "id": $license_Plate_input,
                            "phone": $personnel_phone_input,
                            "status": $inpStatus,
                            "location":$id
                        };
                        parameter = JSON.stringify(self.ambulance);
//                        self.global = parameter;
//                        console.log(self.global)
                        <%--$.ajax({--%>
                            <%--type:"POST",--%>
                            <%--url: '${contextRoot}/ambulance/save',--%>
                            <%--data:{--%>
                                <%--ambulance:parameter--%>
                            <%--},--%>
                            <%--dataType:"json",--%>
                            <%--error: function(XMLHttpRequest, textStatus, errorThrown) {--%>

                            <%--},--%>
                            <%--success:function (data) {--%>
                                <%--if(data.successFlg){--%>
                                    <%--closeMenuInfoDialog(function () {--%>
                                        <%--$.Notice.success('新增成功');--%>
                                    <%--});--%>
                                <%--}else {--%>
                                    <%--closeMenuInfoDialog(function () {--%>
                                        <%--window.top.$.Notice.error(data.errorMsg);--%>
                                    <%--});--%>
                                <%--}--%>
                            <%--}--%>
                        <%--})--%>
                        //验证图片
                        var imgHtml = self.$imageShow.children().length;
                        if (imgHtml == 0) {
                            if(resultOne&&resultTwo){
                                update(parameter);
                            }else {
                                $.Notice.error("您输入的车牌号或者手机号码有误");
                            }

                        } else {
                            var upload = self.$uploader.instance;
                            var image = upload.getFiles().length;
                            if (image) {
                                upload.options.formData.ambulance = JSON.stringify(parameter);
                                upload.upload();
                            } else {
                                if(resultOne&&resultTwo){
                                    update(parameter);
                                }else {
                                    $.Notice.error("您输入的车牌号或者手机号码有误");
                                }
                            }
                        }
                    }

                });
                function update(addModel) {
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/ambulance/save", {
                        data: {ambulance: addModel},
                        type:"POST",
                        success: function (data) {
                            if (data.successFlg){
//                                页面回调
                                closeMenuInfoDialog(function () {
                                    $.Notice.success('新增成功');
                                })
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    })
                }

                // 正则筛选事件检验车牌号
                menuInfo.$license_Plate_input.change(function () {
                    var $license_Plate_input = self.$license_Plate_input.val();
                    var place = self.isVehicleNumber($license_Plate_input);
                    if(!place){
                        $.Notice.error("您输入的车牌号有误");
                    }else {
                        resultOne = true;
                    }
                    return resultOne;
                })
                // 正则筛选事件检验手机号
                menuInfo.$personnel_phone_input.change(function () {
                    var $personnel_phone_input = self.$personnel_phone_input.val();
                    var phone = self.checkMobile($personnel_phone_input);
                    if(!phone){
                        $.Notice.error("您输入的手机号码有误");
                    }else {
                        resultTwo = true;
                    }
                    return resultTwo;
                })
                //关闭dailog的方法
                menuInfo.$cancelBtn.click(function(){
                    closeDialog();
                })
            },
            //正则表达式筛选车牌号码
            isVehicleNumber:function (vehicleNumber) {
                var result = false;
                if (vehicleNumber.length == 7){
                    var express = /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$/;
                    result = express.test(vehicleNumber);
                }
                return result;
            },
            //正则表达式筛选手机号码
            checkMobile:function (sMobile){
                var result = false;

                if(!((/^1[3|4|5|8][0-9]\d{4,8}$/).test(sMobile))){
                    debugger
                    result = false;
                }else {
                    result = true;
                }
                return result;
            }
        }
        /* *************************** 模块初始化结束 ***************************** */


        /* *************************** 页面初始化 **************************** */
        pageInit();
        /* *************************** 页面初始化结束 **************************** */

    })(jQuery,window)
</script>

