package com.yihu.ehr.qcReport.controller;

import com.yihu.ehr.emergency.controller.AmbulanceController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.datetime.DateUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
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

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("nowDate", DateUtil.getNowDate(DateUtil.DEFAULT_DATE_YMD_FORMAT));
        model.addAttribute("contentPage", "/qcReport/receive/receive");
        return "pageView";
    }

    @RequestMapping(value = "/receptionList", method = RequestMethod.GET)
    @ApiOperation(value = "获取接收情况列表数据", notes = "获取接收情况列表数据")
    @ResponseBody
    public Envelop receiveList(String startDate, String endDate){
        Envelop envelop = new Envelop();
        try {
            String url = "/dataQuality/quality/receptionList";
            Map<String, Object> params = new HashMap<>();
            params.put("start", startDate);
            params.put("end", endDate);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(QcReportController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/packetNumList", method = RequestMethod.GET)
    @ApiOperation(value = "及时/完整采集的档案包数量集合", notes = "及时/完整采集的档案包数量集合")
    @ResponseBody
    public Envelop receiveList(@ApiParam(name = "orgCode", value = "机构编码", required = true)
                               @RequestParam(name = "orgCode") String orgCode,
                               @ApiParam(name = "eventDateStart", value = "就诊时间（起始），格式 yyyy-MM-dd", required = true)
                               @RequestParam(name = "eventDateStart") String eventDateStart,
                               @ApiParam(name = "eventDateEnd", value = "就诊时间（截止），格式 yyyy-MM-dd", required = true)
                               @RequestParam(name = "eventDateEnd") String eventDateEnd){
        Envelop envelop = new Envelop();
        try {
            String url = "/dataQuality/receivedPacket/packetNumList";
            Map<String, Object> params = new HashMap<>();
            params.put("type", "2");
            params.put("orgCode", orgCode);
            params.put("eventDateStart", eventDateStart);
            params.put("eventDateEnd", eventDateEnd);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(QcReportController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

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
