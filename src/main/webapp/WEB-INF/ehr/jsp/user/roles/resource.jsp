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
		<div class="body-head f-h30 f-mb10" align="left">
			<a href="javascript:$('#contentPage').empty();$('#contentPage').load('${contextRoot}/userRoles/initial');"  class="f-fwb">返回上一层 </a>
			<input id="rolesId" hidden=hidden />
			<span class="f-ml20">角色组名称：</span><input class="f-fwb f-mt10"  readonly="readonly"  readonly id="msg_rolesName"/>
		</div>
	</div>
	<div id="div_wrapper">
		<!-- ####### 查询条件部分 ####### -->
		<div id="div_content" class="f-ww" style="height:780px ">
			<div id="div_left" class="f-w240 f-bd f-of-hd" style=" width:240px;float: left;height: 100%">
				<div class="f-mt10 f-mb10 f-ml10 f-w240">
					<input type="text" id="inp_search" placeholder="请输入视图分类名称" class="f-ml10 f-h28"/>
				</div>
				<!--资源浏览树-->
				<div id="div_tree">
					<div id="div_resource_browse_tree" style=""></div>
				</div>
			</div>
			<!--资源浏览详情-->
			<div id="div_right" class="div-resource-browse" style="float: left;width: 700px;margin-left: 10px">
				<div class="right-retrieve">
					<div class="f-db f-pt10 f-pb10 f-ml10">
						<!--输入框-->
						<input type="text" id="inp_searchNm" placeholder="请输入视图代码或名称" class="f-ml10 f-h28 f-w240" data-attr-scan="searchNm"/>
					</div>
					<div class="f-db f-fr f-pt10 f-mr10">
						<div id="btn_grant_cancel" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
							<span>取消授权</span>
						</div>
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
</div>