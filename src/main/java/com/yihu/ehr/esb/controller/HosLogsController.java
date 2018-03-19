package com.yihu.ehr.esb.controller;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.util.DateTimeUtils;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @author zlf
 * @version 1.0
 * @created 2015.08.10 17:57
 */
@Controller
@RequestMapping("/hosLogs")
public class HosLogsController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("initial")
    public String userInitial(Model model) {
        model.addAttribute("contentPage", "/esb/log/hosLogs");
        return "pageView";
    }


    @RequestMapping("searchHosLogs")
    @ResponseBody
    public Object searchHosLogs(String beginTime, String endTime,String  organization,int page, int rows) {

        String url = "/esb/searchHosLogs";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(beginTime)) {
            try{
                Date beginTimeTemp  =  DateTimeUtils.simpleDateTimeParse(beginTime);
                stringBuffer.append("uploadTime>=" + DateTimeUtils.utcDateTimeFormat(beginTimeTemp)+ ";");
            } catch (Exception e){
                e.printStackTrace();
                return failed(ERR_SYSTEM_DES);
            }

        }
        if (!StringUtils.isEmpty(endTime)) {
            try{
                Date endTimeTemp  =  DateTimeUtils.simpleDateTimeParse(endTime);
                stringBuffer.append("uploadTime<=" + DateTimeUtils.utcDateTimeFormat(endTimeTemp)+ ";");
            } catch (Exception e){
                e.printStackTrace();
                return failed(ERR_SYSTEM_DES);
            }
        }
        if (!StringUtils.isEmpty(organization)) {
            stringBuffer.append("orgCode=" + organization);
        }
        params.put("filters", "");
        String filters = stringBuffer.toString();
        if(filters.lastIndexOf(";")>0){
            filters = filters.substring(0,filters.lastIndexOf(";"));
        }
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }

        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }

    @RequestMapping("clearHosLogs")
    @ResponseBody
    public Object clearHosLogs(String beginTime, String endTime,String  organization){
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(beginTime)) {
            try{
                Date beginTimeTemp  =  DateTimeUtils.simpleDateTimeParse(beginTime);
                stringBuffer.append("uploadTime>=" + DateTimeUtils.utcDateTimeFormat(beginTimeTemp)+ ";");
            }catch (Exception e){
                e.printStackTrace();
                return failed(ERR_SYSTEM_DES);
            }
        }
        if (!StringUtils.isEmpty(endTime)) {
            try{
                Date endTimeTemp  =  DateTimeUtils.simpleDateTimeParse(endTime);
                stringBuffer.append("uploadTime<=" + DateTimeUtils.utcDateTimeFormat(endTimeTemp)+ ";");
            }catch (Exception e){
                e.printStackTrace();
                return failed(ERR_SYSTEM_DES);
            }
        }
        if (!StringUtils.isEmpty(organization)) {
            stringBuffer.append("orgCode=" + organization);
        }
        params.put("filters", "");
        String filters = stringBuffer.toString();
        if(filters.lastIndexOf(";")>0){
            filters = filters.substring(0,filters.lastIndexOf(";"));
        }
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        String url = "/esb/deleteHosLogs";
        try{
            HttpClientUtil.doDelete(comUrl + url, params, username, password);
            envelop.setSuccessFlg(true);
            return envelop;
        }catch (Exception e){
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }
}
