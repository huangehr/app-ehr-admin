package com.yihu.ehr.specialdict.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.specialdict.Icd10DictModel;
import com.yihu.ehr.agModel.specialdict.Icd10DrugRelationModel;
import com.yihu.ehr.agModel.specialdict.Icd10IndicatorRelationModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.model.specialdict.MIcd10Dict;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * Created by yww on 2016/4/15.
 */
@RequestMapping("/specialdict/icd10")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class Icd10Controller extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("initial")
    public String icd10Initial(Model model){
        model.addAttribute("contentPage", "specialdict/icd10/icd10");
        return "pageView";
    }

    @RequestMapping("dialog/icd10Info")
    public String icd10InfoTemplate(Model model,Long id,String mode){
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","specialdict/icd10/icd10InfoDialog");
        Envelop envelop = new Envelop();
        String envelopStr = "";
        try{
            if (id != null) {
                String url = "/dict/icd10/" + id;
                envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
        }
        return "simpleView";
    }


    @RequestMapping("/icd10s")
    @ResponseBody
    public Object getIcd10DictList(String searchNm,int page,int rows){
//        URLQueryBuilder builder = new URLQueryBuilder();
//        if(!StringUtils.isEmpty(codename)){
//            builder.addFilter("code","?",codename,"g1");
//            builder.addFilter("name","?",codename,"g1");
//        }
//        builder.setPageSize(rows);
//        builder.setPageNumber(page);
//        String params = builder.toString();
//        String url = "/dict/icd10s";
//        String envelopStr = "";
//        try{
//            RestTemplates restTemplates = new RestTemplates();
//            envelopStr = restTemplates.doGet(comUrl+url+"?"+params);
//        }catch (Exception ex){
//            LogService.getLogger(SpecialDictController.class).error(ex.getMessage());
//        }
//        return envelopStr;
        String url = "/dict/icd10s";
        String filters = "";
        String envelopStr = "";
        if(!StringUtils.isEmpty(searchNm)){
            filters +="code?"+searchNm+" g1;name?"+searchNm+" g1;";
        }
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
        }
        return envelopStr;
    }

    @RequestMapping("/deletes")
    @ResponseBody
    //根据ids删除icd10疾病字典(含与药品及指标的关联关系，同时删除关联的诊断)
    public Object deleteIcd10Dicts(String ids){
        String url = "/dict/icd10s";
        String envelopStr = "";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("ids",ids);
            envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
        }
        return envelopStr;
    }

    @RequestMapping("/update")
    @ResponseBody
    public Object updateIcd10Dict(String icd10JsonData,String mode,HttpServletRequest request){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        String url = "/dict/icd10";
        try{
            Icd10DictModel model = objectMapper.readValue(icd10JsonData, Icd10DictModel.class);
            if(StringUtils.isEmpty(model.getCode())){
                envelop.setErrorMsg("字典项编码不能为空！");
                return envelop;
            }
            if(StringUtils.isEmpty(model.getName())){
                envelop.setErrorMsg("字典项名称不能为空！");
                return envelop;
            }
            if("new".equals(mode)){
                model.setCreateUser(userDetailModel.getId());
                Map<String,Object> args = new HashMap<>();
                args.put("dictionary",objectMapper.writeValueAsString(model));
                String envelopStr = HttpClientUtil.doPost(comUrl+url,args,username,password);
                return envelopStr;
            } else if("modify".equals(mode)){
                String urlGet = "/dict/icd10/"+model.getId();
                String envelopGetStr = HttpClientUtil.doGet(comUrl+urlGet,username,password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    envelop.setErrorMsg("原字典项信息获取失败！");
                }
                Icd10DictModel updateModel = getEnvelopModel(envelopGet.getObj(),Icd10DictModel.class);
                updateModel.setUpdateUser(userDetailModel.getId());
                updateModel.setCode(model.getCode());
                updateModel.setName(model.getName());
                updateModel.setChronicFlag(model.getChronicFlag());
                updateModel.setInfectiousFlag(model.getInfectiousFlag());
                updateModel.setDescription(model.getDescription());
                String updateModelJson = objectMapper.writeValueAsString(updateModel);
                Map<String,Object> params = new HashMap<>();
                params.put("dictionary",updateModelJson);
                String envelopStr = HttpClientUtil.doPut(comUrl+url,params,username,password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping("/icd10")
    @ResponseBody
    MIcd10Dict getIcd10Dict( long id){
        return null;
    }

    @RequestMapping("/icd10DictIsUsage")
    @ResponseBody
    public Object icd10DictIsUsage(long id){
        Envelop envelop = new Envelop();
        try{
            String url = "dict/icd10/hp/"+id;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    @RequestMapping("isNameExist")
    @ResponseBody
    public Object isNameExists(String name){
        Envelop envelop = new Envelop();
        try{
            String url = "/dict/icd10/existence/name";
            Map<String,Object> params = new HashMap<>();
            params.put("name",name);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    @RequestMapping("isCodeExist")
    @ResponseBody
    public Object isCodeExists(String code){
        Envelop envelop = new Envelop();
        try{
            String url = "/dict/icd10/existence/code/"+code;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    //-------------------------ICD10与诊断之间关联关系管理---开始--------------------------------------------------------
    //关联信息列表页面
    @RequestMapping("/diagnoseRelaInfo/initial")
    public String diagnoseIcd10RelaInfoInitial(Model model,Long id){
        model.addAttribute("icd10Id",id);
        model.addAttribute("contentPage","specialdict/icd10/diagnoseIcd10RelaInfo");
        return "simpleView";
    }
    //关联操作界面
    @RequestMapping("/diagnoseRelaCreate/initial")
    public String diagnoseIcd10RelaCreateInitial(Model model,Long id){
        model.addAttribute("icd10Id",id);
        model.addAttribute("contentPage","specialdict/icd10/diagnoseIcd10RelaCreate");
        return "simpleView";
    }
    //-------------------------ICD10与诊断之间关联关系管理---结束--------------------------------------------------------


    //-------------------------ICD10与药品之间关联关系管理-----------------------------------------------------------
    //关联信息列表页面
    @RequestMapping("/drugRelaInfo/initial")
    public String drugIcd10RelaInfoInitial(Model model,Long id){
        model.addAttribute("icd10Id",id);
        model.addAttribute("contentPage","specialdict/icd10/drugIcd10RelaInfo");
        return "simpleView";
    }
    //关联操作界面
    @RequestMapping("/drugRelaCreate/initial")
    public String drugIcd10RelaCreateInitial(Model model,String id){
        model.addAttribute("icd10Id",id);
        model.addAttribute("contentPage","specialdict/icd10/drugIcd10RelaCreate");
        return "simpleView";
    }

    //根据icd10Id获取已关联的药品字典列表
    @RequestMapping("/drugs/include")
    @ResponseBody
    public Object drugsInclude(Long icd10Id,String searchNm){
        Envelop envelop = new Envelop();
        try{
            String drugsIds = getRelatedDrugsIds(icd10Id);
            String filters = "";
            if(!StringUtils.isEmpty(searchNm)){
                filters +="code?"+searchNm+" g1;name?"+searchNm+" g1;";
            }
            filters += "id="+drugsIds+";";
            Map<String,Object> args = new HashMap<>();
            args.put("fields","");
            args.put("filters",filters);
            args.put("sorts","");
            args.put("page",1);
            args.put("size",999);
            String url = "/dict/drugs";
            String envelopStr = HttpClientUtil.doGet(comUrl+url,args,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    //根据icd10Id获取未关联的药品字典列表
    @RequestMapping("/drug/exclude")
    @ResponseBody
    public Object drugsExclude(Long icd10Id,String searchNm,int page,int rows){
        Envelop envelop = new Envelop();
        try{
            String drugIds = getRelatedDrugsIds(icd10Id);
            String filters = "";
            if(!StringUtils.isEmpty(searchNm)){
                filters +="code?"+searchNm+" g1;name?"+searchNm+" g1;";
            }
            if(!StringUtils.isEmpty(drugIds)){
                filters += "id<>"+drugIds+";";
            }
            Map<String,Object> args = new HashMap<>();
            args.put("fields","");
            args.put("filters",filters);
            args.put("sorts","");
            args.put("page",page);
            args.put("size",rows);
            String url = "/dict/drugs";
            String envelopStr = HttpClientUtil.doGet(comUrl+url,args,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/drug/creates")
    @ResponseBody
    public Object createIcd10DrugRelations(Long icd10Id,String drugIds,HttpServletRequest request){
        Envelop envelop = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        String url = "/dict/icd10/drugs";
        if(icd10Id == null){
            envelop.setErrorMsg("icd10字典id不能为空！");
            return envelop;
        }
        if (StringUtils.isEmpty(drugIds)){
            envelop.setErrorMsg("药品字典id不能为空！");
            return envelop;
        }
        String[] ids = drugIds.split(",");
        try {
            //单个关联
            if(ids.length == 1){
                url = "/dict/icd10/drug";
                Icd10DrugRelationModel model = new Icd10DrugRelationModel();
                model.setCreateUser(userDetailModel.getId());
                model.setIcd10Id(icd10Id);
                model.setDrugId(Long.parseLong(drugIds));
                String modelJson = objectMapper.writeValueAsString(model);
                Map<String,Object> params = new HashMap<>();
                params.put("dictionary",modelJson);
                String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
                return envelopStr;
            }
            //批量关联
            Map<String,Object> params = new HashMap<>();
            params.put("icd10_id",icd10Id);
            params.put("drug_ids",drugIds);
            params.put("create_user",userDetailModel.getId());
            String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/drug/deletes")
    @ResponseBody
    public Object deleteIcd10DrugRelations(Long icd10Id,String drugIds){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            String relationIds = getIcd10DrugRelaIdsForDel(icd10Id, drugIds);
            if (StringUtils.isEmpty(relationIds)){
                envelop.setErrorMsg("不存在关联！");
                return envelop;
            }
            String url = "/dict/icd10/drugs";
            Map<String,Object> params = new HashMap<>();
            params.put("ids",relationIds);
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/drugs/relations")
    @ResponseBody
    public Object getIcd10DrugRelationList(int rows, int page){
        //获取关联关联列表
        Envelop envelop = new Envelop();
        String url = "/dict/icd10/indicators";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters","");
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/drug/isIcd10DrugRelaExist")
    @ResponseBody
    public Object isIcd10DrugRelaExist(Long drugId,Long icd10Id){
        Envelop envelop = new Envelop();
        String url = "/dict/icd10/drug/existence";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("drugId",drugId);
            params.put("icd10Id",icd10Id);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 根据icd10获取关联的药品字典的ids,用于查询关联/未关联的药品集合
     * @param icd10Id
     * @return
     * @throws Exception
     */
    public String getRelatedDrugsIds(Long icd10Id) throws Exception{
        String drugIds = "";
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        Map<String,Object> params = new HashMap<>();
        String filtersRelation = "icd10Id="+icd10Id+";";
        params.put("filters",filtersRelation);
        String urlRelation = "/dict/icd10/drugs/no_paging";
        String envelopGetRelation = HttpClientUtil.doGet(comUrl+urlRelation,params,username,password);
        Envelop result = objectMapper.readValue(envelopGetRelation,Envelop.class);
        if (!result.isSuccessFlg()){
            return drugIds;
        }
        List<Icd10DrugRelationModel> models = (List<Icd10DrugRelationModel>)getEnvelopList(result.getDetailModelList(),new ArrayList<Icd10DrugRelationModel>(),Icd10DrugRelationModel.class);
        for (Icd10DrugRelationModel model:models){
            drugIds += model.getDrugId()+",";
        }
        return StringUtils.isEmpty(drugIds) ? "" : (drugIds.substring(0,drugIds.length()-1));
    }

    /**
     * 根据icd10Id、drugIds获取关联关系的ids,用于删除/批量删除关联
     * @param icd10Id
     * @param drugIds
     * @return
     * @throws Exception
     */
    public String getIcd10DrugRelaIdsForDel(Long icd10Id,String drugIds) throws Exception{
        String ids = "";
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        Map<String,Object> params = new HashMap<>();
        String filtersRelation = "icd10Id="+icd10Id+";drugId="+drugIds;
        params.put("filters",filtersRelation);
        String urlRelation = "/dict/icd10/drugs/no_paging";
        String envelopGetRelation = HttpClientUtil.doGet(comUrl+urlRelation,params,username,password);
        Envelop result = objectMapper.readValue(envelopGetRelation,Envelop.class);
        if (!result.isSuccessFlg()){
            return ids;
        }
        List<Icd10DrugRelationModel> models = (List<Icd10DrugRelationModel>)getEnvelopList(result.getDetailModelList(),new ArrayList<Icd10DrugRelationModel>(),Icd10DrugRelationModel.class);
        for (Icd10DrugRelationModel model:models){
            ids += model.getId()+",";
        }
        return StringUtils.isEmpty(ids) ? "" : (ids.substring(0,ids.length()-1));
    }
    //-------------------------ICD10与药品之间关联关系管理 结束-----------------------------------------------------------


    //-------------------------ICD10与指标之间关联关系管理 开始-----------------------------------------------------------

    //关联信息页面
    @RequestMapping("/indicator/initial")
    public String indicatorIcd10Initial(Model model,Long id){
        model.addAttribute("icd10Id",id);
        model.addAttribute("contentPage","specialdict/icd10/indicatorIcd10RelaInfo");
        return "simpleView";
    }
    //关联操作界面
    @RequestMapping("/indicatorRelation/initial")
    public String indicatorIcd10RelationInitial(Model model,Long id){
        model.addAttribute("icd10Id",id);
        model.addAttribute("contentPage","specialdict/icd10/indicatorIcd10RelaCreate");
        return "simpleView";
    }

    //根据icd10Id获取已关联的indicator列表
    @RequestMapping("/indicators/include")
    @ResponseBody
    public Object icd10IndicatorsInclude(Long icd10Id,String searchNm){
        Envelop envelop = new Envelop();
        try{
            String indicatorIds = getRelatedIndicatorIds(icd10Id);
            String filters = "";
            if(!StringUtils.isEmpty(searchNm)){
                filters +="code?"+searchNm+" g1;name?"+searchNm+" g1;";
            }
            filters += "id="+indicatorIds+";";
            Map<String,Object> args = new HashMap<>();
            args.put("fields","");
            args.put("filters",filters);
            args.put("sorts","");
            args.put("page",1);
            args.put("size",999);
            String url = "/dict/indicators";
            String envelopStr = HttpClientUtil.doGet(comUrl+url,args,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    //根据icd10Id获取未关联的indicator列表
    @RequestMapping("/indicators/exclude")
    @ResponseBody
    public Object icd10IndicatorsExclude(Long icd10Id,String searchNm,int page,int rows){
        Envelop envelop = new Envelop();
        try{
            String indicatorIds = getRelatedIndicatorIds(icd10Id);
            String filters = "";
            if(!StringUtils.isEmpty(searchNm)){
                filters +="code?"+searchNm+" g1;name?"+searchNm+" g1;";
            }
            if(!StringUtils.isEmpty(indicatorIds)){
                filters += "id<>"+indicatorIds+";";
            }
            Map<String,Object> args = new HashMap<>();
            args.put("fields","");
            args.put("filters",filters);
            args.put("sorts","");
            args.put("page",page);
            args.put("size",rows);
            String url = "/dict/indicators";
            String envelopStr = HttpClientUtil.doGet(comUrl+url,args,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }


    @RequestMapping("/indicator/creates")
    @ResponseBody
    public Object createIcd10IndicatorRelations(Long icd10Id,String indicatorIds,HttpServletRequest request){
        Envelop envelop = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        String url = "/dict/icd10/indicators";
        if(icd10Id == null){
            envelop.setErrorMsg("icd10字典id不能为空！");
            return envelop;
        }
        if (StringUtils.isEmpty(indicatorIds)){
            envelop.setErrorMsg("指标字典id不能为空！");
            return envelop;
        }
        String[] ids = indicatorIds.split(",");
        try {
            //单个关联
            if(ids.length == 1){
                url = "/dict/icd10/indicator";
                Icd10IndicatorRelationModel model = new Icd10IndicatorRelationModel();
                model.setCreateUser(userDetailModel.getId());
                model.setIcd10Id(icd10Id);
                model.setIndicatorId(Long.parseLong(indicatorIds));
                String modelJson = objectMapper.writeValueAsString(model);
                Map<String,Object> params = new HashMap<>();
                params.put("dictionary",modelJson);
                String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
                return envelopStr;
            }
            //批量关联
            Map<String,Object> params = new HashMap<>();
            params.put("icd10_id",icd10Id);
            params.put("indicator_ids",indicatorIds);
            params.put("create_user",userDetailModel.getId());
            String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/indicator/deletes")
    @ResponseBody
    public Object deleteIcd10IndicatorRelations(Long icd10Id,String indicatorIds){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            //根据icdId、indicatorId 获取关系对象ids
            String relationIds = getIcd10IndicatorRelaIdsForDel(icd10Id, indicatorIds);
            if (StringUtils.isEmpty(relationIds)){
                envelop.setErrorMsg("不存在关联！");
                return envelop;
            }
            String url = "/dict/icd10/indicators";
            Map<String,Object> params = new HashMap<>();
            params.put("ids",relationIds);
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/indicator/relations")
    @ResponseBody
    public Object getIcd10IndicatorRelationList(int rows, int page){
        //获取关联关联列表
        Envelop envelop = new Envelop();
        String url = "/dict/icd10/indicators";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters","");
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/indicator/isIcd10IndicatorsRelaExist")
    @ResponseBody
    public Object isIcd10IndicatorsRelaExist(Long indicatorId,Long icd10Id){
        Envelop envelop = new Envelop();
        String url = "/dict/icd10/indicator/existence";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("indicatorsId",indicatorId);
            params.put("icd10Id",icd10Id);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(Icd10Controller.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 根据icd10获取关联的indicator的ids,用于查询关联/未关联的indicator集合
     * @param icd10Id
     * @return
     * @throws Exception
     */
    public String getRelatedIndicatorIds(Long icd10Id) throws Exception{
        String indicatorIds = "";
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        Map<String,Object> params = new HashMap<>();
        String filtersRelation = "icd10Id="+icd10Id+";";
        params.put("filters",filtersRelation);
        String urlRelation = "/dict/icd10/indicators/no_paging";
        String envelopGetRelation = HttpClientUtil.doGet(comUrl+urlRelation,params,username,password);
        Envelop result = objectMapper.readValue(envelopGetRelation,Envelop.class);
        if (!result.isSuccessFlg()){
            return indicatorIds;
        }
        List<Icd10IndicatorRelationModel> models = (List<Icd10IndicatorRelationModel>)getEnvelopList(result.getDetailModelList(),new ArrayList<Icd10IndicatorRelationModel>(),Icd10IndicatorRelationModel.class);
        for (Icd10IndicatorRelationModel model:models){
            indicatorIds += model.getIndicatorId()+",";
        }
        return StringUtils.isEmpty(indicatorIds) ? "" : (indicatorIds.substring(0,indicatorIds.length()-1));
    }

    /**
     * 根据icd10Id、indicatorIds获取关联关系的ids,用于删除/批量删除关联
     * @param icd10Id
     * @param indicatorIds
     * @return
     * @throws Exception
     */
    public String getIcd10IndicatorRelaIdsForDel(Long icd10Id,String indicatorIds) throws Exception{
        String ids = "";
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        Map<String,Object> params = new HashMap<>();
        String filtersRelation = "icd10Id="+icd10Id+";indicatorId="+indicatorIds;
        params.put("filters",filtersRelation);
        String urlRelation = "/dict/icd10/indicators/no_paging";
        String envelopGetRelation = HttpClientUtil.doGet(comUrl+urlRelation,params,username,password);
        Envelop result = objectMapper.readValue(envelopGetRelation,Envelop.class);
        if (!result.isSuccessFlg()){
            return ids;
        }
        List<Icd10IndicatorRelationModel> models = (List<Icd10IndicatorRelationModel>)getEnvelopList(result.getDetailModelList(),new ArrayList<Icd10IndicatorRelationModel>(),Icd10IndicatorRelationModel.class);
        for (Icd10IndicatorRelationModel model:models){
            ids += model.getId()+",";
        }
        return StringUtils.isEmpty(ids) ? "" : (ids.substring(0,ids.length()-1));
    }
    //-------------------------ICD10与指标之间关联关系管理 结束-----------------------------------------------------------

}
