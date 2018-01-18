<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true">用户角色管理</div>
<div id="div_wrapper" style="overflow: hidden;position: relative">
	<div style="width: 100%" id="grid_content" style="overflow: hidden;position: relative">
		<!--######平台应用列表######-->
		<div id="div_left" style=" width:300px;float: left;">
			<div id="std_app" class="m-retrieve-area f-h50 f-dn f-pr m-form-inline" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px">
				<div class="m-form-group f-mt10">
					<div class="f-mt5 f-fs14 f-ml10 f-fl f-fwb f-mr10">
						<span id="left_title">平台应用：</span>
					</div>
					<div class="m-form-control f-fs12">
						<input type="text" id="inp_search" placeholder="请输入应用名称">
					</div>
				</div>
			</div>
			<div id="div_std_app_grid" ></div>
		</div>

		<!--  应用角色组   -->
		<div id="div_right" style="/*float: right;width:calc(100% - 300px - 20px);margin-left: 10px*/position: absolute;left: 310px;right: 0;top: 0;bottom: 0;">
			<div id="std_roles" class="m-retrieve-area f-dn f-pr m-form-inline" style="display:block;border: 1px solid #D6D6D6;border-bottom: 0px">
				<div class="m-form-group f-mt10" style="padding-bottom: 0">
					<div class="f-mt5 f-fs14 f-ml10 f-fl f-fwb f-mr10 f-mb10">
						<span id="ssf">应用角色组：</span>
					</div>
					<div class="m-form-control f-fs12 f-mb10">
						<input type="text" id="inp_searchNm" placeholder="请输入角色组编码或名称">
					</div>
					<%--<div class="m-form-control f-ml20">--%>
						<%--<!--搜索按钮-->--%>
						<%--<div id="btn_roles_search" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >--%>
							<%--<span><spring:message code="btn.search"/></span>--%>
						<%--</div>--%>
					<%--</div>--%>
					<sec:authorize url="/userRoles/update">
					<div class="m-form-control f-mr20 f-mb10" style="float: right">
						<div id="div_new_record" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
							<span><spring:message code="btn.create"/></span>
						</div>
					</div>
					</sec:authorize>

					<sec:authorize url="/userRoles/batchAddRoles">
						<div class="m-form-control f-mr20 f-mb10" style="float: right">
							<div id="div_new_batchAddRoles" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >
								<span>批量添加角色</span>
							</div>
						</div>
					</sec:authorize>

				</div>
			</div>
			<div id="div_roles_grid" ></div>
		</div>
	</div>
</div>