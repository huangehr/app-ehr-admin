<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="utf-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@include file="/WEB-INF/ehr/commons/jsp/commonInclude.jsp" %>
<style>
  .m-form-control{display: inline-block;vertical-align: middle;}
  .mouse-pop-win{width: 140px;position: fixed;left:0;top: 0;z-index: 10;background: #fff;border: 1px solid #ccc;}
  .pop-item{line-height: 35px;text-align: center;}

  .pop-item a{display: block;color: #555a5f;}
  .pop-item a:hover{background: #00a0e9;color: #fff;}
  .pop-win{width: 460px;/*height: 200px;*/position: fixed;left:50%;top: 50%;-webkit-transform: translate(-50%,-50%);-moz-transform: translate(-50%,-50%);-ms-transform: translate(-50%,-50%);-o-transform: translate(-50%,-50%);transform: translate(-50%,-50%);z-index: 999;background: #fff;border: 1px solid #ccc;padding-bottom: 74px;}
  .pop-form{padding: 17px 0 0 0;}
  .pop-form label{display: block;position: relative;float: left;width: 130px;height: 30px;line-height: 30px;text-align: right;min-height: 1px;padding-right: 10px;padding-left: 10px;font-weight: normal;}
  .pop-form input{height: 28px;line-height: 28px;padding: 0 10px;vertical-align: middle;background-color: #fff;width: 238px;margin: 0;outline: none;color: #555555;margin-top: 1px;}
  .btns{width: 100%;position: absolute;text-align: center;bottom: 0;left: 0;padding: 20px;}
  .btn{display: inline-block;width: 98px;height: 35px;line-height: 23px;text-align: center;color: #fff;font-size: 13px;font-weight: 600;margin: 0 10px;}
  .btn:hover,.btn:focus{color: #fff;}
  .sure-btn{background: #2D9BD2;}
  .cancel-btn{background: #B9C8D2;}
  .pop-tit{height: 40px;line-height: 40px;font-size: 15px;font-weight: 600;padding-left: 10px;color: #fff;background: #2D9BD2;}
  .pop-f-hide{display: none}
  .pop-form .l-checkbox-wrapper{margin-top: 7px;}
</style>
<!--######用户管理页面Title设置######-->
<div class="f-dn" data-head-title="true"><spring:message code="title.dict.manage"/></div>
<div id="div_wrapper">
  <!-- ####### 指标分类浏览树 ####### -->
  <div id="div_content" class="f-ww contentH">
    <div id="div_left" class="f-w240 f-bd f-of-hd" style="position: relative;">
      <div style="position: absolute;left: 10px;top: 6px;">指标分类</div>
      <!--指标分类浏览树-->
      <div id="div_tree" class="f-w230 f-pt30">
        <div id="div_resource_browse_tree"></div>
      </div>
    </div>
    <!--指标详情-->
    <div id="div_right" class="div-resource-browse ">
      <div class="right-retrieve">
        <div class="m-form-control f-mt5 f-fs14 f-fwb f-ml10">
          <div>指标：</div>
        </div>
        <div class="m-form-control f-fs12">
          <input type="text" id="searchNm" placeholder="<spring:message code="lbl.input.placehold"/>">
        </div>

        <div class="m-form-control f-mr10 f-fr">
          <sec:authorize url="/tjQuota/updateTjDataSource">
            <div id="div_new_record" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam"  onclick="javascript:$.publish('zhibiao:zhiBiaoInfo:open',['','new'])">
              <span><spring:message code="btn.create"/></span>
            </div>
          </sec:authorize>
        </div>
      </div>
      <div class="div-result-msg">
        <div id="div_stdDict_grid" ></div>
      </div>
    </div>
  </div>
</div>
