package com.yihu.ehr.resource.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.agModel.resource.RsMetadataModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.resource.service.MetaService;
import com.yihu.ehr.util.Envelop;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/19
 */
@Controller
@RequestMapping("/resource/meta")
public class MetaController extends ExtendController<MetaService> {

    public MetaController() {
        this.init(
                "/resource/meta/grid",        //列表页面url
                "/resource/meta/dialog"      //编辑页面url
        );
        comboKv = new HashMap<>();
        comboKv.put("code", "id");
        comboKv.put("value", "name");
        comboKv.put("domainName", "domainName");
        comboKv.put("domain", "domain");
    }

}
