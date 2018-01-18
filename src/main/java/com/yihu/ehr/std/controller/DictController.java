package com.yihu.ehr.std.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.agModel.standard.dict.DictEntryModel;
import com.yihu.ehr.agModel.standard.dict.DictModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.std.model.DictionaryMsg;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.excel.read.DictionaryMsgReader;
import com.yihu.ehr.util.excel.read.DictionaryMsgWriter;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import jxl.Workbook;
import jxl.format.CellFormat;
import jxl.write.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

/**
 * Created by Administrator on 2015/8/12.
 */
@RequestMapping("/cdadict")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class DictController  extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.stdurl}")
    private String comUrl;
    @Value("${service-gateway.stdsourceurl}")
    private String stdsourceurl;
    final String parentFile = "dict";
    @RequestMapping("initial")
    public String dictInitial(Model model) {
        model.addAttribute("contentPage","/std/dict/stdDict");
        return "pageView";
    }

    @RequestMapping("template/stdDictInfo")
    public String stdDictInfoTemplate(Model model, String dictId, String strVersionCode, String mode,String staged) {
        Map<String, Object> params = new HashMap<>();
        DictModel dictModel = new DictModel();
        Envelop result = new Envelop();
        String resultStr = "";

        //mode定义：new modify view三种模式，新增，修改，查看
        if(mode.equals("view") || mode.equals("modify")){
            model.addAttribute("rs", "suc");
            if (strVersionCode == null) {
                model.addAttribute("rs", ("找不到version_code"));
            }else{
                String url = "/dict";
                try {
                    params.put("dictId",dictId);
                    params.put("version_code",strVersionCode);
                    resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                    result = getEnvelop(resultStr);
                    dictModel = getEnvelopModel(result.getObj(), DictModel.class);
                    if(dictModel.getBaseDict()!=null){
                        Long baseDictId = dictModel.getBaseDict();
                        params.replace("dictId", baseDictId);
                        params.put("version_code",strVersionCode);

                        String baseResultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                        result = getEnvelop(baseResultStr);
                        if(result.isSuccessFlg()){
                            DictModel baseDictModel = getEnvelopModel(result.getObj(),DictModel.class);
                            String baseDictName = baseDictModel.getName();
                            model.addAttribute("baseDictId",baseDictId);
                            model.addAttribute("baseDictName",baseDictName);
                        }
                    }
                    else{
                        model.addAttribute("baseDictId","");
                        model.addAttribute("baseDictName","");
                    }
                } catch (Exception ex) {
                    LogService.getLogger(DictController.class).error(ex.getMessage());
                    model.addAttribute("rs", "error");
                }
            }
        }
        model.addAttribute("info",toJson(dictModel));
        model.addAttribute("mode",mode);
        model.addAttribute("staged",staged);
        model.addAttribute("contentPage","/std/dict/stdDictInfoDialog");
        return "emptyView";
    }

    @RequestMapping("template/dictEntryInfo")
    public String dictEntryInfoTemplate(Model model, String id, String dictId, String strVersionCode,String staged, String mode) {
        String resultStr = "";
        DictEntryModel dictEntryModel = new DictEntryModel();
        dictEntryModel.setDictId(Long.parseLong(dictId));

        Envelop result = new Envelop();
        model.addAttribute("rs", "suc");
        //mode定义：new modify view三种模式，新增，修改，查看
        String url = "/dict_entry";
        try {
            if(!mode.equals("new")){
                Map<String,Object> params = new HashMap<>();
                Long dictEntryId = id.equals("") ? 0 : Long.parseLong(id);
                //Long dictIdForEntry = dictId.equals("") ? 0 : Long.parseLong(dictId);

                params.put("versionCode",strVersionCode);
                params.put("entryId",dictEntryId);
                resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                result = getEnvelop(resultStr);
                dictEntryModel = getEnvelopModel(result.getObj(),DictEntryModel.class);
            }
        } catch (Exception ex) {
            LogService.getLogger(DictController.class).error(ex.getMessage());
            model.addAttribute("rs", "error");
        }
        model.addAttribute("info", toJson(dictEntryModel));
        model.addAttribute("mode",mode);
        model.addAttribute("staged",staged);
        model.addAttribute("contentPage","/std/dict/dictEntryInfoDialog");
        return "emptyView";
    }

    /**
     * 新增或更新字典数据。
     *
     * @return
     */
    @RequestMapping("saveDict")
    @ResponseBody
    public Object saveDict(String cdaVersion, String dictId, String code, String name, String baseDict, String stdSource, String stdVersion, String description,HttpServletRequest request) {
        Envelop result = new Envelop();
        String resultStr = "";
        try{
            UserDetailModel userDetailModel = getCurrentUserRedis(request);
            String userId = userDetailModel.getId().toString();
            if (StringUtils.isEmpty(cdaVersion)) {
                result.setSuccessFlg(false);
                result.setErrorMsg("版本号不能为空！");
                return result;
            }
            if (StringUtils.isEmpty(code)) {
                result.setSuccessFlg(false);
                result.setErrorMsg("代码不能为空！");
                return result;
            }
            if (StringUtils.isEmpty(name)) {
                result.setSuccessFlg(false);
                result.setErrorMsg("名称不能为空！");
                return result;
            }
            Map<String, Object> params = new HashMap<>();
            DictModel dictModel = new DictModel();
            dictModel.setId(Long.parseLong(dictId));
            dictModel.setCode(code);
            dictModel.setName(name);
            dictModel.setBaseDict(StringUtils.isEmpty(baseDict) ? null : Long.parseLong(baseDict));
            dictModel.setSourceId(stdSource);
            dictModel.setDescription(description);
            dictModel.setAuthor(userId);
            dictModel.setStdVersion(cdaVersion);

            params.put("version_code",cdaVersion);
            params.put("json_data",toJson(dictModel));
            String url = "/save_dict";
            resultStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return resultStr;

        }catch(Exception ex){
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());

            return result;
        }
       /* Result result = new Result();
        Long id = dictId.equals("") ? 0 : Long.parseLong(dictId);
        Long baseDictL = baseDict.equals("") ? 0 : Long.parseLong(baseDict);
        //新增字典
        try {
            if (cdaVersion == null || cdaVersion.equals("")) {
                return missParameter("VersionCode");
            }
            List<String> ids = new ArrayList<>();
            ids.add(stdSource);
            XStandardSource[] xStandardSource = xStandardSourceManager.getSourceById(ids);
            XCDAVersion xcdaVersion = cdaVersionManager.getVersion(cdaVersion);
            if (xcdaVersion == null)
                return failed(ErrorCode.GetCDAVersionFailed);
            if (code == null || code.equals("")) {
                return missParameter("code");
            }
            if (name == null || name.equals("")) {
                return missParameter("name");
            }
            Date createTime = new Date();
            XDict xDict = new Dict();
            if(id!=0){
                xDict = dictManager.getDict(id, xcdaVersion);
                if(!code.equals(xDict.getCode())){
                    if(dictManager.isDictCodeExist(xcdaVersion,code)){
                        result.setErrorMsg("codeNotUnique");
                        return result;
                    }
                }
            }
            else if(dictManager.isDictCodeExist(xcdaVersion,code)){
                result.setErrorMsg("codeNotUnique");
                return result;
            }
            xDict.setId(id);
            xDict.setCode(code);
            xDict.setName(name);
            xDict.setAuthor(user.getId());
            xDict.setSource(xStandardSource[0]);
            xDict.setBaseDictId(baseDictL);
            xDict.setCreateDate(createTime);
            xDict.setDescription(description);
            xDict.setStdVersion(stdVersion);
            xDict.setInnerVersion(xcdaVersion);
            int resultItem = dictManager.saveDict(xDict);
            if (resultItem >= 1) {
                result.setSuccessFlg(true);
                return result;
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.SaveDictFailed.toString());
                return result;
            }
        } catch (Exception ex) {
            LogService.getLogger(StdManagerRestController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SaveDictFailed.toString());
            return result;
        }*/
    }

    @RequestMapping("deleteDict")
    @ResponseBody
    public Object deleteDict(String cdaVersion, String dictId) {
        Envelop result = new Envelop();
        String resultStr = "";

        String url = "/dict";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("versionCode",cdaVersion);
            params.put("dictId",dictId);

            resultStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return resultStr;

        }catch(Exception ex){
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
/*        Result result = new Result();
        Long id = Long.parseLong(dictId);
        XCDAVersion xcdaVersion = cdaVersionManager.getVersion(cdaVersion);
        XDict dict = dictManager.createDict(xcdaVersion);
        dict.setId(id);
        try {
            int resultItem = dictManager.removeDict(dict);
            if (resultItem >= 1) {
                result.setSuccessFlg(true);
                return result;
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.DeleteDictFailed.toString());
                return result;
            }
        } catch (Exception ex) {
            LogService.getLogger(StdManagerRestController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.DeleteDictFailed.toString());
            return result;
        }*/
    }

    /**
     * 根据CdaVersion查询相应版本的字典数据。
     *
     * @return
     */
    @RequestMapping("getCdaDictList")
    @ResponseBody
    public Object getCdaDictList(String searchNm, String strVersionCode, Integer page, Integer rows) {
        Envelop result = new Envelop();
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();

        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchNm)) {
            stringBuffer.append("name?" + searchNm + " g1;code?" + searchNm + " g1");
        }
        String filters = stringBuffer.toString();
        params.put("filters", "");
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        params.put("fields", "");
        params.put("sorts", "");
        if (strVersionCode == null) {
            result.setSuccessFlg(false);
            result.setErrorMsg("版本号不能为空！");
            return result;
        }
        params.put("version",strVersionCode);

        try{
            String url = "/dicts";
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;

        }catch(Exception ex){
//            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg("数据加载失败！");
            return result;
        }
    }

    /**
     * 查询StdSource用于下拉框赋值。
     *
     * @return
     */
    @RequestMapping("getStdSourceList")
    @ResponseBody
    public Object getStdSourceList() {
        Envelop result = new Envelop();
        String resultStr = "";
        DictModel dictModel = new DictModel();
        Map<String,Object> params = new HashMap<>();

        params.put("filters", "");
        params.put("page", 1);
        params.put("size", 500);
        params.put("fields", "");
        params.put("sorts", "");

        try {
            String url = "/sources";
            resultStr = HttpClientUtil.doGet(stdsourceurl+url,params,username,password);

            return resultStr;

        } catch (Exception ex) {
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.GetCDAVersionListFailed.toString());
            return result;
        }
    }

    /**
     * 根据CdaVersion及字典ID查询相应版本的字典详细信息。
     *
     * @return
     */
    @RequestMapping(value = "/getCdaDictInfo", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object getCdaDictInfo(String dictId, String strVersionCode) {
        Envelop result = new Envelop();
        String resultStr = "";
        Map<String,Object> params = new HashMap<>();
        if (strVersionCode == null) {
            result.setSuccessFlg(false);
            result.setErrorMsg("版本号不能为空！");
            return result;
        }
        params.put("versionCode",strVersionCode);
        params.put("dictId",dictId);

        try{
            String url = "/dict";
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            //result = getEnvelop(resultStr);
            //DictModel dictModel = getEnvelopModel(result.getObj(),DictModel.class);

            return resultStr;

        }catch(Exception ex){
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }

        /*Result result = new Result();
        Long id = dictId == null ? 0 : Long.parseLong(dictId);
        if (strVersionCode == null) {
            return missParameter("version_code");
        }
        try {
            XCDAVersion xcdaVersion = cdaVersionManager.getVersion(strVersionCode);
            XDict xDict = dictManager.getDict(id, xcdaVersion);
            if (xDict != null) {
                XDictForInterface info = new DictForInterface();
                info.setId(String.valueOf(xDict.getId()));
                info.setCode(xDict.getCode());
                info.setName(xDict.getName());
                info.setAuthor(xDict.getAuthor());
                info.setBaseDictId(String.valueOf(xDict.getBaseDictId()));
                info.setCreateDate(String.valueOf(xDict.getCreateDate()));
                info.setDescription(xDict.getDescription());
                info.setStdVersion(xDict.getStdVersion());
                if (xDict.getSource() == null) {
                    info.setStdSource(null);
                } else {
                    info.setStdSource(xDict.getSource().getId());
                }
                info.setHashCode(String.valueOf(xDict.getHashCode()));
                info.setInnerVersionId(xDict.getInnerVersionId());
                result.setSuccessFlg(true);
                result.setObj(info);
            }
        } catch (Exception ex) {
            LogService.getLogger(StdManagerRestController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.GetDictFaild.toString());
        }
        return result.toJson();*/
    }

    /**
     * 查询CdaVersion用于下拉框赋值。
     *
     * @return
     */
    @RequestMapping("getCdaVersionList")
    @ResponseBody
    public Object getCdaVersionList() {
        Envelop result = new Envelop();
        String resultStr = "";
        Map<String,Object> params = new HashMap<>();

        params.put("filters", "");
        params.put("page", "");
        params.put("size", "");

        try {
            String url = "/versions";
            resultStr = HttpClientUtil.doGet(comUrl+url,username,password);

            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.GetCDAVersionListFailed.toString());
            return result;
        }
    }

    /**
     * 根据输入条件，查询字典List(过滤掉当前字典)
     *
     * @return
     */
    @RequestMapping("getCdaBaseDictList")
    @ResponseBody
    public Object getCdaBaseDictList(String strVersionCode, String dictId) {
        Envelop result = new Envelop();
        String resultStr = "";
        Map<String,Object> params = new HashMap<>();

        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(dictId)) {
            stringBuffer.append("dictId<>" + dictId);
        }
        String filters = stringBuffer.toString();
        params.put("filters", "");
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", "");
        params.put("size", "");

        if (strVersionCode == null) {
            result.setSuccessFlg(false);
            result.setErrorMsg("版本号不能为空！");
            return result;
        }
        params.put("version",strVersionCode);

        try{
            String url = "/dict";
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);

            return resultStr;

        }catch(Exception ex){
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 根据输入条件，查询字典List(过滤掉当前字典)
     *
     * @return
     */
    @RequestMapping("searchCdaBaseDictList")
    @ResponseBody
    public Object searchCdaBaseDictList(String strVersionCode, String param ,Integer page, Integer rows) {
        Envelop result = new Envelop();
        String resultStr = "";
        Map<String,Object> params = new HashMap<>();

        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(param)) {
            stringBuffer.append("code?" + param + " g1;name?" + param + " g1;");
        }
        String filters = stringBuffer.toString();
        params.put("filters", "");
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);

        if (strVersionCode == null) {
            result.setSuccessFlg(false);
            result.setErrorMsg("版本号不能为空！");
            return result;
        }
        params.put("version",strVersionCode);

        try{
            String url = "/dicts";
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);

            return resultStr;

        }catch(Exception ex){
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }
    /**
     * 查询最新版本的CdaVersion，用于初始化查询字典数据。
     *
     * @return
     */
    @RequestMapping("getLastCdaVersion")
    @ResponseBody
    public Object getLastCdaVersion() {

        //TODO 获取最新的版本信息API方法缺失
        /*String url = "/version/latestVersion";
        String strJson = "";
        try {
            strJson = HttpClientUtil.doGet(comUrl+url,username,password);
            return strJson;
        } catch (Exception ex) {
            LogService.getLogger(DictController.class).error(ex.getMessage());
            return (ErrorCode.GetCDAVersionListFailed);
        }*/

       /* try {
            String strJson = "";
            XCDAVersion cdaVersion = cdaVersionManager.getLatestVersion();
            if (cdaVersion != null) {
                CDAVersionForInterface info = new CDAVersionForInterface();
                info.setVersion(cdaVersion.getVersion());
                info.setAuthor(cdaVersion.getAuthor());
                info.setBaseVersion(cdaVersion.getBaseVersion());
                info.setCommitTime(cdaVersion.getCommitTime());
                ObjectMapper objectMapper = ServiceFactory.getService(Services.ObjectMapper);
                strJson = objectMapper.writeValueAsString(info);
            }
            RestEcho echo = new RestEcho().success();
            echo.putResultToList(strJson);
            return echo;
        } catch (Exception ex) {
            LogService.getLogger(StdManagerRestController.class).error(ex.getMessage());
            return failed(ErrorCode.GetCDAVersionListFailed);
        }*/
        return  null;
    }

    @RequestMapping("saveDictEntry")
    @ResponseBody
    public Object saveDictEntry(String cdaVersion, String dictId, String id, String code, String value, String desc) {
        String resultStr = "";

        Envelop result = new Envelop();
        if (StringUtils.isEmpty(cdaVersion)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("版本号不能为空！");
            return result;
        }
        if (StringUtils.isEmpty(dictId)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("字典ID不能为空！");
            return result;
        }
        if (StringUtils.isEmpty(id)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("ID不能为空！");
            return result;
        }
        if (StringUtils.isEmpty(code)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("代码不能为空！");
            return result;
        }
        if (StringUtils.isEmpty(value)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("值不能为空！");
            return result;
        }

        Map<String, Object> params = new HashMap<>();
        DictEntryModel dictEntryModel = new DictEntryModel();
        dictEntryModel.setId(Long.parseLong(id));
        dictEntryModel.setDictId(Long.parseLong(dictId));
        dictEntryModel.setCode(code);
        dictEntryModel.setValue(value);
        dictEntryModel.setDesc(desc);

        params.put("version_code",cdaVersion);
        params.put("json_data",toJson(dictEntryModel));

        try{
            String url = "/dict_entry";
            resultStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return resultStr;

        }catch(Exception ex){
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }

       /* Result result = new Result();
        try {
            Long entryId = id.equals("") ? 0 : Long.parseLong(id);
            if (cdaVersion == null || cdaVersion.equals("")) {
                return missParameter("stdVersion");
            }
            XCDAVersion xcdaVersion = cdaVersionManager.getVersion(cdaVersion);
            if (xcdaVersion == null)
                return failed(ErrorCode.GetCDAVersionFailed);
            Long dictIdForEntry = dictId.equals("") ? 0 : Long.parseLong(dictId);
            if (dictIdForEntry == 0) {
                return missParameter("DictId");
            }
            XDict xDict = dictManager.getDict(dictIdForEntry, xcdaVersion);
            if (code == null || code.equals("")) {
                return missParameter("Code");
            }
            if (value == null || value.equals("")) {
                return missParameter("Value");
            }
            XDictEntry xDictEntry = new DictEntry();
            if(entryId!=0){
                xDictEntry = dictEntryManager.getEntries(entryId, xDict);
                if(!code.equals(xDictEntry.getCode())){
                    if(dictEntryManager.isDictEntryCodeExist(xDict, code)){
                        result.setErrorMsg("codeNotUnique");
                        return result;
                    }
                }
            }
            else{
                if(dictEntryManager.isDictEntryCodeExist(xDict, code)){
                    result.setErrorMsg("codeNotUnique");
                    return result;
                }
            }
            xDictEntry.setId(entryId);
            xDictEntry.setDict(xDict);
            xDictEntry.setCode(code);
            xDictEntry.setValue(value);
            xDictEntry.setDesc(desc);
            int resultFlag = dictEntryManager.saveEntry(xDictEntry);
            if (resultFlag >= 1) {
                result.setSuccessFlg(true);
                return result.toJson();
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.saveDictEntryFailed.toString());
                return result.toJson();
            }
        } catch (Exception ex) {
            LogService.getLogger(StdManagerRestController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.saveDictEntryFailed.toString());
            return result.toJson();
        }*/
    }

    @RequestMapping("deleteDictEntry")
    @ResponseBody
    public Object deleteDictEntry(String cdaVersion, String dictId, String entryId) {
        Envelop result = new Envelop();
        String resultStr = "";

        Map<String,Object> params = new HashMap<>();
        params.put("versionCode",cdaVersion);
        //params.put("dictId",dictId); 字典ID项不需要

        String[] entryIds = new String[1];
        entryIds[0] = entryId;
        params.put("entryIds",entryIds);

        try{
            String url = "/dict_entry";
            resultStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return resultStr;

        }catch(Exception ex){
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    @RequestMapping("deleteDictEntryList")
    @ResponseBody
    public Object deleteDictEntryList(String cdaVersion,String dictId, String id) {
        Envelop result = new Envelop();
        String resultStr = "";
        if (StringUtils.isEmpty(cdaVersion)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("版本号不能为空！");
            return result;
        }
        try{
            String url = "/dict_entry";
            Map<String,Object> params = new HashMap<>();
            params.put("versionCode",cdaVersion);
            //params.put("dictId",dictId);
            params.put("entryIds",id);
            resultStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            result = getEnvelop(resultStr);

            if(result.isSuccessFlg()){
                result.setSuccessFlg(true);
            }else{
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.DeleteDictEntryFailed.toString());
            }
        }catch(Exception ex){
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return result;
    }

    @RequestMapping("searchDictEntryList")
    @ResponseBody
    public Object searchDictEntryList(Long dictId, String searchNmEntry, String strVersionCode, Integer page, Integer rows) {
        Envelop result = new Envelop();
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();

        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("dictId=" + dictId);
        if (!StringUtils.isEmpty(searchNmEntry)) {
            stringBuffer.append(";value?" + searchNmEntry + " g1;code?" + searchNmEntry + " g1");
        }

        String filters = stringBuffer.toString();
        params.put("filters", "");
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        params.put("fields", "");
        params.put("sorts", "");

        if (strVersionCode == null) {
            result.setSuccessFlg(false);
            result.setErrorMsg("版本号不能为空！");
            return result;
        }
        params.put("version",strVersionCode);

        try{
            String url = "/dict_entrys";
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;

        }catch(Exception ex){
//            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }

 /*       Result result = new Result();
        if (strVersionCode == null) {
            return missParameter("version_code");
        }
        try {
            XCDAVersion xcdaVersion = cdaVersionManager.getVersion(strVersionCode);
            XDict xDict = dictManager.getDict(dictId, xcdaVersion);
            XDictEntry[] xDictEntries = dictManager.getDictEntries(xDict, searchNmEntry, page, rows);
            int totalCount = dictManager.getDictEntriesForInt(xDict, searchNmEntry);
            if (xDictEntries != null) {
                XDictEntryForInterface[] infos = new DictEntryForInterface[xDictEntries.length];
                int i = 0;
                for (XDictEntry xDictEntry : xDictEntries) {
                    XDictEntryForInterface info = new DictEntryForInterface();
                    info.setId(String.valueOf(xDictEntry.getId()));
                    info.setCode(xDictEntry.getCode());
                    info.setValue(xDictEntry.getValue());
                    info.setDictId(String.valueOf(xDictEntry.getDictId()));
                    info.setDesc(xDictEntry.getDesc());
                    infos[i] = info;
                    i++;
                }
                result = getResult(Arrays.asList(infos), totalCount, page, rows);
            }
        } catch (Exception ex) {
            LogService.getLogger(StdManagerRestController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.GetDictEntryListFailed.toString());
        }

        return result.toJson();*/
    }

    @RequestMapping("getDictEntry")
    @ResponseBody
    public Object getDictEntry(String id, String dictId, String strVersionCode) {
        Envelop result = new Envelop();
        String resultStr = "";
        String url = "/dict_entry";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("versionCode",strVersionCode);
            params.put("dictId",dictId);
            params.put("entryId",id);
            resultStr = HttpClientUtil.doGet(comUrl+url,params,username,password);

            return resultStr;

        }catch(Exception ex){
            LogService.getLogger(DictController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());

            return result;
        }


        /*Result result = new Result();
        Long dictEntryId = id.equals("") ? 0 : Long.parseLong(id);
        Long dictIdForEntry = dictId.equals("") ? 0 : Long.parseLong(dictId);
        XCDAVersion xcdaVersion = cdaVersionManager.getVersion(strVersionCode);
        XDict xDict = dictManager.getDict(dictIdForEntry, xcdaVersion);
        try {
            XDictEntry xDictEntry = dictEntryManager.getEntries(dictEntryId, xDict);
            if (xDictEntry != null) {
                XDictEntryForInterface info = new DictEntryForInterface();
                info.setId(String.valueOf(xDictEntry.getId()));
                info.setCode(xDictEntry.getCode());
                info.setValue(xDictEntry.getValue());
                info.setDictId(String.valueOf(xDictEntry.getDictId()));
                info.setDesc(xDictEntry.getDesc());
                result.setSuccessFlg(true);
                result.setObj(info);
            }
        } catch (Exception ex) {
            LogService.getLogger(StdManagerRestController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.GetDictEntryListFailed.toString());
        }
        return result.toJson();*/
    }


    @RequestMapping("/importFromExcel")
    @ResponseBody
    public void importMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        UserDetailModel user = getCurrentUserRedis(request);
        try {
            String version = request.getParameter("version");
            if(StringUtils.isBlank(version)){
                throw new RuntimeException("版本号不能为空！");
            }
            writerResponse(response, 1 + "", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new DictionaryMsgReader();
            excelReader.read(file.getInputStream());
            List<DictionaryMsg> errorLs = excelReader.getErrorLs();
            List<DictionaryMsg> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 35+"", "l_upd_progress");

            //保存验证通过数据
            List saveLs = new ArrayList<>();
            if(correctLs.size()>0){
                Set<String> codes = findExistCode(toJson(excelReader.getRepeat().get("code")),version);
                writerResponse(response, 45+"", "l_upd_progress");
                if(codes.size()>0){
                    DictionaryMsg model;
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
                new DictionaryMsgWriter().write(new File(TemPath.getFullPath(eFile, parentFile)), errorLs);
                rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
            }
            writerResponse(response, 65 + "", "l_upd_progress");

            if(saveLs.size()>0)
                saveDicts(toJson(saveLs),version);
            if(errorLs.size()==0)
                writerResponse(response, 100 + ",'suc'", "l_upd_progress");
            else
                writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");

        } catch (Exception e) {
            e.printStackTrace();
            writerResponse(response, "-1", "l_upd_progress");
        }
    }

    private List saveDicts(String dicts,String version) throws Exception {
        Map map = new HashMap<>();
        map.put("model", dicts);
        map.put("version",version);
        Envelop envelop = getEnvelop(HttpClientUtil.doPost(comUrl + "/dict/entry/batch", map,username,password));
        if(envelop!=null&&envelop.isSuccessFlg())
            return envelop.getDetailModelList();
        throw new Exception("保存失败！");
    }

    private Set<String> findExistCode(String codes,String version) throws Exception {
        HashMap<String,Object> conditionMap = new HashMap<>();
        conditionMap.put("codes", codes);
        conditionMap.put("version", version);
        RestTemplates template = new RestTemplates();
        String rs = HttpClientUtil.doPost(comUrl + "/dict/codes/existence", conditionMap,username,password);
        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }

    protected void writerResponse(HttpServletResponse response, String body, String client_method) throws IOException {
        StringBuffer sb = new StringBuffer();
        sb.append("<script type=\"text/javascript\">//<![CDATA[\n");
        sb.append("     parent.").append(client_method).append("(").append(body).append(");\n");
        sb.append("//]]></script>");

        response.setContentType("text/html;charset=UTF-8");
        response.addHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
        response.setHeader("Cache-Control", "pre-check=0,post-check=0");
        response.setDateHeader("Expires", 0);
        response.getWriter().write(sb.toString());
        response.flushBuffer();
    }

    @RequestMapping("/exportToExcel")
    //@ResponseBody
    public void exportToExcel(HttpServletResponse response,String versionCode,String versionName){
        Envelop envelop = new Envelop();
        try {
            String fileName = "标准字典";
            String url="";
            String envelopStr = "";
            //设置下载
            response.setContentType("octets/stream");
            response.setHeader("Content-Disposition", "attachment; filename="
                    + new String( fileName.getBytes("gb2312"), "ISO8859-1" )+versionName+".xls");
            OutputStream os = response.getOutputStream();
            //获取导出字典
            Map<String,Object> params = new HashMap<>();
            url = "/dicts";
            params.put("fields","");
            params.put("filters","");
            params.put("sorts","+id");
            params.put("page",1);
            params.put("size",999);
            params.put("version",versionCode);
            envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop dictEnvelop = getEnvelop(envelopStr);
            List<DictModel> dictModelList = (List<DictModel>)getEnvelopList(dictEnvelop.getDetailModelList(),new ArrayList<DictModel>(),DictModel.class) ;
            //获取导出字典项
            params = new HashMap<>();
            url = "/dict_entrys";
            params.put("fields","");
            String ids="";
            DictModel dictModel;
            for(int i=0;i<dictModelList.size();i++){
                dictModel = dictModelList.get(i);
                if(i!=0){
                    ids+=",";
                }
                ids +=dictModel.getId();
            }
            params.put("filters","dictId="+ids);
            params.put("sorts","+dictId");
            params.put("page",1);
            params.put("size",9999999);
            params.put("version",versionCode);
            envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop dictEntryEnvelop = getEnvelop(envelopStr);
            List<DictEntryModel> dictEntryModelList = (List<DictEntryModel>)getEnvelopList(dictEntryEnvelop.getDetailModelList(), new ArrayList<DictEntryModel>(), DictEntryModel.class) ;

            //写excel
            WritableWorkbook wwb = Workbook.createWorkbook(os);
            int k=0;
            DictModel dict=null;
            DictEntryModel dictEntry=null;
            for(int i=0;i<dictModelList.size();i++){
                dict=dictModelList.get(i);
                //创建Excel工作表 指定名称和位置
                WritableSheet ws = wwb.createSheet(dict.getName(),i);
                addStaticCell(ws);//添加固定信息，题头等
                //添加字典信息
                addCell(ws,1,0,dict.getCode());//代码
                addCell(ws,1,1,dict.getName());//名称
                addCell(ws,1,2,dict.getDescription());//说明

                //添加字典项信息
                WritableCellFormat wc = new WritableCellFormat();
                wc.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN, Colour.SKY_BLUE);//边框
                for(int j=0;k<dictEntryModelList.size(); j++,k++){
                    dictEntry = (DictEntryModel)dictEntryModelList.get(k);
                    if (dict.getId()!=dictEntry.getDictId()){
                        break;
                    }
                    addCell(ws,3,j,dictEntry.getCode(),wc);//代码
                    addCell(ws,4,j,dictEntry.getValue(),wc);//名称
                }
            }
            //写入工作表
            wwb.write();
            wwb.close();
            os.flush();
            os.close();
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
    }

    //字典字典项整体入库
    private Envelop saveData(DictModel dict,List<DictEntryModel> dictEntryModelList,String versionCode){
        Envelop ret = new Envelop();
        String url = "/save_dict";
        Map<String,Object> params = new HashMap<>();
        params.put("version_code",versionCode);
        long dictId;
        DictModel dictModel=null;
        List<DictEntryModel> dictEntryModels = new ArrayList<>();
        try {
            //字典入库
            params.put("json_data",toJson(dict));
            String envelopStrNew = HttpClientUtil.doPost(comUrl+url,params,username,password);
            Envelop envelop = getEnvelop(envelopStrNew);
            if (envelop.isSuccessFlg()){
                dictModel = getEnvelopModel(envelop.getObj(),DictModel.class);
                dictId = dictModel.getId();
                //字典项入库
                url = "/dict_entry";
                if (dictEntryModelList.size()>0){
                    for (DictEntryModel dictEntry : dictEntryModelList) {
                        dictEntry.setDictId(dictId);
                        params.remove("json_data");
                        params.put("json_data",toJson(dictEntry));
                        envelopStrNew = HttpClientUtil.doPost(comUrl+url,params,username,password);
                        envelop = getEnvelop(envelopStrNew);
                        //新增成功后的字典项集合
                        if (envelop.isSuccessFlg()) {
                            DictEntryModel dictEntryModel = getEnvelopModel(envelop.getObj(),DictEntryModel.class);
                            dictEntryModels.add(dictEntryModel);
                        }
                    }
                }

            }
            //返回信息
            ret.setSuccessFlg(true);
            ret.setObj(dictModel);
            ret.setDetailModelList(dictEntryModels);
            return ret;
        } catch (Exception e) {
            e.printStackTrace();
            ret.setSuccessFlg(false);
            return ret;
        }
    }
    //excel中添加固定内容
    private void addStaticCell(WritableSheet ws){
        try {
            addCell(ws,0,0,"代码");
            addCell(ws,0,1,"名称");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //添加单元格内容
    private void addCell(WritableSheet ws,int column,int row,String data){
        try {
            Label label = new Label(column,row,data);
            ws.addCell(label);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //添加单元格内容带样式
    private void addCell(WritableSheet ws,int column,int row,String data,CellFormat cellFormat){
        try {
            Label label = new Label(column,row,data,cellFormat);
            ws.addCell(label);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
