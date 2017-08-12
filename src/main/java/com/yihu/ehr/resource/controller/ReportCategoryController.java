package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.resource.RsReportCategoryModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.health.controller.HealthBusinessController;
import com.yihu.ehr.std.controller.StdSourceManagerController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.yihu.ehr.util.HttpClientUtil.doGet;

/**
 * 资源报表分类 controller
 *
 * @author 张进军
 * @date 2017/8/8 13:53
 */
@Controller
@RequestMapping("/resource/reportCategory")
public class ReportCategoryController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/index")
    public String index(Model model) {
        model.addAttribute("contentPage", "/resource/reportCategory/list");
        return "pageView";
    }

    @RequestMapping(value = "detail")
    public String detail(Model model, Integer id) {
        Object detailModel = new RsReportCategoryModel();
        try {
            if (id != null) {
                String url = comUrl + "/resources/reportCategory/" + id;
                String result = doGet(url, username, password);
                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(StdSourceManagerController.class).error(e.getMessage());
        }
        model.addAttribute("detailModel", toJson(detailModel));
        model.addAttribute("contentPage", "resource/reportCategory/detail");
        return "simpleView";
    }

    /**
     * 根据条件，获取资源报表分类（树形结构）
     */
    @RequestMapping("/getTreeData")
    @ResponseBody
    public Object getTreeData(String codeName) {
        Map<String, Object> params = new HashMap<>();
        if (StringUtils.isEmpty(codeName)) codeName = "";
        params.put("codeName", codeName);

        try {
            return doGet(comUrl + ServiceApi.Resources.RsReportCategoryTree, params, username, password);
        } catch (Exception ex) {
            LogService.getLogger(HealthBusinessController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 获取资源报表分类下拉框数据
     */
    @RequestMapping("/getComboTreeData")
    @ResponseBody
    public Object getComboTreeData(String name) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("name", name);
            String envelopJsonStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportCategoryComboTree, params, username, password);
            List<Object> data = toModel(envelopJsonStr, Envelop.class).getDetailModelList();
            return toJson(data);
        } catch (Exception ex) {
            LogService.getLogger(HealthBusinessController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 新增、修改
     */
    @RequestMapping("/save")
    @ResponseBody
    public Object save(String dataJson, String mode) {
        String result = null;
        Map<String, Object> params = new HashMap<>();

        if (StringUtils.isEmpty(mode)) {
            return failed("操作类别不能为空！");
        }
        if (StringUtils.isEmpty(dataJson)) {
            return failed("空数据！");
        }

        try {
            RsReportCategoryModel model = objectMapper.readValue(dataJson, RsReportCategoryModel.class);
            if (StringUtils.isEmpty(model.getCode())) {
                return failed("编码不能为空！");
            }
            if (StringUtils.isEmpty(model.getName())) {
                return failed("名称不能为空！");
            }

            params.put("rsReportCategory", dataJson);

            if (StringUtils.equalsIgnoreCase(mode, "new")) {
                result = HttpClientUtil.doPost(comUrl + ServiceApi.Resources.RsReportCategoryAdd, params, username, password);
            } else {
                if (model.getId() == null) {
                    return failed("ID不能为空！");
                }
                result = HttpClientUtil.doPut(comUrl + ServiceApi.Resources.RsReportCategoryUpdate, params, username, password);
            }
            return result;
        } catch (Exception ex) {
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 删除
     */
    @RequestMapping("/delete")
    @ResponseBody
    public Object delete(String id) {
        try {
            if (id == null) {
                return failed("ID不能为空！");
            }
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            String url = ServiceApi.Resources.RsReportCategoryDelete + "/" + id;
            return HttpClientUtil.doDelete(comUrl + url, params, username, password);
        } catch (Exception ex) {
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

}
