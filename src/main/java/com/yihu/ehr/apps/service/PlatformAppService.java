package com.yihu.ehr.apps.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.app.AppModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/23
 */
@Service
public class PlatformAppService extends ExtendService<AppModel> {

    public PlatformAppService() {
        init(
                "/apps",                   //searchUrl
                "/apps/{id}",        //modelUrl
                "/apps",                  //addUrl
                "/apps",                  //modifyUrl
                "/apps/{id}"        //deleteUrl
        );
        existenceUrl = "/apps/filterList"; //存在
    }

}
