package com.yihu.ehr.log.controller;

import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.operator.DateUtil;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by janseny on 2017/5/18.
 */
@Controller
@RequestMapping("/logManager")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class LogController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.adminInnerUrl}")
    private String adminInnerUrl;


    /**
     * 列表页
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String patientInitial(Model model) {
        model.addAttribute("contentPage", "/log/log");
        return "pageView";
    }

    /**
     * 根据id获取log
     * @param model
     * @param logId
     * @param mode
     * @return
     * @throws IOException
     */
    @RequestMapping("getLogByIdAndType")
    public Object getDoctor(Model model,String type, String logId, String mode) throws IOException {
        String url = "/dfs/api/v1.0/elasticSearch/" + logId ;
        String index = "";
        if("3".equals(type)){
            //总支撑业务日志
            index = "businesslog";
        }else if("2".equals(type)){
            //eip网关日志
            index = "operatorlog";
        }
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("index", index);
        params.put("type", index);
        try {
            resultStr = HttpClientUtil.doGet( adminInnerUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            model.addAttribute("logData", resultStr);
            model.addAttribute("mode", mode);
            model.addAttribute("contentPage", "log/logInfo");
            return "emptyView";
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 查找日志
     * @param
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchListLogs")
    @ResponseBody
    public Object searchListLogs(String patient,String type,String startTime ,String endTime ,String caller, int page, int rows) {
        String url = "/dfs/api/v1.0/elasticSearch/pageSort";
        String index = "";
        String sorts = "-time";
        if("3".equals(type)){
            //总支撑业务日志

            index = "businesslog";
        }else if("2".equals(type)){
            //eip网关日志
            index = "operatorlog";
        }
        String filter = "";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        if (!StringUtils.isEmpty(index)) {
            params.put("index", index);
            params.put("type", index);
        }
        filter =  "logType=" + type ;

       if (!StringUtils.isEmpty(startTime)) {
           Date startDate = DateUtil.formatCharDateYMDHMS(startTime);
           filter =  filter + ";time>=" + DateUtil.formatDate(startDate,DateUtil.DEFAULT_YMDHMSDATE_FORMAT);;
        }
        if (!StringUtils.isEmpty(endTime)) {
            Date enddate = DateUtil.formatCharDateYMDHMS(endTime);
            //enddate = DateUtil.addDate(1,enddate);
            filter =  filter + ";time<" + DateUtil.formatDate(enddate,DateUtil.DEFAULT_YMDHMSDATE_FORMAT);
        }
        if (!StringUtils.isEmpty(patient)) {
            filter =  filter + ";caller=" + patient;
        }
        params.put("filter", filter);
        params.put("sorts", sorts);
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }




}
