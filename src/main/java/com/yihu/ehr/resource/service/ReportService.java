package com.yihu.ehr.resource.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
//import com.yihu.ehr.agModel.report.ChartInfoModel;
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
import java.io.IOException;
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
        return null;

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

