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
 * Created by janseny on 2017/3/30.
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
    public String deptMemberInitial(Model model,String mode, String dataModel){
        model.addAttribute("dataModel",dataModel);
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage", "/organization/upAndDownMember/upAndDownMember");
        return "pageView";
    }

    //成员上下级树目录数据
    @RequestMapping("/categories")
    @ResponseBody
    public Object getCategories(){
        List<MOrgMemberRelation> list = new ArrayList<>();
        try{
            String filters = "";
            String envelopStr = "";
            String url = "/orgDeptMember/getAllOrgDeptMember";
            Map<String,Object> params = new HashMap<>();
            params.put("filters",filters);
            envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopStr,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                list = (List<MOrgMemberRelation>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<>(),MOrgMemberRelation.class);
            }
        }catch (Exception ex){
            LogService.getLogger(DeptMemberController.class).error(ex.getMessage());
        }
        return list;
    }


    @RequestMapping("/getOrgMemberList")
    @ResponseBody
    public Object getOrgMemberList( String searchParm, int page, int rows,String orgId) {
        try {
            String url = "/orgDeptMember/list";
            PageParms pageParms = new PageParms(rows, page)
                    .addEqual("orgId",orgId)
                    .addLikeNotNull("userName", searchParm);
            String resultStr = service.search(url, pageParms);
            return formatComboData(resultStr, "id", "realName");
        } catch (Exception e) {
            return systemError();
        }
    }

    @RequestMapping("/infoInitial")
    public String OrgDeptMembersInfoInitial(Model model,String mode,String categoryId,String type){
        model.addAttribute("mode",mode);
        model.addAttribute("categoryId",categoryId);
        model.addAttribute("type",type);
        model.addAttribute("contentPage","/organization/upAndDownMember/upAndDownMemberInfoDialog");
        return "simpleView";
    }

    //更新
    @RequestMapping("/updateOrgDeptMember")
    @ResponseBody
    public Object updateOrgDeptMember(String dataJson,String type,String userId){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        String url = "/orgDeptMember";
        try{
            OrgDeptMemberModel model = objectMapper.readValue(dataJson, OrgDeptMemberModel.class);
            if(StringUtils.isEmpty(model.getUserId())){
                envelop.setErrorMsg("用户不能为空！");
                return envelop;
            }
            String urlGet = "";
            OrgDeptMemberModel  updateModel = new OrgDeptMemberModel();
            if(type.equals("1")){//增加上级成员
                urlGet = "/orgDeptMember/admin/" + userId;
                String envelopGetStr = HttpClientUtil.doGet(comUrl+urlGet,username,password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                updateModel = getEnvelopModel(envelopGet.getObj(),OrgDeptMemberModel.class);
                if (!envelopGet.isSuccessFlg()){
                    envelop.setErrorMsg("原成员息获取失败！");
                }
                updateModel.setParentUserId(model.getUserId());
            }else if(type.equals("2")){//增加下级成员
                urlGet = "/orgDeptMember/admin/" + model.getUserId();
                String envelopGetStr = HttpClientUtil.doGet(comUrl+urlGet,username,password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr,Envelop.class);
                updateModel = getEnvelopModel(envelopGet.getObj(),OrgDeptMemberModel.class);
                if (!envelopGet.isSuccessFlg()){
                    envelop.setErrorMsg("原成员息获取失败！");
                }
                updateModel.setParentUserId(userId);
            }

            String updateModelJson = objectMapper.writeValueAsString(updateModel);
            Map<String,Object> params = new HashMap<>();
            params.put("memberRelationJsonData",updateModelJson);
            String envelopStr = HttpClientUtil.doPut(comUrl+url,params,username,password);
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
       return "";
    }



}
