package com.yihu.ehr.resource.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.agModel.resource.RsDictionaryModel;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/25
 */
@Service("rsDictService")
public class DictService extends ExtendService<RsDictionaryModel> {
    public DictService() {
        init(
                "/resources/dicts",        //searchUrl
                "/resources/dicts/{id}",   //modelUrl
                "/resources/dicts",        //addUrl
                "/resources/dicts/{id}",   //modifyUrl
                "",                            //deleteUrl
                "/resources/dicts/{id}"       //deleteUniqUrl
        );
        this.idField = "code";
    }
}
