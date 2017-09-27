package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.resource.RsCategoryModel;
import com.yihu.ehr.agModel.resource.RsResourcesModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestClientException;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 视图管理控制器
 * Created by yww on 2016/5/27.
 */
@Controller
@RequestMapping("/resource/resourceManage")
public class ResourceController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    private ObjectMapper objectMapper;

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
     * 资源分页查询
     * @param searchNm
     * @param categoryId
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("/resources")
    @ResponseBody
    public Object searchResources(String searchNm, String categoryId, Integer dataSource, int page, int rows){
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
     * 资源列表树
     * @param filters
     * @param dataSource
     * @return
     */
    @RequestMapping("/resources/tree")
    @ResponseBody
    public Envelop getResourceTree(String filters, Integer dataSource){
        Envelop envelop = new Envelop();
        String url = "/resources/tree";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        if(dataSource != null && dataSource != 0) {
            params.put("dataSource", dataSource);
        }
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
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
    public Object updateResource(String dataJson, String mode){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        String url = "/resources";
        try{
            RsResourcesModel model = objectMapper.readValue(dataJson, RsResourcesModel.class);
            if(StringUtils.isEmpty(model.getCode())){
                envelop.setErrorMsg("资源编码不能为空！");
                return envelop;
            }
            if(StringUtils.isEmpty(model.getName())){
                envelop.setErrorMsg("资源名称不能为空！");
                return envelop;
            }
            if("new".equals(mode)){
                Map<String,Object> args = new HashMap<>();
                args.put("resource",objectMapper.writeValueAsString(model));
                String envelopStr = HttpClientUtil.doPost(comUrl + url,args,username,password);
                return envelopStr;
            } else if("modify".equals(mode)){
                String urlGet = "/resources/"+model.getId();
                String envelopGetStr = HttpClientUtil.doGet(comUrl+urlGet,username,password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    envelop.setErrorMsg("原资源信息获取失败！");
                }
                RsResourcesModel updateModel = getEnvelopModel(envelopGet.getObj(),RsResourcesModel.class);
                updateModel.setCode(model.getCode());
                updateModel.setName(model.getName());
                updateModel.setCategoryId(model.getCategoryId());
                updateModel.setRsInterface(model.getRsInterface());
                updateModel.setGrantType(model.getGrantType());
                updateModel.setDescription(model.getDescription());
                updateModel.setDataSource(model.getDataSource());
                String updateModelJson = objectMapper.writeValueAsString(updateModel);
                Map<String,Object> params = new HashMap<>();
                params.put("resource",updateModelJson);
                String envelopStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(ResourceController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
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
            result.setErrorMsg(ErrorCode.SystemError.toString());
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
            LogService.getLogger(ResourceController.class).error(ex.getMessage());
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
            LogService.getLogger(ResourceController.class).error(ex.getMessage());
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
            LogService.getLogger(ResourceController.class).error(ex.getMessage());
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
    public Object searchRsCategory(String searchParm,int page,int rows){
        String url = "/resources/categories/search";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
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
        try {
            String envelopStrGet = HttpClientUtil.doGet(comUrl + url, params, username, password);
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
        } catch (Exception ex) {
            LogService.getLogger(ResourceController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
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
            LogService.getLogger(ResourceController.class).error(ex.getMessage());
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
        String url = "/resources/getRsQuotaPreview";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("resourceId", id);
        params.put("dimension", dimension);
        params.put("quotaId", quotaId);
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        params.put("userId", userDetailModel.getId());
        try {
            Map<String, Object> quotaFilterMap = new HashMap<>();
           if( !StringUtils.isEmpty(quotaFilter) ){
               String filter[] = quotaFilter.split(";");
               for(int i=0;i<filter.length;i++){
                   String [] val = filter[i].split("=");
                   quotaFilterMap.put(val[0].toString(),val[1].toString());
               }
               params.put("quotaFilter", objectMapper.writeValueAsString(quotaFilterMap));
           }
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.addAttribute("id", id);
        model.addAttribute("resultStr", resultStr);
        model.addAttribute("contentPage","/resource/resourcemanage/resoureShowCharts");
        return "simpleView";
    }

    /**
     * 指标预览
     * @param id
     * @param dimension  维度
     * @param quotaFilter 过滤条件 多个;拼接 如：org=123;city=001
     * @return
     */
    @RequestMapping("/resourceUpDown")
    @ResponseBody
    public String getResourceUpDown(String id, String dimension,String quotaFilter,String quotaId,HttpServletRequest request){
        String url = "/resources/getRsQuotaPreview";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("resourceId", id);
        params.put("dimension", dimension);
        params.put("quotaId", quotaId);
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        params.put("userId", userDetailModel.getId());
        try {
            Map<String, Object> quotaFilterMap = new HashMap<>();
            if( !StringUtils.isEmpty(quotaFilter) ){
                String filter[] = quotaFilter.split(";");
                for(int i=0;i<filter.length;i++){
                    String [] val = filter[i].split("=");
                    quotaFilterMap.put(val[0].toString(),val[1].toString());
                }
                params.put("quotaFilter", objectMapper.writeValueAsString(quotaFilterMap));
            }
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultStr;
    }

    public Boolean isRsInUse(String resourceId) throws Exception{
        String url = "/resources/grants/no_paging";
        Map<String,Object> params = new HashMap<>();
        params.put("filters","resourceId="+resourceId);
        String resultStr = HttpClientUtil.doGet(comUrl + url,params, username, password);
        Envelop result = objectMapper.readValue(resultStr, Envelop.class);
        if (result.isSuccessFlg()&&result.getDetailModelList().size() >0) {
            return true;
        } else {
            return false;
        }
    }

}
