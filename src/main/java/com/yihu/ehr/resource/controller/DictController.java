package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.resource.model.RsDictionaryMsg;
import com.yihu.ehr.resource.service.DictService;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.excel.read.RsDictionaryMsgReader;
import com.yihu.ehr.util.excel.read.RsDictionaryMsgWriter;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
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
    final String parentFile = "dict";
    Map<String, Integer> dictExcel;
    Map<String, Integer> dictEntryExcel;
    Map<Integer, String> headerMap ;
    public DictController() {
        this.init(
                "/resource/dict/grid",        //列表页面url
                "/resource/dict/dialog"      //编辑页面url
        );
        comboKv.put("code", "code");
        comboKv.put("id", "id");

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
                    combo.put("id", map.get("id"));
                    combo.put("name", map.get("name"));
                    combo.put("code", map.get("code"));
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
            writerResponse(response, 1 + "", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new RsDictionaryMsgReader();
            excelReader.read(file.getInputStream());
            List<RsDictionaryMsg> errorLs = excelReader.getErrorLs();
            List<RsDictionaryMsg> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 35+"", "l_upd_progress");

            //保存验证通过数据
            List saveLs = new ArrayList<>();
            if(correctLs.size()>0){
                Set<String> codes = findExistCode(toJson(excelReader.getRepeat().get("code")));
                writerResponse(response, 45+"", "l_upd_progress");
                if(codes.size()>0){
                    RsDictionaryMsg model;
                    for(int i=0; i<correctLs.size(); i++){
                        model = correctLs.get(i);
                        if(codes.contains(model.getCode())){
                            model.addErrorMsg("code", "该代码已存在！");
                            errorLs.add(model);
                        }
                        else
                            saveLs.add(correctLs.get(i));
                    }
                }else
                    saveLs = correctLs;
            }
            writerResponse(response, 55+"", "l_upd_progress");

            Map rs = new HashMap<>();
            if(errorLs.size()>0){
                String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".xls");
                new RsDictionaryMsgWriter().write(new File(TemPath.getFullPath(eFile, parentFile)), errorLs);
                rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
            }
            writerResponse(response, 65 + "", "l_upd_progress");

            if(saveLs.size()>0)
                saveDicts(toJson(saveLs));
            if(errorLs.size()==0)
                writerResponse(response, 100 + ",'suc'", "l_upd_progress");
            else
                writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");

        } catch (Exception e) {
            e.printStackTrace();
            writerResponse(response, "-1", "l_upd_progress");
        }
    }

    @RequestMapping("/downLoadErrInfo")
    public void downLoadErrInfo(String f, String datePath,  HttpServletResponse response) throws IOException {

        try{
            f = datePath + TemPath.separator + f;
            downLoadFile(TemPath.getFullPath(f, parentFile), response);
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

    private Set<String> findExistCode(String codes) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("codes", codes);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/resources/dict/codes/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }

}
