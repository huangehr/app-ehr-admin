package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.agModel.resource.RsCategoryTypeTreeModel;
import com.yihu.ehr.agModel.resource.RsReportModel;
import com.yihu.ehr.agModel.resource.RsReportViewModel;
import com.yihu.ehr.agModel.resource.RsResourcesModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.model.resource.MChartInfoModel;
import com.yihu.ehr.util.FileUploadUtil;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.datetime.DateTimeUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.ParseException;
import java.util.*;

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
                String result = HttpClientUtil.doGet(url, username, password);
                detailModel = objectMapper.readValue(result, Envelop.class).getObj();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportController.class).error(e.getMessage());
        }
        model.addAttribute("detailModel", toJson(detailModel));
        model.addAttribute("contentPage", "resource/report/detail");
        return "simpleView";
    }

    /**
     *
     */
    @RequestMapping(value = "selView")
    public String selView(Model model, Integer id) {
        model.addAttribute("id", id);
        model.addAttribute("contentPage", "resource/report/selView");
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
     *
     */
    @RequestMapping(value = "tmpViewSetting")
    public String tmpViewSetting(Model model, Integer id, String code) {
        model.addAttribute("id", id);
        model.addAttribute("code", code);
        model.addAttribute("contentPage", "resource/report/tmpViewSetting");
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
    public Object getViewsTreeData(String codeName, Integer reportId, HttpServletRequest request) {
        try {
            //从Session中获取用户的角色和和授权视图列表作为查询参数
            boolean isAccessAll = getIsAccessAllRedis(request);
            List<String> userResourceList  = getUserResourceListRedis(request);
            if (!isAccessAll) {
                if (null == userResourceList || userResourceList.size() <= 0) {
                    return failed("无权访问");
                }
            }
            Map<String, Object> params = new HashMap<>();
            if (isAccessAll) {
                params.put("userResource", "*");
            } else {
                params.put("userResource", "auth");
            }
            String rsCategoryTreeStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.CategoryTree, params, username, password);
            List<Object> treeModelList = objectMapper.readValue(rsCategoryTreeStr, Envelop.class).getDetailModelList();
            List<RsCategoryTypeTreeModel> rsCategoryTypeTreeModelList = (List<RsCategoryTypeTreeModel>) this.getEnvelopList(treeModelList, new ArrayList<RsCategoryTypeTreeModel>(), RsCategoryTypeTreeModel.class);
            this.setRsCategoryViews(rsCategoryTypeTreeModelList, reportId, userResourceList, isAccessAll);
            return rsCategoryTypeTreeModelList;
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ReportController.class).error(e.getMessage());
            return failed(e.getMessage());
        }
    }

    // 设置视图类别拥有的视图
    private void setRsCategoryViews(List<RsCategoryTypeTreeModel> rsCategoryTypeTreeModelList, Integer reportId, List<String> userResourceList, boolean isAccessAll) throws Exception {
        Map<String, Object> params;
        RsCategoryTypeTreeModel rsCategoryTypeTreeModel;
        for (RsCategoryTypeTreeModel rsCategory : rsCategoryTypeTreeModelList) {
            params = new HashMap<>();
            params.put("filters", "categoryId=" + rsCategory.getId());
            String rsResourcesStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.NoPageResources, params, username, password);
            List<Object> rsResourcesList = objectMapper.readValue(rsResourcesStr, Envelop.class).getDetailModelList();
            List<RsResourcesModel> rsResourcesModelList = (List<RsResourcesModel>) this.getEnvelopList(rsResourcesList, new ArrayList<RsResourcesModel>(), RsResourcesModel.class);
            for (RsResourcesModel rsResources : rsResourcesModelList) {
                if (isAccessAll || (rsResources.getGrantType().equals("0") || userResourceList.contains(rsResources.getId()))) {
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
            }
            if (rsCategory.getChildren() != null && rsCategory.getChildren().size() != 0) {
                setRsCategoryViews(rsCategory.getChildren(), reportId, userResourceList, isAccessAll);
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
            LogService.getLogger(ReportController.class).error(e.getMessage());
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
    public Object upload(Integer id, String name, HttpServletRequest request) {
        try {
            Envelop result = new Envelop();

            Map<String, Object> uploadFileParams = FileUploadUtil.getParams(request.getInputStream(), name);
            String storagePath = uploadFileParams.size() == 0 ? "" : HttpClientUtil.doPost(comUrl + "/filesReturnUrl", uploadFileParams, username, password);

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
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed("导入模版发生异常");
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
    public Object getTemplateData(@RequestParam String reportCode, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        Map<String, Object> resultMap = new HashMap<>();
        List<Map<String, Object>> viewInfos = new ArrayList<>();
        try {
            List<String> userRolesList  = getUserRolesListRedis(request);
            String roleId = objectMapper.writeValueAsString(userRolesList);

            // 获取报表模版内容
            params.put("reportCode", reportCode);
            String tcEnvelopStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportTemplateContent, params, username, password);
            String templateContent = objectMapper.readValue(tcEnvelopStr, Envelop.class).getObj().toString();
            resultMap.put("templateContent", templateContent);

            // 获取报表视图
            params.clear();
            params.put("code", reportCode);
            String reportEnvelopStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportFindByCode, params, username, password);
            RsReportModel rsReportModel = getEnvelopModel(objectMapper.readValue(reportEnvelopStr, Envelop.class).getObj(), RsReportModel.class);
            params.clear();
            params.put("reportId", rsReportModel.getId());
            String viewListEnvelopStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReportViews, params, username, password);
            String viewListStr = objectMapper.writeValueAsString(objectMapper.readValue(viewListEnvelopStr, Envelop.class).getDetailModelList());
            List<RsReportViewModel> rsReportViewList = objectMapper.readValue(viewListStr, new TypeReference<List<RsReportViewModel>>() {
            });

            // 获取图形配置
            for (RsReportViewModel view : rsReportViewList) {
                String resourceEnvelopStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.Resources + "/" + view.getResourceId(), params, username, password);
                RsResourcesModel rsResourcesModel = getEnvelopModel(objectMapper.readValue(resourceEnvelopStr, Envelop.class).getObj(), RsResourcesModel.class);
                params.clear();
                params.put("resourceId", view.getResourceId());
                String queryEnvelopStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.QueryByResourceId, params, username, password);
                String queryStr = objectMapper.readValue(queryEnvelopStr, Envelop.class).getObj().toString();

                Map<String, Object> viewInfo = new HashMap<>();
                Map<String, Object> conditions = translateViewCondition(rsResourcesModel.getDataSource(), queryStr);
                viewInfo.put("conditions", conditions); // 视图数据过滤条件。
                List<Map<String, Object>> options = new ArrayList<>();
                if (rsResourcesModel.getDataSource() == 1) {
                    // 档案视图场合
                    viewInfo.put("type", "record");
                    viewInfo.put("resourceCode", rsResourcesModel.getCode());
                    viewInfo.put("searchParams", queryStr);
                    // 获取展示的列名
                    params.clear();
                    params.put("resourcesCode", rsResourcesModel.getCode());
                    params.put("roleId", roleId);
                    String rowsEnvelopStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.ResourceBrowseResourceMetadata, params, username, password);
                    List columns = objectMapper.readValue(rowsEnvelopStr, Envelop.class).getDetailModelList();
                    viewInfo.put("columns", columns);
                    viewInfos.add(viewInfo);
                } else if (rsResourcesModel.getDataSource() == 2) {
                    // 指标视图场合
                    viewInfo.put("type", "quota");
                    viewInfo.put("resourceId", view.getResourceId());
                    params.clear();
                    params.put("resourceId", view.getResourceId());
                    List<String> userOrgList  = getUserOrgSaasListRedis(request);
                    params.put("userOrgList", userOrgList);
                    params.put("quotaFilter", " ");
                    params.put("dimension", " ");
                    String chartInfoStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.GetRsQuotaPreview, params, username, password);
                    Envelop envelop1 = objectMapper.readValue(chartInfoStr, Envelop.class);
                    String s = objectMapper.writeValueAsString((HashMap<String,String>)envelop1.getObj());
                    MChartInfoModel chartInfoModel = objectMapper.readValue(s,MChartInfoModel.class);
                    Map<String, Object> option = new HashMap<>();
                    option.put("resourceCode", chartInfoModel.getResourceCode());
                    option.put("resourceId", chartInfoModel.getResourceId());
                    option.put("dimensionList", chartInfoModel.getDimensionMap());
                    option.put("option", chartInfoModel.getOption());
                    options.add(option);
                    viewInfo.put("options", options); // 视图包含的指标echart图形的option。
                    viewInfos.add(viewInfo);
                }
            }
            resultMap.put("viewInfos", viewInfos);

            envelop.setObj(resultMap);
            envelop.setSuccessFlg(true);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return failed("获取报表数据发生异常");
        }
    }


    @RequestMapping("getRsQuotaPreview")
    @ResponseBody
    public Object getRsQuotaPreview(@RequestParam String resourceId, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        List<Map<String, Object>> options = new ArrayList<>();
        try {
            Map<String, Object> params = new HashMap<>();
            params.clear();
            params.put("resourceId", resourceId);
            List<String> userOrgList  = getUserOrgSaasListRedis(request);
            params.put("userOrgList", userOrgList);
            String chartInfoStr = HttpClientUtil.doGet(comUrl + ServiceApi.Resources.GetRsQuotaPreview, params, username, password);
            Envelop envelop1 = objectMapper.readValue(chartInfoStr, Envelop.class);
            String s = objectMapper.writeValueAsString((HashMap<String,String>)envelop1.getObj());
            MChartInfoModel chartInfoModel = objectMapper.readValue(s,MChartInfoModel.class);

            Map<String, Object> option = new HashMap<>();
            option.put("resourceCode", chartInfoModel.getResourceCode());
            option.put("resourceId", chartInfoModel.getResourceId());
            option.put("option", chartInfoModel.getOption());
            options.add(option);
            envelop.setSuccessFlg(true);
            envelop.setDetailModelList(options);
        }catch (Exception e){
            e.printStackTrace();
            return failed("获取报表数据发生异常");
        }
        return envelop;
    }

    /**
     * 转换视图数据筛选条件
     */
    private Map<String, Object> translateViewCondition(Integer type, String queryStr) throws IOException, ParseException {
        Map<String, Object> conditions = new HashMap<>();
        if (type == 1) {
            // 档案视图场合
            List<Map<String, Object>> filterList = objectMapper.readValue(queryStr, new TypeReference<List<Map<String, Object>>>() {
            });
            for (int i = 0; i < filterList.size(); i++) {
                Map filter = filterList.get(i);
                String field = filter.get("field").toString();
                String condition = filter.get("condition").toString();
                String value = filter.get("value").toString();
                if ("event_date".equals(field)) {
                    // 期间
                    String date = DateTimeUtil.simpleDateFormat(DateTimeUtil.simpleDateParse(value));
                    if (condition.contains(">")) {
                        conditions.put("startDate", date);
                    } else if (condition.contains("<")) {
                        conditions.put("endDate", date);
                    }
                }
                if ("EHR_000241".equals(field)) {
                    // 地区
                    conditions.put("area", value);
                }
            }
        } else if (type == 2) {
            // 指标视图场合
            Map filter = objectMapper.readValue(queryStr, Map.class);
            if (filter.get("startTime") != null) {
                // 起始日期
                String date = filter.get("startTime").toString();
                conditions.put("startDate", DateTimeUtil.simpleDateFormat(DateTimeUtil.simpleDateParse(date)));
            }
            if (filter.get("endTime") != null) {
                // 终止日期
                String date = filter.get("endTime").toString();
                conditions.put("endDate", DateTimeUtil.simpleDateFormat(DateTimeUtil.simpleDateParse(date)));
            }
            // 地区
            String area = "";
            if (filter.get("province") != null) {
                area += filter.get("province").toString();
            }
            if (filter.get("city") != null) {
                area += filter.get("city").toString();
            }
            if (filter.get("town") != null) {
                area += filter.get("town").toString();
            }
            conditions.put("area", area);
        }
        return conditions;
    }

    /**
     * 生成模板
     * @param id
     * @param content
     * @return
     */
    @RequestMapping("/uploadTemplate")
    @ResponseBody
    public Object uploadTemplate(Integer id, String content, String reportData) {
        try {
            saveSetting(id, reportData);
            Envelop result = new Envelop();
            String filePath = this.getClass().getResource("/").getPath() + "temp/";
            String fileName = System.currentTimeMillis() + "template.html";
            // 生成模板
            FileUploadUtil.createFile(filePath, fileName, content);
            FileInputStream inputStream = new FileInputStream(filePath + fileName);
            Map<String, Object> uploadFileParams = FileUploadUtil.getParams(inputStream, fileName);
            String storagePath = uploadFileParams.size() == 0 ? "" : HttpClientUtil.doPost(comUrl + "/filesReturnUrl", uploadFileParams, username, password);

            String urlGet = comUrl + ServiceApi.Resources.RsReportPrefix + id;
            String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);
            RsReportModel updateModel = getEnvelopModel(envelopGet.getObj(), RsReportModel.class);
            updateModel.setTemplatePath(storagePath);

            Map<String, Object> params = new HashMap<>();
            params.put("rsReport", objectMapper.writeValueAsString(updateModel));
            String envelopUpdateStr = HttpClientUtil.doPut(comUrl + ServiceApi.Resources.RsReportSave, params, username, password);
            // 删除临时文件
            FileUploadUtil.delDir(filePath);

            Envelop envelopUpdate = objectMapper.readValue(envelopUpdateStr, Envelop.class);
            if (envelopUpdate.isSuccessFlg()) {
                result.setSuccessFlg(true);
                result.setObj(storagePath);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg("保存失败！");
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return failed("生成模版发生异常");
        }
    }
}
