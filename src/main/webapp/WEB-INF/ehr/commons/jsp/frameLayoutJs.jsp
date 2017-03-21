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

                //判断用户是否初始密码
                bo = Util.isStrEmpty(${defaultPassWord})?false:true;

                if(bo)
                    window.location.href = "${contextRoot}/user/initialChangePassword";

                this.$mainContent.ligerLayout({
                    // 左侧导航栏菜单宽度
                    leftWidth: 190,
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
                {id: 1,level:1, text: '<spring:message code="title.register.manage.center"/>'},
                </sec:authorize>

                // 1-1 - 机构管理
                <sec:authorize url="/organization/initial">
                {
                    id: 11,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.org.manage"/>',
                    url: '${contextRoot}/organization/initial'
                },
                </sec:authorize>

                // 1-2 - 人口管理
                <sec:authorize url="Ehr_Patients">
                {
                    id: 12,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.patient.manage"/>'
                },
                </sec:authorize>

                // 1-2-1 - 人口管理 - 基础信息管理
                <sec:authorize url="/patient/initial">
                {
                    id: 121,
                    pid: 12,
                    level:3,
                    text: '<spring:message code="title.patient.master.info"/>',
                    url: '${contextRoot}/patient/initial'
                },
                </sec:authorize>

                // 1-2-2 - 人口管理 - 档案关联审核
                <sec:authorize url="/correlation/initial">
                {
                    id: 122,
                    pid: 12,
                    level:3,
                    text: '<spring:message code="title.correlation.audit"/>',
                    url: '${contextRoot}/correlation/initial'
                },
                </sec:authorize>

                // 1-2-3 - 人口管理 - 身份认证
                <sec:authorize url="/authentication/initial">
                {
                    id: 123,
                    pid: 12,
                    level:3,
                    text: '<spring:message code="title.patient.apply"/>',
                    url: '${contextRoot}/authentication/initial'
                },
                </sec:authorize>

                // 1-3 - 医生管理
                <sec:authorize url="/doctor/initial">
                {
                    id: 13,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.doctor.manage"/>',
                    url: '${contextRoot}/doctor/initial'
                },
                </sec:authorize>

                // 1-4 - 资源上传管理
                <sec:authorize url="/portalResources/initial">
                {
                    id: 14,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.portal.resources"/>',
                    url: '${contextRoot}/portalResources/initial'
                },
                </sec:authorize>

                //{id: 14, pid: 1, text: '<spring:message code="title.knowledge.base"/>'},

                //2 - 标准规范中心
                <sec:authorize url="Ehr_Standard_Centre">
                {id: 2,level:1, text: '<spring:message code="title.data.manage.center"/>'},
                </sec:authorize>

                // 2-1 - 平台标准
                <sec:authorize url="Ehr_Platform_Std">
                {
                    id: 21,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.ehr.std"/>',
                },
                </sec:authorize>

                // 2-1-1 - 平台标准 - 标准来源
                <sec:authorize url="/standardsource/initial">
                {
                    id: 211,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.std.source"/>',
                    url: '${contextRoot}/standardsource/initial'
                },
                </sec:authorize>

                // 2-1-2 - 平台标准 - 标准字典
                <sec:authorize url="/cdadict/initial">
                {
                    id: 212,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.dict.manage"/>',
                    url: '${contextRoot}/cdadict/initial'
                },
                </sec:authorize>

                // 2-1-3 - 平台标准 - 标准数据集
                <sec:authorize url="/std/dataset/initial">
                {
                    id: 213,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.standard.dataSet"/>',
                    url: '${contextRoot}/std/dataset/initial'
                },
                </sec:authorize>

                // 2-1-4 - 平台标准 - CDA文档
                <sec:authorize url="/cda/initial">
                {
                    id: 214,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.CDA.manage"/>',
                    url: '${contextRoot}/cda/initial'
                },
                </sec:authorize>

                // 2-1-5 - 平台标准 - CDA类别
                <sec:authorize url="/cdatype/index">
                {
                    id: 215,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.CDA.type"/>',
                    url: '${contextRoot}/cdatype/index'
                },
                </sec:authorize>

                // 2-1-6 - 平台标准 - 标准版本管理
                <sec:authorize url="/cdaVersion/initial">
                {
                    id: 216,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.std.version.manage"/>',
                    url: '${contextRoot}/cdaVersion/initial'
                },
                </sec:authorize>

                // 2-1-7 - 平台标准 - 特殊字典
                <sec:authorize url="Ehr_Specialdict">
                {
                    id: 217,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.std.special.dict"/>'
                },
                </sec:authorize>

                // 2-1-7-1 - 平台标准 - 特殊字典 - 诊断字典
                <sec:authorize url="/specialdict/icd10/initial">
                {
                    id: 2171,
                    pid:217,
                    level:4,
                    text: '<spring:message code="title.std.icd10.dict"/>',
                    url: '${contextRoot}/specialdict/icd10/initial'
                },
                </sec:authorize>

                // 特殊字典 - 指标字典
                <sec:authorize url="/specialdict/indicator/initial">
                {
                    id: 2172,
                    pid: 217,
                    level:4,
                    text: '<spring:message code="title.std.indicator.dict"/>',
                    url: '${contextRoot}/specialdict/indicator/initial'
                },
                </sec:authorize>

                // 特殊字典 - 药品字典
                <sec:authorize url="/specialdict/drug/initial">
                {
                    id: 2173,
                    pid: 217,
                    level:4,
                    text: '<spring:message code="title.std.drug.dict"/>',
                    url: '${contextRoot}/specialdict/drug/initial'
                },
                </sec:authorize>

                // 特殊字典 - 疾病字典
                <sec:authorize url="/specialdict/hp/initial">
                {
                    id: 2174,
                    pid: 217,
                    level:4,
                    text: '<spring:message code="title.std.disease.dict"/>',
                    url: '${contextRoot}/specialdict/hp/initial'
                },
                </sec:authorize>

                // 2-2 - 第三方标准
                <sec:authorize url="/adapterorg/initial">
                {
                    id: 22,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.org.std.collection.manage"/>',
                    url: '${contextRoot}/adapterorg/initial'
                },
                </sec:authorize>

                // 2-3 - 标准适配
                <sec:authorize url="/adapter/initial">
                {
                    id: 23,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.adapter.manager"/>',
                    url: '${contextRoot}/adapter/initial'
                },
                </sec:authorize>

                // 2-4 - 模版管理
                <sec:authorize url="EHR_template_manager">
                {
                    id: 24,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.template.manage"/>',
                    url: '${contextRoot}/template/initial'
                },
                </sec:authorize>

                //3 - 开放中心
                <sec:authorize url="Ehr_Public_Centre">
                {id: 3,level:1, text: '<spring:message code="title.open.hub.manage.center"/>'},
                </sec:authorize>

                // 开放中心 - 接入应用
                <sec:authorize url="/app/initial">
                {
                    id: 31,
                    level:2,
                    pid: 3,
                    text: '<spring:message code="title.app.manage"/>',
                    url: '${contextRoot}/app/initial'
                },
                </sec:authorize>

                // 开放中心 - 平台应用
                <sec:authorize url="/app/platform/initial">
                {
                    id: 32,
                    level:2,
                    pid: 3,
                    text:  '<spring:message code="title.ehr.app.manage"/>',
                    url: '${contextRoot}/app/platform/initial'
                },
                </sec:authorize>

                // 开放中心 - API管理
                <sec:authorize url="/app/api/initial">
                {
                    id: 33,
                    level:2,
                    pid: 3,
                    text: '<spring:message code="title.api.manage"/>',
                    url:'${contextRoot}/app/api/initial'
                },
                </sec:authorize>

                // 开放中心 - 应用角色
                <sec:authorize url="/appRole/initial">
                {
                    id: 34,
                    level: 2,
                    pid: 3,
                    text: '<spring:message code="title.app.role"/>',
                    url: '${contextRoot}/appRole/initial'
                },
                </sec:authorize>

                // 开放中心 - 云门户管理
                <sec:authorize url="/portal/manager">
                {
                    id: 35,
                    pid: 3,
                    level:2,
                    text: '云门户管理',
                },
                </sec:authorize>

                // 云门户管理 - 通知公告管理
                <sec:authorize url="/portalNotice/initial">
                {
                    id: 351,
                    pid: 35,
                    level:2,
                    text: '<spring:message code="title.portal.notice"/>',
                    url: '${contextRoot}/portalNotice/initial'
                },
                </sec:authorize>

                //消息提醒
                <sec:authorize url="/messageRemind/initial">
                {
                    id: 352,
                    pid: 35,
                    level:2,
                    text: '<spring:message code="title.portal.messageRemind"/>',
                    url: '${contextRoot}/messageRemind/initial'
                },
                </sec:authorize>

                //资源配置
                <sec:authorize url="/portalSetting/initial">
                {
                    id: 352,
                    pid: 35,
                    level:2,
                    text: '<spring:message code="title.portal.portalSetting"/>',
                    url: '${contextRoot}/portalSetting/initial'
                },
                </sec:authorize>

                //4 - 安全管理中心
                <sec:authorize url="Ehr_Security_Centre">
                {id: 4, level:1, text: '<spring:message code="title.security.manage.center"/>'},
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

                //5 - 资源管理中心
                <sec:authorize url="Ehr_Resource_Centre">
                {id: 5, level:1, text: '<spring:message code="title.resource.manage.center"/>'},
                </sec:authorize>

                // 资源管理中心 - 资源标准
                <sec:authorize url="Ehr_Resource_Std">
                {
                    id: 51,
                    level:2,
                    pid: 5,
                    text: '<spring:message code="title.resource.standard"/>'
                },
                </sec:authorize>

                // 资源管理中心 - 资源标准 - 数据元
                <sec:authorize url="/resource/meta/initial">
                {
                    id: 511,
                    level:3,
                    pid: 51,
                    text: '<spring:message code="title.resource.standard.metaData"/>',
                    url: '${contextRoot}/resource/meta/initial'
                },
                </sec:authorize>

                // 资源管理中心 - 资源标准 - 字典
                <sec:authorize url="/resource/dict/initial">
                {
                    id: 512,
                    level:3,
                    pid: 51,
                    text: '<spring:message code="title.resource.standard.dict"/>',
                    url: '${contextRoot}/resource/dict/initial'
                },
                </sec:authorize>

                // 资源管理中心 - 资源标准 - 适配方案
                <sec:authorize url="/schemeAdapt/initial">
                {
                    id: 513,
                    level:3,
                    pid: 51,
                    text: '<spring:message code="title.resource.standard.adapter"/>',
                    url: '${contextRoot}/schemeAdapt/initial'
                },
                </sec:authorize>

                // 资源管理中心 - 资源分类
                <sec:authorize url="/rscategory/index">
                {
                    id: 52,
                    level:2,
                    pid: 5,
                    text: '<spring:message code="title.resource.catalog"/>',
                    url: '${contextRoot}/rscategory/index'
                },
                </sec:authorize>

                // 资源管理中心 - 资源注册
                <sec:authorize url="/resource/resourceManage/initial">
                {
                    id: 53,
                    level:2,
                    pid: 5,
                    text: '<spring:message code="title.resource.register"/>',
                    url: '${contextRoot}/resource/resourceManage/initial'
                },
                </sec:authorize>

                // 资源管理中心 - 资源浏览
                <sec:authorize url="/resource/resourceManage/initial">
                {
                    id: 54,
                    level:2,
                    pid: 5,
                    text: '<spring:message code="title.resource.view"/>',
                    url: '${contextRoot}/resource/resourceManage/initial'
                },
                </sec:authorize>

                // 资源管理中心 - 资源接口
                <sec:authorize url="/resource/resourceInterface/initial">
                {
                    id: 55,
                    level:2,
                    pid: 5,
                    text: '<spring:message code="title.resource.interface"/>',
                    url: '${contextRoot}/resource/resourceInterface/initial'
                },
                </sec:authorize>

                //6 - 运营中心
                <sec:authorize url="Ehr_Operating_Centre">
                {id: 6, level:1, text: '<spring:message code="title.operating.center"/>'},
                </sec:authorize>

                // 运营中心 - ESB管理
                <sec:authorize url="Ehr_Operating_Esb">
                {
                    id: 61,
                    level:2,
                    pid: 6,
                    text: '<spring:message code="title.esb.manage"/>'
                },
                </sec:authorize>

                // 运营中心 - ESB管理 - LOG管理
                <sec:authorize url="/hosLogs/initial">
                {
                    id: 611,
                    level:3,
                    pid: 61,
                    text: '<spring:message code="title.esb.log.upload"/>',
                    url: '${contextRoot}/hosLogs/initial'
                },
                </sec:authorize>

                // 运营中心 - ESB管理 - 系统版本管理
                <sec:authorize url="/esb/hosRelease/initial">
                {
                    id: 612,
                    level:3,
                    pid: 61,
                    text: '<spring:message code="title.esb.source.list"/>',
                    url: '${contextRoot}/esb/hosRelease/initial'
                },
                </sec:authorize>

                // 运营中心 - ESB管理 - 机构更新管理
                <sec:authorize url="/esb/installLog/initial">
                {
                    id: 613,
                    level:3,
                    pid: 61,
                    text: '<spring:message code="title.esb.source.org.update"/>',
                    url: '${contextRoot}/esb/installLog/initial'
                },
                </sec:authorize>

                // 运营中心 - ESB管理 - His穿透
                <sec:authorize url="/esb/sqlTask/initial">
                {
                    id: 614,
                    level:3,
                    pid: 61,
                    text: '<spring:message code="title.esb.his.search"/>',
                    url: '${contextRoot}/esb/sqlTask/initial'
                },
                </sec:authorize>

                // 运营中心 - ESB管理 - 补采任务配置
                <sec:authorize url="/esb/acqTask/initial">
                {
                    id: 615,
                    level:3,
                    pid: 61,
                    text: '<spring:message code="title.esb.task.recollect"/>',
                    url: '${contextRoot}/esb/acqTask/initial'
                },
                </sec:authorize>

                // 7 - 服务管理中心
                //{id: 7, text: '<spring:message code="title.server.manage.center"/>'},

                // 8 - 配置管理中心
                <sec:authorize url="Ehr_Setting_Centre">
                {id: 8,level:1,text: '<spring:message code="title.setting.manage.center"/>'},
                </sec:authorize>

                // 配置管理中心 - 系统字典
                <sec:authorize url="/dict/initial">
                {
                    id: 81,
                    pid: 8,
                    level:2,
                    text: '<spring:message code="title.sysDict.manage"/>',
                    url: '${contextRoot}/dict/initial'
                }
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
//            init: function () {
//                var self = this;
//                // 初始化树形菜单
//
//                //当浏览器刷新之后，展开刷新前点击的tree节点，
//                if (treePid) {
//                    //debugger;
//                    this.data[treePid].isExpand = true;
//                }
//                this.treeMenu = this.$tree.ligerTree({
//                    data: this.data,
//                    idFieldName: 'id',
//                    parentIDFieldName: 'pid',
//                    checkbox: false,
//                    treeLine: false,
//                    autoCheckboxEven: false,
//                    needCancel: false,
//                    btnClickToToggleOnly: false,
//                    slide: false,
//                    nodeDraggable: false,
//                    isExpand: false,
//                    parentIcon: null,
//                    adjustToWidth: true,
//                    onClick: function (obj) {
//                        var content = self.getBreadcrumbContent(obj.data);
//                        mainLayout.$breadcrumbContent.html(content);
//                        var dt = obj.data;
//                        var url = dt.url;
//                        var treedataindex = $(this.getParentTreeItem(obj.data.treedataindex)).attr("treedataindex") || "";
//                        //debugger;
//                        sessionStorage.setItem("treePid", treedataindex);//存储变量到SEssion
//                        sessionStorage.setItem("treeId", dt.id);//存储变量到SEssion
//                        if (url) {
//                            $("#contentPage").empty();
//                            $("#contentPage").load(url);
////                            window.location.href = url;//+ '?' + 'treePid=' + treedataindex + '&treeId=' + dt.id
//                        }
//                    }
//                });
//                //当浏览器刷新之后，高亮显示刷新前点击的tree节点，并且显示当前位置（面包屑）Util.getUrlQueryString("treeId")
//                $(".l-expandable-open", this.treeMenu).not($("#" + treeId).find(".l-expandable-open")).click();
//                if (treeId) {
//                    var treeData = this.treeMenu.getDataByID(treeId);
//                    var content = self.getBreadcrumbContent(treeData);
//                    mainLayout.$breadcrumbContent.html(content);
//                    $('.l-body', "#" + treeId).addClass("l-selected");
//                    $("#contentPage").empty();
//                    if (treeData.url)
//                        $("#contentPage").load(treeData.url);
//                }
//                // 初始化树形菜单后，缓存一级节点
//                this.$level1Nodes = $('li[outlinelevel="1"]', this.$tree);
//                // 树形导航菜单节点集
//                this.$treeNodes = $('li[outlinelevel="2"]', this.$tree);
//                // 更新一级菜单图标
//                this.updateLevel1Icons();
//            },
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
