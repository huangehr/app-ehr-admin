package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.resource.RsCategoryTypeTreeModel;
import com.yihu.ehr.agModel.resource.RsReportModel;
import com.yihu.ehr.agModel.resource.RsResourcesModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.health.controller.HealthBusinessController;
import com.yihu.ehr.std.controller.StdSourceManagerController;
import com.yihu.ehr.util.FileUploadUtil;
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
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.yihu.ehr.util.HttpClientUtil.doGet;

/**
 * 资源报表管理 controller
 *
 * @author 张进军
 * @created 2017.8.15 19:18
 */
@Controller("RsReportController")
@RequestMapping("/resource/report")
public class ReportController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/index")
    public String index(Model model) {
        model.addAttribute("contentPage", "/resource/report/list");
        return "pageView";
    }

    /**
     * 展示明细
     */
    @RequestMapping(value = "detail")
    public String detail(Model model, Integer id) {
        Object detailModel = new RsReportModel();
        try {
            if (id != null) {
                String url = comUrl + ServiceApi.Resources.RsReportPrefix + id;
                String result = doGet(url, username, password);
                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(StdSourceManagerController.class).error(e.getMessage());
        }
        model.addAttribute("detailModel", toJson(detailModel));
        model.addAttribute("contentPage", "resource/report/detail");
        return "simpleView";
    }

    /**
     * 展示资源配置
     */
    @RequestMapping(value = "setting")
    public String setting(Model model, Integer id) {
        Object detailModel = new RsReportModel();
        model.addAttribute("id", id);
        model.addAttribute("contentPage", "resource/report/setting");
        return "simpleView";
    }

    /**
     * 预览报表
     */
    @RequestMapping(value = "preview")
    public String preview(Model model, String code) {
        model.addAttribute("reportCode", code);
        model.addAttribute("contentPage", "resource/report/preview");
        return "simpleView";
    }

    /**
     * 展示报表模版外壳
     */
    @RequestMapping(value = "viewTemplateShell")
    public String viewTemplateShell(Model model, String reportCode) {
        model.addAttribute("reportCode", reportCode);
        model.addAttribute("contentPage", "resource/report/reportTemplateShell");
        return "simpleView";
    }

    /**
     * 分页查询
     */
    @RequestMapping("/search")
    @ResponseBody
    public Object search(String codeName, String reportCategoryId, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        StringBuffer filters = new StringBuffer();

        if (!StringUtils.isEmpty(codeName)) {
            filters.append("code?" + codeName + " g1;name?" + codeName + " g1;");
        }
        if (!StringUtils.isEmpty(reportCategoryId)) {
            filters.append("reportCategoryId=" + reportCategoryId + ";");
        } else {
            return success(null);
        }

        params.put("filters", filters.toString());
        params.put("page", page);
        params.put("size", rows);

        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReports, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 根据条件，获取视图树形数据（视图类别树下展示视图）
     */
    @RequestMapping("/getViewsTreeData")
    @ResponseBody
    public Object getViewsTreeData(String codeName, Integer reportId) {
        try {
            String rsCategoryTreeStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.CategoryTree, username, password);
            List<Object> treeModelList = objectMapper.readValue(rsCategoryTreeStr, Envelop.class).getDetailModelList();
            List<RsCategoryTypeTreeModel> rsCategoryTypeTreeModelList = (List<RsCategoryTypeTreeModel>) this.getEnvelopList(treeModelList, new ArrayList<RsCategoryTypeTreeModel>(), RsCategoryTypeTreeModel.class);

            this.setRsCategoryViews(rsCategoryTypeTreeModelList, reportId);

            return rsCategoryTypeTreeModelList;
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(HealthBusinessController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    // 设置视图类别拥有的视图
    private void setRsCategoryViews(List<RsCategoryTypeTreeModel> rsCategoryTypeTreeModelList, Integer reportId) throws Exception {
        Map<String, Object> params;
        RsCategoryTypeTreeModel rsCategoryTypeTreeModel;
        for (RsCategoryTypeTreeModel rsCategory : rsCategoryTypeTreeModelList) {
            params = new HashMap<>();
            params.put("filters", "categoryId=" + rsCategory.getId());
            String rsResourcesStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.NoPageResources, params, username, password);
            List<Object> rsResourcesList = objectMapper.readValue(rsResourcesStr, Envelop.class).getDetailModelList();
            List<RsResourcesModel> rsResourcesModelList = (List<RsResourcesModel>) this.getEnvelopList(rsResourcesList, new ArrayList<RsResourcesModel>(), RsResourcesModel.class);

            for (RsResourcesModel rsResources : rsResourcesModelList) {
                rsCategoryTypeTreeModel = new RsCategoryTypeTreeModel();
                rsCategoryTypeTreeModel.setId(rsResources.getId());
                rsCategoryTypeTreeModel.setName(rsResources.getName());
                rsCategoryTypeTreeModel.setPid(rsCategory.getId());
                params = new HashMap<>();
                params.put("reportId", reportId);
                params.put("resourceId", rsResources.getId());
                String ischeckedStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportViewExist, params, username, password);
                boolean ischecked = (Boolean) objectMapper.readValue(ischeckedStr, Envelop.class).getObj();
                rsCategoryTypeTreeModel.setIschecked(ischecked);
                rsCategory.getChildren().add(rsCategoryTypeTreeModel);
            }

            if (rsCategory.getChildren() != null && rsCategory.getChildren().size() != 0) {
                setRsCategoryViews(rsCategory.getChildren(), reportId);
            }
        }
    }

    /**
     * 获取选择的报表视图
     */
    @RequestMapping("/getSelectedViews")
    @ResponseBody
    public Object getSelectedViews(Integer reportId) {
        Map<String, Object> params = new HashMap<>();
        params.put("reportId", reportId);
        try {
            return doGet(comUrl + ServiceApi.Resources.RsReportViews, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(HealthBusinessController.class).error(e.getMessage());
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
            RsReportModel model = objectMapper.readValue(data, RsReportModel.class);
            if (StringUtils.isEmpty(model.getCode())) {
                return failed("编码不能为空！");
            }
            if (StringUtils.isEmpty(model.getName())) {
                return failed("名称不能为空！");
            }

            if (model.getId() == null) {
                // 新增
                params.put("rsReport", data);
                return HttpClientUtil.doPost(comUrl + ServiceApi.Resources.RsReportSave, params, username, password);
            } else {
                // 修改
                String urlGet = comUrl + ServiceApi.Resources.RsReportPrefix + model.getId();
                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);

                RsReportModel updateModel = getEnvelopModel(envelopGet.getObj(), RsReportModel.class);
                updateModel.setCode(model.getCode());
                updateModel.setName(model.getName());
                updateModel.setReportCategoryId(model.getReportCategoryId());
                updateModel.setStatus(model.getStatus());
                updateModel.setRemark(model.getRemark());
                updateModel.setTemplatePath(model.getTemplatePath());

                params.put("rsReport", objectMapper.writeValueAsString(updateModel));
                return HttpClientUtil.doPut(comUrl + ServiceApi.Resources.RsReportSave, params, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportController.class).error(e.getMessage());
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
            return HttpClientUtil.doDelete(comUrl + ServiceApi.Resources.RsReportDelete, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证资源报表编码是否唯一
     */
    @RequestMapping("/isUniqueCode")
    @ResponseBody
    public Object isUniqueCode(@RequestParam Integer id, @RequestParam String code) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("code", code);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportIsUniqueCode, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 验证资源报表名称是否唯一
     */
    @RequestMapping("/isUniqueName")
    @ResponseBody
    public Object isUniqueName(@RequestParam Integer id, @RequestParam String name) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("id", id);
            params.put("name", name);
            return HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportIsUniqueName, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportController.class).error(e.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    /**
     * 列表：模版导入
     */
    @RequestMapping("upload")
    @ResponseBody
    public Object upload(@RequestParam MultipartFile file, @RequestParam Integer id) {
        try {
            Envelop result = new Envelop();

            Map<String, Object> uploadFileParams = FileUploadUtil.getParams(file.getInputStream(), file.getOriginalFilename());
            String storagePath = uploadFileParams.size() == 0 ? "" : HttpClientUtil.doPost(comUrl + "/filesReturnUrl", uploadFileParams, username, password);

            if (!StringUtils.isEmpty(storagePath)) {
                String urlGet = comUrl + ServiceApi.Resources.RsReportPrefix + id;
                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);
                RsReportModel updateModel = getEnvelopModel(envelopGet.getObj(), RsReportModel.class);
                updateModel.setTemplatePath(storagePath);

                Map<String, Object> params = new HashMap<>();
                params.put("rsReport", objectMapper.writeValueAsString(updateModel));
                String envelopUpdateStr = HttpClientUtil.doPut(comUrl + ServiceApi.Resources.RsReportSave, params, username, password);

                Envelop envelopUpdate = objectMapper.readValue(envelopUpdateStr, Envelop.class);
                if (envelopUpdate.isSuccessFlg()) {
                    result.setSuccessFlg(true);
                    result.setObj(storagePath);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg("文件保存失败！");
                }
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg("请上传非空文件！");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed("上传文件发生异常");
        }
    }

    /**
     * 保存资源配置
     */
    @RequestMapping("saveSetting")
    @ResponseBody
    public Object saveSetting(@RequestParam Integer reportId, @RequestParam String data) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("reportId", reportId);
            params.put("modelListJson", data);
            return HttpClientUtil.doPost(comUrl + ServiceApi.Resources.RsReportViewSave, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            return failed("保存发生异常");
        }
    }

    /**
     * 获取报表模版内容及其各个图形数据
     */
    @RequestMapping("getTemplateData")
    @ResponseBody
    public Object getTemplateData(@RequestParam String reportCode) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        try {
            params.put("reportCode", reportCode);
            String tcEnvelopStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportTemplateContent, params, username, password);
            String templateContent = objectMapper.readValue(tcEnvelopStr, Envelop.class).getObj().toString();
            envelop.setObj(templateContent);
            envelop.setSuccessFlg(true);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return failed("保存发生异常");
        }
    }

}
