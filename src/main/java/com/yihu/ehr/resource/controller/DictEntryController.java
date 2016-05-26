package com.yihu.ehr.resource.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.resource.service.DictEntryService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/20
 */
@Controller("resource-dict-entry")
@RequestMapping("/resource/dict/entry")
public class DictEntryController extends ExtendController<DictEntryService> {

    public DictEntryController() {
        this.init(
                "",                                     //列表页面url
                "/resource/dict/entryDialog"      //编辑页面url
        );
    }
}
