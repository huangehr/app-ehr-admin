package com.yihu.ehr.organization.controller;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.model.org.MOrgTypeCategory;
import com.yihu.ehr.resource.controller.ReportCategoryController;
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

/**
 * 机构类型管理 controller
 *
 * @author 张进军
 * @date 2017/12/21 12:00
 */
@Controller
@RequestMapping("/org/typeCategory")
public class OrgTypeCategoryController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/index")
    public String index(Model model) {
        model.addAttribute("contentPage", "organization/typeCategory/list");
        return "pageView";
    }

    /**
     * 展示明细
     */
    @RequestMapping(value = "/detail")
    public String detail(Model model, Integer id) {
        Object detailModel = new MOrgTypeCategory();
        try {
            if (id != null) {
                String url = comUrl + ServiceApi.Org.TypeCategory.Prefix + id;
                String result = HttpClientUtil.doGet(url, username, password);
                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(OrgTypeCategoryController.class).error(e.getMessage());
        }
        model.addAttribute("detailModel", toJson(detailModel));
        model.addAttribute("contentPage", "organization/typeCategory/detail");
        return "simpleView";
    }

    /**
     * 根据条件，获取机构类型（树形结构）
     */
    @RequestMapping("/search")
    @ResponseBody
    public Object search(String searchContent) {
        Map<String, Object> params = new HashMap<>();
        if (StringUtils.isEmpty(searchContent)) searchContent = "";
        params.put("codeName", searchContent);

        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Org.TypeCategory.Search, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(OrgTypeCategoryController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 获取机构类型下拉框数据
     */
    @RequestMapping("/getComboTreeData")
    @ResponseBody
    public Object getComboTreeData() {
        try {
            String envelopJsonStr = HttpClientUtil.doGet(comUrl + ServiceApi.Org.TypeCategory.FindAll, username, password);
            List<Object> data = toModel(envelopJsonStr, Envelop.class).getDetailModelList();
            return toJson(data);
        } catch (Exception ex) {
            LogService.getLogger(ReportCategoryController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
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
            MOrgTypeCategory model = objectMapper.readValue(data, MOrgTypeCategory.class);
            if (StringUtils.isEmpty(model.getCode())) {
                return failed("机构类型编码不能为空！");
            }

            if (model.getId() == null) {
                // 新增
                params.put("entityJson", data);
                return HttpClientUtil.doPost(comUrl + ServiceApi.Org.TypeCategory.Save, params, username, password);
            } else {
                // 修改
                String urlGet = comUrl + ServiceApi.Org.TypeCategory.Prefix + model.getId();
                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);

                MOrgTypeCategory updateModel = getEnvelopModel(envelopGet.getObj(), MOrgTypeCategory.class);
                updateModel.setName(model.getName());
                updateModel.setRemark(model.getRemark());

                params.put("entityJson", objectMapper.writeValueAsString(updateModel));
                return HttpClientUtil.doPut(comUrl + ServiceApi.Org.TypeCategory.Save, params, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(OrgTypeCategoryController.class).error(e.getMessage());
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
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            return HttpClientUtil.doDelete(comUrl + ServiceApi.Org.TypeCategory.Delete, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(OrgTypeCategoryController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证机构类型编码是否唯一
     */
    @RequestMapping("/isUniqueCode")
    @ResponseBody
    public Object isUniqueCode(Integer id, String code) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("code", code);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Org.TypeCategory.IsUniqueCode, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(OrgTypeCategoryController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证机构类型名是否唯一
     */
    @RequestMapping("/isUniqueName")
    @ResponseBody
    public Object isUniqueName(Integer id, String name) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("name", name);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Org.TypeCategory.IsUniqueName, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(OrgTypeCategoryController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

}
