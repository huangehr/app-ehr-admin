<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script >
  (function ($, win) {
    $(function () {
      /* ************************** 全局变量定义 **************************** */
      var retrieve = null;
      var master = null;
      var conditionArea = null;
      var adapterSchemeId = '${dataModel}';
      var version = '${version}';
      var adapterScheme =${adapterScheme};
      var entryRetrieve = null;
      var entryMater = null;
      var cfgModel = 0;
      var changeFlag=false;
      var metaDataList = null;
      var dictDataList = null;
      var lastSelectRow = null;
      var cfg = [
        {
          left:{title:'平台数据集', cls:'', search:'/std/dataset/searchDataSets'},
          right:{title:'数据元映射', cls:'', search:'/schemeAdaptDataSet/metaDataList', goSave:'/schemeAdaptDataSet/saveMetaDate'}
        },
        {
          left:{title:'平台字典', cls:'', search:'/cdadict/getCdaDictList'},
          right:{title:'字典项映射', cls:'', search:'/schemeAdaptDataSet/searchAdapterDictEntry', goSave:'/schemeAdaptDataSet/saveAdaptDict'}
        }
      ];
      /* *************************** 函数定义 ******************************* */
      function pageInit() {
        resizeContent();
        retrieve.init();
        conditionArea.init();
        entryRetrieve.init();
        master.init();
        master.reloadGrid();
        entryMater.init();
      }

      function  isUpdate(){
        var update = false;
        for(var j in metaDataList){
          var metadataId = $("#metadataId"+metaDataList[j].id).ligerGetComboBoxManager().getValue();
          if(metadataId!=(metaDataList[j].metadataId==null?"":metaDataList[j].metadataId)){
            update = true;
            break;
          }
        }
        return update;
      }

      function dataSetClick(){
        cfgModel = 0;
        changeFlag=true;
        conditionArea.$btn_switch_dataSet.addClass('btn-primary');
        conditionArea.$btn_switch_dict.removeClass('btn-primary');
        master.grid.options.newPage = 1;
        master.reloadGrid();
      }

      function dictClick(){
        cfgModel = 1;
        changeFlag=true;
        conditionArea.$btn_switch_dataSet.removeClass('btn-primary');
        conditionArea.$btn_switch_dict.addClass('btn-primary');
        master.grid.options.newPage = 1;
        master.reloadGrid();
        entryMater.reloadGrid();
      }

      function goHis(){
        $('#contentPage').empty();
        $('#contentPage').load('${contextRoot}/schemeAdapt/initial');
      }

      function validateMasterSelect(oldDate,newDate){
        var update = isUpdate();
        if(update){
          $.ligerDialog.confirm('适配数据还未保存，是否刷新数据?', function (yes) {
              if(yes){
                lastSelectRow = newDate;
                master.grid.select(newDate.__index);
              }
            })
        }else{
          lastSelectRow = newDate;
          master.grid.select(newDate.__index);
        }
      }

      function validateTabclick(callback){
        var update = isUpdate();
        if(update){
          $.ligerDialog.confirm('适配数据还未保存，是否离开?', function (yes) {
            if(yes){
              callback();
            }
          })
        }else{
            callback();
        }
      }


      function reloadGrid (url, params, columns) {
        if(columns){
          this.grid.set({
            columns:columns,
            url: url,
            parms: params
          });
        }
        else{
          this.grid.set({
            url: url,
            parms: params
          });
        }
      }

      function mastReload(){
        master.grid.reload();
      }
      //first|prev|next|last|input
      function masterfirst(){
          metaDataList=null;
          master.grid.changePage("first");
      }
      function masterprev(){
          metaDataList=null;
          master.grid.changePage("prev");
      }
      function masternext(){
          metaDataList=null;
          master.grid.changePage("next");
      }
      function masterlast(){
          metaDataList=null;
          master.grid.changePage("last");
      }


      function entryMaterReload(){
        entryMater.grid.reload();
      }
      //first|prev|next|last|input
      function entryMaterfirst(){
        metaDataList=null;
        entryMater.grid.changePage("first");
      }
      function entryMaterprev(){
        metaDataList=null;
        entryMater.grid.changePage("prev");
      }
      function entryMaternext(){
        metaDataList=null;
        entryMater.grid.changePage("next");
      }
      function entryMaterlast(){
        metaDataList=null;
        entryMater.grid.changePage("last");
      }

      function resizeContent(){
        var contentW = $('#grid_content').width();
        var leftW = $('#div_left').width();
        $('#div_right').width(contentW-leftW-20);
      }
      /* *************************** title模块初始化 ***************************** */
      conditionArea = {
        $element: $('#conditionArea'),
        //头部提示
        $adapter_scheme_name :$('#adapter_scheme_name'),
        $adapter_scheme_type :$('#adapter_scheme_type'),
        $adapter_scheme_code :$('#adapter_scheme_code'),
        //切换BTN
        $btn_switch_dataSet :$('#switch_dataSet'),
        $btn_switch_dict :$('#switch_dict'),
        initAdapterScheme: function () {
             if(adapterScheme.successFlg){
               this.$adapter_scheme_name.val(adapterScheme.obj.name);
               this.$adapter_scheme_type.val(adapterScheme.obj.typeName);
               this.$adapter_scheme_code.val(adapterScheme.obj.code);
             }else{
               $.Notice.error('数据获取失败，请刷新后重试！');
             }
        },
        init : function () {
          this.bindEvents();
          this.$element.show();
          this.initAdapterScheme();
        },
        bindEvents : function () {
          this.$btn_switch_dataSet.click(function () {
            validateTabclick(dataSetClick);
          });

          this.$btn_switch_dict.click(function () {
            validateTabclick(dictClick);
          })
        }
      };

      /* *************************** left模块初始化 ***************************** */
      retrieve = {
        $element: $('#retrieve'),
        $searchNm: $('#searchNm'),
        $addBtn: $('#btn_create'),
        $gohis:$('#gohis'),
        init: function () {
          this.$searchNm.ligerTextBox({width: 240, isSearch: true, search: function () {
            master.grid.options.newPage = 1;
            validateTabclick(mastReload);
          }});
          this.$gohis.bind("click",function(){
            validateTabclick(goHis);
          })
          this.$element.show();
        }
      };
      master = {
        grid: null,
        init: function () {
          if(this.grid)
            return;
          this.grid = $("#div_left_grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}'+cfg[cfgModel].left.search,
            columns: this.getColumn(),
            delayLoad:true,
            selectRowButtonOnly: true,
            allowHideColumn:false,
            validate : true,
            unSetValidateAttr:false,
            onBeforeSelectRow:function(selectDate){
              if(lastSelectRow==null){
                return true;
              }
              if(lastSelectRow.id != selectDate.id){
                validateMasterSelect(lastSelectRow,selectDate);
              }else{
                return true;
              }
              return false;
            },
            onBeforeShowData: function (data) {
              if(data.detailModelList.length==0){
                entryMater.reloadGrid('');
              }
            },
            onAfterShowData: function () {
              this.select(0);
            },
            onSelectRow: function(row){
                lastSelectRow = row;
                entryMater.grid.options.newPage = 1;
                entryMater.reloadGrid(row.code);
            },onToFirst:function(){
              validateTabclick(masterfirst);
              return false;
            },onReload:function(){
              validateTabclick(mastReload);
              return false;
            },onToPrev:function(){
              validateTabclick(masterprev);
              return false;
            },onToNext:function(){
              validateTabclick(masternext);
              return false;
            },onToLast:function(){
              validateTabclick(masterlast);
              return false;
            }
          }));
          this.bindEvents();
          // 自适应宽度
          this.grid.adjustToWidth();

        },
        bindEvents:function(){

        },
        reloadGrid: function () {
          var searchNm = $("#searchNm").val();
          var values =null;
          if(cfgModel==0){
            values={
              "codename":searchNm,
              "version":version
            }
          }else{
            values={
              "searchNm":searchNm,
              "strVersionCode":version
            }
          }
          if (changeFlag){
            var url = '${contextRoot}' + cfg[cfgModel].left.search;
            reloadGrid.call(this, url, values, this.getColumn());
          }else{
            this.grid.setOptions({parms: $.extend({},values)});
            //重新查询
            this.grid.loadData(true);
          }
        },
        getColumn: function () {
          var columnCfg =[];
          var code = 'code';
          var name = 'name';
          if(cfgModel==0){
             columnCfg = [{ display: 'id', name: 'id', hide:true },
                         { display: '数据集编码', name: code,width: '50%', isAllowHide: false ,align:'left' },
                         { display: '数据集名称',name: name, width: '50%',isAllowHide: false ,align:'left' }];
          }else{
            columnCfg = [{ display: 'id', name: 'id', hide:true },
                        { display: '字典编码', name: code,width: '50%', isAllowHide: false ,align:'left' },
                        { display: '字典名称',name: name, width: '50%',isAllowHide: false ,align:'left' }];
          }
          return columnCfg;
        }
      };
      /* *************************** right模块初始化 ***************************** */
      entryRetrieve = {
        $element: $('#entryRetrieve'),
        $searchNm: $('#searchNmEntry'),
        $title: $('#right_title'),
        init: function () {
          this.$element.show();
        }
      };
      entryMater = {
        entryInfoDialog: null,
        grid: null,
        init: function (dictId) {
          if(this.grid){
             return;
          }
          this.grid = $("#div_relation_grid").ligerGrid($.LigerGridEx.config({
            url: '${contextRoot}'+cfg[cfgModel].right.search,
            columns: this.getColumn(),
            delayLoad:true,
            selectRowButtonOnly: false,
            allowHideColumn:false,
            validate : true,
            unSetValidateAttr:false,
            checkbox:false,
            onAfterShowData: function (currentData) {
              entryMater.initMetadataId();
            },onBeforeShowData:function(currentData){
              metaDataList = currentData.detailModelList;
            },
            reloadGrid:function(){
              validateTabclick(entryMater.reloadGrid);
            },onToFirst:function(){
              validateTabclick(entryMaterfirst);
              return false;
            },onReload:function(){
              validateTabclick(entryMaterReload);
              return false;
            },onToPrev:function(){
              validateTabclick(entryMaterprev);
              return false;
            },onToNext:function(){
              validateTabclick(entryMaternext);
              return false;
            },onToLast:function(){
              validateTabclick(entryMaterlast);
              return false;
            }
          }));
          this.bindEvents();
          // 自适应宽度
          this.grid.adjustToWidth();
        },
        reloadGrid: function (code) {
            if(code!=''){
              var row = master.grid.getSelectedRow();
              if(row){
                code = row.code;
              }
            }
            var values = {
              adapterSchemeId :adapterSchemeId,
              code:code,
            };
            if (changeFlag){
              reloadGrid.call(this, '${contextRoot}'+cfg[cfgModel].right.search, values, this.getColumn());
            }else{
              this.grid.setOptions({parms: $.extend({},values)});
              //重新查询
              this.grid.loadData(true);
            }
            changeFlag=false;
        },
        bindEvents: function () {
          //窗体改变大小事件
          $(window).bind('resize', function() {
            resizeContent();
          });
          $.subscribe('grid:right:save',function(event,id,mode){
              var allRowList = metaDataList;
              var saveRows = new Array();
              for(var j in  allRowList){
                var rowData = allRowList[j];
                var metadataId = $("#metadataId"+rowData.id).ligerGetComboBoxManager().getValue();
                //未做变更
                var saveRowData={};
                if(rowData.metadataId!=metadataId){
                  saveRowData.metadataId = metadataId;
                  rowData.metadataId = metadataId;
                  rowData.metadataDomain = $("#metadataDomain"+rowData.id).html();
                  saveRowData.metadataDomain = $("#metadataDomain"+rowData.id).html();
                  saveRowData.id =rowData.id;
                  saveRowData.srcDatasetCode =rowData.srcDatasetCode;
                  saveRowData.srcMetadataName =rowData.srcMetadataName;
                  saveRowData.srcMetadataCode =rowData.srcMetadataCode;
                  saveRowData.schemaId = rowData.schemaId;
                  saveRows.push(saveRowData);
                }
              }
              if(saveRows.length==0){
                $.Notice.error('数据未变更，无需保存！');
                return false;
              }else{
                var dataModel = $.DataModel.init();
                dataModel.updateRemote('${contextRoot}/schemeAdaptDataSet/updates', {
                  data: {dataJson: JSON.stringify(saveRows)},
                  success: function (data) {
                    metaDataList = allRowList;
                  }
                })
              }

          })

        },
        getColumn: function () {
          var columnCfg =[];
          if(cfgModel==0){
            columnCfg = [
              { display: 'id', name: 'id', hide:true },
              { display: 'metadataId', name: 'metadataId', hide:true },
              { display: 'schemaId', name: 'schemaId', hide:true },
              { display: 'srcDatasetCode', name: 'srcDatasetCode', hide:true },
              { display: '内部标识符', name: 'srcMetadataCode',width: '19%', isAllowHide: false ,align:'left' },
              { display: '数据元名称',name: 'srcMetadataName', width: '19%',isAllowHide: false  ,align:'left'},
              { display: '资源标准编码', name: 'metadataId',width: '21%', isAllowHide: false  ,align:'left',render: function (row) {
                var html= "<input type=\"text\" id='metadataId"+row.id+"' name=\"metadataId\"  data-type=\"select\" class=\"useTitle\" >";
                return html;
              }},
              { display: '业务领域',name: 'metadataDomain', width: '20%',hide:true  ,align:'left',render: function (row) {
                var html="<span id='metadataDomain"+row.id+"'>"+((row.metadataDomain==undefined)?"":row.metadataDomain)+"</span>"
                return html;
              }},
              { display: '业务领域',name: 'metadataDomainName', width: '20%',isAllowHide: false  ,align:'left',render: function (row) {
                var html="<span id='metadataDomainName"+row.id+"'>"+((row.metadataDomainName==undefined)?"":row.metadataDomainName)+"</span>"
                return html;
              }},
              { display: '数据元名称', name: 'metadataName',width: '21%', isAllowHide: false  ,align:'left',render: function (row) {
                var html="<span id='metadataName"+row.id+"'>"+((row.metadataName==undefined)?"":row.metadataDomainName)+"</span>"
                return html;
              }}
            ]
          }
          else{
            columnCfg = [
              { display: 'id', name: 'id', hide:true },
              { display: 'dictEntryId', name: 'dictEntryId', hide:true },
              { display: '值域编码', name: 'dictEntryCode',width: '10%', isAllowHide: false ,align:'left' },
              { display: '值域名称',name: 'dictEntryName', width: '10%',isAllowHide: false  ,align:'left'},
              { display: '资源标准编码', name: 'orgDictCode',width: '30%', isAllowHide: false ,align:'left' },
              { display: '业务领域',name: 'orgDictName', width: '25%',isAllowHide: false  ,align:'left'},
              { display: '值域名称', name: 'orgDictEntryCode',width: '25%', isAllowHide: false  ,align:'left'}
            ]
          }
          return columnCfg;
        },initMetadataId:function(){
            url = "${contextRoot}/resource/meta/combo";
            $("input[name=metadataId]").ligerComboBox({
            condition: { inputWidth: 240 ,width:0,labelWidth:0,hideSpace:true,fields: [{ name: "value", label:''}] },//搜索框的字段, name 必须是服务器返回的字段
            grid: getGridOptions(true),
            valueField: "code",
            textField: "code",
            width : 240,
            selectBoxHeight : 260,
            selectBoxWidth:751,
            onSelected: function(id,name){//name为选择的值
              if(this.grid ==undefined) return;
              var rowData  = this.grid.getSelected();
              var selected = entryMater.grid.getSelected();
              $("#metadataDomain"+selected.id).html(rowData.domain);
              $("#metadataDomainName"+selected.id).html(rowData.domainName);
              $("#metadataName"+selected.id).html(rowData.value);
            },
            onBeforeSetData:function(value){
              debugger;
              var selected = entryMater.grid.getSelected();
                if(value==null||value==""){
                  $("#metadataDomain"+selected.id).html("");
                  $("#metadataDomainName"+selected.id).html("");
                  $("#metadataName"+selected.id).html("");
                }
            },
            conditionSearchClick: function (g) {
              var param = g.rules.length>0? "id="+g.rules[0].value +" g1;name="+g.rules[0].value+" g1": '';
              param = {"filters":param}
              g.grid.set({
                parms: param,
                newPage: 1
              });
              g.grid.reload();
            }
          });
          for(var j in metaDataList){
            var metadataId = metaDataList[j].metadataId;
            if(metadataId!=""&&metadataId!=null){
              $("#metadataId"+metaDataList[j].id).ligerGetComboBoxManager().setValue(metadataId);
              $("#metadataId"+metaDataList[j].id).ligerGetComboBoxManager().setText(metadataId);
            }
          }
        }
      };
      /* *************************** 页面功能 **************************** */
      function getGridOptions(checkbox) {
        var options = {
          columns: [

            {display : '资源标准编码', name :'code',width :243},
            {display : '业务领域', name :'domainName',width : 243},
            {display : '数据元名称', name :'value',width : 243}
          ],
          allowAdjustColWidth : true,
          editorTopDiff : 41,
          headerRowHeight : 30,
          height : '100%',
          heightDiff : 0,
          pageSize: 15,
          pagesizeParmName : 'rows',
          record : "totalCount",
          root : "detailModelList",
          rowHeight : 28,
          rownumbers :false,
          switchPageSizeApplyComboBox: false,
          width :755,
          url : url
        };
        return options;
      }
      pageInit();
      $(window).bind('beforeunload',function(){
        if(isUpdate()){
          return "适配数据还未保存，是否刷新数据?";
        }
      });
      });
  })(jQuery, window);
</script>
