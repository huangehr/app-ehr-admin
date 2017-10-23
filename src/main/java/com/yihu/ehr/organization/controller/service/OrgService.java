package com.yihu.ehr.organization.controller.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.organization.controller.model.OrgMsgModel;
import com.yihu.ehr.user.controller.model.OrgDeptMsgModel;
import org.springframework.stereotype.Service;

/**
 * Created by zdm on 2017/10/19.
 */
@Service
public class OrgService extends ExtendService<OrgMsgModel> {
    public OrgService() {
        init(
                "/orgImport/metadata",        //searchUrl
                "/orgImport/metadata/{id}",   //modelUrl
                "/orgImport/metadata",        //addUrl
                "/orgImport/metadata",        //modifyUrl
                "/orgImport/metadata"        //deleteUrl
        );
        existenceUrl = "/orgImport/existence"; //存在
    }
}
