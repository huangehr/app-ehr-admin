package com.yihu.ehr.esb.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.net.httpserver.Authenticator;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.model.esb.MHosLog;
import com.yihu.ehr.patient.controller.PatientController;
import com.yihu.ehr.util.Envelop;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.RestTemplates;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
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
        model.addAttribute("contentPage", "esb/log/uploadLog");
        return "pageView";
    }


    @RequestMapping("searchHosLogs")
    @ResponseBody
    public Object searchHosLogs(String beginTime, String endTime,String  organization,int page, int rows) {

        String url = "/esb/searchHosLogs";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd ");

        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(beginTime)) {
            stringBuffer.append("uploadTime>=" + beginTime + ";");
        }
        if (!StringUtils.isEmpty(endTime)) {
            stringBuffer.append("uploadTime<=" + endTime + ";");
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
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }

    }

    @RequestMapping("clearHosLogs")
    @ResponseBody
    public Object clearHosLogs(String beginTime, String endTime,String  organization){
        Object  dataStr =  this.searchHosLogs(beginTime,endTime,organization,1,Integer.MAX_VALUE);
        String resultStr="";
        Envelop envelopLog = getEnvelop(dataStr.toString());
        Map<String, Object> params = new HashMap<String, Object>();
        Envelop envelop = new Envelop();
        if (envelopLog.isSuccessFlg()) {
            List<MHosLog> mHosLogs = (List<MHosLog>) getEnvelopList(envelopLog.getDetailModelList(), new ArrayList<MHosLog>(), MHosLog.class);
            try {
                for(MHosLog mHosLog :  mHosLogs){
                    String url = "/esb/deleteHosLogs/"+mHosLog.getId();
                    resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
                }
                return resultStr;
            }catch (Exception e) {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg(ErrorCode.SystemError.toString());
            }
            return envelop;
        }else{
            return resultStr;
        }

    }
}
