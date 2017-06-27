package com.yihu.ehr.tjQuota.controller;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.client.RestClientException;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2017/6/15.
 */
@Controller
@RequestMapping("/tjQuotaDimensionMain")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class TjQuotaDimensionSlaveController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 添加主维度子表
     * @param jsonModel 维度子表信息的json串
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "addTjQuotaDimensionSlave", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object addTjQuotaDimensionSlave(String quotaCode, String jsonModel, HttpServletRequest request) throws IOException {
        String url = "/tj/addTjQuotaDimensionSlave";
        String resultStr = "";
        Envelop result = new Envelop();
        if (!StringUtils.isBlank(quotaCode)) {
            url = "/tj/deleteSlaveByQuotaCode";
            Map<String, Object> params = new HashMap<>();
            params.put("quotaCode", quotaCode);
            try {
                resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            } catch (Exception e) {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.SystemError.toString());
                return result;
            }
            return resultStr;
        }
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("model", jsonModel);
        RestTemplates templates = new RestTemplates();
        try {
            resultStr = templates.doPost(comUrl + url, params);
        } catch (RestClientException e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
        return resultStr;
    }
}
