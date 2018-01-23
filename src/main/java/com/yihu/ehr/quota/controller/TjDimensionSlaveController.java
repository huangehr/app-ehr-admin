package com.yihu.ehr.quota.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.tj.TjDimensionSlaveModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.agModel.user.UsersModel;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by llh on 2017/5/9.
 */
@Controller
@RequestMapping("/tjDimensionSlave")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class TjDimensionSlaveController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 从维度
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/report/zhibiao/dimensionSlave");
        return "pageView";
    }


    
    //查询
    @RequestMapping("/getTjDimensionSlave")
    @ResponseBody
    public Object searchTjDimensionSlave(String name, int page, int rows){
        String url = "/tj/getTjDimensionSlaveList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(name)) {
            stringBuffer.append("name?" + name );
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
            LogService.getLogger(TjDimensionSlaveController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }



    /**
     * 新增修改
     * @param tjDimensionSlaveModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updateTjDimensionSlave", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateTjDimensionSlave(String tjDimensionSlaveModelJsonData, HttpServletRequest request) throws IOException {

        String url = "/tj/tjDimensionSlave";
        String resultStr = "";
        System.out.println();
        Envelop result = new Envelop();
        UsersModel userDetailModel = getCurrentUserRedis(request);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        String[] strings = URLDecoder.decode(tjDimensionSlaveModelJsonData, "UTF-8").split(";");
        TjDimensionSlaveModel detailModel = toModel(strings[0], TjDimensionSlaveModel.class);
        RestTemplates templates = new RestTemplates();

        try {
            if (!StringUtils.isEmpty(detailModel.getId())) {
                Long id = detailModel.getId();
                resultStr = templates.doGet(comUrl + "/tj/tjDimensionSlaveId/" + id);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    TjDimensionSlaveModel updateTjDimensionSlave = getEnvelopModel(envelop.getObj(), TjDimensionSlaveModel.class);

                    updateTjDimensionSlave.setCode(detailModel.getCode());
                    updateTjDimensionSlave.setName(detailModel.getName());
                    updateTjDimensionSlave.setType(detailModel.getType());
                    updateTjDimensionSlave.setStatus(detailModel.getStatus());
                    updateTjDimensionSlave.setRemark(detailModel.getRemark());
                    updateTjDimensionSlave.setUpdateUser(userDetailModel.getId());
                    updateTjDimensionSlave.setUpdateUserName(userDetailModel.getRealName());
                    params.add("model", toJson(updateTjDimensionSlave));

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
     * @param tjDimensionSlaveId
     * @return
     */
    @RequestMapping("deleteTjDimensionSlave")
    @ResponseBody
    public Object deleteTjDimensionSlave(Long tjDimensionSlaveId) {
        String url = "/tj/tjDimensionSlave";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("id", tjDimensionSlaveId);
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
    @RequestMapping("getTjDimensionSlaveById")
    @ResponseBody
    public TjDimensionSlaveModel getTjDimensionSlaveById(Model model, Long id ) {
        String url ="/tj/tjDimensionSlaveId/" +id;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            TjDimensionSlaveModel detailModel = toModel(toJson(ep.getObj()),TjDimensionSlaveModel.class);
            return detailModel;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 校验名称是否唯一
     * @param name
     * @return
     */
    @RequestMapping("isNameExists")
    @ResponseBody
    public boolean isNameExists(String name) {
        String url = "/tj/tjDimensionSlaveName" ;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("name", name);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if (resultStr.equals("true")) {
                return  true;
            } else {

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
    @RequestMapping("isCodeExists")
    @ResponseBody
    public boolean isCodeExists(String code) {
        String url = "/tj/tjDimensionSlaveCode" ;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("code", code);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if (resultStr.equals("true")) {
                return  true;
            } else {

            }
        } catch (Exception e) {
            e.getMessage();
        }
        return  false;
    }

    @RequestMapping("/getTjDimensionSlaveInfo")
    @ResponseBody
    public Object getTjDimensionSlaveInfo(String quotaCode, String name, int page, int rows){
        String url = "/tj/getTjDimensionSlaveInfoList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer slaveFilter = new StringBuffer("status=1");
        if (!StringUtils.isEmpty(quotaCode)) {
            params.put("filter", "quotaCode=" + quotaCode);
        }
        if (!StringUtils.isEmpty(name)) {
            slaveFilter.append("name?" + name + " g1;code?" + name + " g1;");
        }
        String filters = slaveFilter.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(TjDimensionMainController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }
}
