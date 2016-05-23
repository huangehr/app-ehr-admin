<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script type="text/javascript">
    (function ($,win) {
        $(function () {
            /* ************************** 变量定义 ******************************** */
            // 通用工具类库
            var Util = $.Util;
            // 页面表格条件部模块
            var retrieve = null;
            // 页面主模块，对应于用户信息表区域
            var master = null;

            var resourceConfigurationUrl = ['${contextRoot}/user/searchUsers','']//test_url

            var elmParams = ['resourceConfigurationInfoGrid','resourceConfigurationInfoGridTrue'];

            var dataModel = $.DataModel.init();

            /* *************************** 函数定义 ******************************* */
            /**
             * 页面初始化。
             * @type {Function}
             */
            function pageInit() {
                retrieve.init();
                master.init();
            }

            function reloadGrid(url, params,searchType) {
                debugger
                var grif = null;
                if (Util.isStrEquals(searchType,"mateData"))
                    grif = elmParams[0];
                else
                    grif =  elmParams[1];

                grif.setOptions({parms: params});
                grif.loadData(true);

            }

            /* *************************** 模块初始化 ***************************** */
            retrieve = {

                $mateDataSearch: $("#inp_mateData_search"),
                $mateDataSearchTrue: $("#inp_mateData_search_true"),
                $resourceConfigurationInfoGrid: $("#div_resource_configuration_info_grid"),
                $resourceConfigurationInfoGridTrue: $("#div_resource_configuration_info_grid_true"),

                init: function () {

                    var mateDataElm = this.$mateDataSearch
                    var seMetaDataElm = this.$mateDataSearchTrue

                    mateDataElm.ligerTextBox({width: 240, isSearch: true,search: function (data) {
                        master.reloadResourceConfigurationGrid(resourceConfigurationUrl[0],mateDataElm.val(),"mateData");
                    }});
                    seMetaDataElm.ligerTextBox({width: 240, isSearch: true,search:function () {
                        master.reloadResourceConfigurationGrid(resourceConfigurationUrl[1],seMetaDataElm.val(),"seMetaData");
                    }});
                },
            };
            master = {
                init: function () {
                    var self = retrieve;

                    var columnDatas = [
                        {name: 'id', hide: true, isAllowHide: false},
                        {display: '数据元编码', name: 'userTypeName', width: '25%', align: 'left'},
                        {display: '数据元名称', name: 'userTypeName', width: '25%', align: 'left'},
                        {display: '类型', name: 'userTypeName', width: '25%', align: 'left'},
                        {display: '说明', name: 'userTypeName', width: '25%', align: 'left'},  //test_name
                    ];

                    var elm = [self.$resourceConfigurationInfoGrid,self.$resourceConfigurationInfoGridTrue];

                    for (var i = 0;i<resourceConfigurationUrl.length;i++){
                        elmParams[i] = elm[i].ligerGrid($.LigerGridEx.config({
                            url: resourceConfigurationUrl[i],
                            columns: columnDatas,
                            checkbox:true,
                            onSelectRow:function (rowdata, rowid, rowobj) {
                                if (Util.isStrEquals(elm[0],self.$resourceConfigurationInfoGrid)){
                                    addRows(rowdata);
                                }else {
                                    deleteRows(rowdata);
                                }
                            },
                        }));
                    }

                    function addRows(rowdata){
                        var rowDatas = [
                            {userTypeName:'1',userTypeName:'1',userTypeName:'1',userTypeName:'1'},
                            {userTypeName:'1',userTypeName:'2',userTypeName:'3',userTypeName:'2'},
                            {userTypeName:'1',userTypeName:'2',userTypeName:'3',userTypeName:'3'}  //test_data
                        ];

                        elmParams[1].addRow(rowDatas);
                    }

                    function deleteRows(rowdata){

                    }

                    this.bindEvents();

                },
                reloadResourceConfigurationGrid: function (url,value,searchType) {
                    reloadGrid.call(this, url, value,searchType);
                },
                bindEvents: function () {

                },
            };

            /* ************************* 模块初始化结束 ************************** */


            /* *************************** 页面初始化 **************************** */
            pageInit();
            /* ************************* 页面初始化结束 ************************** */
        })
    })(jQuery,window)
</script>