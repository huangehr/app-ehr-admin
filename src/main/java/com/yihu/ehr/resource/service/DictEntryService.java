package com.yihu.ehr.resource.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.resource.RsDictionaryEntryModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/25
 */
@Service("rsDictEntryService")
public class DictEntryService extends ExtendService<RsDictionaryEntryModel> {

    public DictEntryService() {
        init(
                "/resources/dictentries",        //searchUrl
                "/resources/dictentries/{id}",   //modelUrl
                "/resources/dictentries",        //addUrl
                "/resources/dictentries",   //modifyUrl
                "",                            //deleteUrl
                "/resources/dictentries/{id}"       //deleteUniqUrl
        );
        existenceUrl = "/resources/dictentries/existence"; //存在
    }
}
