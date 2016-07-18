package com.yihu.ehr.apps.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.apps.service.AppApiParameterService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/19
 */
@Controller
@RequestMapping("/app/api/parameter")
public class AppApiParameterController extends ExtendController<AppApiParameterService> {

    public AppApiParameterController() {
        this.init(
                "",        //列表页面url
                ""       //编辑页面url
        );
    }

}
