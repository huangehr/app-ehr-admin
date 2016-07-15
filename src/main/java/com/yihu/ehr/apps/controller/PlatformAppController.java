package com.yihu.ehr.apps.controller;

import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.agModel.app.AppDetailModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.apps.service.PlatformAppService;
import com.yihu.ehr.constants.SessionAttributeKeys;
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
                UserDetailModel userDetailModel = (UserDetailModel)request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
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
}
