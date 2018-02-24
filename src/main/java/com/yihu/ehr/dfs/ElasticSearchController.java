package com.yihu.ehr.dfs;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.ServiceApi;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.datetime.DateUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.net.URLEncoder;
import java.util.*;

/**
 * Created by wxw on 2018/2/6.
 */
@Controller
@RequestMapping("/elasticSearch")
public class ElasticSearchController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    private ObjectMapper objectMapper;

    @RequestMapping("/initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/dfs/elasticSearch/list");
        return "pageView";
    }

    @RequestMapping("/getElasticList")
    @ResponseBody
    public Object getQuotaCategoryList(String indexNm, String indexType,String quotaCode, Double begin, Double end, int page, int rows) throws Exception{
        String url = ServiceApi.ElasticSearch.Page;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        List<String> list = new ArrayList<>();
        if (!StringUtils.isEmpty(quotaCode)) {
            list.add("{\"andOr\":\"and\",\"condition\":\"?\",\"field\":\"quotaCode\",\"value\":\"" + quotaCode + "\"}");
        }
        if (!StringUtils.isEmpty(begin)) {
            list.add("{\"andOr\":\"and\",\"condition\":\">=\",\"field\":\"result\",\"value\":\"" + begin + "\"}");
        }
        if (!StringUtils.isEmpty(end)) {
            list.add("{\"andOr\":\"and\",\"condition\":\"<=\",\"field\":\"result\",\"value\":\"" + end + "\"}");
        }
        String[] array = list.toArray(new String[list.size()]);

        String filters = org.apache.commons.lang3.StringUtils.join(array, ",");
        if (list.size() > 0) {
            params.put("filter", "[" + filters + "]");
        }
        params.put("index", indexNm);
        params.put("type", indexType);
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(resultStr, Envelop.class);
            List<String> obj = new ArrayList<>();
            obj.add(indexNm);
            obj.add(indexType);
            envelop.setObj(obj);
            return envelop;
        } catch (Exception ex) {
            LogService.getLogger(ElasticSearchController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/deleteElastic")
    @ResponseBody
    public Object deleteQuotaCategory(String indexNm, String indexType, String id) {
        String url = ServiceApi.ElasticSearch.Delete;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("index", indexNm);
        params.put("type", indexType);
        params.put("id", id);
        try {
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            result = toModel(resultStr, Envelop.class);
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping(value = "/getPage")
    public String getPage(Model model, String indexNm, String indexType, String id){
        if (id == "") {
            model.addAttribute("id","-1");
            return  "/dfs/elasticSearch/addElasticInfoDialog";
        } else {
            model.addAttribute("id",id);
            model.addAttribute("indexNm",indexNm);
            model.addAttribute("indexType",indexType);
            return  "/dfs/elasticSearch/elasticInfoDialog";
        }
    }

    @RequestMapping("/detailById")
    @ResponseBody
    public Object getTjQuotaById(Model model, String indexNm, String indexType, String id) throws Exception {
        String url ="/elasticSearch/" + id;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("index", indexNm);
        params.put("type", indexType);
        resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        envelop = toModel(resultStr, Envelop.class);
        return envelop;
    }

    @RequestMapping("/addElastic")
    @ResponseBody
    public Object addElastic(
            @RequestParam("file") MultipartFile file) throws IOException {
//        InputStream inputStream = file.getInputStream();
//        String fileName = file.getOriginalFilename(); //获取文件名
//        if (!file.isEmpty()) {
//            return  uploadFile(inputStream,fileName);
//        }
//        return "fail";
        String url ="/elasticSearch/addElasticSearch";
        Envelop envelop = new Envelop();
        String str;
        String jsonString = "";
        List<String> list = new ArrayList<>();
        String index = "";
        String type = "";
        InputStream inputStream = file.getInputStream();
        InputStreamReader isr = null;
        BufferedReader br = null;
        isr = new InputStreamReader(inputStream);
        br = new BufferedReader(isr);
        while ((str = br.readLine()) != null) {
            System.out.println(str);// 打印
            JSONObject jsonObject = new JSONObject(str);
            if (str.contains("_index")) {
                JSONObject data = jsonObject.getJSONObject("index");
                if (data.toString().contains("_index")) {
                    index = data.get("_index").toString();
                }
                if (data.toString().contains("_type")) {
                    type = data.get("_type").toString();
                }
            } else {
                list.add(str);
            }
        }
        if (StringUtils.isEmpty(index) || StringUtils.isEmpty(type)) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("格式有误，请检查");
            return envelop;
        }
        HashSet<String> hashSet = new HashSet<>(list);
        list.clear();
        list.addAll(hashSet);
        jsonString = URLEncoder.encode(String.join(";", list).replace(" ", ""), "UTF-8");
        Map<String, Object> params = new HashMap<>();
        params.put("index", index);
        params.put("type", type);
        params.put("sourceList", jsonString);
        try {
            HttpClientUtil.doPost(comUrl + url, params, username, password);
            return envelop;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("格式有误，请检查");
            return envelop;
        }
    }

    @RequestMapping("/updateElasticSearch")
    @ResponseBody
    public Object updateElasticSearch(String id, String data, String index, String type) throws Exception {
        String url =ServiceApi.ElasticSearch.Update;
        Envelop envelop = new Envelop();
        String resultStr = "";
        if (StringUtils.isEmpty(index) || StringUtils.isEmpty(type) || StringUtils.isEmpty(id)) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("参数缺失");
            return envelop;
        }
        Map<String, Object> params = new HashMap<>();
        params.put("index", index);
        params.put("type", type);
        params.put("id", id);
        params.put("source", data);
        resultStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
        envelop = toModel(resultStr, Envelop.class);
        return envelop;
    }
}
