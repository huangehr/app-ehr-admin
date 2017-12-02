package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.resource.RsCategoryModel;
import com.yihu.ehr.agModel.resource.RsResourcesModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.model.resource.MChartInfoModel;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestClientException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

/**
 * Controller - 视图管理控制器
 * Created by yww on 2016/5/27.
 */
@Controller
@RequestMapping("/resource/resourceManage")
public class ResourceManageController extends BaseUIController {


    @RequestMapping("/initial")
    public String resourceInitial(Model model){
        model.addAttribute("contentPage","/resource/resourcemanage/newResource");
        return "pageView";
    }
    @RequestMapping("/newInitial")
    public String newResourceInitial(Model model){
        model.addAttribute("contentPage","/resource/resourcemanage/resource");
        return "pageView";
    }

    @RequestMapping("/infoInitial")
    public String resourceInterfaceInfoInitial(Model model,String id,String mode,String categoryId, String name, String dataSource){
        model.addAttribute("mode", mode);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("name", name);
        model.addAttribute("dataSource", dataSource);
        model.addAttribute("contentPage", "/resource/resourcemanage/resourceInfoDialog");
        Envelop envelop = new Envelop();
        String envelopStr = "";
        String categoryName = "";
        try{
            if(!StringUtils.isEmpty(categoryId)) {
                String url = "/resources/category/" + categoryId;
                String envelopStrGet = HttpClientUtil.doGet(comUrl + url, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
                if(envelopGet.isSuccessFlg()){
                    categoryName = getEnvelopModel(envelopGet.getObj(),RsCategoryModel.class).getName();
                }
            }
            model.addAttribute("categoryName",categoryName);
            if (!StringUtils.isEmpty(id)) {
                String url = "/resources/" + id;
                envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
        }
        return "simpleView";
    }

    /**
     * 指标配置
     * @param model
     * @param id
     * @return
     */
    @RequestMapping("/resourceConfigue")
    public String resourceConfigue(Model model, String id){
        model.addAttribute("resourceId", id);
        model.addAttribute("contentPage","/resource/resourcemanage/resoureConfigure");
        return "simpleView";
    }

    /**
     * 配置授权浏览页面跳转
     * @param model
     * @param pageName
     * @param resourceId
     * @return
     */
    @RequestMapping("/switch")
    public String switchToPage(Model model,String pageName,String resourceId){
        if("config".equals(pageName)){
            model.addAttribute("contentPage","/resource/resourceconfiguration/resourceConfiguration");
        }
        if("grant".equals(pageName)){
            model.addAttribute("contentPage","/resource/grant/grant");
        }
        if("browse".equals(pageName)){
            model.addAttribute("contentPage","/resource/resourcebrowse/resourceBrowse");
        }
        Envelop envelop = new Envelop();
        String envelopStr = "";
        try{
            if (!StringUtils.isEmpty(resourceId)) {
                String url = "/resources/"+resourceId;
                envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
        }
        return "pageView";
    }

    /**
     * 资源分页查询 -- 弃用
     * @param searchNm
     * @param categoryId
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("/resources")
    @ResponseBody
    public Object searchResources(String searchNm, String categoryId, String rolesId, String appId, Integer dataSource, int page, int rows){
        String url = "/resources";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("code?" + searchNm + " g1;name?" + searchNm + " g1;");
        }
        if(dataSource != null && dataSource != 0) {
            stringBuffer.append("dataSource=" + dataSource + ";");
        }
        if(!StringUtils.isEmpty(categoryId)){
            stringBuffer.append("categoryId=" + categoryId);
        }else {
            return envelop;
        }
        params.put("filters", "");
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        if (!StringUtils.isEmpty(rolesId)) {
            params.put("rolesId", rolesId);
        }
        if (!StringUtils.isEmpty(appId)) {
            params.put("appId", appId);
        }
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

    /**
     * 视图资源列表树
     * @param filters 过滤查询条件
     * @param dataSource 1 档案视图 2 指标视图
     * @return
     */
    @RequestMapping("/resources/tree")
    @ResponseBody
    public Envelop getResourceTree(String filters, Integer dataSource, HttpServletRequest request){
        Envelop envelop = new Envelop();
        String url = "/resources/tree";
        String resultStr = "";
        //从Session中获取用户的角色和和授权视图列表作为查询参数
        try {
            HttpSession session = request.getSession();
            boolean isAccessAll = getIsAccessAllRedis(request);
            List<String> userResourceList = getUserResourceListRedis(request);
            Map<String, Object> params = new HashMap<>();
            if (!StringUtils.isEmpty(filters)) {
                params.put("filters", filters);
            }
            if(dataSource != null && dataSource != 0) {
                params.put("dataSource", dataSource);
            }
            if(isAccessAll) {
                params.put("userResource", "*");
            }else {
                params.put("userResource", objectMapper.writeValueAsString(userResourceList));
            }
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
            return envelop;
        }
        return envelop;
    }

    /**
     * 创建或更新资源
     * @param dataJson
     * @param mode
     * @return
     */
    @RequestMapping("/update")
    @ResponseBody
    public Envelop updateResource(String dataJson, String mode, HttpServletRequest request){
        Envelop envelop = new Envelop();
        String url = "/resources";
        try{
            //RsResourcesModel model = objectMapper.readValue(dataJson, RsResourcesModel.class);
            Map<String, Object> resourceMap = objectMapper.readValue(dataJson, Map.class);
            if(resourceMap != null) {
                if (StringUtils.isEmpty(resourceMap.get("code"))) {
                    envelop.setSuccessFlg(false);
                    envelop.setErrorMsg("资源编码不能为空！");
                    return envelop;
                }
                if (StringUtils.isEmpty(resourceMap.get("name"))) {
                    envelop.setSuccessFlg(false);
                    envelop.setErrorMsg("资源名称不能为空！");
                    return envelop;
                }
                // 新增
                if ("new".equals(mode)) {
                    HttpSession session = request.getSession();
                    resourceMap.put("creator", session.getAttribute("userId"));
                    Map<String, Object> params = new HashMap<>();
                    params.put("resource", objectMapper.writeValueAsString(resourceMap));
                    String result = HttpClientUtil.doPost(comUrl + url, params, username, password);
                    Envelop envelopPost = toModel(result, Envelop.class);
                    if(envelopPost.isSuccessFlg()) {
                        Map<String, Object> rsObj = (Map<String, Object>) envelopPost.getObj();
                        List<String> userResourceList = getUserResourceListRedis(request);
                        if(userResourceList == null){
                            userResourceList = new ArrayList<>();
                        }
                        userResourceList.add(String.valueOf(rsObj.get("id")));
                        session.setAttribute(AuthorityKey.UserResource, userResourceList);
                    }
                    return envelopPost;
                } else if ("modify".equals(mode)) {
                    String urlGet = "/resources/" + resourceMap.get("id");
                    String result1 = HttpClientUtil.doGet(comUrl + urlGet, username, password);
                    Envelop envelopGet = objectMapper.readValue(result1, Envelop.class);
                    if (!envelopGet.isSuccessFlg()) {
                        envelop.setSuccessFlg(false);
                        envelop.setErrorMsg("原资源信息获取失败！");
                        return envelop;
                    }
                    Map<String, Object> rsObj = (Map<String, Object>) envelopGet.getObj();
                    resourceMap.put("creator", rsObj.get("creator").toString());
                    resourceMap.put("modifier", request.getSession().getAttribute("userId"));
                    Map<String, Object> params = new HashMap<>();
                    params.put("resource", objectMapper.writeValueAsString(resourceMap));
                    String result2 = HttpClientUtil.doPut(comUrl + url, params, username, password);
                    Envelop envelopPut = envelop = toModel(result2, Envelop.class);
                    return envelopPut;
                }
            }else {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("参数有误");
                return envelop;
            }
        }catch (Exception e){
            LogService.getLogger(ResourceManageController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 删除资源
     * @param id
     * @return
     */
    @RequestMapping("/delete")
    @ResponseBody
    public Object deleteResource(String id) {
        String url = "/resources/" + id;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        try {
            if (isRsInUse(id)){
                result.setSuccessFlg(false);
                result.setErrorMsg("已授权资源不能删除");
                return result;
            }
            if(isRsReportInUse(id)){
                result.setSuccessFlg(false);
                result.setErrorMsg("已关联报表资源不能删除");
                return result;
            }
            if (isSetReport(id)){
                result.setSuccessFlg(false);
                result.setErrorMsg("已配置报表不能删除");
                return result;
            }
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            result = objectMapper.readValue(resultStr, Envelop.class);
            if (result.isSuccessFlg()) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidDelete.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(e.getMessage());
            return result;
        }
    }

    /**
     * 资源编码唯一性验证
     * @param code
     * @return
     */
    @RequestMapping("/isExistCode")
    @ResponseBody
    public Object isExistCode(String code){
        Envelop envelop = new Envelop();
        String url = "/resources/isExistCode/"+code;
        try{
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceManageController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 资源名称唯一性验证
     * @param name
     * @return
     */
    @RequestMapping("/isExistName")
    @ResponseBody
    public Object isExistName(String name){
        Envelop envelop = new Envelop();
        String url = "/resources/isExistName";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("name",name);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceManageController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 资源分类树-页面初始化时
     * @return
     */
    @RequestMapping("/categories")
    @ResponseBody
    public Object getCategories(){
        List<RsCategoryModel> list = new ArrayList<>();
        try{
            String filters = "";
            String envelopStr = "";
            String url = "/resources/categories/all";
            Map<String,Object> params = new HashMap<>();
            params.put("filters",filters);
            envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStr,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                list = (List<RsCategoryModel>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<>(),RsCategoryModel.class);
            }
        }catch (Exception ex){
            LogService.getLogger(ResourceManageController.class).error(ex.getMessage());
        }
        return list;
    }

    /**
     * 带检索分页的查找资源分类方法,新增资源时
     * @param searchParm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("/rsCategory")
    @ResponseBody
    public Object searchRsCategory(String searchParm, HttpServletRequest request, int page, int rows){
        Envelop envelop = new Envelop();
        String url = "/resources/categories/search";
        String envelopStrGet = "";
        try {
            HttpSession session = request.getSession();
            boolean isAccessAll = getIsAccessAllRedis(request);
            List<String> userRoleList = getUserRolesListRedis(request);
            if(!isAccessAll) {
                if(null == userRoleList || userRoleList.size() <= 0) {
                    envelop.setSuccessFlg(false);
                    envelop.setErrorMsg("无权访问");
                    return envelop;
                }
            }
            Map<String, Object> params = new HashMap<>();
            if(isAccessAll) {
                params.put("roleId", "*");
            }else {
                params.put("roleId", objectMapper.writeValueAsString(userRoleList));
            }
            StringBuffer stringBuffer = new StringBuffer();
            if (!StringUtils.isEmpty(searchParm)) {
                stringBuffer.append("name?" + searchParm +";");
            }
            params.put("filters", "");
            String filters = stringBuffer.toString();
            if (!StringUtils.isEmpty(filters)) {
                params.put("filters", filters);
            }
            params.put("page", page);
            params.put("size", rows);
            envelopStrGet = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
            List<RsCategoryModel> rsCategoryModels = new ArrayList<>();
            List<Map> list = new ArrayList<>();
            if(envelopGet.isSuccessFlg()){
                rsCategoryModels = (List<RsCategoryModel>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<RsCategoryModel>(),RsCategoryModel.class);
                for (RsCategoryModel m:rsCategoryModels){
                    Map map = new HashMap<>();
                    map.put("id",m.getId());
                    map.put("name",m.getName());
                    list.add(map);
                }
                envelopGet.setDetailModelList(list);
                return envelopGet;
            }
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ResourceManageController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
            return envelop;
        }
    }

    @RequestMapping("/getResourceQuotaInfo")
    @ResponseBody
    public Object getResourceQuotaInfo(String resourceId, String name, int page, int rows){
        String url = "/resources/getQuotaList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        if (!StringUtils.isEmpty(resourceId)) {
            params.put("filters", "resourceId=" + resourceId);
        }
        if (!StringUtils.isEmpty(name)) {
            params.put("quotaName", name);
        }
        params.put("page", page);
        params.put("pageSize", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(ResourceManageController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping(value = "/addResourceQuota", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object addResourceQuota(String resourceId, String jsonModel, HttpServletRequest request) throws IOException {
        String url = "/resourceQuota/batchAddResourceQuota";
        String resultStr = "";
        Envelop result = new Envelop();
        if (!org.apache.commons.lang.StringUtils.isBlank(resourceId)) {
            url = "/resourceQuota/delRQNameByResourceId";
            Map<String, Object> params = new HashMap<>();
            params.put("resourceId", resourceId);
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

    /**
     * 指标上卷下钻预览
     * @param id
     * @param model
     * @param dimension  维度
     * @param quotaFilter 过滤条件 多个;拼接 如：org=123;city=001
     * @return
     */
    @RequestMapping("/resourceShow")
    public String resourceShow(String id ,Model model,String quotaId,String dimension,String quotaFilter,HttpServletRequest request){
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("resourceId", id);
            params.put("dimension", dimension);
            params.put("quotaId", quotaId);
            List<String> userOrgList  = (List<String>)request.getSession().getAttribute(AuthorityKey.UserOrgSaas);
            params.put("userOrgList", userOrgList);
            Map<String, Object> quotaFilterMap = new HashMap<>();
           if( !StringUtils.isEmpty(quotaFilter) ){
               String filter[] = quotaFilter.split(";");
               for(int i=0;i<filter.length;i++){
                   String [] val = filter[i].split("=");
                   quotaFilterMap.put(val[0].toString(),val[1].toString());
               }
               params.put("quotaFilter", objectMapper.writeValueAsString(quotaFilterMap));
           }
            resultStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.GetRsQuotaPreview, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.addAttribute("id", id);
        model.addAttribute("resultStr", resultStr);
        model.addAttribute("contentPage","/resource/resourcemanage/resoureShowCharts");
        return "simpleView";
    }

    /**
     * 指标预览 包含上卷 下钻
     * @param id
     * @param dimension  维度
     * @param quotaFilter 过滤条件 多个;拼接 如：org=123;city=001
     * @return
     */
    @RequestMapping("/resourceUpDown")
    @ResponseBody
    public MChartInfoModel getResourceUpDown(String id, String dimension,String quotaFilter,String quotaId,HttpServletRequest request){
        MChartInfoModel chartInfoModel = new MChartInfoModel();
        try {
            Envelop result = new Envelop();
            String resultStr = "";
            Map<String, Object> params = new HashMap<>();
            params.put("resourceId", id);
            params.put("dimension", dimension);
            params.put("quotaId", quotaId);
            List<String> userOrgList  = getUserOrgSaasListRedis(request);
            params.put("userOrgList", userOrgList);
            Map<String, Object> quotaFilterMap = new HashMap<>();
            if( !StringUtils.isEmpty(quotaFilter) ){
                String filter[] = quotaFilter.split(";");
                for(int i=0;i<filter.length;i++){
                    String [] val = filter[i].split("=");
                    quotaFilterMap.put(val[0].toString(),val[1].toString());
                }
                params.put("quotaFilter", objectMapper.writeValueAsString(quotaFilterMap));
            }
            resultStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.GetRsQuotaPreview, params, username, password);
            Envelop envelop = objectMapper.readValue(resultStr, Envelop.class);
            String s = objectMapper.writeValueAsString((HashMap<String,String>)envelop.getObj());
            chartInfoModel = objectMapper.readValue(s,MChartInfoModel.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return chartInfoModel;
    }

    /**
     * 判断资源是否已被授权
     * @param resourceId
     * @return
     * @throws Exception
     */
    public boolean isRsInUse(String resourceId) throws Exception{
        String url = "/resources/grants/no_paging";
        Map<String,Object> params = new HashMap<>();
        params.put("filters","resourceId=" + resourceId);
        String resultStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
        Envelop result = objectMapper.readValue(resultStr, Envelop.class);
        if (result.isSuccessFlg() && result.getDetailModelList().size() > 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 判断资源报表是否关联相关资源
     * @param resourceId
     * @return
     * @throws Exception
     */
    public boolean isRsReportInUse(String resourceId) throws Exception {
        String url = "/resources/reportView/existByResourceId";
        Map<String,Object> params = new HashMap<>();
        params.put("resourceId", resourceId);
        String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        Envelop envelop = objectMapper.readValue(resultStr, Envelop.class);
        return (boolean)envelop.getObj();
    }

    public Boolean isSetReport(String resourceId) throws Exception{
        String url = ServiceApi.Resources.RsReportViewExistReport;
        Map<String,Object> params = new HashMap<>();
        params.put("resourceId",resourceId);
        String resultStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
        Envelop result = objectMapper.readValue(resultStr, Envelop.class);
        if (result.isSuccessFlg()) {
            return true;
        } else {
            return false;
        }
    }


}
