package com.yihu.ehr.apps.controller;

import com.yihu.ehr.agModel.app.AppDetailModel;
import com.yihu.ehr.agModel.fileresource.FileResourceModel;
import com.yihu.ehr.agModel.resource.RsAppResourceModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.model.resource.MRsAppResource;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.service.GetInfoService;
import com.yihu.ehr.util.url.URLQueryBuilder;
import com.yihu.ehr.util.web.RestTemplates;
import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

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
    @Autowired
    private GetInfoService getInfoService;

    @RequestMapping("template/appInfo")
    public String appInfoTemplate(Model model, String appId, String mode) {

        String result = "";
        Object app = null;
        try {
            //mode定义：new modify view三种模式，新增，修改，查看
            if (mode.equals("new")) {
                app = new AppDetailModel();
                ((AppDetailModel) app).setStatus("WaitingForApprove");
            } else {
                String url = "/apps/" + appId;
                RestTemplates template = new RestTemplates();
                result = template.doGet(comUrl + url);
                Envelop envelop = getEnvelop(result);
                if (envelop.isSuccessFlg()) {
                    app = envelop.getObj();
                }
            }
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }

        model.addAttribute("model", toJson(app));
        model.addAttribute("mode", mode);
        model.addAttribute("contentPage", "/app/appInfoDialog");
        return "emptyView";
    }

    @RequestMapping("initial")
    public String appInitial(Model model) {

        model.addAttribute("contentPage", "/app/appManage");
        return "pageView";
    }

    @RequestMapping("/searchApps")
    /**
     * 应用列表及特定查询
     */
    @ResponseBody
    public Object getAppList(String sourceType, String searchNm, String org, String catalog, String status, int page, int rows, HttpServletRequest request) {
        URLQueryBuilder builder = new URLQueryBuilder();
        if (!StringUtils.isEmpty(sourceType)) {
            builder.addFilter("sourceType", "=", sourceType, null);
        }
        if (!StringUtils.isEmpty(searchNm)) {
            builder.addFilter("id", "?", searchNm, "g1");
            builder.addFilter("name", "?", searchNm, "g1");
        }
        if (!StringUtils.isEmpty(org)) {
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
       /* String orgCode = getInfoService.getOrgCode();
        if (!StringUtils.isEmpty(orgCode)) {
            builder.addFilter("org", "=", orgCode, null);
        } else {
            builder.addFilter("org", "=", null, null);
        }*/

        String appsId = getInfoService.appIdList(request);
        if (!StringUtils.isEmpty(appsId) && !"admin".equals(appsId)) {
            builder.addFilter("id", "=", appsId, null);
        } else if (StringUtils.isEmpty(appsId)) {
            builder.addFilter("id", "=", null, null);
        }
        builder.setPageNumber(page)
                .setPageSize(rows);
        builder.addSorter("createTime", false);
        String param = builder.toString();
        String url = "/apps";
        String resultStr = "";
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doGet(comUrl + url + "?" + param);
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }

        return resultStr;
    }

    @RequestMapping("/deleteApp")
    @ResponseBody
    public Object deleteApp(String appId) {
        Envelop result = new Envelop();
        String resultStr = "";
        try {
            String url = "/apps/" + appId;
            RestTemplates template = new RestTemplates();
            resultStr = template.doDelete(comUrl + url);
            result.setSuccessFlg(getEnvelop(resultStr).isSuccessFlg());
        } catch (Exception ex) {
            result.setSuccessFlg(false);
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }
        return result;
    }

    @RequestMapping("createApp")
    @ResponseBody
    public Object createApp(AppDetailModel appDetailModel, HttpServletRequest request) {

        Envelop result = new Envelop();
        String resultStr = "";
        String url = "/apps";
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        try {
            if(null!=appDetailModel&&appDetailModel.getCode().length()>30){
                return failed("应用代码长度不超过30");
            }
            //不能用 @ModelAttribute(SessionAttributeKeys.CurrentUser)获取，会与AppDetailModel中的id属性有冲突
            UsersModel userDetailModel = getCurrentUserRedis(request);
            appDetailModel.setCreator(userDetailModel.getId());
            conditionMap.add("app", toJson(appDetailModel));
            RestTemplates template = new RestTemplates();
            resultStr = template.doPost(comUrl + url, conditionMap);
            Envelop envelop = getEnvelop(resultStr);
            if (envelop.isSuccessFlg()) {
                result.setSuccessFlg(true);
                result.setObj(envelop.getObj());
            } else {
                return failed("注册失败");
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
        String resultStr = "";
        String url = "/apps";
        try {
            if(null!=appDetailModel&&appDetailModel.getCode().length()>30){
                return failed("应用代码长度不超过30");
            }
            RestTemplates template = new RestTemplates();
            //获取app
            String id = appDetailModel.getId();
            MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
            map.add("app_id", id);
            resultStr = template.doGet(comUrl + url + '/' + id, map);
            envelop = getEnvelop(resultStr);
            if (envelop.isSuccessFlg()) {
                AppDetailModel appUpdate = getEnvelopModel(envelop.getObj(), AppDetailModel.class);
                appUpdate.setName(appDetailModel.getName());
                appUpdate.setOrg(appDetailModel.getOrg());
                appUpdate.setCatalog(appDetailModel.getCatalog());
                appUpdate.setTags(appDetailModel.getTags());
                appUpdate.setUrl(appDetailModel.getUrl());
                appUpdate.setOutUrl(appDetailModel.getOutUrl());
                appUpdate.setDescription(appDetailModel.getDescription());
                appUpdate.setCode(appDetailModel.getCode());
                appUpdate.setRole(appDetailModel.getRole());
                String icon = appDetailModel.getIcon();
                if (!StringUtils.isEmpty(icon)) {
                    icon = icon.substring(icon.indexOf("group1"), icon.length()).replace("group1/", "group1:");
                    appUpdate.setIcon(icon);
                }
                appUpdate.setReleaseFlag(appDetailModel.getReleaseFlag());
                appUpdate.setManageType(appDetailModel.getManageType());
                appUpdate.setSourceType(appDetailModel.getSourceType());
                appUpdate.setDoctorManageType(appDetailModel.getDoctorManageType());
                //更新
                MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
                conditionMap.add("app", toJson(appUpdate));
                resultStr = template.doPut(comUrl + url, conditionMap);
                envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    result.setSuccessFlg(true);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg("修改失败！");
                }
            }
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
            return failed("系统错误");
        }

        return result;
    }

    @RequestMapping("check")
    @ResponseBody
    public Object check(String appId, String status) {
        Envelop result = new Envelop();
        String urlPath = "/apps/status";
        String resultStr = "";
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<>();
        conditionMap.add("app_id", appId);
        conditionMap.add("app_status", status);
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doPut(comUrl + urlPath, conditionMap);
            result.setSuccessFlg(Boolean.parseBoolean(resultStr));
        } catch (Exception e) {
            result.setSuccessFlg(false);
        }
        return result;
    }

    //-------------------------------------------------------应用---资源授权管理---开始----------------
    @RequestMapping("/resource/initial")
    public String resourceInitial(Model model, String backParams) {
        model.addAttribute("backParams", backParams);
        model.addAttribute("contentPage", "/app/resource");
        return "emptyView";
    }

    //获取app已授权资源ids集合
    @RequestMapping("/resourceIds")
    @ResponseBody
    public Object getResourceIds(String appId) {
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
            resultStr = template.doGet(comUrl + url + "?" + param);
            Envelop resultGet = objectMapper.readValue(resultStr, Envelop.class);
            if (resultGet.isSuccessFlg() && resultGet.getDetailModelList().size() != 0) {
                List<RsAppResourceModel> rsAppModels = (List<RsAppResourceModel>) getEnvelopList(resultGet.getDetailModelList(), new ArrayList<RsAppResourceModel>(), RsAppResourceModel.class);
                for (RsAppResourceModel m : rsAppModels) {
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
    public Object getAppById(String appId) {
        Envelop envelop = new Envelop();
        try {
            String url = "/apps/" + appId;
            RestTemplates template = new RestTemplates();
            String envelopStr = template.doGet(comUrl + url);
            return envelopStr;
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
        }
        envelop.setSuccessFlg(false);
        return envelop;
    }

    //资源授权appId+resourceIds
    @RequestMapping("/resource/grant")
    @ResponseBody
    public Object resourceGrant(String appId, String resourceIds) {
        Envelop envelop = new Envelop();
        try {
            String url = "/resources/apps/" + appId + "/grant";
            Map<String, Object> params = new HashMap<>();
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
    public Object resourceGrantCancel(String appId, String resourceIds) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        if (StringUtils.isEmpty(appId)) {
            envelop.setErrorMsg("应用id不能为空！");
            return envelop;
        }
        if (StringUtils.isEmpty(resourceIds)) {
            envelop.setErrorMsg("资源id不能为空！");
            return envelop;
        }
        try {
            //先获取授权关系表的ids
            String url = "/resources/grants/no_paging";
            Map<String, Object> params = new HashMap<>();
            params.put("filters", "appId=" + appId + ";resourceId=" + resourceIds);
            String envelopStrGet = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopStrGet, Envelop.class);
            String ids = "";
            if (envelopGet.isSuccessFlg() && envelopGet.getDetailModelList().size() != 0) {
                List<MRsAppResource> list = (List<MRsAppResource>) getEnvelopList(envelopGet.getDetailModelList(),
                        new ArrayList<MRsAppResource>(), MRsAppResource.class);
                for (MRsAppResource m : list) {
                    ids += m.getId() + ",";
                }
                ids = ids.substring(0, ids.length() - 1);
            }
            //取消资源授权
            if (!StringUtils.isEmpty(ids)) {
                String urlCancel = "/resources/grants";
                Map<String, Object> args = new HashMap<>();
                args.put("ids", ids);
                String result = HttpClientUtil.doDelete(comUrl + urlCancel, args, username, password);
                return result;
            }
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
            return failed("系统出错");

        }
        return envelop;
    }


    /**
     * 资源文件上传
     *
     * @param
     * @return
     */
    @RequestMapping("appIconFileUpload")
    @ResponseBody
    public Object orgLogoFileUpload(
            @RequestParam("iconFile") MultipartFile file) throws IOException {
        Envelop result = new Envelop();
        InputStream inputStream = file.getInputStream();
        String fileName = file.getOriginalFilename(); //获取文件名
        if (!file.isEmpty()) {
            return uploadFile(inputStream, fileName);
        }
        return "fail";
    }

    public String uploadFile(InputStream inputStream, String fileName) {
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
            url = fileUpload(restStream, fileName);
            if (!StringUtils.isEmpty(url)) {
                System.out.println("上传成功");
                return url;
            } else {
                System.out.println("上传失败");
            }

        } catch (Exception e) {
            return "fail";
        }
        return "fail";
    }

    /**
     * 图片上传
     *
     * @param inputStream
     * @param fileName
     * @return
     */
    public String fileUpload(String inputStream, String fileName) {

        RestTemplates templates = new RestTemplates();
        Map<String, Object> params = new HashMap<>();

        String url = null;
        if (!StringUtils.isEmpty(inputStream)) {

            //mime  参数 doctor 需要改变  --  需要从其他地方配置
            FileResourceModel fileResourceModel = new FileResourceModel("", "org", "");
            String fileResourceModelJsonData = toJson(fileResourceModel);

            params.put("file_str", inputStream);
            params.put("file_name", fileName);
            params.put("json_data", fileResourceModelJsonData);
            try {
                url = HttpClientUtil.doPost(comUrl + "/filesReturnUrl", params, username, password);
                return url;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return url;
    }



    //修改、查看授权资源
    //-------------------------------------------------------应用---资源授权管理---结束----------------

    //-------------------------------------------------------应用----资源----数据元--管理开始--------------
    @RequestMapping("/resourceManage/initial")
    public String resourceManageInitial(Model model, String appId, String resourceId, String dataModel) {
        model.addAttribute("dataModel", dataModel);
        model.addAttribute("appRsId", getAppResId(appId, resourceId));
        model.addAttribute("contentPage", "/app/resourceManage");
        return "pageView";
    }

    //获取应用资源关联关系id
    public String getAppResId(String appId, String resourceId) {
        URLQueryBuilder builder = new URLQueryBuilder();
        if (StringUtils.isEmpty(appId) || StringUtils.isEmpty(resourceId)) {
            return "";
        }
        builder.addFilter("appId", "=", appId, null);
        builder.addFilter("resourceId", "=", resourceId, null);
        builder.setPageNumber(1)
                .setPageSize(1);
        String param = builder.toString();
        String url = "/resources/grants";
        String resultStr = "";
        try {
            RestTemplates template = new RestTemplates();
            resultStr = template.doGet(comUrl + url + "?" + param);
            Envelop resultGet = objectMapper.readValue(resultStr, Envelop.class);
            if (resultGet.isSuccessFlg()) {
                List<RsAppResourceModel> rsAppModels = (List<RsAppResourceModel>) getEnvelopList(resultGet.getDetailModelList(), new ArrayList<RsAppResourceModel>(), RsAppResourceModel.class);
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
    public Object getRoleArr() {
        try {
            String url = comUrl + "/roles/platformAppRolesTree";
            Map<String, Object> params = new HashMap<>();
            params.put("type", 0);
            params.put("source_type", 1);
            String envelopStr = HttpClientUtil.doGet(url, params, username, password);
            return envelopStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failedSystem();
        }
    }

    //获取平台应用
    @RequestMapping("/getAppTreeByType")
    @ResponseBody
    public Object getAppTreeByType() {
        try {
            String url = "/getAppTreeByType";
            Map<String, Object> params = new HashMap<>();
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
//            Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
            return envelopStr;
        } catch (Exception ex) {
            LogService.getLogger(AppController.class).error(ex.getMessage());
            return failed("内部服务请求失败");
        }
    }

    //应用一键授权
    @RequestMapping("/grantByCategoryId")
    @ResponseBody
    public Object grantByCategoryId(String appId, String categoryIds, String resourceIds) {
        System.out.print("---");
        try {
            String url = "/resource/api/v1.0" + ServiceApi.Resources.AppsGrantResourcesByCategoryId;
            Map<String, Object> params = new HashMap<>();
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

    //应用一键取消授权
    @RequestMapping("/deleteAppsGrantResourcesByCategoryId")
    @ResponseBody
    public Object deleteAppsGrantResourcesByCategoryId(String appId, String categoryIds, String resourceIds) {
        try {
            String url = "/resource/api/v1.0" + ServiceApi.Resources.DeleteAppsGrantResourcesByCategoryId;
            Map<String, Object> params = new HashMap<>();
            params.put("appId", appId);
            params.put("categoryIds", categoryIds);
            params.put("resourceIds", resourceIds);
            String envelopStr = HttpClientUtil.doPost(adminInnerUrl + url, params, username, password);
            return envelopStr;
        } catch (Exception ex){
            LogService.getLogger(AppController.class).error(ex.getMessage());
            return failed("内部服务请求失败");
        }
    }

}
