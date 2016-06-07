package com.yihu.ehr.resource.controller;

import com.yihu.ehr.agModel.resource.RsBrowseModel;
import com.yihu.ehr.api.ServiceApi;
import com.yihu.ehr.util.Envelop;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
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
        String CategoriesUrl = ServiceApi.Resources.Categories;
        String ResourcesUrl = ServiceApi.Resources.Resources;
        String resultStr = "";

//        params.put("filters","");
//        if (!StringUtils.isEmpty(ids))
//            params.put("filters","pid="+ids);//test_code
//
//        params.put("page", 1);
//        params.put("size", 999);
//        params.put("fields","");
//        params.put("sorts","");
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
    public Object searchResourceData(String resourcesCode,String searchParams, int page, int rows) {
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        String resultStr = "";
        String url = "/resources/ResourceBrowses/getResourceData";
        resourcesCode = "RS_PATIENT_EVENT";
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

//    /**
//     * 动态获取GRID的列名
//     *
//     * @param dictId
//     * @return
//     */
//    @RequestMapping("/")
//    @ResponseBody
//    public Object getGridCloumnNamestest(String dictId) {
//        Envelop envelop = new Envelop();
//        Map<String, Object> params = new HashMap<>();
//        String url = "/resources/ResourceBrowses";
//        String resultStr = "";
//        params.put("category_id", dictId);
//
//        try {
//
//            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
//            envelop = toModel(resultStr, Envelop.class);
//        } catch (Exception e) {
//
//        }
//        return envelop.getDetailModelList();
//    }



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
        dictId = "RS_PATIENT_EVENT";
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


    //数据导出方法  test
    @RequestMapping("testexcel")
    @ResponseBody
    public String testexcel() {
        //标题行
        String title[] = {"角色", "编号", "功能名称", "功能描述"};
        //内容
        String context[][] = {{"UC11", "设置课程", "创建课程"},
                {"UC12", "设置学生名单", "给出与课程关联的学生名单"},
                {"UC21", "查看学生名单", ""},
                {"UC22", "查看小组信息", "显示助教所负责的小组列表信息"}
        };
        //操作执行
        try {
            //t.xls为要新建的文件名
            WritableWorkbook book = Workbook.createWorkbook(new File("F:\\excel\\t.xls"));
            //生成名为“第一页”的工作表，参数0表示这是第一页
            WritableSheet sheet = book.createSheet("第一页", 0);

            //写入内容
            for (int i = 0; i < 4; i++)  //title
                sheet.addCell(new Label(i, 0, title[i]));
            for (int i = 0; i < 4; i++)  //context
            {
                for (int j = 0; j < 3; j++) {
                    sheet.addCell(new Label(j + 1, i + 1, context[i][j]));
                }
            }
            sheet.addCell(new Label(0, 1, "教师"));
            sheet.addCell(new Label(0, 3, "助教"));

      /*合并单元格.合并既可以是横向的，也可以是纵向的
       *WritableSheet.mergeCells(int m,int n,int p,int q);  表示由(m,n)到(p,q)的单元格组成的矩形区域合并
       * */
            sheet.mergeCells(0, 1, 0, 2);
            sheet.mergeCells(0, 3, 0, 4);

            //写入数据
            book.write();
            //关闭文件
            book.close();
        } catch (Exception e) {

        }
        return null;
    }
}
