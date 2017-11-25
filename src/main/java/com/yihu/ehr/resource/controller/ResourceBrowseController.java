package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.agModel.dict.SystemDictEntryModel;
import com.yihu.ehr.agModel.resource.RsBrowseModel;
import com.yihu.ehr.agModel.resource.RsCategoryModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.constants.AuthorityKey;
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
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.OutputStream;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 资源浏览服务控制器
 * Created by wq on 2016/5/17.
 */
@Controller
@RequestMapping("/resourceBrowse")
public class ResourceBrowseController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Autowired
    private ResourceIntegratedController resourceIntegratedController;

    @RequestMapping("/browse")
    public String resourceBrowse(Model model) {
        model.addAttribute("contentPage", "/resource/browse/resourceView");
        return "pageView";
    }

    @RequestMapping("/browseCenter")
    public String browseCenter(Model model) {
        model.addAttribute("contentPage", "/resource/browse/resourceDataView");
        return "pageView";
    }

    @RequestMapping("/browseNewCenter")
    public String browseNewCenter(Model model) {
        model.addAttribute("contentPage", "/resource/browse/resourceNewDataView");
        return "pageView";
    }

    @RequestMapping("/customQuery")
    public String customQuery(Model model) {
        model.addAttribute("contentPage", "/resource/browse/customQuery");
        return "pageView";
    }

    @RequestMapping("/dataCenter")
    public String dataCenter(Model model) {
        model.addAttribute("contentPage", "/resource/dataCenter/dataCenter");
        return "pageView";
    }

    @RequestMapping("/customNewQuery")
    public String customNewQuery(Model model) {
        model.addAttribute("contentPage", "/resource/browse/customNewQuery");
        return "pageView";
    }

    @RequestMapping("/infoInitial")
    public String customQueryDialogView(String queryCondition, String metadatas, String type, Model model) {
        model.addAttribute("queryCondition", queryCondition);
        model.addAttribute("metadatas", metadatas);
        model.addAttribute("type", type);
        model.addAttribute("contentPage", "/resource/browse/customQueryDialogView");
        return "pageView";
    }

    @RequestMapping("/initial")
    public String resourceBrowseInitial(Model model) {
        model.addAttribute("contentPage", "/resource/resourcebrowse/resourceBrowse");
        return "pageView";
    }

    @RequestMapping("/searchResourceList")
    @ResponseBody
    public Object searchResourceList() {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/categories/all";
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping("/searchResource")
    @ResponseBody
    public Object searchResource(String ids) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/ResourceBrowses/categories";
        String resultStr = "";
        params.put("id", ids);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop.getDetailModelList();
    }

    /**
     * 动态获取GRID的列名
     * @param dictId 资源编码
     * @param request
     * @return
     */
    @RequestMapping("/getGridCloumnNames")
    @ResponseBody
    public Object getGridColumnNames(String dictId, HttpServletRequest request) {
        Envelop envelop;
        envelop = getColumns(dictId, request);
        if(envelop != null) {
            return envelop.getDetailModelList();
        }else {
            return new ArrayList<Object>();
        }
    }

    public Envelop getColumns(String resourceCode, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        String url = "/resources/ResourceBrowses/getResourceMetadata";
        String resultStr = "";
        try {
            //从Session中获取用户的角色信息作为查询参数
            boolean isAccessAll = getIsAccessAllRedis(request);
            List<String> userRoleList  = getUserRolesListRedis(request);
            if(!isAccessAll) {
                if(null == userRoleList || userRoleList.size() <= 0) {
                    envelop.setSuccessFlg(false);
                    envelop.setErrorMsg("无权访问");
                    return envelop;
                }
            }
            // 获取资源拥着信息
            String urlGet = "/resources/byCode";
            Map<String, Object> getParams = new HashMap<>();
            getParams.put("code", resourceCode);
            String result1 = HttpClientUtil.doGet(comUrl + urlGet, getParams, username, password);
            Envelop getEnvelop = objectMapper.readValue(result1, Envelop.class);
            if (!getEnvelop.isSuccessFlg()) {
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("原资源信息获取失败！");
                return envelop;
            }
            Map<String, Object> rsObj = (Map<String, Object>) getEnvelop.getObj();
            Map<String, Object> params = new HashMap<>();
            String userId = String.valueOf(request.getSession().getAttribute("userId"));
            String creator = String.valueOf(rsObj.get("creator"));
            if(isAccessAll || userId.equals(creator)) {
                params.put("roleId", "*");
            }else {
                params.put("roleId", objectMapper.writeValueAsString(userRoleList));
            }
            params.put("resourcesCode", resourceCode);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 获取字典值
     * @param dictId
     * @return
     */
    @RequestMapping("/getRsDictEntryList")
    @ResponseBody
    public Object getRsDictEntryList(String dictId) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String dictEntryUrl = "/resources/noPageDictEntries";
        params.put("filters", "dictCode=" + dictId + " g0");
        try {
            if (!StringUtils.isEmpty(dictId)) {
                resultStr = HttpClientUtil.doGet(comUrl + dictEntryUrl, params, username, password);
                return resultStr;
            }
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("字典查询失败");
        }
        return envelop;
    }

    /**
     * 档案资源浏览
     * @param resourcesCode
     * @param searchParams
     * @param page
     * @param rows
     * @param request
     * @return
     */
    @RequestMapping("/searchResourceData")
    @ResponseBody
    public Object searchResourceData(String resourcesCode, String searchParams, int page, int rows, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        String url = "/resources/ResourceBrowses/getResourceData";
        String resultStr = "";
        try {
            //从Session中获取用户的角色信息和授权视图列表作为查询参数
            List<String> userRolesList  = getUserRolesListRedis(request);
            List<String> userOrgSaasList  = getUserOrgSaasListRedis(request);
            List<String> userAreaSaasList  = getUserAreaSaasListRedis(request);
            boolean isAccessAll = getIsAccessAllRedis(request);
            if(!isAccessAll) {
                if(null == userRolesList || userRolesList.size() <= 0) {
                    envelop.setSuccessFlg(false);
                    envelop.setErrorMsg("无权访问");
                    return envelop;
                }
                if((null == userOrgSaasList || userOrgSaasList.size() <= 0) && (null == userAreaSaasList || userAreaSaasList.size() <= 0)) {
                    envelop.setSuccessFlg(false);
                    envelop.setErrorMsg("无权访问");
                    return envelop;
                }
            }
            Map<String, Object> params = new HashMap<>();
            params.put("resourcesCode", resourcesCode);
            if(isAccessAll) {
                params.put("roleId", "*");
                params.put("orgCode", "*");
                params.put("areaCode", "*");
            }else {
                // 获取资源拥着信息
                String urlGet = "/resources/byCode";
                Map<String, Object> getParams = new HashMap<>();
                getParams.put("code", resourcesCode);
                String result1 = HttpClientUtil.doGet(comUrl + urlGet, getParams, username, password);
                Envelop getEnvelop = objectMapper.readValue(result1, Envelop.class);
                if (!getEnvelop.isSuccessFlg()) {
                    envelop.setSuccessFlg(false);
                    envelop.setErrorMsg("原资源信息获取失败！");
                    return envelop;
                }
                Map<String, Object> rsObj = (Map<String, Object>) getEnvelop.getObj();
                String userId = String.valueOf(request.getSession().getAttribute("userId"));
                String creator = String.valueOf(rsObj.get("creator"));
                // 判断视图是否由用户生成
                if(userId.equals(creator)) {
                    params.put("roleId", "*");
                }else {
                    params.put("roleId", objectMapper.writeValueAsString(userRolesList));
                }
                params.put("orgCode", objectMapper.writeValueAsString(userOrgSaasList));
                params.put("areaCode", objectMapper.writeValueAsString(userAreaSaasList));
            }
            Pattern pattern = Pattern.compile("\\[.+?\\]");
            Matcher matcher = pattern.matcher(searchParams);
            if(matcher.find()) {
                if(searchParams.contains("{") || searchParams.contains("}")) {
                    params.put("queryCondition", searchParams);
                }else {
                    params.put("queryCondition", "");
                }
            }else {
                params.put("queryCondition", "");
            }
            params.put("page", page);
            params.put("size", rows);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
            List<Map<String, Object>> envelopList = envelop.getDetailModelList();
            List<Map<String, Object>> finalList = new ArrayList<Map<String, Object>>();
            if(envelop.isSuccessFlg() && envelopList != null) {
                List<Map<String, Object>> middleList = new ArrayList<>();
                for (Map<String, Object> envelopMap : envelopList) {
                    Map<String, Object> resultMap = new HashMap<String, Object>();
                    for (String key : envelopMap.keySet()) {
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
                    middleList.add(resultMap);
                }
                finalList = resourceIntegratedController.changeIdCardNo(middleList, request);
            }
            envelop.setDetailModelList(finalList);
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 指标资源检索条件获取
     * @param resourcesId
     * @return
     */
    @RequestMapping("/searchQuotaResourceParam")
    @ResponseBody
    public Envelop searchQuotaDataParam(String resourcesId) {
        Envelop envelop = new Envelop();
        try {
            String url = "/resources/ResourceBrowses/getQuotaResourceParam";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("resourcesId", resourcesId);
            String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        }catch (Exception e) {
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    /**
     * 指标资源浏览
     * @param resourcesId
     * @param searchParams
     * @param page
     * @param rows
     * @param request
     * @return
     */
    @RequestMapping("/searchQuotaResourceData")
    @ResponseBody
    public Object searchQuotaResourceData(String resourcesId, String searchParams, int page, int rows, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<>();
            String resultStr = "";
            String url = "/resources/ResourceBrowses/getQuotaResourceData";
            List<String> userOrgList  = getUserOrgSaasListRedis(request);
            params.put("userOrgList", userOrgList);
            params.put("resourcesId", resourcesId);
            if(searchParams != null) {
                if (searchParams.contains("{") || searchParams.contains("}")) {
                    params.put("queryCondition", searchParams);
                } else {
                    params.put("queryCondition", "");
                }
            }
            params.put("page", page);
            params.put("size", rows);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 档案资源数据导出
     * @param response
     * @param request
     * @param page
     * @param size
     * @param resourcesCode
     * @param searchParams
     */
    @RequestMapping("/outExcel")
    public void outExcel(HttpServletResponse response, HttpServletRequest request, String resourcesCode, String searchParams, Integer page, Integer size) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String fileName = "档案资源数据";
        String resourceCategoryName = System.currentTimeMillis() + "";
        try {
            envelop = getColumns(resourcesCode, request);
            response.setContentType("octets/stream");
            response.setHeader("Content-Disposition", "attachment; filename="
                    + new String(fileName.getBytes("gb2312"), "ISO8859-1") + resourceCategoryName + ".xls");
            OutputStream os = response.getOutputStream();
            WritableWorkbook book = Workbook.createWorkbook(os);
            WritableSheet sheet = book.createSheet(resourceCategoryName, 0);
            sheet = ResourceIntegratedController.initBaseInfo(sheet);
            for(int i = 0; i < envelop.getDetailModelList().size(); i++) {
                Map cmap = objectMapper.readValue(toJson(envelop.getDetailModelList().get(i)), Map.class);
                //new laberl（'列','行','数据'）
                sheet.addCell(new Label(0, 0, "代码"));
                sheet.addCell(new Label(0, 1, "名称"));
                sheet.addCell(new Label(i + 6, 0, String.valueOf(cmap.get("code"))));
                sheet.addCell(new Label(i + 6, 1, String.valueOf(cmap.get("value"))));
            }
            String url = "/resources/ResourceBrowses/getResourceData";
            //从Session中获取用户的角色信息和授权视图列表作为查询参数
            HttpSession session = request.getSession();
//            List<String> userRolesList = (List<String>)session.getAttribute(AuthorityKey.UserRoles);
//            List<String> userOrgSaasList = (List<String>)session.getAttribute(AuthorityKey.UserOrgSaas);
//            List<String> userAreaSaasList = (List<String>)session.getAttribute(AuthorityKey.UserAreaSaas);
            List<String> userRolesList  = getUserRolesListRedis(request);
            List<String> userOrgSaasList  = getUserOrgSaasListRedis(request);
            List<String> userAreaSaasList  = getUserAreaSaasListRedis(request);
            boolean isAccessAll = getIsAccessAllRedis(request);
            if(!isAccessAll) {
                if((null == userOrgSaasList || userOrgSaasList.size() <= 0) && (null == userAreaSaasList || userAreaSaasList.size() <= 0)) {
                    System.out.println("无权访问");
                    return;
                }
            }
            params.put("resourcesCode", resourcesCode);
            if(isAccessAll) {
                params.put("roleId", "*");
                params.put("orgCode", "*");
                params.put("areaCode", "*");
            }else {
                // 获取资源拥着信息
                String urlGet = "/resources/byCode";
                Map<String, Object> getParams = new HashMap<>();
                getParams.put("code", resourcesCode);
                String result1 = HttpClientUtil.doGet(comUrl + urlGet, getParams, username, password);
                Envelop getEnvelop = objectMapper.readValue(result1, Envelop.class);
                if (!getEnvelop.isSuccessFlg()) {
                    System.out.println("原资源信息获取失败");
                    return;
                }
                Map<String, Object> rsObj = (Map<String, Object>) getEnvelop.getObj();
                String userId = String.valueOf(request.getSession().getAttribute("userId"));
                String creator = String.valueOf(rsObj.get("creator"));
                // 判断视图是否由用户生成
                if(userId.equals(creator)) {
                    params.put("roleId", "*");
                }else {
                    params.put("roleId", objectMapper.writeValueAsString(userRolesList));
                }
                params.put("roleId", objectMapper.writeValueAsString(userRolesList));
                params.put("orgCode", objectMapper.writeValueAsString(userOrgSaasList));
                params.put("areaCode", objectMapper.writeValueAsString(userAreaSaasList));
            }
            params.put("queryCondition", searchParams);
            params.put("page", 1);
            params.put("size", 500);
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
            List<Object> objectList = envelop.getDetailModelList();
            Cell[] cells = sheet.getRow(0);
            sheet = inputData(sheet, envelop.getDetailModelList(), cells);
            sheet.mergeCells(0, 2, 0, objectList.size() + 1);
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
     * 指标资源数据导出
     * @param response
     * @param searchParams
     */
    @RequestMapping("/outQuotaExcel")
    public void outQuotaExcel(HttpServletResponse response, String resourcesId, String searchParams, HttpServletRequest request){
        Envelop envelop = new Envelop();
        String fileName = "指标资源数据";
        String resourceCategoryName = System.currentTimeMillis() + "";
        try {
            //请求数据
            String url = "/resources/ResourceBrowses/getQuotaResourceData";
            Map<String, Object> params = new HashMap<String, Object>();
            params.put("resourcesId", resourcesId);
            params.put("queryCondition", searchParams);
            List<String> userOrgList  = getUserOrgSaasListRedis(request);
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

    @RequestMapping("/searchDictEntryList")
    @ResponseBody
    public Object getDictEntryList(String dictId, String conditions) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        List<RsBrowseModel> rsBrowseModelList = new ArrayList<>();
        String resultStr = "";
        String url = "";
        try {
            if (!StringUtils.isEmpty(dictId)) {
                switch (dictId) {
                    case "34":
                        params.put("filters", "dictId=" + dictId);
                        params.put("page", 1);
                        params.put("size", 500);
                        params.put("fields", "");
                        params.put("sorts", "");
                        String con = changeConditions(conditions);
                        if (!StringUtils.isEmpty(con)) {
                            params.put("filters", "dictId=" + dictId + " g0;value=" + con + " g1");
                        }
                        url = "/dictionaries/entries";
                        resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                        break;
                    case "andOr":
                        rsBrowseModelList.add(new RsBrowseModel("AND", "并且"));
                        rsBrowseModelList.add(new RsBrowseModel("OR", "或者"));
                        envelop.setDetailModelList(rsBrowseModelList);
                        return envelop;
                    default:
                        url = "/resources/ResourceBrowses";
                        params.put("category_id", dictId);
                        resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                        break;
                }
            }
        } catch (Exception e) {

        }
        return resultStr;
    }

    @RequestMapping("/browseBefore")
    public String resourceBrowseBefore(Model model) {
        Envelop envelop = new Envelop();
        String resultStr = "";
        List<RsCategoryModel> list=new ArrayList<RsCategoryModel>();
        try {
            RsCategoryModel rsModel=new RsCategoryModel();
            rsModel.setId("0dae002159535497b3865e129433e933");
            rsModel.setName("全员人口个案库");
            list.add(rsModel);
            rsModel=new RsCategoryModel();
            rsModel.setId("0dae0021595354a8b3865e129433e934");
            rsModel.setName("医疗资源库");
            list.add(rsModel);
            rsModel=new RsCategoryModel();
            rsModel.setId("0dae0021595354c4b3865e129433e935");
            rsModel.setName("健康档案库");
            list.add(rsModel);
            rsModel=new RsCategoryModel();
            rsModel.setId("0dae0021595354cfb3865e129433e936");
            rsModel.setName("电子病历库");
            list.add(rsModel);
            rsModel=new RsCategoryModel();
            rsModel.setId("0dae0021595354d6b3865e129433e937");
            rsModel.setName("生命体征库");
            list.add(rsModel);
            envelop.setDetailModelList(list);
            envelop.setSuccessFlg(true);
            resultStr =  toJson(envelop);
            model.addAttribute("list",list);
            model.addAttribute("resultStr",resultStr);
            model.addAttribute("contentPage", "/resource/browse/resourceBrowseBefore");

            return "pageView";
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("字典查询失败");
        }
        model.addAttribute("contentPage", "/resource/browse/resourceBrowseBefore");
        return "pageView";
    }

    //获取所有平台应用下的角色组用于下拉框
    @RequestMapping("/resourceBrowseTree")
    @ResponseBody
    public Object getResourceBrowseTree(){
        try {
            String url = "/resourceBrowseTree";
            Map<String,Object> params = new HashMap<>();
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            //Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceBrowseController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    //根据视图分类的id-CategoryId获取数据集
    @RequestMapping("/getResourceByCategoryId")
    @ResponseBody
    public Object getResourceByCategoryId(String categoryId){
        try {
            String url = "/getResourceByCategoryId";
            Map<String,Object> params = new HashMap<>();
            params.put("categoryId",categoryId);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceBrowseController.class).error(ex.getMessage());
            return failed(ErrorCode.SystemError.toString());
        }
    }

    public String changeConditions(String conditions) {
        String value = "";
        if (StringUtils.isEmpty(conditions)) {
            return value;
        }
        Map<String, Object> params = new HashMap<>();
        String condition = "";
        String conditionAll = "";
        String url = "/dictionaries/entries";
        params.put("filters", "dictId=30 g0;code=" + conditions + " g1");
        params.put("page", 1);
        params.put("size", 999);
        params.put("fields", "");
        params.put("sorts", "");
        try {
            condition = HttpClientUtil.doGet(comUrl + url, params, username, password);
            params.put("filters", "dictId=34");
            conditionAll = HttpClientUtil.doGet(comUrl + url, params, username, password);
            SystemDictEntryModel systemDictEntryModel = toModel(toJson(toModel(condition, Envelop.class).getDetailModelList().get(0)), SystemDictEntryModel.class);
            List<SystemDictEntryModel> systemDictEntryModelAll = toModel(conditionAll, Envelop.class).getDetailModelList();
            String[] cs = systemDictEntryModel.getCatalog().split(",");
            for (int i = 0; i < systemDictEntryModelAll.size(); i++) {
                SystemDictEntryModel sde = toModel(toJson(systemDictEntryModelAll.get(i)), SystemDictEntryModel.class);
                if (Arrays.asList(cs).contains(sde.getCode())) {
                    value += sde.getValue() + ",";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return value;
    }

}
