package com.yihu.ehr.tjQuota.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.tj.TjQuotaModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.DateTimeUtils;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.springframework.beans.factory.annotation.Autowired;
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
    @Autowired
    private ObjectMapper objectMapper;


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
    public Object searchTjQuota(String name,Integer quotaType, int page, int rows){
        String url = "/tj/getTjQuotaList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(name)) {
            stringBuffer.append("name?" + name + " g1;code?" + name + " g1;");
        }
        if (!StringUtils.isEmpty(quotaType)) {
            stringBuffer.append("quotaType=" + quotaType + ";");
        } /*else {
            stringBuffer.append("quotaType=-1");
        }*/
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
                    updateTjQuota.setQuotaType(detailModel.getQuotaType());
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
     * 删除
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



    /**
     * 指标执行
     * @param tjQuotaId
     * @return
     */
    @RequestMapping("execuQuota")
    @ResponseBody
    public Object execuQuota(Long tjQuotaId) {
        String url = "/job/execuJob";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id", tjQuotaId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if (resultStr.equals("true")) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 指标结果页
     * @param model
     * @return
     */
    @RequestMapping("initialResult")
    public String initialResult(Model model,long tjQuotaId) {
        model.addAttribute("contentPage", "/report/zhibiao/resultIndex");
        model.addAttribute("id", tjQuotaId);
        return "pageView";
    }


    /**
     * 指标执行结果
     * @param tjQuotaId
     * @return
     */
    @RequestMapping("selectQuotaResult")
    @ResponseBody
    public Object selectQuotaResult(Long tjQuotaId, int page, int rows,
                                    String startTime,String endTime,String orgName,String province,String city,String district) {
        Envelop result = new Envelop();
        String resultStr = "";
        String url = "/tj/tjGetQuotaResult";
        try {
            Map<String, Object> filters = new HashMap<>();
            filters.put("startTime", startTime);
            filters.put("endTime", endTime);
            filters.put("orgName", orgName);
            filters.put("province", province);
            filters.put("city", city);
            filters.put("district", district);
            Map<String, Object> params = new HashMap<>();
            params.put("id", tjQuotaId);
            params.put("pageNo", page);
            params.put("pageSize", rows);
            params.put("filters", objectMapper.writeValueAsString(filters));
            ObjectMapper mapper = new ObjectMapper();
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            result = mapper.readValue(resultStr, Envelop.class);
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 指标日志查询
     * @param model
     * @return
     */
    @RequestMapping("initialQuotaLog")
    public String initialQuotaLog(Model model,String quotaCode) {
        model.addAttribute("contentPage", "/report/zhibiao/zhiBiaoLogIndex");
        model.addAttribute("quotaCode", quotaCode);
        return "pageView";
    }

    /**
     * 获取指标日志信息
     * @param
     * @return
     */
    @RequestMapping("queryQuotaLog")
    @ResponseBody
    public Object queryQuotaLog(String quotaCode, String startTime, String endTime,int page, int rows) throws Exception{
        String url = "/tj/getTjQuotaLogList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();

        params.put("startTime", startTime);
        params.put("endTime", endTime);
        params.put("quotaCode", quotaCode);
        params.put("fields", "");
        params.put("sorts", "");
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
     * 获取quotaCode查询是否配置维度
     * @param
     * @return
     */
    @RequestMapping("hasConfigDimension")
    @ResponseBody
    public boolean hasConfigDimension(String quotaCode) throws Exception {
        String url = "/tj/hasConfigDimension";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();

        params.put("quotaCode", quotaCode);
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
