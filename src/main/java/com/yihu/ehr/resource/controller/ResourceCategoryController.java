package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.standard.cdatype.CdaTypeDetailModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.model.resource.MRsCategory;
import com.yihu.ehr.util.Envelop;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by AndyCai on 2015/12/14.
 */
@RequestMapping("/rscategory")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class ResourceCategoryController extends BaseUIController{
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("index")
    public String cdaTypeInitial(Model model) {
        model.addAttribute("contentPage", "resource/rscategory/index");
        return "pageView";
    }

    @RequestMapping("typeupdate")
    public String typeupdate(Model model,HttpServletRequest request) {
        model.addAttribute("id", request.getParameter("id"));
        model.addAttribute("contentPage", "resource/rscategory/RsCategoryDetail");
        return "generalView";
    }

    @RequestMapping("getTreeGridData")
    @ResponseBody
    //获取TreeData 用于初始页面显示嵌套model
    public Object getTreeGridData(String codeName) {
        Envelop envelop = new Envelop();
        Map<String,Object> params = new HashMap<>();
        String url ="/resources/categories/tree";
        String strResult = "";
        if (StringUtils.isEmpty(codeName)){
            codeName = "";
        }else{
            params.put("name",codeName);
        }
        try{
            strResult = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return strResult;
        }catch(Exception ex){
            LogService.getLogger(ResourceCategoryController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("getCdaTypeList")
    @ResponseBody
    public Object GetCdaTypeList(String strKey, Integer page, Integer rows) {
        Envelop envelop = new Envelop();
        String url = "/cda_types/no_paging";
        String filters = "";
        if(!StringUtils.isEmpty(strKey)){
            filters = "code?"+strKey+" g1;name?"+strKey+" g1;";
        }
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("filters",filters);
            String _rus = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return _rus;
        }catch (Exception ex){
            LogService.getLogger(ResourceCategoryController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping("getCateTypeById")
    @ResponseBody
    public Object getCdaTypeById(String strIds) {
        Envelop envelop = new Envelop();
        String url = "/resources/categories/"+strIds;
        try{
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceCategoryController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping("delteCateTypeInfo")
    @ResponseBody
    /**
     * 删除CDA类别，若该类别存在子类别，将一并删除子类别
     * 先根据当前的类别ID获取全部子类别ID，再进行删除
     * @param  ids  cdaType Id
     *  @return result 操作结果
     */
    public Object delteCdaTypeInfo(String id) {
        Envelop result = new Envelop();
        if (StringUtils.isEmpty(id)){
            result.setErrorMsg("请选择要删除的数据");
            result.setSuccessFlg(false);
            return result;
        }
        try{
            String url = "/resources/categories/"+id;
            Map<String,Object> params = new HashMap<>();
            params.put("id",id);
            String _msg = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            return _msg;
        }catch (Exception ex){
            LogService.getLogger(ResourceCategoryController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return result;
    }

    @RequestMapping("saveCateType")
    @ResponseBody
    //新增、修改的保存合二为一
    public Object SaveCdaType(String dataJson,HttpServletRequest request) {
        Envelop envelop = new Envelop();
        Map<String,Object> params = new HashMap<>();
        envelop.setSuccessFlg(false);
        String url = "/resources/categories/no_paging";
        try {
            MRsCategory detailModel = objectMapper.readValue(dataJson,MRsCategory.class);
            if(StringUtils.isEmpty(detailModel.getName())){
                envelop.setErrorMsg("类别名称不能为空！");
                return envelop;
            }
            params.put("resourceCategory",dataJson);
            String envelopStrUpdate=null;
            if(StringUtils.isNotBlank(detailModel.getId())) {
                envelopStrUpdate = HttpClientUtil.doPut(comUrl + url, params, username, password);
            }else{
                envelopStrUpdate = HttpClientUtil.doPost(comUrl + url, params, username, password);
            }
            return envelopStrUpdate;
        } catch (Exception ex){
            LogService.getLogger(ResourceCategoryController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    /**
     * 获取可以作为父类别的cate类别列表
     * @param strId
     * @param codeName
     * @return
     */
    @RequestMapping("getCateTypeExcludeSelfAndChildren")
    @ResponseBody
    public Object getCdaTypeExcludeSelfAndChildren(String strId, String codeName) {
        //页面新增修改访问的是同个接口
        Envelop envelop = new Envelop();
        try{
            String urlGetAll = "/resources/categories";
            Map<String,Object> params = new HashMap<>();
            if(!StringUtils.isEmpty(strId)){
                params.put("filters","id<>"+strId);
            }
            String envelopStr = HttpClientUtil.doGet(comUrl+urlGetAll,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceCategoryController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }

    }

    @RequestMapping("getCateTypeByPid")
    @ResponseBody
    public Object getCateTypeByPid(String id) {
        Envelop envelop = new Envelop();
        ObjectMapper mapper = new ObjectMapper();
        Map<String,Object> params = new HashMap<>();
        String url = "/resources/categories/pid/";
        try {
            params.put("pid",id);
            String envelopStr = HttpClientUtil.doGet(comUrl + url,params,username, password);
            envelop = mapper.readValue(envelopStr,Envelop.class);
            return envelop.getDetailModelList();
        } catch (Exception ex) {
            LogService.getLogger(ResourceCategoryController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }
}
