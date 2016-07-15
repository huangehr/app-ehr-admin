package com.yihu.ehr.apps.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.app.AppApiModel;
import com.yihu.ehr.agModel.app.AppApiParameterModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/23
 */
@Service
public class AppApiService extends ExtendService<AppApiModel> {

    public AppApiService() {
        init(
                "/appApiNoPage",                   //searchUrl
                "/appApi/{id}",             //modelUrl
                "/appApi",                  //addUrl
                "/appApi",                  //modifyUrl
                "/appApi"           //deleteUrl
        );
        existenceUrl = "/appApiNoPage"; //存在
        deleteUniqUrl = "/appApi/{id}";
    }


}
