package com.yihu.ehr.std.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.standard.standardsource.StdSourceDetailModel;
import com.yihu.ehr.agModel.user.UsersModel;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by zqb on 2015/9/18.
 */
@Controller
@RequestMapping("/standardsource")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class StdSourceManagerController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.stdsourceurl}")
    private String comUrl;

    @Autowired
    ObjectMapper objectMapper;

    public StdSourceManagerController() {
    }

    @RequestMapping("initial")
    public String cdaInitial(Model model) {
        model.addAttribute("contentPage","std/standardsource/standardsource");
        return "pageView";
    }

    @RequestMapping("template/stdInfo")
    public String stdInfoTemplate(Model model, String id, String mode) {
        Envelop envelop = new Envelop();
        String url = "/source/"+id;
        String envelopStr = "";
        try{
            envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
        }catch(Exception ex){
            LogService.getLogger(StdSourceManagerController.class).error(ex.getMessage());
        }
        model.addAttribute("envelop", StringUtils.isEmpty(envelopStr)?toJson(envelop):envelopStr);
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","/std/standardsource/stdInfoDialog");
        return "emptyView";
    }

    @RequestMapping("searchStdSource")
    @ResponseBody
    public Object searchStdSource(String searchNm, String searchType, Integer page, Integer rows) {
        Envelop envelop = new Envelop();
        String url = "/sources";
        StringBuffer filters = new StringBuffer();
        if(!StringUtils.isEmpty(searchNm)){
            filters.append("code?"+searchNm+" g1;name?"+searchNm+" g1;");
        }
        if(!StringUtils.isEmpty(searchType)){
            filters.append("sourceType="+searchType+";");
        }
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("size",rows);
            params.put("page",page);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if(StringUtils.isEmpty(envelopStr)){
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("获取标准数据源失败");
            }else{
                return envelopStr;
            }
        } catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return envelop;
    }

    @RequestMapping("getStdSource")
    @ResponseBody
    //获取标准来源信息
    public Object getStdSource(String id) {
        Envelop envelop = new Envelop();
        String url = "/stdSource/"+id;
        String envelopStr = "";
        try{
            envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            return envelopStr;
        } catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("updateStdSource")
    @ResponseBody
    public Object updateStdSource(String id,String code, String name, String type, String description,@ModelAttribute(SessionAttributeKeys.CurrentUser) UsersModel user) {
        //新增、修改标准来源
        Envelop envelop = new Envelop();
        String envelopStr = "";
        //非空判断
        if (StringUtils.isEmpty(code)){
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("标准来源编码不能为空！");
            return envelop;
        }
        if (StringUtils.isEmpty(name)){
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("标准来源名称不能为空！");
            return envelop;
        }
        if (StringUtils.isEmpty(code)){
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("标准来源类别不能为空！");
            return envelop;
        }

        try{
            Map<String,Object> params = new HashMap<>();
            // new
            if (StringUtils.isEmpty(id)){
                String urlNew = "/source";
                StdSourceDetailModel detailModel = new StdSourceDetailModel();
                detailModel.setCreateUser(user.getLoginCode());
                detailModel.setId(id);
                detailModel.setCode(code);
                detailModel.setName(name);
                detailModel.setSourceType(type);
                detailModel.setDescription(description);
                String modelJsonNew = objectMapper.writeValueAsString(detailModel);
                params.put("model",modelJsonNew);
                envelopStr = HttpClientUtil.doPost(comUrl+urlNew,params,username,password);
                return envelopStr;
            }

            // get
            String urlGet = "/source/"+id;
            String envelopStrGet = HttpClientUtil.doGet(comUrl+urlGet,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
            if (!envelopGet.isSuccessFlg()){
                return envelopStrGet;
            }
            StdSourceDetailModel modelForUpdate = getEnvelopModel(envelopGet.getObj(),StdSourceDetailModel.class);

            //update
            modelForUpdate.setUpdateUser(user.getLoginCode());
            modelForUpdate.setCode(code);
            modelForUpdate.setName(name);
            modelForUpdate.setSourceType(type);
            modelForUpdate.setDescription(description);
            String urlUpdate = "/source";
            String modelJsonUpdate = objectMapper.writeValueAsString(modelForUpdate);
            params.put("model",modelJsonUpdate);
            envelopStr = HttpClientUtil.doPut(comUrl+urlUpdate,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("delStdSource")
    @ResponseBody
    public Object delStdSource(String id) {
        Envelop envelop = new Envelop();
        String envelopStr = "";
        if (StringUtils.isEmpty(id)){
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("标准来源id号不能为空！");
            return envelop;
        }
        String url = "/sources";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("ids",id);
            envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
//            envelop = toModel(envelopStr,Envelop.class);
//            if(envelop.isSuccessFlg()){
//                envelop.setSuccessFlg(true);
//            }else{
//                envelop.setSuccessFlg(false);
//            }
        } catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

//    public Envelop isDeleteStdSource(String id){
//
//        String resultStr = "";
//        String filters = "sourceId="+id;
//        Envelop envelop = new Envelop();
//        Map<String, Object> params = new HashMap<>();
//
//        params.put("fields", "");
//        params.put("filters","");
//        params.put("sorts","");
//        params.put("page",1);
//        params.put("size",9999);
//
//        try {
////            String url = "/dicts";
//            String url = "/versions";
//            //查询所有版本
//            ResponseEntity<Collection<MCDAVersion>> responseEntity = cdaVersionClient.searchCDAVersions(fields, filters, sorts, size, page);
//            Collection<MCDAVersion> mCdaVersions = responseEntity.getBody();
//
//            envelop = toModel(envelopStr,Envelop.class);
//            List<StdVersionModel> stdSourceModels = envelop.getDetailModelList();
//            for (StdVersionModel stdVersionModel:stdSourceModels){
//                params.put("filters",filters);
//                params.put("size",id.split(",").length);
//                resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
//                envelop = toModel(resultStr,Envelop.class);
//                if (envelop.getDetailModelList().size() > 0){
//
//                }else {
////                    resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
//                }
//            }
//
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }

    @RequestMapping("isSourceCodeExit")
    @ResponseBody
    public boolean isSourceCodeExit(String code) {
        String url = "/source/is_exist";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("code",code);
            String _msg = HttpClientUtil.doGet(comUrl+url,params,username,password);
            if(Boolean.parseBoolean(_msg)){
                return true;
            }
        }catch (Exception ex){
            LogService.getLogger(StdSourceManagerController.class).error(ex.getMessage());
        }
        return false;
    }

    /**
     * 通用的用于下拉列表框(获取所有标准来源)
     * @return
     */
    @RequestMapping("getStdSourceList")
    @ResponseBody
    public Object getStdSourceList() {
        Envelop envelop = new Envelop();
        String url = "/sources/no_paging";
        try{
            String filters = "";
            //后期根据需要添加过滤参数
            Map<String,Object> params = new HashMap<>();
            params.put("filters",filters);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if(StringUtils.isEmpty(envelopStr)){
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("获取标准数据源失败");
            }else{
                return envelopStr;
            }
        } catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return envelop;
    }


}
