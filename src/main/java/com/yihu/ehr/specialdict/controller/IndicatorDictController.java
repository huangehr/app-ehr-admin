package com.yihu.ehr.specialdict.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.specialdict.IndicatorsDictModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
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
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by yww on 2016/4/20.
 */
@RequestMapping("/specialdict/indicator")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class IndicatorDictController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("initial")
    public String indicatorInitial(Model model){
        model.addAttribute("contentPage", "specialdict/indicator/indicator");
        return "pageView";
    }

    //新增、修改弹出框初始页面
    @RequestMapping("dialog/indicator")
    public String indicatorInfoTemplate(Model model,String id,String mode){
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","specialdict/indicator/indicatorInfoDialog");
        Envelop envelop = new Envelop();
        String envelopStr = "";
        try{
            if (!StringUtils.isEmpty(id)) {
                String url = "/dict/indicator/" + id;
                envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(IndicatorDictController.class).error(ex.getMessage());
        }
        return "simpleView";
    }


    @RequestMapping("/indicators")
    @ResponseBody
    public Object getIndicatorDictList(String searchNm,int page,int rows){
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
//            LogService.getLogger(IndicatorDictController.class).error(ex.getMessage());
//        }
//        return envelopStr;
        String url = "/dict/indicators";
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
            LogService.getLogger(IndicatorDictController.class).error(ex.getMessage());
        }
        return envelopStr;
    }

    @RequestMapping("/delete")
    @ResponseBody
    public Object deleteIndicatorDict(String id){
        String url = "/dict/indicator/"+id;
        String envelopStr = "";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("id",id);
            envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
        }catch (Exception ex){
            LogService.getLogger(IndicatorDictController.class).error(ex.getMessage());
        }
        return envelopStr;
    }

    @RequestMapping("/deletes")
    @ResponseBody
    public Object deleteIndicatorDicts(String ids){
        String url = "/dict/indicators";
        String envelopStr = "";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("ids",ids);
            envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
        }catch (Exception ex){
            LogService.getLogger(IndicatorDictController.class).error(ex.getMessage());
        }
        return envelopStr;
    }

    @RequestMapping("/update")
    @ResponseBody
    public Object updateIndicatorDict(String dictJson,String mode,HttpServletRequest request){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        String url = "/dict/indicator";
        try{
            IndicatorsDictModel model = objectMapper.readValue(dictJson, IndicatorsDictModel.class);
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
                String urlGet = "/dict/indicator/"+model.getId();
                String envelopGetStr = HttpClientUtil.doGet(comUrl+urlGet,username,password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    envelop.setErrorMsg("原字典项信息获取失败！");
                }
                IndicatorsDictModel updateModel = getEnvelopModel(envelopGet.getObj(),IndicatorsDictModel.class);
                updateModel.setUpdateUser(userDetailModel.getId());
                updateModel.setCode(model.getCode());
                updateModel.setName(model.getName());
                updateModel.setType(model.getType());
                updateModel.setUnit(model.getUnit());
                updateModel.setUpperLimit(model.getUpperLimit());
                updateModel.setLowerLimit(model.getLowerLimit());
                updateModel.setDescription(model.getDescription());
                String updateModelJson = objectMapper.writeValueAsString(updateModel);
                Map<String,Object> params = new HashMap<>();
                params.put("dictionary",updateModelJson);
                String envelopStr = HttpClientUtil.doPut(comUrl+url,params,username,password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(IndicatorDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }
    @RequestMapping("/indicatorIsUsage")
    @ResponseBody
    //根据指标的ID判断是否与ICD10字典存在关联。
    public Object indicatorIsUsage(String id){
        Envelop envelop = new Envelop();
        try{
            String url = "dict/indicator/icd10/"+id;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(IndicatorDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    @RequestMapping("/isNameExist" )
    @ResponseBody
    //判断提交的字典名称是否已经存在
    public Object isNameExists(String name){
        Envelop envelop = new Envelop();
        try{
            String url = "/dict/indicator/existence/name";
            Map<String,Object> params = new HashMap<>();
            params.put("name",name);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(IndicatorDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    @RequestMapping("/isCodeExist")
    @ResponseBody
    //"判断提交的字典代码是否已经存在"
    public Object isCodeExists( String code){
        Envelop envelop = new Envelop();
        try{
            String url = "/dict/indicator/existence/code/"+code;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(IndicatorDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }
}
