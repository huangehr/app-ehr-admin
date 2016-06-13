package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.resource.RsCategoryModel;
import com.yihu.ehr.agModel.resource.RsResourcesModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.util.Envelop;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
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
    ObjectMapper objectMapper;

    @RequestMapping("/initial")
    public String resourceInitial(Model model,String backParams){
        model.addAttribute("contentPage","/resource/resourcemanage/resource");
        model.addAttribute("backParams",backParams==""?"{\"categoryIds\":\"\",\"sourceFilter\":\"\"}":backParams);
        return "pageView";
    }
    @RequestMapping("/infoInitial")
    public String resourceInterfaceInfoInitial(Model model,String id,String mode,String categoryId){
        model.addAttribute("mode",mode);
        model.addAttribute("categoryId",categoryId);
        model.addAttribute("contentPage","/resource/resourcemanage/resourceInfoDialog");
        Envelop envelop = new Envelop();
        String envelopStr = "";
        String categoryName = "";
        try{
            if(!StringUtils.isEmpty(categoryId)) {
                String url = "/resources/categories/"+categoryId;
                String envelopStrGet = HttpClientUtil.doGet(comUrl + url, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
                if(envelopGet.isSuccessFlg()){
                    categoryName = getEnvelopModel(envelopGet.getObj(),RsCategoryModel.class).getName();
                }
            }
            model.addAttribute("categoryName",categoryName);
            if (!StringUtils.isEmpty(id)) {
                String url = "/resources/"+id;
                envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
        }
        return "simpleView";
    }
    //配置授权浏览页面跳转
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

    //分页查询
    @RequestMapping("/resources")
    @ResponseBody
    public Object searchResources(String searchNm,String categoryId,int page,int rows){
        String url = "/resources";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("code?" + searchNm + " g1;name?" + searchNm + " g1;");
        }
        if(!StringUtils.isEmpty(categoryId)){
            stringBuffer.append("categoryId="+categoryId);
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
        } catch (Exception ex) {
            LogService.getLogger(ResourceController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    //更新
    @RequestMapping("/update")
    @ResponseBody
    public Object updateResource(String dataJson,String mode){
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
                String envelopStr = HttpClientUtil.doPost(comUrl+url,args,username,password);
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
                String updateModelJson = objectMapper.writeValueAsString(updateModel);
                Map<String,Object> params = new HashMap<>();
                params.put("resource",updateModelJson);
                String envelopStr = HttpClientUtil.doPut(comUrl+url,params,username,password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(ResourceController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    //删除
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
    //资源名称唯一性验证
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

    public Boolean isRsInUse(String resourceId) throws Exception{
        String url = "/resources/" + resourceId+"/grant";
        String resultStr = HttpClientUtil.doGet(comUrl + url, username, password);
        Envelop result = objectMapper.readValue(resultStr, Envelop.class);
        if (result.isSuccessFlg()) {
            return true;
        } else {
            return false;
        }
    }

    //资源分类树数据-获取所有分类的不分页方法
    @RequestMapping("/categories")
    @ResponseBody
    public Object getCategories(){
        List<RsCategoryModel> list = new ArrayList<>();
        try{
            String filters = "";
            String envelopStr = "";
            String url = "/resources/categories";
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
    //----------------------------------

    //带检索分页的查找资源分类方法,用于下拉框
    @RequestMapping("/rsCategory")
    @ResponseBody
    public Object searchRsCategory(String searchParm,int page,int rows){
        String url = "/resources/categories/no_paging";
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

    //根据资源分类id，获取其以上直接父级id，含自身
    @RequestMapping("/categoryIds")
    @ResponseBody
    public Object getCategoryParentIdsById(String categoryId){
        String envelopStr = "";
        try{
            String url = "/resources/categories/parent_ids";
            Map<String,Object> params = new HashMap<>();
            params.put("id",categoryId);
            envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
        }catch (Exception ex){
            LogService.getLogger(ResourceController.class).error(ex.getMessage());
        }
        return envelopStr;
    }
}
