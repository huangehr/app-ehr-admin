package com.yihu.ehr.resource.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.resource.RsAppResourceMetadataModel;
import com.yihu.ehr.agModel.resource.RsMetadataModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/23
 */
@Service
public class GrantService extends ExtendService<RsAppResourceMetadataModel> {

    public GrantService() {
        init(
                "/resources/metadata/grants",        //searchUrl
                "/resources/metadata/grants/{id}",   //modelUrl
                "/resources/metadatas",               //addUrl
                "/resources/metadata/grants/{id}",   //modifyUrl
                "/resources/metadatas"                //deleteUrl
        );
    }
}
