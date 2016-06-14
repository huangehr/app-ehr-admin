package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.resource.RsBrowseModel;
import com.yihu.ehr.api.ServiceApi;
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
 * Created by wq on 2016/6/7.
 */

@Controller
@RequestMapping("/resourceView")
public class resourceViewController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @RequestMapping("/initial")
    public String resourceBrowseInitial(Model model,String dataModel) {
        model.addAttribute("contentPage", "/resource/resourcebrowse/resourceView");
        model.addAttribute("dataModel",dataModel);
        return "pageView";
    }

    @RequestMapping("/searchResource")
    @ResponseBody
    public Object searchResource(String ids) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        params.put("id", ids);

        try {

            resultStr = HttpClientUtil.doGet(comUrl + "/resources/ResourceBrowses/categories", params, username, password);

            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {

        }
        return envelop.getDetailModelList();
    }

    @RequestMapping("/searchResourceData")
    @ResponseBody
    public Object searchResourceData(String resourcesCode, String searchParams, int page, int rows) {
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String url = "/resources/ResourceBrowses/getResourceData";
        params.put("resourcesCode", resourcesCode);
        params.put("queryCondition", searchParams);
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        } catch (Exception e) {

        }
        return resultStr;
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
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String url = "/resources/ResourceBrowses/getResourceMetadata";
        String resultStr = "";
        params.put("resourcesCode", dictId);

        try {

            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
        } catch (Exception e) {

        }
        return envelop.getDetailModelList();
    }


    @RequestMapping("/getRsDictEntryList")
    @ResponseBody
    public Object getRsDictEntryList(String dictId) {

        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String dictEntryUrl = ServiceApi.Resources.DictEntries;

        params.put("filters", "dictCode=" + dictId);
        params.put("page", 1);
        params.put("size", 500);// TODO: 2016/6/1   字典项没有不分页的接口
        params.put("fields", "");
        params.put("sorts", "");

        try {
            if (!StringUtils.isEmpty(dictId)) {

                resultStr = HttpClientUtil.doGet(comUrl + dictEntryUrl, params, username, password);
                envelop = toModel(resultStr, Envelop.class);

            }
        } catch (Exception e) {

        }

        return envelop.getDetailModelList();
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
                        envelop = toModel(resultStr, Envelop.class);
                        break;

                    case "andOr":
                        rsBrowseModelList.add(new RsBrowseModel("AND", "并且"));
                        rsBrowseModelList.add(new RsBrowseModel("OR", "或者"));
                        envelop.setDetailModelList(rsBrowseModelList);
                        break;
                    default:
                        url = "/resources/ResourceBrowses";
                        params.put("category_id", dictId);

                        resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                        envelop = toModel(resultStr, Envelop.class);
                        break;

                }
            }
        } catch (Exception e) {

        }

        return envelop.getDetailModelList();
    }

    //数据导出方法
    @RequestMapping("outExcel")
    @ResponseBody
    public Object outExcel(String rowData, String resourceCategoryName) {

        Envelop envelop = new Envelop();
        resourceCategoryName = resourceCategoryName.replaceAll("/", "") + "_" + System.currentTimeMillis();
        //标题行
        List<Object> dataAllList = toModel(rowData, List.class);

        List<String> titleList = new ArrayList<>();
        List<List> dataList = new ArrayList<>();
        List<String> rowContext = new ArrayList<>();

        Map<String, String> map = new HashMap<>();

        for (int i = 0; i < dataAllList.size(); i++) {
            map = toModel(toJson(dataAllList.get(i)), Map.class);
            for (String key : map.keySet()) {

                if (!titleList.contains(key)) {
                    titleList.add(key);
                }
                rowContext.add(String.valueOf(map.get(key)));
            }
            dataList.add(rowContext);
            rowContext = new ArrayList<>();
        }

        try {
            //resourceCategoryName.xls为要新建的文件名
            WritableWorkbook book = Workbook.createWorkbook(new File("F:\\excel\\" + resourceCategoryName + ".xls"));
            //生成名为“resourceCategoryName”的工作表，参数0表示这是第一页
            WritableSheet sheet = book.createSheet(resourceCategoryName, 0);
            //title
            for (int i = 0; i < titleList.size(); i++) {
                sheet.addCell(new Label(i, 0, titleList.get(i)));
            }
            //context
            for (int i = 0; i < dataList.size(); i++) {
                for (int j = 0; j < dataList.get(i).size(); j++) {
                    sheet.addCell(new Label(j, i + 1, String.valueOf(dataList.get(i).get(j))));
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
