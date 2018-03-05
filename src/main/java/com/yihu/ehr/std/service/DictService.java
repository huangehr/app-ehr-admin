package com.yihu.ehr.std.service;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.model.standard.MStdDict;
import org.springframework.stereotype.Service;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/3/19
 */
@Service
public class DictService extends ExtendService<MStdDict> {

    public DictService() {
        init(
                "/dicts",        //searchUrl
                "/save_dict",   //modelUrl
                "/adapter/dict/entry",        //addUrl
                "/dict",        //modifyUrl
                "/dict"        //deleteUrl
        );
    }

}
