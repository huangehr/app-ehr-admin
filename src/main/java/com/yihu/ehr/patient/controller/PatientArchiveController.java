package com.yihu.ehr.patient.controller;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.web.RestTemplates;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by zqb on 2015/8/14.
 */
@Controller
@RequestMapping("/patient/arApply")
public class PatientArchiveController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    public PatientArchiveController() {
    }

    @RequestMapping("initial")
    public String patientInitial(Model model) {
        model.addAttribute("contentPage", "/patient/arApply/arApply");
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
    public Object searchPatient(String id) {
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
    public Object deletePatient(String id) {
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
}
