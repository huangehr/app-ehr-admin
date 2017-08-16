package com.yihu.ehr.resource.controller;

//import com.yihu.ehr.agModel.resource.RsReportCategoryModel;
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
import org.springframework.web.bind.annotation.RequestParam;
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

//    @RequestMapping(value = "detail")
//    public String detail(Model model, Integer id) {
//        Object detailModel = new RsReportCategoryModel();
//        try {
//            if (id != null) {
//                String url = comUrl + ServiceApi.Resources.RsReportCategoryPrefix + id;
//                String result = doGet(url, username, password);
//                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            LogService.getLogger(StdSourceManagerController.class).error(e.getMessage());
//        }
//        model.addAttribute("detailModel", toJson(detailModel));
//        model.addAttribute("contentPage", "resource/reportCategory/detail");
//        return "simpleView";
//    }

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

//    /**
//     * 保存
//     */
//    @RequestMapping("/save")
//    @ResponseBody
//    public Object save(String data) {
//        Envelop envelop = new Envelop();
//        Map<String, Object> params = new HashMap<>();
//
//        try {
//            RsReportCategoryModel model = objectMapper.readValue(data, RsReportCategoryModel.class);
//            if (StringUtils.isEmpty(model.getCode())) {
//                return failed("编码不能为空！");
//            }
//            if (StringUtils.isEmpty(model.getName())) {
//                return failed("名称不能为空！");
//            }
//
//            if (model.getId() == null) {
//                // 新增
//                params.put("rsReportCategory", data);
//                return HttpClientUtil.doPost(comUrl + ServiceApi.Resources.RsReportCategorySave, params, username, password);
//            } else {
//                // 修改
//                String urlGet = comUrl + ServiceApi.Resources.RsReportCategoryPrefix + model.getId();
//                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
//                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);
//                if (!envelopGet.isSuccessFlg()) {
//                    envelop.setErrorMsg("获取资源报表分类信息失败！");
//                    return envelop;
//                }
//
//                RsReportCategoryModel updateModel = getEnvelopModel(envelopGet.getObj(), RsReportCategoryModel.class);
//                updateModel.setCode(model.getCode());
//                updateModel.setName(model.getName());
//                updateModel.setPid(model.getPid());
//                updateModel.setRemark(model.getRemark());
//
//                params.put("rsReportCategory", objectMapper.writeValueAsString(updateModel));
//                return HttpClientUtil.doPut(comUrl + ServiceApi.Resources.RsReportCategorySave, params, username, password);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
//            return failed(ErrorCode.SystemError.toString());
//        }
//    }

    /**
     * 删除
     */
    @RequestMapping("/delete")
    @ResponseBody
    public Object delete(String id) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            return HttpClientUtil.doDelete(comUrl + ServiceApi.Resources.RsReportCategoryDelete, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证资源报表分类编码是否唯一
     */
    @RequestMapping("/isUniqueCode")
    @ResponseBody
    public Object isUniqueCode(@RequestParam Integer id, @RequestParam String code) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("code", code);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportCategoryIsUniqueCode, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
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
            return HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportCategoryIsUniqueName, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

}
