package com.yihu.ehr.user.controller.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.user.controller.model.OrgDeptMsgModel;
import org.springframework.stereotype.Service;

/**
 * Created by Administrator on 2017/7/14.
 */
@Service
public class OrgDeptService extends ExtendService<OrgDeptMsgModel> {
    public OrgDeptService() {
        init(
                "/doctorImport/metadata",        //searchUrl
                "/doctorImport/metadata/{id}",   //modelUrl
                "/doctorImport/metadata",        //addUrl
                "/doctorImport/metadata",        //modifyUrl
                "/doctorImport/metadata"        //deleteUrl
        );
        existenceUrl = "/doctorImport/existence"; //存在
    }
}
