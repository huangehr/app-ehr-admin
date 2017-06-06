<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {

        /* ************************** 变量定义 ******************************** */
        // 通用工具类库
        var Util = $.Util;
        var userInfo = null;

        //修改用户变量
        var userModel = null;

        //公钥管理弹框
        var publicKeyMsgDialog = null;

        // 表单校验工具类
        var jValidation = $.jValidation;

        var allData = ${allData};
        var user = allData.obj;
		var trees;


        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        function pageInit() {
            userInfo.init();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */
        userInfo = {
            $idCardCopy: $('#idCardCopy'),
            $emailCopy: $('#emailCopy'),
            $tel2: $('#inp_userTel2'),
            $location: $('#location'),
            $fertilityStatus: $('#inp_fertilityStatus'),
            $qq: $('#inp_qq'),
            $micard: $('#inp_micard'),
            $ssid: $('#inp_ssid'),
            $realnameFlag: $('input[name="realnameFlag"]', this.$form),
            $birthday: $("#inp_birthday"),

            $form: $("#div_user_info_form"),
            $loginCode: $("#inp_loginCode"),
            $realName: $('#inp_user_name'),
            $idCard: $('#inp_idCard'),
            $email: $('#inp_userEmail'),
            $tel: $('#inp_userTel'),
//            $org: $('#inp_org'),
            $major: $('#inp_major'),
//            $source:$('#inp_source'),
            $userSex: $('input[name="gender"]', this.$form),
            $marriage: $("#inp_select_marriage"),
            $userType: $("#inp_select_userType"),
            $updateUserDtn: $("#div_update_btn"),
            $cancelBtn: $("#div_cancel_btn"),
            $resetPassword: $("#div_resetPassword"),
            $publicKey: $("#div_publicKey"),
            $uploader: $("#div_user_img_upload"),
            $emailRelieve: $("#div_emailRelieve"),
            $telRelieve: $("#div_telRelieve"),
            $publicManage: $("#div_public_manage"),
            $allotpublicKey: $("#div_allot_publicKey"),
            $publicKeyMessage: $("#txt_publicKey_message"),
            $publicKeyValidTime: $("#lbl_publicKey_validTime"),
            $publicKeyStartTime: $("#lbl_publicKey_startTime"),
            $selectPublicKeyMessage: $("#div_publicKeyMessage"),
            $selectPublicKeyValidTime: $("#div_publicKey_validTime"),
            $selectPublicKeyStartTime: $("#div_publicKey_startTime"),
            $filePicker: $("#div_file_picker"),
            $affirmBtn: $('#div_affirm_btn'),
            $toolbar: $('#div_toolbar'),
            $imageShow: $('#div_file_list'),
			$jryycyc:$("#jryycyc"),//cyctodo

            init: function () {
				var self = this;
				this.cycToDo()//复制完记得删掉
                self.initForm();
                self.bindEvents();
                //self.$uploader.webupload();
                self.$uploader.instance = self.$uploader.webupload({
                    server: "${contextRoot}/user/updateUser",
                    pick: {id: '#div_file_picker'},
                    accept: {
                        title: 'Images',
                        extensions: 'gif,jpg,jpeg,bmp,png',
                        mimeTypes: 'image/*'
                    },
                    auto: false,
                    async:false
                });
                self.$uploader.instance.on( 'uploadSuccess', function( file, resp ) {
                    if(!resp.successFlg)
                        $.Notice.error(resp.errorMsg);
                    else
                        $.Notice.success('修改成功');
                    win.closeUserInfoDialog();
                    win.reloadMasterUpdateGrid();
                });
            },
			cycToDo:function(){
				var self=this;
				var treeData;
				$.ajax({
					dataType: 'json',
					async: false,
					url: '${contextRoot}/user/appRolesList',
					success: function (data) {
						treeData = data;
					}
				})
				trees=self.$jryycyc.ligerComboBox({
					width : 240,
					selectBoxWidth: 238,
					selectBoxHeight: 500, textField: 'name', treeLeafOnly: false,
					tree: {
						data: treeData, idFieldName:'id', textFieldName: 'name', onClick:function(e){
							self.listTree(trees);
						}},
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
            initForm: function () {
                var self = this;
                this.$form.removeClass("m-form-readonly");
                this.$loginCode.ligerTextBox({width: 240});
                this.$realName.ligerTextBox({width: 240});
                this.$idCard.ligerTextBox({width: 240});
                this.$email.ligerTextBox({width: 240});
                this.$tel.ligerTextBox({width: 240});
                this.$qq.ligerTextBox({width: 240});
                this.$micard.ligerTextBox({width: 240});
                this.$ssid.ligerTextBox({width: 240});
                this.$tel2.ligerTextBox({width: 240});
                this.$birthday.ligerDateEditor({format: "yyyy-MM-dd"});

                <%--this.$org.addressDropdown({--%>
                    <%--tabsData: [--%>
                        <%--{name: '省份', code: 'id', value: 'name', url: '${contextRoot}/address/getParent', params: {level: '1'}},--%>
                        <%--{name: '城市', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'},--%>
                        <%--{name: '医院', code: 'orgCode', value: 'fullName', url: '${contextRoot}/address/getOrgs',--%>
                            <%--beforeAjaxSend: function (ds, $options) {--%>
                                <%--var province = $options.eq(0).attr('title'),--%>
                                        <%--city = $options.eq(1).attr('title');--%>
                                <%--ds.params = $.extend({}, ds.params, {--%>
                                    <%--province: province,--%>
                                    <%--city: city--%>
                                <%--});--%>
                            <%--}--%>
                        <%--}--%>
                    <%--]--%>
                <%--});--%>
                this.$major.ligerTextBox({width: 240});
//                this.$source.ligerTextBox({width: 240});
                this.$userSex.ligerRadio();
                this.$marriage.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 4
                    },
                    onSuccess: function () {
                        self.$form.Fields.fillValues({martialStatus: user.martialStatus});
                    }
                });

                this.$fertilityStatus.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 54
                    },
                    onSuccess: function () {
                        self.$form.Fields.fillValues({fertilityStatus: user.fertilityStatus});
                    }
                });

                this.$userType.ligerComboBox({
                    url: '${contextRoot}/dict/searchDictEntryList',
                    valueField: 'code',
                    textField: 'value',
                    dataParmName: 'detailModelList',
                    urlParms: {
                        dictId: 15
                    },
                    onSuccess: function () {
                        self.$form.Fields.fillValues({userType: user.userType});
                        self.$userType.parent().removeClass('l-text-focus')
                        self.$form.Fields.fillValues({martialStatus: user.martialStatus});
                    },
                    onSelected: function (value) {
                        if (value == 'Doctor')
                            $('#inp_major_div').show();
                        else
                            $('#inp_major_div').hide();
                    }
                });




                <%--this.$source.ligerComboBox({--%>
                    <%--url: '${contextRoot}/dict/searchDictEntryList',--%>
                    <%--valueField: 'code',--%>
                    <%--textField: 'value',--%>
                    <%--dataParmName: 'detailModelList',--%>
                    <%--urlParms: {--%>
                        <%--dictId: 26--%>
                    <%--},--%>
                    <%--onSuccess: function () {--%>
                        <%--self.$form.Fields.fillValues({sourceName:user.sourceName,});--%>
                    <%--},--%>

                <%--});--%>
                this.$form.attrScan();
                //debugger
                if(user){
                    this.$form.Fields.fillValues({
                        id: user.id,
                        loginCode: user.loginCode,
                        realName: user.realName,
                        idCardNo: user.idCardNo,
                        gender: user.gender,
                        email: user.email,
                        telephone: user.telephone,
//                        organization: [user.province, user.city, user.organization],
                        major: user.major,
                        publicKey: user.publicKey,
                        validTime: user.validTime,
                        startTime: user.startTime,
                        sourceName:user.sourceName,
                        fertilityStatus:user.fertilityStatus,
                        secondPhone:user.secondPhone,
                        birthday:user.birthday != null?user.birthday.substring(0,10):"",
                        micard:user.micard,
                        qq:user.qq,
                        ssid:user.ssid,
                        realnameFlag:user.realnameFlag,

                    });
                    if(user.role){
                        var roleArr = user.role.split(",") ;
                        for(var k in roleArr){
                            $("#"+ roleArr[k], trees.tree).find(".l-checkbox").click()
                        }
                    }
                    self.$publicKeyMessage.val(user.publicKey);
                    self.$publicKeyValidTime.html(user.validTime);
                    self.$publicKeyStartTime.html(user.startTime);
                    self.$idCardCopy.val(user.idCardNo);
                    self.$emailCopy.val(user.email);
                    this.$location.ligerComboBox({width: 240});
                    this.$location.addressDropdown({
                        tabsData: [
                            {
                                name: '省份',
                                code: 'id',
                                value: 'name',
                                url: '${contextRoot}/address/getParent',
                                params: {level: '1'}
                            },
                            {name: '城市', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'},
                            {name: '县区', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'},
                            {name: '街道', maxlength: 200}
                        ]
                    });
                    setTimeout(function(){
                        self.$form.Fields.location.setValue([user.provinceName, user.cityName, user.area_name, user.street]);
                    },500);

                    var pic = user.imgRemotePath;
                    if (!Util.isStrEmpty(pic)) {
                        self.$imageShow.html('<img src="${contextRoot}/user/showImage?timestamp='+(new Date()).valueOf()+'" class="f-w88 f-h110"></img>');
                    }
                }
                if ('${mode}' == 'view') {
                    this.$form.addClass("m-form-readonly");
                    this.$resetPassword.hide();
                    this.$publicKey.hide();
                    this.$updateUserDtn.hide();
                    this.$cancelBtn.hide();
                    this.$filePicker.hide();
                    this.$toolbar.hide();
                    this.$selectPublicKeyMessage.show();
                    this.$selectPublicKeyValidTime.show();
                    this.$selectPublicKeyStartTime.show();
                }
            },

            bindEvents: function () {
                var self = this;
                var validator = new jValidation.Validation(this.$form, {
                    immediate: true, onSubmit: false,
                    onElementValidateForAjax: function (elm) {
                        if (Util.isStrEquals($(elm).attr("id"), 'inp_userEmail')) {
                            var email = $("#inp_userEmail").val();
                            var emailCopy = self.$emailCopy.val();
                            if (emailCopy != null && emailCopy != '' && emailCopy == email) {
                                return true;
                            }
                            return checkDataSourceName('email', email, "该邮箱已被绑定，请确认。");
                        }
                        if (Util.isStrEquals($(elm).attr("id"), 'inp_idCard')) {
                            var idCard = $("#inp_idCard").val();
                            var idCardCopy = self.$idCardCopy.val();
                            if (idCardCopy != null && idCardCopy != '' && idCardCopy == idCard) {
                                return true;
                            }
                            return checkDataSourceName('id_card_no', idCard, "该身份证号已被注册，请确认。");
                        }
                    }
                });
                //唯一性验证身份证/邮箱
                function checkDataSourceName(type, searchNm, errorMsg) {
                    var result = new jValidation.ajax.Result();
                    var dataModel = $.DataModel.init();
                    dataModel.fetchRemote("${contextRoot}/user/existence", {
                        data: {existenceType: type, existenceNm: searchNm},
                        async: false,
                        success: function (data) {
                            if (data.successFlg) {
                                result.setResult(false);
                                result.setErrorMsg(errorMsg);
                            } else {
                                result.setResult(true);
                            }
                        }
                    });
                    return result;
                }

                //修改用户的点击事件
                this.$updateUserDtn.click(function () {
                    debugger
                    var userImgHtml = self.$imageShow.children().length;
                    if (validator.validate()) {
                        userModel = self.$form.Fields.getValues();
                        var location = self.$form.Fields.location.val()==""?"":JSON.parse(self.$location.val());
                        if(location!=""){
                            var keys = location.keys;
                            var names = location.names;
                            if(keys.length==1){//省
                                userModel.provinceId = parseInt(keys[0]);
                                userModel.provinceName = names[0];
                            }
                            if(keys.length==2){//省、市
                                userModel.provinceId = parseInt(keys[0]);
                                userModel.provinceName = names[0];
                                userModel.cityId = parseInt(keys[1]);
                                userModel.cityName = names[1];
                            }
                            if(keys.length==3){//省、市、县
                                userModel.provinceId =parseInt(keys[0]);
                                userModel.provinceName = names[0];
                                userModel.cityId = parseInt(keys[1]);
                                userModel.cityName = names[1];
                                userModel.area_id = parseInt(keys[2]);
                                userModel.area_name = names[2];
                            }
                            if(keys.length==4){//省、市、县、街道
                                userModel.provinceId = parseInt(keys[0]);
                                userModel.provinceName = names[0];
                                userModel.cityId = parseInt(keys[1]);
                                userModel.cityName = names[1];
                                userModel.area_id = parseInt(keys[2]);
                                userModel.area_name = names[2];
                                userModel.street = keys[3];
                            }
                        }
                        delete userModel.location;
						userModel.role = userInfo.roleIds(userModel.role);
//                        var organizationKeys = userModel.organization['keys'];
//                        userModel.organization = organizationKeys[2];
                        if (userImgHtml == 0) {
                            updateUser(userModel);
                        } else {
                            var upload = self.$uploader.instance;
                            var image = upload.getFiles().length;
                            if (image) {
                                upload.options.formData.userModelJsonData = encodeURIComponent(JSON.stringify(userModel));
                                upload.upload();
                                win.closeUserInfoDialog();
                                win.reloadMasterUpdateGrid();
                            } else {
                                updateUser(userModel);
                            }
                        }
                    } else {
                        return;
                    }
                });

                function updateUser(userModel) {
                    debugger
                    var userModelJsonData = JSON.stringify(userModel);
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/user/updateUser", {
                        data: {userModelJsonData: userModelJsonData},
                        success: function (data) {
                            if (data.successFlg) {
                                win.closeUserInfoDialog();
                                win.reloadMasterUpdateGrid();
                                $.Notice.success('修改成功');
                            } else {
                                $.Notice.error('修改失败');
                            }
                        }
                    })
                }

                //重置密码的点击事件
                this.$resetPassword.click(function () {
                    var userModelres = self.$form.Fields.getValues();
                    $.ligerDialog.confirm('确认重置密码？<br>如果是请点击确认按钮，否则请点击取消。', function (yes) {

                        if (yes) {
                            var dataModel = $.DataModel.init();
                            dataModel.updateRemote('${contextRoot}/user/resetPass', {
                                title: 'asd',
                                data: {userId: userModelres.id},
                                success: function (data) {
                                    if (data.successFlg)
                                    //重置当前用户密码，需重登
                                        if ((userModelres.id) == (data.obj)) {
                                            $.Notice.success('重置成功，请重新登录!', function () {
                                                location.href = '${contextRoot}/logout';
                                            });
                                        } else {
                                            $.Notice.success('重置成功!');
                                        }
                                    else
                                        $.Notice.error('重置失败!');
                                },
                                error: function () {
                                    $.Notice.error('重置失败!');
                                }
                            });
                        }
                    });
                });
                //公钥管理窗口点击事件

                this.$publicKey.click(function () {
                    publicKeyMsgDialog = $.ligerDialog.open({
                        title: '公钥管理',
                        width: 416,
                        height: 320,
                        target: self.$publicManage
                    });
                    $('#div_affirm_btn').click(function () {
                        publicKeyMsgDialog.close();
                    });
                    //分配公钥点击事件
                    self.$allotpublicKey.click(function () {
                        var code = self.$form.Fields.loginCode.getValue();
                        var dataModel = $.DataModel.init();
                        dataModel.createRemote('${contextRoot}/user/distributeKey', {
                            data: {loginCode: code},
                            success: function (data) {
                                var keyData = $.parseJSON(data.obj);
                                self.$publicKeyMessage.val(keyData.publicKey);
                                self.$publicKeyValidTime.html(keyData.validTime);
                                self.$publicKeyStartTime.html(keyData.startTime);
                                $.ligerDialog.alert('分配公钥成功');
                            }
                        });
                    });
                });

                this.$cancelBtn.click(function () {
                    win.closeUserInfoDialog();
                });
                this.$affirmBtn.click(function () {
                    publicKeyMsgDialog.close();
                })
                self.$userType.removeClass("l-text-focus")
            },

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
						if('${mode}' != 'view'){
							liHtml+='<li ><a href="javascript:void(0);" data-id="'+v.data.id+'"  data-index="'+v.data.treedataindex+'" >X</a>'+tit+'</li>';
						}else{
							liHtml+='<li >'+tit+'</li>';
						}
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