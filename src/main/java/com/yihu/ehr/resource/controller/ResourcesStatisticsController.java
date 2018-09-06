package com.yihu.ehr.resource.controller;

import com.yihu.ehr.model.common.ListResult;
import com.yihu.ehr.model.common.Result;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by wxw on 2017/9/12.
 */
@RequestMapping("/resourcesStatistics")
@Controller
//资源中心首页统计  控制入口
public class ResourcesStatisticsController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping(value = "/stasticReport/getArchiveReportInfo", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "获取健康档案图表", notes = "获取健康档案图表")
    public Result getArchiveReportInfo(String requestType) {
        String url = "/stasticReport/getArchiveReportInfo";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("requestType", requestType);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getStatisticsElectronicMedicalCount", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "电子病历-最近七天采集总数统计，门诊住院数", notes = "电子病历-最近七天采集总数统计，门诊住院数")
    public Result getStatisticsElectronicMedicalCount( ) {
        String url = "/stasticReport/getStatisticsElectronicMedicalCount";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getStatisticsMedicalEventTypeCount", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "电子病历 - 今天 门诊住院数统计", notes = "电子病历 - 今天 门诊住院数统计")
    public Result getStatisticsMedicalEventTypeCount( ) {
        String url = "/stasticReport/getStatisticsMedicalEventTypeCount";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getStatisticsDemographicsAgeCount", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "全员人口个案库 - 年龄段人数统计", notes = "全员人口个案库 - 年龄段人数统计")
    public Result getStatisticsDemographicsAgeCount( ) {
        String url = "/stasticReport/getStatisticsDemographicsAgeCount";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getStatisticsUserCards", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "获取健康卡绑定量", notes = "获取健康卡绑定量")
    public Result getStatisticsUserCards( ) {
        String url = "/tj/getStatisticsUserCards";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getStatisticsDoctorByRoleType", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "按机构医生、护士、床位的统计", notes = "按机构医生、护士、床位的统计")
    public Result getStatisticsDoctorByRoleType( ) {
        String url = "/tj/getStatisticsDoctorByRoleType";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getStatisticsCityDoctorByRoleType", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "全市医生、护士、床位的统计", notes = "全市医生、护士、床位的统计")
    public Result getStatisticsCityDoctorByRoleType( ) {
        String url = "/tj/getStatisticsCityDoctorByRoleType";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }


    @RequestMapping(value = "/stasticReport/getArchiveReportAll", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "获取一段时间内数据解析情况", notes = "获取一段时间内数据解析情况")
    public Result getArchiveReport1(String startDate,String endDate,String orgCode) {
        String url = "/stasticReport/getArchiveReportAll";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getRecieveOrgCount", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "根据接收日期统计各个医院的数据解析情况", notes = "根据接收日期统计各个医院的数据解析情况")
    public Result getRecieveOrgCount(String date) {
        String url = "/stasticReport/getRecieveOrgCount";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("date", date);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getArchivesInc", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "获取某天数据新增情况", notes = "获取某天数据新增情况")
    public Result getArchivesInc(String date, String orgCode) {
        String url = "/stasticReport/getArchivesInc";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("date", date);
            params.put("orgCode", orgCode);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getArchivesFull", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "完整性", notes = "完整性")
    public Result getArchivesFull(String startDate, String endDate, String orgCode) {
        String url = "/stasticReport/getArchivesFull";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getArchivesTime", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "及时性", notes = "及时性")
    public Result getArchivesTime(String startDate, String endDate, String orgCode) {
        String url = "/stasticReport/getArchivesTime";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getDataSetCount", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "获取数据集数量", notes = "获取数据集数量")
    public Result getDataSetCount(String date, String orgCode) {
        String url = "/stasticReport/getDataSetCount";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("date", date);
            params.put("orgCode", orgCode);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }

    @RequestMapping(value = "/stasticReport/getArchivesRight", method = RequestMethod.GET)
    @ResponseBody
    @ApiOperation(value = "准确性", notes = "准确性")
    public Result getArchivesRight(String startDate, String endDate, String orgCode) {
        String url = "/stasticReport/getArchivesRight";
        String resultStr = "";
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("orgCode", orgCode);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return toModel(resultStr, ListResult.class);
        } catch (Exception e) {
            LogService.getLogger(ResourceInterfaceController.class).error(e.getMessage());
        }
        return null;
    }
}
