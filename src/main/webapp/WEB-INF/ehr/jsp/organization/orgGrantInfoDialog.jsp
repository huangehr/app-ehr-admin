<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>

<input value="${orgCode}" class="f-dn" id="inp_orgCode"/>
<div id="div_feature_config" style="position: relative;">
	<div class="div-grant-btn div-quyu active" data-saved="false"></div>
	<div class="div-grant-btn div-jigou" data-saved="false"></div>
	<div class="m-form-group">
		<div class="f-fr  f-mt10 f-mr10 l-button u-btn u-btn-primary u-btn-large f-ib f-vam close-toolbar div-roleGroup-btn"
			 id="div_featrue_save_btn">
			<span>保存</span>
		</div>
	</div>
	<!--######区域数据授权######-->
	<div class="f-mw100 div-area-grant">
		<div class="f-mw50 f-ds1 f-fl f-ml10  f-mt10" style="height: 450px">
			<div class="f-mw100 f-fl f-mt5 f-mb5">
				<label class="f-lh30 f-ml10 f-fl lab-title-msg">功能权限：</label>
				<div class="f-fl">
					<input type="text" id="inp_fun_featrue_search" placeholder="请输入名称" class="f-ml10"/>
				</div>
			</div>
			<hr class="f-mt5 f-mb10 f-mw100">
			<div class="div-appRole-grid-scrollbar" style="width: 100%;height: 390px;">
				<div id="div_function_featrue_grid"></div>
			</div>
		</div>
		<div class="f-mw50 f-ds1 f-fr f-mr10 f-mt10" style="height: 450px">
			<label class="f-mt10 f-ml10 f-mh26">已配置权限</label>
			<hr class="f-mt5 f-mb10">
			<div class="div-appRole-grid-scrollbar" style="width: 100%;height: 390px;">
				<div id="div_configFun_featrue_grid"></div>
			</div>
		</div>
	</div>

	<!--######机构数据授权######-->
	<div class="f-mw100 div-org-grant f-dn">
		<div class="f-mw50 f-ds1 f-fl f-ml10 f-mt10" style="height: 450px">
			<div class="f-mw100 f-fl f-mt5 f-mb5">
				<label class="f-lh30 f-ml10 f-fl lab-title-msg">功能权限：</label>
				<div class="f-fl">
					<input type="text" id="inp_fun_featrue_org_search" placeholder="请输入名称" class="f-ml10"/>
				</div>
			</div>
			<hr class="f-mt5 f-mb10 f-mw100">
			<div class="div-appRole-grid-scrollbar" style="width: 100%;height: 390px;">
				<div id="div_function_featrue_org_grid"></div>
			</div>
		</div>
		<div class="f-mw50 f-ds1 f-fr f-mr10 f-mt10" style="height: 450px">
			<label class="f-mt10 f-ml10 f-mh26">已配置权限</label>
			<hr class="f-mt5 f-mb10">

			<div class="div-appRole-grid-scrollbar">
				<div id="div_configFun_featrue_org_grid" style="width: 100%;height: 390px;"></div>
			</div>
		</div>
	</div>

</div>

