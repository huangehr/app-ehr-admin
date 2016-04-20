/**
 * Created by AndyCai on 2016/4/20.
 */

/* ************************** 变量定义 ******************************** */
var _url = $("#hd_url").val();
var _id = $("#hd_id").val();
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
        this.columns=[
            {display: '姓名', name: 'name', align: 'left'},
            {display: '年龄', name: 'age', align: 'left'},
            {display: '关系', name: 'relationshipName', align: 'left'},
            {display: '关联时间', name: 'relationTime', align: 'left'}
        ];

        this.columns_group=[
            {display: '户主', name: 'name', align: 'left'},
            {display: '关系', name: 'relationshipName', align: 'left'},
            {display: '关联时间', name: 'relationTime', align: 'left'}
        ];
    },
    getHomeMembersList: function () {
        //TODO: 获取家庭关系列表
        var u= home.list;

        u.grid = $("#div_home_relationship").ligerGrid($.LigerGridEx.config({
            url: _url + "/home_relation/home_relationship_list",
            // 传给服务器的ajax 参数
            parms: {
                id: _id
            },
            async: true,
            columns: u.columns,
            pageSizeOptions: [10, 15, 20, 30, 40, 50],
            pageSize: 15,
            rownumbers: true,
            height: "100%"
        }));

        window.grid = u.grid;
    },
    getHomeGroupList:function(){
        //TODO: 获取家庭群组列表
        var u= home.list;

        u.grid_group = $("#div_home_group").ligerGrid($.LigerGridEx.config({
            url: _url + "/home_relation/home_group_list",
            // 传给服务器的ajax 参数
            parms: {
                id: _id
            },
            async: true,
            columns: u.columns_group,
            pageSizeOptions: [10, 15, 20, 30, 40, 50],
            pageSize: 15,
            rownumbers: true,
            height: "100%"
        }));

        window.grid_group = u.grid_group;
    },
    event:function(){
        var u= home.list;
        $("#btn_members").click(function(){
            u.getHomeMembersList();
        });
        $("#btn_group").click(function(){
            u.getHomeGroupList();
        });
        //初始化时显示家庭关系页
        $("#btn_members").click();
    }
};
/* *************************** 函数定义结束******************************* */