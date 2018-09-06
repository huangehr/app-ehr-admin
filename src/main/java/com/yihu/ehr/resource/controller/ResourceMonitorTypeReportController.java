package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.resource.RsMonitorTypeReportModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by janseny on 2017/11/8.
 */

@Controller
@RequestMapping("/resource/monitorTypeReport")
public class ResourceMonitorTypeReportController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/initial")
    public String resourceBrowseInitial(Model model,String dataModel) {
        model.addAttribute("contentPage", "/resource/reportMonitorType/monitorTypeReport");
        model.addAttribute("dataModel",dataModel);
        return "pageView";
    }

    /**
     * 报表分页查询
     */
    @RequestMapping("/search")
    @ResponseBody
    public Object search(String searchNm, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        StringBuffer filters = new StringBuffer();

        if (!org.apache.commons.lang3.StringUtils.isEmpty(searchNm)) {
            filters.append("code?" + searchNm + " g1;name?" + searchNm + " g1;");
        }

        params.put("filters", filters.toString());
        params.put("page", page);
        params.put("size", rows);

        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReports, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    //监测类型添加报表
    @RequestMapping("/reportCreate")
    @ResponseBody
    public Object reportCreate(String reportId,String monitorTypeId) {
        if(org.apache.commons.lang.StringUtils.isEmpty(reportId)){
            return failed("报表不能为空！");
        }
        if(org.apache.commons.lang.StringUtils.isEmpty(monitorTypeId)){
            return failed("监测类型id不能为空！");
        }
        RsMonitorTypeReportModel model = new RsMonitorTypeReportModel();
        model.setReportId(Integer.valueOf(reportId));
        model.setRsReoportMonitorTypeId(Integer.valueOf(monitorTypeId));
        try{
            String url = ServiceApi.Resources.RsMonitorTypeReport;
            Map<String,Object> params = new HashMap<>();
            params.put("data_json",objectMapper.writeValueAsString(model));
            String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    //监测类型删除报表
    @RequestMapping("/reportDelete")
    @ResponseBody
    public Object reportDelete(String reportId,String monitorTypeId) {
        if(org.apache.commons.lang.StringUtils.isEmpty(reportId)){
            return failed("报表不能为空！");
        }
        if(org.apache.commons.lang.StringUtils.isEmpty(monitorTypeId)){
            return failed("监测类型id不能为空！");
        }
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("reportId",reportId);
            params.put("monitorTypeId",monitorTypeId);
            String url = ServiceApi.Resources.RsMonitorTypeReport;
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    //监测类型配置报表列表查询
    @RequestMapping("/monitorTypeReportList")
    @ResponseBody
    public Object getMonitorTypeReportList(String searchNm,int page,int rows){
        if(org.apache.commons.lang.StringUtils.isEmpty(searchNm)){
            return failed("监测类型id不能为空！");
        }
        try{
            String url = ServiceApi.Resources.RsMonitorTypeReports;
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters","rsReoportMonitorTypeId="+searchNm);
            params.put("page",page);
            params.put("size",rows);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    //获取监测类型配置的所有 报表
    @RequestMapping("/monitorTypeReportByMonitorTypeId")
    @ResponseBody
    public Object getMonitorTypeReportByMonitorTypeId(String monitorTypeId){
        if(org.apache.commons.lang.StringUtils.isEmpty(monitorTypeId)){
            return failed("监测类型id不能为空！");
        }
        try{
            String url = ServiceApi.Resources.RsMonitorTypeReportsNoPage;
            Map<String,Object> params = new HashMap<>();
            params.put("filters","rsReoportMonitorTypeId="+monitorTypeId);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

}
