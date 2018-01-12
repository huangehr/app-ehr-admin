package com.yihu.ehr.report;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.report.MQcDailyReportResultDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import jxl.Workbook;
import jxl.format.CellFormat;
import jxl.write.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by llh on 2017/5/9.
 */
@Controller
@RequestMapping("/report")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class ReportController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    /**
     * 趋势分析页
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/report/trendAnalysis");
        return "pageView";
    }

    /**
     * 趋势分析页(对外）
     * @param model
     * @return
     */
    @RequestMapping("outInitial")
    public String initialOut(Model model) {
        model.addAttribute("thirdParty", "true");
        model.addAttribute("contentPage", "/report/trendAnalysis");
        return "generalView";
    }

    /**
     * 趋势分析详情页
     * @param model
     * @return
     */
    @RequestMapping("trendAnalysisDetail")
    public String trendAnalysisDetail(Model model,String location,String orgCode,String orgName,String quotaId,String startTime,String endTime) {
        model.addAttribute("location",location);
        model.addAttribute("orgCode",orgCode);
        model.addAttribute("orgName",orgName);
        model.addAttribute("quotaId",quotaId);
        model.addAttribute("startTime",startTime);
        model.addAttribute("endTime",endTime);
        model.addAttribute("contentPage", "/report/trendAnalysisDetail");
        return "pageView";
    }

    /**
     * 采集状况页
     * @param model
     * @return
     */
    @RequestMapping("acquisitionConditionSign")
    public String acquisitionConditionSign(Model model) {
        model.addAttribute("contentPage", "/report/acquisitionConditionSign");
        return "emptyView";
    }

    /**
     * 分析列表页面
     * @param model
     * @return
     */
    @RequestMapping("analysisList")
    public String addResources(Model model,String location,String orgName,String startTime,String endTime) {
        model.addAttribute("location",location);
        model.addAttribute("orgName",orgName);
        model.addAttribute("startTime",startTime);
        model.addAttribute("endTime",endTime);
        model.addAttribute("contentPage", "/report/analysisList");
        return "emptyView";
    }

    /**
     * 分析列表页面
     * @param model
     * @return
     */
    @RequestMapping("outAnalysisList")
    public String outAnalysisList(Model model,String location,String orgName,String startTime,String endTime) {
        model.addAttribute("location",location);
        model.addAttribute("orgName",orgName);
        model.addAttribute("startTime",startTime);
        model.addAttribute("endTime",endTime);
        model.addAttribute("thirdParty", "true");
        model.addAttribute("contentPage", "/report/analysisList");
        return "generalView";
    }
    
    //所有指标统计结果查询,初始化查询
    @RequestMapping("/getQcOverAllIntegrity")
    @ResponseBody
    public Object searchQcOverAllIntegrity(String location,String startTime,String endTime){
        String url = "/report/getQcOverAllIntegrity";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("location", location);
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(ReportController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    //根据机构查询所有指标统计结果,初始化查询
    @RequestMapping("/getQcOverAllOrgIntegrity")
    @ResponseBody
    public Object searchQcOverAllOrgIntegrity(String location,String orgCode,String startTime,String endTime){
        String url = "/report/getQcOverAllOrgIntegrity";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("location", location);
        params.put("orgCode", orgCode);
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(ReportController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    //趋势分析 - 按区域列表查询,初始化查询
    @RequestMapping("/getQcQuotaIntegrity")
    @ResponseBody
    public Object searchQcQuotaIntegrity(String location,String quotaId,String startTime,String endTime){
        String url = "/report/getQcQuotaIntegrity";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("location", location);
        params.put("quotaId", quotaId);
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(ReportController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }
    //趋势分析 -按机构列表查询,初始化查询
    @RequestMapping("/getQcQuotaOrgIntegrity")
    @ResponseBody
    public Object searchQcQuotaOrgIntegrity(String orgCode,String quotaId,String startTime,String endTime){
        String url = "/report/getQcQuotaOrgIntegrity";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("orgCode", orgCode);
        params.put("quotaId", quotaId);
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(ReportController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    //分析明细列表
    @RequestMapping("/getQcQuotaDailyIntegrity")
    @ResponseBody
    public Object searchQcQuotaDailyIntegrity(String location,String startTime,String endTime){
        String url = "/report/getQcQuotaDailyIntegrity";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("location", location);
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(ReportController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    //根据地区、期间查询各机构某项指标的值
    @RequestMapping("/getQcQuotaByLocation")
    @ResponseBody
    public Object searchQcQuotaByLocation(String location,String quotaId,String startTime,String endTime){
        String url = "/report/getQcQuotaByLocation";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("location", location);
        params.put("quotaId", quotaId);
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(ReportController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    //根据地区、期间查询分析明细列表，并导出
    @RequestMapping("/exportToExcel")
    //@ResponseBody
    public void exportToExcel(HttpServletResponse response,String location,String startTime,String endTime){
        Envelop envelop = new Envelop();
        try {
            String fileName = "分析列表明细";
            String url="";
            String envelopStr = "";
            //设置下载
            response.setContentType("octets/stream");
            response.setHeader("Content-Disposition", "attachment; filename="
                    + new String( fileName.getBytes("gb2312"), "ISO8859-1" )+".xls");
            OutputStream os = response.getOutputStream();
            //获取导出字典
            Map<String,Object> params = new HashMap<>();
            url = "/report/getQcQuotaDailyIntegrity";
            params.put("location",location);
            params.put("startTime",startTime);
            params.put("endTime",endTime);
            envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop qcEnvelop = getEnvelop(envelopStr);

            List<MQcDailyReportResultDetailModel> qcModelList = (List<MQcDailyReportResultDetailModel>)getEnvelopList(qcEnvelop.getDetailModelList(),new ArrayList<MQcDailyReportResultDetailModel>(),MQcDailyReportResultDetailModel.class) ;
            //写excel
            WritableWorkbook wwb = Workbook.createWorkbook(os);
            //创建Excel工作表 指定名称和位置
            WritableSheet ws = wwb.createSheet("质控分析明细",0);
            addStaticCell(ws);//添加固定信息，题头等
            //添加字典项信息
            WritableCellFormat wc = new WritableCellFormat();
            wc.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN, Colour.SKY_BLUE);//边框
            MQcDailyReportResultDetailModel qc=null;
            for(int i=0;i<qcModelList.size();i++) {
                int j=i+1;
                qc = (MQcDailyReportResultDetailModel)qcModelList.get(i);
                //添加列表明细
                addCell(ws,0,j,qc.getEventTime(),wc);//时间
                addCell(ws,1,j,qc.getOrgName(),wc);//机构名称
                addCell(ws,2,j,qc.getScaleType(),wc);//比例名称
                addCell(ws,3,j,qc.getArIntegrity(),wc);//整体数量完整性
                addCell(ws,4,j,qc.getDsIntegrity(),wc);//数据集完整性
                addCell(ws,5,j,qc.getMdIntegrity(),wc);//数据元完整性
                addCell(ws,6,j,qc.getMdAccuracy(),wc);//准确性
                addCell(ws,7,j,qc.getArTimely(),wc);//全部及时性
                addCell(ws,8,j,qc.getHpTimely(),wc);//住院病人及时性
                addCell(ws,9,j,qc.getOpTimely(),wc);//门诊病人及时性

            }
            //写入工作表
            wwb.write();
            wwb.close();
            os.flush();
            os.close();
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
    }

    //excel中添加固定内容
    private void addStaticCell(WritableSheet ws){
        try {
            addCell(ws,0,0,"时间");
            addCell(ws,1,0,"对象");
            addCell(ws,2,0," ");
            addCell(ws,3,0,"整体数量完整性");
            addCell(ws,4,0,"数据集完整性");
            addCell(ws,5,0,"数据元完整性");
            addCell(ws,6,0,"准确性");
            addCell(ws,7,0,"全部及时性");
            addCell(ws,8,0,"住院病人及时性");
            addCell(ws,9,0,"门诊病人及时性");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //添加单元格内容
    private void addCell(WritableSheet ws,int column,int row,String data){
        try {
            Label label = new Label(column,row,data);
            ws.addCell(label);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //添加单元格内容带样式
    private void addCell(WritableSheet ws,int column,int row,String data,CellFormat cellFormat){
        try {
            Label label = new Label(column,row,data,cellFormat);
            ws.addCell(label);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }



    /**
     * 临时页
     * @param model
     * @return
     */
    @RequestMapping("initialLs")
    public String initialLs(Model model) {
        model.addAttribute("contentPage", "/report/ls/orgAnalysisList");
        return "generalView";
    }

    /**
     * 档案入库状况数据
     * @param model
     * @return
     */
    @RequestMapping("rukuData")
    @ResponseBody
    public Object rukuData(Model model,String orgCode,String startDate,String endDate) {
        String url = "/report/qcDailyStatisticsStorageByDate";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();
        Envelop result = new Envelop();
        try {
            params.put("orgCode",orgCode);
            params.put("startDate",startDate);
            params.put("endDate",endDate);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            ObjectMapper mapper = new ObjectMapper();
            Envelop envelop = mapper.readValue(resultStr, Envelop.class);
            if (!envelop.isSuccessFlg()) {
                result.setSuccessFlg(true);
                result.setDetailModelList(envelop.getDetailModelList());
                result.setObj(envelop.getObj());
                return result;
            } else {
                result.setSuccessFlg(false);
                return result;
            }
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }


}
