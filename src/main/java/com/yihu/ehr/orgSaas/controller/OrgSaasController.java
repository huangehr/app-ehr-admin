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
    public Object getParent(String orgCode, String type,String saasName) {
        String url = "/OrgSaasByOrg";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("orgCode", orgCode);
        params.put("type", type);
        params.put("saasName", saasName);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            ObjectMapper mapper = new ObjectMapper();
            Envelop envelop = mapper.readValue(resultStr, Envelop.class);
            if (envelop.isSuccessFlg()) {
                result.setSuccessFlg(true);
                result.setDetailModelList(envelop.getDetailModelList());
                result.setObj(envelop.getObj());
                return result;
            } else {
                result.setSuccessFlg(false);
                return result;
            }
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }

    }


    /**
     * 机构授权检查并保存
     *
     * @return
     */
    @RequestMapping("/orgSaasSave")
    public Object saveOrgSaas(String orgCode, String type, String jsonData) {
        String url = "/orgSaasSave";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("orgCode",orgCode);
        params.put("type",type);
        params.put("jsonData",jsonData);
        try {
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            ObjectMapper mapper = new ObjectMapper();
            Envelop envelop = mapper.readValue(resultStr, Envelop.class);
            if (envelop.isSuccessFlg()) {
                result.setSuccessFlg(true);
                result.setDetailModelList(envelop.getDetailModelList());
                return result;
            } else {
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