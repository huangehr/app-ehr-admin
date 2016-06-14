package com.yihu.ehr.specialdict.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.specialdict.DrugDictModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.log.LogService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;


/**
 * Created by yww on 2016/4/20.
 */
@RequestMapping("/specialdict/drug")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class DrugDictController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    private ObjectMapper objectMapper;

    @RequestMapping("initial")
    public String drugInitial(Model model){
        model.addAttribute("contentPage","specialdict/drug/drug");
        return "pageView";
    }

    @RequestMapping("dialog/drugInfo")
    public String drugInfoTemplate(Model model,String id, String mode){
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","specialdict/drug/drugInfoDialog");
        Envelop envelop = new Envelop();
        String envelopStr = "";
        try {
            if(!StringUtils.isEmpty(id)){
                String url = "/dict/drug/"+id;
                envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(DrugDictController.class).error(ex.getMessage());
        }
        return "simpleView";
    }

    @RequestMapping("/drugs")
    @ResponseBody
    public Object getDrugDictList(String searchNm,Integer rows, Integer page){
        Envelop envelop = new Envelop();
        String filters = "";
        if(!StringUtils.isEmpty(searchNm)){
            filters = "code?"+searchNm+" g1;name?"+searchNm+" g1;";
        }
        try{
            String url = "/dict/drugs";
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(DrugDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    @RequestMapping("/delete")
    @ResponseBody
    public Object deleteDrugDict(String id) {
        String url = "/dict/drug/"+id;
        String envelopStr = "";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("id",id);
            envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
        }catch (Exception ex){
            LogService.getLogger(DrugDictController.class).error(ex.getMessage());
        }
        return envelopStr;
    }

    @RequestMapping("/deletes")
    @ResponseBody
    public Object deleteDrugDicts(String ids) {
        String url = "/dict/drugs";
        String envelopStr = "";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("ids",ids);
            envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
        }catch (Exception ex){
            LogService.getLogger(DrugDictController.class).error(ex.getMessage());
        }
        return envelopStr;
    }

    @RequestMapping("/update")
    @ResponseBody
    public Object updateDrugDict(String dictJson,String mode,HttpServletRequest request) {
        //新增、修改
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        String url = "/dict/drug";
        try{
            DrugDictModel model = objectMapper.readValue(dictJson,DrugDictModel.class);
            if("new".equals(mode)){
                model.setCreateUser(userDetailModel.getId());
                Map<String,Object> args = new HashMap<>();
                args.put("dictionary",objectMapper.writeValueAsString(model));
                String envelopStrNew = HttpClientUtil.doPost(comUrl+url,args,username,password);
                return envelopStrNew;
            }
            //获取原对象
            String urlGet = "/dict/drug/"+model.getId();
            String envelopStrGet = HttpClientUtil.doGet(comUrl+urlGet,username,password);
            Envelop envelopget = objectMapper.readValue(envelopStrGet,Envelop.class);
            if (!envelopget.isSuccessFlg()){
                envelop.setErrorMsg("药品字典获取失败！");
                return envelop;
            }
            DrugDictModel modelUpdate = getEnvelopModel(envelopget.getObj(),DrugDictModel.class);
            modelUpdate.setUpdateUser(userDetailModel.getId());
            modelUpdate.setCode(model.getCode());
            modelUpdate.setName(model.getName());
            modelUpdate.setType(model.getType());
            modelUpdate.setTradeName(model.getTradeName());
            modelUpdate.setUnit(model.getUnit());
            modelUpdate.setDescription(model.getDescription());
            modelUpdate.setSpecifications(model.getSpecifications());

            String modelUpdateJson = objectMapper.writeValueAsString(modelUpdate);
            Map<String,Object> params = new HashMap<>();
            params.put("dictionary",modelUpdateJson);
            String envelopStrUpdate = HttpClientUtil.doPut(comUrl+url,params,username,password);
            return envelopStrUpdate;
        }catch(Exception ex){
            LogService.getLogger(DrugDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/drugDictInfo")
    @ResponseBody
    public Object getDrugDict( String id){
        Envelop envelop = new Envelop();
        try {
            String url = "/dict/drug/"+id;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex) {
            LogService.getLogger(DrugDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    @RequestMapping("/isRelatedIcd10")
    @ResponseBody
    //"根据drug的ID判断是否与ICD10字典存在关联。
    public Object isRelatedIcd10(String id){
        Envelop envelop = new Envelop();
        String url = "/dict/drug/icd10/"+id;
        try{
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(DrugDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    //"判断提交的字典代码是否已经存在"
    @RequestMapping("/isCodeExist")
    @ResponseBody
    public Object isCodeExist(String code){
        Envelop envelop = new Envelop();
        String url = "/dict/drug/existence/code/"+code;
        try{
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(DrugDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/isNameExist")
    @ResponseBody
    //"判断提交的字典名称是否已经存在"
    public Object isNameExist(String name){
        Envelop envelop = new Envelop();
        String url = "/dict/drug/existence/name";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("name",name);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(DrugDictController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }
}
