/**
 * Created by AndyCai on 2016/4/20.
 */

/* ************************** 变量定义 ******************************** */
var home={};
/* ************************** 变量定义结束 ******************************** */
/* *************************** 函数定义 ******************************* */
home.list={
    grid: null,
    columns: [],
    grid_group:null,
    columns_group:[],
    rows: null,
    enableData: [],
    init:function(){
        //var id = $.Util.getUrlQueryString('id');
        //$("#hd_id").val(id);
        this.event();
    },
    getHomeMembersList: function () {

        var _homeUrl = $("#hd_url").val();
        // 获取家庭关系列表
        var u= home.list;
        var _id = $("#hd_id").val();
        u.grid = $("#div_home_relationship").ligerGrid($.LigerGridEx.config({
            url: _homeUrl + "/home_relation/home_relationship_list",
            // 传给服务器的ajax 参数
            parms: {
                id: _id,
                page:1,
                rows:100
            },
            async: true,
            columns: [
                {display: '姓名', name: 'name', align: 'left'},
                {display: '年龄', name: 'age', align: 'left'},
                {display: '关系', name: 'relationShipName', align: 'left'},
                {display: '关联时间', name: 'relationTime', align: 'left'}
            ],
            pageSizeOptions: [10, 15, 20, 30, 40, 50],
            pageSize: 15,
            rownumbers: true,
            usePager:false,
            unSetValidateAttr: false,
            height:'573px'
        }));

        window.grid = u.grid;

        $("#div_home_relationship .l-grid-body2").css({
            'overflow-x':'hidden'
        });
    },
    getHomeGroupList:function(){
        //获取家庭群组列表
        var u= home.list;
        var _id = $("#hd_id").val();
        var _homeUrl = $("#hd_url").val();
        var u= home.list;

        u.grid_group = $("#div_home_group").ligerGrid($.LigerGridEx.config({
            url: _homeUrl + "/home_relation/home_group_list",
            // 传给服务器的ajax 参数
            parms: {
                id: _id,
                page:1,
                rows:100
            },
            async: true,
            columns: [
                {display: '户主', name: 'name', align: 'left'},
                {display: '关系', name: 'relationShipName', align: 'left'},
                {display: '关联时间', name: 'createTime', align: 'left'}
            ],
            pageSizeOptions: [10, 15, 20, 30, 40, 50],
            pageSize: 15,
            rownumbers: true,
            usePager:false,
            unSetValidateAttr: false,
            height:'573px'
        }));

        window.grid_group = u.grid_group;
        $(".l-grid-body2").css({
            'overflow-x':'hidden'
        });
    },
    event:function(){

        var u= home.list;
        $("#btn_members").unbind('click');
        $("#btn_members").click(function(){
            $(this).addClass('btn-primary');
            $("#btn_group").removeClass('btn-primary');
            $("#div_home_relationship").show();
            $("#div_home_group").hide();
            u.getHomeMembersList();
        });
        $("#btn_group").unbind('click');
        $("#btn_group").click(function(){
            $(this).addClass('btn-primary');
            $("#btn_members").removeClass('btn-primary');
            $("#div_home_relationship").hide();
            $("#div_home_group").show();
            u.getHomeGroupList();
        });
        //初始化时显示家庭关系页
        $("#btn_members").click();
    }
};
/* *************************** 函数定义结束******************************* */