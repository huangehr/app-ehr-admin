package com.yihu.ehr.template.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.model.profile.MTemplate;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016-4-18
 */
@Service
public class TemplateService extends ExtendService<MTemplate> {

    public TemplateService() {
        init(
                "/templates",        //searchUrl
                "/template/{id}",   //modelUrl
                "/template",        //addUrl
                "/template/{id}",        //modifyUrl
                "/template/{id}"        //deleteUrl
        );
    }

}
