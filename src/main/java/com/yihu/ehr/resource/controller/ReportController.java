package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.resource.RsReportModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
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

import java.util.HashMap;
import java.util.Map;

import static com.yihu.ehr.util.HttpClientUtil.doGet;
import static com.yihu.ehr.util.HttpClientUtil.doPut;

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
     * 分页查询
     */
    @RequestMapping("/search")
    @ResponseBody
    public Object search(String codeName, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        StringBuffer filters = new StringBuffer();

        if (!StringUtils.isEmpty(codeName)) {
            filters.append("code?" + codeName + " g1;name?" + codeName + " g1;");
        }

        params.put("filters", filters.toString());
        params.put("page", page);
        params.put("size", rows);

        try {
            return HttpClientUtil.doGet(comUrl + ServiceApi.Resources.RsReports, params, username, password);
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
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
                params.put("rsReportCategory", data);
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

                params.put("rsReportCategory", objectMapper.writeValueAsString(updateModel));
                return HttpClientUtil.doPut(comUrl + ServiceApi.Resources.RsReportSave, params, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
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
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
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
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
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
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
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
            String filePath = uploadFileParams.size() == 0 ? "" : HttpClientUtil.doPost(comUrl + "/filesReturnUrl", uploadFileParams, username, password);

            if(!StringUtils.isEmpty(filePath)) {
                String urlGet = comUrl + ServiceApi.Resources.RsReportPrefix + id;
                String envelopGetStr = HttpClientUtil.doGet(urlGet, username, password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);
                RsReportModel updateModel = getEnvelopModel(envelopGet.getObj(), RsReportModel.class);
                updateModel.setTemplatePath(filePath);

                Map<String, Object> params = new HashMap<>();
                params.put("rsReportCategory", objectMapper.writeValueAsString(updateModel));
                String envelopUpdateStr = HttpClientUtil.doPut(comUrl + ServiceApi.Resources.RsReportSave, params, username, password);

                Envelop envelopUpdate = objectMapper.readValue(envelopUpdateStr, Envelop.class);
                if(envelopUpdate.isSuccessFlg()) {
                    result.setSuccessFlg(true);
                    result.setObj(filePath);
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

}
