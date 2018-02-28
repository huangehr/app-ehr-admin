package com.yihu.ehr.template.controller;

        import com.yihu.ehr.adapter.controller.ExtendController;
        import com.yihu.ehr.adapter.service.PageParms;
        import com.yihu.ehr.agModel.template.TemplateModel;
        import com.yihu.ehr.model.profile.MTemplate;
        import com.yihu.ehr.template.service.TemplateService;
        import com.yihu.ehr.util.HttpClientUtil;
        import com.yihu.ehr.util.rest.Envelop;
        import org.apache.commons.lang.StringUtils;
        import org.springframework.beans.factory.annotation.Value;
        import org.springframework.stereotype.Controller;
        import org.springframework.ui.Model;
        import org.springframework.web.bind.annotation.RequestMapping;
        import org.springframework.web.bind.annotation.ResponseBody;

        import javax.servlet.http.HttpServletRequest;
        import java.io.IOException;
        import java.util.HashMap;
        import java.util.List;
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
    @Value("${service-gateway.url}")
    public String comUrl;
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;

    public ArchiveTplMgrController() {
        this.init(
                "/template/archiveTplManager",       //列表页面url
                "/template/archiveTplDialog"      //编辑页面url
        );
    }

    /**
     *数据存储
     * @param model
     * @return
     */
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
            PageParms pageParms =
                    new PageParms(rows, page)
                            .setFields("id,name")
                            .addExt("version", version)
                            .addGroupNotNull("name", searchName, "g1")
                            .addGroupNotNull("code", searchName, "g1")
                            .addGroupNotNull("name",PageParms.LIKE,searchParm, "g1")
                            .addGroupNotNull("code",PageParms.LIKE, searchParm, "g1");

            String resultStr = service.search(url, pageParms);
            return formatComboData(resultStr, "id", "name");
        } catch (Exception e) {
            return faild("系统出错！");
        }
    }

    @RequestMapping("validateTitle")
    @ResponseBody
    public Object validateTitle(String version, String title, String orgCode) {
        String url = "/template/title/existence";
        Map<String, Object> params = new HashMap<>();
        params.put("version", version);
        params.put("title", title);
        params.put("org_code", orgCode);

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

    @Override
    public Map beforeUpdate(Map parms){
        String model  = (String)parms.get("model");
        MTemplate mTemplate = toModel(model,MTemplate.class);
        Map<String,Object> params = new HashMap<>();
        try{
            params.put("version_code",mTemplate.getCdaVersion());
            params.put("cda_id",mTemplate.getCdaDocumentId());
            String _rus = HttpClientUtil.doGet(comUrl + "/cda/cda", params, username, password);
            Envelop envelop = getEnvelop(_rus);
            if(envelop.isSuccessFlg()){
                List mcdaDocuments = envelop.getDetailModelList();
                if(mcdaDocuments.size()>0){
                    Object obj = mcdaDocuments.get(0);
                    Map dataMap  = objectMapper.readValue(toJson(obj), Map.class);
                    mTemplate.setCdaCode(dataMap.get("code").toString());
                    parms.put("model",toJson(mTemplate));
                }else{
                    throw new RuntimeException("获取cda文档失败！cda文档不存在！");
                }
            }else{
                throw new RuntimeException("获取cda文档失败！");
            }
        }catch (Exception e){
            throw new RuntimeException(e.getMessage());
        }
        return parms;
    }
    @Override
    public Object afterGotoModify(Object rs, Map params) {

        if("new".equals(params.get("mode"))){
            String orgCode;
            TemplateModel template = (TemplateModel) rs;
            if(!StringUtils.isEmpty(orgCode = (String) params.get("orgCode"))){
                try {
                    Envelop envelop = getEnvelop(
                            service.doGet(
                                    service.comUrl + "/organizations/" + orgCode, new HashMap<>()));
                    if(envelop.isSuccessFlg()){
                        Map<String, String> obj = (Map<String, String>) envelop.getObj();
                        template.setOrganizationCode(obj.get("orgCode"));
                        template.setProvince(obj.get("province"));
                        template.setCity(obj.get("city"));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            return template;
        }
        return rs;
    }
}
