package com.yihu.ehr.emergency.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import org.springframework.stereotype.Service;

/**
 * @author zdm
 * @version 1.0
 * @created 2017/11/15
 */
@Service
public class AmbulanceService extends ExtendService<DoctorMsgModel> {

    public AmbulanceService() {
        init(
                "/ambulanceImport/idIsExistence",        //searchUrl
                "/ambulanceImport/orgCodeIsExistence",   //modelUrl
                "/doctorImport/metadata",        //addUrl
                "/doctorImport/metadata",        //modifyUrl
                "/doctorImport/metadata"        //de

              //  "/ambulanceImport/idIsExistence",        //id
             //   "/ambulanceImport/orgCodeIsExistence",   //orgCode
             //   "/ambulanceImport/orgNameIsExistence",        //orgName


        );
        existenceUrl = "/doctorImport/existence"; //存在
    }
}
