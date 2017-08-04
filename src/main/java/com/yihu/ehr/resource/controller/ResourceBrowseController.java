package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.dict.SystemDictEntryModel;
import com.yihu.ehr.agModel.resource.RsBrowseModel;
import com.yihu.ehr.agModel.resource.RsCategoryModel;
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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
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

    @RequestMapping("/searchResourceList")
    @ResponseBody
    public Object searchResourceList() {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/categories";
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {

        }
        return envelop;
    }

    @RequestMapping("/searchCustomizeResourceList")
    @ResponseBody
    public Object searchCustomizeResourceList() {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/customize_list";
        String resultStr = "";
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {

        }
        return envelop;
    }

    @RequestMapping("/searchCustomizeResourceData")
    @ResponseBody
    public Object searchCustomizeResourceData(String resourcesCode, String metaData, String searchParams, int page, int rows, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String url = "/resources/customize_data";
        //当前用户机构
        UserDetailModel userDetailModel = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        params.put("resourcesCode", resourcesCode);
        params.put("metaData", metaData);
        params.put("orgCode", userDetailModel.getOrganization());
        /**
         * 暂未进行控制
         */
        params.put("appId", "JKZL");
        params.put("queryCondition", searchParams);
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("数据检索失败");
        }
        return envelop;
    }

    @RequestMapping("/initial")
    public String resourceBrowseInitial(Model model) {
        model.addAttribute("contentPage", "/resource/resourcebrowse/resourceBrowse");
        return "pageView";
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

        }
        return envelop.getDetailModelList();
    }

    @RequestMapping("/searchResourceData")
    @ResponseBody
    public Object searchResourceData(String resourcesCode, String searchParams, int page, int rows, HttpServletRequest request) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String url = "/resources/ResourceBrowses/getResourceData";
        //当前用户机构
        UserDetailModel userDetailModel = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        params.put("orgCode", userDetailModel.getOrganization());
        params.put("resourcesCode", resourcesCode);
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
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("数据检索失败");
        }
        return envelop;
    }

    /**
     * 动态获取GRID的列名
     *
     * @param dictId
     * @return
     */
    @RequestMapping("/getGridCloumnNames")
    @ResponseBody
    public Object getGridCloumnNames(String dictId) {
        String resultStr = getColumns(dictId);
        return resultStr;
    }


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

    //数据导出方法
    @RequestMapping("outExcel")
    public void outExcel(HttpServletResponse response, Integer size, String resourcesCode, String searchParams) {

        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String fileName = "资源数据";
        String resourceCategoryName = System.currentTimeMillis() + "";
        try {
            resultStr = getColumns(resourcesCode);
            envelop = toModel(resultStr, Envelop.class);

            response.setContentType("octets/stream");
            response.setHeader("Content-Disposition", "attachment; filename="
                    + new String(fileName.getBytes("gb2312"), "ISO8859-1") + resourceCategoryName + ".xls");
            OutputStream os = response.getOutputStream();
            WritableWorkbook book = Workbook.createWorkbook(os);
            WritableSheet sheet = book.createSheet(resourceCategoryName, 0);

            for (int i = 0; i < envelop.getDetailModelList().size(); i++) {
                Map cmap = toModel(toJson(envelop.getDetailModelList().get(i)), Map.class);
                //new laberl（'列','行','数据'）
                sheet.addCell(new Label(0, 0, "代码"));
                sheet.addCell(new Label(0, 1, "名称"));
                sheet.addCell(new Label(i + 1, 0, String.valueOf(cmap.get("code"))));
                sheet.addCell(new Label(i + 1, 1, String.valueOf(cmap.get("value"))));
            }

            String url = "/resources/ResourceBrowses/getResourceData";
            params.put("resourcesCode", resourcesCode);
            params.put("queryCondition", searchParams);
            params.put("page", 1);
            params.put("size", size);

            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
            List<Object> objectList = envelop.getDetailModelList();
            Cell[] cells = sheet.getRow(0);
            for (int i = 0; i < objectList.size(); i++) {
                Map<String, String> map = toModel(toJson(objectList.get(i)), Map.class);
                for (String key : map.keySet()) {
                    for (Cell cell : cells) {
                        if (cell.getContents().equals(key)) {
                            sheet.addCell(new Label(cell.getColumn(), i + 2, String.valueOf(map.get(key))));
                        }
                    }
                }
            }
            sheet.mergeCells(0, 2, 0, objectList.size() + 1);
            sheet.addCell(new Label(0, 2, "值"));

            book.write();
            book.close();
            os.flush();
            os.close();
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("数据导出失败");
        }
        envelop.setSuccessFlg(true);
    }

    public String getColumns(String resourceCode) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/ResourceBrowses/getResourceMetadata";
        String resultStr = "";
        params.put("resourcesCode", resourceCode);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("获取表结构信息失败");
        }
        return toJson(envelop);
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

    @RequestMapping("browseBefore")
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
//            Envelop envelop = objectMapper.readValue(envelopStr,Envelop.class);
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
}
