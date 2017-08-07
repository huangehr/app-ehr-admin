package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Sxy on 2016/15/30.
 */
@Controller
@RequestMapping("/resourceCustomize")
public class ResourceCustomizeController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    ObjectMapper objectMapper;

    /**
     * 资源列表数
     * @return
     */
    @RequestMapping("/searchCustomizeList")
    @ResponseBody
    public Object searchCustomizeResourceList() {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/customize_list";
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("数据检索失败");
        }
        return envelop;
    }

    /**
     * 资源检索
     * @param resourcesCode
     * @param metaData
     * @param searchParams
     * @param page
     * @param rows
     * @param request
     * @return
     */
    @RequestMapping("/searchCustomizeData")
    @ResponseBody
    public Object searchCustomizeResourceData(String resourcesCode, String metaData, String searchParams, int page, int rows, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        if(resourcesCode == null || resourcesCode.equals("")) {
            return envelop;
        }
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String url = "/resources/customize_data";
        //当前用户机构
        UserDetailModel userDetailModel = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        params.put("resourcesCode", resourcesCode);
        params.put("metaData", metaData);
        /**
         * 待确认
         */
        String orgCode = userDetailModel.getOrganization();
        if(orgCode != null) {
            params.put("orgCode", userDetailModel.getOrganization());
        }
        /**
         * 暂未进行控制
         */
        params.put("appId", "JKZL");
        params.put("queryCondition", searchParams);
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("数据检索失败");
        }
        return envelop;
    }

    /**
     * 自定义视图保存
     * @param dataJson
     * @return
     */
    @RequestMapping("/updateCustomizeData")
    @ResponseBody
    public Object updateResource(String dataJson){
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/customize_update";
        params.put("dataJson", dataJson);
        try {
            String resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceController.class).error(e.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

}
