package com.yihu.ehr.qcReport.controller;

import com.alibaba.fastjson.JSONObject;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.datetime.DateUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.word.ExportUtil;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

    private String packAnalyzerUrl = "/pack-analyzer/api/v1.0";

    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("nowDate", DateUtil.getNowDate(DateUtil.DEFAULT_DATE_YMD_FORMAT));
        model.addAttribute("contentPage", "/qcReport/receive/receive");
        return "pageView";
    }

    @RequestMapping("initReceiveDetail")
    public String initReceiveDetail(Model model,String orgCode, String orgName,String visitIntime,
                 String visitIntegrity,String totalVisit,String visitIntimeRate,String visitIntegrityRate,String startDate,String endDate) {
        JSONObject json = new JSONObject();
        json.put("orgCode", orgCode);
        json.put("orgName", orgName);
        json.put("visitIntime", visitIntime);
        json.put("visitIntegrity", visitIntegrity);
        json.put("totalVisit", totalVisit);
        json.put("visitIntimeRate", visitIntimeRate+"%");
        json.put("visitIntegrityRate", visitIntegrityRate+"%");
        json.put("startDate", startDate);
        json.put("endDate", endDate);
        model.addAttribute("receiveDetail", json);
        model.addAttribute("contentPage", "/qcReport/receive/infoDialog");
        return "pageView";
    }

    @RequestMapping("detail")
    public String patientInitial(Model model) {
        model.addAttribute("contentPage", "/qcReport/qcReportDetail");
        return "pageView";
    }

    @RequestMapping(value = "/receptionList", method = RequestMethod.GET)
    @ApiOperation(value = "获取接收情况列表数据", notes = "获取接收情况列表数据")
    @ResponseBody
    public Envelop receiveList(String startDate, String endDate){
        Envelop envelop = new Envelop();
        try {
            String url = packAnalyzerUrl+"/dataQuality/quality/receptionList";
            Map<String, Object> params = new HashMap<>();
            params.put("start", startDate);
            params.put("end", endDate);
            String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(QcReportController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping("index")
    public String index(HttpServletRequest request, HttpServletResponse response) {
        String context = "<html>\n" +
                "  <head>\n" +
                "    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\n" +
                "  </head>\n" +
                "  <body style=\"width: 500px;font-size: 15px;margin:0 auto;\">\n" +
                "  <div id=\"head\" style=\"margin-top: 10px;\">\n" +
                "    <div id=\"title\" style=\"text-align: center;font-size: 30px;font-weight: 700;\">{搜索条件时间范围}接收数据报告</div>\n" +
                "    <div id=\"author\">\n" +
                "        <div id=\"calTime\" style=\"margin-left: 250px;\">统计时间:{报告生成时间}</div>\n" +
                "        <div id=\"reportTime\" style=\"margin-left: 250px;\">报告时间:</div>\n" +
                "        <div id=\"reporter\" style=\"margin-left: 250px;\">报告人: {账号名称}</div>\n" +
                "    </div>\n" +
                "    <div id=\"total\" style=\"margin-top: 10px;\">\n" +
                "        <div id=\"receiveTotal\" style=\"font-size: 20px;font-weight: 700; \">接收总量:{统计所选机构的总量（选择了医疗云平台的除外）}</div>\n" +
                "        <div id=\"successAnalyze\" style=\"font-size: 20px;font-weight: 700; \">成功解析:{统计所选机构的解析成功总量（选择了医疗云平台的除外）}</div>\n" +
                "    </div>\n" +
                "  </div>\n" +
                "  <div id=\"hospitals\" style=\"margin-top: 10px;\">\n" +
                "    <div id=\"hospital\">\n" +
                "        <div id=\"org\" style=\"font-size: 25px;font-weight: 700;margin-bottom: 10px;\">1.医院名称(机构编码)</div>\n" +
                "        <div id=\"receiveDetail\">\n" +
                "            <div id=\"title2\" style=\"font-size: 18px;font-weight: 700;line-height: 40px;\">1.数据接收情况</div>\n" +
                "            <div id=\"hospitalData\">\n" +
                "                <div id=\"title3\" style=\"\">1.1医院上报及采集情况</div>\n" +
                "                  <table width=\"100%\" border=\"1\" bordercolor=\"black\" cellspacing=\"0px\">\n" +
                "                    <tr style=\"\">\n" +
                "                      <td style=\"width: 20%;\">环节</td>\n" +
                "                      <td style=\"width: 20%;\">门诊档案数</td>\n" +
                "                      <td style=\"width: 20%;\">住院档案数</td>\n" +
                "                      <td style=\"width: 20%;\">体检档案数</td>\n" +
                "                      <td style=\"width: 20%;\">总计</td>\n" +
                "                    </tr>\n" +
                "                    <tr>\n" +
                "                      <td style=\"width: 20%;\">1000</td>\n" +
                "                      <td style=\"width: 20%;\">1000</td>\n" +
                "                      <td style=\"width: 20%;\">1000</td>\n" +
                "                      <td style=\"width: 20%;\">1000</td>\n" +
                "                      <td style=\"width: 20%;\">1000</td>\n" +
                "                    </tr>\n" +
                "                  </table>\n" +
                "            </div>\n" +
                "            <div id=\"collection\">\n" +
                "                <br>\n" +
                "                <div id=\"title3\" style=\"\">1.2采集内容</div>\n" +
                "                 <table width=\"100%\" border=\"1\" bordercolor=\"black\" cellspacing=\"0px\" >\n" +
                "                    <tr style=\"\">\n" +
                "                      <td style=\"width: 20%;\">日期</td>\n" +
                "                      <td style=\"width: 20%;\">门诊档案数</td>\n" +
                "                      <td style=\"width: 20%;\">住院档案数</td>\n" +
                "                      <td style=\"width: 20%;\">体检档案数</td>\n" +
                "                      <td style=\"width: 20%;\">总计</td>\n" +
                "                    </tr>\n" +
                "                    <tr>\n" +
                "                      <td style=\"width: 20%;\">2016-01-01</td>\n" +
                "                      <td style=\"width: 20%;\">1000</td>\n" +
                "                      <td style=\"width: 20%;\">1000</td>\n" +
                "                      <td style=\"width: 20%;\">1000</td>\n" +
                "                      <td style=\"width: 20%;\">1000</td>\n" +
                "                    </tr>\n" +
                "                  </table>\n" +
                "            </div>\n" +
                "        </div>\n" +
                "        <div id=\"analyzeDetail\">\n" +
                "            <br>\n" +
                "            <div id=\"title2\" style=\"font-size: 18px;font-weight: 700;line-height: 40px;\">2.数据解析情况{解析状态（正在解析中、已解析完毕，根据是否还有未解析判断）}</div>\n" +
                "                <table width=\"100%\" border=\"1\" bordercolor=\"black\" cellspacing=\"0px\" >\n" +
                "                  <tr style=\"\">\n" +
                "                    <td style=\"width: 25%;\">接收总量</td>\n" +
                "                    <td style=\"width: 25%;\">解析成功</td>\n" +
                "                    <td style=\"width: 25%;\">解析失败</td>\n" +
                "                    <td style=\"width: 25%;\">未解析</td>\n" +
                "                  </tr>\n" +
                "                  <tr>\n" +
                "                    <td style=\"width: 25%;\">1000</td>\n" +
                "                    <td style=\"width: 25%;\">1000</td>\n" +
                "                    <td style=\"width: 25%;\">1000</td>\n" +
                "                    <td style=\"width: 25%;\">1000</td>\n" +
                "                  </tr>\n" +
                "                </table>\n" +
                "        </div>\n" +
                "        <div id=\"datasetTotal\">\n" +
                "            <br>\n" +
                "            <div id=\"title2\" style=\"font-size: 18px;font-weight: 700;line-height: 40px;\">3.数据集总量{解析状态（正在解析中、已解析完毕，根据是否还有未解析判断）}</div>\n" +
                "                <table width=\"100%\" border=\"1\" bordercolor=\"black\" cellspacing=\"0px\" >\n" +
                "                  <tr style=\"\">\n" +
                "                    <td style=\"width: 25%;\">数据集编码</td>\n" +
                "                    <td style=\"width: 25%;\">数据集名称</td>\n" +
                "                    <td style=\"width: 25%;\">总数</td>\n" +
                "                    <td style=\"width: 25%;\">行数</td>\n" +
                "                  </tr>\n" +
                "                  <tr>\n" +
                "                    <td style=\"width: 25%;\">1000</td>\n" +
                "                    <td style=\"width: 25%;\">1000</td>\n" +
                "                    <td style=\"width: 25%;\">1000</td>\n" +
                "                    <td style=\"width: 25%;\">1000</td>\n" +
                "                  </tr>\n" +
                "                </table>\n" +
                "        </div>\n" +
                "        <div id=\"analysis\">\n" +
                "            <br>\n" +
                "            <div id=\"title2\" style=\"font-size: 18px;font-weight: 700;line-height: 40px;\">4.分析</div>\n" +
                "            <div id=\"title3\" style=\"\">4.1解析失败分析</div>\n" +
                "            <table width=\"100%\" border=\"1\" bordercolor=\"black\" cellspacing=\"0px\" >\n" +
                "                  <tr style=\"\">\n" +
                "                    <td style=\"width: 50%;\">错误原因</td>\n" +
                "                    <td style=\"width: 50%;\">数量</td>\n" +
                "                  </tr>\n" +
                "                  <tr>\n" +
                "                    <td style=\"width: 50%;\">1000</td>\n" +
                "                    <td style=\"width: 50%;\">1000</td>\n" +
                "                  </tr>\n" +
                "                </table>\n" +
                "        </div>\n" +
                "    </div>\n" +
                "  </div>\n" +
                "  </body>\n" +
                "</html>\n";

//        ExportUtil.exportWord(request, response, context);

        ExportUtil.test(request, response);
        return "index";
    }

    @RequestMapping(value = "/packetNumList", method = RequestMethod.GET)
    @ApiOperation(value = "及时/完整采集的档案包数量集合", notes = "及时/完整采集的档案包数量集合")
    @ResponseBody
    public Envelop receiveList(@ApiParam(name = "orgCode", value = "机构编码", required = true)
                               @RequestParam(name = "orgCode") String orgCode,
                               @ApiParam(name = "page", value = "第几页", required = true)
                               @RequestParam(name = "page") Integer page,
                               @ApiParam(name = "rows", value = "每页数", required = true)
                               @RequestParam(name = "rows") Integer rows,
                               @ApiParam(name = "eventDateStart", value = "就诊时间（起始），格式 yyyy-MM-dd", required = true)
                               @RequestParam(name = "eventDateStart") String eventDateStart,
                               @ApiParam(name = "eventDateEnd", value = "就诊时间（截止），格式 yyyy-MM-dd", required = true)
                               @RequestParam(name = "eventDateEnd") String eventDateEnd){
        Envelop envelop = new Envelop();
        try {
            String url = packAnalyzerUrl+"/dataQuality/receivedPacket/packetNumList";
            Map<String, Object> params = new HashMap<>();
            params.put("type", "2");
            params.put("pageIndex", page);
            params.put("pageSize", rows);
            params.put("orgCode", orgCode);
            params.put("eventDateStart", eventDateStart);
            params.put("eventDateEnd", eventDateEnd);
            String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
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
            String url = packAnalyzerUrl+"/packQcReport/dailyReport";
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(QcReportController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/datasetWarningList", method = RequestMethod.GET)
    @ApiOperation(value = "预警数据集列表", notes = "预警数据集列表")
    @ResponseBody
    public Envelop datasetWarningList(String orgCode, String type, int page, int rows) {
        Envelop envelop = new Envelop();
        try {
            String url = "/pack-analyzer/api/v1.0/packQcReport/datasetWarningList";
            Map<String, Object> params = new HashMap<>();
            params.put("orgCode", orgCode);
            params.put("type", type);
            params.put("page", page);
            params.put("size", rows);
            String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(QcReportController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/resourceSuccessfulCount", method = RequestMethod.GET)
    @ApiOperation(value = "资源化成功的计数统计")
    @ResponseBody
    public Envelop resourceSuccessfulCount(
            @ApiParam(name = "startDate", value = "开始日期")
            @RequestParam(name = "startDate") String startDate,
            @ApiParam(name = "endDate", value = "结束日期")
            @RequestParam(name = "endDate") String endDate,
            @ApiParam(name = "orgCode", value = "医院代码")
            @RequestParam(name = "orgCode", required = false) String orgCode){
        Envelop envelop = new Envelop();
        try {
            String url = "/pack-analyzer/api/v1.0/packQcReport/resourceSuccessfulCount";
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(QcReportController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/archiveReport", method = RequestMethod.GET)
    @ApiOperation(value = "获取接收档案数据")
    @ResponseBody
    public Envelop archiveReport(
            @ApiParam(name = "startDate", value = "开始日期")
            @RequestParam(name = "startDate") String startDate,
            @ApiParam(name = "endDate", value = "结束日期")
            @RequestParam(name = "endDate") String endDate,
            @ApiParam(name = "orgCode", value = "医院代码")
            @RequestParam(name = "orgCode", required = false) String orgCode) {
        Envelop envelop = new Envelop();
        try {
            String url = "/pack-analyzer/api/v1.0/packQcReport/archiveReport";
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(QcReportController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/dataSetList", method = RequestMethod.GET)
    @ApiOperation(value = "获取接收数据集列表")
    @ResponseBody
    public Envelop dataSetList(
            @ApiParam(name = "startDate", value = "开始日期")
            @RequestParam(name = "startDate") String startDate,
            @ApiParam(name = "endDate", value = "结束日期")
            @RequestParam(name = "endDate") String endDate,
            @ApiParam(name = "orgCode", value = "医院代码")
            @RequestParam(name = "orgCode", required = false) String orgCode) {
        Envelop envelop = new Envelop();
        try {
            String url = "/pack-analyzer/api/v1.0/packQcReport/dataSetList";
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(QcReportController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/archiveFailed", method = RequestMethod.GET)
    @ApiOperation(value = "获取资源化解析失败")
    @ResponseBody
    public Envelop archiveFailed(
            @ApiParam(name = "startDate", value = "开始日期")
            @RequestParam(name = "startDate") String startDate,
            @ApiParam(name = "endDate", value = "结束日期")
            @RequestParam(name = "endDate") String endDate,
            @ApiParam(name = "orgCode", value = "医院代码")
            @RequestParam(name = "orgCode", required = false) String orgCode) {
        Envelop envelop = new Envelop();
        try {
            String url = "/pack-analyzer/api/v1.0/packQcReport/archiveFailed";
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(QcReportController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/metadataError", method = RequestMethod.GET)
    @ApiOperation(value = "获取解析异常")
    @ResponseBody
    public Envelop metadataError(
            @ApiParam(name = "step", value = "异常环节")
            @RequestParam(name = "step") String step,
            @ApiParam(name = "startDate", value = "开始日期")
            @RequestParam(name = "startDate") String startDate,
            @ApiParam(name = "endDate", value = "结束日期")
            @RequestParam(name = "endDate") String endDate,
            @ApiParam(name = "orgCode", value = "医院代码")
            @RequestParam(name = "orgCode", required = false) String orgCode) {
        Envelop envelop = new Envelop();
        try {
            String url = "/pack-analyzer/api/v1.0/packQcReport/metadataError";
            Map<String, Object> params = new HashMap<>();
            params.put("step", step);
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            String envelopStr = HttpClientUtil.doGet(adminInnerUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(QcReportController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }
}
