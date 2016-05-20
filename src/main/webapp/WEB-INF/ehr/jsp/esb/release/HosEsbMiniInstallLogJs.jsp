<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>
    (function ($, win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            // 页面表格条件部模块
            var retrieve = null;
            // 页面主模块
            var master = null;
            // 页面GRID信息
            var installLogGrid = null;
            //是否第一页
            var isFirstPage = true;

            /* *************************** 函数定义 ******************************* */
            /**
             * 页面初始化。
             * @type {Function}
             */
            function pageInit() {
                retrieve.init();
                master.init();
            }
            //多条件查询参数设置
            function reloadGrid (params) {
                if (isFirstPage){
                    installLogGrid.options.newPage = 1;
                }
                installLogGrid.set({
                    parms: params
                });

                installLogGrid.reload();
                isFirstPage = true;
            }

            /* *************************** 模块初始化 ***************************** */
            retrieve = {
                // 模块对应的容器
                $element: $('.m-retrieve-area'),
                // 搜索框
                $searchBox: $('#inp_search'),
                //机构查询下拉框
                $searchOrg: $('#inp_org'),
                //查询按钮
                $searchBtn: $('#btn_search'),
                init: function () {
                    this.$element.show();
                    this.$element.attrScan();
                    retrieve.initDDL();
                },
                //下拉框列表项初始化
                initDDL: function () {
                    this.$searchOrg.addressDropdown({
                     placehoder: '请选择机构',
                     tabsData: [
                        {
                            name: '省份',
                            code: 'id',
                            value: 'name',
                            url: '${contextRoot}/address/getParent',
                            params: {level: '1'}
                        },
                        {name: '城市', code: 'id', value: 'name', url: '${contextRoot}/address/getChildByParent'},
                        {
                            name: '医院',
                            code: 'orgCode',
                            value: 'fullName',
                            url: '${contextRoot}/address/getOrgs',
                            beforeAjaxSend: function (ds, $options) {
                                var province = $options.eq(0).attr('title'),
                                        city = $options.eq(1).attr('title');
                                ds.params = $.extend({}, ds.params, {
                                    province: province,
                                    city: city
                                });
                            }
                        }
                    ]
                });
                }
            };
            master = {
                init: function () {
                    installLogGrid = $("#div_install_log_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/esb/installLog/searchInstallLogList',
                        // 传给服务器的ajax 参数
                        parms: {
                            systemCode: '',
                            orgCode: ''
                        },
                        columns: [
                            // 隐藏列：hide: true（隐藏），isAllowHide: false（列名右击菜单中不显示）
                            {name: 'id', hide: true, isAllowHide: false},
                            {display: '机构编号', name: 'orgCode', width: '16%',align:'left'},
                            {display: '机构名称', name: 'orgName', width: '16%',align:'left'},
                            {display: '系统代码', name: 'systemCode', width: '16%',align:'left'},
                            {display: '版本名称', name: 'currentVersionName', width: '16%',align:'left'},
                            {display: '版本编号',name: 'currentVersionCode', width:'16%', align:'left'},
                            {display: '更新时间', name: 'installDate', width: '20%',align:'left'}
                        ]
                    }));
                    // 自适应宽度
                    installLogGrid.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function () {
                    var values =  retrieve.$element.Fields.getValues();
                    if (values.orgCode.keys.length > 1){
                        values.orgCode = values.orgCode.keys[2];
                        if(!isNotEmpty(values.orgCode)){
                            win.parent.$.Notice.error('请选择机构进行查询！');
                        }
                    }
                    else{
                        values.orgCode = '';
                    }
                    reloadGrid.call(this, values);
                },
                bindEvents: function () {
                    //事件绑定
                    retrieve.$searchBtn.click(function(){
                        master.reloadGrid();
                    })
                }
            };
            /* *************************** 页面初始化 **************************** */
            pageInit();
            isNotEmpty = function(s){
                    if(s==null||s==""){
                        return false;
                    }else{
                        return true;
                    }
            }
            /* ************************* 页面初始化结束 ************************** */
        });
    })(jQuery, window);
</script>