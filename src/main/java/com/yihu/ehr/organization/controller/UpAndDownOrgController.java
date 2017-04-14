package com.yihu.ehr.organization.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.OrgAdapterPlanService;
import com.yihu.ehr.agModel.org.OrgDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.model.org.MOrgMemberRelation;
import com.yihu.ehr.model.org.MOrganization;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
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
 * Created by janseny on
 */

@Controller
@RequestMapping("/upAndDownOrg")
public class UpAndDownOrgController extends ExtendController<OrgAdapterPlanService> {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("initialUpAndDownOrg")
    public String deptMemberInitial(Model model,String mode, String dataModel){
        model.addAttribute("dataModel",dataModel);
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage", "/organization/upAndDownOrg/upAndDownOrg");
        return "pageView";
    }

    //机构上下级树目录数据
    @RequestMapping("/categories")
    @ResponseBody
    public Object getCategories(){
        List<MOrganization> list = new ArrayList<>();
        try{
            String envelopStr = "";
            String url = "/organizations/getAllOrgs";
            envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopStr,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                list = (List<MOrganization>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<>(),MOrganization.class);
            }
        }catch (Exception ex){
            LogService.getLogger(UpAndDownOrgController.class).error(ex.getMessage());
        }
        return list;
    }

    /**
     * 查找下级机构
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchupAndDownOrgs")
    @ResponseBody
    public Object searchupAndDownOrgs(String searchNm,String orgId, int page, int rows) {
        String url = "/organizations";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("fullName?" + searchNm + ";" );
        }
        stringBuffer.append("parentHosId=" + orgId + ";" );

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
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }


    @RequestMapping("/infoInitial")
    public String OrgDeptMembersInfoInitial(Model model,String categoryId){
        model.addAttribute("categoryId",categoryId);
        model.addAttribute("contentPage","/organization/upAndDownOrg/upAndDownOrgInfoDialog");
        return "simpleView";
    }

    //更新 上级 机构
    @RequestMapping("/updateOrgDeptMember")
    @ResponseBody
    public Object updateOrgDeptMember(String orgId,int pOrgId,String mode){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            if(StringUtils.isEmpty(orgId)){
                envelop.setErrorMsg("机构不能为空！");
                return envelop;
            }
            //过滤已添加的成员 TODO

            String urlGet = "";
            String envelopStr ="";
            urlGet = "/organizations/getOrgById/" + orgId;
            Map<String, Object> params = new HashMap<>();
            params.put("org_id", orgId);
            String envelopGetStr = HttpClientUtil.doPut(comUrl+urlGet , params,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
            OrgDetailModel  updateModel = new OrgDetailModel();
            updateModel = getEnvelopModel(envelopGet.getObj(),OrgDetailModel.class);
            if (!envelopGet.isSuccessFlg()){
                envelop.setErrorMsg("原成员息获取失败！");
            }
            if(mode.equals("del")){
                updateModel.setParentHosId(null);
            }else if(mode.equals("modify")){
                updateModel.setParentHosId(pOrgId);
            }
            String url = "/organization";
            params.clear();
            String updateModelJson = objectMapper.writeValueAsString(updateModel);
            params.put("mOrganizationJsonDatas",updateModelJson);
            envelopStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return envelopStr;

        }catch (Exception ex){
            LogService.getLogger(UpAndDownOrgController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }






}
