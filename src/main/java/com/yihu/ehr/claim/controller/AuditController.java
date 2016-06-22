package com.yihu.ehr.claim.controller;

import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by wq on 2016/6/21.
 */

@Controller
@RequestMapping("/audit")
public class AuditController extends BaseUIController{

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/initial")
    public String initial(Model model){
        model.addAttribute("contentPage","claim/audit");
        return "pageView";
    }

    @RequestMapping("/saveAudit")
    @ResponseBody
    public String saveAudit(String applyId,String matchingId){
        String url = "/audit/saveAudit/";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("applyId", applyId);
        params.put("matchingId", matchingId);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);

        } catch (Exception e) {

        }
        return resultStr;
    }

    @RequestMapping("/updateClaim")
    @ResponseBody
    public String updateClaim(String ClaimId,String unrelevance){
        String url = "/audit/updateClaim/";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("ClaimId", ClaimId);
        params.put("unrelevance", unrelevance);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);

        } catch (Exception e) {

        }
        return resultStr;
    }
}
