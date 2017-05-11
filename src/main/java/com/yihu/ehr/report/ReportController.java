package com.yihu.ehr.report;

import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.controller.BaseUIController;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

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
    public String patientInitial(Model model) {
        model.addAttribute("contentPage", "/report/trendAnalysis");
        return "pageView";
    }

    /**
     * 分析列表页面
     * @param model
     * @return
     */
    @RequestMapping("analysisList")
    public String addResources(Model model) {
        model.addAttribute("contentPage", "/report/analysisList");
        return "pageView";
    }
    
    @RequestMapping("analysisListData")
    @ResponseBody
    public Object searchPatient(int page, int rows) {
            String resultStr = "{\"successFlg\":true,\"pageSize\":15,\"currPage\":1,\"totalPage\":2,\"totalCount\":19,\"detailModelList\":[{\"RowId\":\"1\",\"Date\":\"4月1日\",\"Hospital\":\"海沧医院\",\"bizhi\":\"总体\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"2\",\"Date\":\"4月1日\",\"Hospital\":\"海沧医院\",\"bizhi\":\"同比\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"3\",\"Date\":\"4月1日\",\"Hospital\":\"海沧医院\",\"bizhi\":\"环比\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"4\",\"Date\":\"4月1日\",\"Hospital\":\"长庚医院\",\"bizhi\":\"总体\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"5\",\"Date\":\"4月1日\",\"Hospital\":\"长庚医院\",\"bizhi\":\"同比\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"6\",\"Date\":\"4月1日\",\"Hospital\":\"长庚医院\",\"bizhi\":\"环比\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"7\",\"Date\":\"4月2日\",\"Hospital\":\"海沧医院\",\"bizhi\":\"总体\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"8\",\"Date\":\"4月2日\",\"Hospital\":\"海沧医院\",\"bizhi\":\"同比\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"9\",\"Date\":\"4月2日\",\"Hospital\":\"海沧医院\",\"bizhi\":\"环比\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"10\",\"Date\":\"4月2日\",\"Hospital\":\"长庚医院\",\"bizhi\":\"总体\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"11\",\"Date\":\"4月2日\",\"Hospital\":\"长庚医院\",\"bizhi\":\"同比\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"},{\"RowId\":\"12\",\"Date\":\"4月2日\",\"Hospital\":\"长庚医院\",\"bizhi\":\"环比\",\"OverallQuantity\":\"50%\",\"DataSet\":\"50%\",\"DataElement\":\"50%\",\"Accuracy\":\"50%\",\"AllTimeliness\":\"50%\",\"InpatientTimeliness\":\"50%\",\"OutpatientTimeliness\":\"50%\"}],\"obj\":null,\"errorMsg\":null,\"errorCode\":0}";
            return resultStr;
    }



}
