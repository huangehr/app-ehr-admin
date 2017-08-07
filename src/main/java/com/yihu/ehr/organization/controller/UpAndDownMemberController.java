package com.yihu.ehr.organization.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.OrgAdapterPlanService;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.org.OrgDeptMemberModel;
import com.yihu.ehr.agModel.org.OrgDeptModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.model.org.MOrgMemberRelation;
import com.yihu.ehr.resource.controller.ResourceInterfaceController;
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
 * Created by janseny
 */

@Controller
@RequestMapping("/upAndDownMember")
public class UpAndDownMemberController extends ExtendController<OrgAdapterPlanService> {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("initialUpAndDownMember")
    public String deptMemberInitial(Model model,String mode, String orgCode, String orgId, String orgName){
        model.addAttribute("orgCode",orgCode);
        model.addAttribute("orgId",orgId);
        model.addAttribute("orgName",orgName);
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage", "/organization/upAndDownMember/upAndDownMember");
        return "pageView";
    }

    //成员上下级树目录数据
    @RequestMapping("/categories")
    @ResponseBody
    public Object getCategories(int orgId){
        List<MOrgMemberRelation> list = new ArrayList<>();
        try{
            String filters = "";
            String envelopStr = "";
            String url = "/orgDeptMember/getAllOrgDeptMember";
            Map<String,Object> params = new HashMap<>();
            filters = "orgId=" +orgId;
            params.put("filters",filters);
            envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopStr,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                list = (List<MOrgMemberRelation>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<>(),MOrgMemberRelation.class);
            }
        }catch (Exception ex){
            LogService.getLogger(UpAndDownMemberController.class).error(ex.getMessage());
        }
        return list;
    }

    /**
     * 查找下级成员
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchUpAndDownMembers")
    @ResponseBody
    public Object searchUpAndDownMembers(String searchNm,String userId,String orgId, int page, int rows) {
        String url = "/orgDeptMember/list";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("userName?" + searchNm + ";" );
        }
        stringBuffer.append("status=0;" );
        if (!StringUtils.isEmpty(userId)) {
            stringBuffer.append("parentUserId=" + userId + ";" );
        }
        if (!StringUtils.isEmpty(orgId)) {
            stringBuffer.append("orgId=" + orgId + ";" );
        }else{
            stringBuffer.append("orgId=-0;" );
        }
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }


    @RequestMapping("/infoInitial")
    public String OrgDeptMembersInfoInitial(Model model,String mode,String categoryId,String categoryOrgId,String categoryName){
        model.addAttribute("mode",mode);
        model.addAttribute("categoryId",categoryId);
        model.addAttribute("categoryOrgId",categoryOrgId);
        model.addAttribute("categoryName",categoryName);
        model.addAttribute("contentPage","/organization/upAndDownMember/upAndDownMemberInfoDialog");
        return "simpleView";
    }

    //更新
    @RequestMapping("/updateOrgDeptMember")
    @ResponseBody
    public Object updateOrgDeptMember(String dataJson,String pUserId,String parentUserName){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            OrgDeptMemberModel model = objectMapper.readValue(dataJson, OrgDeptMemberModel.class);
            if(StringUtils.isEmpty(model.getUserId())){
                envelop.setErrorMsg("用户不能为空！");
                return envelop;
            }
            model.setParentUserName(parentUserName);
            Map<String, Object> params = new HashMap<>();
            String urlGet = "";
            String envelopStr ="";
            OrgDeptMemberModel  updateModel = new OrgDeptMemberModel();
            urlGet = "/orgDeptMember/admin/" + pUserId;
            params.clear();
            params.put("memRelationId", pUserId);
            String envelopGetStr = HttpClientUtil.doGet(comUrl+urlGet , params,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
            updateModel = getEnvelopModel(envelopGet.getObj(),OrgDeptMemberModel.class);
            if (!envelopGet.isSuccessFlg()){
                envelop.setErrorMsg("原成员息获取失败！");
                return envelop;
            }
            //是否已添加的成员
            String resultStr = "";
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append("status=0;" );
            stringBuffer.append("userId=" + pUserId + ";" );
            stringBuffer.append("orgId=" + updateModel.getOrgId() + ";" );
            String filters = stringBuffer.toString();
            params.put("filters", filters);
            params.put("page", 1);
            params.put("size", 10);
            String url = "/orgDeptMember/list";
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            Envelop envelopResult = objectMapper.readValue(resultStr,Envelop.class);
            if(envelopResult.getDetailModelList()!=null && envelopResult.getDetailModelList().size()>0){
                envelop.setErrorMsg("该成员已添加！");
                return envelop;
            }
            model.setParentUserId(pUserId);
//            model.setParentUserName(updateModel.getParentUserName());
            model.setParentUserName(parentUserName);
            model.setDeptId(updateModel.getDeptId());
            model.setDeptName(updateModel.getDeptName());
            model.setOrgId(updateModel.getOrgId());
            model.setOrgName(updateModel.getOrgName());

            url = "/orgDeptMember";
            params.clear();
            String updateModelJson = objectMapper.writeValueAsString(model);
            params.put("memberRelationJsonData",updateModelJson);
            envelopStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            return envelopStr;

        }catch (Exception ex){
            LogService.getLogger(UpAndDownMemberController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }



    /**
     * 删除成员
     * @param memberRelationId
     * @return
     */
    @RequestMapping("deleteOrgDeptMember")
    @ResponseBody
    public Object deleteOrgDeptMember(int memberRelationId) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try {
            Map<String, Object> params = new HashMap<>();
            String url = "/orgDeptMember/updateStatus";
            params.clear();
            params.put("memberRelationId",memberRelationId);
            params.put("status",1);
            String envelopStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            if(envelopStr.equals("true")){
                envelop.setSuccessFlg(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return envelop;
    }



}
