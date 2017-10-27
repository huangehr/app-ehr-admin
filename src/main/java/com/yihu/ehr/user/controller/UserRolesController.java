package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.resource.RsReportCategoryInfoModel;
import com.yihu.ehr.agModel.resource.RsRolesResourceModel;
import com.yihu.ehr.agModel.user.RoleFeatureRelationModel;
import com.yihu.ehr.agModel.user.RoleOrgModel;
import com.yihu.ehr.agModel.user.RoleUserModel;
import com.yihu.ehr.agModel.user.RolesModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.model.resource.MRsRolesResource;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.url.URLQueryBuilder;
import com.yihu.ehr.util.web.RestTemplates;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestClientException;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

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

    @RequestMapping("/rolesBatchAddInitial")
    public String rolesBatchAddInitial(Model model,String appId) {
        model.addAttribute("contentPage", "user/roles/rolesBatchAddDialog");
        model.addAttribute("appId",appId);
        Envelop envelop = new Envelop();
        return "simpleView";
    }

    @RequestMapping("/rolesInfoInitial")
    public String rolesInfoInitial(Model model, String id, String mode,String appId) {
        model.addAttribute("contentPage", "user/roles/rolesInfoDialog");
        model.addAttribute("mode", mode);
        model.addAttribute("appId",appId);
        Envelop envelop = new Envelop();
        String en = "";
        if(mode.equals("new")){
            model.addAttribute("envelop", "{  \"obj\": \"\"}");
        }else {
            try {
                en = objectMapper.writeValueAsString(envelop);
                String url = "/roles/role/" + id;
                String envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
                model.addAttribute("envelop", envelopStr);
            } catch (Exception ex) {
                LogService.getLogger(UserRolesController.class).error(ex.getMessage());
                model.addAttribute("envelop", en);
            }
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
            if(StringUtils.isEmpty(model.getOrgCode())){
                return failed("机构不能为空！");
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
            updateModel.setOrgCode(model.getOrgCode());
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

    //角色组批量添加
    @RequestMapping("/batchAdd")
    @ResponseBody
    public Object batchAdd(String dataJson,String orgCodes) {
        String url = ServiceApi.Roles.RoleBatchAdd;
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
            if(StringUtils.isEmpty(orgCodes)){
                return failed("机构不能为空！");
            }
            Map<String,Object> args = new HashMap<>();
            args.put("data_json",dataJson);
            args.put("orgCodes",orgCodes);
            String envelopStr = HttpClientUtil.doPost(comUrl+url,args,username,password);
            return envelopStr;
        }catch(Exception ex){
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
    public Object isNameExistence(String appId,String name,String orgCode){
        try{
            String url = ServiceApi.Roles.RoleNameExistence;
            Map<String,Object> params = new HashMap<>();
            params.put("name",name);
            params.put("app_id",appId);
            params.put("type",1);
            List<Envelop> envelops = new ArrayList<>();
            String [] orgs = orgCode.split(";");
            for(int i=0;i<orgs.length ;i++){
                params.put("orgCode",orgs[i]);
                String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
                Envelop envelop = objectMapper.readValue(envelopStr, Envelop.class);
                if(envelop.isSuccessFlg()){
                    envelops.add(envelop);
                }
            }
            Envelop result = new Envelop();
            if(envelops != null && envelops.size() > 0){
                String message = "";
                for(Envelop envelop:envelops){
                    message = message + envelop.getObj() + ";";
                }
                result.setErrorMsg(message.length()>1?message.substring(0,message.length()-1):message);
                result.setSuccessFlg(true);
            }else {
                result.setSuccessFlg(false);
            }
            return result;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }
    @RequestMapping("/isCodeExistence")
    @ResponseBody
    public Object isCodeExistence(String appId,String code,String orgCode){
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("code",code);
            params.put("app_id",appId);
            params.put("orgCode",orgCode);
            params.put("type",1);
            String url = ServiceApi.Roles.RoleCodeExistence;
            List<Envelop> envelops = new ArrayList<>();
            String [] orgs = orgCode.split(";");
            for(int i=0;i<orgs.length ;i++){
                params.put("orgCode",orgs[i]);
                String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
                Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
                if(envelop.isSuccessFlg()){
                    envelops.add(envelop);
                }
            }
            Envelop result = new Envelop();
            if(envelops != null && envelops.size() > 0){
                String message = "";
                for(Envelop envelop:envelops){
                    message = message + envelop.getObj() + ";";
                }
                result.setErrorMsg(message.length()>1?message.substring(0,message.length()-1):message);
                result.setSuccessFlg(true);
            }else {
                result.setSuccessFlg(false);
            }
            return result;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    @RequestMapping("/orgDialog")
    public String orgDialog(Model model, String obj, String dialogType) {
        String dialogUrl = dialogType.equals("users")?"user/roles/rolesUsers":"user/roles/rolesOrg";
        model.addAttribute("obj", obj);
        model.addAttribute("contentPage", dialogUrl);
        return "simpleView";
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



    //-------------------------------------------------------角色组---资源授权管理---开始----------------
    @RequestMapping("/resource/initial")
    public String resourceInitial(Model model, String backParams){
        model.addAttribute("backParams",backParams);
        model.addAttribute("contentPage", "user/roles/resource");
        return "pageView";
    }

    //获取角色组已授权资源ids集合
    @RequestMapping("/rolesResourceIds")
    @ResponseBody
    public  Object getRolesResourceIds(String rolesId){
        Envelop envelop = new Envelop();
        List<String> list = new ArrayList<>();
        envelop.setSuccessFlg(false);
        envelop.setDetailModelList(list);
        URLQueryBuilder builder = new URLQueryBuilder();
        if (org.springframework.util.StringUtils.isEmpty(rolesId)) {
            return envelop;
        }
        builder.addFilter("rolesId", "=", rolesId, null);
        builder.setPageNumber(1)
                .setPageSize(999);
        String param = builder.toString();
        String url = "/resources/rolesGrants";
        String resultStr = "";
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doGet(comUrl+url+"?"+param);
            Envelop resultGet = objectMapper.readValue(resultStr,Envelop.class);
            if(resultGet.isSuccessFlg()&&resultGet.getDetailModelList().size()!=0){
                List<RsRolesResourceModel> rsRolesModels = (List<RsRolesResourceModel>)getEnvelopList(resultGet.getDetailModelList(),new ArrayList<RsRolesResourceModel>(),RsRolesResourceModel.class);
                for(RsRolesResourceModel m : rsRolesModels){
                    list.add(m.getResourceId());
                }
                envelop.setSuccessFlg(true);
            }
        } catch (Exception ex) {
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
        }
        envelop.setSuccessFlg(true);
        envelop.setDetailModelList(list);
        return envelop;
    }

    @RequestMapping("/roles")
    @ResponseBody
    public Object getRolesById(String rolesId){
        Envelop envelop = new Envelop();
        try{
            String url = "/roles/"+rolesId;
            RestTemplates template = new RestTemplates();
            String envelopStr = template.doGet(comUrl+url);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
        }
        envelop.setSuccessFlg(false);
        return envelop;
    }

    //资源授权rolesId+resourceIds
    @RequestMapping("/resource/rolesGrant")
    @ResponseBody
    public Object resourceGrant(String rolesId,String resourceIds){
        Envelop envelop = new Envelop();
        try {
            String url = "/resources/roles/"+rolesId+"/grant";
            Map<String,Object> params = new HashMap<>();
            params.put("rolesId", rolesId);
            params.put("resourceIds", resourceIds);
            String resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
        }
        envelop.setSuccessFlg(false);
        return envelop;
    }

    //批量、单个取消资源授权
    @RequestMapping("/resource/cancel")
    @ResponseBody
    public Object resourceGrantCancel(String rolesId,String resourceIds){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        if(org.springframework.util.StringUtils.isEmpty(rolesId)){
            envelop.setErrorMsg("角色组id不能为空！");
            return envelop;
        }
        if(org.springframework.util.StringUtils.isEmpty(resourceIds)){
            envelop.setErrorMsg("资源id不能为空！");
            return envelop;
        }
        try {
            //先获取授权关系表的ids
            String url = "/resources/rolesGrants/no_paging";
            Map<String,Object> params = new HashMap<>();
            params.put("filters","rolesId="+rolesId+";resourceId="+resourceIds);
            String envelopStrGet = HttpClientUtil.doGet(comUrl+url,params,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
            String ids = "";
            if(envelopGet.isSuccessFlg()&&envelopGet.getDetailModelList().size()!=0){
                List<MRsRolesResource> list = (List<MRsRolesResource>)getEnvelopList(envelopGet.getDetailModelList(),
                        new ArrayList<MRsRolesResource>(),MRsRolesResource.class);
                for(MRsRolesResource m:list){
                    ids += m.getId()+",";
                }
                ids = ids.substring(0,ids.length()-1);
            }
            //取消资源授权
            if(!org.springframework.util.StringUtils.isEmpty(ids)){
                String urlCancel = "/resources/rolesGrants";
                Map<String,Object> args = new HashMap<>();
                args.put("ids",ids);
                String result = HttpClientUtil.doDelete(comUrl+urlCancel,args,username,password);
                return result;
            }
        } catch (Exception ex) {
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }


    /**
     * 资源文件上传
     * @param
     * @return
     */
    @RequestMapping("rolesIconFileUpload")
    @ResponseBody
    public Object orgLogoFileUpload(
            @RequestParam("iconFile") MultipartFile file) throws IOException {
        Envelop result = new Envelop();
        InputStream inputStream = file.getInputStream();
        String fileName = file.getOriginalFilename(); //获取文件名
        if (!file.isEmpty()) {
            return  uploadFile(inputStream,fileName);
        }
        return "fail";
    }

    public String uploadFile(InputStream inputStream,String fileName){
        try {
            //读取文件流，将文件输入流转成 byte
            int temp = 0;
            int bufferSize = 1024;
            byte tempBuffer[] = new byte[bufferSize];
            byte[] fileBuffer = new byte[0];
            while ((temp = inputStream.read(tempBuffer)) != -1) {
                fileBuffer = ArrayUtils.addAll(fileBuffer, ArrayUtils.subarray(tempBuffer, 0, temp));
            }
            inputStream.close();
            String restStream = Base64.getEncoder().encodeToString(fileBuffer);
            String url = "";
            url = fileUpload(restStream,fileName);
            if (!org.springframework.util.StringUtils.isEmpty(url)){
                System.out.println("上传成功");
                return url;
            }else{
                System.out.println("上传失败");
            }

        } catch (Exception e) {
            return "fail";
        }
        return "fail";
    }

    /**
     * 图片上传
     * @param inputStream
     * @param fileName
     * @return
     */
    public String fileUpload(String inputStream,String fileName){

        RestTemplates templates = new RestTemplates();
        Map<String, Object> params = new HashMap<>();

        String url = null;
        if (!org.springframework.util.StringUtils.isEmpty(inputStream)) {

            //mime  参数 doctor 需要改变  --  需要从其他地方配置
            FileResourceModel fileResourceModel = new FileResourceModel("","org","");
            String fileResourceModelJsonData = toJson(fileResourceModel);

            params.put("file_str", inputStream);
            params.put("file_name", fileName);
            params.put("json_data",fileResourceModelJsonData);
            try {
                url = HttpClientUtil.doPost(comUrl + "/filesReturnUrl", params,username,password);
                return url;
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        return url;
    }



    //修改、查看授权资源
    //-------------------------------------------------------角色组---资源授权管理---结束----------------

    //-------------------------------------------------------角色组----资源----数据元--管理开始--------------
    @RequestMapping("/resourceManage/initial")
    public String resourceManageInitial(Model model,String rolesId,String resourceId, String dataModel){
        model.addAttribute("dataModel",dataModel);
        model.addAttribute("rolesRsId",getRolesResId(rolesId,resourceId));
        model.addAttribute("contentPage", "user/roles/resourceManage");
        return "pageView";
    }
    //获取角色组-资源关联关系id
    public String getRolesResId(String rolesId,String resourceId) {
        URLQueryBuilder builder = new URLQueryBuilder();
        if (org.springframework.util.StringUtils.isEmpty(rolesId)|| org.springframework.util.StringUtils.isEmpty(resourceId)) {
            return "";
        }
        builder.addFilter("rolesId", "=", rolesId, null);
        builder.addFilter("resourceId", "=", resourceId,null);
        builder.setPageNumber(1)
                .setPageSize(1);
        String param = builder.toString();
        String url = "/resources/rolesGrants";
        String resultStr = "";
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doGet(comUrl+url+"?"+param);
            Envelop resultGet = objectMapper.readValue(resultStr,Envelop.class);
            if(resultGet.isSuccessFlg()){
                List<RsRolesResourceModel> rsRolesModels = (List<RsRolesResourceModel>)getEnvelopList(resultGet.getDetailModelList(),new ArrayList<RsRolesResourceModel>(),RsRolesResourceModel.class);
                RsRolesResourceModel resourceModel = rsRolesModels.get(0);
                return resourceModel.getId();
            }
        } catch (Exception ex) {
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
        }
        return "";
    }
    @RequestMapping("/rfConfig")
    public String rfConfig(String id, Model model) {
        model.addAttribute("id", id);
        model.addAttribute("contentPage", "user/roles/rfConfig");
        return "pageView";
    }

    //资源报表分类树数据-获取所有分类及对应的资源的不分页方法
    @RequestMapping("/categoriesAndReport")
    @ResponseBody
    public Object getCategoriesAndReport(String roleId, String name){
        Envelop envelop = new Envelop();
        try{
            String filters = "";
            String envelopStr = "";
            String url = "/roles/report/getCategoryAndReportNoPage";
            Map<String,Object> params = new HashMap<>();
            if (!StringUtils.isEmpty(name)) {
                params.put("filters", "name?" + name);
            } else {
                params.put("filters", filters);
            }
            params.put("roleId", roleId);
            envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping(value = "/addRoleReportRelation", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object addRoleReportRelation(String roleId, String jsonModel, HttpServletRequest request) throws IOException {
        String url = "/roles/role_report/batchAddRoleReportRelation";
        String resultStr = "";
        Envelop result = new Envelop();
        if (!StringUtils.isBlank(roleId)) {
            url = "/roles/role_report/deleteByRoleId";
            Map<String, Object> params = new HashMap<>();
            params.put("roleId", Long.valueOf(roleId));
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


    //获取所有有效机构列表
    @RequestMapping("/searchOrgs")
    @ResponseBody
    public Object searchOrgs(String searchNm,int page, int rows) {
        String url = "/organizations";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("fullName?" + searchNm + ";");
        }
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

    //用户角色组添加机构
    @RequestMapping("/orgCreate")
    @ResponseBody
    public Object roleOrgCreate(String orgCode,String roleId) {
        if(StringUtils.isEmpty(orgCode)){
            return failed("机构不能为空！");
        }
        if(StringUtils.isEmpty(roleId)){
            return failed("角色组id不能为空！");
        }
        RoleOrgModel model = new RoleOrgModel();
        model.setRoleId(Long.parseLong(roleId));
        model.setOrgCode(orgCode);
        try{
            String url = ServiceApi.Roles.RoleOrg;
            Map<String,Object> params = new HashMap<>();
            params.put("data_json",objectMapper.writeValueAsString(model));
            String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //用户角色组删除机构
    @RequestMapping("/orgDelete")
    @ResponseBody
    public Object roleOrgDelete(String orgCode,String roleId) {
        if(StringUtils.isEmpty(orgCode)){
            return failed("机构不能为空！");
        }
        if(StringUtils.isEmpty(roleId)){
            return failed("角色组id不能为空！");
        }
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("org_code",orgCode);
            params.put("role_id",roleId);
            String url = ServiceApi.Roles.RoleOrg;
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //角色组人员配置机构列表查询
    @RequestMapping("/roleOrgList")
    @ResponseBody
    public Object getRoleOrgList(String searchNm,int page,int rows){
        if(StringUtils.isEmpty(searchNm)){
            return failed("角色组id不能为空");
        }
        try{
            String url = ServiceApi.Roles.RoleOrgs;
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

    //获取用户角色组配置的所有 机构
    @RequestMapping("/roleOrgByRoleId")
    @ResponseBody
    public Object getRoleOrgListNoPage(String roleId){
        if(StringUtils.isEmpty(roleId)){
            return failed("角色组id不能为空");
        }
        try{
            String url = ServiceApi.Roles.RoleOrgsNoPage;
            Map<String,Object> params = new HashMap<>();
            params.put("filters","roleId="+roleId);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(UserRolesController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }
}
