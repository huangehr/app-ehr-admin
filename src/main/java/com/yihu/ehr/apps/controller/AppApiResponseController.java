package com.yihu.ehr.apps.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.apps.service.AppApiResponseService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/19
 */
@Controller
@RequestMapping("/app/api/response")
public class AppApiResponseController extends ExtendController<AppApiResponseService> {

    public AppApiResponseController() {
        this.init(
                "",        //列表页面url
                ""       //编辑页面url
        );
    }

}
