package com.yihu.ehr.patient.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.patient.MedicalCardsModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
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
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by zhoujie on 2017/4/17
 */
@Controller
@RequestMapping("/medicalCards")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class MedicalCardsController extends BaseUIController {
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
        model.addAttribute("contentPage", "/patient/cards/medicalCards");
        return "pageView";
    }

    @RequestMapping("/infoInitial")
    public String OrgDeptMembersInfoInitial(Model model,String mode,String id){
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","patient/cards/medicalCardsInfoDialog");
        Envelop envelop = new Envelop();
        String envelopStr = "";
        try{
            if (!StringUtils.isEmpty(id)) {
                String url = "/medicalCards/get";
                Map<String, Object> par = new HashMap<>();
                par.put("id", id);
                envelopStr = HttpClientUtil.doGet(comUrl + url,par, username, password);
            }
            model.addAttribute("allData",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(MedicalCardsController.class).error(ex.getMessage());
        }
        return "simpleView";
    }

    /**
     * 查找就诊卡
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("searchMedicalCardss")
    @ResponseBody
    public Object searchMedicalCardss(String searchNm,String status ,int page, int rows) {
        String url = "/getMedicalCards";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("search", searchNm);
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(status)) {
            stringBuffer.append("status=" + status + ";");
        }
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("cardNo?" + searchNm );
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
     * @param medicalCardsModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updateMedicalCards")
    @ResponseBody
    public Object updateMedicalCards(String medicalCardsModelJsonData,String oldCardNo, HttpServletRequest request) throws IOException{


        String resultStr = "";
        Envelop result = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        MedicalCardsModel detailModel = objectMapper.readValue(medicalCardsModelJsonData, MedicalCardsModel.class);
        RestTemplates templates = new RestTemplates();
        try {
            if(!StringUtils.isEmpty(detailModel.getCardNo()) && !oldCardNo.equals(detailModel.getCardNo())){
                Map<String, Object> par = new HashMap<>();
                par.put("cardNo", detailModel.getCardNo());
                resultStr = HttpClientUtil.doPut(comUrl + "/medicalCards/checkCardNo", par, username, password);
                Envelop re = getEnvelop(resultStr);
                if(re.isSuccessFlg()){
                    result.setSuccessFlg(false);
                    result.setErrorMsg("卡号已存在");
                    return result;
                }
            }

            String url = "/medicalCards/save";
            if (detailModel.getId()!=0) {
                Long id = detailModel.getId();
                Map<String, Object> par = new HashMap<>();
                par.put("id", id);
                resultStr = HttpClientUtil.doGet(comUrl + "/medicalCards/get",par, username, password);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    MedicalCardsModel updateMedicalCards = getEnvelopModel(envelop.getObj(), MedicalCardsModel.class);
                    updateMedicalCards.setCardType(detailModel.getCardType());
                    updateMedicalCards.setCardNo(detailModel.getCardNo());
                    updateMedicalCards.setReleaseOrg(detailModel.getReleaseOrg());

                    if(!StringUtils.isEmpty(detailModel.getReleaseDate())){
                        updateMedicalCards.setReleaseDate(detailModel.getReleaseDate() + " 00:00:00");
                    }
                    if(!StringUtils.isEmpty(detailModel.getValidityDateBegin())){
                        updateMedicalCards.setValidityDateBegin(detailModel.getValidityDateBegin() + " 00:00:00");
                    }
                    if(!StringUtils.isEmpty(detailModel.getValidityDateEnd())){
                        updateMedicalCards.setValidityDateEnd(detailModel.getValidityDateEnd() + " 00:00:00");
                    }
                    updateMedicalCards.setDescription(detailModel.getDescription());
                    updateMedicalCards.setCreater(detailModel.getCreater());
                    updateMedicalCards.setStatus(detailModel.getStatus());
                    params.add("data", toJson(updateMedicalCards));
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

    /**
     * 删除就诊卡
     * @param id
     * @return
     */
    @RequestMapping("deleteMedicalCards")
    @ResponseBody
    public Object deleteMedicalCards(Long id) {
        String url = "/medicalCards/del";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("id", id);
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

}
