package com.yihu.ehr.patient.controller;

import com.yihu.ehr.agModel.patient.UserCardsModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.datetime.DateTimeUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.web.RestTemplates;
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
import java.util.HashMap;
import java.util.Map;

/**
 * Created by zhoujie on 2017/4/20
 */
@Controller
@RequestMapping("/userCards")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class UserCardsController extends BaseUIController {

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
        model.addAttribute("contentPage", "/patient/userCards/userCards");
        return "pageView";
    }

    @RequestMapping("/infoInitial")
    public String OrgDeptMembersInfoInitial(Model model,String mode,String id){
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","patient/userCards/userCardsInfoDialog");
        Envelop envelop = new Envelop();
        String envelopStr = "";
        try{
            if (!StringUtils.isEmpty(id)) {
                String url = "/userCards/get";
                Map<String, Object> par = new HashMap<>();
                par.put("id", id);
                envelopStr = HttpClientUtil.doGet(comUrl + url,par, username, password);
            }
            model.addAttribute("allData",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(UserCardsController.class).error(ex.getMessage());
        }
        return "simpleView";
    }

    /**
     * 查找用户关联卡
     * @param
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchUserCards")
    @ResponseBody
    public Object searchUserCardss(String cardNo,String name ,String auditStatus ,int page, int rows) {
        String url = "/getUserCards";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(auditStatus)) {
            stringBuffer.append("auditStatus=" + auditStatus + ";");
        }
        if (!StringUtils.isEmpty(cardNo)) {
            stringBuffer.append("cardNo?" + cardNo );
        }
        if (!StringUtils.isEmpty(name)) {
            stringBuffer.append("ownerName?" + name );
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
     * @param userCardsModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updateUserCards")
    @ResponseBody
    public Object updateUserCards(String userCardsModelJsonData, HttpServletRequest request) throws IOException{
        String resultStr = "";
        Envelop result = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        UserCardsModel detailModel = objectMapper.readValue(userCardsModelJsonData, UserCardsModel.class);
        RestTemplates templates = new RestTemplates();
        try {
            String url = "/patientCards/apply";
            if (detailModel.getId()!=0) {
                Long id = detailModel.getId();
                Map<String, Object> par = new HashMap<>();
                par.put("id", id);
                resultStr = HttpClientUtil.doGet(comUrl + url,par, username, password);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    UserCardsModel updateUserCards = getEnvelopModel(envelop.getObj(), UserCardsModel.class);
                    updateUserCards.setCardType(detailModel.getCardType());
                    updateUserCards.setCardNo(detailModel.getCardNo());
                    updateUserCards.setReleaseOrg(detailModel.getReleaseOrg());

                    if(!StringUtils.isEmpty(detailModel.getReleaseDate())){
                        updateUserCards.setReleaseDate(detailModel.getReleaseDate() + " 00:00:00");
                    }
                    if(!StringUtils.isEmpty(detailModel.getValidityDateBegin())){
                        updateUserCards.setValidityDateBegin(detailModel.getValidityDateBegin() + " 00:00:00");
                    }
                    if(!StringUtils.isEmpty(detailModel.getValidityDateEnd())){
                        updateUserCards.setValidityDateEnd(detailModel.getValidityDateEnd() + " 00:00:00");
                    }
                    updateUserCards.setDescription(detailModel.getDescription());
                    updateUserCards.setCreater(detailModel.getCreater());
                    updateUserCards.setStatus(detailModel.getStatus());
                    params.add("data", toJson(updateUserCards));
                    params.add("operator", toJson(userDetailModel.getId()));
                    resultStr = templates.doPost(comUrl + url, params, username, password);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else {
                if(!StringUtils.isEmpty(detailModel.getReleaseDate())){
                    detailModel.setReleaseDate(detailModel.getReleaseDate() + " 00:00:00");
                }
                if(!StringUtils.isEmpty(detailModel.getValidityDateBegin())){
                    detailModel.setValidityDateBegin(detailModel.getValidityDateBegin() + " 00:00:00");
                }
                if(!StringUtils.isEmpty(detailModel.getValidityDateEnd())){
                    detailModel.setValidityDateEnd(detailModel.getValidityDateEnd() + " 00:00:00");
                }
                params.add("data", toJson(detailModel));
                params.add("operator", toJson(userDetailModel.getId()));
                resultStr = templates.doPost(comUrl + url, params, username, password);
            }
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
        return resultStr;
    }


    @RequestMapping(value = "getUserDetail")
    public String updateUserCards(Model model,String id,String auditStatus) throws Exception {
        String resultStr = "";
        String url = "/patientCards/apply";
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        Envelop envelop = getEnvelop(resultStr);
        UserCardsModel userCardsModel = null;
        if (envelop.isSuccessFlg()) {
            userCardsModel = getEnvelopModel(envelop.getObj(), UserCardsModel.class);
        }
        userCardsModel.setCreateDate(userCardsModel.getCreateDate() == null ? "" : userCardsModel.getCreateDate().substring(0, 10));
        userCardsModel.setReleaseDate(userCardsModel.getReleaseDate() == null ? "" : userCardsModel.getReleaseDate().substring(0, 10));
        userCardsModel.setValidityDateBegin(userCardsModel.getValidityDateBegin() == null ? "" : userCardsModel.getValidityDateBegin().substring(0, 10));
        userCardsModel.setValidityDateEnd(userCardsModel.getValidityDateEnd() == null ? "" :userCardsModel.getValidityDateEnd().substring(0, 10) );
        userCardsModel.setAuditDate(userCardsModel.getAuditDate() == null ? "" : userCardsModel.getAuditDate().substring(0, 10));

        model.addAttribute("userCards",userCardsModel);
        model.addAttribute("contentPage", "/patient/userCards/userCardsDetail");
        return "simpleView";
    }


}
