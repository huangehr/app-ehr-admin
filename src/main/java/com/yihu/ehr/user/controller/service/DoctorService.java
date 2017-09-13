package com.yihu.ehr.user.controller.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/23
 */
@Service
public class DoctorService extends ExtendService<DoctorMsgModel> {

    public DoctorService() {
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
