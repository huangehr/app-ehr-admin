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
            // 页面主模块，对应于用户信息表区域
            var master = null;
            // 画面用户信息表对象
            var uploadLogGrid = null;
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
                    uploadLogGrid.options.newPage = 1;
                }
                uploadLogGrid.set({
                    parms: params
                });
                uploadLogGrid.reload();
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
                //开始时间
                $searchBeginTime: $("#beginTime"),
                //结束时间
                $searchEndTime:$("#endTime"),
                //查询按钮
                $searchBtn: $('#btn_search'),

                $clearBtn:$('#btn_clear'),
                init: function () {
                    this.$element.show();
                    this.$element.attrScan();
                    retrieve.initDDL();
                },
                //下拉框列表项初始化
                initDDL: function () {
                    this.$searchBeginTime.ligerDateEditor({
                     format: "yyyy-MM-dd hh:mm:ss",
                     showTime: true,
                     labelWidth: 100,
                     labelAlign: 'center',
                     cancelable : true
                   });
                    this.$searchEndTime.ligerDateEditor({
                        format: "yyyy-MM-dd hh:mm:ss",
                        labelWidth: 100,
                        labelAlign: 'center',
                        cancelable : true,
                        showTime: true
                    });



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
                    uploadLogGrid = $("#div_esb_log_grid").ligerGrid($.LigerGridEx.config({
                        url: '${contextRoot}/hosLogs/searchHosLogs',
                        // 传给服务器的ajax 参数
                        parms: {
                            organization: '',
                            beginTime: '',
                            endTime:''
                        },
                        columns: [
                            // 隐藏列：hide: true（隐藏），isAllowHide: false（列名右击菜单中不显示）
                            {name: 'id', hide: true, isAllowHide: false},
                            {display: '机构编号', name: 'orgCode', width: '20%',align:'left'},
                            {display: '机构名称', name: 'orgName', width: '20%',align:'left'},
                            {display: '机构服务器IP', name: 'ip', width: '20%',align:'left'},
                            {display: 'log文件路径',name: 'filePath', width:'20%', align:'left'},
                            {display: '日记上传时间', name: 'uploadTime', width: '20%',align:'left'}
                        ]
                    }));
                    // 自适应宽度
                    uploadLogGrid.adjustToWidth();
                    this.bindEvents();
                },
                reloadGrid: function () {
                    var values =  retrieve.$element.Fields.getValues();
                    if (values.organization.keys.length > 1){
                        values.organization = values.organization.keys[2];
                        if(!isNotEmpty(values.organization)){
                            $.Notice.error('请选择机构进行查询！');
                        }
                    }
                    else{
                        values.organization = '';
                    }
                    reloadGrid.call(this, values);
                },
                bindEvents: function () {
                    //事件绑定
                    retrieve.$searchBtn.click(function(){
                        master.reloadGrid();
                    });
                    retrieve.$clearBtn.click(function(){
                        var values =  retrieve.$element.Fields.getValues();
                        if (values.organization.keys.length > 1){
                            values.organization = values.organization.keys[2];
                        }
                        else{
                            values.organization = '';
                        }
                        var isSubmit = false;
                        if(isNotEmpty(values.beginTime)||isNotEmpty(values.endTime)||isNotEmpty(values.organization)){
                            isSubmit = true;
                        }
                        if(isSubmit){
                            $.ligerDialog.confirm('确认清空日记，确认请点击确认按钮，否则请点击取消。', function (yes) {
                                if(!yes)return;
                                var dataModel = $.DataModel.init();
                                dataModel.updateRemote("${contextRoot}/hosLogs/clearHosLogs", {
                                    data: {beginTime: values.beginTime,endTime:values.endTime,organization:values.organization},
                                    success: function (data) {
                                        if (data.successFlg) {
                                             $.Notice.success('日记清空成功！');
                                             master.reloadGrid();
                                        } else {
                                            window.top.$.Notice.error(data.errorMsg);
                                        }
                                    }
                                })
                            })
                        }else{
                            $.Notice.error('请先输入查询条件后进行清空操作！');
                        }

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