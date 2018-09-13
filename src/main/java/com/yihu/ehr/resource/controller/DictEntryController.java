package com.yihu.ehr.resource.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.resource.service.DictEntryService;
import com.yihu.ehr.util.HttpClientUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/20
 */
@Controller("resource-dict-entry")
@RequestMapping("/resource/dict/entry")
public class DictEntryController extends ExtendController<DictEntryService> {
    @Value("${service-gateway.adminInnerUrl}")
    private String comUrl;
    public DictEntryController() {
        this.init(
                "",                                     //列表页面url
                "/resource/dict/entryDialog"      //编辑页面url
        );
    }

    /**
     * 用户修改-选择机构：根据字典编码获取职务的字典项
     * @return
     */
    @RequestMapping("getDictEntryByDictCode")
    @ResponseBody
    public Object getDictEntryByDictCode() {
        String getOrgUrl = "/resource/api/v1.0/resources/dict/code/dict_entries";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        params.put("dict_code","STD_TECH_TITLE");//医务人员职务字典
        try {
            resultStr = HttpClientUtil.doGet(comUrl + getOrgUrl, params, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }
}
