package com.yihu.ehr.util.service;

import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang.StringUtils;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/7/19.
 */
@Service
public class GetInfoService {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    public String getOrgCode(HttpServletRequest request) throws IOException {
        String userId = getCurrentUserId(request);
        String url ="/userInfo/getOrgCode";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }

    public String getUserId(HttpServletRequest request) throws IOException {
        String userId = getCurrentUserId(request);
        String url ="/getUserIdList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }

    public String getDistrictList(HttpServletRequest request) throws IOException {
        String userId = getCurrentUserId(request);
        String url ="/getDistrictList";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }

    private String getCurrentUserId(HttpServletRequest request) throws IOException {
        BaseUIController baseUIController = new BaseUIController();
        UserDetailModel user = baseUIController.getCurrentUserRedis(request);
        return user.getId();
    }

    /**
     * 获取登录用户所属角色组下的应用Id
     * @return
     */
    public String appIdList(HttpServletRequest request) {
        String resultStr = "";
        try {
            BaseUIController baseUIController = new BaseUIController();
            List<String> userOrgList  = baseUIController.getUserOrgSaasListRedis(request);
            if (null == userOrgList) {
                return "admin";
            }
            String userId = getCurrentUserId(request);
            String url ="/BasicInfo/getAppIdsByUserId";
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }

    /**
     * 获取登录用户所属角色的机构下的用户身份证号码
     * @return
     */
    public String idCardNoList(HttpServletRequest request) {
        String resultStr = "";
        try {
            BaseUIController baseUIController = new BaseUIController();
            List<String> userOrgList  = baseUIController.getUserOrgSaasListRedis(request);
            if (null == userOrgList) {
                return "admin";
            }
            String orgCode = StringUtils.join(userOrgList, ",");
            String url ="/BasicInfo/getIdCardNoByOrgCode";
            Map<String, Object> params = new HashMap<>();
            params.put("orgCode", orgCode);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }
}
