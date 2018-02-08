package com.yihu.ehr.quota.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.tj.TjDataSourceModel;
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
@RequestMapping("/tjDataSource")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class TjDataSourceController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 数据资源
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/report/zhibiao/dataSource");
        return "pageView";
    }


    
    //查询
    @RequestMapping("/getTjDataSource")
    @ResponseBody
    public Object searchTjDataSource(String name,String searchParm, int page, int rows){
        String url = "/tj/getTjDataSourceList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(name)) {
            stringBuffer.append("name?" + name );
        }
        if (!StringUtils.isEmpty(searchParm)) {
            stringBuffer.append("name?" + searchParm );
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
            LogService.getLogger(TjDataSourceController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }



    /**
     * 新增修改
     * @param tjDataSourceModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updateTjDataSource", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateTjDataSource(String tjDataSourceModelJsonData, HttpServletRequest request) throws IOException {

        String url = "/tj/addTjDataSource";
        String resultStr = "";
        System.out.println();
        Envelop result = new Envelop();
        UsersModel userDetailModel = getCurrentUserRedis(request);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        String[] strings = URLDecoder.decode(tjDataSourceModelJsonData, "UTF-8").split(";");
        TjDataSourceModel detailModel = toModel(strings[0], TjDataSourceModel.class);
        RestTemplates templates = new RestTemplates();

        try {
            if (!StringUtils.isEmpty(detailModel.getId())) {
                Long tjDataSourceId = detailModel.getId();
                resultStr = templates.doGet(comUrl + "/tj/getTjDataSourceById/" + tjDataSourceId);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    TjDataSourceModel updateTjDataSource = getEnvelopModel(envelop.getObj(), TjDataSourceModel.class);

                    updateTjDataSource.setCode(detailModel.getCode());
                    updateTjDataSource.setName(detailModel.getName());
                    updateTjDataSource.setType(detailModel.getType());
                    updateTjDataSource.setStatus(detailModel.getStatus());
                    updateTjDataSource.setRemark(detailModel.getRemark());
                    updateTjDataSource.setUpdateUser(userDetailModel.getId());
                    updateTjDataSource.setUpdateUserName(userDetailModel.getRealName());
                    params.add("model", toJson(updateTjDataSource));

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
     * @param tjDataSourceId
     * @return
     */
    @RequestMapping("deleteTjDataSource")
    @ResponseBody
    public Object deleteTjDataSource(Long tjDataSourceId) {
        String url = "/tj/deletetTjDataSource" ;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("id", tjDataSourceId);
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
    @RequestMapping("getTjDataSourceById")
    @ResponseBody
    public TjDataSourceModel getTjQuotaById(Model model, Long id ) {
        String url ="/tj/getTjDataSourceById/" +id;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        TjDataSourceModel detailModel = null;
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            detailModel = toModel(toJson(ep.getObj()),TjDataSourceModel.class);
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
        String url = "/tj/tjDataSourceExistsName/" + name ;
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
        String url = "/tj/tjDataSourceExistsCode/" + code ;
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
