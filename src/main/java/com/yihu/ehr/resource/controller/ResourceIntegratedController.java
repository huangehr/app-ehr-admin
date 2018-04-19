package com.yihu.ehr.resource.controller;


import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.http.HttpResponse;
import com.yihu.ehr.util.http.HttpUtils;
import com.yihu.ehr.util.operator.NumberUtil;
import com.yihu.ehr.util.rest.Envelop;
import jxl.Cell;
import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

/**
 * Controller - 资源综合查询服务控制器
 * Created by Progr1mmer on 2017/08/01.
 */
@Controller
@RequestMapping("/resourceIntegrated")
public class ResourceIntegratedController extends BaseUIController {

    private static final Logger logger = LoggerFactory.getLogger(ResourceIntegratedController.class);
    private static final Integer SINGLE_REQUEST_SIZE = 5000; //导出Excel时的单次请求量
    private static final Integer SINGLE_EXCEL_SIZE = 50000; //导出Excel时的单个文件数据量

    /**
     * 综合查询档案数据列表树 zuul
     * @param filters
     * @return
     */
    @RequestMapping("/getMetadataList")
    @ResponseBody
    public Envelop getMetadataList(String filters, HttpServletRequest request) throws Exception {
        String url = "/resource/api/v1.0/resources/integrated/metadata_list";
        //从Session中获取用户的角色信息和授权视图列表作为查询参数
        List<String> userRolesList = getUserRolesListRedis(request);
        List<String> userResourceList  = getUserResourceListRedis(request);
        boolean isAccessAll = getIsAccessAllRedis(request);
        Map<String, Object> params = new HashMap<>();
        if (isAccessAll) {
            params.put("userResource", "*");
            params.put("roleId", "*");
        } else {
            params.put("userResource", objectMapper.writeValueAsString(userResourceList));
            params.put("roleId", objectMapper.writeValueAsString(userRolesList));
        }
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        HttpResponse response = HttpUtils.doGet(adminInnerUrl + url, params);
        return toModel(response.getContent(), Envelop.class);
    }

