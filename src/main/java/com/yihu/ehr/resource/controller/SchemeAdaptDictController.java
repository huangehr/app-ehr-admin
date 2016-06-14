package com.yihu.ehr.resource.controller;


import com.yihu.ehr.api.ServiceApi;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.log.LogService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * 资源适配管理方案适配管理
 * Created by linz on 2015/11/1.
 */

@RequestMapping("/schemeAdaptDict")
@Controller
public class SchemeAdaptDictController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;


    @RequestMapping("/dictlist")
    @ResponseBody
    public Object searchmetaData(String adapterSchemeId, String code, int page, int rows) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<String, Object>();
        StringBuffer stringBuffer = new StringBuffer();
        if(StringUtils.isNotBlank(adapterSchemeId)){
            stringBuffer.append("schemeId=").append(adapterSchemeId).append(";");
        }else{
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("请选择资源适配方案");
            return envelop;
        }
        if(StringUtils.isNotBlank(code)){
            stringBuffer.append("srcDictCode=").append(code).append(";");
        }
        params.put("filters", "");
        params.put("page", page);
        params.put("size", rows);
        String filters = stringBuffer.toString();
        if(filters.lastIndexOf(";")>0){
            filters = filters.substring(0,filters.lastIndexOf(";"));
        }
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        try {
            String resultStr ="";
            String url = "/adaptions/adapter/dictionaries";
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    /**
     * 资源适配：新增、修改窗口
     * @param model
     * @param dataJson
     * @return
     */
    @RequestMapping("save")
    @ResponseBody
    public Object updatesSchemeAdpatDict(Model model,String dataJson) {
        Envelop result = new Envelop();
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        try{
            params.put("jsonData",dataJson);
            String url = "/adaptions/adapter/dictionaries";
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            return resultStr;
        }catch(Exception ex){
            LogService.getLogger(SchemeAdaptController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
      }
    }
