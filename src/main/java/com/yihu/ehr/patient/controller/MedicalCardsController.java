package com.yihu.ehr.patient.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.agModel.patient.MedicalCardsModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.patient.model.RsMedicalCardModel;
import com.yihu.ehr.patient.service.MedicalCardsService;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.excel.read.RsMedicalCardModelReader;
import com.yihu.ehr.util.excel.read.RsMedicalCardModelWriter;
import com.yihu.ehr.util.log.LogService;
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
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by zhoujie on 2017/4/17
 */
@Controller
@RequestMapping("/medicalCards")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class MedicalCardsController  extends ExtendController<MedicalCardsService> {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    static final String parentFile = "medicalCards";

    /**
     * 列表页
     * @param model
     * @return
     */
    @RequestMapping("initialPageView")
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
        UserDetailModel userDetailModel = getCurrentUserRedis(request);
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


    @RequestMapping(value = "import")
    @ResponseBody
    public void importMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        try {
            UserDetailModel user = getCurrentUserRedis(request);
            writerResponse(response, 1+"", "l_upd_progress");//进度条
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new RsMedicalCardModelReader();
            excelReader.read(file.getInputStream());
            List<RsMedicalCardModel> errorLs = excelReader.getErrorLs();
            List<RsMedicalCardModel> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 25 + "", "l_upd_progress");

            Map rs = new HashMap<>();
            if(errorLs.size()>0){
                String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".xls");
                new RsMedicalCardModelWriter().write(new File(TemPath.getFullPath(eFile, parentFile)), errorLs);
                rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
            }

            if(correctLs.size()>0 && correctLs.size()<=50 && errorLs.size()==0){
                String cardNoStr = "";
                for(RsMedicalCardModel rsMedicalCardModel : correctLs){
                    cardNoStr = cardNoStr + rsMedicalCardModel.getCardNo() + ",";
                }
                Map<String, Object> par = new HashMap<>();
                par.put("cardNoStr", cardNoStr.substring(0,cardNoStr.length()-1));
                String resultStr = HttpClientUtil.doPut(comUrl + "/medicalCards/getMutiCard", par, username, password);
                Envelop re = getEnvelop(resultStr);
                List<MedicalCardsModel> muCards = new ArrayList<>();
                getEnvelopList(re.getDetailModelList(),muCards,MedicalCardsModel.class);
                for(RsMedicalCardModel rsMedicalCardModel :correctLs){
                    for(MedicalCardsModel medicalCardsModel :muCards){
                        if(medicalCardsModel.getCardNo().equals(rsMedicalCardModel.getCardNo())){
                            rsMedicalCardModel.addErrorMsg("cardNo","此卡号已添加");
                            errorLs.add(rsMedicalCardModel);
                            break;
                        }
                    }

                }
                if(errorLs.size()>0){
                    String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".xls");
                    new RsMedicalCardModelWriter().write(new File(TemPath.getFullPath(eFile, parentFile)), errorLs);
                    rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
                }else{
                    saveMedicalCard(toJson(correctLs),String.valueOf(user.getId()) );
                }
            }else if(correctLs.size()>50){
                rs.put("maxMsg","一次最多不能超过50条");
                writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");
            }

            if(rs.size()>0)
                writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");
            else
                writerResponse(response, 100 + "", "l_upd_progress");
        } catch (Exception e) {
            e.printStackTrace();
            writerResponse(response, "-1", "l_upd_progress");
        }
    }

    private List saveMedicalCard(String medicalCars,String operator) throws Exception {
        Map map = new HashMap<>();
        map.put("medicalCars", medicalCars);
        map.put("operator", operator);
        EnvelopExt<RsMedicalCardModel> envelop = getEnvelopExt(service.doPost(service.comUrl + "/medicalCards/batch", map), RsMedicalCardModel.class);
        if(envelop.isSuccessFlg())
            return envelop.getDetailModelList();
        throw new Exception("保存失败！");
    }

    @RequestMapping("/downLoadErrInfo")
    public void downLoadErrInfo(String f, String datePath,  HttpServletResponse response) throws IOException {

        try{
            f = datePath + TemPath.separator + f;
            downLoadFile(TemPath.getFullPath(f, parentFile), response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }



}
