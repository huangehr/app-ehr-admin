package com.yihu.ehr.util.controller;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.catalina.Session;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.*;

/**
 * UI用controller工具类
 * Created by Administrator on 2016/3/16.
 */
public class BaseUIController {

    @Autowired
    protected ObjectMapper objectMapper;
    @Value("${service-gateway.username}")
    protected String username;
    @Value("${service-gateway.password}")
    protected String password;
    @Value("${service-gateway.url}")
    protected String comUrl;

    private static String ERR_SYSTEM_DES = "系统错误,请联系管理员!";

    public Envelop getEnvelop(String json){
        try {
            return objectMapper.readValue(json,Envelop.class);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    public String toJson(Object data){
        try {
            String json = objectMapper.writeValueAsString(data);
            return json;
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    public <T> T toModel(String json,Class<T> targetCls){
        try {
            T model = objectMapper.readValue(json, targetCls);
            return model;
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    /**
     *将envelop中的obj串转化为model
     * Envelop envelop = objectMapper.readValue(resultStr,Envelop.class)
     * jsonData = envelop.getObj()
     * @param jsonData
     * @param targetCls
     * @param <T>
     * @return
     */
    public <T> T getEnvelopModel(Object jsonData, Class<T> targetCls) {
        try {
            String objJsonData = objectMapper.writeValueAsString(jsonData);
            T model = objectMapper.readValue(objJsonData, targetCls);
            return model;
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    /**
     *将envelop中的DetailList串转化为模板对象集合
     *Envelop envelop = objectMapper.readValue(resultStr,Envelop.class)
     * modelList = envelop.getDetailModelList()
     * @param modelList
     * @param targets
     * @param targetCls
     * @param <T>
     * @return
     */
    public <T> Collection<T> getEnvelopList(List modelList, Collection<T> targets, Class<T> targetCls) {
        try {
            for (Object aModelList : modelList) {
                String objJsonData = objectMapper.writeValueAsString(aModelList);
                T model = objectMapper.readValue(objJsonData, targetCls);
                targets.add(model);
            }
            return targets;
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    public Envelop failed(String errMsg) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        envelop.setErrorMsg(errMsg);
        return envelop;
    }

    public Envelop success(Object object) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(true);
        envelop.setObj(object);
        return envelop;
    }
    public String encodeStr(String str) {
        try {
            if (str == null) {
                return null;
            }
            return new String(str.getBytes("ISO-8859-1"), "UTF-8");
        } catch (UnsupportedEncodingException ex) {
            return null;
        }
    }

    protected Envelop failedSystem() {
        return failed(ERR_SYSTEM_DES);
    }


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


    /**
     * 删除redis 值
     * @param
     * @param
     * @return
     */
    public Object deleteRedisValue(HttpServletRequest request,String key) {
        String url = ServiceApi.Redis.AppGetRedisValue;
        String resultStr = "";
        Envelop result = new Envelop();
        try {
            Map<String, Object> params = new HashMap<>();
            String sessionId = request.getSession().getId();
            params.put("key",sessionId + "-" + key);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }

    }

    public UserDetailModel getCurrentUserRedis(HttpServletRequest request) throws IOException {
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        if(userDetailModel == null){
            userDetailModel = objectMapper.readValue(getRedisValue(request, SessionAttributeKeys.CurrentUser), UserDetailModel.class);
        }
        return  userDetailModel;
    }

    public boolean getIsAccessAllRedis(HttpServletRequest request) throws IOException {
        boolean isAccessAll = true;
        if(request.getSession().getAttribute(AuthorityKey.IsAccessAll) != null){
            isAccessAll = (boolean)request.getSession().getAttribute(AuthorityKey.IsAccessAll);
        }else {
            isAccessAll = Boolean.parseBoolean(getRedisValue(request, AuthorityKey.IsAccessAll));
        }
        return  isAccessAll;
    }

    public List<String> getUserAreaSaasListRedis(HttpServletRequest request) throws IOException {
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

    public List<String> getUserRolesListRedis(HttpServletRequest request) throws IOException {
        List<String> userOrgList  = new ArrayList<>();
        if(request.getSession().getAttribute(AuthorityKey.UserRoles) != null){
            userOrgList  = (List<String>)request.getSession().getAttribute(AuthorityKey.UserRoles);
        }else {
            String resultRedis = getRedisValue(request,AuthorityKey.UserRoles) ;
            if(org.apache.commons.lang3.StringUtils.isNotEmpty(resultRedis)){
                if(resultRedis.equals(AuthorityKey.NoUserRole)){
                    userOrgList.add(AuthorityKey.NoUserRole);
                }else {
                    userOrgList = objectMapper.readValue(resultRedis, new TypeReference<List<String>>(){} );
                }
            }
        }
        return  userOrgList;
    }

    public List<String> getUserResourceListRedis(HttpServletRequest request) throws IOException {
        List<String> userOrgList  = new ArrayList<>();
        if(request.getSession().getAttribute(AuthorityKey.UserResource) != null){
            userOrgList  = (List<String>)request.getSession().getAttribute(AuthorityKey.UserResource);
        }else {
            String resultRedis = getRedisValue(request,AuthorityKey.UserResource) ;
            if(org.apache.commons.lang3.StringUtils.isNotEmpty(resultRedis)){
                if(resultRedis.equals(AuthorityKey.NoUserResource)){
                    userOrgList.add(AuthorityKey.NoUserResource);
                }else {
                    userOrgList = objectMapper.readValue(resultRedis, new TypeReference<List<String>>(){} );
                }
            }
        }
        return  userOrgList;
    }

}