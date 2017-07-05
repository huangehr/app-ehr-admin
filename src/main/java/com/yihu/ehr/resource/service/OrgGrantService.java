package com.yihu.ehr.resource.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.org.RsOrgResourceMetadataModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/23
 */
@Service
public class OrgGrantService extends ExtendService<RsOrgResourceMetadataModel> {

    public OrgGrantService() {
        init(
                "/resources/Org_resource/{Org_res_id}/metadata",        //searchUrl
                "/resources/OrgMetadata/grants/{id}",   //modelUrl
                "/resources/OrgMetadatas",               //addUrl
                "/resources/OrgMetadata/grants/{id}",   //modifyUrl
                "/resources/OrgMetadatas"                //deleteUrl
        );
    }
}
