package com.yihu.ehr.adapter.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.thirdpartystandard.OrgDataSetDetailModel;
import com.yihu.ehr.agModel.thirdpartystandard.OrgMetaDataDetailModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2015/8/12.
 */
@RequestMapping("/orgdataset")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class OrgDataSetController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("/initialOld")
    public String orgDataSetInitOld(HttpServletRequest request,String adapterOrg){
        request.setAttribute("adapterOrg",adapterOrg);
        return "/adapter/orgCollection";
    }

    @RequestMapping("/initial")
    public String orgDataSetInit(Model model, String adapterOrg){
        model.addAttribute("adapterOrg",adapterOrg);
        model.addAttribute("contentPage","/adapter/orgCollection/grid");
        return "pageView";
    }

    /**
     * 数据集新增,修改窗口
     * @param model
     * @param id
     * @param mode
     * @return
     */
    @RequestMapping("template/orgDataInfo")
    public Object orgDataInfoTemplate(Model model, String id, String mode) {
        String url = "/adapter/org/data_set/"+id;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            if(mode.equals("view") || mode.equals("modify")) {
                resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                model.addAttribute("rs", "success");
            }else{
                resultStr="";
            }
            model.addAttribute("sort","");

//            model.addAttribute("info", resultStr);
            model.addAttribute("info", StringUtils.isEmpty(resultStr)?toJson(envelop):resultStr);
            model.addAttribute("mode",mode);

            model.addAttribute("contentPage","/adapter/orgCollection/dialog");
            return "simpleView";
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }


    /**
     * 数据元新增、修改窗口
     * @param model
     * @param id
     * @param mode
     * @return
     */
    @RequestMapping("template/orgMetaDataInfo")
    public Object orgMetaDataInfoTemplate(Model model, String id, String mode) {
        String url = "/adapter/org/meta_data/"+id;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            if(mode.equals("view") || mode.equals("modify")) {
                resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                model.addAttribute("rs", "success");
            }
            model.addAttribute("sort","");
//            model.addAttribute("info", resultStr);
            model.addAttribute("info", StringUtils.isEmpty(resultStr)?toJson(result):resultStr);
            model.addAttribute("mode",mode);

            model.addAttribute("contentPage","/adapter/orgCollection/dialog");
            return "simpleView";
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 根据id查询实体
     * @param id
     * @return
     */

    @RequestMapping("getOrgDataSet")
    @ResponseBody
    public Object getOrgDataSet(String id) {
        String url = "/orgDataSet/orgDataSet";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id",id);
        try{
            //todo 后台转换成model后传前台
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
//            ObjectMapper mapper = new ObjectMapper();
//            OrgDataSetModel orgDataSetModel = mapper.readValue(resultStr, OrgDataSetModel.class);
            result.setObj(resultStr);
            result.setSuccessFlg(true);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
//        Result result = new Result();
//        try{
//            OrgDataSet orgDataSet = (OrgDataSet) orgDataSetManager.getOrgDataSet(Long.parseLong(id));
//            OrgDataSetModel model = new OrgDataSetModel();
//            model.setCode(orgDataSet.getCode());
//            model.setName(orgDataSet.getName());
//            model.setDescription(orgDataSet.getDescription());
//            result.setObj(model);
//            result.setSuccessFlg(true);
//        }catch (Exception es){
//            result.setSuccessFlg(false);
//        }
//
//        return result.toJson();
    }

    /**
     * 创建机构数据集
     * @return
     */
    @RequestMapping(value = "createOrgDataSet", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object createOrgDataSet(String jsonDataModel, HttpServletRequest request) {

        String url="/adapter/org/data_set";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();

        try{
            OrgDataSetDetailModel orgDataSetDetailModel = toOrgDataSetDetailModel(jsonDataModel);
            orgDataSetDetailModel.setCreateUser(getCurUser(request).getId());
            params.put("json_data", toJson(orgDataSetDetailModel));
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);//创建数据集
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }

    /**
     * 修改机构数据集
     * @return
     */
    @RequestMapping(value = "updateOrgDataSet", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateOrgDataSet(String jsonDataModel, HttpServletRequest request) {

        String url="/adapter/org/data_set";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try{
            OrgDataSetDetailModel orgDataSetDetailModel = toOrgDataSetDetailModel(jsonDataModel);
            orgDataSetDetailModel.setUpdateUser(getCurUser(request).getId());
            params.put("json_data", toJson(orgDataSetDetailModel));
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 删除机构数据集
     * @param id
     * @return
     */
    @RequestMapping("deleteOrgDataSet")
    @ResponseBody
    public Object deleteOrgDataSet(long id) {
        String url = "/adapter/org/data_set/"+id;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }


    /**
     * 条件查询（数据集）
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchOrgDataSets")
    @ResponseBody
    public Object searchOrgDataSets(String organizationCode, String codeOrName, int page, int rows) {
        String url = "/adapter/org/data_sets";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();

        if(StringUtils.isEmpty(organizationCode)){
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("机构代码不能为空");
            return envelop;
        }
        String filters = "organization="+organizationCode;
        if(!StringUtils.isEmpty(codeOrName)){
            filters += " g1;code?"+codeOrName+" g2;name?"+codeOrName+" g2";
        }
        params.put("filters",filters);
        params.put("sorts", "");
        params.put("fields", "");
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }


    //---------------------------以上是机构数据集部分，以下是机构数据元详情部分---------------------------


    /**
     * 根据id查询实体
     *
     * @param id
     * @return
     */
    @RequestMapping("getOrgMetaData")
    @ResponseBody
    public Object getOrgMetaData(String id) {
        String url = "/orgMetaData/orgMetaData";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("metaDataId",id);
        try{
            //todo 后台转换成model后传前台
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
//            ObjectMapper mapper = new ObjectMapper();
//            OrgMetaDataModel orgMetaDataModel = mapper.readValue(resultStr, OrgMetaDataModel.class);
            result.setObj(resultStr);
            result.setSuccessFlg(true);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
//        Result result = new Result();
//        try{
//            OrgMetaData orgMetaData = (OrgMetaData) orgMetaDataManager.getOrgMetaData(Long.parseLong(id));
//            OrgMetaDataModel model = new OrgMetaDataModel();
//            model.setCode(orgMetaData.getCode());
//            model.setName(orgMetaData.getName());
//            model.setDescription(orgMetaData.getDescription());
//            result.setObj(model);
//            result.setSuccessFlg(true);
//        }catch (Exception ex){
//            result.setSuccessFlg(false);
//        }
//
//        return result.toJson();
    }


    /**
     * 创建机构数据元
     * @return
     */
    @RequestMapping(value = "createOrgMetaData", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object createOrgMetaData(String jsonDataModel, HttpServletRequest request) {
        String url="/adapter/org/meta_data";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();

        try{
            OrgMetaDataDetailModel orgMetaDataDetailModel = toOrgMetaDataDetailModel(jsonDataModel);
            orgMetaDataDetailModel.setCreateUser(getCurUser(request).getId());
            params.put("json_data",toJson(orgMetaDataDetailModel));
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 修改机构数据元
     * @return
     */
    @RequestMapping(value = "updateOrgMetaData", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateOrgMetaData(String jsonDataModel, HttpServletRequest request) {
        String url="/adapter/org/meta_data";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try{
            OrgMetaDataDetailModel orgMetaDataDetailModel = toOrgMetaDataDetailModel(jsonDataModel);
            orgMetaDataDetailModel.setUpdateUser(getCurUser(request).getId());
            params.put("json_data", toJson(orgMetaDataDetailModel));
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("系统出错！");
            return envelop;
        }
    }

    /**
     * 删除、批量删除机构数据元
     * @param ids
     * @return
     */
    @RequestMapping("deleteOrgMetaDataList")
    @ResponseBody
    public Object deleteOrgMetaDataList(String ids) {
        String url = "/adapter/org/meta_data";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("ids",ids);
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);

            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }


    /**
     * 条件查询（数据元）
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchOrgMetaDatas")
    @ResponseBody
    public Object searchOrgMetaDatas(String organizationCode,Integer orgDataSetSeq, String codeOrName, int page, int rows) {
        String url = "/adapter/org/meta_datas";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String filters = "orgDataSet="+orgDataSetSeq+" g1;organization="+organizationCode+" g2";
        if (!StringUtils.isEmpty(codeOrName)){
            filters += ";code?"+codeOrName+" g4;name?"+codeOrName+" g4";
        }
        params.put("fields", "");
        params.put("filters", filters);
        params.put("sorts", "");
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    private OrgDataSetDetailModel toOrgDataSetDetailModel(String json) throws IOException {
        return objectMapper.readValue(json, OrgDataSetDetailModel.class);
    }

    private OrgMetaDataDetailModel toOrgMetaDataDetailModel(String json) throws IOException {
        return objectMapper.readValue(json, OrgMetaDataDetailModel.class);
    }

    private UsersModel getCurUser(HttpServletRequest request){
        UsersModel userDetailModel = (UsersModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        return userDetailModel;
    }
}
