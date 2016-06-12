package com.yihu.ehr.resource.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.resource.service.DictService;
import com.yihu.ehr.util.Envelop;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/20
 */
@Controller("resource-dict")
@RequestMapping("/resource/dict")
public class DictController extends ExtendController<DictService> {

    public DictController() {
        this.init(
                "/resource/dict/grid",        //列表页面url
                "/resource/dict/dialog"      //编辑页面url
        );
        comboKv.put("code", "code");
    }

    @Override
    public Map beforeGotoModify(Map params) {
        try {
            params.put("id", URLEncoder.encode(String.valueOf(params.get("id")), "UTF-8"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return params;
    }

    @RequestMapping("/searchCombo")
    @ResponseBody
    public Object comboSearch(String searchParm, int page, int rows){

        try{
            PageParms pageParms = new PageParms(rows, page)
                    .addGroupNotNull("code", PageParms.LIKE, searchParm, "g1")
                    .addGroupNotNull("name", PageParms.LIKE, searchParm, "g1");

            Envelop envelop = getEnvelop(service.search(pageParms));
            List rs = new ArrayList<>();
            Map<String, String> combo;
            if(envelop.isSuccessFlg())
                for(Map<String, String> map: (List<Map<String, String>>) envelop.getDetailModelList()){
                    combo = new HashMap<>();
                    combo.put("id", map.get("code"));
                    combo.put("name", map.get("name"));
                    rs.add(combo);
                }
            envelop.setDetailModelList(rs);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }
}
