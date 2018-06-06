package com.yihu.ehr.qcReport.controller;

import com.yihu.ehr.emergency.controller.AmbulanceController;
import com.yihu.ehr.model.common.ListResult;
import com.yihu.ehr.model.common.Result;
import com.yihu.ehr.resource.controller.ResourceInterfaceController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import io.swagger.annotations.ApiOperation;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: zhengwei
 * @Date: 2018/6/6 9:06
 * @Description: 质控报表
 */
@RequestMapping("/qcReport")
@Controller
public class QcReportController extends BaseUIController {

    @RequestMapping(value = "/dailyReport", method = RequestMethod.GET)
    @ApiOperation(value = "获取医院数据", notes = "获取医院数据")
    @ResponseBody
    public Envelop dailyReport(String startDate, String endDate, String orgCode) {
        Envelop envelop = new Envelop();
        try {
            String url = "/packQcReport/dailyReport";
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(AmbulanceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }
}
