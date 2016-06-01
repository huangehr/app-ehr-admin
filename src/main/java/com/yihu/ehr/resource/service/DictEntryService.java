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
                "/resources/dict_entries",        //searchUrl
                "/resources/dict_entries/{id}",   //modelUrl
                "/resources/dict_entries",        //addUrl
                "/resources/dict_entries",   //modifyUrl
                "",                            //deleteUrl
                "/resources/dict_entries/{id}"       //deleteUniqUrl
        );
        existenceUrl = "/resources/dict_entries/existence"; //存在
    }
}
