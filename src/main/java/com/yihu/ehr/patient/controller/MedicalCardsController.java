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
                String url = "/medicalCards/"+id+"/get";
                Map<String, Object> par = new HashMap<>();
                par.put("id", id);
                envelopStr = HttpClientUtil.doGet(comUrl + url,par, username, password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
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
    public Object searchMedicalCardss(String searchNm,int status ,int page, int rows) {
        String url = "/getMedicalCards";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("search", searchNm);
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("status=" + status );
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
    @RequestMapping(value = "updateMedicalCards", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateMedicalCards(String medicalCardsModelJsonData, HttpServletRequest request) throws IOException{

        String url = "/medicalCards/save";
        String resultStr = "";
        System.out.println();
        Envelop result = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        String[] strings = URLDecoder.decode(medicalCardsModelJsonData, "UTF-8").split(";");
        MedicalCardsModel detailModel = toModel(strings[0], MedicalCardsModel.class);
        RestTemplates templates = new RestTemplates();

        try {
            if (!StringUtils.isEmpty(detailModel.getId())) {
                Long id = detailModel.getId();
                Map<String, Object> par = new HashMap<>();
                par.put("id", id);
                resultStr = templates.doGet(comUrl +  "/medicalCards/"+id+"/get",par);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    MedicalCardsModel updateMedicalCards = getEnvelopModel(envelop.getObj(), MedicalCardsModel.class);
                    updateMedicalCards.setUserId(detailModel.getUserId());
                    updateMedicalCards.setCardType(detailModel.getCardType());
                    updateMedicalCards.setCardNo(detailModel.getCardNo());
                    updateMedicalCards.setReleaseOrg(detailModel.getReleaseOrg());
                    updateMedicalCards.setReleaseDate(detailModel.getReleaseDate());
                    updateMedicalCards.setValidityDateBegin(detailModel.getValidityDateBegin());
                    updateMedicalCards.setValidityDateEnd(detailModel.getValidityDateEnd());
                    updateMedicalCards.setDescription(detailModel.getDescription());
                    updateMedicalCards.setCreater(detailModel.getCreater());
                    updateMedicalCards.setStatus(detailModel.getStatus());
                    params.add("medicalCards_json_data", toJson(updateMedicalCards));

                    resultStr = templates.doPut(comUrl + url, params);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else {
                params.add("medicalCards_json_data", toJson(detailModel));
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

    /**
     * 根据id获取就诊卡
     * @param model
     * @param medicalCardsId
     * @param mode
     * @return
     */
//    @RequestMapping("getMedicalCards")
//    public Object getMedicalCards(Model model, Long medicalCardsId, String mode) {
//        String url = ""/medicalCards/"+medicalCardsId+"/get";
//        String resultStr = "";
//        Envelop envelop = new Envelop();
//        Map<String, Object> params = new HashMap<>();
//        ObjectMapper mapper = new ObjectMapper();
//
//        params.put("medicalCardsId", medicalCardsId);
//        try {
//            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
//
//            Envelop ep = getEnvelop(resultStr);
//            MedicalCardsModel detailModel = toModel(toJson(ep.getObj()),MedicalCardsModel.class);
//            model.addAttribute("allData", resultStr);
//            model.addAttribute("mode", mode);
//            model.addAttribute("contentPage", "patient/cards/medicalCardsInfoDialog");
//            return "simpleView";
//        } catch (Exception e) {
//            envelop.setSuccessFlg(false);
//            envelop.setErrorMsg(ErrorCode.SystemError.toString());
//            return envelop;
//        }
//    }

}
