package com.yihu.ehr.tjQuota.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.tj.TjDimensionMainModel;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by llh on 2017/5/9.
 */
@Controller
@RequestMapping("/tjDimensionMain")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class TjDimensionMainController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 主维度
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/report/zhibiao/dimensionMain");
        return "pageView";
    }


    
    //查询统计主维度
    @RequestMapping("/getTjDimensionMain")
    @ResponseBody
    public Object searchTjDimensionMain(String name, int page, int rows){
        String url = "/tj/getTjDimensionMainList";
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
            LogService.getLogger(TjDimensionMainController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }



    /**
     * 新增修改
     * @param tjDimensionMainModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updateTjDimensionMain", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateTjDimensionMain(String tjDimensionMainModelJsonData, HttpServletRequest request) throws IOException {

        String url = "/tjDimensionMain/";
        String resultStr = "";
        System.out.println();
        Envelop result = new Envelop();
        UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        String[] strings = URLDecoder.decode(tjDimensionMainModelJsonData, "UTF-8").split(";");
        TjDimensionMainModel detailModel = toModel(strings[0], TjDimensionMainModel.class);
        RestTemplates templates = new RestTemplates();

        try {
            if (!StringUtils.isEmpty(detailModel.getId())) {
                Long tjDimensionMainId = detailModel.getId();
                resultStr = templates.doGet(comUrl + "/tjDimensionMain/" + tjDimensionMainId);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    TjDimensionMainModel updateTjDimensionMain = getEnvelopModel(envelop.getObj(), TjDimensionMainModel.class);

                    updateTjDimensionMain.setCode(detailModel.getCode());
                    updateTjDimensionMain.setName(detailModel.getName());
                    updateTjDimensionMain.setType(detailModel.getType());
                    updateTjDimensionMain.setStatus(detailModel.getStatus());
                    updateTjDimensionMain.setRemark(detailModel.getRemark());
                    updateTjDimensionMain.setCreateTime(new Date());
                    updateTjDimensionMain.setCreateUser(userDetailModel.getId());
                    updateTjDimensionMain.setCreateUserName(userDetailModel.getRealName());
                    params.add("model", toJson(updateTjDimensionMain));

                    resultStr = templates.doPost(comUrl + url, params);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else {
                detailModel.setUpdateTime(new Date());
                detailModel.setUpdateUser(userDetailModel.getId());
                detailModel.setUpdateUserName(userDetailModel.getRealName());
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
     * @param tjDimensionMainId
     * @return
     */
    @RequestMapping("deleteTjDimensionMain")
    @ResponseBody
    public Object deleteTjDimensionMain(Long tjDimensionMainId) {
        String url = "/tjDimensionMain/" + tjDimensionMainId;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        params.put("id", tjDimensionMainId);
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
