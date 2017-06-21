package com.yihu.ehr.portal.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.portal.PortalNoticeDetailModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
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
 * Created by yeshijie on 2017/2/13.
 */
@Controller
@RequestMapping("/portalNotice")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class PortalNoticesController extends BaseUIController {
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
        model.addAttribute("contentPage", "/portal/notice/portalNotice");
        return "pageView";
    }

    /**
     * 新增页面
     * @param model
     * @return
     */
    @RequestMapping("addNoticeInfoDialog")
    public String addNotice(Model model) {
        model.addAttribute("contentPage", "portal/notice/addPortalNoticeDialog");
        return "generalView";
    }

    /**
     * 查找通知
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchPortalNotices")
    @ResponseBody
    public Object searchPortalNotices(String searchNm, int page, int rows) {
        String url = "/portalNotices";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("search", searchNm);
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("title?" + searchNm );
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
     * @param portalNoticeModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updatePortalNotice", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updatePortalNotice(String portalNoticeModelJsonData,
                                     HttpServletRequest request) throws IOException{

        String url = "/portalNotice/";
        String resultStr = "";
        System.out.println();
        Envelop result = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        String strings = URLDecoder.decode(portalNoticeModelJsonData, "UTF-8");
        PortalNoticeDetailModel detailModel = toModel(strings, PortalNoticeDetailModel.class);
        RestTemplates templates = new RestTemplates();

        try {
            if (!StringUtils.isEmpty(detailModel.getId())) {
                Long portalNoticeId = detailModel.getId();
                resultStr = templates.doGet(comUrl + "/portalNotices/admin/" + portalNoticeId);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    PortalNoticeDetailModel updateNotice = getEnvelopModel(envelop.getObj(), PortalNoticeDetailModel.class);

                    updateNotice.setTitle(detailModel.getTitle());
                    updateNotice.setType(detailModel.getType());
                    updateNotice.setPortalType(detailModel.getPortalType());
                    updateNotice.setContent(detailModel.getContent());

                    params.add("portalNotice_json_data", toJson(updateNotice));

                    resultStr = templates.doPut(comUrl + url, params);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else {
                detailModel.setReleaseAuthor(userDetailModel.getId());
                params.add("portalNotice_json_data", toJson(detailModel));
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
     * 删除通知
     * @param portalNoticeId
     * @return
     */
    @RequestMapping("deletePortalNotice")
    @ResponseBody
    public Object deletePortalNotice(Long portalNoticeId) {
        String url = "/portalNotices/admin/" + portalNoticeId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("portalNoticeId", portalNoticeId);
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
     * 根据id获取通知
     * @param model
     * @param portalNoticeId
     * @param mode
     * @return
     */
    @RequestMapping("getPortalNotice")
    public Object getPortalNotice(Model model, Long portalNoticeId, String mode) {
        String url = "/portalNotices/admin/"+portalNoticeId;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("portalNoticeId", portalNoticeId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            PortalNoticeDetailModel detailModel = toModel(toJson(ep.getObj()),PortalNoticeDetailModel.class);
            model.addAttribute("allData", resultStr);
            model.addAttribute("mode", mode);
            model.addAttribute("contentPage", "portal/notice/portalNoticeInfoDialog");
            return "simpleView";
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

}
