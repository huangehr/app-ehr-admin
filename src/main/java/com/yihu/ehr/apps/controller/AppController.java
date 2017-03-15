package com.yihu.ehr.apps.controller;

import com.yihu.ehr.agModel.app.AppDetailModel;
import com.yihu.ehr.agModel.resource.RsAppResourceModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.model.resource.MRsAppResource;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.url.URLQueryBuilder;
import com.yihu.ehr.web.RestTemplates;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by yww on 2015/8/12.
 */
@RequestMapping("/app")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class AppController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

//    @Autowired
//    private RestTemplates template;

    @RequestMapping("template/appInfo")
    public String appInfoTemplate(Model model, String appId, String mode) {

        String result ="";
        Object app=null;
        try {
            //mode定义：new modify view三种模式，新增，修改，查看
            if (mode.equals("new")){
                app = new AppDetailModel();
                ((AppDetailModel)app).setStatus("WaitingForApprove");
            }else{
                String url = "/apps/"+appId;
                RestTemplates template = new RestTemplates();
                result = template.doGet(comUrl+url);
                Envelop envelop = getEnvelop(result);
                if(envelop.isSuccessFlg()){
                    app = envelop.getObj();
                }
            }
        }
        catch (Exception ex)
        {
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }

        model.addAttribute("model", toJson(app));
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","/app/appInfoDialog");
        return "simpleView";
    }

    @RequestMapping("initial")
    public String appInitial(Model model) {

        model.addAttribute("contentPage","/app/appManage");
        return "pageView";
    }

    @RequestMapping("/searchApps")
    /**
     * 应用列表及特定查询
     */
    @ResponseBody
    public Object getAppList(String sourceType, String searchNm,String org, String catalog, String status, int page, int rows) {
        URLQueryBuilder builder = new URLQueryBuilder();
        if(!StringUtils.isEmpty(sourceType)){
            builder.addFilter("sourceType", "=", sourceType, null);
        }
        if (!StringUtils.isEmpty(searchNm)) {
            builder.addFilter("id", "?", searchNm, "g1");
            builder.addFilter("name", "?", searchNm, "g1");
        }
        if(!StringUtils.isEmpty(org)){
            //TODO 根据org获取orgCodes
            //builder.addFilter("org", "=", orgCodes, null);
            builder.addFilter("org", "?", org, null);
        }
        if (!StringUtils.isEmpty(catalog)) {
            builder.addFilter("catalog", "=", catalog, null);
        }
        if (!StringUtils.isEmpty(status)) {
            builder.addFilter("status", "=", status, null);
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
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }

        return resultStr;
    }

    @RequestMapping("/deleteApp")
    @ResponseBody
    public Object deleteApp(String appId) {
        Envelop result = new Envelop();
        String resultStr="";
        try {
            String url = "/apps/"+appId;
            RestTemplates template = new RestTemplates();
            resultStr = template.doDelete(comUrl+url);
            result.setSuccessFlg(getEnvelop(resultStr).isSuccessFlg());
        } catch (Exception ex) {
            result.setSuccessFlg(false);
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }
        return result;
    }

    @RequestMapping("createApp")
    @ResponseBody
    public Object createApp(AppDetailModel appDetailModel,HttpServletRequest request) {

        Envelop result = new Envelop();
        String resultStr="";
        String url="/apps";
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        //不能用 @ModelAttribute(SessionAttributeKeys.CurrentUser)获取，会与AppDetailModel中的id属性有冲突
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        appDetailModel.setCreator(userDetailModel.getId());
        conditionMap.add("app", toJson(appDetailModel));
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doPost(comUrl + url, conditionMap);
            Envelop envelop = getEnvelop(resultStr);
            if (envelop.isSuccessFlg()){
                result.setSuccessFlg(true);
                result.setObj(envelop.getObj());
            }else{
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidAppRegister.toString());
            }
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }
        return result;
    }


    @RequestMapping("updateApp")
    @ResponseBody
    public Object updateApp(AppDetailModel appDetailModel) {
//        if (appDetailModel.getDescription().equals("del")){
//            deleteApp(appDetailModel.getId());
//            return false;
//        }
        Envelop result = new Envelop();
        Envelop envelop = new Envelop();
        String resultStr="";
        String url="/apps";
        try {
            RestTemplates template = new RestTemplates();
            //获取app
            String id = appDetailModel.getId();
            MultiValueMap<String,String> map = new LinkedMultiValueMap<>();
            map.add("app_id", id);
            resultStr = template.doGet(comUrl+url+'/'+id,map);
            envelop = getEnvelop(resultStr);
            if(envelop.isSuccessFlg()){
                AppDetailModel appUpdate = getEnvelopModel(envelop.getObj(), AppDetailModel.class);
                appUpdate.setName(appDetailModel.getName());
                appUpdate.setOrg(appDetailModel.getOrg());
                appUpdate.setCatalog(appDetailModel.getCatalog());
                appUpdate.setTags(appDetailModel.getTags());
                appUpdate.setUrl(appDetailModel.getUrl());
                appUpdate.setDescription(appDetailModel.getDescription());
                appUpdate.setCode(appDetailModel.getCode());
                appUpdate.setRole(appDetailModel.getRole());
//                ========================
                appUpdate.setIcon(appDetailModel.getIcon());
                appUpdate.setReleaseFlag(appDetailModel.getReleaseFlag());
                //更新
                MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
                conditionMap.add("app", toJson(appUpdate));
                resultStr = template.doPut(comUrl + url, conditionMap);
                envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()){
                    result.setSuccessFlg(true);
                }else{
                    result.setSuccessFlg(false);
                    result.setErrorMsg("修改失败！");
                }
            }
        }
        catch (Exception ex)
        {
            LogService.getLogger(AppController.class).error(ex.getMessage());
            result.setErrorMsg(ErrorCode.SystemError.toString());
        }

        return result;
    }

    @RequestMapping("check")
    @ResponseBody
    public Object check(String appId, String status) {
        Envelop result = new Envelop();
        String urlPath = "/apps/status";
        String resultStr="";
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<>();
        conditionMap.add("app_id", appId);
        conditionMap.add("app_status", status);
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doPut(comUrl+urlPath,conditionMap);
            result.setSuccessFlg(Boolean.parseBoolean(resultStr));
        } catch (Exception e) {
            result.setSuccessFlg(false);
        }
        return result;
    }

    //-------------------------------------------------------应用---资源授权管理---开始----------------
    @RequestMapping("/resource/initial")
    public String resourceInitial(Model model, String backParams){
        model.addAttribute("backParams",backParams);
        model.addAttribute("contentPage", "/app/resource");
        return "pageView";
    }

    //获取app已授权资源ids集合
    @RequestMapping("/resourceIds")
    @ResponseBody
    public  Object getResourceIds(String appId){
        Envelop envelop = new Envelop();
        List<String> list = new ArrayList<>();
        envelop.setSuccessFlg(false);
        envelop.setDetailModelList(list);
        URLQueryBuilder builder = new URLQueryBuilder();
        if (StringUtils.isEmpty(appId)) {
            return envelop;
        }
        builder.addFilter("appId", "=", appId, null);
        builder.setPageNumber(1)
                .setPageSize(999);
        String param = builder.toString();
        String url = "/resources/grants";
        String resultStr = "";
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doGet(comUrl+url+"?"+param);
            Envelop resultGet = objectMapper.readValue(resultStr,Envelop.class);
            if(resultGet.isSuccessFlg()&&resultGet.getDetailModelList().size()!=0){
                List<RsAppResourceModel> rsAppModels = (List<RsAppResourceModel>)getEnvelopList(resultGet.getDetailModelList(),new ArrayList<RsAppResourceModel>(),RsAppResourceModel.class);
                for(RsAppResourceModel m : rsAppModels){
                    list.add(m.getResourceId());
                }
                envelop.setSuccessFlg(true);
            }
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }
        envelop.setSuccessFlg(true);
        envelop.setDetailModelList(list);
        return envelop;
    }

    @RequestMapping("/app")
    @ResponseBody
    public Object getAppById(String appId){
        Envelop envelop = new Envelop();
        try{
            String url = "/apps/"+appId;
            RestTemplates template = new RestTemplates();
            String envelopStr = template.doGet(comUrl+url);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }
        envelop.setSuccessFlg(false);
        return envelop;
    }

    //资源授权appId+resourceIds
    @RequestMapping("/resource/grant")
    @ResponseBody
    public Object resourceGrant(String appId,String resourceIds){
        Envelop envelop = new Envelop();
        try {
            String url = "/resources/apps/"+appId+"/grant";
            Map<String,Object> params = new HashMap<>();
            params.put("appId", appId);
            params.put("resourceIds", resourceIds);
            String resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }
        envelop.setSuccessFlg(false);
        return envelop;
    }

    //批量、单个取消资源授权
    @RequestMapping("/resource/cancel")
    @ResponseBody
    public Object resourceGrantCancel(String appId,String resourceIds){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        if(StringUtils.isEmpty(appId)){
            envelop.setErrorMsg("应用id不能为空！");
            return envelop;
        }
        if(StringUtils.isEmpty(resourceIds)){
            envelop.setErrorMsg("资源id不能为空！");
            return envelop;
        }
        try {
            //先获取授权关系表的ids
            String url = "/resources/grants/no_paging";
            Map<String,Object> params = new HashMap<>();
            params.put("filters","appId="+appId+";resourceId="+resourceIds);
            String envelopStrGet = HttpClientUtil.doGet(comUrl+url,params,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
            String ids = "";
            if(envelopGet.isSuccessFlg()&&envelopGet.getDetailModelList().size()!=0){
                List<MRsAppResource> list = (List<MRsAppResource>)getEnvelopList(envelopGet.getDetailModelList(),
                        new ArrayList<MRsAppResource>(),MRsAppResource.class);
                for(MRsAppResource m:list){
                    ids += m.getId()+",";
                }
                ids = ids.substring(0,ids.length()-1);
            }
            //取消资源授权
            if(!StringUtils.isEmpty(ids)){
                String urlCancel = "/resources/grants";
                Map<String,Object> args = new HashMap<>();
                args.put("ids",ids);
                String result = HttpClientUtil.doDelete(comUrl+urlCancel,args,username,password);
                return result;
            }
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    //修改、查看授权资源
    //-------------------------------------------------------应用---资源授权管理---结束----------------

    //-------------------------------------------------------应用----资源----数据元--管理开始--------------
    @RequestMapping("/resourceManage/initial")
    public String resourceManageInitial(Model model,String appId,String resourceId, String dataModel){
        model.addAttribute("dataModel",dataModel);
        model.addAttribute("appRsId",getAppResId(appId,resourceId));
        model.addAttribute("contentPage", "/app/resourceManage");
        return "pageView";
    }
    //获取应用资源关联关系id
    public String getAppResId(String appId,String resourceId) {
        URLQueryBuilder builder = new URLQueryBuilder();
        if (StringUtils.isEmpty(appId)||StringUtils.isEmpty(resourceId)) {
            return "";
        }
        builder.addFilter("appId", "=", appId, "g1");
        builder.addFilter("resourceId", "=", resourceId, "g1");
        builder.setPageNumber(1)
                .setPageSize(1);
        String param = builder.toString();
        String url = "/resources/grants";
        String resultStr = "";
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doGet(comUrl+url+"?"+param);
            Envelop resultGet = objectMapper.readValue(resultStr,Envelop.class);
            if(resultGet.isSuccessFlg()){
                List<RsAppResourceModel> rsAppModels = (List<RsAppResourceModel>)getEnvelopList(resultGet.getDetailModelList(),new ArrayList<RsAppResourceModel>(),RsAppResourceModel.class);
                RsAppResourceModel resourceModel = rsAppModels.get(0);
                return resourceModel.getId();
            }
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }
        return "";
    }

//    /**
//     * 跳转维度管理页面顶部资源信息
//     */
//    @RequestMapping("/resource")
//    @ResponseBody
//    public Object getResourceById(String resourceId){
//        Envelop envelop = new Envelop();
//        try{
//            String url = "/resources/"+resourceId;
//            RestTemplates template = new RestTemplates();
//            String envelopStr = template.doGet(comUrl+url);
//            return envelopStr;
//        }catch (Exception ex){
//            LogService.getLogger(AppController.class).error(ex.getMessage());
//        }
//        envelop.setSuccessFlg(false);
//        return envelop;
//    }
//
//    //根据资源id获取数据元列表
//    @RequestMapping("/resource/metadata")
//    @ResponseBody
//    public Object resourceMetadata(String resourceId){
//        Envelop envelop = new Envelop();
//        try{
//            String url = "/resources/"+resourceId+"/metadata_list";
//            RestTemplates template = new RestTemplates();
//            String envelopStr = template.doGet(comUrl+url);
//            return envelopStr;
//        }catch (Exception ex){
//            LogService.getLogger(AppController.class).error(ex.getMessage());
//        }
//        envelop.setSuccessFlg(false);
//        return envelop;
//
//    }

    //-------------------------------------------------------应用----资源----数据元--管理结束--------------


    @RequestMapping("/roles/tree")
    @ResponseBody
    public Object getRoleArr(){
        try {
            String url = comUrl + "/roles/platformAppRolesTree";
            Map<String,Object> params = new HashMap<>();
            params.put("type", 0);
            params.put("source_type", 1);
            String envelopStr = HttpClientUtil.doGet(url,params,username,password);
            return envelopStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failedSystem();
        }
    }

}
