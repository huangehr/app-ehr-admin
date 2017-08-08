<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type="text/javascript">

    $(function () {

        /* ************************** 变量定义 ******************************** */

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
            mainLayout.init();
            $.MenuInit(".l-layout-left",navMenu)
            notice.init();
        }

        /* ************************** 函数定义结束 **************************** */

        /* *************************** 模块初始化 ***************************** */

        mainLayout = {
            // 页面主内容区
            $mainContent: $("#div_main_content"),
            // 面包屑导航栏
            $breadcrumbBar: $('#div_nav_breadcrumb_bar'),
            $breadcrumbContent: $('#span_nav_breadcrumb_content'),
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

        navMenu = {
            // 导航菜单数据源
            data: [
                // 1 - 基础信息管理
                <sec:authorize url="Ehr_Master_Centre">
                {
                    id: 1,
                    level:1,
                    text: '<spring:message code="title.master.info.center"/>'
                },
                </sec:authorize>

                // 1-2 应用信息
                <sec:authorize url="/app/initial">
                {
                    pid: 1,
                    level: 2,
                    id: 11,
                    text: '<spring:message code="title.app.manage"/>',
                    url: '${contextRoot}/app/initial'
                },
                </sec:authorize>

                //  1-3 卫生人员
                <sec:authorize url="/doctor/initial">
                {
                    pid: 1,
                    level: 2,
                    id: 12,
                    text: '<spring:message code="title.doctor.manage"/>',
                    url: '${contextRoot}/doctor/initial'
                },
                </sec:authorize>

                //  1-4 卫生机构
                <sec:authorize url="/ehr/organization/Initial">
                {
                    pid: 1,
                    level: 2,
                    id: 13,
                    text: '<spring:message code="title.org.manage"/>',
                    url: '${contextRoot}/organization/initial'
                },
                </sec:authorize>

                // 2 - 标准规范管理
                <sec:authorize url="Ehr_Standard_Centre">
                {
                    id: 2,
                    level: 1,
                    text: '<spring:message code="title.standard.info.center"/>'
                },
                </sec:authorize>

                // 2-1 平台标准
                <sec:authorize url="Ehr_Platform_Std">
                {
                    pid: 2,
                    level: 2,
                    id: 21,
                    text: '<spring:message code="title.ehr.std"/>',
                },
                </sec:authorize>

                // 2-1-1 平台标准 - 标准来源
                <sec:authorize url="/standardsource/initial">
                {
                    pid: 21,
                    level: 3,
                    id: 211,
                    text: '<spring:message code="title.std.source"/>',
                    url: '${contextRoot}/standardsource/initial'
                },
                </sec:authorize>

                // 2-1-2 平台标准 - 标准版本管理
                <sec:authorize url="/cdaVersion/initial">
                {
                    pid: 21,
                    level: 3,
                    id: 212,
                    text: '<spring:message code="title.std.version.manage"/>',
                    url: '${contextRoot}/cdaVersion/initial'
                },
                </sec:authorize>

                // 2-1-3 平台标准 - 标准字典
                <sec:authorize url="/cdadict/initial">
                {
                    pid: 21,
                    level: 3,
                    id: 213,
                    text: '<spring:message code="title.dict.manage"/>',
                    url: '${contextRoot}/cdadict/initial'
                },
                </sec:authorize>

                // 2-1-4 平台标准 - 标准数据集
                <sec:authorize url="/std/dataset/initial">
                {
                    pid: 21,
                    level:3,
                    id: 214,
                    text: '<spring:message code="title.standard.dataSet"/>',
                    url: '${contextRoot}/std/dataset/initial'
                },
                </sec:authorize>

                // 2-1-5 平台标准 - CDA类别
                <sec:authorize url="/cdatype/index">
                {
                    pid: 21,
                    level:3,
                    id: 215,
                    text: '<spring:message code="title.CDA.type"/>',
                    url: '${contextRoot}/cdatype/index'
                },
                </sec:authorize>

                // 2-1-6 平台标准 - CDA文档
                <sec:authorize url="/cda/initial">
                {
                    pid: 21,
                    level:3,
                    id: 216,
                    text: '<spring:message code="title.CDA.manage"/>',
                    url: '${contextRoot}/cda/initial'
                },
                </sec:authorize>

                // 2-2 特殊字典
                <sec:authorize url="Ehr_Specialdict">
                {
                    pid: 2,
                    level:2,
                    id: 22,
                    text: '<spring:message code="title.std.special.dict"/>'
                },
                </sec:authorize>

                // 2-2-1 特殊字典 - 诊断字典
                <sec:authorize url="/specialdict/icd10/initial">
                {
                    pid: 22,
                    level:3,
                    id: 221,
                    text: '<spring:message code="title.std.icd10.dict"/>',
                    url: '${contextRoot}/specialdict/icd10/initial'
                },
                </sec:authorize>

                // 2-2-2 特殊字典 - 指标字典
                <sec:authorize url="/specialdict/indicator/initial">
                {
                    pid: 22,
                    level:3,
                    id: 222,
                    text: '<spring:message code="title.std.indicator.dict"/>',
                    url: '${contextRoot}/specialdict/indicator/initial'
                },
                </sec:authorize>

                // 2-2-3 特殊字典 - 药品字典
                <sec:authorize url="/specialdict/drug/initial">
                {
                    pid: 22,
                    level:3,
                    id: 223,
                    text: '<spring:message code="title.std.drug.dict"/>',
                    url: '${contextRoot}/specialdict/drug/initial'
                },
                </sec:authorize>

                // 2-2-4 特殊字典 - 疾病字典
                <sec:authorize url="/specialdict/hp/initial">
                {
                    pid: 22,
                    level:3,
                    id: 224,
                    text: '<spring:message code="title.std.disease.dict"/>',
                    url: '${contextRoot}/specialdict/hp/initial'
                },
                </sec:authorize>

                // 3  数据资源管理
                <sec:authorize url="Ehr_Resource_Centre">
                {
                    id: 3,
                    level:1,
                    text: '<spring:message code="title.data.manage.center"/>'
                },
                </sec:authorize>

                // 3-1 数据元
                <sec:authorize url="/resource/meta/initial">
                {
                    pid: 3,
                    level:2,
                    id: 31,
                    text: '<spring:message code="title.resource.standard.metaData"/>',
                    url: '${contextRoot}/resource/meta/initial'
                },
                </sec:authorize>

                // 3-8 综合查询
                <sec:authorize url="/resourceBrowse/customQuery">
                {
                    pid: 3,
                    level:2,
                    id: 31,
                    text: '<spring:message code="title.resource.resourceBrowse.customQuery"/>',
                    url: '${contextRoot}/resourceBrowse/customQuery'
                },
                </sec:authorize>


                // 3-2 - 字典
                <sec:authorize url="/resource/dict/initial">
                {
                    pid: 3,
                    level:2,
                    id: 32,
                    text: '<spring:message code="title.resource.standard.dict"/>',
                    url: '${contextRoot}/resource/dict/initial'
                },
                </sec:authorize>

                //  3-3- 适配方案
                <sec:authorize url="/schemeAdapt/initial">
                {
                    pid: 3,
                    level:2,
                    id: 33,
                    text: '<spring:message code="title.resource.standard.adapter"/>',
                    url: '${contextRoot}/schemeAdapt/initial'
                },
                </sec:authorize>

                // 3-4 - 资源分类
                <sec:authorize url="/rscategory/index">
                {
                    pid: 3,
                    level:2,
                    id: 34,
                    text: '<spring:message code="title.resource.catalog"/>',
                    url: '${contextRoot}/rscategory/index'
                },
                </sec:authorize>

                // 3-5 - 资源注册
                <sec:authorize url="/resource/resourceManage/initial">
                {
                    pid: 3,
                    level:2,
                    id: 35,
                    text: '<spring:message code="title.resource.register"/>',
                    url: '${contextRoot}/resource/resourceManage/initial'
                },
                </sec:authorize>

                // 3-6 - 资源接口
                <sec:authorize url="/resource/resourceInterface/initial">
                {
                    pid: 3,
                    level:2,
                    id: 36,
                    text: '<spring:message code="title.resource.interface"/>',
                    url: '${contextRoot}/resource/resourceInterface/initial'
                },
                </sec:authorize>

                // 3-7 - 资源浏览
                <sec:authorize url="/resourceBrowse/browse">
                {
                    pid: 3,
                    level:2,
                    id: 37,
                    text: '<spring:message code="title.resource.browse"/>',
                    url: '${contextRoot}/resourceBrowse/browse'
                },
                </sec:authorize>

                // 4- 全程健康档案
                <sec:authorize url="Ehr_Archive_Manager">
                {
                    id: 4,
                    level:1,
                    text: '<spring:message code="title.health.manage.center"/>'
                },
                </sec:authorize>

                // 1-1 居民信息
                <sec:authorize url="/patient/Initial">
                {
                    pid: 4,
                    level:2,
                    id: 41,
                    text: '<spring:message code="title.patient.manage"/>',
                    url: '${contextRoot}/patient/initial'
                },
                </sec:authorize>

                <%--// 4-1 居民档案管理--%>
                <%--<sec:authorize url="userCards/archiveRelation/initial">--%>
                <%--{--%>
                    <%--pid: 4,--%>
                    <%--level:2,--%>
                    <%--id: 42,--%>
                    <%--text: '<spring:message code="title.patient.archiveRelation"/>',--%>
                    <%--url: '${contextRoot}/userCards/archiveRelation/initial'--%>
                <%--},--%>
                <%--</sec:authorize>--%>

                // 4-2 居民档案申领审核
                <sec:authorize url="/archive/apply/initial">
                {
                    pid: 4,
                    level:2,
                    id: 43,
                    text: '<spring:message code="title.correlation.audit"/>',
                    url: '${contextRoot}/archive/apply/initial'
                },
                </sec:authorize>

                <%--// 4-3- 就诊卡管理--%>
                <%--<sec:authorize url="/medicalCards/initialPageView">--%>
                <%--{--%>
                    <%--pid: 4,--%>
                    <%--level:2,--%>
                    <%--id: 44,--%>
                    <%--text: '<spring:message code="title.card.manage"/>',--%>
                    <%--url: '${contextRoot}/medicalCards/initialPageView'--%>
                <%--},--%>
                <%--</sec:authorize>--%>

                // 4-4 就诊卡申领审核
                <sec:authorize url="/userCards/initial">
                {
                    pid: 4,
                    level:2,
                    id: 45,
                    text: '<spring:message code="title.card.medicalCardsAudit"/>',
                    url: '${contextRoot}/userCards/initial'
                },
                </sec:authorize>
                // 2-5 - 模版管理
                <sec:authorize url="/template/initial">
                {
                    pid: 4,
                    level:2,
                    id: 46,
                    text: '<spring:message code="title.template.manage"/>',
                    url: '${contextRoot}/template/initial'
                },
                </sec:authorize>

                // 5 - 质量监控报告
                <sec:authorize url="Ehr_Data_Centre">
                {
                    id: 5,
                    level:1,
                    text: '<spring:message code="title.quality.control.management"/>'
                },
                </sec:authorize>
                // 5-3 - 指标管理
                <sec:authorize url="/zhibiao/initial">
                {
                    pid: 5,
                    level: 2,
                    id: 51,
                    text: '<spring:message code="title.index.management"/>',
                    url: '${contextRoot}/zhibiao/initial'
                },
                </sec:authorize>

                //  5-2 指标分类管理
                <sec:authorize url="/health/initial">
                {
                    pid: 5,
                    level: 2,
                    id: 52,
                    text: '<spring:message code="title.health.manage"/>',
                    url: '${contextRoot}/health/initial'
                },
                </sec:authorize>

                // 5-4 - 指标配置管理
                <sec:authorize url="/zhibiaoconfig/initial">
                {
                    pid: 5,
                    level: 2,
                    id: 54,
                    text: '<spring:message code="title.index.config.management"/>',
                    url: '${contextRoot}/zhibiaoconfig/initial'
                },
                </sec:authorize>

                // 5-5 - 趋势分析
                <%--<sec:authorize url="Ehr_Master_Centre">
                {
                    pid: 5,
                    level: 2,
                    id: 55,
                    text: '<spring:message code="title.trend.analysis"/>',
                    url: '${contextRoot}/report/initial'
                },
                </sec:authorize>--%>

                // 6- 信息安全管理
                <sec:authorize url="Ehr_Security_Centre">
                {
                    id: 6,
                    level:1,
                    text: '<spring:message code="title.security.manage.center"/>'
                },
                </sec:authorize>

                // 6-1 安全管理中心 - 用户管理
                <sec:authorize url="/user/initial">
                {
                    pid: 6,
                    level: 2,
                    id: 61,
                    text: '<spring:message code="title.user.manage"/>',
                    url: '${contextRoot}/user/initial'
                },
                </sec:authorize>

                // 6-2 -身份认证
                <%--<sec:authorize url="/authentication/initial">
                {
                    pid: 6,
                    level: 2,
                    id: 62,
                    text: '<spring:message code="title.patient.apply"/>',
                    url: '${contextRoot}/authentication/initial'
                },
                </sec:authorize>--%>

                // 6-3 安全管理中心 - 角色管理
                <sec:authorize url="/userRoles/initial">
                {
                    pid: 6,
                    level: 2,
                    id: 63,
                    text:  '<spring:message code="title.role.manage"/>',
                    url: '${contextRoot}/userRoles/initial'
                },
                </sec:authorize>

                // 6-4 安全管理中心 - 应用角色管理
                <sec:authorize url="/appRole/initial">
                {
                    pid: 6,
                    level: 2,
                    id: 64,
                    text: '<spring:message code="title.app.role"/>',
                    url: '${contextRoot}/appRole/initial'
                },
                </sec:authorize>

                // 6-5 安全管理中心 - 机构数据授权
                <sec:authorize url="/organization/organizationGrant">
                {
                    pid: 6,
                    level: 2,
                    id: 65,
                    text: '<spring:message code="title.org.data.auth"/>',
                    url: '${contextRoot}/organization/organizationGrant'
                },
                </sec:authorize>

                // 6-6 安全管理中心 - 日志管理
                <sec:authorize url="/logManager/initial">
                {
                    pid: 6,
                    level: 2,
                    id: 66,
                    text:  '<spring:message code="title.log.manage"/>',
                    url: '${contextRoot}/logManager/initial'
                },
                </sec:authorize>

                // 7 配置管理中心
                <sec:authorize url="Ehr_Setting_Centre">
                {
                    id: 7,
                    level:1,
                    text: '<spring:message code="title.setting.manage.center"/>'
                },
                </sec:authorize>

                // 7-1 配置管理中心 - 系统字典
                <sec:authorize url="/dict/initial">
                {
                    pid: 7,
                    level: 2,
                    id: 71,
                    text: '<spring:message code="title.sysDict.manage"/>',
                    url: '${contextRoot}/dict/initial'
                },
                </sec:authorize>

                // 7-2 开放中心 - 云门户管理
                <sec:authorize url="Ehr_Setting_Portal">
                {
                    pid: 7,
                    level: 2,
                    id: 72,
                    text:  '<spring:message code="title.portal.homepage.setting"/>'
                },
                </sec:authorize>

                // 7-2-1 云门户管理 - 通知公告管理
                <sec:authorize url="/portalNotice/initial">
                {
                    pid: 72,
                    level: 3,
                    id: 721,
                    text: '<spring:message code="title.portal.notice"/>',
                    url: '${contextRoot}/portalNotice/initial'
                },
                </sec:authorize>

                //7-2-2 消息提醒
                <sec:authorize url="/messageRemind/initialMessageRemind">
                {
                    pid: 72,
                    level: 3,
                    id: 722,
                    text: '<spring:message code="title.portal.messageRemind"/>',
                    url: '${contextRoot}/messageRemind/initialMessageRemind'
                },
                </sec:authorize>

                // 7-2-3 资源上传管理
                <sec:authorize url="/portalResources/initial">
                {
                    pid: 72,
                    level: 3,
                    id: 723,
                    text: '<spring:message code="title.portal.resources"/>',
                    url: '${contextRoot}/portalResources/initial'
                },
                </sec:authorize>

                // 7-2-4 资源配置管理
                <sec:authorize url="/portalSetting/initial">
                {
                    pid: 72,
                    level: 3,
                    id: 724,
                    text: '<spring:message code="title.portal.portalSetting"/>',
                    url: '${contextRoot}/portalSetting/initial'
                },
                </sec:authorize>
            ],

            // 一级菜单图标
            level1Icons: ["icon_Reg.png", "icon_adm.png", "icon_adm.png", "icon_adm.png", "icon_adm.png", "icon_adm.png", "icon_adm.png"],
            $tree: $('#ul_tree'),
            treeMenu: null,
            // 树形导航菜单一级子节点集
            $level1Nodes: [],
            // 树形导航菜单节点集
            $treeNodes: $('li[outlinelevel]', this.$tree),
            // 更新一级菜单图标
            updateLevel1Icons: function () {
                var self = this;
                this.$level1Nodes.each(function (i) {
                    $('>.l-body .l-box', this).css({
                        background: 'url(${staticRoot}/images/' + self.level1Icons[i] + ') no-repeat 7px 12px'
                    });
                });
            },
            getBreadcrumbContent: function (nodeData) {
                var self = this;
                // 存放从一级菜单自当前菜单的导航菜单标题
                var titles = [];
                // 当前节点的父节点ID
                var pid = nodeData.pid;
                // 往前插入当前节点的节点文本
                titles.unshift(nodeData.text);
                while (pid > 0) {
                    var parentNodeData = self.treeMenu.getDataByID(pid);
                    titles.unshift(parentNodeData.text);
                    pid = parentNodeData.pid;
                }

                return titles.join(' > ');
            },
            // 绑定事件
            bindEvents: function () {

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

        /* ************************* 页面初始化结束 ************************** */
    });
</script>