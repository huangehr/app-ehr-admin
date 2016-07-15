package com.yihu.ehr.apps.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.app.AppFeatureModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/23
 */
@Service
public class AppFeatureService extends ExtendService<AppFeatureModel> {

    public AppFeatureService() {
        init(
                "/filterFeatureNoPage",                   //searchUrl
                "/appFeature/{id}",             //modelUrl
                "/appFeature",                  //addUrl
                "/appFeature",                  //modifyUrl
                "/appFeature"           //deleteUrl
        );
        existenceUrl = "/filterFeatureList"; //存在
        deleteUniqUrl = "/appFeature/{id}";
    }


}
