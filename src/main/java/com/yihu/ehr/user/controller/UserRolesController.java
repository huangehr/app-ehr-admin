package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.user.RoleFeatureRelationModel;
import com.yihu.ehr.agModel.user.RoleUserModel;
import com.yihu.ehr.agModel.user.RolesModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.url.URLQueryBuilder;
import com.yihu.ehr.util.web.RestTemplates;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by yww on 2016/7/6.
 */
@RequestMapping("/userRoles")
@Controller
public class UserRolesController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    private ObjectMapper objectMapper;

    @RequestMapping("/initial")
    public String rolesInitial(Model model) {
        model.addAttribute("contentPage", "user/roles/roles");
        return "pageView";
    }

    @RequestMapping("/rolesInfoInitial")
    public String rolesInfoInitial(Model model, String id, String mode,String appId) {
        model.addAttribute("contentPage", "user/roles/rolesInfoDialog");
        model.addAttribute("mode", mode);
        model.addAttribute("appId",appId);
        Envelop envelop = new Envelop();
        String en = "";
        try {
            en = objectMapper.writeValueAsString(envelop);
            String url = "/roles/role/" + id;
            String envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            model.addAttribute("envelop", envelopStr);
        } catch (Exception ex) {
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            model.addAttribute("envelop", en);
        }
        return "simpleView";
    }
    //角色组增改
    @RequestMapping("/update")
    @ResponseBody
    public Object rolesUpdate(String dataJson, String mode) {
        String url = ServiceApi.Roles.Role;
        try{
            RolesModel model = objectMapper.readValue(dataJson,RolesModel.class);
            if(StringUtils.isEmpty(model.getName())){
                return failed("角色组名称不能为空！");
            }
            if(StringUtils.isEmpty(model.getCode())){
                return failed("角色组编码不能为空！");
            }
            if(StringUtils.isEmpty(model.getType())){
                return failed("角色组类型不能为空！");
            }
            if(StringUtils.isEmpty(model.getAppId())){
                return failed("应用id不能为空！");
            }
            if("new".equals(mode)){
                Map<String,Object> args = new HashMap<>();
                args.put("data_json",dataJson);
                String envelopStr = HttpClientUtil.doPost(comUrl+url,args,username,password);
                return envelopStr;
            }
            String urlGet = url+"/"+model.getId();
            String envelopGetStr = HttpClientUtil.doGet(comUrl+urlGet,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);
            if (!envelopGet.isSuccessFlg()){
                return failed("原角色组信息获取失败！");
            }
            RolesModel updateModel = getEnvelopModel(envelopGet.getObj(),RolesModel.class);
            updateModel.setCode(model.getCode());
            updateModel.setName(model.getName());
            updateModel.setAppId(model.getAppId());
            updateModel.setType(model.getType());
            updateModel.setDescription(model.getDescription());
            String updateModelJson = objectMapper.writeValueAsString(updateModel);
            Map<String,Object> params = new HashMap<>();
            params.put("data_json",updateModelJson);
            String envelopStr = HttpClientUtil.doPut(comUrl+url,params,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //角色组删除
    @RequestMapping("/delete")
    @ResponseBody
    public Object rolesDelete(String id) {
        if(StringUtils.isEmpty(id)){
            return failed("角色组id不能为空！");
        }
        try{
            String url = "/roles/role/"+id;
            Map<String,Object> params = new HashMap<>();
            params.put("id",id);
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //角色组列表查询
    @RequestMapping("/search")
    @ResponseBody
    public Object searchRoles(String searchNm, String appId, int page, int rows) {
        if(StringUtils.isEmpty(appId)){
            return failed("应用id不能为空！");
        }
        StringBuffer buffer = new StringBuffer();
        //buffer.append("type=1;appId="+appId+";");
        buffer.append("appId="+appId+";");
        if (!StringUtils.isEmpty(searchNm)) {
            buffer.append("name?" + searchNm+" g0;code?"+searchNm+" g0");
        }
        String filters = buffer.toString();
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("fields", "");
            params.put("filters", filters);
            params.put("sorts", "");
            params.put("size", rows);
            params.put("page", page);
            String url = "/roles/roles";
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return envelopStr;
        } catch (Exception ex) {
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //用户角色组列表查询，不分页，用于下拉列表框
    @RequestMapping("/rolesForForm")
    @ResponseBody
    public Object getRolesForForm(){
        try{
            String url = ServiceApi.Roles.RoleUsersNoPage;
            Map<String,Object> params = new HashMap<>();
            //type=1,为用户角色
            //params.put("filters","type=1");
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    @RequestMapping("/isNameExistence")
    @ResponseBody
    public Object isNameExistence(String appId,String name){
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("name",name);
            params.put("app_id",appId);
            String url = ServiceApi.Roles.RoleNameExistence;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }
    @RequestMapping("/isCodeExistence")
    @ResponseBody
    public Object isCodeExistence(String appId,String code){
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("code",code);
            params.put("app_id",appId);
            String url = ServiceApi.Roles.RoleCodeExistence;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    @RequestMapping("/configDialog")
    public String configDialog(Model model, String obj, String dialogType) {
        String dialogUrl = dialogType.equals("users")?"user/roles/rolesUsers":"user/roles/rolesFeature";
        model.addAttribute("obj", obj);
        model.addAttribute("contentPage", dialogUrl);
        return "simpleView";
    }

    //用户角色组添加人员
    @RequestMapping("/userCreate")
    @ResponseBody
    public Object roleUserCreate(String userId,String roleId) {
        if(StringUtils.isEmpty(userId)){
            return failed("人员id不能为空！");
        }
        if(StringUtils.isEmpty(roleId)){
            return failed("角色组id不能为空！");
        }
        RoleUserModel model = new RoleUserModel();
        model.setRoleId(Long.parseLong(roleId));
        model.setUserId(userId);
        try{
            String url = ServiceApi.Roles.RoleUser;
            Map<String,Object> params = new HashMap<>();
            params.put("data_json",objectMapper.writeValueAsString(model));
            String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //用户角色组删除人员
    @RequestMapping("/userDelete")
    @ResponseBody
    public Object roleUserDelete(String userId,String roleId) {
        if(StringUtils.isEmpty(userId)){
            return failed("人员id不能为空！");
        }
        if(StringUtils.isEmpty(roleId)){
            return failed("角色组id不能为空！");
        }
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("user_id",userId);
            params.put("role_id",roleId);
            String url = ServiceApi.Roles.RoleUser;
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //获取所有有效用户列表
    @RequestMapping("/searchUsers")
    @ResponseBody
    public Object searchUsers(String searchNm,int page, int rows) {
        String url = "/users";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("realName?" + searchNm + ";");
        }
        stringBuffer.append("activated=true;");
        String filters = stringBuffer.toString();
        params.put("fields","");
        params.put("sorts","");
        params.put("filters", filters);
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }

    }

    //用户角色组人员配置列表查询
    @RequestMapping("/roleUserList")
    @ResponseBody
    public Object getRoleUserList(String searchNm,int page,int rows){
        if(StringUtils.isEmpty(searchNm)){
            return failed("角色组id不能为空");
        }
        try{
            String url = ServiceApi.Roles.RoleUsers;
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters","roleId="+searchNm);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //获取用户角色组配置的所有人员
    @RequestMapping("/roleUsersByRoleId")
    @ResponseBody
    public Object getRoleUserListNoPage(String roleId){
        if(StringUtils.isEmpty(roleId)){
            return failed("角色组id不能为空");
        }
        try{
            String url = ServiceApi.Roles.RoleUsersNoPage;
            Map<String,Object> params = new HashMap<>();
            params.put("filters","roleId="+roleId);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //角色组权限配置（增加）
    @RequestMapping("/featureCreate")
    @ResponseBody
    public Object roleFeatureCreate(String roleId,String featureId) {
        if(StringUtils.isEmpty(featureId)){
            return failed("人员id不能为空！");
        }
        if(StringUtils.isEmpty(roleId)){
            return failed("角色组id不能为空！");
        }
        RoleFeatureRelationModel model = new RoleFeatureRelationModel();
        model.setRoleId(Long.parseLong(roleId));
        model.setFeatureId(Long.parseLong(featureId));
        try{
            String url = ServiceApi.Roles.RoleFeature;
            Map<String,Object> params = new HashMap<>();
            params.put("data_json",objectMapper.writeValueAsString(model));
            String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //角色组权限配置（删除）
    @RequestMapping("/featureDelete")
    @ResponseBody
    public Object roleFeatureDelete(String roleId,String featureId){
        if(StringUtils.isEmpty(roleId)){
            return failed("角色组id不能为空！");
        }
        if(StringUtils.isEmpty(featureId)){
            return failed("权限id不能为空！");
        }
        try{
            String url = ServiceApi.Roles.RoleFeature;
            Map<String,Object> params = new HashMap<>();
            params.put("role_id",roleId);
            params.put("feature_id",featureId);
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //查找平台应用列表
    @RequestMapping("/searchApps")
    @ResponseBody
    public Object getAppList(String searchNm, int page, int rows) {
        URLQueryBuilder builder = new URLQueryBuilder();
        //builder.addFilter("sourceType","=","1","");
        if (!StringUtils.isEmpty(searchNm)) {
            builder.addFilter("name", "?", searchNm,"");
        }
        builder.setPageNumber(page)
                .setPageSize(rows);
        String param = builder.toString();
        String url = "/apps";
        String resultStr = "";
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doGet(comUrl+url+"?"+param);
        } catch (Exception ex) {
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
        }
        return resultStr;
    }

    @RequestMapping("/searchFeatrueTree")
    @ResponseBody
    public Object searchFeatrueTree(String treeType,String roleId){
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "";
        String filters = "";
        if (treeType.equals("configFeatrueTree")){
            url = "/role_app_feature/no_paging";
            params.put("role_id", roleId);
        }else {
            url = ServiceApi.AppFeature.FilterFeatureNoPage;
            params.put("filters", filters);
            params.put("roleId", roleId);
        }
        String resultStr = "";

        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return envelop.getDetailModelList();
    }

    @RequestMapping("/updateFeatureConfig")
    @ResponseBody
    public String updateFeatureConfig(String userFeatureId,String roleId,boolean updateType){
        Map<String, Object> params = new HashMap<>();
        String url = updateType?ServiceApi.Roles.RoleFeature:ServiceApi.Roles.RoleFeature;
        String resultStr = "";
        try {
            if (updateType){
                RoleFeatureRelationModel Model = new RoleFeatureRelationModel();
                Model.setFeatureId(Long.valueOf(userFeatureId));
                Model.setRoleId(Long.valueOf(roleId));
                params.put("data_json", toJson(Model));
                resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            }else{
                params.put("feature_id", userFeatureId);
                params.put("role_id", roleId);
                resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }
}
