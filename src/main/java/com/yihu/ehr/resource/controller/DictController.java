package com.yihu.ehr.resource.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.resource.service.DictService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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

}
