package com.yihu.ehr.template.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.template.service.TemplateService;
import com.yihu.ehr.util.http.HttpResponse;
import com.yihu.ehr.util.http.HttpUtils;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 健康档案浏览器模板管理控制器。
 *
 * @author lincl
 * @version 1.0
 * @created 2016-4-18
 */
@Controller
@RequestMapping("/template")
public class ArchiveTplMgrController extends ExtendController<TemplateService> {

    public ArchiveTplMgrController() {
        this.init(
                "/template/archiveTplManager",       //列表页面url
                "/template/archiveTplDialog"      //编辑页面url
        );
    }

    @RequestMapping("/archiveTplManager/initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/template/archiveTplManager");
        return "pageView";
    }

    @RequestMapping("/getCDAListByVersionAndKey")
    @ResponseBody
    public Object getCDAListByVersionAndKey(String version, String searchName,String searchParm, int page, int rows) {
        String url = "/cda/cdas";
        try {
            PageParms pageParms = new PageParms(rows, page)
                    .setFields("id,name")
                    .addExt("version", version)
                    .addGroupNotNull("name", searchName, "g1")
                    .addGroupNotNull("code", searchName, "g1")
                    .addGroupNotNull("name", PageParms.LIKE, searchParm, "g1")
                    .addGroupNotNull("code", PageParms.LIKE, searchParm, "g1");
            String resultStr = service.search(url, pageParms);
            return formatComboData(resultStr, "id", "name");
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @Override
    public Object update(String id, String model, String modelName, String extParms) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("id", id);
            if (StringUtils.isEmpty(modelName)) {
                params.put("model", model);
            } else {
                params.put(modelName, model);
            }
            //修改或复制
            if (!StringUtils.isEmpty(extParms)) {
                Map<String, String> type = toModel(extParms, Map.class);
                for (String key : type.keySet()) {
                    params.put(key, type.get(key));
                }
            }
            if (StringUtils.isEmpty(id) || "0".equals(id)) {
                String url = "/profile/api/v1.0/templates";
                HttpResponse httpResponse = HttpUtils.doPost(adminInnerUrl + url, params);
                return toModel(httpResponse.getContent(), Envelop.class);
            } else {
                String url = "/profile/api/v1.0/templates/" + id;
                HttpResponse httpResponse = HttpUtils.doPut(adminInnerUrl + url, params);
                return toModel(httpResponse.getContent(), Envelop.class);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @Override
    public Object delete(String ids, String idField, String extParms, String type){
        try {
            Map<String, Object> params = new HashMap<>();
            if (StringUtils.isEmpty(idField)) {
                params.put("ids", nullToSpace(ids));
            } else {
                params.put(idField, nullToSpace(ids));
            }
            params = putAll(extParms, params);
            params = beforeDel(params);
            String rs;
            if("uniq".equals(type)) {
                rs = service.deleteUniq(params);
            } else {
                rs = service.delete(params);
            }
            return afterDel(rs, params);
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @Override
    public Object search(String fields, String filters, String sorts, int page, int rows, String extParms){
        Map<String, Object> params = new HashMap<>();
        params.put("sorts", "");
        params.put("page", page);
        params.put("size", rows);
        if (!StringUtils.isEmpty(extParms)) {
            Map<String, String> extParmsMap = toModel(extParms, Map.class);
            for (String key : extParmsMap.keySet()) {
                if (!StringUtils.isEmpty(extParmsMap.get(key))) {
                    filters += ";title?" + extParmsMap.get(key);
                }
            }
        }
        params.put("filters", filters);
        String url = adminInnerUrl + "/profile/api/v1.0/templates";
        try {
            HttpResponse response = HttpUtils.doGet(url, params);
            return toModel(response.getContent(), Envelop.class);
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @RequestMapping("/validateTitle")
    @ResponseBody
    public Object validateTitle(String version, String title) throws Exception {
        String url = "/profile/api/v1.0/template/title/existence";
        Map<String, Object> params = new HashMap<>();
        params.put("version", version);
        params.put("title", title);
        HttpResponse response = HttpUtils.doGet(adminInnerUrl + url, params);
        if (Boolean.valueOf(response.getContent())) {
            return success(null);
        } else {
            return failed(null);
        }
    }

    @RequestMapping(value = "update_tpl_content")
    @ResponseBody
    public Object updateTplContent(HttpServletRequest request, String templateId, String mode, int size, String name) {
        try {
            if (StringUtils.isEmpty(name) || !name.contains(".")){
                return failed("缺失文件扩展名!");
            }
            Map map = new HashMap<>();
            map.put("pc", "pc".equals(mode));
            service.doPostFile(
                    adminInnerUrl + "/profile/api/v1.0/templates/" + templateId + "/content",
                    map,
                    name,
                    "file",
                    request.getInputStream(),
                    size
            );
            return success(true);
        } catch (IOException e) {
            e.printStackTrace();
            return systemError();
        }
    }

}
