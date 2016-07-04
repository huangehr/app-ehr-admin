package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.resource.RsBrowseModel;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.controller.BaseUIController;
import jxl.Cell;
import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
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

//数据导出方法
    @RequestMapping("outExcel")
    public void outExcel(HttpServletResponse response, String codes, String names, Integer size, String resourcesCode, String searchParams) {

        Envelop envelop = new Envelop();
        String resourceCategoryName = System.currentTimeMillis() + "";
        List<String> titleList = toModel(codes, List.class);
        List<List> dataList = new ArrayList<>();
        List<String> nameList = toModel(names, List.class);
        String fileName = "资源数据";

        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String url = "/resources/ResourceBrowses/getResourceData";
        params.put("resourcesCode", resourcesCode);
        params.put("queryCondition", searchParams);
        params.put("page", 1);
        params.put("size", size);

        try {

            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
            List<Object> objectList = envelop.getDetailModelList();
            response.setContentType("octets/stream");
            response.setHeader("Content-Disposition", "attachment; filename="
                    + new String(fileName.getBytes("gb2312"), "ISO8859-1") + resourceCategoryName + ".xls");
            OutputStream os = response.getOutputStream();
            WritableWorkbook book = Workbook.createWorkbook(os);
            WritableSheet sheet = book.createSheet(resourceCategoryName, 0);
            for (int i = 0; i < titleList.size(); i++) {
                //new laberl（'列','行','数据'）
                sheet.addCell(new Label(0, 0, "代码"));
                sheet.addCell(new Label(0, 1, "名称"));
                sheet.addCell(new Label(i + 1, 0, titleList.get(i)));
                sheet.addCell(new Label(i + 1, 1, nameList.get(i)));
            }
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
}
