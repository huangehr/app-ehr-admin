package com.yihu.ehr.resource.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.resource.RsMetadataModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/23
 */
@Service
public class MetaService extends ExtendService<RsMetadataModel> {

    public MetaService() {
        init(
                "/resources/metadatas",        //searchUrl
                "/resources/metadatas/{id}",   //modelUrl
                "/resources/metadatas",        //addUrl
                "/resources/metadatas",        //modifyUrl
                "/resources/metadatas"        //deleteUrl
        );
        existenceUrl = "/resources/metadatas/existence"; //存在
    }
}
