package com.yihu.ehr.apps.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.app.AppApiResponseModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/23
 */
@Service
public class AppApiResponseService extends ExtendService<AppApiResponseModel> {

    public AppApiResponseService() {
        init(
                "/appApiResponse",                   //searchUrl
                "/appApiResponse/{id}",             //modelUrl
                "/appApiResponse",                  //addUrl
                "/appApiResponse",                  //modifyUrl
                "/appApiResponse"           //deleteUrl
        );
        deleteUniqUrl = "/appApiResponse/{id}";
    }


}
