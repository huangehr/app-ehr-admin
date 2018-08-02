<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var addUserInfo = null;

        var source;
        var trees;

        win.orgDeptDio = null;
        win.ORGDEPTVAL = '';
        win.roleIds = '';


        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        /**
         * 页面初始化。
         * @type {Function}
         */
        function pageInit() {
            addUserInfo.init();
            $("#div_addUser_form").show();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */

        addUserInfo = {
            $form: $("#div_addUser_form"),
            $loginCode: $("#inp_loginCode"),
            $userName: $('#inp_userName'),
            $idCard: $('#inp_idCard'),
            $userEmail: $('#inp_userEmail'),
            $userTel: $('#inp_userTel'),
//            $org: $('#inp_org'),
//            $major: $('#inp_major'),
//            $source: $('#inp_source'),
            $sex: $('input[name="gender"]', this.$form),
            $uploader: $("#div_user_img_upload"),
//            $inp_select_marriage: $("#inp_select_marriage"),
            $inp_select_userType: $("#inp_select_userType"),
            $addUserBtn: $("#div_btn_add"),
            $cancelBtn: $("#div_cancel_btn"),
            $imageShow: $("#div_file_list"),
//            $jryycyc:$("#jryycyc"),//cyctodo
//            $location: $('#location'),
            $divBtnShow: $('#divBtnShow'),
            $divBtnSetrole:$("#div_btn_setrole"),
            $SelSetrole:$("#inp_select_setrole"),

            init: function () {
                var self = this;
                self.$sex.eq(0).attr("checked", 'true');
                self.initForm();
                self.bindEvents();
//                this.cycToDo()//复制完记得删掉
                self.$uploader.instance = self.$uploader.webupload({
                    server: "${contextRoot}/user/updateUser",
                    pick: {id: '#div_file_picker'},
                    accept: {
                        title: 'Images',
                        extensions: 'gif,jpg,jpeg,bmp,png',
                        mimeTypes: 'image/*'
                    },
                    auto: false
                });
                self.$uploader.instance.on('uploadSuccess', function (file, resp) {
                    if(!resp.successFlg)
                        $.Notice.error(resp.errorMsg);
                    else
                        $.Notice.success('新增成功',function () {
                            win.parent.closeAddUserInfoDialog();
                        });
                    win.parent.closeAddUserInfoDialog(function () {});//只做刷新列表
                });

            },
            initForm: function () {
                this.$loginCode.ligerTextBox({width: 240});
                this.$userName.ligerTextBox({width: 240});
                this.$idCard.ligerTextBox({width: 240});
                this.$userEmail.ligerTextBox({width: 240});
                this.$userTel.ligerTextBox({width: 240});
//                this.$major.ligerTextBox({width: 240});
                this.$sex.ligerRadio();


                var select_user_type = this.$inp_select_userType.customCombo('${contextRoot}/userRoles/user/searchUserType',{searchParm:''});

                <%--source = this.$source.ligerComboBox({--%>
                <%--url: '${contextRoot}/dict/searchDictEntryList',--%>
                <%--valueField: 'code',--%>
                <%--textField: 'value',--%>
                <%--dataParmName: 'detailModelList',--%>
                <%--urlParms: {--%>
                <%--dictId: 26--%>
                <%--},--%>
                <%--onSuccess: function () {--%>
                <%--self.$form.Fields.fillValues({sourceName: user.sourceName,});--%>
                <%--},--%>

                <%--});--%>



                this.$form.attrScan();
            },

            bindEvents: function () {
                var self = this;
                var validator = new jValidation.Validation(this.$form, {
                    immediate: true, onSubmit: false,
                    onElementValidateForAjax: function (elm) {
                        var checkObj = { result:true, errorMsg: ''};
                        if (Util.isStrEquals($(elm).attr("id"), 'inp_loginCode')) {
                            var loginCode = $("#inp_loginCode").val();
                            checkObj = checkDataSourceName('login_code', loginCode, "该账号已存在");
                        }
                        if (Util.isStrEquals($(elm).attr("id"), 'inp_idCard')) {
                            var idCard = $("#inp_idCard").val();
                            var cellphone = $("#inp_userTel").val();
                            checkObj = checkDataSourceName('id_card_no', idCard, "该身份证号已被注册，请确认。");
                            if (checkObj.result) {
                                inputSourceByIdCard(idCard,cellphone);
                            }
                        }
                        if (Util.isStrEquals($(elm).attr("id"), 'inp_userEmail')) {
                            var email = $("#inp_userEmail").val();
                            checkObj = checkDataSourceName('email', email, "该邮箱已存在");
                        }
//                        新增用户手机号验证
                        if (Util.isStrEquals($(elm).attr("id"), 'inp_userTel')) {
                            var telephone = $("#inp_userTel").val();
                            checkObj = checkDataSourceName('telephone', telephone, "该手机号码已存在");
                        }
                        if (!checkObj.result) {
                            return checkObj;
                        } else {
                            return checkObj.result;
                        }
                    }
                });
                //唯一性验证--账号/身份证号(字段名、输入值、提示信息）  ---新增用户手机号验证
                function checkDataSourceName(type, inputValue, errorMsg) {
                    var result = new jValidation.ajax.Result();
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/user/existence", {
                        data: {existenceType: type, existenceNm: inputValue},
                        async: false,
                        success: function (data) {
                            if (data.successFlg) {
                                result.setResult(false);
                                result.setErrorMsg(errorMsg);
                            } else {
                                result.setResult(true);
                                result.setErrorMsg('');
                            }
                        }
                    });
                    return result;
                }

                function inputSourceByIdCard(inputValue,phone) {
                    var result = new jValidation.ajax.Result();
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/user/getPatientInUserByIdCardNo", {
                        data: {idCardNo: inputValue},
                        async: false,
                        success: function(data) {
                            var model = data.obj;
                            if (model != null) {
                                if(model.name) {
                                    self.$userName.val(model.name);
                                }
                                if(model.gender){
                                    self.$sex.val(model.gender);
                                }
                                if(model.martialStatus) {
//                                    self.$inp_select_marriage.val(model.martialStatus);
                                    self.$inp_select_marriage.ligerComboBox({
                                        url: '${contextRoot}/dict/searchDictEntryList',
                                        valueField: 'code',
                                        textField: 'value',
                                        dataParmName: 'detailModelList',
                                        urlParms: {
                                            dictId: 4
                                        },
                                        onSuccess: function () {
                                            self.$form.Fields.fillValues({martialStatus: model.martialStatus});
                                        }
                                    });
                                }
                                if(model.email){
                                    self.$userEmail.val(model.email);
                                }
                                if(model.telephoneNo){
                                    self.$userTel.val(model.telephoneNo);
                                    if(phone){
                                        self.$userTel.val(phone);
                                    }
                                }
                            }
                        },
                        error: function () {
                            // alert(1)
                        }
                    });
                    return result;
                }

                //新增的点击事件
                this.$addUserBtn.click(function () {
                    debugger
                    var userImgHtml = self.$imageShow.children().length;
                    var addUser = self.$form.Fields.getValues();
                    var roles = win.roleIds;
                    console.log('selroles'+roles);
                    addUser.role = roles;
                    if (validator.validate()) {
//                        var organizationKeys = addUser.organization['keys'];
//
//                        addUser.organization = organizationKeys[2];
//                        addUser.source = source.getValue();
                        if (userImgHtml == 0) {
                            updateUser(addUser);
                        } else {
                            var upload = self.$uploader.instance;
                            var image = upload.getFiles().length;
                            if (image) {
                                upload.options.formData.userModelJsonData = encodeURIComponent(JSON.stringify(addUser));
                                upload.upload();
                            } else {
                                updateUser(addUser);
                            }
                        }

                    } else {
                        return;
                    }


                });


                function updateUser(userModel) {
                    var userModelJsonData = JSON.stringify(userModel);
                    var dataModel = $.DataModel.init();
                    var jsonModel = win.ORGDEPTVAL;
                    if (jsonModel.length <= 0) {
                        $.Notice.error('请选择机构部门');
                        return;
                    }
                    dataModel.updateRemote("${contextRoot}/user/updateUserAndInitRoles", {
                        data: {userModelJsonData: userModelJsonData,orgModel:jsonModel},
                        success: function (data) {
                            if (data.successFlg) {
                                $.Notice.success('新增成功',function () {
                                    win.parent.closeAddUserInfoDialog();
                                });
                                win.parent.closeAddUserInfoDialog(function () {});//只做刷新列表
                            } else {
                                $.Notice.error(data.errorMsg);
                            }
                        }
                    })
                }

                self.$cancelBtn.click(function () {
                    win.parent.closeAddUserInfoDialog();
                });

                this.$divBtnShow.click(function () {
                    var wait = $.Notice.waitting("请稍后...");
                    win.orgDeptDio = $.ligerDialog.open({
                        height: 620,
                        width: 800,
                        title: '选择机构部门',
                        url: '${contextRoot}/doctor/selectOrgDept',
                        urlParms: {
                            idCardNo: ''
                        },
                        isHidden: false,
                        show: false,
                        onLoaded: function () {
                            wait.close();
                            win.orgDeptDio.show();
                        },
                        load: true
                    });
                    win.orgDeptDio.hide();
                })

                this.$divBtnSetrole.click(function () {
                    var addUser = self.$form.Fields.getValues();
                    debugger
                    if(addUser.userType){
                        var wait = $.Notice.waitting("请稍后...");
                        win.roleGroupDio = $.ligerDialog.open({
                            height: 620,
                            width: 800,
                            title: '关联角色组',
                            url: '${contextRoot}/user/appRoleGroup',
                            urlParms: {
                                loginCode: addUser.loginCode,
                                type: addUser.userType,
                            },
                            isHidden: false,
                            show: false,
                            onLoaded: function () {
                                wait.close();
                                win.roleGroupDio.show();
                            },
                            load: true
                        });
                        win.roleGroupDio.hide();
                    }else{
                        $.Notice.warn("请选择用户类别")
                    }
                })
            },
            cycToDo:function(){
                var self=this;
                trees=self.$jryycyc.ligerComboBox({
                    width : 240,
                    selectBoxWidth: 238,
                    selectBoxHeight: 500, textField: 'name', treeLeafOnly: false,
                    tree: {
                        url:"${contextRoot}/user/appRolesList",
                        idFieldName:'id',
                        textFieldName:'name',
                        //autoCheckboxEven:false,
                        isExpand:true,
                        onClick:function(e){

                            self.listTree(trees);
                        },
                        onSuccess:function(data){
//							for(var item in data) {
//								$('#'+data[item].id).children('.l-body').children('.l-checkbox').hide();
//							}
                        }
                    },
                    onBeforeSelect: function () {

                    }
                })

                function removeSclBox(){
                    setTimeout(function(){
                        $(trees.tree).prev(".mCustomScrollBox").hide()
                    },100)
                }
                self.$jryycyc.on("click", removeSclBox);
                $('#roleDiv div.l-trigger-icon').on("click",removeSclBox);
                self.listTreeClick(trees);
            },//树形结构todo
            listTree:function(trees){
                var self=this;
                var dataAll=trees.treeManager.data//获取所有选中的值
                var dateTreeEd=trees.treeManager.getChecked()//获取所有选中的值
                var liHtml="";//li拼接
                var obj=self.$jryycyc.closest(".m-form-group");//父容器
                $.each(dateTreeEd,function(i,v){
                    if(v.data.children==null){
                        var  tit="";
                        for(i=0;i<dataAll.length;i++){
                            if(v.data.pid==dataAll[i].id){
                                tit=dataAll[i].name+":"+v.data.name
                            }
                        }
                        liHtml+='<li ><a href="javascript:void(0);" data-id="'+v.data.id+'"  data-index="'+v.data.treedataindex+'" >X</a>'+tit+'</li>';
                    }
                })
                if(obj.find(".listree").length==0){
                    obj.append('<div class="listree"></div>')
                }
                $(".listree").html(liHtml);

            },
            listTreeClick:function(trees){
                $("body").delegate(".listree a","click",function(){
                    $("li#"+$(this).attr("data-id"), trees.tree).find(".l-checkbox").click()
                })//删除操作
            },
            roleIds:function(addUserRole){//得到的角色组ids过滤，去除应用id
                if(!addUserRole){
                    return '';
                }
                var dateTreeEd=trees.treeManager.getChecked();
                var roleArray = [];
                for(var i in dateTreeEd){
                    if(!Util.isStrEquals(dateTreeEd[i].data.type,"0")){
                        roleArray.push(dateTreeEd[i].data.id)
                    }
                }
                return roleArray.join(",");
            }
        };


        /* ************************* 模块初始化结束 ************************** */

        /* *************************** 页面初始化 **************************** */

        pageInit();

        /* ************************* 页面初始化结束 ************************** */

    })(jQuery, window);
</script>