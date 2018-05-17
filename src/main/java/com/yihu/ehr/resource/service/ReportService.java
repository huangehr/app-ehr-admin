package com.yihu.ehr.resource.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.report.ChartInfoModel;
import com.yihu.ehr.agModel.resource.RsReportModel;
import com.yihu.ehr.agModel.resource.RsReportViewModel;
import com.yihu.ehr.agModel.resource.RsResourcesModel;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.util.http.HttpResponse;
import com.yihu.ehr.util.http.HttpUtils;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by janseny on 2017/11/10.
 */
@Service
public class ReportService{

    @Autowired
    protected ObjectMapper objectMapper;
    @Value("${service-gateway.url}")
    private String comUrl;

    public String getHttpRespons( Map<String, Object> params,String url) throws Exception {
        String resultStr = "";
        HttpResponse response = HttpUtils.doGet(comUrl + url, params);
        if (response.isSuccessFlg()) {
            if(url.equals(ServiceApi.Resources.RsReportTemplateContent)){
                resultStr = objectMapper.readValue(response.getContent(), Envelop.class).getObj().toString();
            }else if(url.equals(ServiceApi.Resources.RsReportViews) || url.equals(ServiceApi.Resources.ResourceBrowseResourceMetadata)){
                resultStr = objectMapper.writeValueAsString(objectMapper.readValue(response.getContent(), Envelop.class).getDetailModelList());
            }else {
                resultStr = objectMapper.writeValueAsString(objectMapper.readValue(response.getContent(), Envelop.class).getObj());
            }
        }
        return resultStr;
    }

