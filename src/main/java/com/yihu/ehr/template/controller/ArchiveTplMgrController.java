package com.yihu.ehr.template.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.template.service.TemplateService;
import com.yihu.ehr.util.Envelop;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
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

    @Value("${service-gateway.template}")
    public String templateUrl;

    public ArchiveTplMgrController() {
        this.init(
                "/template/archiveTplManager",       //列表页面url
                "/template/archiveTplDialog"      //编辑页面url
        );
    }

    @RequestMapping("/getCDAListByVersionAndKey")
    @ResponseBody
    public Object getCDAListByVersionAndKey(String version, String searchName, int page, int rows) {
        String url = "/cda/cdas";
        try {
            PageParms pageParms =
                    new PageParms(rows, page)
                            .setFields("id,name")
                            .addExt("version", version)
                            .addGroupNotNull("name", searchName, "g1")
                            .addGroupNotNull("code", searchName, "g1");
            String resultStr = service.search(url, pageParms);
            return formatComboData(resultStr, "id", "name");
        } catch (Exception e) {
            return faild("系统出错！");
        }
    }

    @RequestMapping("validateTitle")
    @ResponseBody
    public Object validateTitle(String version, String title) {
        String url = "/template/title/existence";
        Map<String, Object> params = new HashMap<>();
        params.put("version", version);
        params.put("title", title);

        try {
            String resultStr = service.search(url, params);
            Envelop result = getEnvelop(resultStr);
            result.setSuccessFlg((boolean) getEnvelop(resultStr).getObj());
            return result;
        } catch (Exception e) {
            return faild("系统出错！");
        }
    }


    @RequestMapping(value = "update_tpl_content")
    @ResponseBody
    public Object updateTplContent(HttpServletRequest request, String templateId, String mode, int size, String name) {

        try {
            Envelop envelop = new Envelop();
            if(StringUtils.isEmpty(name) || !name.contains(".") || !name.substring(name.lastIndexOf(".")).equals(".html")){
                envelop.setErrorMsg("请上传html文件！");
                envelop.setSuccessFlg(false);
                return envelop;
            }

            Map map = new HashMap<>();
            map.put("pc", "pc".equals(mode));

            service.doPostFile(
                    templateUrl + "s/" + templateId + "/content",
                    map,
                    name,
                    "file",
                    request.getInputStream(),
                    size
            );

            envelop.setSuccessFlg(true);
            return envelop;
        } catch (IOException e) {
            e.printStackTrace();
            return faild("系统出错！");
        }
    }
}
