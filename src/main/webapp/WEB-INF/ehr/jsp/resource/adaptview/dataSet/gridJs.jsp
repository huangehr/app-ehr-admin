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
      var entryDataList = null;
      var cfg = [
        {
          left:{title:'平台数据集', cls:'', search1:'/std/dataset/searchDataSets',search2:'/orgdataset/searchOrgDataSets'},
          right:{title:'数据元映射', cls:'', search:'/schemeAdaptDataSet/metaDataList'}
        },
        {
          left:{title:'平台字典', cls:'', search1:'/cdadict/getCdaDictList',search2:'/orgdict/searchOrgDicts'},
          right:{title:'字典项映射', cls:'', search:'/schemeAdaptDict/dictlist'}
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
      //数据源页签点击
      function dataSetClick(){
        cfgModel = 0;
        changeFlag=true;
        conditionArea.$btn_switch_dataSet.addClass('btn-primary');
        conditionArea.$btn_switch_dict.removeClass('btn-primary');
        master.grid.options.newPage = 1;
        master.reloadGrid();
      }
      //字典页签点击
      function dictClick(){
        cfgModel = 1;
        changeFlag=true;
        conditionArea.$btn_switch_dataSet.removeClass('btn-primary');
        conditionArea.$btn_switch_dict.addClass('btn-primary');
        master.grid.options.newPage = 1;
        master.reloadGrid();
      }
      //返回上一页
      function goHis(){
        $('#contentPage').empty();
        $('#contentPage').load('${contextRoot}/schemeAdapt/initial');
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
             dataSetClick();
          });

          this.$btn_switch_dict.click(function () {
             dictClick();
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
            master.reloadGrid();
          }});
          this.$searchNm.keydown(function(e){
            if(e.keyCode==13){
              master.grid.options.newPage = 1;
              master.reloadGrid();
            }
          });
          this.$gohis.bind("click",function(){
            goHis();
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
            url: '${contextRoot}'+this.getSearchUrl(),
            columns: this.getColumn(),
            delayLoad:true,
            selectRowButtonOnly: true,
            allowHideColumn:false,
            validate : true,
            unSetValidateAttr:false,
            onBeforeShowData: function (data) {
              if(data.detailModelList.length==0){
                entryMater.reloadGrid('');
              }
            },
            onAfterShowData: function () {
              this.select(0);
            },
            onSelectRow: function(row){
                entryMater.grid.options.newPage = 1;
                entryMater.reloadGrid(row.code);
            }
          }));
          this.bindEvents();
          // 自适应宽度
          this.grid.adjustToWidth();

        },
        bindEvents:function(){

        },
        reloadGrid: function () {
          var values =this.getParam();
          if (changeFlag){
            var url = '${contextRoot}' + this.getSearchUrl();
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
        },getSearchUrl:function(){
          if(cfgModel==0&&adapterScheme.obj.type==1){
            return  cfg[cfgModel].left.search1;
          }else if(cfgModel==0&&adapterScheme.obj.type==2){
            return  cfg[cfgModel].left.search2;
          }else if(cfgModel==1&&adapterScheme.obj.type==1){
            return  cfg[cfgModel].left.search1
          }else if(cfgModel==1&&adapterScheme.obj.type==2){
            return  cfg[cfgModel].left.search2
          }
        },getParam:function(){
          var searchNm = $("#searchNm").val();
          var values=null;
          if(cfgModel==0&&adapterScheme.obj.type==1){
            values={
              "codename":searchNm,
              "version":version
            }
          }else if(cfgModel==0&&adapterScheme.obj.type==2){
            values={
              "codeOrName":searchNm,
              "organizationCode":version
            }
          }else if(cfgModel==1&&adapterScheme.obj.type==1){
            values={
              "searchNm":searchNm,
              "strVersionCode":version
            }
          }
          else if(cfgModel==1&&adapterScheme.obj.type==2){
            values={
              "codeOrName":searchNm,
              "organizationCode":version
            }
          }
          return values;
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
              entryDataList = currentData.detailModelList;
              entryMater.initMetadataId();
              this.select(0);
            },
            reloadGrid:function(){
              entryMater.reloadGrid();
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
              code:code
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
              { display: '资源数据元名称', name: 'metadataName',width: '21%', isAllowHide: false  ,align:'left',render: function (row) {
                var html="<span id='metadataName"+row.id+"'>"+((row.metadataName==undefined)?"":row.metadataName)+"</span>"
                return html;
              }}
            ]
          }
          else{
            columnCfg = [
              { display: 'id', name: 'id', hide:true },
              { display: 'schemeId', name: 'schemeId', hide:true },
              { display: 'srcDictCode', name: 'srcDictCode', hide:true },
              { display: '值域编码', name: 'srcDictEntryCode',width: '20%', isAllowHide: false ,align:'left' },
              { display: '值域名称',name: 'srcDictEntryName', width: '20%',isAllowHide: false  ,align:'left'},
              { display: '资源字典', name: 'dictName',width: '20%', isAllowHide: false ,align:'left',render: function (row) {
                var html= "<input type=\"text\" id='dictName"+row.id+"' name=\"dictName\"  data-type=\"select\" class=\"useTitle\" >";
                return html;
              }},
              { display: 'dictCode', name: 'dictCode', hide:true ,render: function (row) {
                var html="<span id='dictCode"+row.id+"'>"+((row.dictCode==undefined)?"":row.dictCode)+"</span>"
                return html;
              }},
              { display: '资源字典项编码', name: 'dictEntryCode',width: '20%', isAllowHide: false ,align:'left',render: function (row) {
                var html= "<div  id='dictEntryCodeDiv"+row.id+"'><input type=\"text\"  id='dictEntryCode"+row.id+"' name=\"dictEntryCode\"  data-type=\"select\" class=\"useTitle\" ></div>";
                return html;
               }},
              { display: '资源字典项名称', name: 'dictEntryName',width: '20%', isAllowHide: false  ,align:'left',render: function (row) {
                var html="<span id='dictEntryName"+row.id+"'>"+((row.dictEntryName==undefined)?"":row.dictEntryName)+"</span>"
                return html;
              }}
            ]
          }
          return columnCfg;
        },getSaveUrl:function(){
          var saveUrl="";
          //数据集
          if(cfgModel==0){
            saveUrl ="schemeAdaptDataSet/save";
          }else{
            saveUrl ="schemeAdaptDict/save";
          }
          return saveUrl;
        },save:function(saveData){
            var dataModel = $.DataModel.init();
            //保存
            dataModel.updateRemote('${contextRoot}/'+entryMater.getSaveUrl(), {
              data: {dataJson: JSON.stringify(saveData)},
              success: function (data) {
                if((data.successFlag)==false){
                  if(data.errorMsg){
                    $.Notice.error(data.errorMsg);
                  }else{
                    $.Notice.error('保存失败！');
                  }
                }
              }
            })
        },
        initMetadataId:function(){
          if(cfgModel==0){
            var url = "${contextRoot}/resource/meta/combo";
            var parms={};
            $("input[name=metadataId]").ligerComboBox({
            condition: { inputWidth: 240 ,width:0,labelWidth:0,hideSpace:true,fields: [{ name: "value", label:''}] },//搜索框的字段, name 必须是服务器返回的字段
            grid: getGridOptions(false,755,url,parms),
            valueField: "code",
            textField: "code",
            width : 240,
            selectBoxHeight : 260,
            selectBoxWidth:751,
            onSelected: function(id,name){//name为选择的值
              if(this.grid==undefined) return;
              var rowData  = this.grid.getSelected();
              var selected = entryMater.grid.getSelected();
              var saveData={};
              $("#metadataDomain"+selected.id).html(rowData.domain);
              $("#metadataDomainName"+selected.id).html(rowData.domainName);
              $("#metadataName"+selected.id).html(rowData.value);
              //赋值
              saveData.metadataDomain =$("#metadataDomain"+selected.id).html();
              saveData.metadataId = id;
              saveData.id = selected.id;
              saveData.schemaId= selected.schemaId;
              saveData.srcDatasetCode = selected.srcDatasetCode;
              saveData.srcMetadataCode = selected.srcMetadataCode;
              saveData.srcMetadataName = selected.srcMetadataName;
              entryMater.save(saveData);
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
          $("#div_relation_grid .l-trigger-cancel").remove();
          for(var j in entryDataList){
            var metadataId = entryDataList[j].metadataId;
            if(metadataId!=""&&metadataId!=null){
              //由于下拉框还未加载无法初始化
              $("#metadataId"+entryDataList[j].id).ligerGetComboBoxManager().setValue(metadataId);
              $("#metadataId"+entryDataList[j].id).ligerGetComboBoxManager().setText(metadataId);
            }
          }
        }
        else{
            //初始化字典下拉框
            var url = "${contextRoot}/resource/dict/list";
            var parms={};
            $("input[name=dictName]").ligerComboBox({
              condition: { inputWidth: 100 ,width:0,labelWidth:0,hideSpace:true,fields: [{ name: "name", label:''}] },//搜索框的字段, name 必须是服务器返回的字段
              grid: getGridOptions(true,240,url,parms),
              valueField: "name",
              textField: "name",
              width : 240,
              selectBoxHeight : 260,
              selectBoxWidth:240,
              onSelected: function(id,name){//name为选择的值
                if(this.grid==undefined) return;
                var rowData  = this.grid.getSelected();
                var selected = entryMater.grid.getSelected();
                $("#dictCode"+selected.id).html(rowData.code);
                $("#dictEntryCodeDiv"+selected.id).css("display","block");
                var dictEntryManager =  $("#dictEntryCode"+selected.id).ligerGetComboBoxManager();
                dictEntryManager.setValue("");
                dictEntryManager.setText("");
                $("#dictEntryName"+selected.id).html("");
                //重新加载子表
                ligerGrid = dictEntryManager.getGrid();
                ligerGrid.set({
                  parms: {"filters":"dictCode=" + rowData.code},
                  newPage: 1
                })
                ligerGrid.reload();
              },conditionSearchClick: function (g) {
                var param = g.rules.length>0? "code="+g.rules[0].value +" g1;name="+g.rules[0].value+" g1": '';
                param = {"filters":param}
                g.grid.set({
                  parms: param,
                  newPage: 1
                });
                g.grid.reload();
              }
            });
            $("#div_relation_grid .l-trigger-cancel").remove();
            for(var j in entryDataList){
              var dictName = entryDataList[j].dictName;
              if(dictName!=""&&dictName!=null){
                $("#dictName"+entryDataList[j].id).ligerGetComboBoxManager().setText(dictName);
              }
            }
            //初始化字典项下拉框
            url = "${contextRoot}/resource/dict/entry/list";
            $("input[name=dictEntryCode]").ligerComboBox({
              condition: { inputWidth: 100 ,width:0,labelWidth:0,hideSpace:true,fields: [{ name: "name", label:''}] },//搜索框的字段, name 必须是服务器返回的字段
              grid: getGridOptionsByDictEntry(true,240,url),
              valueField: "code",
              textField: "code",
              width : 240,
              selectBoxHeight : 260,
              selectBoxWidth:240,
              onSelected: function(id,name){//name为选择的值
                if(this.grid==undefined||name=="") return;
                var rowData  = this.grid.getSelected();
                var selected = entryMater.grid.getSelected();
                $("#dictEntryName"+selected.id).html(rowData.name);
                var saveData={};
                saveData.id = selected.id;
                saveData.schemeId = selected.schemeId;
                saveData.dictEntryCode=id;
                saveData.dictCode = $("#dictCode"+selected.id).html();
                saveData.srcDictCode = selected.srcDictCode;
                saveData.srcDictEntryName = selected.srcDictEntryName;
                saveData.srcDictEntryCode = selected.srcDictEntryCode;
                entryMater.save(saveData);
              },
              conditionSearchClick: function (g) {
                var selected = entryMater.grid.getSelected();
                var dictCode = $("#dictCode"+selected.id).html();
                var param = g.rules.length>0? ("code="+g.rules[0].value +" g1;name="+g.rules[0].value+" g1;dictCode="+dictCode):"dictCode="+dictCode;
                param = {"filters":param}
                g.grid.set({
                  parms: param,
                  newPage: 1
                });
                g.grid.reload();
              }
            });
            $("#div_relation_grid .l-trigger-cancel").remove();
            for(var j in entryDataList){
              var dictEntryCode = entryDataList[j].dictEntryCode;
              if(dictEntryCode!=""&&dictEntryCode!=null){
                $("#dictEntryCode"+entryDataList[j].id).ligerGetComboBoxManager().setValue(dictEntryCode);
                $("#dictEntryCode"+entryDataList[j].id).ligerGetComboBoxManager().setText(dictEntryCode);
              }else{
                $("#dictEntryCodeDiv"+entryDataList[j].id).css("display","none");
              }
            }
          }
      }};
      /* *************************** 页面功能 **************************** */
      function getGridOptionsByDictEntry(isDict,width,url,parms) {
        var options = {
          columns:getComboxGrid(isDict),
          allowAdjustColWidth : true,
          allowUnSelectRow:false,
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
          width :width,
          url : url,
          onLoadData:function(){
            var selected = entryMater.grid.getSelected();
            var dictCode = $("#dictCode" + selected.id).html();
            if (dictCode == null || dictCode == "") {
              $.Notice.error('请先选择资源字典！');
              return false;
            }
            this.setParm("filters","dictCode=" + dictCode);
            return true;
          }
        };
        return options;
      }

      function getGridOptions(isDict,width,url,parms) {
        var options = {
          columns:getComboxGrid(isDict),
          allowAdjustColWidth : true,
          allowUnSelectRow:false,
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
          width :width,
          url : url
        };
        return options;
      }

      function getComboxGrid(isDict){
        var columnCfg =[];
        if(!isDict){
          columnCfg=[
            {display : '资源标准编码', name :'code',width :243},
            {display : '业务领域', name :'domainName',width : 243},
            {display : '数据元名称', name :'value',width : 243}
          ]
        }else if(isDict){
          columnCfg=[
            {display : '编码', name :'code',width :100},
            {display : '名称', name :'name',width : 100}
          ]
        }
        return columnCfg;
      }
      pageInit();
      });
  })(jQuery, window);
</script>
