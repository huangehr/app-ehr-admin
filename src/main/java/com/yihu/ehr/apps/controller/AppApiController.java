package com.yihu.ehr.apps.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.app.AppApiModel;
import com.yihu.ehr.apps.model.AppFeatureTree;
import com.yihu.ehr.apps.service.AppApiService;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
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
@RequestMapping("/app/api")
public class AppApiController extends ExtendController<AppApiService> {

    public AppApiController() {
        this.init(
                "/app/platform/api/grid",        //列表页面url
                "/app/platform/api/dialog"       //编辑页面url
        );
    }

    private List<AppApiModel> search(PageParms pageParms) throws Exception {
        EnvelopExt<AppApiModel> envelopExt = getEnvelopExt(service.search(pageParms));
        return envelopExt.getDetailModelList();
    }

    @RequestMapping("/edit")
    public String gotoEdit(Model model, AppApiModel apiModel, String mode){

        try {
            model.addAttribute("paramTypes", service.searchSysDictEntries(47));
            model.addAttribute("dataTypes", service.searchSysDictEntries(48));
            model.addAttribute("requiredTypes", service.searchSysDictEntries(49));

            model.addAttribute("mode", mode);
            model.addAttribute("model", toJson(apiModel));
            model.addAttribute("contentPage", "/app/platform/api/edit");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "pageView";
    }

    @RequestMapping("/tree")
    @ResponseBody
    public Object tree(String appId, String appName) {

        List<AppApiModel> ls;

        try {
            if(StringUtils.isEmpty(appId)){
                ls  = search(new PageParms( "+parentId", 999, 1).addNotEqual("type", "1"));
            }else{
                ls = search(new PageParms( "+parentId", 999, 1).addNotEqual("type", "1").addEqual("appId",appId));
            }

            Map<Integer, AppFeatureTree> map = new HashMap<>();
            map.put(0, new AppFeatureTree(0, "全部应用", "", -1, "-1", ""));
            for(AppApiModel model : ls){
                map.put(model.getId(), new AppFeatureTree(
                        model.getId(), model.getName(), model.getDescription(), model.getParentId(), model.getType(), model.getAppId()) );
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
}
