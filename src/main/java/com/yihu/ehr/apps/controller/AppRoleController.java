package com.yihu.ehr.apps.controller;

import com.yihu.ehr.agModel.user.RoleAppRelationModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.user.controller.UserRolesController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by wq on 2016/7/7.
 */

@Controller
@RequestMapping("/appRole")
public class AppRoleController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/app/approle/appRole");
        return "pageView";
    }

    /**
     * 应用角色组
     * 新增、
     * 修改、
     * 权限配置、
     * 应用接入、
     * 弹框、
     * @param model
     * @param jsonStr
     * @param type
     * @return
     */
    @RequestMapping("/appRoleDialog")
    public String appRoleDialog(Model model,String jsonStr,String type){

        Envelop envelop = new Envelop();
        envelop.setObj(jsonStr);
        model.addAttribute("appRoleGroupModel",toJson(envelop));
        if (!StringUtils.isEmpty(jsonStr)&&(type.equals("edit")||type.equals("sel"))){
            Map<String, Object> params = new HashMap<>();
//            String resultStr = "";
            String url = "/roles/role/"+jsonStr;
            try {
                jsonStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        String contentPage = "";
        switch (type){
            case "featrueConfig":
                contentPage = "/app/approle/featrueConfigDialog";
                model.addAttribute("jsonStr", jsonStr);
                break;
            case "appInsert":
                contentPage = "/app/approle/appInsert";
                model.addAttribute("jsonStr", jsonStr);
                break;
            case "addAppRoleGroup":
                contentPage = "/app/approle/appRoleDialog";
//                model.addAttribute("appRoleGroupModel", jsonStr);
                break;
            case "appUsers":
                contentPage = "/app/approle/appRoleUsers";
                model.addAttribute("obj", jsonStr);
                break;
            default:
                contentPage = "/app/approle/appRoleDialog";
                model.addAttribute("appRoleGroupModel",jsonStr);
                break;
        }
        model.addAttribute("Dialogtype", type);
        model.addAttribute("contentPage", contentPage);
        return "emptyView";
    }

    @RequestMapping("/searchAppRole")
    @ResponseBody
    public String searchAppRole(String searchNm, String gridType, String appRoleId, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        String url = ServiceApi.Roles.Roles;
        String resultStr = "";
        String filters = "type=0 g0;";
        filters = StringUtils.isEmpty(appRoleId)? filters : filters + "appId=" + appRoleId + " g1;";
        filters = StringUtils.isEmpty(searchNm)? filters : filters + "code?" + searchNm + " g2;name?" + searchNm + " g2;";
        if (gridType.equals("appRole")){
            url = "/apps";
            filters = StringUtils.isEmpty(searchNm) ? "" : "name?" + searchNm + " g1";
        }
        params.put("filters", filters);
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }

    @RequestMapping("/saveAppRoleGroup")
    @ResponseBody
    public String saveAppRoleGroup(String appRoleGroupModel,String saveType){
        Map<String, Object> params = new HashMap<>();
        String url = ServiceApi.Roles.Role;
        String resultStr = "";

        params.put("data_json", appRoleGroupModel);
        try {
            if (saveType.equals("add")){
                resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            }else {
                resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return resultStr;
    }

    @RequestMapping("/deleteAppRoleGroup")
    @ResponseBody
    public String deleteAppRoleGroup(String appGroupId){
        Map<String, Object> params = new HashMap<>();
        String url = "/roles/role/"+appGroupId;
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }

    @RequestMapping("/updateFeatureConfig")
    @ResponseBody
    public String updateFeatureConfig(String featureIds,String roleId){
        Map<String, Object> params = new HashMap<>();
        String url = "/roles/role_features_update";
        String resultStr = "";
        params.put("role_id", roleId);
        params.put("feature_ids", featureIds);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }

    @RequestMapping("/updateApiConfig")
    @ResponseBody
    public String updateApiConfig(String featureIds,String roleId){
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String url = "/roles/role_apis_update";
        try {
                params.put("api_ids", featureIds);
                params.put("role_id", roleId);
                resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }

    @RequestMapping("/searchFeatrueTree")
    @ResponseBody
    public Object searchFeatrueTree(String treeType,String appRoleId,String appId){
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "";
        String filters = "appId="+appId;
        if (treeType.equals("configFeatrue")){
            url = "/role_app_feature/no_paging";
            params.put("role_id", appRoleId);
        }else {
            url = ServiceApi.AppFeature.FilterFeatureNoPage;
            params.put("filters", filters);
            params.put("sorts", "+sort");
            params.put("roleId", appRoleId);
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
    @RequestMapping("/searchApiTree")
    @ResponseBody
    public Object searchApiTree(String treeType,String appRoleId,String appId){
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "";
        String filters = "appId="+appId+" g0;openLevel=1 g1";
        if (treeType.equals("configapiTree")){
            url = "/role_app_api/no_paging";
            params.put("role_id", appRoleId);
        }else {
            url = ServiceApi.AppApi.AppApisNoPage;
            params.put("filters", filters);
            params.put("roleId", appRoleId);
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

    @RequestMapping("/updateAppInsert")
    @ResponseBody
    public String updateAppInsert(String appInsertId,String appRoleId,boolean updateType){
        Map<String, Object> params = new HashMap<>();
        String url = updateType?ServiceApi.Roles.RoleApp:ServiceApi.Roles.RoleApp;
        RoleAppRelationModel roleAppRelationModel = new RoleAppRelationModel();
        String resultStr = "";
//        params.put("role_ids", appInsertId);
//        params.put("app_id", appRoleId);
        roleAppRelationModel.setAppId(appInsertId);
        roleAppRelationModel.setRoleId(Long.valueOf(appRoleId));
        params.put("data_json", toJson(roleAppRelationModel));
        try {
            if (updateType){
                resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            }else{
                params.put("app_id", appInsertId);
                params.put("role_id", appRoleId);
                resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return resultStr;
    }

    @RequestMapping("/searchInsertApps")
    @ResponseBody
    public String searchAppInsert(String searchNm,String gridType,String appRoleId,int page, int rows){
        Map<String, Object> params = new HashMap<>();
        String url = "";
        if (gridType.equals("appInsertGrid")) {
            url = "/apps";
            params.put("sort", "");
        } else {
            url = ServiceApi.Roles.RoleApps;
            params.put("sorts", "");
        }
        String resultStr = "";
        String filters = "";
        if (gridType.equals("appInsertGrid")){
            filters = StringUtils.isEmpty(searchNm)?"sourceType=0":"sourceType=0 g0;name?"+searchNm+" g1";
        }else {
            filters = "roleId="+appRoleId;
        }
        params.put("filters", filters);
        params.put("fields", "");
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return resultStr;
    }

    @RequestMapping("/isNameExistence")
    @ResponseBody
    public Object isNameExistence(String appId,String name){
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("app_id",appId);
            params.put("name",name);
            String url = ServiceApi.Roles.RoleNameExistence;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        } catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed("系统出错");
        }
    }
    @RequestMapping("/isCodeExistence")
    @ResponseBody
    public Object isCodeExistence(String appId,String code){
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("app_id",appId);
            params.put("code",code);
            String url = ServiceApi.Roles.RoleCodeExistence;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        } catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed("系统出错");
        }
    }

    //应用角色组删除人员
    @RequestMapping("/userDelete")
    @ResponseBody
    public Object roleUserDelete(String userId,String roleId) {
        if(org.apache.commons.lang.StringUtils.isEmpty(userId)){
            return failed("人员id不能为空！");
        }
        if(org.apache.commons.lang.StringUtils.isEmpty(roleId)){
            return failed("角色组id不能为空！");
        }
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("user_id",userId);
            params.put("role_id",roleId);
            String url = ServiceApi.Roles.RoleUser;
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        } catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed("系统出错");
        }
    }

    //角色一键授权
    @RequestMapping("/rolesGrantResourcesByCategoryId")
    @ResponseBody
    public Object rolesGrantResourcesByCategoryId(String rolesId,String appId, String categoryIds, String resourceIds) {
        try {
            String url = "/resource/api/v1.0" + ServiceApi.Resources.RolesGrantResourcesByCategoryId;
            Map<String, Object> params = new HashMap<>();
            params.put("rolesId", rolesId);
            params.put("appId", appId);
            params.put("categoryIds", categoryIds);
            params.put("resourceIds", resourceIds);
            String envelopStr = HttpClientUtil.doPost(adminInnerUrl + url, params, username, password);
            return envelopStr;
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
            return failed("内部服务请求失败");
        }
    }

    //角色一键取消授权
    @RequestMapping("/deleteRolesGrantResourcesByCategoryId")
    @ResponseBody
    public Object deleteRolesGrantResourcesByCategoryId(String rolesId,String appId, String categoryIds, String resourceIds) {
        try {
            String url = "/resource/api/v1.0" + ServiceApi.Resources.DeleteRolesGrantResourcesByCategoryId;
            Map<String, Object> params = new HashMap<>();
            params.put("rolesId", rolesId);
            params.put("appId", appId);
            params.put("categoryIds", categoryIds);
            params.put("resourceIds", resourceIds);
            String envelopStr = HttpClientUtil.doPost(adminInnerUrl + url, params, username, password);
            return envelopStr;
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
            return failed("内部服务请求失败");
        }
    }

}