package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.resource.model.RsDictionaryEntryMsg;
import com.yihu.ehr.resource.model.RsDictionaryMsg;
import com.yihu.ehr.resource.service.DictService;
import com.yihu.ehr.util.excel.ExcelReader;
import com.yihu.ehr.util.excel.ExcelRWFactory;
import com.yihu.ehr.util.excel.ExcelWriter;
import com.yihu.ehr.util.rest.Envelop;
import javafx.util.Pair;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.*;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/20
 */
@Controller("resource-dict")
@RequestMapping("/resource/dict")
public class DictController extends ExtendController<DictService> {

    Map<String, Integer> dictExcel;
    Map<String, Integer> dictEntryExcel;
    Map<Integer, String> headerMap ;
    public DictController() {
        this.init(
                "/resource/dict/grid",        //列表页面url
                "/resource/dict/dialog"      //编辑页面url
        );
        comboKv.put("code", "code");
        dictExcel = new HashMap<>();
        dictExcel.put("code", 0);
        dictExcel.put("name", 1);
        dictExcel.put("description", 2);

        dictEntryExcel = new HashMap<>();
        dictEntryExcel.put("code", 3);
        dictEntryExcel.put("name", 4);
        dictEntryExcel.put("description", 5);

        headerMap = new HashMap<>();
        headerMap.put(0, "代码");
        headerMap.put(1, "名称");
        headerMap.put(2, "说明");
    }

    @Override
    public Map beforeGotoModify(Map params) {
        try {
            params.put("id", URLEncoder.encode(String.valueOf(params.get("id")), "UTF-8"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return params;
    }

    @RequestMapping("/searchCombo")
    @ResponseBody
    public Object comboSearch(String searchParm, int page, int rows){

        try{
            PageParms pageParms = new PageParms(rows, page)
                    .addGroupNotNull("code", PageParms.LIKE, searchParm, "g1")
                    .addGroupNotNull("name", PageParms.LIKE, searchParm, "g1");

            Envelop envelop = getEnvelop(service.search(pageParms));
            List rs = new ArrayList<>();
            Map<String, String> combo;
            if(envelop.isSuccessFlg())
                for(Map<String, String> map: (List<Map<String, String>>) envelop.getDetailModelList()){
                    combo = new HashMap<>();
                    combo.put("id", map.get("code"));
                    combo.put("name", map.get("name"));
                    rs.add(combo);
                }
            envelop.setDetailModelList(rs);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @RequestMapping(value = "import")
    @ResponseBody
    public void importMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        UserDetailModel user = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        try {
            writerResponse(response, 10+"", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            ExcelReader excelReader = ExcelRWFactory.createReader(
                    RsDictionaryMsg.class, dictExcel, RsDictionaryEntryMsg.class, dictEntryExcel,
                    new Pair<>("dictCode", "code"));
            excelReader.read(file.getInputStream());

            writerResponse(response, 25+"", "l_upd_progress");

            Map errorMap = excelReader.getErrorMap();
            List<Pair<RsDictionaryMsg, List>> correctLs = excelReader.getCorrectLs();


            //保存验证通过数据
            if(correctLs.size()>0){
                Map map = new HashMap<>();
                Pair<RsDictionaryMsg, List> p;
                map.put("codes", toJson(excelReader.getRepeat().get("code")));
                String rs = service.doGet(service.comUrl + "/resources/dict/codes/existence", map);

                writerResponse(response, 35+"", "l_upd_progress");

                Set<String> codes = objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
                int len = codes.size();
                List saveLs = new ArrayList<>();
                for(int i=0; i<correctLs.size(); i++){
                    p = correctLs.get(i);
                    codes.add(p.getKey().getCode());
                    if(len == codes.size()){
                        p.getKey().addErrorMsg("code", "该代码已存在！");
                        errorMap.put(p.getKey(), p.getValue());
                    }
                    else
                        saveLs.add(correctLs.get(i));
                    len = codes.size();
                }
                writerResponse(response, 55+"", "l_upd_progress");
                if(saveLs.size()>0)
                    saveDicts(toJson(saveLs));
            }

            writerResponse(response, 75 + "", "l_upd_progress");

            if(errorMap.size()==0){
                writerResponse(response, 100 + ",'suc'", "l_upd_progress");
                return;
            }

            String eFile = ExcelWriter.createFileName(user.getLoginCode(), "e");
            ExcelWriter writer = ExcelRWFactory.createWriter(
                    RsDictionaryMsg.class, dictExcel, RsDictionaryEntryMsg.class, dictEntryExcel,
                    "name", headerMap);
            writer.createXls(errorMap, eFile);

            Map rs = new HashMap<>();
            rs.put("eFile", eFile.split("\\\\"));
            writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");
        } catch (Exception e) {
            e.printStackTrace();
            writerResponse(response, "-1", "l_upd_progress");
        }
    }

    @RequestMapping("/downLoadErrInfo")
    public void downLoadErrInfo(String f, String datePath,  HttpServletResponse response) throws IOException {

        try{
            f = datePath + ExcelWriter.separator + f;
            downLoadFile(ExcelWriter.getFullPath(f), response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private List saveDicts(String dicts) throws Exception {
        Map map = new HashMap<>();
        map.put("model", dicts);
        Envelop envelop = getEnvelop(service.doPost(service.comUrl + "/resources/dict/entry/batch", map));
        if(envelop.isSuccessFlg())
            return envelop.getDetailModelList();
        throw new Exception("保存失败！");
    }
}
