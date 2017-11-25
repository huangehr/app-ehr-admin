package com.yihu.ehr.util.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by janseny on 2017/11/24.
 */
@Service
public class RedisService {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    protected ObjectMapper objectMapper;

    /**
     * 设置redis 值
     * @param
     * @param
     * @return
     */
    public Object setRedisValue(HttpServletRequest request,String key, String value) {
        String url = ServiceApi.Redis.AppSetRedisValue;
        String resultStr = "";
        Envelop result = new Envelop();
        if(value != null){
            try {
                Map<String, Object> params = new HashMap<>();
                String sessionId = request.getSession().getId();
                params.put("key", sessionId + "-" + key);
                params.put("value", value);
                System.out.println(sessionId);
                System.out.println("set  key=" + key + ",val = " + value);
                resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                return resultStr;
            } catch (Exception e) {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.SystemError.toString());
                return result;
            }
        }
        return null;
    }

    public Object setRedisObjectValue(HttpServletRequest request,String key, Object value) {
        String url = ServiceApi.Redis.AppSetRedisJsonValue;
        String resultStr = "";
        Envelop result = new Envelop();
        if(value != null){
            try {
                Map<String, Object> params = new HashMap<>();
                String sessionId = request.getSession().getId();
                params.put("key", sessionId + "-" + key);
                params.put("value", objectMapper.writeValueAsString(value));
                System.out.println(sessionId);
                System.out.println("set --- key=" + key + ",val = " + objectMapper.writeValueAsString(value));
                resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                return resultStr;
            } catch (Exception e) {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.SystemError.toString());
                return result;
            }
        }
        return null;
    }


    /**
     * 获取redis 值
     * @param
     * @param
     * @return
     */
    public String getRedisValue(HttpServletRequest request,String key) {
        String url = ServiceApi.Redis.AppGetRedisValue;
        String resultStr = "";
        Envelop result = new Envelop();
        try {
            Map<String, Object> params = new HashMap<>();
            String sessionId = request.getSession().getId();
            System.out.println("sessionId=" + sessionId);
            params.put("key", sessionId + "-" + key);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            System.out.println("get -- key=" + sessionId + "-" + key + ", value = " + resultStr);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            System.out.println(e.getMessage());
            result.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return "";
    }

    public UserDetailModel getCurrentUserRedis(HttpServletRequest request) throws IOException {
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        if(userDetailModel == null){
            userDetailModel = objectMapper.readValue(getRedisValue(request, SessionAttributeKeys.CurrentUser), UserDetailModel.class);
        }
        return  userDetailModel;
    }


    public List<String> getUserOrgSaasListRedis(HttpServletRequest request) throws IOException {
        List<String> userOrgList  = new ArrayList<>();
        if(request.getSession().getAttribute(AuthorityKey.UserOrgSaas) != null){
            userOrgList  = (List<String>)request.getSession().getAttribute(AuthorityKey.UserOrgSaas);
        }else {
            String resultRedis = getRedisValue(request,AuthorityKey.UserOrgSaas) ;
            if(org.apache.commons.lang3.StringUtils.isNotEmpty(resultRedis)){
                if(resultRedis.equals(AuthorityKey.NoUserOrgSaas)){
                    userOrgList.add(AuthorityKey.NoUserOrgSaas);
                }else {
                    userOrgList = objectMapper.readValue(resultRedis, new TypeReference<List<String>>(){} );
                }
            }
        }
        return  userOrgList;
    }


}