    public Object getTemplateData(String reportCode,String linkageResourceId,String linkageFilter,String linkageDimension, String limitCondition) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        Map<String, Object> resultMap = new HashMap<>();
        List<Map<String, Object>> viewInfos = new ArrayList<>();
        Map<String, String> limitMap = new HashMap();   //  存放需要限制查询条数的resourceId及限制的条数
        try {
            if (StringUtils.isNotEmpty(limitCondition)) {
                limitMap = objectMapper.readValue(limitCondition, Map.class);
            }
            // 获取图形配置
            Map<String, Object> viewInfo = new HashMap<>();
            List<Map<String, Object>> options = new ArrayList<>();
            String resourceEnvelopStr = getHttpRespons(params,ServiceApi.Resources.Resources+ "/" + linkageResourceId);
            RsResourcesModel rsResourcesModel = objectMapper.readValue(resourceEnvelopStr, RsResourcesModel.class);
            if (rsResourcesModel.getDataSource() == 1) {
                // 档案视图场合
                params.clear();
                params.put("resourceId", linkageResourceId);
                String queryEnvelopStr = getHttpRespons(params,ServiceApi.Resources.QueryByResourceId);
                String queryStr = "";
                if(StringUtils.isNotEmpty(queryEnvelopStr) && queryEnvelopStr.length()> 4){
                    objectMapper.readValue(queryEnvelopStr, Envelop.class).getObj().toString();
                }
                viewInfo.put("type", "record");
                viewInfo.put("resourceCode", rsResourcesModel.getCode());
                viewInfo.put("searchParams", queryStr);
                // 获取展示的列名
                params.clear();
                params.put("resourcesCode", rsResourcesModel.getCode());
                String rowsEnvelopStr = getHttpRespons(params,ServiceApi.Resources.ResourceBrowseResourceMetadata);
                List columns = objectMapper.readValue(rowsEnvelopStr, new TypeReference<List<String>>() {});
                viewInfo.put("columns", columns);
                viewInfos.add(viewInfo);
                resultMap.put("viewInfos", viewInfos);
            } else if (rsResourcesModel.getDataSource() == 2) {
                //指标视图 展示图形类型：data 数值, bar 柱状,line 线型, pie 饼图, twoDimensional 二维表,radar 雷达图, nestedPie 旭日图
                if(rsResourcesModel.getEchartType().contains("data") || rsResourcesModel.getEchartType().contains("twoDimensional")){
                    resultMap.put("type", "twoDimensional");
                    resultMap.put("viewInfos", getTemplateDataTable(linkageResourceId,linkageFilter, limitCondition));
                }else {
                    resultMap.put("type", "echart");
                    // 指标视图场合
                    params.clear();
                    params.put("resourceId", linkageResourceId);
                    params.put("userOrgList", "null");//权限未做控制
                    params.put("quotaFilter", linkageFilter);
                    params.put("dimension", "");
                    // 判断是否需要限制查询条数
                    if (limitMap.containsKey(linkageResourceId)) {
                        params.put("top", limitMap.get(linkageResourceId));
                    }
                    HttpResponse response = HttpUtils.doGet(comUrl + ServiceApi.Resources.GetRsQuotaPreview, params);
                    if (response.isSuccessFlg()) {
                        String chartInfoListStr = objectMapper.writeValueAsString(objectMapper.readValue(response.getContent(), Envelop.class).getObj());
                        ChartInfoModel chartInfoModel = objectMapper.readValue(chartInfoListStr,ChartInfoModel.class);
                        Map<String, Object> option = new HashMap<>();
                        option.put("resourceCode", chartInfoModel.getResourceCode());
                        option.put("resourceId", chartInfoModel.getResourceId());
                        option.put("dimensionOptions", chartInfoModel.getDimensionMap());
                        option.put("option", chartInfoModel.getOption());

                        if(StringUtils.isNotEmpty(reportCode)) {
                            // 获取报表视图
                            params.clear();
                            params.put("code", reportCode);
                            String reportEnvelopStr = getHttpRespons(params,ServiceApi.Resources.RsReportFindByCode);
                            RsReportModel rsReportModel = objectMapper.readValue(reportEnvelopStr, RsReportModel.class);
                            String position = rsReportModel.getPosition();
                            if (StringUtils.isNotEmpty(position)) {
                                Map<String, String> map = objectMapper.readValue(position, Map.class);
                                if (null != map && map.size() > 0) {
                                    for (Map.Entry<String, String> m : map.entrySet()) {
                                        if (m.getValue().equals(chartInfoModel.getResourceId())) {
                                            option.put(m.getKey(), m.getValue());
                                        }
                                    }
                                }
                            }
                        }
                        options.add(option);
                        viewInfo.put("options", options); // 视图包含的指标echart图形的option。
                        viewInfos.add(viewInfo);
                        resultMap.put("viewInfos", viewInfos);
                    }
                }
            }

            envelop.setObj(resultMap);
            envelop.setSuccessFlg(true);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setErrorMsg("报表模板获取失败");
            return envelop;
        }

    }

    public List<Map<String, Object>> getTemplateDataTable(String resourceId,String filter, String limitCondition) {
        List<Map<String, Object>> viewInfo = new ArrayList<>();
        try {
            Map<String, String> limitMap = new HashMap();   //  存放需要限制查询条数的resourceId及限制的条数
            if (StringUtils.isNotEmpty(limitCondition)) {
                limitMap = objectMapper.readValue(limitCondition, Map.class);
            }
            Map<String, Object> params = new HashMap<>();
            params.clear();
            params.put("resourceId", resourceId);
            params.put("filters", filter);
            // 判断是否需要限制查询条数
            if (limitMap.containsKey(resourceId) ){
                params.put("top", limitMap.get( resourceId ));
            }
            String rowsEnvelopStr = getHttpRespons(params,ServiceApi.TJ.GetQuotaReportTwoDimensionalTable);
            viewInfo = objectMapper.readValue(rowsEnvelopStr, new TypeReference<List<Map<String, Object>>>() {});
            return viewInfo;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 获取单个视图数据
     * @param viewCode
     * @param filter
     * @return
     */
    public Envelop getViewData(String viewCode,String filter ) {
        Envelop envelop = new Envelop();
        List<Map<String, Object>> viewInfo = new ArrayList<>();
        try {
            Map<String, Object> params = new HashMap<>();
            params.clear();
            params.put("code", viewCode);
            String resourceEnvelopStr = getHttpRespons(params, ServiceApi.Resources.ResourceByCode);
            RsResourcesModel rsResourcesModel = objectMapper.readValue(resourceEnvelopStr, RsResourcesModel.class);
            params.clear();
            params.put("resourceId", rsResourcesModel.getId());
            params.put("filters", filter);
            String rowsEnvelopStr = getHttpRespons(params,ServiceApi.TJ.GetQuotaReportTwoDimensionalTable);
            viewInfo = objectMapper.readValue(rowsEnvelopStr, new TypeReference<List<Map<String, Object>>>() {});
            envelop.setDetailModelList(viewInfo);
            envelop.setSuccessFlg(true);
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("视图数据获取失败");
            return null;
        }
        return envelop;
    }

}

