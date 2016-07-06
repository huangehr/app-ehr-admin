package com.yihu.ehr.claim.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.jaxrs.json.annotation.JSONP;
import com.sun.net.httpserver.Authenticator;
import com.yihu.ehr.agModel.patient.ArApplyModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.model.esb.MHosLog;
import com.yihu.ehr.patient.controller.PatientController;
import com.yihu.ehr.util.DateTimeUtils;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.log.LogService;
import freemarker.template.SimpleDate;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @author linz
 * @version 1.0
 * @created 2016.06.21 17:57
 */
@Controller
@RequestMapping("/correlation")
public class CorrelationController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("initial")
    public String userInitial(Model model) {
        model.addAttribute("contentPage", "/claim/correlationManage");
        return "pageView";
    }

    @RequestMapping("msgDialog")
    public String msgDialog(Model model,String status,String id) {
        try{
            String url = "/archive/applications/"+id+"/archive_info";
            Map<String, Object> params = new HashMap<>();
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop result = getEnvelop(resultStr);
            if(result.getObj()!=null){
                Object list =  result.getObj();
                model.addAttribute("mode",toJson(list));
            }else{
                ArApplyModel arApplyModel =  new ArApplyModel();
                arApplyModel.setId(Integer.parseInt(id));
                model.addAttribute("mode",toJson(arApplyModel));
            }
            //审核失败的查看，
            if("view".equals(status)){
                model.addAttribute("contentPage", "/claim/correlationRejectDialog");
            }else if("-1".equals(status)){//及无内容的展示
                model.addAttribute("contentPage", "/claim/correlationValidateDialog");
                model.addAttribute("msg","数据库中未查找到相关档案列表，建议审核不通过，原因为“未查找到相关就诊机构，请您核对就诊机构信息后重新提交申请!");
            }else if("2".equals(status)){//无机构导致无内容
                model.addAttribute("contentPage", "/claim/correlationValidateDialog");
                model.addAttribute("msg","数据库中未查找到相关就诊机构，建议审核不通过，原因为“未查找到相关就诊机构，请您核对就诊机构信息后重新提交申请!");
            }else if("3".equals(status)){//无医生导致无内容
                model.addAttribute("contentPage", "/claim/correlationValidateDialog");
                model.addAttribute("msg","数据库中未查找到相关医生，建议审核不通过，原因为“未查找到就诊医生，请您核对就诊医生信息后重新提交申请!");
            }else if("4".equals(status)){//在就诊时间内，无相应就诊人就诊导致无内容
                model.addAttribute("contentPage", "/claim/correlationValidateDialog");
                model.addAttribute("msg","该时间段内未查找到相关档案，建议审核不通过，原因为“未查找到相关档案，请您核对相关信息后重新提交申请!");
            }else if("success".equals(status)){//查看预关联
                model.addAttribute("contentPage", "/claim/correlationAuditDialog");
                if(result.getDetailModelList()!=null&&result.getDetailModelList().size()==1){
                    Object list =  result.getDetailModelList().get(0);
                    model.addAttribute("archives",toJson(list));
                }else{
                    model.addAttribute("archives",toJson(new ArApplyModel()));
                }
            }
        }catch (Exception e){
            LogService.getLogger(CorrelationController.class).error(e.getMessage());
        }
        return "pageView";
    }

    @RequestMapping("getCorrelationModeList")
    @ResponseBody
    public Object getCorrelationModeList(Model model,HttpServletRequest request) throws  Exception{
        String url = "/archive/applications";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        //申请开始时间
        String beginTime = request.getParameter("beginTime");
        //申请结束时间
        String endTime = request.getParameter("endTime");
        //审核状态
        String status = request.getParameter("auditStatus");
        //申请人姓名
        String name = request.getParameter("applyName");
        //排序字段
        String sortname = request.getParameter("sortname");
        //升降序
        String sortorder = request.getParameter("sortorder");
        //第几页
        String page = request.getParameter("page");
        //界面大小
        String size = request.getParameter("rows");

        params.put("page",page);

        params.put("size",size);
        //查询条件处理
        StringBuffer queryBuffer = new StringBuffer();
        if(StringUtils.isNotBlank(beginTime)){
            beginTime=beginTime+":00";
            Date beginTimeTemp  =  DateTimeUtils.simpleDateTimeParse(beginTime);
            queryBuffer.append("applyDate>=" + DateTimeUtils.utcDateTimeFormat(beginTimeTemp)+ ";");
        }
        if(StringUtils.isNotBlank(endTime)){
            endTime=endTime+":00";
            Date endTimeTemp  =  DateTimeUtils.simpleDateTimeParse(endTime);
            queryBuffer.append("applyDate<=" + DateTimeUtils.utcDateTimeFormat(endTimeTemp)+ ";");
        }
        if (StringUtils.isNotBlank(status)) {
            queryBuffer.append("status=" + status);
        }
        if (StringUtils.isNotBlank(name)) {
            queryBuffer.append("name?" + name);
        }
        String filters = queryBuffer.toString();
        if(filters.lastIndexOf(";")>0){
            filters = filters.substring(0,filters.lastIndexOf(";"));
        }
        if (StringUtils.isNotBlank(filters)) {
            params.put("filters", filters);
        }
        //查询条件处理结束
        //排序处理
        if (StringUtils.isNotBlank(sortname)) {
            params.put("sorts", sortname+" "+sortorder);
        }
        //排序处理结束
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }

    }

    /**根据ID获取数据将数据放在OBJ字段中**/
    @RequestMapping(value = "/getModeById")
    @ResponseBody
    public Object getCorrelationModeById(String id){
        Envelop envelop = new Envelop();
        String url = "/archive/applications/"+id;
        try{
            String envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            envelop.setSuccessFlg(true);
            envelop.setObj(envelopStr);
            return envelop;
        }catch (Exception e){
            LogService.getLogger(CorrelationController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**根据ID判断是否可以审核，成功返回1 失败：-1:不存在档案列表，2:不存在对应机构，3:不存在对应的医生，4:时段内不存在患者**/
    @RequestMapping(value = "/validateAudit")
    @ResponseBody
    public String validateAudit(String id) throws Exception{
        try{
            String url = "/archive/applications/"+id+"/audit";
            Envelop envelop = new Envelop();
            String envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            if(envelop.getDetailModelList().size()>0){
                return "1";
            }else{
                return "-1";
            }
        }catch (Exception e){
            LogService.getLogger(CorrelationController.class).error(e.getMessage());
            return "-1";
        }
    }

    /**根据关联关系获取预关联档案列表**/
    @RequestMapping(value = "/getArchivesModeList")
    @ResponseBody
    public Object getArchives(String correlationModeId) throws Exception{
        Envelop envelop = new Envelop();
        try{
            String url = "/correlation/getArchivesModeList/"+correlationModeId;
            String envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            return envelopStr;
        }catch (Exception e){
            LogService.getLogger(CorrelationController.class).error(e.getMessage());
            envelop.setErrorMsg(e.getLocalizedMessage());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    /**更新档案关联审核数据**/
    @RequestMapping(value = "/updateCorrelationMode")
    @ResponseBody
    public Object updateCorrelationMode(String correlationMode){
        Envelop envelop = new Envelop();
        try{
            Map<String, Object> params = new HashMap<>();
            ArApplyModel arApplyModel = toModel(correlationMode, ArApplyModel.class);
            Date date = DateTimeUtils.simpleDateParse(arApplyModel.getApplyDate());
            String applyData = DateTimeUtils.utcDateTimeFormat(date);
            arApplyModel.setApplyDate(applyData);
            date = DateTimeUtils.simpleDateParse(arApplyModel.getAuditDate());
            applyData = DateTimeUtils.utcDateTimeFormat(date);
            arApplyModel.setAuditDate(applyData);
            params.put("model",toJson(arApplyModel));
            String url = "/archive/applications";
            String resultStr = HttpClientUtil.doPut(comUrl+url,params,username,password);
            envelop = getEnvelop(resultStr);
            return envelop;
        }catch (Exception e){
            LogService.getLogger(CorrelationController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }
}
