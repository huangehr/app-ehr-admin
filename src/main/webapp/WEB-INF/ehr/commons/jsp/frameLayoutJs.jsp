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
            //navMenu.init();

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
                // 1 - 基础数据中心
                <sec:authorize url="Ehr_Master_Centre">
                {
                    id: 1,
                    level:1,
                    text: '<spring:message code="title.info_register.manage.center"/>'
                },
                </sec:authorize>

                // 1-1 - 居民管理
                <sec:authorize url="/organization/Initial">
                {
                    id: 11,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.patient.manage"/>',
                    url: '${contextRoot}/patient/initial'
                },
                </sec:authorize>

                // 1-1-1 - 基础信息维护
                <%--<sec:authorize url="/organization/Initial">
                {
                    id: 111,
                    pid: 11,
                    level:3,
                    text: '<spring:message code="title.patient.master.info"/>',
                    url: '${contextRoot}/patient/initial'
                },
                </sec:authorize>--%>

                // 1-1-2 -身份认证
                <%--<sec:authorize url="/deptMember/initialDeptMember">--%>
                <%--{--%>
                    <%--id: 112,--%>
                    <%--pid: 11,--%>
                    <%--level:3,--%>
                    <%--text: '<spring:message code="title.patient.apply"/>',--%>
                    <%--url: '${contextRoot}/authentication/initial'--%>
                <%--},--%>
                <%--</sec:authorize>--%>



                // 1-2 - 应用管理
                <sec:authorize url="Ehr_Patients">
                {
                    id: 12,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.app.manage"/>'
                },
                </sec:authorize>

                // 开放中心 - 接入应用
                <sec:authorize url="/app/initial">
                {
                    id: 121,
                    level:3,
                    pid: 12,
                    text: '<spring:message code="title.ehr.app.manage"/>',
                    url: '${contextRoot}/app/initial'
                },
                </sec:authorize>

                <%--// 开放中心 - 平台应用--%>
                <%--<sec:authorize url="/app/platform/initial">--%>
                <%--{--%>
                    <%--id: 122,--%>
                    <%--level:3,--%>
                    <%--pid: 12,--%>
                    <%--text:  '<spring:message code="title.ehr.app.manage"/>',--%>
                    <%--url: '${contextRoot}/app/platform/initial'--%>
                <%--},--%>
                <%--</sec:authorize>--%>

                <%--// 开放中心 - API管理--%>
                <%--<sec:authorize url="/app/api/initial">--%>
                <%--{--%>
                    <%--id: 123,--%>
                    <%--level:3,--%>
                    <%--pid: 12,--%>
                    <%--text: '<spring:message code="title.api.manage"/>',--%>
                    <%--url:'${contextRoot}/app/api/initial'--%>
                <%--},--%>
                <%--</sec:authorize>--%>

                // 开放中心 - 应用角色
                <sec:authorize url="/appRole/initial">
                {
                    id: 124,
                    level:3,
                    pid: 12,
                    text: '<spring:message code="title.app.role"/>',
                    url: '${contextRoot}/appRole/initial'
                },
                </sec:authorize>


                // 1-3 - 医疗卫生资源管理
                <sec:authorize  url="Ehr_Doctor_Source">
                {
                    id: 13,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.resource.manage.center"/>'
                },
                </sec:authorize>

                //  1-3-1   卫生人员管理
                <sec:authorize url="/doctor/initial">
                {
                    id: 131,
                    level:3,
                    pid: 13,
                    text: '<spring:message code="title.doctor.manage"/>',
                    url: '${contextRoot}/doctor/initial'
                },
                </sec:authorize>

                //  1-3-2  卫生机构管理
                <sec:authorize url="/organization/Initial">
                {
                    id: 132,
                    pid: 13,
                    level:3,
                    text: '<spring:message code="title.org.manage"/>',
                    url: '${contextRoot}/organization/initial'
                },
                </sec:authorize>

                // 1-3-3 - 机构管理 - 机构上下级机构
                <sec:authorize url="/initialUpAndDownOrg/initialUpAndDownOrg">
                {
                    id: 133,
                    pid: 13,
                    level:3,
                    text: '<spring:message code="title.org.upAndDownOrg"/>',
                    url: '${contextRoot}/upAndDownOrg/initialUpAndDownOrg'
                },
                </sec:authorize>

                // 1-4  数据资源管理
                <sec:authorize url="Ehr_Resource_Centre">
                {
                    id: 14,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.data.manage.center"/>'
                },
                </sec:authorize>

                // 1-4-1 数据元
                <sec:authorize url="/resource/meta/initial">
                {
                    id: 141,
                    level:3,
                    pid: 14,
                    text: '<spring:message code="title.resource.standard.metaData"/>',
                    url: '${contextRoot}/resource/meta/initial'
                },
                </sec:authorize>

                // 1-4-2 - 字典
                <sec:authorize url="/resource/dict/initial">
                {
                    id: 142,
                    level:3,
                    pid: 14,
                    text: '<spring:message code="title.resource.standard.dict"/>',
                    url: '${contextRoot}/resource/dict/initial'
                },
                </sec:authorize>

                //  1-4-3- 适配方案
                <sec:authorize url="/schemeAdapt/initial">
                {
                    id: 143,
                    level:3,
                    pid: 14,
                    text: '<spring:message code="title.resource.standard.adapter"/>',
                    url: '${contextRoot}/schemeAdapt/initial'
                },
                </sec:authorize>

                // 1-4-4 - 资源注册
                <sec:authorize url="/resource/resourceManage/initial">
                {
                    id: 144,
                    level:3,
                    pid: 14,
                    text: '<spring:message code="title.resource.register"/>',
                    url: '${contextRoot}/resource/resourceManage/initial'
                },
                </sec:authorize>

                // 1-4-5 - 资源浏览
                <sec:authorize url="/resource/resourceManage/initial">
                {
                    id: 145,
                    level:3,
                    pid: 14,
                    text: '<spring:message code="title.resource.view"/>',
                    url: '${contextRoot}/resource/resourceManage/initial'
                },
                </sec:authorize>

                // 1-4-6 - 资源接口
                <sec:authorize url="/resource/resourceInterface/initial">
                {
                    id: 146,
                    level:3,
                    pid: 14,
                    text: '<spring:message code="title.resource.interface"/>',
                    url: '${contextRoot}/resource/resourceInterface/initial'
                },
                </sec:authorize>

                // 1-4-7 - 资源分类
                <sec:authorize url="/rscategory/index">
                {
                    id: 147,
                    level:3,
                    pid: 14,
                    text: '<spring:message code="title.resource.catalog"/>',
                    url: '${contextRoot}/rscategory/index'
                },
                </sec:authorize>

                // 2 - 标准注册与管理
                <sec:authorize url="Ehr_Standard_Centre">
                {
                    id: 2,
                    level:1,
                    text: '<spring:message code="title.register.manage.center"/>'
                },
                </sec:authorize>

                // 2-1 - 平台标准 - 标准字典
                <sec:authorize url="/cdadict/initial">
                {
                    id: 21,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.dict.manage"/>',
                    url: '${contextRoot}/cdadict/initial'
                },
                </sec:authorize>

                // 2-2 - 平台标准 - 标准数据集
                <sec:authorize url="/std/dataset/initial">
                {
                    id: 22,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.standard.dataSet"/>',
                    url: '${contextRoot}/std/dataset/initial'
                },
                </sec:authorize>

                // 2-3 - 平台标准 - CDA文档
                <sec:authorize url="/cda/initial">
                {
                    id: 23,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.CDA.manage"/>',
                    url: '${contextRoot}/cda/initial'
                },
                </sec:authorize>

                // 2-4- 平台标准 - CDA类别
                <sec:authorize url="/cdatype/index">
                {
                    id: 24,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.CDA.type"/>',
                    url: '${contextRoot}/cdatype/index'
                },
                </sec:authorize>

                // 2-5- 平台标准 - 标准版本管理
                <sec:authorize url="/cdaVersion/initial">
                {
                    id: 25,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.std.version.manage"/>',
                    url: '${contextRoot}/cdaVersion/initial'
                },
                </sec:authorize>

                // 2-6 - 第三方标准
                <sec:authorize url="/adapterorg/initial">
                {
                    id: 26,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.org.std.collection.manage"/>',
                    url: '${contextRoot}/adapterorg/initial'
                },
                </sec:authorize>

                // 2-7- 标准适配
                <sec:authorize url="/adapter/initial">
                {
                    id: 27,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.adapter.manager"/>',
                    url: '${contextRoot}/adapter/initial'
                },
                </sec:authorize>

                // 2-8 - 模版管理
                <sec:authorize url="EHR_template_manager">
                {
                    id: 28,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.template.manage"/>',
                    url: '${contextRoot}/template/initial'
                },
                </sec:authorize>


                // 2-9- 平台标准 - 特殊字典
                <sec:authorize url="Ehr_Specialdict">
                {
                    id: 29,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.std.special.dict"/>'
                },
                </sec:authorize>

                // 2-9-1 - 平台标准 - 特殊字典 - 诊断字典
                <sec:authorize url="/specialdict/icd10/initial">
                {
                    id: 291,
                    pid:29,
                    level:3,
                    text: '<spring:message code="title.std.icd10.dict"/>',
                    url: '${contextRoot}/specialdict/icd10/initial'
                },
                </sec:authorize>

                // 特殊字典 - 指标字典
                <sec:authorize url="/specialdict/indicator/initial">
                {
                    id: 292,
                    pid:29,
                    level:3,
                    text: '<spring:message code="title.std.indicator.dict"/>',
                    url: '${contextRoot}/specialdict/indicator/initial'
                },
                </sec:authorize>

                // 特殊字典 - 药品字典
                <sec:authorize url="/specialdict/drug/initial">
                {
                    id: 293,
                    pid:29,
                    level:3,
                    text: '<spring:message code="title.std.drug.dict"/>',
                    url: '${contextRoot}/specialdict/drug/initial'
                },
                </sec:authorize>

                // 特殊字典 - 疾病字典
                <sec:authorize url="/specialdict/hp/initial">
                {
                    id: 294,
                    pid:29,
                    level:3,
                    text: '<spring:message code="title.std.disease.dict"/>',
                    url: '${contextRoot}/specialdict/hp/initial'
                },
                </sec:authorize>

                // 3- 全程健康档案管理   安全管理中心
                <sec:authorize url="Ehr_archive_manager">
                {
                    id: 3,
                    level:1,
                    text: '<spring:message code="title.health.manage.center"/>'
                },
                </sec:authorize>

                // 3-1 居民档案管理
                <sec:authorize url="userCards/archiveRelation/initial">
                {
                    id: 31,
                    pid: 3,
                    level:2,
                    text: '<spring:message code="title.patient.archiveRelation"/>',
                    url: '${contextRoot}/userCards/archiveRelation/initial'
                },
                </sec:authorize>

                // 3-2 居民档案申领审核
                <sec:authorize url="/correlation/initial">
                {
                    id: 32,
                    pid: 3,
                    level:2,
                    text: '<spring:message code="title.correlation.audit"/>',
                    url: '${contextRoot}/archive/apply/initial'
                },
                </sec:authorize>

                // 3-3- 就诊卡管理
                <sec:authorize url="/medicalCards/initialPageView">
                {
                    id: 33,
                    pid: 3,
                    level:2,
                    text: '<spring:message code="title.card.manage"/>',
                    url: '${contextRoot}/medicalCards/initialPageView'
                },
                </sec:authorize>

                // 3-4 就诊卡申领审核
                <sec:authorize url="/userCards/initial">
                {
                    id: 34,
                    pid: 3,
                    level:2,
                    text: '<spring:message code="title.card.medicalCardsAudit"/>',
                    url: '${contextRoot}/userCards/initial'
                },
                </sec:authorize>

                // 4- 信息安全和隐私管理   安全管理中心
                <sec:authorize url="Ehr_Security_Centre">
                {
                    id: 4,
                    level:1,
                    text: '<spring:message code="title.security.manage.center"/>'
                },
                </sec:authorize>

                // 安全管理中心 - 用户管理
                <sec:authorize url="/user/initial">
                {
                    id: 41,
                    pid: 4,
                    level:2,
                    text: '<spring:message code="title.user.manage"/>',
                    url: '${contextRoot}/user/initial'
                },
                </sec:authorize>

                // 安全管理中心 - 角色管理
                <sec:authorize url="/userRoles/initial">
                {
                    id: 42,
                    pid: 4,
                    level:2,
                    text:  '<spring:message code="title.role.manage"/>',
                    url: '${contextRoot}/userRoles/initial'
                },
                </sec:authorize>

                // 配置管理中心
                <sec:authorize url="Ehr_Setting_Centre">
                {
                    id: 5,
                    level:1,
                    text: '<spring:message code="title.setting.manage.center"/>'
                },
                </sec:authorize>

                // 配置管理中心 - 系统字典
                <sec:authorize url="/dict/initial">
                {
                    id: 51,
                    pid: 5,
                    level:2,
                    text: '<spring:message code="title.sysDict.manage"/>',
                    url: '${contextRoot}/dict/initial'
                },
                </sec:authorize>

                // 开放中心 - 云门户管理
                <sec:authorize url="/portal/manager">
                {
                    id: 52,
                    pid: 5,
                    level:2,
                    text: '云门户管理'
                },
                </sec:authorize>

                // 云门户管理 - 通知公告管理
                <sec:authorize url="/portalNotice/initial">
                {
                    id: 521,
                    pid: 52,
                    level:3,
                    text: '<spring:message code="title.portal.notice"/>',
                    url: '${contextRoot}/portalNotice/initial'
                },
                </sec:authorize>

                //消息提醒
                <sec:authorize url="/messageRemind/initialMessageRemind">
                {
                    id: 522,
                    pid: 52,
                    level:3,
                    text: '<spring:message code="title.portal.messageRemind"/>',
                    url: '${contextRoot}/messageRemind/initialMessageRemind'
                },
                </sec:authorize>

                // 1-4 - 资源上传管理
                <sec:authorize url="/portalResources/initial">
                {
                    id: 523,
                    pid: 52,
                    level: 3,
                    text: '<spring:message code="title.portal.resources"/>',
                    url: '${contextRoot}/portalResources/initial'
                },
                </sec:authorize>

                // 1-4 - 资源配置管理
                <sec:authorize url="/portalSetting/initial">
                {
                    id: 524,
                    pid: 52,
                    level: 3,
                    text: '<spring:message code="title.portal.portalSetting"/>',
                    url: '${contextRoot}/portalSetting/initial'
                },
                </sec:authorize>

                // 6-1 - 质量监控报告
                <sec:authorize url="Ehr_Master_Centre">
                {
                    id: 6,
                    level:1,
                    text: '<spring:message code="title.quality.control.management"/>'
                },
                </sec:authorize>

                // 6-1 - 趋势分析
                <sec:authorize url="Ehr_Patients">
                {
                    id: 61,
                    pid: 6,
                    level:2,
                    text: '<spring:message code="title.trend.analysis"/>',
                    url: '${contextRoot}/report/initial'
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