package com.yihu.ehr.apps.controller;

import com.yihu.ehr.Filter.RoleCache;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.app.AppFeatureModel;
import com.yihu.ehr.apps.model.AppFeatureTree;
import com.yihu.ehr.apps.service.AppFeatureService;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/19
 */
@Controller
@RequestMapping("/app/feature")
public class AppFeatureController extends ExtendController<AppFeatureService> {

    @Autowired
    RoleCache roleCache;

    public AppFeatureController() {
        this.init(
                "/app/platform/manager/grid",        //列表页面url
                "/app/platform/manager/dialog"       //编辑页面url
        );
    }

    private List<AppFeatureModel> search(PageParms pageParms) throws Exception {
        EnvelopExt<AppFeatureModel> envelopExt = getEnvelopExt(service.search(pageParms));
        return envelopExt.getDetailModelList();
    }

    @RequestMapping("/tree")
    @ResponseBody
    public Object tree(String appId, String appName) {

        try {
            List<AppFeatureModel> ls = search(new PageParms( "+parentId", 999, 1).addEqual("appId", appId).addNotEqual("type", "3"));
            Map<Integer, AppFeatureTree> map = new HashMap<>();
            map.put(0, new AppFeatureTree(0, appName, -1, "0", "", -1));
            for(AppFeatureModel model : ls){
                map.put(model.getId(), new AppFeatureTree(model.getId(), model.getName(), model.getParentId(), model.getType(), model.getIconUrl(), model.getLevel()) );
            }
            AppFeatureTree p;
            for(AppFeatureTree model : map.values()){
                if((p=map.get(model.getParentId()))!=null)
                    p.addChild(model);
            }

            List rs = new ArrayList<>();
            rs.add(map.get(0));
            Envelop envelop = new Envelop();
            envelop.setDetailModelList(rs);
            return toJson(envelop);
        } catch (Exception ex) {
            ex.printStackTrace();
            return systemError();
        }
    }

    @Override
    public Object afterDel(String rs, Map<String, Object> params) {
        Envelop envelop = getEnvelop(rs);
        if(envelop.isSuccessFlg()){
            Object obj = params.get("url");
            if(obj!=null){
                roleCache.removeRes(obj.toString());
            }
        }
        return super.afterDel(rs, params);
    }

    @Override
    public String afterUpdate(String rs, String id, String model, Map<String, Object> params) {
        Envelop envelop = getEnvelop(rs);
        if(envelop.isSuccessFlg()){
            if(params.get("oldUrl")!=null){
                roleCache.removeRes(params.get("oldUrl").toString());
            }

            AppFeatureModel appFeatureModel = toModel(model, AppFeatureModel.class);
            if(!StringUtils.isEmpty(appFeatureModel.getUrl())){
                roleCache.addRes(appFeatureModel.getUrl());
            }
        }
        return rs;
    }
}
