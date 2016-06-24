package com.yihu.ehr.claim.controller;

import com.yihu.ehr.agModel.patient.ArApplyModel;
import com.yihu.ehr.api.ServiceApi;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.model.patient.MArApply;
import com.yihu.ehr.util.DateTimeUtils;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

/**
 * Created by wq on 2016/6/21.
 */

@Controller
@RequestMapping("/audit")
public class AuditController extends BaseUIController{

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/initial")
    public String initial(Model model,String claimId){

        Envelop envelopTest = new Envelop();
        List<MArApply>  mArApplyListTest = new ArrayList<>();
        MArApply mArApplyTest = new MArApply();

        mArApplyTest.setVisDate("");
        mArApplyTest.setId(123);
        mArApplyTest.setVisOrg("就诊机构");
        mArApplyTest.setVisDoctor("就诊医生");
        mArApplyTest.setCardNo("开号");
        mArApplyTest.setDiagnosedResult("就赠结果");
        mArApplyTest.setDiagnosedProject("检查项目");
        mArApplyTest.setMedicines("诊断开药");
        mArApplyTest.setMemo("备注");

        MArApply mArApplyTest2 = new MArApply();

        mArApplyTest2.setId(456);
        mArApplyTest2.setVisDate("");
        mArApplyTest2.setVisOrg("就诊机构2");
        mArApplyTest2.setVisDoctor("就诊医生2");
        mArApplyTest2.setCardNo("开号2");
        mArApplyTest2.setDiagnosedResult("就赠结果2");
        mArApplyTest2.setDiagnosedProject("检查项目2");
        mArApplyTest2.setMedicines("诊断开药2");
        mArApplyTest2.setMemo("备注2");

        mArApplyListTest.add(mArApplyTest);
        mArApplyListTest.add(mArApplyTest2);
        envelopTest.setDetailModelList(mArApplyListTest);

//        String url = "/archive/applications/1"+claimId;
        String url = "/archive/applications/5";
        Map<String, Object> params = new HashMap<>();
        String resultStr = null;
        String ApplyStr = null;
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            params.put("filters","id="+claimId);
            url = ServiceApi.Patients.ArApplications;
//            ApplyStr = HttpClientUtil.doGet(comUrl + url, params, username, password);

        } catch (Exception e) {
            e.printStackTrace();
        }

        model.addAttribute("claimModel",resultStr);
        model.addAttribute("contentPage","claim/audit");
        model.addAttribute("ApplyStr",toJson(envelopTest));
        return "pageView";
    }


    @RequestMapping("/saveAudit")
    @ResponseBody
    public String saveAudit(String applyId,String matchingId){
        String url = "/audit/saveAudit/";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("applyId", applyId);
        params.put("matchingId", matchingId);
        try {
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);

        } catch (Exception e) {

        }
        return resultStr;
    }

//    @RequestMapping("/updateClaim")
//    @ResponseBody
//    public String updateClaim(String ClaimId,String unrelevance){
//        String url = "/audit/updateClaim/";
//        String resultStr = "";
//        Map<String, Object> params = new HashMap<>();
//        params.put("ClaimId", ClaimId);
//        params.put("unrelevance", unrelevance);
//        try {
//            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
//
//        } catch (Exception e) {
//
//        }
//        return resultStr;
//    }

    @RequestMapping("/addArRelations")
    @ResponseBody
    public String addArRelations(String relationModel){
        String url = ServiceApi.Patients.ArRelations;
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("model", relationModel);
        try {
            resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);

        } catch (Exception e) {

        }
        return resultStr;
    }

    @RequestMapping("/updateClaim")
    @ResponseBody
    public String updateClaim(String jsonModel) {

        String url = ServiceApi.Patients.ArApplications;
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();


        try {
            ArApplyModel arApplyModel = toModel(jsonModel, ArApplyModel.class);
            Date date = DateTimeUtils.simpleDateParse(arApplyModel.getApplyDate());
            String applyData = DateTimeUtils.utcDateTimeFormat(date);

            arApplyModel.setApplyDate(applyData);
//            date = DateTimeUtils.utcDateTimeParse(arApplyModel.getAuditDate());
//            String auditDate = DateTimeUtils.utcDateTimeFormat(date);
//            arApplyModel.setAuditDate(auditDate);
            jsonModel = toJson(arApplyModel);

            params.put("model", jsonModel);
            resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);

        } catch (Exception e) {

        }
        return resultStr;
    }
}
