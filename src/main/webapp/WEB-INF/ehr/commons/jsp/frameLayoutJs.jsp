<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

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
                {id: 1,level:1, text: '<spring:message code="title.register.manage.center"/>'},
                {
                    id: 11,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.user.manage"/>',
                    url: '${contextRoot}/user/initial'
                },
				<%--{--%>
					<%--id: 111,--%>
					<%--pid: 11,--%>
					<%--level:3,--%>
					<%--text: '用户角色管理',--%>
					<%--url: '${contextRoot}/userRoles/initial'--%>
				<%--},--%>
                {
                    id: 12,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.org.manage"/>',
                    url: '${contextRoot}/organization/initial'
                },
                {
                    id: 13,
                    pid: 1,
                    level:2,
                    text: '<spring:message code="title.patient.manage"/>',
                    url: '${contextRoot}/patient/initial'
                },
                //{id: 14, pid: 1, text: '<spring:message code="title.knowledge.base"/>'},

                //2 - 标准规范中心
                {id: 2,level:1, text: '<spring:message code="title.data.manage.center"/>'},
                {
                    id: 21,
                    pid: 2,
                    level:2,
                    text: '平台标准'
                },
                {
                    id: 211,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.std.source"/>',
                    url: '${contextRoot}/standardsource/initial'
                },
                {
                    id: 212,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.dict.manage"/>',
                    url: '${contextRoot}/cdadict/initial'
                },
                {
                    id: 213,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.standard.dataSet"/>',
                    url: '${contextRoot}/std/dataset/initial'
                },
                {
                    id: 214,
                    pid: 21,
                    level:3,
                    text: '<spring:message code="title.CDA.manage"/>',
                    url: '${contextRoot}/cda/initial'
                },
                {
                    id: 215,
                    pid: 21,
                    level:3,
                    text: 'CDA类别',
                    url: '${contextRoot}/cdatype/index'
                },
                {
                    id: 216,
                    pid: 21,
                    level:3,
                    text: '标准版本管理',
                    url: '${contextRoot}/cdaVersion/initial'
                },
                {
                    id: 217,
                    pid: 21,
                    level:3,
                    text: '特殊字典'
                },
                {
                    id: 2171,
                    pid:217,
                    level:4,
                    text: '诊断字典',
                    url: '${contextRoot}/specialdict/icd10/initial'
                },
                {
                    id: 2172,
                    pid: 217,
                    level:4,
                    text: '指标字典',
                    url: '${contextRoot}/specialdict/indicator/initial'
                },
                {
                    id: 2173,
                    pid: 217,
                    level:4,
                    text: '药品字典',
                    url: '${contextRoot}/specialdict/drug/initial'
                },
                {
                    id: 2174,
                    pid: 217,
                    level:4,
                    text: '疾病字典',
                    url: '${contextRoot}/specialdict/hp/initial'
                },
                {
                    id: 22,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.org.std.collection.manage"/>',
                    url: '${contextRoot}/adapterorg/initial'
                },
                {
                    id: 23,
                    pid: 2,
                    level:2,
                    text: '<spring:message code="title.adapter.manager"/>',
                    url: '${contextRoot}/adapter/initial'
                },

                //3 - 资源管理中心
                {id: 3, level:1, text: '<spring:message code="title.resource.manage.center"/>'},
                //3-1 资源标准
                {
                    id: 31,
                    level:2,
                    pid: 3,
                    text: '<spring:message code="title.resource.standard"/>'
                },
                //3-1-1 数据元
                {
                    id: 311,
                    level:3,
                    pid: 31,
                    text: '<spring:message code="title.resource.standard.metaData"/>',
                    url: '${contextRoot}/resource/meta/initial'
                },
                {
                    id: 312,
                    level:3,
                    pid: 31,
                    text: '<spring:message code="title.resource.standard.dict"/>',
                    url: '${contextRoot}/resource/dict/initial'
                },
                {
                    id: 313,
                    level:3,
                    pid: 31,
                    text: '<spring:message code="title.resource.standard.adapter"/>',
                    url: '${contextRoot}/schemeAdapt/initial'
                },
                {
                    id: 32,
                    level:2,
                    pid: 3,
                    text: '<spring:message code="title.resource.catalog"/>',
                    url: '${contextRoot}/rscategory/index'
                },
                {
                    id: 33,
                    level:2,
                    pid: 3,
                    text: '<spring:message code="title.resource.register"/>',
                    url: '${contextRoot}/resource/resourceManage/initial'
                },
                <%--{--%>
                    <%--id: 331,--%>
                    <%--level:3,--%>
                    <%--pid: 33,--%>
                    <%--text: '资源配置',--%>
                    <%--url: '${contextRoot}/resourceConfiguration/initial'--%>
                <%--},--%>
                <%--{--%>
                    <%--id: 332,--%>
                    <%--level:3,--%>
                    <%--pid: 33,--%>
                    <%--text: '资源授权',--%>
                    <%--url: '${contextRoot}/resource/grant/initial'--%>
                <%--},--%>
                <%--{--%>
                    <%--id: 333,--%>
                    <%--level:3,--%>
                    <%--pid: 33,--%>
                    <%--text: '资源浏览',--%>
                    <%--url: '${contextRoot}/resourceBrowse/initial'--%>
                <%--},--%>
                {
                    id: 34,
                    level:2,
                    pid: 3,
                    text: '<spring:message code="title.resource.view"/>',
                    url: '${contextRoot}/resourceBrowse/initial'
                },
                {
                    id: 35,
                    level:2,
                    pid: 3,
                    text: '<spring:message code="title.resource.interface"/>',
                    url: '${contextRoot}/resource/resourceInterface/initial'
                },
                //4 - 安全管理中心
                //{id: 4, text: '<spring:message code="title.security.manage.center"/>'},

                //4 - 运营中心
                {id: 5, level:1, text: '<spring:message code="title.operating.center"/>'},
                {
                    id: 51,
                    level:2,
                    pid: 5,
                    text: '<spring:message code="title.esb.manage"/>'
                },
                {
                    id: 511,
                    level:3,
                    pid: 51,
                    text: '<spring:message code="title.esb.log.upload"/>',
                    url: '${contextRoot}/hosLogs/initial'
                },
                {
                    id: 512,
                    level:3,
                    pid: 51,
                    text: '<spring:message code="title.esb.source.list"/>',
                    url: '${contextRoot}/esb/hosRelease/initial'
                },
                {
                    id: 513,
                    level:3,
                    pid: 51,
                    text: '<spring:message code="title.esb.source.org.update"/>',
                    url: '${contextRoot}/esb/installLog/initial'
                },
                {
                    id: 514,
                    level:3,
                    pid: 51,
                    text: '<spring:message code="title.esb.his.search"/>',
                    url: '${contextRoot}/esb/sqlTask/initial'
                },
                {
                    id: 515,
                    level:3,
                    pid: 51,
                    text: '<spring:message code="title.esb.task.recollect"/>',
                    url: '${contextRoot}/esb/acqTask/initial'
                },

                //6 - 服务管理中心
                //{id: 6, text: '<spring:message code="title.server.manage.center"/>'},

                //7 - 开放中心
                {id: 7,level:1, text: '<spring:message code="title.open.hub.manage.center"/>'},
                {
                    id: 71,
                    level:2,
                    pid: 7,
                    text: '<spring:message code="title.app.manage"/>',
                    url: '${contextRoot}/app/initial'
                },
                {
                    id: 74,
                    level:2,
                    pid: 7,
                    text: '应用角色',
                    url: '${contextRoot}/appRole/initial'
                },
                //8 - 配置管理中心
                {id: 8,level:1,text: '<spring:message code="title.setting.manage.center"/>'},
                {
                    id: 81,
                    pid: 8,
                    level:2,
                    text: '<spring:message code="title.sysDict.manage"/>',
                    url: '${contextRoot}/dict/initial'
                },

                //9 - 健康档案浏览器
                {id: 9,level:1, text: '<spring:message code="title.health.archive.browser"/>'},
                {
                    id: 91,
                    pid: 9,
                    level:2,
                    text: '<spring:message code="title.template.manage"/>',
                    url: '${contextRoot}/template/initial'
                }
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
