<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script type="text/javascript">

    (function ($, win) {
        /* ************************** 变量定义 ******************************** */
        var Util = $.Util;
        var appInfoForm = null;
        // 表单校验工具类
        var jValidation = $.jValidation;
		var catalogDictId = 1;
		var statusDictId = 2;
        var sourceTypeDictId = 38;
        var manageTypeDictId = 94;
        var app = {};
		/* *************************** 函数定义 ******************************* */
        function pageInit() {
            appInfoForm.init();
        }
        /* *************************** 模块初始化 ***************************** */
        var trees;
        appInfoForm = {
			$form: $("#div_app_info_form"),
			$name: $("#inp_app_name"),
            $sourceType: $("#inp_source_type"),
            $code: $("#inp_app_code"),
			$orgCode:$('#inp_org_code'),
			$catalog: $("#inp_dialog_catalog"),
			$status: $("#inp_dialog_status"),
			$tags: $("#inp_tags"),
			$appId: $("#inp_app_id"),
			$secret: $("#inp_app_secret"),
			$url: $("#inp_url"),
			$outUrl: $("#inp_out_url"),
			$manageType: $("#inp_dialog_manageType"),
            $doctorManageType: $("#inp_doctorManageType"),
			$description: $("#inp_description"),
			$btnSave: $("#btn_save"),
			$btnCancel: $("#btn_cancel"),
            $jryycyc:$("#jryycyc"),//cyctodo
            $icon:$("#inp_app_icon"),
            $inpFileIcon:$("#inp_file_icon"),
            $releaseFlag: $('input[name="releaseFlag"]', this.$form),
            init: function () {
                this.cycToDo()//复制完记得删掉阿亮
                this.initForm();
                this.bindEvents();
            },
            initForm: function () {
                this.$name.ligerTextBox({width:240});
				this.initDDL(catalogDictId, this.$catalog);
				this.initDDL(statusDictId, this.$status);
                this.initDDL(sourceTypeDictId, this.$sourceType);
                this.initDDL(manageTypeDictId, this.$manageType);

				this.$orgCode.customCombo('${contextRoot}/organization/orgCodes',{filters: "activityFlag=1;"})
                this.$tags.ligerTextBox({width:240});
				this.$code.ligerTextBox({width:240});

				this.$icon.ligerTextBox({width:190});
                this.$releaseFlag.ligerRadio();
				this.$appId.ligerTextBox({width:240});
				this.$secret.ligerTextBox({width:240});
				this.$url.ligerTextBox({width:240});
				this.$outUrl.ligerTextBox({width:240});
                this.$description.ligerTextBox({width:240, height: 50 });
                var mode = '${mode}';
				if(mode != 'view'){
					$(".my-footer").show();
				}
				if(mode == 'view'){
					appInfoForm.$form.addClass('m-form-readonly');
                    $('#div_app_info_form textarea').attr("disabled","disabled");
                    $(".m-form-control .l-text-trigger-cancel").remove();
					$("#btn_save").hide();
					$("#btn_cancel").hide();
                 //$("input,select", this.$form).prop('disabled', false);
				}
                this.$form.attrScan();
                debugger
                if(mode !='new'){
                    app = ${model};
                    this.$form.Fields.fillValues({
						sourceType: app.sourceType,
                        name:app.name,
                        icon:app.icon,
                        releaseFlag:app.releaseFlag+'',
                        catalog: app.catalog,
                        status:app.status,
                        tags:app.tags,
                        id:app.id,
                        secret:app.secret,
                        url:app.url,
                        outUrl:app.outUrl,
                        description:app.description,
                        code: app.code,
                        manageType: app.manageType,
                        doctorManageType:app.doctorManageType
                    });
					$("#inp_org_code").ligerGetComboBoxManager().setValue(app.org);
					$("#inp_org_code").ligerGetComboBoxManager().setText(app.orgName);
                    if(app.roleJson){
                        var roleArr = eval('('+ app.roleJson +')');
                        for(var k in roleArr){
                            $("#"+ k, trees.tree).find(".l-checkbox").click()
                        }
                        if(mode=='view')
                            $('.listree a').hide();
                    }
                }
                this.$form.show();
            },
            initDDL: function (dictId, target) {
                target.ligerComboBox({
                    url: "${contextRoot}/dict/searchDictEntryList",
                    dataParmName: 'detailModelList',
                    urlParms: {dictId: dictId},
                    valueField: 'code',
                    textField: 'value'
                });
            },
            bindEvents: function () {
                var self = this;
                $(".l-text-wrapper").on("click",function(){//解决样式不兼容问题
                   if($(this).find("#jryycyc").length>0){
                        $(".l-box-select-inner").css("height","240px");
                    }else{
                        $(".l-box-select-inner").css("height","auto");
                    }
                });
                var validator =  new jValidation.Validation(this.$form, {immediate:true,onSubmit:false,
                    onElementValidateForAjax:function(elm){
                        var field = $(elm).attr('id');
                        var val = $('#' + field).val();

                        if(field=='inp_app_code' && val!=app.code){
                            return uniqValid("${contextRoot}/app/platform/existence", "code="+val+" g1;sourceType=0", "该接入应用代码已存在！");
                        }else if(field=='jryycyc'){
                            var result = new $.jValidation.ajax.Result();
                            if(!val || val.replace(/;/g, "")==""){
                                result.setResult(false);
                                result.setErrorMsg("该项为必填项！");
                            }else{
                                result.setResult(true);
                            }
                            return result;
                        }
                    }
                });
                this.$btnSave.click(function () {
                    debugger
                    if(validator.validate()){
                        var wait = $.ligerDialog.waitting('正在保存中,请稍候...');
                        var role = '';
                        var roleDom = $(".listree li a");
                        $.each(roleDom, function (i, v) {
                            role += ',' + $(v).attr('data-id');
                        })
                        role = role.length>0? role.substring(1) : role;
                        if('${mode}' == 'new'){
                            var values = self.$form.Fields.getValues();
                            values.role = role;
                            var dataModel = $.DataModel.init();
                            dataModel.updateRemote("${contextRoot}/app/createApp",{data: $.extend({}, values),
                                success: function(data) {
                                    wait.close();
                                    if (data.successFlg) {
                                        $.Notice.success('新增成功！');
                                        closeDialog();
                                    } else {
                                        $.Notice.error(data.errorMsg);
                                    }
                                }});
                        }else{
                            var values = self.$form.Fields.getValues();
                            values.role = role;
                            var dataModel = $.DataModel.init();
                            dataModel.updateRemote("${contextRoot}/app/updateApp",{data: $.extend({}, values),
                                success: function(data) {
                                    wait.close();
                                    if (data.successFlg) {
                                        $.Notice.success('保存成功！');
                                       closeDialog(function () {
                                        });
                                    } else {
                                        $.Notice.error(data.errorMsg);
                                    }
                                }});
                        }
                    }else{
                        return;
                    }
                });

                this.$btnCancel.click(function () {
					win.closeDialog();
                });

                //change事件
                this.$inpFileIcon.on( 'change', function () {
                    var url = '${contextRoot}/app/appIconFileUpload';
                    self.$icon.val(doUpload(url));
                });

                function doUpload(url) {
                    var formData = new FormData($( "#uploadForm" )[0]);
                    var fileUrl;
                    $.ajax({
                        url: url ,
                        type: 'POST',
                        data: formData,
                        async: false,
                        cache: false,
                        contentType: false,
                        processData: false,
                        success: function (returndata) {
                            if(returndata != "fail"){
//                                alert("上传成功");
                                $.Notice.success('上传成功');
                                fileUrl = returndata;
                            }else{
//                                alert("上传失败");
                                $.Notice.error('上传失败');
                            }
                        },
                        error: function (returndata) {
//                            alert("上传失败");
                            $.Notice.error('上传失败');
                        }
                    });
                    return fileUrl;
                };
            },
            cycToDo:function(){
                var treeData;
                $.ajax({
                    dataType: 'json',
                    async: false,
                    url: '${contextRoot}/app/roles/tree',
                    success: function (data) {
                        treeData = data.detailModelList;
                    }
                })
                var self=this;
                trees=self.$jryycyc.ligerComboBox({
                    cancelable: false,
                    width : 240,
                    selectBoxWidth: 238,
                    selectBoxHeight: 500, textField: 'name', treeLeafOnly: false,
                    tree: {
                        data: treeData, idFieldName:'id', textFieldName: 'name', onClick:function(e){
                            $('#jryycyc').blur();
                            self.listTree(trees);
                    }},
                    onAfterShowData: function () {
                        $('#jryycyc').width(216);
                    }
                })

                function removeSclBox(){
                    $('.l-box-select-inner.mCustomScrollbar',this.tree).height(240);
                    setTimeout(function(){
                        $(trees.tree).prev(".mCustomScrollBox").hide();
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
                    if((v.data.children==undefined || v.data.children.length<=0) &&  v.data.type!=0){
                        var parentText = $(trees.treeManager.getParentTreeItem( trees.treeManager.getNodeDom(v))).find('.l-body:first').find('span').html();
                        tit = parentText+":"+v.data.name
                        liHtml+='<li ><a href="javascript:void(0);" data-id="'+v.data.id+'"  data-index="'+v.data.treedataindex+'" >X</a>'+tit+'</li>';
                    }
                })
                if(obj.find(".listree").length==0){
                    obj.append('<div class="listree"></div>')
                }
                $(".listree").html(liHtml);

            },listTreeClick:function(trees){
                $("body").delegate(".listree a","click",function(){
                    $("li#"+$(this).attr("data-id"), trees.tree).find(".l-checkbox").click()
                })//删除操作
            }
        };

        /* *************************** 页面初始化 **************************** */
        pageInit();

    })(jQuery, window);
</script>