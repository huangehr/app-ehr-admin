package com.yihu.ehr.resource.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.resource.RsAppResourceMetadataModel;
import com.yihu.ehr.agModel.resource.RsRolesResourceMetadataModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/23
 */
@Service
public class RolesGrantService extends ExtendService<RsRolesResourceMetadataModel> {

    public RolesGrantService() {
        init(
                "/resources/roles_resource/{roles_res_id}/metadata",        //searchUrl
                "/resources/metadata/grants/{id}",   //modelUrl
                "/resources/metadatas",               //addUrl
                "/resources/metadata/grants/{id}",   //modifyUrl
                "/resources/metadatas"                //deleteUrl
        );
    }
}
