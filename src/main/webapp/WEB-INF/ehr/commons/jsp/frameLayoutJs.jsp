<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="${staticRoot}/lib/contabs/contabs.min.js"></script>
<script src="${staticRoot}/lib/contabs/showTabs.js"></script>
<script src="${contextRoot}/develop/source/toolBar.js"></script>

<script type="text/javascript">
    $(function () {
        var menuId = '${menuId}';
        var sta = 0;
        /* ************************** 变量定义 ******************************** */
        window.addEventListener("message", function (e) {
            switch (e.data.type) {
                case 'fullScreen':
                    if (sta == 0) {
                        $('.J_iframe').addClass('ifr_fixed');
                    } else {
                        $('.J_iframe').removeClass('ifr_fixed');
                    }
                    sta = sta == 0 ? 1 : 0;
                    break;
            }
            window.parent.postMessage(e.data, '*');
        }, true);
        window.GlobalEventBus = new Vue();
        var menuData = ${menuData};
        if (menuId != '') {
            menuData.push({
                MenuId: menuId
            });
        }
        // Util工具类
        var Util = $.Util;

        // 主布局模块
        var mainLayout = null;

        // 导航菜单模块
        var navMenu = null;

        // 消息通知栏模块
        var notice = null;

        //登入成功后，将输入次数过多的错误密码清除
        sessionStorage.setItem("logined", "true");
        sessionStorage.removeItem("errorPassWord");
        localStorage.removeItem('${current_user.loginCode}');

        //Pid 和Id 用于浏览器刷新之后，菜单导航不改变
        var treePid = sessionStorage.getItem("treePid");

        var treeId = sessionStorage.getItem("treeId");

        var bo = false

        /* ************************** 变量定义结束 **************************** */

        /* *************************** 函数定义 ******************************* */
        /**
         * 页面初始化。
         * @type {Function}
         */
        function pageInit() {
//            getDictSetting()
            mainLayout.init();
            $.MenuInit(".l-layout-left",menuData)
            notice.init();
        }

        function getDictSetting(){
            debugger
            $.ajax({
                type: "GET",
                url: "${contextRoot}/login/getLogoByDictIdAndEntry",
                data: {"dictId":125,"code":"appAdminLogo"},
                dataType: "json",
                success: function(data) {
                    $(".m-logo").css("background",'url(' + data.detailModelList[0].path + ')');
                }
            });
        }
        
        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */

        mainLayout = {
            // 页面主内容区
            $mainContent: $("#div_main_content"),
            // 面包屑导航栏
            $breadcrumbBar: $('#div_nav_breadcrumb_bar'),
            $breadcrumbContent: $('#span_nav_breadcrumb_content'),
//            $contentPage: $("#contentPage"),
            init: function () {
                //判断是否内嵌登录

                var hash = window.location.hash;
                if(hash.indexOf("#signin")>=0)
                {
                    $("#div_top").hide();
                }
                //判断用户是否初始密码
                bo = Util.isStrEmpty(${defaultPassWord})?false:true;

                if(bo)
                    window.location.href = "${contextRoot}/user/initialChangePassword";

                this.$mainContent.ligerLayout({
                    // 左侧导航栏菜单宽度
                    leftWidth: 199,
                    // 不允许菜单向左收缩
                    allowLeftCollapse: false
                });
                this.$breadcrumbBar.show();
            }
        };

        notice = {
            $container: null,
            $msgContent: null,
            $msgControlBar: null,
            // 消息类型样式容器
            $notyType: null,
            $notyText: null,
            init: function () {
                this.$container = $('#div_notice_container');
                this.$msgContent = $('.msgContent', this.$container);
                this.$msgControlBar = $('.messageControlBar', this.$container);
                this.$notyType = $('.u-notice', this.$container);
                this.$notyText = $('.noty_text', this.$msgContent);

                this.bindEvents();
            },
            changeStatus: function (type) {
                if (Util.isStrEqualsIgnorecase("success", type)) {
                    this.$notyType.removeClass('error').addClass('success');
                } else if (Util.isStrEqualsIgnorecase("error", type)) {
                    this.$notyType.removeClass('success').addClass('error');
                }
            },
            showTopNoticeBar: function (args) {
                if (!args || !args.type || !args.msg) return;

                this.changeStatus(args.type);

                this.$notyText.html(args.msg);
                this.$msgContent.show();
                this.$container.show();

                var self = this;
                if (args.autoHide !== false) {
                    setTimeout(function () {
                        self.$msgContent.hide();
                    }, 3000);
                }
            },
            hideTopNoticeBar: function (args) {
                setTimeout(function () {
                    self.$msgContent.hide();
                }, args.delayTime || 0);
            },
            bindEvents: function () {
                var self = this;
                this.$msgControlBar.on('click', function () {
                    self.$msgContent.show();
                    setTimeout(function () {
                        self.$msgContent.hide();
                    }, 3000);
                });

                $.subscribe("top:notice:open", function (event, args) {
                    //self.showTopNoticeBar({type:'success', msg:'成功'});
                    self.showTopNoticeBar(args);
                });
                $.subscribe("top:notice:close", function (event, args) {
                    self.hideTopNoticeBar(args);
                });
            }
        };
        /* ************************* 模块初始化结束 ************************** */
        /* *************************** 页面初始化 **************************** */

        pageInit();
        window._LIGERDIALOG = $.ligerDialog;
        window._OPENDIALOG = function (url, title, width, height, parms, opts) {
            return openDialog(url, title, width, height, parms, opts)
        };
        window._UNIQDEL = function (gtGrid, findFunc, url, ids, code, idField, opration, warnMsg) {
            uniqDel(gtGrid, findFunc, url, ids, code, idField, opration, warnMsg);
        }
        /* ************************* 页面初始化结束 ************************** */
    });
</script>