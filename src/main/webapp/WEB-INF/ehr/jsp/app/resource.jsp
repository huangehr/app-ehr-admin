<%--
  Created by IntelliJ IDEA.
  User: yww
  Date: 2016/5/23
  Time: 10:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<div>
	<!-- ####### 头部 ####### -->
	<div id="conditionArea" class="" align="right">
		<div class="body-head f-h50" align="left">
			<a href="javascript:$('#contentPage').empty();$('#contentPage').load('${contextRoot}/app/initial');"  class="f-fwb">返回上一层 </a>
			<input id="appId" hidden=hidden />
			<span class="f-ml20">应用名称：</span><input class="f-fwb f-mt10"  readonly="readonly"  readonly id="msg_appName"/>
			<span class="f-ml20">应用类型：</span><input class="f-mt10" readonly="readonly" id="msg_catalogName"/>
		</div>
	</div>
	<div id="div_wrapper">
		<!-- ####### 查询条件部分 ####### -->
		<div id="div_content" class="f-ww" style="height:780px ">
			<div id="div_left" class="f-w240 f-bd f-of-hd" style=" width:240px;float: left;height: 780px">
				<div class="f-mt10 f-mb10 f-ml10 f-w240">
					<input type="text" id="inp_search" class="f-ml10 f-h28"/>
				</div>
				<!--资源浏览树-->
				<div id="div_resource_browse_tree" style=""></div>
			</div>
			<!--资源浏览详情-->
			<div id="div_right" class="div-resource-browse" style="float: left;width: 700px;margin-left: 10px">
				<div class="right-retrieve">
					<div class="f-db f-pt10 f-pb10 f-ml10">
						<!--输入框-->
						<input type="text" id="inp_searchNm" placeholder="请输入资源代码或名称" class="f-ml10 f-h28 f-w240" data-attr-scan="searchNm"/>
					</div>
					<div class="f-db f-fr f-pt10 f-mr10">
						<div id="btn_grant" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
							<span>确认授权</span>
						</div>
					</div>
				</div>
				<div class="div-result-msg">
					<div id="div_resource_info_grid"></div>
				</div>
			</div>
		</div>
	</div>
	<%--<div id="div_wrapper" class="f-ww" style="height: 100%;">--%>
		<%--<!-- ####### 查询条件部分 ####### -->--%>
		<%--<div class="f-ww" >--%>
			<%--<div class="f-w240 f-bd f-of-hd" style="float: left;height: 440px">--%>
				<%--<div class="f-mt10 f-mb10 f-ml10 f-w240">--%>
					<%--<input type="text" id="inp_search" class="f-ml10 f-h28"/>--%>
				<%--</div>--%>
				<%--<!--资源浏览树-->--%>
				<%--<div id="div_resource_browse_tree"></div>--%>
			<%--</div>--%>
			<%--<!--资源浏览详情-->--%>
			<%--<div id="div_resource_browse_msg" class="div-resource-browse" style="height: 440px;">--%>
				<%--<div class="" style="border: 1px solid #D6D6D6;">--%>
					<%--<div class="f-db f-pt10 f-pb10">--%>
						<%--<!--输入框-->--%>
						<%--<input type="text" id="inp_searchNm" placeholder="请输入资源代码或名称" class="f-ml10 f-h28 f-w240" data-attr-scan="searchNm"/>--%>
					<%--</div>--%>
					<%--<div class="f-db f-fr f-pt10 f-mr10">--%>
						<%--<div id="btn_add" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >--%>
							<%--<span >确认授权</span>--%>
						<%--</div>--%>
					<%--</div>--%>
				<%--</div>--%>
				<%--<div class="div-result-msg">--%>
					<%--<div id="div_resource_info_grid"></div>--%>
				<%--</div>--%>
			<%--</div>--%>
		<%--</div>--%>
	<%--</div>--%>
</div>