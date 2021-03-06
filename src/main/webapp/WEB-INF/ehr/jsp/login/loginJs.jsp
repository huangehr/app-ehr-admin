<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<script src="${staticRoot}/lib/plugin/captcha/idcode.js"></script>
<script>
    /**
     * Login -v1.0.0 (2015/7/29)
     *
     * @description 登录页面模块
     *
     * @author     yezehua
     *
     * @copyright   2015 www.yihu.com
     */

    (function ($, win) {

        $(function () {

            /* ************************** 变量定义 ******************************** */

            /**
             * 输入校验器。
             * @type {Object}
             */
            var jValidation = $.jValidation;
            /**
             * 登录模块。
             * @type {Object}
             */
            var login;

            var util = $.Util;

            /* ************************** 变量定义结束 **************************** */


            /* **************************** 函数定义 ****************************** */

            /**
             * 页面初始化。
             * @type {Function}
             */
            function pageInit() {

                if(top === window) {
                    login.init();
                    passwordInNum();
                } else {
                    top.postMessage({
                        type: 'pagereload'
                    },'*');
                    top.location.reload()
                }

            }

            /* ************************** 函数定义结束 **************************** */


            /* *************************** 模块初始化 ***************************** */

            /** @namespace */
            login = {
                /**
                 * 表单对象，以‘$’开头命名，表示它是一个jQuery包装的对象
                 * @type {jQuery}
                 */
                $loginForm: $('#form_login'),
                /**
                 * 登录按钮。
                 * @type {jQuery}
                 */
                $loginBtn: $('#btn_login'),
                /**
                 * 表单内的输入框对象集合。
                 * @type {jQuery}
                 */
                $inputs: $('.u-input', this.$loginForm),
                /**
                 * 验证码显示容器。
                 * @type {jQuery}
                 */
                $captchaWrapper: $('#div_captcha_wrapper'),
                /**
                 * 验证码输入框。
                 * @type {jQuery}
                 */
                $captchaCode: $('#inp_captcha_code'),
                /**
                 * 存储验证码的隐藏域。
                 * @type {jQuery}
                 */
                $captchaCodeHidden: $('#inp_captcha_hidden'),
                /**
                 * 表单初始化。
                 * @type {Function}
                 */
                init: function () {
                    // 表单验证码插件的初始化
                    $.idcode.setCode({
                        e: 'div_captcha_wrapper',
                        inputID: 'inp_captcha_code',
                        codeTip: '<div>看不清</div><div>换一张</div>'
                    });

                    // 事件绑定
                    this.bindEvents();

                    // 更新验证码隐藏域
                    this.$captchaCodeHidden.val($.idcode.getCode());

                    this.$loginForm.attrScan();
                    window.$loginForm = this.$loginForm;
                },
                /**
                 * 事件绑定。负责表单内所有对象的事件绑定。
                 * @type {Function}
                 */
                bindEvents: function () {
                    var self = this;

                    // 输入框失去焦点时，验证输入的合法性
                    this.$inputs.on('blur', function (e) {
                                self.validateInput(this);
                            })
                            // 通过回车键提交表单
                            .on('keydown', function (e) {
                                if (e.which == 13) {
                                    self.submit();
                                }
                            });

                    // 绑定登录按钮点击事件，点击时验证表单并提交登录请求
                    this.$loginBtn.on('click', function () {
                        self.submit();
                    });

                    // 绑定验证码点击更新事件，
                    this.$captchaWrapper.on('click', function () {
                        self.$captchaCodeHidden.val($.idcode.getCode());
                    });

                },
                /**
                 * 验证输入。
                 * @type {Function}
                 * @param {HTMLElement} el - 需要验证输入的HTML元素（DOM对象）
                 */
                validateInput: function (el) {
                    jValidation.Validation.validateElement(el);
                },
                /**
                 * 当点击登录按钮，表单验证通过后提交登录请求。
                 * @type {Function}
                 */
                submit: function () {
                    if (sessionStorage) {
                        sessionStorage.removeItem("treePid");
                        sessionStorage.removeItem("treeId");
                    }
                    var validator = new jValidation.Validation(this.$loginForm, {immediate: true, onSubmit: false});

                    if (validator.validate()) {
                        this.$loginForm.submit();
                    } else {
                        //验证码错误重输
                        this.$captchaCode.val("");
                        $("#div_error_msg").html("验证码错误");
                        $("#ehong-code-tip-ck").trigger('click');
                    }
                }
            };
            function passwordInNum() {
                if (!${successFlg}) {
                    var userName = $("#inp_user_name").val();
                    var inNum;
                    var dataModel = $.DataModel.init();
                    dataModel.updateRemote("${contextRoot}/login/userVerification", {
                        data: {userName: userName},
                        success: function (data) {
                            if (data.detailModelList.length<1){
                                $("<div class='f-tac s-c13'>用户名或密码错误</div>").replaceAll($("#div_error_msg"));
                                return;
                            }
                            if(!data.detailModelList[0].activated){
                                $("<div class='f-tac s-c13'>该账户已被锁定，请联系系统管理员重新生效！</div>").replaceAll($("#div_error_msg"));
                                return;
                            }
                            if (data.successFlg) {
                                inNum = util.isStrEmpty(localStorage.getItem(userName)) ? 0: localStorage.getItem(userName);
                                localStorage.setItem(userName, parseInt(inNum)+1);
                                if(data.detailModelList[0].activated&&localStorage.getItem(userName) >= 6){
                                    localStorage.setItem(userName,1);
                                }
                                $("<div class='f-tac s-c13' id='div_error_msg'>密码或用户名错误，您还有"+parseInt(5-localStorage.getItem(userName))+"次登入机会</div>").replaceAll($(".div-inp-num-msg"));
                                if(localStorage.getItem(userName) >= 5){
                                    dataModel.updateRemote("${contextRoot}/login/activityUser", {
                                        data: {userId: data.detailModelList[0].id, activated: 0},
                                        success: function (data) {
                                            $("<div class='f-tac s-c13'>该账户已被锁定，请联系系统管理员重新生效！</div>").replaceAll($("#div_error_msg"));
                                        }
                                    })
                                }
                            }
                        }
                    });
                }
            }
            /* ************************* 模块初始化结束 ************************** */


            /* *************************** 页面初始化 **************************** */

            pageInit();

            /* ************************* 页面初始化结束 ************************** */
        });

    })(jQuery, window);
    $(function () {
        $.extend({
            TipBox: function () {
                var CycLeft = 259 + $("#inp_user_name").offset().left;
                $("body").append('<style>.SD-tipbox\{ left:' + CycLeft + 'px !important\}</style>');
            }
        })
        $.TipBox();
        $(window).resize(function () {
            $.TipBox();
        })
        $("#inp_captcha_code").focus(function () {
//            $("#div_error_msg").html("")
            $(this).removeClass("required");
            $(".SD-tipbox").remove();
            $(this).removeClass("validation-failed")
        })
        $("#inp_captcha_code").hover(function () {
            $(this).addClass("required");
            if ($(this).val() == '') {
                $(".SD-tipbox .cntBox").each(function (i) {
                    if ($(this).html() == "验证码错误") {
                        $(this).html("该项为必输项，不允许为空")
                    }
                })
            }

        })
    })
</script>