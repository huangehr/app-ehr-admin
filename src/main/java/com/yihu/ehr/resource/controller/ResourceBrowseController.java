package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.resource.RsBrowseModel;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.controller.BaseUIController;
import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
    public Object searchResourceData(String resourcesCode, String searchParams, int page, int rows) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String url = "/resources/ResourceBrowses/getResourceData";
        params.put("resourcesCode", resourcesCode);
        params.put("queryCondition", searchParams);
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
     * @param dictId
     * @return
     */
    @RequestMapping("/getGridCloumnNames")
    @ResponseBody
    public Object getGridCloumnNames(String dictId) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/ResourceBrowses/getResourceMetadata";
        String resultStr = "";
        params.put("resourcesCode", dictId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {

        }
        return resultStr;
    }


    @RequestMapping("/getRsDictEntryList")
    @ResponseBody
    public Object getRsDictEntryList(String dictId) {

        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String dictEntryUrl = "/resources/noPageDictEntries";
        params.put("filters", "dictCode=" + dictId+" g0");

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
    public Object getDictEntryList(String dictId) {

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

//    //数据导出方法
//    @RequestMapping("outExcel")
//    @ResponseBody
//    public Object outExcel(String rowData, String resourceCategoryName) {
//
//        Envelop envelop = new Envelop();
////        resourceCategoryName = resourceCategoryName.replaceAll("/","")+"_"+System.currentTimeMillis();
//        resourceCategoryName = System.currentTimeMillis()+"";
//        //标题行
//        List<Object> dataAllList = toModel(rowData, List.class);
//
//        List<String> titleList = new ArrayList<>();
//        List<List> dataList = new ArrayList<>();
//        List<String> rowContext = new ArrayList<>();
//
//        Map<String, String> map = new HashMap<>();
//
//        for (int i = 0; i < dataAllList.size(); i++) {
//            map = toModel(toJson(dataAllList.get(i)), Map.class);
//            for (String key : map.keySet()) {
//
//                if (!titleList.contains(key)) {
//                    titleList.add(key);
//                }
//                rowContext.add(String.valueOf(map.get(key)));
//            }
//            dataList.add(rowContext);
//            rowContext = new ArrayList<>();
//        }
//
//        try {
//            //resourceCategoryName.xls为要新建的文件名
//            WritableWorkbook book = Workbook.createWorkbook(new File("F:\\excel\\" + resourceCategoryName + ".xls"));
//            //生成名为“resourceCategoryName”的工作表，参数0表示这是第一页
//            WritableSheet sheet = book.createSheet(resourceCategoryName, 0);
//            //title
//            for (int i = 0; i < titleList.size(); i++) {
//                sheet.addCell(new Label(i, 0, titleList.get(i)));
//            }
//            //context
//            for (int i = 0; i < dataList.size(); i++) {
//                for (int j = 0; j < dataList.get(i).size(); j++) {
//                    sheet.addCell(new Label(j, i + 1, String.valueOf(dataList.get(i).get(j))));
//                }
//            }
//            book.write();
//            book.close();
//        } catch (Exception e) {
//            envelop.setSuccessFlg(false);
//            envelop.setErrorMsg("数据导出失败");
//        }
//        envelop.setSuccessFlg(true);
//        return envelop;
//    }
//数据导出方法
@RequestMapping("outExcel")
@ResponseBody
public Object outExcel(String codes,String names,String valueList, String resourceCategoryName) {

    Envelop envelop = new Envelop();
    resourceCategoryName = System.currentTimeMillis()+"";
    List<String> titleList = toModel(codes,List.class);
    List<List> dataList = toModel(valueList,List.class);
    List<String> nameList = toModel(names,List.class);
    String path = "C:\\resourceData\\"+resourceCategoryName + ".xls";
    try {
        File file = new File(path);
        if(!file.getParentFile().exists()){
            file.getParentFile().mkdirs();
        }
        WritableWorkbook book = Workbook.createWorkbook(file);
        WritableSheet sheet = book.createSheet(resourceCategoryName, 0);
        for (int i = 0; i < titleList.size(); i++) {
            //new laberl（'列','行','数据'）
            sheet.addCell(new Label(0,0,"代码"));
            sheet.addCell(new Label(0,1,"名称"));
            sheet.addCell(new Label(i+1, 0, titleList.get(i)));
            sheet.addCell(new Label(i+1,1,nameList.get(i)));
        }
        for (int i = 0; i < dataList.size(); i++) {
            for (int j = 0; j < dataList.get(i).size(); j++) {
                sheet.mergeCells(0,2,0,dataList.size()+1);
                sheet.addCell(new Label(0,2,"值"));
                sheet.addCell(new Label(j+1, i + 2, String.valueOf(dataList.get(i).get(j))));
            }
        }
        book.write();
        book.close();
    } catch (Exception e) {
        envelop.setSuccessFlg(false);
        envelop.setErrorMsg("数据导出失败");
    }
    envelop.setSuccessFlg(true);
    return envelop;
}
}
