package com.yihu.ehr.patient.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.patient.MedicalCardsModel;
import com.yihu.ehr.agModel.resource.RsMetadataModel;
import org.springframework.stereotype.Service;


@Service
public class MedicalCardsService extends ExtendService<MedicalCardsModel> {

    public MedicalCardsService() {
        init(
                "/resources/metadata",        //searchUrl
                "/resources/metadata/{id}",   //modelUrl
                "/resources/metadata",        //addUrl
                "/resources/metadata",        //modifyUrl
                "/resources/metadata"        //deleteUrl
        );
    }
}
