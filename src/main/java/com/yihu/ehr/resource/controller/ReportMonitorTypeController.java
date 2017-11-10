package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.resource.RsReportCategoryModel;
import com.yihu.ehr.agModel.resource.RsReportMonitorTypeModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.yihu.ehr.util.HttpClientUtil.doGet;

/**
 * 资源报表监测分类 controller
 *
 * @author janseny
 * @date 2017/11/7 16:53
 */
@Controller
@RequestMapping("/resource/reportMonitorType")
public class ReportMonitorTypeController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/index")
    public String index(Model model) {
        model.addAttribute("contentPage", "/resource/reportMonitorType/list");
        return "pageView";
    }

    /**
     * 查找消息
     * @param searchNm
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("getRsReportMonitorTypePage")
    @ResponseBody
    public Object getRsReportMonitorTypePage(String searchNm, int page, int rows) {
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!org.springframework.util.StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("name?" + searchNm );
        }
        String filters = stringBuffer.toString();
        if (!org.springframework.util.StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportMonitorTypes, params, username, password);
            return resultStr;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }


    @RequestMapping(value = "detail")
    public String detail(Model model, Integer id) {
        Object detailModel = new RsReportMonitorTypeModel();
        try {
            if (id != null) {
                String url = comUrl + "/resources/rsReportMonitorType/" + id;
                String result = doGet(url, username, password);
                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportCategoryController.class).error(e.getMessage());
        }
        model.addAttribute("detailModel", toJson(detailModel));
        model.addAttribute("contentPage", "resource/reportMonitorType/detail");
        return "simpleView";
    }

    /**
     * 保存
     */
    @RequestMapping("/save")
    @ResponseBody
    public Object save(String data) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();

        try {
            RsReportMonitorTypeModel model = objectMapper.readValue(data, RsReportMonitorTypeModel.class);
            if (StringUtils.isEmpty(model.getName())) {
                return failed("名称不能为空！");
            }
            if (model.getId() == null) {
                // 新增
                params.put("rsReportMonitorType", data);
                return HttpClientUtil.doPost(comUrl + ServiceApi.Resources.RsReportMonitorTypeSave, params, username, password);
            }else{
                // 修改
                String urlGet = comUrl + "/resources/rsReportMonitorType/"+ model.getId();
                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);

                RsReportMonitorTypeModel updateModel = getEnvelopModel(envelopGet.getObj(), RsReportMonitorTypeModel.class);
                updateModel.setName(model.getName());
                updateModel.setNote(model.getNote());

                params.put("rsReportMonitorType", objectMapper.writeValueAsString(updateModel));
                return HttpClientUtil.doPut(comUrl + ServiceApi.Resources.RsReportMonitorTypeSave, params, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportMonitorTypeController.class).error(e.getMessage());
        }
        return failed(ErrorCode.SystemError.toString());
    }

    /**
     * 删除
     */
    @RequestMapping("/delete")
    @ResponseBody
    public Object delete(String id) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            return HttpClientUtil.doDelete(comUrl + ServiceApi.Resources.RsReportMonitorTypeDelete, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportMonitorTypeController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证资源报表分类名称是否唯一
     */
    @RequestMapping("/isUniqueName")
    @ResponseBody
    public Object isUniqueName(@RequestParam Integer id, @RequestParam String name) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("name", name);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportMonitorTypeIsUniqueName, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportMonitorTypeController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    @RequestMapping("/reportConfig")
    public String reportConfig(String id ,Model model) {
        model.addAttribute("id", id);
        model.addAttribute("contentPage", "resource/reportMonitorType/monitorTypeReport");
        return "simpleView";
    }

}
