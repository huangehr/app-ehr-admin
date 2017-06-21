package com.yihu.ehr.specialdict.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.specialdict.HealthProblemDictModel;
import com.yihu.ehr.agModel.specialdict.HpIcd10RelationModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
 * Created by yww on 2016/4/20.
 */
@RequestMapping("/specialdict/hp")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class HealthProblemDictController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("initial")
    public String hpInitial(Model model){
        model.addAttribute("contentPage", "specialdict/healthproblem/hp");
        return "pageView";
    }

    //新增、修改弹出框初始页面
    @RequestMapping("dialog/hp")
    public String hpInfoTemplate(Model model,Long id,String mode){
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","specialdict/healthproblem/hpInfoDialog");
        Envelop envelop = new Envelop();
        String envelopStr = "";
        try{
            if (id != null) {
                String url = "/dict/hp/" + id;
                envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
        }
        return "simpleView";
    }


    @RequestMapping("/hps")
    @ResponseBody
    public Object getHpDictList(String searchNm,int page,int rows){
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
        String url = "/dict/hps";
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
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
        }
        return envelopStr;
    }

    @RequestMapping("/deletes")
    @ResponseBody
    public Object deleteHpDicts(String ids){
        String url = "/dict/hps";
        String envelopStr = "";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("ids",ids);
            envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
        }catch (Exception ex){
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
        }
        return envelopStr;
    }

    @RequestMapping("/update")
    @ResponseBody
    public Object updateIcd10Dict(String dictJson,String mode,HttpServletRequest request){
        Envelop envelop = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        envelop.setSuccessFlg(false);
        String url = "/dict/hp";
        try{
            HealthProblemDictModel model = objectMapper.readValue(dictJson, HealthProblemDictModel.class);
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
                String urlGet = "/dict/hp/"+model.getId();
                String envelopGetStr = HttpClientUtil.doGet(comUrl+urlGet,username,password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    envelop.setErrorMsg("原字典项信息获取失败！");
                }
                HealthProblemDictModel updateModel = getEnvelopModel(envelopGet.getObj(),HealthProblemDictModel.class);
                updateModel.setUpdateUser(userDetailModel.getId());
                updateModel.setCode(model.getCode());
                updateModel.setName(model.getName());
                updateModel.setDescription(model.getDescription());
                String updateModelJson = objectMapper.writeValueAsString(updateModel);
                Map<String,Object> params = new HashMap<>();
                params.put("dictionary",updateModelJson);
                String envelopStr = HttpClientUtil.doPut(comUrl+url,params,username,password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping("isCodeExist")
    @ResponseBody
    //"判断提交的字典代码是否已经存在"
    public Object isCodeExist(String code){
        Envelop envelop = new Envelop();
        try{
            String url = "/dict/hp/existence/code/"+code;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex) {
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    @RequestMapping("isNameExist")
    @ResponseBody
    //"判断提交的字典名称是否已经存在"
    public Object isNameExist( String name){
        Envelop envelop = new Envelop();
        try{
            String url = "/dict/hp/existence/name";
            Map<String,Object> params = new HashMap<>();
            params.put("name",name);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex) {
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    //-------------------------健康问题与ICD10之间关联关系管理---------------------------------------------------------

    @RequestMapping("/hpIcd10Relation/initial")
    //关联的icd10列表初始化页面
    public  String hpIcd10RelationInitial(Model model,Long hpId){
        model.addAttribute("hpId",hpId);
        model.addAttribute("contentPage","specialdict/healthproblem/icd10HpRelaInfoDialog");
        return "pageView";
    }


    @RequestMapping("/hpIcd10RelationCreate/initial")
    //新增关联icd10页面初始化
    public  String hpIcd10RelationCreateInitial(Model model,Long hpId){
        model.addAttribute("hpId",hpId);
        model.addAttribute("contentPage","specialdict/healthproblem/icd10HpRelaCreate");
        return "pageView";
    }


    //获取健康问题已经关了的icd10信息列表
    @RequestMapping("/icd10ListRelaInclude")
    @ResponseBody
    public Object icd10ListRelaInclude(String searchNm,Long hpId){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            String icd10Ids = this.getRelatedIcd10Ids(hpId);
            if(StringUtils.isEmpty(icd10Ids)){
                return envelop;
            }
            String filters = "";
            if(!StringUtils.isEmpty(searchNm)){
                filters +="code?"+searchNm+" g1;name?"+searchNm+" g1;";
            }
            filters += "id="+icd10Ids+";";
            Map<String,Object> args = new HashMap<>();
            args.put("fields","");
            args.put("filters",filters);
            args.put("sorts","");
            args.put("page",1);
            args.put("size",999);
            String url = "/dict/icd10s";
            String envelopStr = HttpClientUtil.doGet(comUrl+url,args,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    //除健康问提字典已经关了的icd10之外的icd10列表
    @RequestMapping("/icd10ListRelaExclude")
    @ResponseBody
    public Object icd10ListRelaExclude(String searchNm,Long hpId,int page,int rows){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            String icd10Ids = this.getRelatedIcd10Ids(hpId);
            String filters = "";
            if(!StringUtils.isEmpty(searchNm)){
                filters +="code?"+searchNm+" g1;name?"+searchNm+" g1;";
            }
            if(!StringUtils.isEmpty(icd10Ids)){
                filters += "id<>"+icd10Ids+";";
            }
            Map<String,Object> args = new HashMap<>();
            args.put("fields","");
            args.put("filters",filters);
            args.put("sorts","");
            args.put("page",page);
            args.put("size",rows);
            String url = "/dict/icd10s";
            String envelopStr = HttpClientUtil.doGet(comUrl+url,args,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 根据hpId获取关联的icd10的ids,用于查询关联/未关联的icd10集合
     * @param hpId
     * @return
     * @throws Exception
     */
    public String getRelatedIcd10Ids(Long hpId) throws Exception{
        String icd10Ids = "";
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        Map<String,Object> params = new HashMap<>();
        String filtersRelation = "hpId="+hpId+";";
        params.put("filters",filtersRelation);
        String urlRelation = "/dict/hp/icd10s/no_paging";
        String envelopGetRelation = HttpClientUtil.doGet(comUrl+urlRelation,params,username,password);
        Envelop result = objectMapper.readValue(envelopGetRelation,Envelop.class);
        if (!result.isSuccessFlg()&&result.getDetailModelList().size() <= 0){
            return icd10Ids;
        }
        List<HpIcd10RelationModel> models = (List<HpIcd10RelationModel>)getEnvelopList(result.getDetailModelList(),new ArrayList<HpIcd10RelationModel>(),HpIcd10RelationModel.class);
        for (HpIcd10RelationModel model:models){
            icd10Ids += model.getIcd10Id()+",";
        }
        return StringUtils.isEmpty(icd10Ids) ? "" : (icd10Ids.substring(0,icd10Ids.length()-1));
    }

    /**
     * 根据hpId、icd10ids获取关联的icd10的ids,用于删除/批量删除关联
     * @param hpId
     * @return
     * @throws Exception
     */
    public String getRelatedIcd10IdsForDel(Long hpId,String icd10Ids) throws Exception{
        String ids = "";
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        Map<String,Object> params = new HashMap<>();
        String filtersRelation = "hpId="+hpId+";icd10Id="+icd10Ids;
        params.put("filters",filtersRelation);
        String urlRelation = "/dict/hp/icd10s/no_paging";
        String envelopGetRelation = HttpClientUtil.doGet(comUrl+urlRelation,params,username,password);
        Envelop result = objectMapper.readValue(envelopGetRelation,Envelop.class);
        if (!result.isSuccessFlg()&&result.getDetailModelList().size() <= 0){
            return ids;
        }
        List<HpIcd10RelationModel> models = (List<HpIcd10RelationModel>)getEnvelopList(result.getDetailModelList(),new ArrayList<HpIcd10RelationModel>(),HpIcd10RelationModel.class);
        for (HpIcd10RelationModel model:models){
            ids += model.getId()+",";
        }
        return StringUtils.isEmpty(ids) ? "" : (ids.substring(0,ids.length()-1));
    }

    @RequestMapping("/hpIcd10Relation/creates")
    @ResponseBody
    //"为健康问题增加ICD10疾病关联。
    public Object createHpIcd10Relations(Long hpId,String icd10Ids,HttpServletRequest request){
        Envelop envelop = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        String url = "/dict/hp/icd10s";
        if(StringUtils.isEmpty(icd10Ids)){
            envelop.setErrorMsg("icd10字典id不能为空！");
            return envelop;
        }
        if (StringUtils.isEmpty(hpId)){
            envelop.setErrorMsg("指标字典id不能为空！");
            return envelop;
        }
        String[] ids = icd10Ids.split(",");
        try {
            //单个关联
            if(ids.length == 1){
                url = "/dict/hp/icd10";
                HpIcd10RelationModel model = new HpIcd10RelationModel();
                model.setCreateUser(userDetailModel.getId());
                model.setIcd10Id(Long.parseLong(icd10Ids));
                model.setHpId(hpId);
                String modelJson = objectMapper.writeValueAsString(model);
                Map<String,Object> params = new HashMap<>();
                params.put("dictionary",modelJson);
                String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
                return envelopStr;
            }
            //批量关联
            Map<String,Object> params = new HashMap<>();
            params.put("hp_id",hpId);
            params.put("icd10_ids",icd10Ids);
            params.put("create_user",userDetailModel.getId());
            String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/hpIcd10Relation/deletes")
    @ResponseBody
    // "为健康问题删除ICD10疾病关联---单个、批量删除。"
    public Object deleteHpIcd10Relations(String icd10Ids,Long hpId){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            String relationIds = getRelatedIcd10IdsForDel(hpId,icd10Ids);
            if (StringUtils.isEmpty(relationIds)){
                envelop.setErrorMsg("不存在关联！");
                return envelop;
            }
            String url = "/dict/hp/icd10s";
            Map<String,Object> params = new HashMap<>();
            params.put("ids",relationIds);
            String envelopStr = HttpClientUtil.doDelete(comUrl + url, params, username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping( "/hpIcd10Relations")
    @ResponseBody
    //"根据健康问题查询相应的ICD10关联列表信息。"
    public Object getHpIcd10RelationList(String searchNm,int page, int rows){
        Envelop envelop = new Envelop();
        String filters = "";
        String envelopStr = "";
        if(!StringUtils.isEmpty(searchNm)){
            filters +="code?"+searchNm+" g1;name?"+searchNm+" g1;";
        }
        try{
            String url = "/dict/hp/icd10s";
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex) {
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    @RequestMapping("isHpIcd10RelaExist")
    @ResponseBody
    //"判断健康问题与ICD10的关联关系在系统中是否已存在"
    public Object isHpIcd10RelaExist(Long hpId,Long icd10Id){
        Envelop envelop = new Envelop();
        try{
            String url = "/dict/hp/icd10/existence";
            Map<String,Object> params = new HashMap<>();
            params.put("hpId",hpId);
            params.put("icd10Id",icd10Id);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(HealthProblemDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }
}
