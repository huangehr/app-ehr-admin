package com.yihu.ehr.log.controller;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

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
    @Value("${service-gateway.url}")
    private String comUrl;


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
     * 查找日志
     * @param
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchLogs")
    @ResponseBody
    public Object searchLogs(String logType,String data,String startTime ,String endTime ,String caller, int page, int rows) {
        String url = "/getLogList";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        if (!StringUtils.isEmpty(logType)) {
            params.put("logType", logType);
        }
        if (!StringUtils.isEmpty(data)) {
            params.put("data", data);
        }
        if (!StringUtils.isEmpty(startTime)) {
            params.put("startTime", startTime);
        }
        if (!StringUtils.isEmpty(endTime)) {
            params.put("endTime", endTime);
        }
        if (!StringUtils.isEmpty(caller)) {
            params.put("caller", caller);
        }
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }




}
