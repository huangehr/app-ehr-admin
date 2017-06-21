<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<script>

    (function ($, win) {
	    $(function () {
	
		    /* ************************** 全局变量定义 **************************** */
		    var Util = $.Util;
		    var retrieve = null;

		    /* *************************** 函数定义 ******************************* */
		    function pageInit() {
		        retrieve.init();
		    }
		
		    /* *************************** 模块初始化 ***************************** */
			retrieve = {
				$element: $('.m-retrieve-area'),
				$deptId: $('#inp_deptId'),
				$startDate:$("#inp_start_date"),
				$endDate:$("#inp_end_date"),
				$searchBtn: $('#btn_search'),
				init: function () {
					var self = this;
					var combo = self.$deptId.customCombo('${contextRoot}/deptMember/getOrgList');
					self.$deptId.parent().css({
						width:'240'
					}).parent().css({
						display:'inline-block',
						width:'240px'
					});

//					combo.setValue("2");
//					combo.setText("阳光医院");

					self.$startDate.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){

					}});
					self.$endDate.ligerDateEditor({format: "yyyy-MM-dd",onChangeDate:function(value){

					}});
					self.$startDate.ligerDateEditor("setValue",self.getCurrentMonthFirst());
					self.$endDate.ligerDateEditor("setValue",self.getCurrentDate());
					self.$element.show();
					self.bindEvents();
				},
				bindEvents: function () {
					var self = this;
					self.$searchBtn.click(function () {
						debugger
						if (self.$startDate.val() == "") {
							$.Notice.error('请选择查询的开始时间');
							return false;
						}
						if (self.$endDate.val() == "") {
							$.Notice.error('请选择查询的结束时间');
							return false;
						}

						self.getRukuData();//所有指标统计结果查询,初始化查询
					});
				},
				getRukuData:function(){
					var waittingDialog = $.ligerDialog.waitting("查询中，请稍候..");
					var self = this;
					var dataModel = $.DataModel.init();
					dataModel.createRemote('${contextRoot}/report/rukuData', {
						data: {orgCode: $("#inp_deptId"+"_val").val(),startDate:self.$startDate.val(),endDate:self.$endDate.val()},
						success: function (data) {
							if(data.successFlg){
								var resultStr = "";
								var detailModelList = data.detailModelList;
								for(var i=0;i<detailModelList.length;i++){
									var eventDate = detailModelList[i].eventDate;
									resultStr+='<tr class="firstTr">' +
													'<td colspan="7"><h3>'+eventDate+'</h3></td></tr>'+
												'<tr  class="f-h40">'+
													'<td>数据集</td>'+
													'<td>累计入库记录数</td>'+
													'<td>当天入库记录数</td>'+
													'<td>累计可识别</td>'+
													'<td>累计不可识别</td>'+
													'<td>当天可识别</td>'+
													'<td>当天不可识别</td>'+
												'</tr>';
									var detailData = detailModelList[i].qcDailyStorageDetailModelList;
									for(var j=0;j<detailData.length;j++){
										resultStr+='<tr class="f-h30">'+
														'<td>'+detailData[j].dataType+'</td>'+
														'<td>'+detailData[j].totalStorageNum+'</td>'+
														'<td>'+detailData[j].todayStorageNum+'</td>'+
														'<td>'+detailData[j].totalIdentifyNum+'</td>'+
														'<td>'+detailData[j].totalNoIdentifyNum+'</td>'+
														'<td>'+detailData[j].todayIdentifyNum+'</td>'+
														'<td>'+detailData[j].todayNoIdentifyNum+'</td>'+
													'</tr>';
									}
								}
								$("#table_data").html(resultStr);
								waittingDialog.close();
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
				}
			}

		    /* *************************** 页面功能 **************************** */
		    pageInit();
	    });
	})(jQuery, window);

</script>