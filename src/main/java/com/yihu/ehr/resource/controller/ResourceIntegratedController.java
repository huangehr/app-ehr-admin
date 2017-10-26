package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.constants.AuthorityKey;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.operator.NumberUtil;
import com.yihu.ehr.util.rest.Envelop;
import jxl.Cell;
import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.OutputStream;
import java.util.*;

/**
 * 资源综合查询服务控制器
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
    public Envelop getMetadataList(String filters, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        String url = "/resources/integrated/metadata_list";
        String resultStr = "";
        //从Session中获取用户的角色信息和授权视图列表作为查询参数
        HttpSession session = request.getSession();
        boolean isAccessAll = (boolean)session.getAttribute(AuthorityKey.IsAccessAll);
        List<String> userRolesList = (List<String>)session.getAttribute(AuthorityKey.UserRoles);
        List<String> userResourceList = (List<String>)session.getAttribute(AuthorityKey.UserResource);
        if(!isAccessAll) {
            if(null == userResourceList || userResourceList.size() <= 0) {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("无权访问！");
                return envelop;
            }
            if(null == userRolesList || userRolesList.size() <= 0) {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("无权访问！");
                return envelop;
            }
        }
        try {
            Map<String, Object> params = new HashMap<>();
            if(isAccessAll) {
                params.put("userResource", "*");
                params.put("roleId", "*");
            }else {
                params.put("userResource", objectMapper.writeValueAsString(userResourceList));
                params.put("roleId", objectMapper.writeValueAsString(userRolesList));
            }
            if (!StringUtils.isEmpty(filters)) {
                params.put("filters", filters);
            }
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 综合查询档案数据检索
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
    public Envelop searchMetadataData(String resourcesCode, String metaData, String searchParams, int page, int rows, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        String url = "/resources/integrated/metadata_data";
        String resultStr = "";
        if(resourcesCode == null || resourcesCode.equals("")) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("资源编码不能为空");
            return envelop;
        }
        //权限控制
        HttpSession session = request.getSession();
        List<String> userOrgSaasList = (List<String>)session.getAttribute(AuthorityKey.UserOrgSaas);
        List<String> userAreaSaasList = (List<String>)session.getAttribute(AuthorityKey.UserAreaSaas);
        boolean isAccessAll = (boolean)session.getAttribute(AuthorityKey.IsAccessAll);
        if(!isAccessAll) {
            if((null == userOrgSaasList || userOrgSaasList.size() <= 0) && (null == userAreaSaasList || userAreaSaasList.size() <= 0)) {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("无权访问");
                return envelop;
            }
        }
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("resourcesCode", resourcesCode);
            params.put("metaData", metaData);
            if(isAccessAll) {
                params.put("orgCode", "*");
                params.put("areaCode", "*");
            }else {
                params.put("orgCode", objectMapper.writeValueAsString(userOrgSaasList));
                params.put("areaCode", objectMapper.writeValueAsString(userAreaSaasList));
            }
            params.put("queryCondition", searchParams);
            params.put("page", page);
            params.put("size", rows);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
            List<Map<String, Object>> envelopList = envelop.getDetailModelList();
            List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
            for(Map<String, Object> envelopMap : envelopList) {
                Map<String, Object> resultMap = new HashMap<String, Object>();
                for(String key : envelopMap.keySet()) {
                    String value = envelopMap.get(key).toString();
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
                resultList.add(resultMap);
            }
            List<Map<String, Object>> listMap = changeIdCardNo(resultList, request);
            envelop.setDetailModelList(listMap);
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
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
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
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
    public Envelop searchQuotaData(String tjQuotaIds, String tjQuotaCodes, String searchParams,HttpServletRequest request) {
        Envelop envelop = new Envelop();
        try {
            String url = "/resources/integrated/quota_data";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("quotaIds", tjQuotaIds);
            params.put("quotaCodes", tjQuotaCodes);
            params.put("queryCondition", searchParams);
            List<String> userOrgList  = (List<String>)request.getSession().getAttribute(AuthorityKey.UserOrgSaas);
            params.put("userOrgList", userOrgList);
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        }catch (Exception e) {
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    /**
     * 综合查询指标统计数据检索条件
     * @param tjQuotaCodes
     * @return
     */
    @RequestMapping("/searchQuotaParam")
    @ResponseBody
    public Envelop searchQuotaDataParam(String tjQuotaCodes) {
        Envelop envelop = new Envelop();
        try {
            String url = "/resources/integrated/quota_param";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("quotaCodes", tjQuotaCodes);
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        }catch (Exception e) {
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
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
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    /**
     * 综合查询搜索条件更新
     * @param dataJson
     * @return
     */
    @RequestMapping(value = "/updateResourceQuery", method = RequestMethod.POST)
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
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
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
     * @param searchParams
     */
    @RequestMapping("/outQuotaExcel")
    public void outQuotaExcel(HttpServletResponse response, String tjQuotaIds, String tjQuotaCodes, String searchParams,
    HttpServletRequest request){
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
            List<String> userOrgList  = (List<String>)request.getSession().getAttribute(AuthorityKey.UserOrgSaas);
            params.put("userOrgList", userOrgList);
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
            List<Map<String, String>> objList = (List<Map<String, String>>)envelop.getObj();
            for(int i = 0; i< objList.size(); i ++) {
                Map<String, String> objMap = objList.get(i);
                sheet.addCell(new Label(i + 1, 0, String.valueOf(objMap.get("key"))));
                sheet.addCell(new Label(i + 1, 1, String.valueOf(objMap.get("name"))));
            }
            Cell [] cells = sheet.getRow(0);
            sheet = inputData(sheet, envelop.getDetailModelList(), cells);
            sheet.mergeCells(0, 2, 0, envelop.getDetailModelList().size() + 1);
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

    public List<Map<String, Object>> changeIdCardNo(List<Map<String, Object>> resultList, HttpServletRequest request) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        boolean flag = false;
        try {
            Map<String, Object> params = new HashMap<>();
            UserDetailModel userDetailModel = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
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
                    listMap.add(map);
                }
            } else {
                listMap.addAll(resultList);
            }
            return listMap;
        } catch (Exception e) {
            listMap.addAll(resultList);
            return listMap;
        }
    }
}
