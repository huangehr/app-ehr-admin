package com.yihu.ehr.archive.controller;

import com.yihu.ehr.agModel.patient.ArApplyModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by zqb on 2015/8/14.
 */
@Controller
@RequestMapping("/archive/apply")
public class ArApplyController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    public ArApplyController() {
    }

    @RequestMapping("initial")
    public String userInitial(Model model) {
        model.addAttribute("contentPage", "/archive/apply/arApplyManage");
        return "pageView";
    }

    @RequestMapping("arApplyDialog")
    public String msgDialog(Model model,String status,String id) {
        try{
            //根据ID获取申请信息
            String url = "/patientArchive/apply";
            Map<String, Object> params = new HashMap<>();
            params.put("id",id);
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop result = getEnvelop(resultStr);
            if(result.getObj()!=null){
                Object list =  result.getObj();
                model.addAttribute("mode",toJson(list));
            }else{
                ArApplyModel arApplyModel =  new ArApplyModel();
                arApplyModel.setId(Integer.parseInt(id));
                model.addAttribute("mode",toJson(arApplyModel));
            }
            if("view".equals(status)){
                model.addAttribute("contentPage", "/archive/apply/arApplyRejectDialog");
            }else if("success".equals(status)){//查看预关联
                model.addAttribute("contentPage", "/archive/apply/arApplyPassDialog");
                if(result.getDetailModelList()!=null&&result.getDetailModelList().size()==1){
                    Object list =  result.getDetailModelList().get(0);
                    model.addAttribute("archives",toJson(list));
                }else{
                    String relaUrl = "/patientArchive/" + id + "/getArRelation";
                    Map<String, Object> relaParams = new HashMap<>();
                    /*relaParams.put("applyId",id);*/
                    String relaResultStr = HttpClientUtil.doGet(comUrl + relaUrl, relaParams, username, password);
                    Envelop relaResult = getEnvelop(relaResultStr);
                    if(relaResult.getObj()!=null){
                        Object obj =  relaResult.getObj();
                        model.addAttribute("archives",toJson(obj));
                    }else{
                        model.addAttribute("archives",toJson(new ArApplyModel()));
                    }
                }
            }else if("audit".equals(status)){
                model.addAttribute("contentPage", "/archive/apply/arApplyDialog");
            }
        }catch (Exception e){
            LogService.getLogger(ArApplyController.class).error(e.getMessage());
        }
        return "pageView";
    }

    /**
     *  根据查询条件查询申请列表
     * @param status
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("getApplyList")
    @ResponseBody
    public Object getApplyList(String status,String searchNm, int page, int rows) {
        String url = "/patientArchive/getApplyList";
        String resultStr = "";
        String filters = "";
        if (!StringUtils.isEmpty(searchNm)) {
            filters += "name?" + searchNm + " g1;idCard?" + searchNm + " g1;";
        }
        if (!StringUtils.isEmpty(status)) {
            filters += "status=" + status + ";";
        }

        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("fields", "");
        params.put("filters", filters);
        params.put("size", rows);
        params.put("page", page);
        params.put("sorts", "");
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 辅助档案审核,查询按姓名，身份证号，及就诊卡号查询关联的档案列表
     * @param name
     * @param idCardNo
     * @param cardNo
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("getArRelaListForAudit")
    @ResponseBody
    public Object getApplyListForAudit(String name,String idCardNo, String cardNo,int page, int rows) {
        String url = "/patientArchive/getArRelationList";
        String resultStr = "";
        String filters = "";
        if (!StringUtils.isEmpty(name)) {
            filters += "name?" + name + ";";
        }
        if (!StringUtils.isEmpty(idCardNo)) {
            filters += "idCardNo=" + idCardNo + ";";
        }
        if (!StringUtils.isEmpty(cardNo)) {
            filters += "cardNo=" + cardNo + ";";
        }
        filters += "status=0;";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("fields", "");
        params.put("filters", filters);
        params.put("size", rows);
        params.put("page", page);
        params.put("sorts", "");
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("getArApplyList")
    @ResponseBody
    public Object getArApplyList(String status, int page, int rows) {
        String url = "/patientArchive/applyList";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("status", status);
        params.put("page", page);
        params.put("rows", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("getArApply")
    @ResponseBody
    public Object getArApply(String id) {
        String url = "/patientArchive/apply";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);

        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("deleteArApply")
    @ResponseBody
    public Object deleteArApply(String id) {
        String url = "/patientArchive/apply";
        String resultStr = "";
        Envelop result = new Envelop();
        try {
            RestTemplates restTemplates = new RestTemplates();
            resultStr = restTemplates.doDelete(comUrl + url);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 更新档案关联申请的审核状态（ArApply），并批量更新档案关联的关联状态(ArRela)
     * @param applyId
     * @param status
     * @param auditReason
     * @param archiveRelationIds
     * @return
     */
    @RequestMapping("arApplyAudit")
    @ResponseBody
    public Object arApplyAudit(String applyId,String status ,String auditReason,String archiveRelationIds, HttpServletRequest request) {
        Envelop result = new Envelop();
        String resultStr = "";
        try {
            String url = "/patientArchive/manager/verify";
            UserDetailModel userDetailModel = getCurrentUserRedis(request);
            Map<String, Object> params = new HashMap<>();
            params.put("id", applyId);
            params.put("status", status);
            params.put("auditor", userDetailModel.getId());
            params.put("auditReason", auditReason);
            params.put("archiveRelationIds", archiveRelationIds);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }


}
