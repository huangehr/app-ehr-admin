<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>

    (function ($, win) {
	    $(function () {
	
		    /* ************************** 全局变量定义 **************************** */
		    var Util = $.Util;
		    var retrieve = null;
            var chartData = null;
            var recordCount = 10;//一页显示几条数据
            var currentIndex = 0;//第一页
		    var tabelGrid=null;

		    /* *************************** 函数定义 ******************************* */
		    function pageInit() {
		        retrieve.init();
		    }
		
		    /* *************************** 模块初始化 ***************************** */
		    retrieve = {
		        $element: $('.m-retrieve-area'),
		        $startDate:$("#inp_start_date"),
		        $endDate:$("#inp_end_date"),
		        $back:$('#btn_back'),
		        $table:$("#table_analysis"),
		        $downExl:$("#downExl"),
			    init: function () {
			        var self = this;
			        self.$startDate.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                            if(value){
                                $(".div-head").find(".div-item.active").trigger("click");
                            }
                    }});
                    self.$endDate.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){
                        if(value){
                            $(".div-head").find(".div-item.active").trigger("click");
                        }
                    }});
                    self.$startDate.ligerDateEditor("setValue",self.getCurrentMonthFirst());
                    self.$endDate.ligerDateEditor("setValue",self.getCurrentDate());
                    self.$element.show();
                    self.$element.attrScan();
			        self.bindEvents();
			        self.getQcOverAllIntegrity();//所有指标统计结果查询,初始化查询
			        
		        },
		        bindEvents:function(){
		        	var self = this;
		        	retrieve.$back.click(function(){
		        		var url = '${contextRoot}/report/initial';
                        $("#contentPage").load(url);
		        	});
		        	$(".div-head").on("click",".div-item",function(){
                        var quotaId = $(this).attr("data-quotaId");
                        $(".div-head").find(".div-item").removeClass("active");
                        $(this).addClass("active");
                        self.drawTable(quotaId);//趋势分析 -按区域列表查询,按日初始化查询
                    });
                    //下载数据
                    // retrieve.$downExl.click(function(){
                    // 	self.getExl();
                    // });
		        },
		        getQcOverAllIntegrity:function(){
                    var self = this;
                    var dataModel = $.DataModel.init();
                    dataModel.createRemote('${contextRoot}/report/getQcOverAllIntegrity', {
                        data: {location: "350200",startTime:self.$startDate.val(),endTime:self.$endDate.val()},
                        success: function (data) {
                            if(data.successFlg){
                                var list = data.detailModelList;
                                for(var i=0;i<list.length;i++){
                                    var item =  $(".div-item").eq(i);
                                    item.attr("data-quotaId",list[i].quotaId);
                                    item.find("span").html(list[i].value);
                                    item.find(".div-item-count").html(list[i].realNum+"/"+list[i].totalNum);
                                }
                                $(".div-head").find(".div-item").eq(0).trigger("click");
                            }
                        }
                    });
                },
                getCurrentMonthFirst:function(){
                    var date_ = new Date();
                    var year = date_.getFullYear();
                    var month = date_.getMonth() + 1<10?"0"+parseInt(date_.getMonth() + 1):parseInt(date_.getMonth() + 1);
                    var firstdate = year + '-' + month + '-01';
                    return firstdate;
                },
                getCurrentDate:function(){
                    var date_ = new Date();
                    var year = date_.getFullYear();
                    var month = date_.getMonth() + 1<10?"0"+parseInt(date_.getMonth() + 1):parseInt(date_.getMonth() + 1);
                    var day = date_.getDate()<10?"0"+date_.getDate():date_.getDate();
                    var currentDate = year + '-' + month + '-' + day;
                    return currentDate;
                },
                getExl:function(){
                	var self = this;
                    var dataModel = $.DataModel.init();
                    dataModel.createRemote('', {
                        data: {},
                        success: function (data) {
                            if(data.successFlg){
                                
                            }
                        }
                    });
                },
		        drawTable:function(quotaId){
		        	var self = this;
		        	var location  = "350200";
		        	var startTime = self.$startDate.val();
		        	var endTime   = self.$endDate.val();
		        	tabelGrid     = retrieve.$table.ligerGrid($.LigerGridEx.config({
				            url: '${contextRoot}/report/getQcQuotaDailyIntegrity',
				            pageSize:20,
				            allowHideColumn:false,
				            height:500,
				            rownumbers:true,
				            parms: {
								location:location,
								quotaId: quotaId,
								startTime: startTime,
	                            endTime: endTime
	                        },
				            //mouseoverRowCssClass:"",
				            columns: [
				                { display: '时间', name: 'eventTime', width: '10%',align: "center",
				                	render:function(row){
				                		var html = row.eventTime.substring(5,row.eventTime.length);
				                		return html;
				                	}
				            	},
				                { display: '对象', name: 'orgName',width: '20%'},
				                { display: '完整性', columns:
				                [
				                    { display: '', name: 'scaleType',width: '7%'
					                },
				                    { display: '整体数量',width: '9%', name: 'arIntegrity',
					                    render: function (row) {
					                    	var html = '';
					                    	if(row.arIntegritySta == 0){
					                    		html+='<span style="color:red">'+ row.arIntegrity + '</span>';
					                    	}else{
					                    		html+= row.arIntegrity;
					                    	}
					                    	return html;
					                    }},
				                    { display: '数据集', width: '9%',name: 'dsIntegrity',
					                    render: function (row) {
					                    	var html = '';
					                    	if(row.dsIntegritySta == 0){
					                    		html+='<span style="color:red">'+ row.dsIntegrity + '</span>';
					                    	}else{
					                    		html+= row.dsIntegrity;
					                    	}
					                    	return html;
					                    }},
				                    { display: '数据元',width: '9%', name: 'mdIntegrity',
					                    render: function (row) {
					                    	var html = '';
					                    	if(row.mdIntegritySta == 0){
					                    		html+='<span style="color:red">'+ row.mdIntegrity + '</span>';
					                    	}else{
					                    		html+= row.mdIntegrity;
					                    	}
					                    	return html;
					                    }}
				                ]
				                },
				                { display: '准确性', name: 'mdAccuracy', width: '7%',
									render: function (row) {
					                    	var html = '';
					                    	if(row.arTimelySta == 0){
					                    		html+='<span style="color:red">'+ row.arTimely + '</span>';
					                    	}else{
					                    		html+= row.arTimely;
					                    	}
					                    	return html;
					                    }
								},
				                { display: '及时性', columns:
				                [
				                    { display: '全部及时性', width: '9%',name: 'arTimely',
					                    render: function (row) {
					                    	var html = '';
					                    	if(row.arTimelySta == 0){
					                    		html+='<span style="color:red">'+ row.arTimely + '</span>';
					                    	}else{
					                    		html+= row.arTimely;
					                    	}
					                    	return html;
					                    }},
				                    { display: '住院病人及时性',width: '9%', name: 'hpTimely',
					                    render: function (row) {
					                    	var html = '';
					                    	if(row.hpTimelySta == 0){
					                    		html+='<span style="color:red">'+ row.hpTimely + '</span>';
					                    	}else{
					                    		html+= row.hpTimely;
					                    	}
					                    	return html;
					                    }},
				                    { display: '门诊病人及时性',width: '9%', name: 'opTimely',
					                    render: function (row) {
					                    	var html = '';
					                    	if(row.opTimelySta == 0){
					                    		html+='<span style="color:red">'+ row.opTimely + '</span>';
					                    	}else{
					                    		html+= row.opTimely;
					                    	}
					                    	return html;
					                    }}
				                ]
				                }
					          ],
				            onAfterShowData: function () {
				            	// debugger
				              	//合并单元格
				             //    setTimeout(function () {
						           //  $('#table_analysis .l-grid-body .l-grid-body-table tbody').rowspan('eventTime', tabelGrid);
						           //  $('#table_analysis .l-grid-body1 .l-grid-body-table tbody').rowspan('orgName', tabelGrid);
					            // }, 0)
				            },
				            onSelectRow: function(row){
			            		//选中行时排除前两列
			            		// $(".l-grid-body1").find("tr.l-selected").removeClass("l-selected");
				            }
			        }));
		       		tabelGrid.adjustToWidth();
		        }
		    };
		    /* *************************** 页面功能 **************************** */
		    pageInit();
	    });
	})(jQuery, window);
  //合并单元格
	// jQuery.fn.rowspan = function (colname, tableObj) {
	// 	var colIdx;
	// 	for (var i = 0, n = tableObj.columns.length; i < n; i++) {
	// 	    if (tableObj.columns[i]["columnname"] == colname) {
	// 	        colIdx = i <= 0 ? 0 : i ;
	// 	        break;
	// 	    }
	// 	}
	// 	return this.each(function () {
	// 	    var that;
	// 	    $('tr', this).each(function (row) {
	// 	        $('td:eq(' + colIdx + ')', this).filter(':visible').each(function (col) {
	// 	            if (that != null && $(this).html() == $(that).html()) {
	// 	                rowspan = $(that).attr("rowspan");
	// 	                if (rowspan == undefined) {
	// 	                    $(that).attr("rowspan", 1);
	// 	                    rowspan = $(that).attr("rowspan");
	// 	                }
	// 	                rowspan = Number(rowspan) + 1;
	// 	                $(that).attr("rowspan", rowspan);
	// 	                $(this).hide();
	//                 } else {
	//                     that = this;
	//                 }
	//             });
	//         });
	// 	});
	// }
</script>