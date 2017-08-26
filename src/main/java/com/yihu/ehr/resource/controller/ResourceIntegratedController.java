package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import jxl.Cell;
import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.util.*;

/**
 * 资源综合查询数据服务控制器
 * Created by Sxy on 2017/08/01.
 */
@Controller
@RequestMapping("/resourceIntegrated")
public class ResourceIntegratedController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    private ObjectMapper objectMapper;

    /**
     * 综合查询档案数据列表树
     * @param filters
     * @return
     */
    @RequestMapping("/getMetadataList")
    @ResponseBody
    public Envelop getMetadataList(String filters) {
        Envelop envelop = new Envelop();
        String url = "/resources/integrated/metadata_list";
        Map<String, Object> params = new HashMap<>();
        params.put("filters", filters);
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("综合查询档案数据列表树获取失败");
        }
        return envelop;
    }

    /**
     * 综合查询档案数据检索
     * @param resourcesCode ["code1","code2"]
     * @param metaData ["EHR_000006","EHR_000004"]
     * @param searchParams [{"andOr":"OR","condition":"=","field":"event_no","value":"1002281201"},{"andOr":"OR","condition":"=","field":"event_no","value":"1002281203"}]
     * @param page
     * @param rows
     * @param request
     * @return
     */
    @RequestMapping("/searchMetadataData")
    @ResponseBody
    public Envelop searchMetadataData(String resourcesCode, String metaData, String searchParams, int page, int rows, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        if(resourcesCode == null || resourcesCode.equals("")) {
            return envelop;
        }
        String url = "/resources/integrated/metadata_data";
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        //当前用户机构
        UserDetailModel userDetailModel = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        params.put("resourcesCode", resourcesCode);
        params.put("metaData", metaData);
        //（获取用户机构代码）待确认
        String orgCode = userDetailModel.getOrganization();
        if(orgCode != null) {
            params.put("orgCode", userDetailModel.getOrganization());
        }
        //暂未进行控制
        params.put("appId", "JKZL");
        params.put("queryCondition", searchParams);
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("综合查询档案数据检索失败");
        }
        return envelop;
    }

    /**
     * 综合查询指标统计列表树
     * @param filters
     * @return
     */
    @RequestMapping("/getQuotaList")
    @ResponseBody
    public Envelop getQuotaList(String filters) {
        Envelop envelop = new Envelop();
        String url = "/resources/integrated/quota_list";
        Map<String, Object> params = new HashMap<>();
        params.put("filters", filters);
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("综合查询指标统计列表树获取失败");
        }
        return envelop;
    }

    /**
     * 综合查询指标统计数据检索
     * @param tjQuotaIds
     * @param tjQuotaCodes
     * @param searchParams
     * @return
     */
    @RequestMapping("/searchQuotaData")
    @ResponseBody
    public Envelop searchQuotaData(String tjQuotaIds, String tjQuotaCodes, String searchParams) {
        Envelop envelop = new Envelop();
        try {
            String url = "/resources/integrated/quota_data";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("quotaIds", tjQuotaIds);
            params.put("quotaCodes", tjQuotaCodes);
            params.put("queryCondition", searchParams);
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        }catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("综合查询指标数据检索失败");
        }
        return envelop;
    }

    /**
     * 综合查询视图保存
     * @param dataJson
     * @return
     */
    @RequestMapping(value = "/updateResource", method = RequestMethod.POST)
    @ResponseBody
    public Envelop updateResource(String dataJson) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/integrated/resource_update";
        params.put("dataJson", dataJson);
        try {
            String resultStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("综合查询视图保存失败");
        }
        return envelop;
    }

    /**
     * 综合查询搜索条件更新
     * @param dataJson
     * @return
     */
    @RequestMapping(value = "/updateResourceQuery", method = RequestMethod.PUT)
    @ResponseBody
    public Envelop updateResourceQuery(String dataJson){
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/integrated/resource_query_update";
        params.put("dataJson", dataJson);
        try {
            String resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            //LogService.getLogger(ResourceIntegratedController.class).error(e.getMessage());
            //envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("综合查询搜索条件更新失败");
        }
        return envelop;
    }

    /**
     * 综合查询档案数据导出
     * @param request
     * @param response
     * @param size
     * @param resourcesCode
     * @param searchParams
     * @param metaData
     */
    @RequestMapping(value = "/outFileExcel")
    public void outExcel(HttpServletRequest request, HttpServletResponse response, Integer size, String resourcesCode, String searchParams, String metaData) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String fileName = "综合查询档案数据";
        String resourceCategoryName = System.currentTimeMillis() + "";
        try {
            response.setContentType("octets/stream");
            response.setHeader("Content-Disposition", "attachment; filename="
                    + new String(fileName.getBytes("gb2312"), "ISO8859-1") + resourceCategoryName + ".xls");
            OutputStream os = response.getOutputStream();
            WritableWorkbook book = Workbook.createWorkbook(os);
            WritableSheet sheet = book.createSheet(resourceCategoryName, 0);
            /**
             * 初始化基础数据
             */
            sheet = initBaseInfo(sheet);
            List<Map<String, String>> metaDataSrcList = objectMapper.readValue(metaData, List.class);
            List<String> metaDataList = new ArrayList<String>();
            for(int i = 0; i < metaDataSrcList.size(); i ++) {
                Map<String, String> temp = metaDataSrcList.get(i);
                sheet.addCell(new Label(i + 6, 0, String.valueOf(temp.get("code"))));
                sheet.addCell(new Label(i + 6, 1, String.valueOf(temp.get("name"))));
                metaDataList.add(String.valueOf(temp.get("code")));
            }
            String url = "/resources/integrated/metadata_data";
            //当前用户机构
            UserDetailModel userDetailModel = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
            params.put("resourcesCode", resourcesCode);
            params.put("metaData", objectMapper.writeValueAsString(metaDataList));
            /**
             * 待确认
             */
            String orgCode = userDetailModel.getOrganization();
            if(orgCode != null) {
                params.put("orgCode", userDetailModel.getOrganization());
            }
            /**
             * 暂未进行控制
             */
            params.put("appId", "JKZL");
            params.put("queryCondition", searchParams);
            params.put("page", 1);
            params.put("size", size);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
            List<Object> dataList = envelop.getDetailModelList();
            Cell[] cells = sheet.getRow(0);
            /**
             * 填充数据
             */
            sheet = inputData(sheet, dataList, cells);
            sheet.mergeCells(0, 2, 0, dataList.size() + 1);
            sheet.addCell(new Label(0, 2, "值"));
            book.write();
            book.close();
            os.flush();
            os.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 综合查询指标数据导出
     * @param response
     * @param tjQuotaIds
     * @param tjQuotaCodes
     * @param tiQuotaNames
     * @param searchParams
     */
    @RequestMapping("/outQuotaExcel")
    public void outQuotaExcel(HttpServletResponse response, String tjQuotaIds, String tjQuotaCodes, String tiQuotaNames, String searchParams){
        Envelop envelop = new Envelop();
        String fileName = "综合查询指标数据";
        String resourceCategoryName = System.currentTimeMillis() + "";
        try {
            //请求数据
            String url = "/resources/integrated/quota_data";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("quotaIds", tjQuotaIds);
            params.put("quotaCodes", tjQuotaCodes);
            params.put("queryCondition", searchParams);
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
            //处理Excel
            response.setContentType("octets/stream");
            response.setHeader("Content-Disposition", "attachment; filename="
                    + new String(fileName.getBytes("gb2312"), "ISO8859-1") + resourceCategoryName + ".xls");
            OutputStream os = response.getOutputStream();
            WritableWorkbook book = Workbook.createWorkbook(os);
            WritableSheet sheet = book.createSheet(resourceCategoryName, 0);
            sheet.addCell(new Label(0, 0, "代码"));
            sheet.addCell(new Label(0, 1, "名称"));
            String [] tjQuotaCodesArr = tjQuotaCodes.split(",");
            String [] tiQuotaNamesArr = tiQuotaNames.split(",");
            int pos = 0;
            List<Map<String, String>> objList = (List<Map<String, String>>)envelop.getObj();
            for(int i = 0; i< objList.size(); i ++) {
                Map<String, String> objMap = objList.get(i);
                sheet.addCell(new Label(i + 1, 0, String.valueOf(objMap.get("key"))));
                sheet.addCell(new Label(i + 1, 1, String.valueOf(objMap.get("name"))));
                pos = i + 1;
            }
            for(int j = 0; j < tjQuotaCodesArr.length; j ++) {
                sheet.addCell(new Label(pos + 1 + j, 0, String.valueOf(tjQuotaCodesArr[j])));
                sheet.addCell(new Label( pos + 1 + j, 1, String.valueOf(tiQuotaNamesArr[j])));
            }
            List<Map<String, String>> dataList = envelop.getDetailModelList();
            //处理结果集合
            List<Object> parseList = new ArrayList<Object>();
            for(Map<String, String> tempMap : dataList) {
                Map<String, String> parseMap = new HashMap<String, String>();
                for(String key : tempMap.keySet()) {
                    if(key.equals("value")) {
                        String values = tempMap.get(key);
                        String [] valuesArr = values.split(",");
                        for(int j = 0; j < tjQuotaCodesArr.length; j ++) {
                            parseMap.put(tjQuotaCodesArr[j], valuesArr[j]);
                        }
                    }else {
                        parseMap.put(key, tempMap.get(key));
                    }
                }
                parseList.add(parseMap);
            }
            Cell [] cells = sheet.getRow(0);
            sheet = inputData(sheet, parseList, cells);
            sheet.mergeCells(0, 2, 0, dataList.size() + 1);
            sheet.addCell(new Label(0, 2, "值"));
            book.write();
            book.close();
            os.flush();
            os.close();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 综合查询档案数据已选数据导出
     * @param response
     * @param selectData
     * @param metaData
     */
    @RequestMapping(value = "/outSelectExcel", method = RequestMethod.GET)
    public void outSelectExcel(HttpServletResponse response, String selectData, String metaData) {
        Envelop envelop = new Envelop();
        String fileName = "综合查询档案数据已选数据";
        String resourceCategoryName = System.currentTimeMillis() + "";
        try {
            response.setContentType("octets/stream");
            response.setHeader("Content-Disposition", "attachment; filename="
                    + new String(fileName.getBytes("gb2312"), "ISO8859-1") + resourceCategoryName + ".xls");
            OutputStream os = response.getOutputStream();
            WritableWorkbook book = Workbook.createWorkbook(os);
            WritableSheet sheet = book.createSheet(resourceCategoryName, 0);
            /**
             * 初始化基础数据
             */
            sheet = initBaseInfo(sheet);
            List<Map<String, String>> metaDataSrcList = objectMapper.readValue(metaData, List.class);
            for(int i = 0; i < metaDataSrcList.size(); i ++) {
                Map<String, String> temp = metaDataSrcList.get(i);
                sheet.addCell(new Label(i + 6, 0, String.valueOf(temp.get("code"))));
                sheet.addCell(new Label(i + 6, 1, String.valueOf(temp.get("name"))));
            }
            List<Object> selectDataList = objectMapper.readValue(selectData, List.class);
            Cell[] cells = sheet.getRow(0);
            /**
             * 填充数据
             */
            sheet = inputData(sheet, selectDataList, cells);
            sheet.mergeCells(0, 2, 0, selectDataList.size() + 1);
            sheet.addCell(new Label(0, 2, "值"));
            book.write();
            book.close();
            os.flush();
            os.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 档案数据基础信息初始化
     * @param sheet
     * @return
     * @throws Exception
     */
    public WritableSheet initBaseInfo(WritableSheet sheet) throws Exception{
        sheet.addCell(new Label(0, 0, "代码"));
        sheet.addCell(new Label(0, 1, "名称"));
        sheet.addCell(new Label(1, 0, "event_date"));
        sheet.addCell(new Label(1, 1, "时间"));
        sheet.addCell(new Label(2, 0, "org_name"));
        sheet.addCell(new Label(2, 1, "机构名称"));
        sheet.addCell(new Label(3, 0, "org_code"));
        sheet.addCell(new Label(3, 1, "机构编号"));
        sheet.addCell(new Label(4, 0, "patient_name"));
        sheet.addCell(new Label(4, 1, "病人姓名"));
        sheet.addCell(new Label(5, 0, "demographic_id"));
        sheet.addCell(new Label(5, 1, "病人身份证号码"));
        return sheet;
    }

    /**
     * 填充数据
     * @param sheet
     * @param dataList
     * @param cells
     * @return
     * @throws Exception
     */
    public WritableSheet inputData(WritableSheet sheet, List<Object> dataList, Cell[] cells) throws Exception{
        for (int i = 0; i < dataList.size(); i++) {
            Map<String, String> map = toModel(toJson(dataList.get(i)), Map.class);
            for (String key : map.keySet()) {
                for (Cell cell : cells) {
                    if (cell.getContents().equals(key)) {
                        sheet.addCell(new Label(cell.getColumn(), i + 2, String.valueOf(map.get(key))));
                    }
                }
            }
        }
        return sheet;
    }

}
