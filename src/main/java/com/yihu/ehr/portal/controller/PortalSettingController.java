package com.yihu.ehr.portal.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.portal.PortalSettingModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by zhoujie on 2017/3/13.
 */
@Controller
@RequestMapping("/portalSetting")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class PortalSettingController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 列表页
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String patientInitial(Model model) {
        model.addAttribute("contentPage", "/portal/setting/portalSetting");
        return "pageView";
    }

    /**
     * 新增页面
     * @param model
     * @return
     */
    @RequestMapping("addPortalSettingInfoDialog")
    public String addPortalSetting(Model model) {
        model.addAttribute("contentPage", "portal/setting/addPortalSettingDialog");
        return "generalView";
    }

    /**
     * 查找消息
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchPortalSettings")
    @ResponseBody
    public Object searchPortalSettings(String searchNm, int page, int rows) {
        String url = "/portalSetting";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("search", searchNm);
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("appId?" + searchNm );
        }
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

    /**
     * 新增修改
     * @param portalSettingModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updatePortalSetting", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updatePortalSetting(String portalSettingModelJsonData, HttpServletRequest request) throws IOException{

        String url = "/portalSetting/";
        String resultStr = "";
        System.out.println();
        Envelop result = new Envelop();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        String[] strings = URLDecoder.decode(portalSettingModelJsonData, "UTF-8").split(";");
        PortalSettingModel detailModel = toModel(strings[0], PortalSettingModel.class);
        RestTemplates templates = new RestTemplates();

        try {
            if (!StringUtils.isEmpty(detailModel.getId())) {
                Long portalSettingId = detailModel.getId();
                resultStr = templates.doGet(comUrl + "/portalSetting/admin/" + portalSettingId);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    PortalSettingModel updatePortalSetting = getEnvelopModel(envelop.getObj(), PortalSettingModel.class);

                    updatePortalSetting.setAppId(detailModel.getAppId());
                    updatePortalSetting.setOrgId(detailModel.getOrgId());
                    updatePortalSetting.setColumnRequestType(detailModel.getColumnRequestType());
                    updatePortalSetting.setColumnUri(detailModel.getColumnUri());
                    updatePortalSetting.setColumnName(detailModel.getColumnName());
                    updatePortalSetting.setAppApiId(detailModel.getAppApiId());
                    updatePortalSetting.setStatus(detailModel.getStatus());
                    params.add("portalSetting_json_data", toJson(updatePortalSetting));

                    resultStr = templates.doPut(comUrl + url, params);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else {
                params.add("portalSetting_json_data", toJson(detailModel));
                resultStr = templates.doPost(comUrl + url, params);
            }
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
        return resultStr;
    }

    /**
     * 删除消息
     * @param portalSettingId
     * @return
     */
    @RequestMapping("deletePortalSetting")
    @ResponseBody
    public Object deletePortalSetting(Long portalSettingId) {
        String url = "/portalSetting/admin/" + portalSettingId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("portalSettingId", portalSettingId);
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            result = mapper.readValue(resultStr, Envelop.class);
            if (result.isSuccessFlg()) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidDelete.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 根据id获取消息
     * @param model
     * @param portalSettingId
     * @param mode
     * @return
     */
    @RequestMapping("getPortalSetting")
    public Object getPortalSetting(Model model, Long portalSettingId, String mode) {
        String url = "/portalSetting/admin/"+portalSettingId;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("portalSettingId", portalSettingId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);

            Envelop ep = getEnvelop(resultStr);
            PortalSettingModel detailModel = toModel(toJson(ep.getObj()),PortalSettingModel.class);
            model.addAttribute("allData", resultStr);
            model.addAttribute("mode", mode);
            model.addAttribute("contentPage", "portal/setting/portalSettingInfoDialog");
            return "simpleView";
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

}
