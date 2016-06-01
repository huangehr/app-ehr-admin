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
                "/resources/dict",        //searchUrl
                "/resources/dict/{id}",   //modelUrl
                "/resources/dict",        //addUrl
                "/resources/dict/{id}",   //modifyUrl
                "",                            //deleteUrl
                "/resources/dict/{id}"       //deleteUniqUrl
        );
        existenceUrl = "/resources/dict/existence"; //存在
        this.idField = "code";
    }
}
