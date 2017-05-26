package com.yihu.ehr.orgSaas.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;


/**
 * @author zlf
 * @version 1.0
 * @created 2015.08.10 17:57
 */
@Controller
@RequestMapping("/orgSaas")
public class OrgSaasController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/getOrgSaas")
    @ResponseBody
    public Object getParent(String orgCode,String type) {
        String url = "/OrgSaasByOrg";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("orgCode",orgCode);
        params.put("type",type);
        try{
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            ObjectMapper mapper = new ObjectMapper();
            Envelop envelop = mapper.readValue(resultStr, Envelop.class);
            if (envelop.isSuccessFlg()) {
                result.setObj(envelop.getDetailModelList());
                result.setSuccessFlg(true);
                return result;
            }else{
                result.setSuccessFlg(false);
                return result;
            }
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }

    }


}
