package com.yihu.ehr.tjQuota.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.tj.TjQuotaModel;
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
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2017/6/13.
 */
@Controller
@RequestMapping("/tjQuota")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class TjQuotaController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;


    /*
    * 获取弹窗页面：指标增、改
    * */
    @RequestMapping(value = "getPage")
    public String getPage(Model model,String id){
        if (id == "") {
            model.addAttribute("id","-1");
        } else {
            model.addAttribute("id",id);
        }
        return  "/report/zhibiao/zhiBiaoInfoDialog";
    }


    /**
     * 指标
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/report/zhibiao/quota");
        return "pageView";
    }

    @RequestMapping("/getTjQuota")
    @ResponseBody
    public Object searchTjQuota(String name, int page, int rows){
        String url = "/tj/getTjQuotaList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(name)) {
            stringBuffer.append("name?" + name + " g1;code?" + name + " g1;");
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
        } catch (Exception ex) {
            LogService.getLogger(TjQuotaController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 新增修改
     * @param tjQuotaModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updateTjDataSource", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateTjQuota(String tjQuotaModelJsonData, HttpServletRequest request) throws IOException {

        String url = "/tj/addTjQuota/";
        String resultStr = "";
        Envelop result = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        String[] strings = URLDecoder.decode(tjQuotaModelJsonData, "UTF-8").split(";");
        TjQuotaModel detailModel = toModel(strings[0], TjQuotaModel.class);
        RestTemplates templates = new RestTemplates();

        try {
            if (!StringUtils.isEmpty(detailModel.getId())) {
                Long tjQuotaId = detailModel.getId();
                resultStr = templates.doGet(comUrl + "/tj/getTjQuotaById/" + tjQuotaId);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    TjQuotaModel updateTjQuota = getEnvelopModel(envelop.getObj(), TjQuotaModel.class);

                    updateTjQuota.setCode(detailModel.getCode());
                    updateTjQuota.setName(detailModel.getName());
                    updateTjQuota.setCron(detailModel.getCron());
                    updateTjQuota.setExecType(detailModel.getExecType());
                    updateTjQuota.setExecTime(detailModel.getExecTime());
                    updateTjQuota.setJobClazz(detailModel.getJobClazz());
                    updateTjQuota.setStatus(detailModel.getStatus());
                    updateTjQuota.setDataLevel(detailModel.getDataLevel());
                    updateTjQuota.setRemark(detailModel.getRemark());
                    updateTjQuota.setUpdateUser(userDetailModel.getId());
                    updateTjQuota.setUpdateUserName(userDetailModel.getRealName());
                    updateTjQuota.setTjQuotaDataSaveModel(detailModel.getTjQuotaDataSaveModel());
                    updateTjQuota.setTjQuotaDataSourceModel(detailModel.getTjQuotaDataSourceModel());
                    params.add("model", toJson(updateTjQuota));

                    resultStr = templates.doPost(comUrl + url, params);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else {
                detailModel.setCreateUser(userDetailModel.getId());
                detailModel.setCreateUserName(userDetailModel.getRealName());
                params.add("model", toJson(detailModel));
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
     * @param tjQuotaId
     * @return
     */
    @RequestMapping("deleteTjDataSave")
    @ResponseBody
    public Object deleteTjQuota(Long tjQuotaId) {
        String url = "/tj/deleteTjQuota";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("id", tjQuotaId);
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
     * @param id
     * @return
     */
    @RequestMapping("getTjQuotaById")
    @ResponseBody
    public Object getTjQuotaById(Model model, Long id ) {
        String url ="/tj/getTjQuotaById/" +id;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        TjQuotaModel detailModel = null;
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            detailModel = toModel(toJson(ep.getObj()),TjQuotaModel.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detailModel;
    }

    /**
     * 校验name是否唯一,true已存在
     * @param name
     * @return
     */
    @RequestMapping("hasExistsName")
    @ResponseBody
    public boolean hasExistsName(String name) {
        String url = "/tj/tjQuotaExistsName/" + name ;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("name", name);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if (resultStr.equals("true")) {
                return  true;
            }
        } catch (Exception e) {
            e.getMessage();
        }
        return  false;
    }

    /**
     * 校验code是否唯一
     * @param code
     * @return
     */
    @RequestMapping("hasExistsCode")
    @ResponseBody
    public boolean hasExistsCode(String code) {
        String url = "/tj/tjQuotaExistsCode/" + code ;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("code", code);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if (resultStr.equals("true")) {
                return  true;
            }
        } catch (Exception e) {
            e.getMessage();
        }
        return  false;
    }
}
