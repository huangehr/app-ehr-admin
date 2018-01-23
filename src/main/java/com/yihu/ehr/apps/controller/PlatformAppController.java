package com.yihu.ehr.apps.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.agModel.app.AppDetailModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.apps.service.PlatformAppService;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/19
 */
@Controller
@RequestMapping("/app/platform")
public class PlatformAppController extends ExtendController<PlatformAppService> {

    public PlatformAppController() {
        this.init(
                "/app/platform/grid",        //列表页面url
                "/app/platform/dialog"         //编辑页面url
        );
    }


    @RequestMapping("/modify")
    @ResponseBody
    public Object update(AppDetailModel appDetailModel, HttpServletRequest request){

        try {
            Map<String, Object> params = new HashMap<>();
            String resultStr = "";
            if(StringUtils.isEmpty(appDetailModel.getId())){
                UsersModel userDetailModel = getCurrentUserRedis(request);
                appDetailModel.setCreator(userDetailModel.getId());
                appDetailModel.setStatus("'Approved'");
                appDetailModel.setSourceType(1);
                params.put("app", toJson(appDetailModel));
                resultStr = service.add(params);
            }
            else{
                params.put("app", toJson(appDetailModel));
                resultStr = service.update(params);
            }
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @RequestMapping("/exsit/apiMan")
    @ResponseBody
    public Object existApiOrMan(String id){

        try {

            Map<String, Object> params = new HashMap<>();
            params.put("filters", "appId="+ id);
            Envelop envelop = getEnvelop(service.doGet(service.comUrl + "/filterFeatureList", params));
            Envelop en = getEnvelop(service.doGet(service.comUrl + "/appApiNoPage", params));

            if(envelop.isSuccessFlg() && en.isSuccessFlg()){
                int i = (Boolean) envelop.getObj()? 1 : 2;
                int j = en.getDetailModelList().size()>0? 3 : 4;
                switch (i*j){
                    case 3: return faild("该应用已存在api以及模块管理，请先删除api及模块管理信息！");
                    case 4: return faild("该应用已存在模块管理，请先删除模块管理信息！");
                    case 6: return faild("该应用已存在api管理，请先删除api管理信息！");
                    case 8: return success(true);
                    default: return faild("验证出错！");
                }
            }
            return faild("获取验证信息出错！");
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }
}
