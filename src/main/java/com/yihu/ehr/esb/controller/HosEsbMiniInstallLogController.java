package com.yihu.ehr.esb.controller;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
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
 * Created by Administrator on 2015/8/12.
 */
@RequestMapping("/esb/installLog")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class HosEsbMiniInstallLogController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("initial")
    public String dictInitial(Model model) {
        model.addAttribute("contentPage","/esb/release/HosEsbMiniInstallLog");
        return "pageView";
    }
    /**
     * 查询安装记录列表根据安装包systemCode
     *
     * @return
     */
    @RequestMapping("searchInstallLogList")
    @ResponseBody
    public Object getReleaseInfoList(String systemCode,String orgCode,Integer page, Integer rows) {
        Envelop result = new Envelop();
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(systemCode)) {
            stringBuffer.append("systemCode=" + systemCode + ";");
        }
        if (!StringUtils.isEmpty(orgCode)) {
            stringBuffer.append("orgCode=" + orgCode);
        }
        String filters = stringBuffer.toString();
        if(filters.lastIndexOf(";")>0){
            filters = filters.substring(0,filters.lastIndexOf(";"));
        }
        params.put("filters", "");
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        params.put("fields", "");
        params.put("sorts", "");
        try {
            String url = "/esb/searchHosEsbMiniInstallLog";
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }
}