    /**
     * 综合查询档案数据检索 zuul
     * @param resourcesCode
     * @param metaData
     * @param searchParams
     * @param page
     * @param rows
     * @param request
     * @return
     */
    @RequestMapping("/searchMetadataData")
    @ResponseBody
    public Envelop searchMetadataData(String resourcesCode, String metaData, String searchParams, int page, int rows, HttpServletRequest request) throws Exception {
        Envelop envelop = new Envelop();
        String url = "/resource/api/v1.0/resources/integrated/metadata_data";
        if (resourcesCode == null || resourcesCode.equals("")) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("资源编码不能为空");
            return envelop;
        }
        //权限控制
        List<String> userOrgSaasList  = getUserOrgSaasListRedis(request);
        List<String> userAreaSaasList = getUserAreaSaasListRedis(request);
        boolean isAccessAll = getIsAccessAllRedis(request);
        if (!isAccessAll) {
            if ((null == userOrgSaasList || userOrgSaasList.size() <= 0) && (null == userAreaSaasList || userAreaSaasList.size() <= 0)) {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("无权访问");
                return envelop;
            }
        }
        Map<String, Object> params = new HashMap<>();
        params.put("resourcesCode", resourcesCode);
        params.put("metaData", metaData);
        if (isAccessAll) {
            params.put("orgCode", "*");
            params.put("areaCode", "*");
        } else {
            params.put("orgCode", objectMapper.writeValueAsString(userOrgSaasList));
            params.put("areaCode", objectMapper.writeValueAsString(userAreaSaasList));
        }
        params.put("queryCondition", searchParams);
        params.put("page", page);
        params.put("size", rows);
        HttpResponse response = HttpUtils.doGet(adminInnerUrl + url, params);
        if (response.isSuccessFlg()) {
            envelop = toModel(response.getContent(), Envelop.class);
            if (envelop.isSuccessFlg()) {
                List<Map<String, Object>> envelopList = envelop.getDetailModelList();
                List<Map<String, Object>> middleList = new ArrayList<Map<String, Object>>();
                for (Map<String, Object> envelopMap : envelopList) {
                    Map<String, Object> resultMap = new HashMap<String, Object>();
                    for (String key : envelopMap.keySet()) {
                        String value = envelopMap.get(key) == null? "" : String.valueOf(envelopMap.get(key));
                        if (key.equals("event_type")) {
                            String eventType = envelopMap.get(key).toString();
                            if (eventType.equals("0")) {
                                resultMap.put(key, "门诊");
                            } else if (eventType.equals("1")) {
                                resultMap.put(key, "住院");
                            } else if (eventType.equals("2")) {
                                resultMap.put(key, "线上");
                            }
                        } else if (value.contains("T") && value.contains("Z")) {
                            String newDateStr = value.replace("T", " ").replace("Z", "");
                            resultMap.put(key, newDateStr);
                        } else {
                            resultMap.put(key, value);
                        }
                    }
                    middleList.add(resultMap);
                }
                List<Map<String, Object>> finalList = changeIdCardNo(middleList, request);
                envelop.setDetailModelList(finalList);
                envelop.setSuccessFlg(true);
                return envelop;
            }
            return envelop;
        }
        return toModel(response.getContent(), Envelop.class);
    }

    /**
     * 综合查询指标统计列表树 zuul
     * @param filters
     * @return
     */
    @RequestMapping("/getQuotaList")
    @ResponseBody
    public Envelop getQuotaList(String filters) throws Exception {
        String url = "/resource/api/v1.0/resources/integrated/quota_list";
        Map<String, Object> params = new HashMap<>();
        params.put("filters", filters);
        HttpResponse resultStr = HttpUtils.doGet(adminInnerUrl + url, params);
        return toModel(resultStr.getContent(), Envelop.class);
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
    public Envelop searchQuotaData(String tjQuotaIds, String tjQuotaCodes, String searchParams,HttpServletRequest request) throws Exception {
        String url = "/resources/integrated/quota_data";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("quotaIds", tjQuotaIds);
        params.put("quotaCodes", tjQuotaCodes);
        params.put("queryCondition", searchParams);
        List<String> userOrgList  = getUserOrgSaasListRedis(request);
        params.put("userOrgList", userOrgList);
        String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        Envelop envelop = toModel(resultStr, Envelop.class);
        return envelop;
    }

    /**
     * 综合查询指标统计数据检索条件
     * @param tjQuotaCodes
     * @return
     */
    @RequestMapping("/searchQuotaParam")
    @ResponseBody
    public Envelop searchQuotaDataParam(String tjQuotaCodes) throws Exception {
        String url = "/resources/integrated/quota_param";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("quotaCodes", tjQuotaCodes);
        String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        Envelop envelop = toModel(resultStr, Envelop.class);
        return envelop;
    }

    /**
     * 综合查询视图保存 zuul
     * @param dataJson
     * @return
     */
    @RequestMapping(value = "/updateResource", method = RequestMethod.POST)
    @ResponseBody
    public Envelop updateResource(String dataJson, HttpServletRequest request) throws Exception {
        Map<String, Object> params = new HashMap<>();
        String url = "/resource/api/v1.0/resources/integrated/resource_update";
        HttpSession session = request.getSession();
        // 转换参数
        Map<String, Object> dataMap = objectMapper.readValue(dataJson, Map.class);
        // 获取资源字符串
        String resource = objectMapper.writeValueAsString(dataMap.get("resource"));
        // 获取资源Map映射
        Map<String, Object> rsObj = objectMapper.readValue(resource, Map.class);
        // 设置创建者
        rsObj.put("creator", session.getAttribute("userId"));
        // 更新参数
        dataMap.put("resource", rsObj);
        // 设置请求参数
        params.put("dataJson", objectMapper.writeValueAsString(dataMap));
        HttpResponse resultStr = HttpUtils.doPost(adminInnerUrl + url, params);
        Envelop envelop = toModel(resultStr.getContent(), Envelop.class);
        if (envelop.isSuccessFlg()) {
            String newRsId = (String) envelop.getObj();
            List<String> userResourceList = getUserResourceListRedis(request);
            if (userResourceList == null){
                userResourceList = new ArrayList<>();
            }
            userResourceList.add(newRsId);
            session.setAttribute(AuthorityKey.UserResource, userResourceList);
        }
        return envelop;
    }

    /**
     * 综合查询搜索条件更新 zuul
     * @param dataJson
     * @return
     */
    @RequestMapping(value = "/updateResourceQuery", method = RequestMethod.POST)
    @ResponseBody
    public Envelop updateResourceQuery(String dataJson) throws Exception {
        Map<String, Object> params = new HashMap<>();
        String url = "/resource/api/v1.0/resources/integrated/resource_query_update";
        params.put("dataJson", dataJson);
        HttpResponse resultStr = HttpUtils.doPut(adminInnerUrl + url, params);
        Envelop envelop = toModel(resultStr.getContent(), Envelop.class);
        return envelop;
    }

    /**
     *  获取视图列表（不区分数据源）
     *
     * @param page
     * @param size
     * @param request
     * @return
     */
    @RequestMapping("/getResourceList")
    @ResponseBody
    public Envelop getResourceList(int page, int size, HttpServletRequest request) throws Exception {
        String url = "/resources/page";
        //从Session中获取用户的角色和和授权视图列表作为查询参数
        HttpSession session = request.getSession();
        Map<String, Object> params = new HashMap<>();
        String userId = session.getAttribute("userId").toString();
        params.put("page", page);
        params.put("size", size);
        params.put("userId", userId);
        List<String> userResourceList = (List<String>)session.getAttribute(AuthorityKey.UserResource);
        params.put("userResource", objectMapper.writeValueAsString(userResourceList));
        String response = HttpClientUtil.doGet(comUrl + url, params, username, password);
        Envelop envelop = toModel(response, Envelop.class);
        return envelop;
    }

    /**
     * 综合查询档案数据导出
     * @param request
     * @param response
     * @param resourcesCode
     * @param searchParams
     * @param metaData
     * @param size
     * @throws Exception
     */
    @RequestMapping(value = "/outFileExcel")
    public void outExcel(HttpServletRequest request, HttpServletResponse response, String resourcesCode, String searchParams, String metaData, Integer size) throws Exception {
        //权限控制
        List<String> userOrgSaasList  = getUserOrgSaasListRedis(request);
        List<String> userAreaSaasList  = getUserAreaSaasListRedis(request);
        boolean isAccessAll = getIsAccessAllRedis(request);
        if (!isAccessAll) {
            if((null == userOrgSaasList || userOrgSaasList.size() <= 0) && (null == userAreaSaasList || userAreaSaasList.size() <= 0)) {
                logger.warn("无权访问");
                response.setStatus(403);
                return;
            }
        }
        //基本设置
        response.setContentType("application/vnd.ms-excel");
        String fileName = "综合查询档案资源数据";
        Long current = System.currentTimeMillis();
        response.setHeader("Content-Disposition", "attachment; filename="
                + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + current.toString() + ".xls");
        OutputStream os = response.getOutputStream();
        Map<String, Object> params = new HashMap<>();
        //基本参数
        String url = "/resource/api/v1.0/resources/integrated/metadata_data";
        params.put("resourcesCode", resourcesCode);
        if (isAccessAll) {
            params.put("orgCode", "*");
            params.put("areaCode", "*");
        } else {
            params.put("orgCode", objectMapper.writeValueAsString(userOrgSaasList));
            params.put("areaCode", objectMapper.writeValueAsString(userAreaSaasList));
        }
        params.put("queryCondition", searchParams);
        params.put("size", SINGLE_REQUEST_SIZE);
        if (size <= SINGLE_EXCEL_SIZE) {
            WritableWorkbook book = Workbook.createWorkbook(os);
            WritableSheet sheet = book.createSheet("page1", 0);
            //初始化表格基础数据
            sheet = initBaseInfo(sheet);
            List<Map<String, String>> metaDataSrcList = objectMapper.readValue(metaData, List.class);
            List<String> metaDataList = new ArrayList<String>();
            for(int i = 0; i < metaDataSrcList.size(); i ++) {
                Map<String, String> temp = metaDataSrcList.get(i);
                sheet.addCell(new Label(i + 6, 0, String.valueOf(temp.get("code"))));
                sheet.addCell(new Label(i + 6, 1, String.valueOf(temp.get("name"))));
                metaDataList.add(String.valueOf(temp.get("code")));
            }
            params.put("metaData", objectMapper.writeValueAsString(metaDataList));
            //循环获取数据
            int totalPage;
            if (size % SINGLE_REQUEST_SIZE > 0) {
                totalPage = size / SINGLE_REQUEST_SIZE + 1;
            } else {
                totalPage = size / SINGLE_REQUEST_SIZE;
            }
            for (int page = 1; page <= totalPage; page ++) {
                params.put("page", page);
                HttpResponse httpResponse = HttpUtils.doGet(adminInnerUrl + url, params);
                Envelop envelop = toModel(httpResponse.getContent(), Envelop.class);
                List<Object> dataList = envelop.getDetailModelList();
                Cell[] cells = sheet.getRow(0);
                //填充数据
                sheet = inputData(sheet, dataList, cells, sheet.getRows());
            }
            sheet.mergeCells(0, 2, 0, sheet.getRows() - 1);
            sheet.addCell(new Label(0, 2, "值"));
            sheet.removeRow(0);
            book.write();
            book.close();
        } else {
            int fileCount;
            if (size % SINGLE_EXCEL_SIZE > 0) {
                fileCount = size / SINGLE_EXCEL_SIZE + 1;
            } else {
                fileCount = size / SINGLE_EXCEL_SIZE;
            }
            int totalPage;
            if (size % SINGLE_REQUEST_SIZE > 0) {
                totalPage = size / SINGLE_REQUEST_SIZE + 1;
            } else {
                totalPage = size / SINGLE_REQUEST_SIZE;
            }
            WritableWorkbook book = Workbook.createWorkbook(os);
            for (int fileIndex = 1; fileIndex <= fileCount; fileIndex ++) {
                WritableSheet sheet = book.createSheet("page" + fileIndex, fileIndex - 1);
                //初始化表格基础数据
                sheet = initBaseInfo(sheet);
                List<Map<String, String>> metaDataSrcList = objectMapper.readValue(metaData, List.class);
                List<String> metaDataList = new ArrayList<String>();
                for (int i = 0; i < metaDataSrcList.size(); i++) {
                    Map<String, String> temp = metaDataSrcList.get(i);
                    sheet.addCell(new Label(i + 6, 0, String.valueOf(temp.get("code"))));
                    sheet.addCell(new Label(i + 6, 1, String.valueOf(temp.get("name"))));
                    metaDataList.add(String.valueOf(temp.get("code")));
                }
                params.put("metaData", objectMapper.writeValueAsString(metaDataList));
                //循环获取数据
                int currentPage = (fileIndex - 1) * (SINGLE_EXCEL_SIZE / SINGLE_REQUEST_SIZE) + 1;
                int cycPage;
                if (fileIndex == fileCount) {
                    int beforePage = (fileIndex - 1) * (SINGLE_EXCEL_SIZE / SINGLE_REQUEST_SIZE);
                    int lastPage = totalPage - beforePage;
                    cycPage = beforePage + lastPage;
                } else {
                    cycPage = fileIndex * (SINGLE_EXCEL_SIZE / SINGLE_REQUEST_SIZE);
                }
                for (int page = currentPage; page <= cycPage; page ++) {
                    params.put("page", page);
                    String httpResponse = HttpClientUtil.doGet(adminInnerUrl + url, params);
                    Envelop envelop = toModel(httpResponse, Envelop.class);
                    List<Object> dataList = envelop.getDetailModelList();
                    Cell[] cells = sheet.getRow(0);
                    //填充数据
                    sheet = inputData(sheet, dataList, cells, sheet.getRows());
                }
                sheet.mergeCells(0, 2, 0, sheet.getRows() - 1);
                sheet.addCell(new Label(0, 2, "值"));
                sheet.removeRow(0);
            }
            book.write();
            book.close();
        }
        os.flush();
        os.close();
    }

    /**
     * 综合查询指标数据导出
     * @param response
     * @param tjQuotaIds
     * @param tjQuotaCodes
     * @param searchParams
     */
    @RequestMapping("/outQuotaExcel")
    public void outQuotaExcel(HttpServletResponse response, HttpServletRequest request, String tjQuotaIds, String tjQuotaCodes, String searchParams) throws Exception {
        //基本设置
        response.setContentType("application/vnd.ms-excel");
        String fileName = "综合查询指标资源数据";
        Long current = System.currentTimeMillis();
        response.setHeader("Content-Disposition", "attachment; filename="
                + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + current.toString() + ".xls");
        OutputStream os = response.getOutputStream();
        //请求数据
        String url = "/resources/integrated/quota_data";
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("quotaIds", tjQuotaIds);
        params.put("quotaCodes", tjQuotaCodes);
        params.put("queryCondition", searchParams);
        List<String> userOrgList  = getUserOrgSaasListRedis(request);
        params.put("userOrgList", userOrgList);
        String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        Envelop envelop = toModel(resultStr, Envelop.class);
        //处理Excel
        WritableWorkbook book = Workbook.createWorkbook(os);
        WritableSheet sheet = book.createSheet("page1", 0);
        sheet.addCell(new Label(0, 0, "代码"));
        sheet.addCell(new Label(0, 1, "名称"));
        List<Map<String, String>> objList = (List<Map<String, String>>)envelop.getObj();
        for(int i = 0; i< objList.size(); i ++) {
            Map<String, String> objMap = objList.get(i);
            sheet.addCell(new Label(i + 1, 0, String.valueOf(objMap.get("key"))));
            sheet.addCell(new Label(i + 1, 1, String.valueOf(objMap.get("name"))));
        }
        Cell [] cells = sheet.getRow(0);
        sheet = inputData(sheet, envelop.getDetailModelList(), cells, sheet.getRows());
        sheet.mergeCells(0, 2, 0, sheet.getRows() - 1);
        sheet.addCell(new Label(0, 2, "值"));
        sheet.removeRow(0);
        book.write();
        book.close();
        os.flush();
        os.close();

    }

    /**
     * 综合查询档案数据已选数据导出
     * @param response
     * @param selectData
     * @param metaData
     */
    @RequestMapping(value = "/outSelectExcel", method = RequestMethod.GET)
    public void outSelectExcel(HttpServletResponse response, String selectData, String metaData) throws Exception {
        //基本设置
        response.setContentType("application/vnd.ms-excel");
        String fileName = "综合查询档案数据资源已选数据";
        Long current = System.currentTimeMillis();
        response.setHeader("Content-Disposition", "attachment; filename="
                + new String(fileName.getBytes("gb2312"), "ISO8859-1") + current.toString() + ".xls");
        OutputStream os = response.getOutputStream();
        WritableWorkbook book = Workbook.createWorkbook(os);
        WritableSheet sheet = book.createSheet("page1", 0);
        //初始化基础数据
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
        sheet = inputData(sheet, selectDataList, cells, sheet.getRows());
        sheet.mergeCells(0, 2, 0, sheet.getRows() - 1);
        sheet.addCell(new Label(0, 2, "值"));
        book.write();
        book.close();
        os.flush();
        os.close();

    }

    /**
     * 档案数据基础信息初始化
     * @param sheet
     * @return
     * @throws Exception
     */
    public static WritableSheet initBaseInfo(WritableSheet sheet) throws Exception{
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
    public WritableSheet inputData(WritableSheet sheet, List<Object> dataList, Cell[] cells, int rowNum) throws Exception{
        for (int i = 0; i < dataList.size(); i++) {
            Map<String, String> map = toModel(toJson(dataList.get(i)), Map.class);
            for (String key : map.keySet()) {
                for (Cell cell : cells) {
                    if (cell.getContents().equals(key)) {
                        sheet.addCell(new Label(cell.getColumn(), i + rowNum, String.valueOf(map.get(key))));
                    }
                }
            }
        }
        return sheet;
    }

    public List<Map<String, Object>> changeIdCardNo(List<Map<String, Object>> resultList, HttpServletRequest request) throws Exception {
        List<Map<String, Object>> finalList = new ArrayList<Map<String, Object>>();
        boolean flag = false;
        Map<String, Object> params = new HashMap<>();
        UsersModel userDetailModel = getCurrentUserRedis(request);
        params.put("userId", StringUtils.isEmpty(userDetailModel) ? "" : userDetailModel.getId());
        String result = HttpClientUtil.doGet(comUrl + "/roles/role_feature/hasPermission", params, username, password);
        if ("true".equals(result)) {
            flag = true;
        }
        if (!flag) {
            //没有权限，对身份证号进行部分*展示
            for (Map<String, Object> map : resultList) {
                if (!StringUtils.isEmpty(map.get("demographic_id"))) {
                    map.put("demographic_id", NumberUtil.changeIdCardNo(map.get("demographic_id").toString()));
                }
                //身份证件号码
                if (!StringUtils.isEmpty(map.get("EHR_000017"))) {
                    map.put("EHR_000017", NumberUtil.changeIdCardNo(map.get("EHR_000017").toString()));
                }
                //户主证件号码
                if (!StringUtils.isEmpty(map.get("EHR_000027"))) {
                    map.put("EHR_000027", NumberUtil.changeIdCardNo(map.get("EHR_000027").toString()));
                }
                //医疗保险号
                if (!StringUtils.isEmpty(map.get("EHR_000232"))) {
                    map.put("EHR_000232", NumberUtil.changeIdCardNo(map.get("EHR_000232").toString()));
                }
                //身份证件号码（体检）
                if (!StringUtils.isEmpty(map.get("EHR_000776"))) {
                    map.put("EHR_000776", NumberUtil.changeIdCardNo(map.get("EHR_000776").toString()));
                }
                //母亲身份证件号码
                if (!StringUtils.isEmpty(map.get("EHR_001264"))) {
                    map.put("EHR_001264", NumberUtil.changeIdCardNo(map.get("EHR_001264").toString()));
                }
                //父亲身份证件号码
                if (!StringUtils.isEmpty(map.get("EHR_001266"))) {
                    map.put("EHR_001266", NumberUtil.changeIdCardNo(map.get("EHR_001266").toString()));
                }
                finalList.add(map);
            }
        } else {
            finalList.addAll(resultList);
        }
        return finalList;
    }

    /**
     * 新建查询
     *
     * @throws IOException
     */
    @RequestMapping("/goAddQueryPage")
    public String browseCenter(Model model) {
        model.addAttribute("contentPage", "/resource/browse/addQuery");
        return "pageView";
    }
}
