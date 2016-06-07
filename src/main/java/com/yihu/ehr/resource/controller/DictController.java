package com.yihu.ehr.resource.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.resource.service.DictService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/20
 */
@Controller("resource-dict")
@RequestMapping("/resource/dict")
public class DictController extends ExtendController<DictService> {

    public DictController() {
        this.init(
                "/resource/dict/grid",        //列表页面url
                "/resource/dict/dialog"      //编辑页面url
        );
        comboKv.put("code", "code");
    }

    @Override
    public Map beforeGotoModify(Map params) {
        try {
            params.put("id", URLEncoder.encode(String.valueOf(params.get("id")), "UTF-8"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return params;
    }
}
