package com.yihu.ehr.util.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import javax.servlet.http.HttpServletRequest;
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


    public UsersModel getCurrentUserRedis(HttpServletRequest request) throws IOException {
        UsersModel userDetailModel = (UsersModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        return  userDetailModel;
    }

    public boolean getIsAccessAllRedis(HttpServletRequest request) throws IOException {
        boolean isAccessAll = true;
        if(request.getSession().getAttribute(AuthorityKey.IsAccessAll) != null){
            isAccessAll = (boolean)request.getSession().getAttribute(AuthorityKey.IsAccessAll);
        }
        return  isAccessAll;
    }

    public List<String> getUserAreaSaasListRedis(HttpServletRequest request) throws IOException {
        List<String> userOrgList  = new ArrayList<>();
        if(request.getSession().getAttribute(AuthorityKey.UserOrgSaas) != null){
            userOrgList  = (List<String>)request.getSession().getAttribute(AuthorityKey.UserOrgSaas);
        }
        return  userOrgList;
    }


    public List<String> getUserOrgSaasListRedis(HttpServletRequest request) throws IOException {
        List<String> userOrgList  = new ArrayList<>();
        if(request.getSession().getAttribute(AuthorityKey.UserOrgSaas) != null){
            userOrgList  = (List<String>)request.getSession().getAttribute(AuthorityKey.UserOrgSaas);
        }
        return  userOrgList;
    }

    public List<String> getUserRolesListRedis(HttpServletRequest request) throws IOException {
        List<String> userRoleList  = new ArrayList<>();
        if(request.getSession().getAttribute(AuthorityKey.UserRoles) != null){
            userRoleList  = (List<String>)request.getSession().getAttribute(AuthorityKey.UserRoles);
        }
        return  userRoleList;
    }

    public List<String> getUserResourceListRedis(HttpServletRequest request) throws IOException {
        List<String> userResourceList  = new ArrayList<>();
        if(request.getSession().getAttribute(AuthorityKey.UserResource) != null){
            userResourceList  = (List<String>)request.getSession().getAttribute(AuthorityKey.UserResource);
        }
        return  userResourceList;
    }

}