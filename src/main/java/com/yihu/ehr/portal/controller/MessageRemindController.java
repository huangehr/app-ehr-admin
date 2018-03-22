package com.yihu.ehr.portal.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.OrgAdapterPlanService;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.portal.MessageRemindModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
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
@RequestMapping("/messageRemind")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class MessageRemindController extends ExtendController<OrgAdapterPlanService> {
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
    @RequestMapping("initialMessageRemind")
    public String messageRemindInitial(Model model) {
        model.addAttribute("contentPage", "/portal/message/messageRemind");
        return "pageView";
    }

    /**
     * 新增页面
     * @param model
     * @return
     */
    @RequestMapping("addMessageRemindInfoDialog")
    public String addMessageRemind(Model model) {
        model.addAttribute("contentPage", "portal/message/addMessageRemindDialog");
        return "generalView";
    }

    /**
     * 查找消息
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchMessageReminds")
    @ResponseBody
    public Object searchMessageReminds(String searchNm, int page, int rows) {
        String url = "/messageRemindList";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("search", searchNm);
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("appName?" + searchNm );
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
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 新增修改
     * @param messageRemindModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updateMessageRemind", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateMessageRemind(String messageRemindModelJsonData, HttpServletRequest request) throws IOException{

        String url = "/messageRemind/";
        String resultStr = "";
        System.out.println();
        Envelop result = new Envelop();
        UsersModel userDetailModel = getCurrentUserRedis(request);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        String[] strings = URLDecoder.decode(messageRemindModelJsonData, "UTF-8").split(";");
        MessageRemindModel detailModel = toModel(strings[0], MessageRemindModel.class);
        RestTemplates templates = new RestTemplates();

        try {
            if (!StringUtils.isEmpty(detailModel.getId())) {
                Long messageRemindId = detailModel.getId();
                resultStr = templates.doGet(comUrl + "/messageRemind/admin/" + messageRemindId);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    MessageRemindModel updateMessageRemind = getEnvelopModel(envelop.getObj(), MessageRemindModel.class);

                    updateMessageRemind.setAppId(detailModel.getAppId());
                    updateMessageRemind.setAppName(detailModel.getAppName());
                    updateMessageRemind.setContent(detailModel.getContent());
                    updateMessageRemind.setToUserId(detailModel.getToUserId());
                    updateMessageRemind.setTypeId(detailModel.getTypeId());
                    updateMessageRemind.setWorkUri(detailModel.getWorkUri());
                    params.add("messageRemind_json_data", toJson(updateMessageRemind));

                    resultStr = templates.doPut(comUrl + url, params);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else {
                detailModel.setReaded(0);
                detailModel.setFromUserId(userDetailModel.getId());
                params.add("messageRemind_json_data", toJson(detailModel));
                resultStr = templates.doPost(comUrl + url, params);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return resultStr;
    }

    /**
     * 删除消息
     * @param messageRemindId
     * @return
     */
    @RequestMapping("deleteMessageRemind")
    @ResponseBody
    public Object deleteMessageRemind(Long messageRemindId) {
        String url = "/messageRemind/admin/" + messageRemindId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("messageRemindId", messageRemindId);
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            result = mapper.readValue(resultStr, Envelop.class);
            if (result.isSuccessFlg()) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg("删除失败");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    /**
     * 根据id获取消息
     * @param model
     * @param messageRemindId
     * @param mode
     * @return
     */
    @RequestMapping("getMessageRemind")
    public Object getMessageRemind(Model model, Long messageRemindId, String mode) {
        String url = "/messageRemind/admin/"+messageRemindId;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("messageRemindId", messageRemindId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);

            Envelop ep = getEnvelop(resultStr);
            MessageRemindModel detailModel = toModel(toJson(ep.getObj()),MessageRemindModel.class);
            model.addAttribute("allData", resultStr);
            model.addAttribute("mode", mode);
            model.addAttribute("contentPage", "portal/message/messageRemindInfoDialog");
            return "simpleView";
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("/getUserList")
    @ResponseBody
    public Object getUserList(String type, String version, String mode, String searchParm, int page, int rows) {
        try {
            String adapterOrgs = "";
            String url = "/users";
            PageParms pageParms = new PageParms(rows, page)
                    .addEqualNotNull("type", type)
                    .addNotEqualNotNull("org", adapterOrgs.length()>0 ? adapterOrgs.substring(1) : "")
                    .addLikeNotNull("realName", searchParm);
            String resultStr = service.search(url, pageParms);
            return formatComboData(resultStr, "id", "realName");
        } catch (Exception e) {
            return systemError();
        }
    }



}
