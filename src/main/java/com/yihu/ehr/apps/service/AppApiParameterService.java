package com.yihu.ehr.apps.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.app.AppApiParameterModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/23
 */
@Service
public class AppApiParameterService extends ExtendService<AppApiParameterModel> {

    public AppApiParameterService() {
        init(
                "/appApiParameter",                   //searchUrl
                "/appApiParameter/{id}",             //modelUrl
                "/appApiParameter",                  //addUrl
                "/appApiParameter",                  //modifyUrl
                "/appApiParameter"           //deleteUrl
        );
        deleteUniqUrl = "/appApiParameter/{id}";
    }


}
