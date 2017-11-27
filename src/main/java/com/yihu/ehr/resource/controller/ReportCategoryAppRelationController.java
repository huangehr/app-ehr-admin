package com.yihu.ehr.resource.controller;

import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by wxw on 2017/11/24.
 */
@Controller
@RequestMapping("/resource/reportCategoryApp")
public class ReportCategoryAppRelationController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;


    @RequestMapping("/saveInfo")
    @ResponseBody
    public Object save(String categoryId, String appId) {
        String url = "/resources/reportCategory/saveCategoryApp";
        Envelop envelop = new Envelop();
        String result = "";
        Map<String, Object> params = new HashMap<>();
        params.put("reportCategoryId", categoryId);
        params.put("appId", appId);
        try {
            result = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setErrorMsg("请求发生异常");
            return envelop;
        }
    }

    @RequestMapping("/deleteInfo")
    @ResponseBody
    public Object delete(String categoryId, String appId) {
        String url = "/resources/reportCategory/deleteCategoryApp";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("reportCategoryId", categoryId);
        params.put("appId", appId);
        try {
            String result = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setErrorMsg("请求发生异常");
            return envelop;
        }
    }
}
