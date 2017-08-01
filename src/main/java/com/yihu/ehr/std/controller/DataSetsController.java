package com.yihu.ehr.std.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.standard.datasset.DataSetModel;
import com.yihu.ehr.agModel.standard.datasset.MetaDataModel;
import com.yihu.ehr.agModel.standard.dict.DictModel;
import com.yihu.ehr.agModel.standard.standardsource.StdSourceModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.std.model.DataSetMsg;
import com.yihu.ehr.std.model.MetaDataMsg;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.excel.read.DataSetMsgReader;
import com.yihu.ehr.util.excel.read.DataSetMsgWriter;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import javafx.util.Pair;
import jxl.Sheet;
import jxl.Workbook;
import jxl.format.CellFormat;
import jxl.format.UnderlineStyle;
import jxl.write.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.Boolean;
import java.util.*;


/**
 * @author Sand
 * @version 1.0
 * @created 2015.07.14 17:59
 */
@Controller
@RequestMapping("/std/dataset")
public class DataSetsController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.stdurl}")
    private String comUrl;
    @Value("${service-gateway.url}")
    private String adminUrl;
    @Value("${service-gateway.stdsourceurl}")
    private String stdSrcUrl;

    //    @RequestMapping("/initial")
//    public String dataSetInitial() {
//        return "/std/dataset/dataSet";
//    }
    @Autowired
    ObjectMapper objectMapper ;

    @RequestMapping("/initial")
    public String setInitial(Model model) {
        model.addAttribute("contentPage", "std/dataset/set");
        return "pageView";
    }

    @RequestMapping("setupdate")
    public String setUpdate(Model model) {
        model.addAttribute("contentPage", "std/dataset/setUpdate");
        return "generalView";
    }

    @RequestMapping("elementupdate")
    public String elementUpdate(Model model) {
        model.addAttribute("contentPage", "std/dataset/elementUpdate");
        return "generalView";
    }

    /**
     * 数据集分页查询
     * @param codename
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("/searchDataSets")
    @ResponseBody
    public Object searchDataSets(String codename, String version, int page, int rows) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        if (StringUtils.isEmpty(version)) {
            envelop.setErrorMsg("请选择版本号！");
            return envelop;
        }
        String filters = "";
        if (!StringUtils.isEmpty(codename)){
            filters += "name?"+codename+" g1;code?"+codename+" g1;";

        }
        String url = "/data_sets";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            params.put("version",version);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping("/deleteDataSet")
    @ResponseBody
    public Object deleteDataSet(Long dataSetId, String version) {
        Envelop envelop = new Envelop();
        if (StringUtils.isEmpty(dataSetId) || dataSetId.equals(0)) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("数据集id和版本号不能为空!");
            return envelop;
        }
        String url = "/data_set/"+dataSetId;
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("version",version);
            params.put("id",dataSetId);
            String envelopStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping(value = "/getDataSet", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object getDataSet(Long dataSetId,String versionCode) {
        Envelop envelop = new Envelop();
        if (StringUtils.isEmpty(dataSetId) || dataSetId.equals(0)) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("数据集Id和版本号不能为空!");
            return envelop;
        }
        String url = "/data_set/"+dataSetId;
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("version",versionCode);
            params.put("id",dataSetId);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return envelopStr;
        }catch(Exception ex){
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping("/saveDataSet")
    @ResponseBody
    public Object saveDataSet(long id, String code, String name, String type, String refStandard, String summary, String versionCode) {
        //新增、修改数据集
        Envelop envelop = new Envelop();
        String strErrorMsg = "";
        if(StringUtils.isEmpty(code)) {
            strErrorMsg += "代码不能为空!";
        }
        if (StringUtils.isEmpty(name)) {
            strErrorMsg += "名称不能为空!";
        }
        if (StringUtils.isEmpty(type)) {
            strErrorMsg += "标准来源不能为空!";
        }
        if (StringUtils.isEmpty(refStandard)) {
            strErrorMsg += "标准版本不能为空!";
        }
        if (StringUtils.isEmpty(strErrorMsg)) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(strErrorMsg);
            return envelop;
        }
        String url = "/data_set";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("version_code",versionCode);
            //新增数据集
            if(id == 0){
                DataSetModel modelNew = new DataSetModel();
                modelNew.setCode(code);
                modelNew.setName(name);
                modelNew.setReference(refStandard);
                modelNew.setSummary(summary);
                //TODO 数库保存的是版本名称，待查询
                modelNew.setStdVersion(versionCode);
                String jsonDataNew = objectMapper.writeValueAsString(modelNew);
                params.put("json_data",jsonDataNew);
                String envelopStrNew = HttpClientUtil.doPost(comUrl+url,params,username,password);
                return envelopStrNew;
            }

            //修改数据集
            //获取原数据集对象
            String urlGet = "/data_set/"+id;
            Map<String,Object> args = new HashMap<>();
            args.put("id",id);
            args.put("version",versionCode);
            String envelopStrGet = HttpClientUtil.doGet(comUrl+urlGet,args,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
            if (!envelopGet.isSuccessFlg()){
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("获取标准数据集失败！");
                return envelop;
            }
            DataSetModel modelForUpdate = getEnvelopModel(envelopGet.getObj(),DataSetModel.class);
            modelForUpdate.setCode(code);
            modelForUpdate.setName(name);
            modelForUpdate.setReference(refStandard);
            modelForUpdate.setSummary(summary);
            String dataJsonUpdate = objectMapper.writeValueAsString(modelForUpdate);
            params.put("json_data",dataJsonUpdate);
            String envelopStrUpdate = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return envelopStrUpdate;
        }catch(Exception ex){
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping("/searchMetaData")
    @ResponseBody
    public Object searchMetaData(Long id, String version, String metaDataCode, int page, int rows) {
        Envelop result = new Envelop();
        if (StringUtils.isEmpty(id) || id.equals(0) || StringUtils.isEmpty(version)|| version.equals(0)) {
            result.setSuccessFlg(false);
            result.setErrorMsg("数据集id、标准版本不能为空!");
            return result;
        }
        String url = "/meta_datas";
        String filters = "dataSetId="+id+";";
        if(!StringUtils.isEmpty(metaDataCode)){
            filters += "innerCode?"+metaDataCode+" g1;name?"+metaDataCode+" g1;";
        }
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            params.put("version",version);
            String _rus = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if(StringUtils.isEmpty(_rus)){
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.SavedatasetFailed.toString());
            }else{
                return _rus;
            }
        }catch(Exception ex){
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return result;
    }

    @RequestMapping("/deleteMetaData")
    @ResponseBody
    public Object deleteMetaData(String ids, String version) {
        Envelop envelop = new Envelop();
        String strErrMessage = "";
        if (StringUtils.isEmpty(ids)) {
            strErrMessage += "请选择数据元!";
        }
        if (StringUtils.isEmpty(version)) {
            strErrMessage += "请选择标准版本!";
        }
        if (!strErrMessage.equals("")) {
            envelop.setErrorMsg(strErrMessage);
            envelop.setSuccessFlg(false);
            return envelop;
        }
        try {
            String url = "/meta_data";
            Map<String,Object> params = new HashMap<>();
            params.put("ids",ids);
            params.put("version_code",version);
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        } catch (Exception ex) {
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    @RequestMapping(value = "/getMetaData", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object getMetaData(Long dataSetId, Long metaDataId, String version) {
        Envelop envelop = new Envelop();
        Envelop result = new Envelop();
        String strErrMessage = "";
        if (StringUtils.isEmpty(dataSetId) || dataSetId.equals(0)) {
            strErrMessage += "请先选择数据集!";
        }
        if (StringUtils.isEmpty(metaDataId) || metaDataId.equals(0)) {
            strErrMessage += "请先选择数据元!";
        }
        if (StringUtils.isEmpty(version) || version.equals(0)) {
            strErrMessage += "请先选择标准版本!";
        }
        if (strErrMessage != "") {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(strErrMessage);
            return envelop;
        }
        try {
            String url = "/meta_data";
            Map<String,Object> params = new HashMap<>();
            params.put("metaDataId",metaDataId);
            params.put("versionCode",version);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);

            result = getEnvelop(envelopStr);
            MetaDataModel mdModel = getEnvelopModel(result.getObj(), MetaDataModel.class);
            if(mdModel.getDictId() != 0){
                Long dictId = mdModel.getDictId();

                String urlForDict = "/dict";
                Envelop dictResult = new Envelop();
                Map<String, Object> paramsForDict = new HashMap<>();
                paramsForDict.put("dictId", dictId);
                paramsForDict.put("version_code",version);

                String dictResultStr = HttpClientUtil.doGet(comUrl + urlForDict, paramsForDict, username, password);
                dictResult = getEnvelop(dictResultStr);
                if(dictResult.isSuccessFlg()){
                    DictModel dictModel = getEnvelopModel(dictResult.getObj(),DictModel.class);
                    mdModel.setDictCode(dictModel.getCode());
                    mdModel.setDictName(dictModel.getName());
                }
            }
            else{
                mdModel.setDictCode("");
                mdModel.setDictName("");
            }

            result.setObj(mdModel);
            envelopStr = objectMapper.writeValueAsString(result);

            return envelopStr;
        } catch (Exception ex) {
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    @RequestMapping(value = "/updataMetaSet", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updataMetaSet(String info,String version) {
        //新增、合二为一
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try {
            MetaDataModel model = objectMapper.readValue(info,MetaDataModel.class);
            if(StringUtils.isEmpty(version)){
                envelop.setErrorMsg("标准版本号不能为空！");
                return envelop;
            }
            if(model.getDataSetId() == 0){
                envelop.setErrorMsg("数据集id不能为空！");
                return envelop;
            }
            if(StringUtils.isEmpty(model.getCode())){
                envelop.setErrorMsg("数据元编码不能为空！");
                return envelop;
            }
            if(StringUtils.isEmpty(model.getName())){
                envelop.setErrorMsg("数据元名称不能为空！");
                return envelop;
            }
            if(StringUtils.isEmpty(model.getInnerCode())){
                envelop.setErrorMsg("数据元内部编码不能为空！");
                return envelop;
            }
            if(StringUtils.isEmpty(model.getColumnName())){
                envelop.setErrorMsg("数据元对应列名不能为空！");
                return envelop;
            }

            String url = "/meta_data";
            Map<String,Object> params = new HashMap<>();
            params.put("version",version);

            //新增数据元操作
            if(model.getId() ==0){
                params.put("json_data",info);
                String envelopStrNew = HttpClientUtil.doPost(comUrl+url,params,username,password);
                return envelopStrNew;
            }

            //修改数据元操作
            //获取原数据元对象
            String urlGet = "/meta_data";
            Map<String,Object> args = new HashMap<>();
            args.put("versionCode",version);
            args.put("metaDataId",model.getId());
            String envelopStrGet = HttpClientUtil.doGet(comUrl+urlGet,args,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
            if(!envelopGet.isSuccessFlg()){
                envelop.setErrorMsg("数据元不存在！");
                return envelop;
            }
            String mStr = objectMapper.writeValueAsString(envelopGet.getObj());
            MetaDataModel modelForUpdate = objectMapper.readValue(mStr, MetaDataModel.class);
            //设置修改值
            modelForUpdate.setCode(model.getCode());
            modelForUpdate.setName(model.getName());
            modelForUpdate.setInnerCode(model.getInnerCode());
            modelForUpdate.setType(model.getType());
            modelForUpdate.setDictId(model.getDictId());
            modelForUpdate.setFormat(model.getFormat());
            modelForUpdate.setDefinition(model.getDefinition());
            modelForUpdate.setColumnName(model.getColumnName());
            modelForUpdate.setColumnLength(model.getColumnLength());
            modelForUpdate.setColumnType(model.getColumnType());
            modelForUpdate.setNullable(model.isNullable());
            modelForUpdate.setPrimaryKey(model.isPrimaryKey());
            String metaDataJson = objectMapper.writeValueAsString(modelForUpdate);
            params.put("json_data",metaDataJson);
            String envelopStrUpdate = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return envelopStrUpdate;
        } catch (Exception ex) {
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    /**
     * 检验字典查询的方法
     * @param version
     * @return
     */
    @RequestMapping(value = "/getMetaDataDict", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String getMetaDataDict(String version, String param , Integer page, Integer rows) {
        String strResult = "[]";
        try {
            String url = "/std/dicts";
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
            params.put("fields","");
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            params.put("version",version);
            String envelopStr = HttpClientUtil.doGet(adminUrl+url,params,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStr,Envelop.class);
            if (envelopGet.isSuccessFlg()) {
                return envelopStr;
                //List<DictModel> dictModels = (List<DictModel>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<DictModel>(),DictModel.class);
                //strResult = objectMapper.writeValueAsString(dictModels);
            }

        } catch (Exception ex) {
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
        }
        return strResult;
    }


    /**
     * 验证数据元内部编码是否存在
     * @param version
     * @param datasetId
     * @param searchNm
     * @param metaDataCodeMsg
     * @return
     */
    @RequestMapping("/validatorMetadata")
    @ResponseBody
    public Object validatorMetadata(String version, String datasetId, String searchNm, String metaDataCodeMsg) {
        Envelop envelop = new Envelop();
        String url ="/meta_data/is_exist/inner_code";
        try{
            Map<String,Object> params = new HashMap<>();
            params.put("version",version);
            params.put("dataSetId",datasetId);
            params.put("inner_code",searchNm);
            String _msg = HttpClientUtil.doGet(comUrl+url,params,username,password);
            if(Boolean.parseBoolean(_msg)){
                envelop.setSuccessFlg(true);
            }else{
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("验证失败");
            }
        }catch(Exception ex){
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    /**
     * 将CDA归属的数据集信息转换的XML信息
     *
     * @param setId       数据集ID
     * @param versionCode 版本号
     * @return xml信息
     */
    @RequestMapping("/getXMLInfoByDataSetId")
    @ResponseBody
    public Object getXMLInfoByDataSetId(String setId, String versionCode) {

        try {
            String strResult = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><root>";
            Envelop envelop = new Envelop();
            if (StringUtils.isEmpty(setId)) {
                envelop.setSuccessFlg(true);
                envelop.setObj(strResult += "</root>");
                return envelop;
            }

            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> params = new HashMap<>();
            params.put("ids", setId);
            params.put("version", versionCode);

            //根据 dataSetIds 查询数据集信息
            String rs = HttpClientUtil.doGet(comUrl + "/getData_sets", params, username, password);
            EnvelopExt<DataSetModel> envelopExt = mapper.readValue(rs, new TypeReference<EnvelopExt<DataSetModel>>() {});

            if (envelopExt.getDetailModelList().size() > 0) {
                String dataSetIds = "";
                for (DataSetModel dataSetModel : envelopExt.getDetailModelList()){
                    dataSetIds += "," + dataSetModel.getId();
                }

                params.put("data_set_ids", dataSetIds.substring(1));
                rs = HttpClientUtil.doGet(comUrl + "/getMetaDataByDataSetId", params, username, password);
                Envelop metaEvn = mapper.readValue(rs, Envelop.class);

                List<Map<String, String>> metaDataModelList = metaEvn.getDetailModelList();
                Map<String, String> metaDataModel;
                int j = 0;
                for (DataSetModel dataSetModel : envelopExt.getDetailModelList()){
                    strResult += "<" + dataSetModel.getCode() + ">";

                    for(; j < metaDataModelList.size(); j++){
                        metaDataModel = metaDataModelList.get(j);
                        if(String.valueOf(dataSetModel.getId()).equals(String.valueOf(metaDataModel.get("dataSetId"))))
                            strResult += "<" + metaDataModel.get("columnName") + "></" + metaDataModel.get("columnName") + ">";
                        else
                            break;
                    }

                    strResult += "</" + dataSetModel.getCode() + ">";
                }
            }

            strResult += "</root>";
            envelop.setSuccessFlg(true);
            envelop.setObj(strResult);
            return envelop;
        } catch (Exception ex) {
            LogService.getLogger(DataSetsController.class).error(ex.getMessage());
            return failed("系统出错！");
        }
    }

    @RequestMapping("/importFromExcel")
    @ResponseBody
    public Object importFromExcel(HttpServletRequest request,String versionCode){
        Envelop envelop = new Envelop();
        String resultStr="";
        Envelop envelopTemp;
        try {
            request.setCharacterEncoding("UTF-8");
            InputStream inputStream = request.getInputStream();
            Workbook rwb = Workbook.getWorkbook(inputStream);
            Sheet[] sheets = rwb.getSheets();
            String strErrorMsg="";
            int rows;
            int row;
            //批量入库
            List<Pair<DataSetModel,List<MetaDataModel>>> allData = new ArrayList<>();
            Pair<DataSetModel,List<MetaDataModel>> pair=null;
            List<Envelop> saveDatas = new ArrayList<>();
            Envelop saveData;   //obj对应DataSetModel,detailModelList对应List<MetaDataModel>
            //数据集信息
            DataSetModel dataSet;
            String sheetName; //sheet名字
            String dataSetName;//名称
            String dataSetCode;//标识
            String reference;//参考
            String summary;
            //数据元信息
            List<DictModel> dictModelList;
            Set<String> set;
            String dictUrl = "/dicts";
            Map<String,Object> dictParams ;
            String dictFilters ;
            List<MetaDataModel> metaDataList;
            MetaDataModel metaData;
            String innerCode;//内部标识
            String code ;//数据元编码
            String name;//数据元名称
            String definition;//数据元定义
            String type ;//数据类型
            String format ;//表示形式
            String dictCode ;//术语范围值
            String columnName ;//列名
            String columnType ;//列类型
            String columnLength;//列长度
            String primaryKey;//主键
            String nullable ;//可为空
            boolean pk;
            boolean nullAble;
            long dictId = 0;
            for (Sheet sheet : sheets) {
                dataSet = new DataSetModel();
                dataSet.setStdVersion(versionCode);
                //获取数据集信息
                sheetName = sheet.getName(); //sheet名字
                dataSetName = sheet.getCell(1, 0).getContents();//名称
                dataSetCode = sheet.getCell(1, 1).getContents();//标识
                reference = sheet.getCell(1, 2).getContents();//参考
                summary = sheet.getCell(1, 3).getContents();//备注

                //todo：test--测试时备注做区别，方便删除测试，summary变量区别
                //summary="测试excel导入";
                //todo：test--测试时code区别，否则测试不成功，因为code唯一
                //dataSetCode = dataSetCode+"excel";

                //数据集校验
                if (isExistDataSetCode(dataSetCode, versionCode)){
                    strErrorMsg = sheetName+"数据集标识已存在，请检查！";
                }
                if (dataSetName==null || dataSetName.equals("")){
                    strErrorMsg = sheetName+"数据集名称不能为空，请检查！";
                }
                if (dataSetCode==null || dataSetCode.equals("")){
                    strErrorMsg = sheetName +"数据集标识不能为空，请检查！";
                }
                if (!StringUtils.isEmpty(strErrorMsg)) {
                    //数据集校验
                    envelop.setSuccessFlg(false);
                    envelop.setErrorMsg(strErrorMsg);
                    return envelop;
                }
                //插入数据集信息
                dataSet.setCode(dataSetCode);//code唯一
                dataSet.setName(dataSetName);
                dataSet.setReference(reference);//标准来源
                dataSet.setStdVersion(versionCode);
                dataSet.setSummary(summary);

                //获取数据元信息
                set = new HashSet<String>();
                metaDataList = new ArrayList<>();
                rows = sheet.getRows();
                for (int j = 0; j < rows - 5; j++) {
                    dictId = 0;
                    metaData = new MetaDataModel();
                    row = j + 5;
                    innerCode = sheet.getCell(1, row).getContents();//内部标识
                    code = sheet.getCell(2, row).getContents();//数据元编码
                    name = sheet.getCell(3, row).getContents();//数据元名称
                    definition = sheet.getCell(4, row).getContents();//数据元定义
                    type = sheet.getCell(5, row).getContents();//数据类型
                    format = sheet.getCell(6, row).getContents();//表示形式
                    dictCode = sheet.getCell(7, row).getContents();//术语范围值
                    columnName = innerCode;//列名取内部标识
                    columnType = getColumnType(type);//根据数据类型获取列类型
                    columnLength = getColumnLength(type,format);//根据数据类型和标识格式获取列长度
                    primaryKey = sheet.getCell(11, row).getContents();//主键
                    nullable = sheet.getCell(12, row).getContents();//可为空
                    pk=primaryKey.equals("1");
                    nullAble=nullable.equals("1");

                    //todo：test--测试时备注做区别，方便删除测试，definition变量区别
                    //definition="测试excel导入";

                    //数据元的校验，一个不通过则全部不保存
                    if (innerCode==null || innerCode.equals("")){
                        strErrorMsg = sheetName+"第"+(row+1)+"行内部标识不能为空，请检查！";
                    }else{
                        //innerCode要唯一
                        set.add(innerCode);
                        if (set.toArray(new String[set.size()]).length != j+1){
                            //innerCode重复
                            strErrorMsg = sheetName+"第"+(row+1)+"行内部标识已存在，请检查！";
                        }
                    }
                    if (code==null || code.equals("")){
                        strErrorMsg = sheetName+"第"+(row+1)+"行数据元编码不能为空，请检查！";
                    }
                    if (name==null || name.equals("")){
                        strErrorMsg = sheetName+"第"+(row+1)+"行数据元名称不能为空，请检查！";
                    }
                    if (pk && nullAble){
                        strErrorMsg = sheetName+"第"+(row+1)+"行主键不能为空，请检查！";
                    }
                    //关联字典是否已经导入
                    if (!StringUtils.isEmpty(dictCode)){
                        dictParams = new HashMap<>();
                        dictFilters = "code=" + dictCode + " g1";
                        dictParams.put("filters", dictFilters);
                        dictParams.put("version",versionCode);
                        dictParams.put("page", 1);
                        dictParams.put("size", 1);
                        resultStr = HttpClientUtil.doGet(comUrl + dictUrl, dictParams, username, password);
                        envelopTemp = getEnvelop(resultStr);
                        if (envelopTemp.getDetailModelList().size()!= 0){
                            dictModelList = (List<DictModel>)getEnvelopList(envelopTemp.getDetailModelList(),new ArrayList<DictModel>(),DictModel.class) ;
                            dictId = dictModelList.get(0).getId();
                        }else{
                            strErrorMsg = sheetName+"第"+(row+1)+"行术语范围值查找不到，请先导入标准字典！";
                        }
                    }
                    if (!StringUtils.isEmpty(strErrorMsg)) {
                        //数据元校验
                        envelop.setSuccessFlg(false);
                        envelop.setErrorMsg(strErrorMsg);
                        return envelop;
                    }
                    //插入数据元信息
                    metaData.setId(0);//为0内部自增
                    metaData.setDataSetId(dataSet.getId());
                    metaData.setCode(code);
                    metaData.setName(name);
                    metaData.setInnerCode(innerCode);
                    metaData.setType(type);
                    metaData.setDictId(dictId);
                    metaData.setFormat(format);
                    metaData.setDefinition(definition);
                    metaData.setColumnName(columnName);
                    metaData.setColumnLength(columnLength);
                    metaData.setColumnType(columnType);
                    metaData.setPrimaryKey(pk);
                    metaData.setNullable(nullAble);
                    metaDataList.add(metaData);
                }
                //缓存，后面数据集、数据元批量入库
                pair = new Pair<>(dataSet,metaDataList);
                allData.add(pair);
            }
            //批量入库
            for(Pair<DataSetModel,List<MetaDataModel>> pairTemp:allData){
                saveData = saveData(pairTemp.getKey(),pairTemp.getValue(),versionCode);//保存数据集、数据元信息
                saveDatas.add(saveData);
            }

            //关闭
            rwb.close();
            inputStream.close();
            //todo：汇总返回前台展示,saveDatas处理
            envelop.setObj(saveDatas);
            envelop.setSuccessFlg(true);
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;
    }

    //根据数据类型获取列类型
    private String getColumnType(String type) {
        //数据类型S（字符型）、L（布尔型）、N（数值型）、D（日期型）、DT（日期时间型）、T（时间型）、BY（二进制）
        String columnType = "VARCHAR";
        switch (type){
            case "L":
                columnType = "VARCHAR";
                break;
            case "N":
                columnType = "NUMERIC";
                break;
            case "D":
                columnType = "DATE";
                break;
            case "DT":
                columnType = "DATETIME";
                break;
            case "T":
                columnType = "DATETIME";
                break;
            case "BY":
                columnType = "BLOB";
                break;
        }
        return columnType;
    }
    //根据标识格式获取列长度
    private String getColumnLength(String type,String format) {
        //只取后面的数字
        String columnLength = "";
        if (!type.equals("D") && !type.equals("DT") && !type.equals("T") && !type.equals("BY")){
            if (type.equals("L")){
                columnLength="1";
            }else{
                if (format.contains(",")){
                    format = format.replace(format.substring(format.indexOf(",")),"");
                }
                columnLength=format.replaceAll(".*[^\\d](?=(\\d+))","");
            }

        }
        return columnLength;
    }

    @RequestMapping("/exportToExcel")
    //@ResponseBody
    public void exportToExcel(HttpServletResponse response,String versionCode,String versionName){
        Envelop envelop = new Envelop();
        try {
            String fileName = "标准数据集";
            String url="";
            String envelopStr = "";
            //设置下载
            response.setContentType("octets/stream");
            response.setHeader("Content-Disposition", "attachment; filename="
                    + new String( fileName.getBytes("gb2312"), "ISO8859-1" )+versionName+".xls");
            OutputStream os = response.getOutputStream();
            //获取导出数据集
            Map<String,Object> params = new HashMap<>();
            url = "/data_sets";
            params.put("fields","");
            params.put("filters","");
            params.put("sorts","+id");
            params.put("page",1);
            params.put("size",999);
            params.put("version",versionCode);
            envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop dataSetEnvelop = getEnvelop(envelopStr);
            List<DataSetModel> dataSetModelList = (List<DataSetModel>)getEnvelopList(dataSetEnvelop.getDetailModelList(),new ArrayList<DataSetModel>(),DataSetModel.class) ;
            //获取导出数据元
            params = new HashMap<>();
            url = "/meta_datas";
            params.put("fields","");
            String ids="";
            DataSetModel dataSetModel;
            for(int i=0;i<dataSetModelList.size();i++){
                dataSetModel = dataSetModelList.get(i);
                if(i!=0){
                    ids+=",";
                }
                ids +=dataSetModel.getId();
            }
            params.put("filters","dataSetId="+ids);
            params.put("sorts","+dataSetId");
            params.put("page",1);
            params.put("size",9999);
            params.put("version",versionCode);
            envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop metaDataEnvelop = getEnvelop(envelopStr);
            List<MetaDataModel> metaDataList = (List<MetaDataModel>)getEnvelopList(metaDataEnvelop.getDetailModelList(), new ArrayList<MetaDataModel>(), MetaDataModel.class) ;

            //写excel
            WritableWorkbook wwb = Workbook.createWorkbook(os);
            int k=0;
            DataSetModel dataSet=null;
            MetaDataModel metaData=null;
            int row=0;
            for(int i=0;i<dataSetModelList.size();i++){
                dataSet=dataSetModelList.get(i);
                //创建Excel工作表 指定名称和位置
                WritableSheet ws = wwb.createSheet(dataSet.getName(),i);
                addStaticCell(ws);//添加固定信息，题头等
                //添加数据集信息
                addCell(ws,1,0,dataSet.getName());//名称
                addCell(ws,1,1,dataSet.getCode());//标识
                addCell(ws,1,2,dataSet.getReferenceCode());//参考
                addCell(ws,1,3,dataSet.getSummary());//备注

                //添加数据元信息
                WritableCellFormat wc = new WritableCellFormat();
                wc.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN, Colour.SKY_BLUE);//边框
                for(int j=0;k<metaDataList.size(); j++,k++){
                    metaData = (MetaDataModel)metaDataList.get(k);
                    if (dataSet.getId()!=metaData.getDataSetId()){
                        break;
                    }
                    row=j+5;
                    addCell(ws,0,row,j+1+"",wc);//序号
                    addCell(ws,1,row,metaData.getInnerCode(),wc);//内部标识
                    addCell(ws,2,row,metaData.getCode(),wc);//数据元编码
                    addCell(ws,3,row,metaData.getName(),wc);//数据元名称
                    addCell(ws,4,row,metaData.getDefinition(),wc);//数据元定义
                    addCell(ws,5,row,metaData.getType(),wc);//数据类型
                    addCell(ws,6,row,metaData.getFormat(),wc);//表示形式
                    addCell(ws,7,row,metaData.getDictCode(),wc);//术语范围值
                    addCell(ws,8,row,metaData.getColumnName(),wc);//列名
                    addCell(ws,9,row,metaData.getColumnType(),wc);//列类型
                    addCell(ws,10,row,metaData.getColumnLength(),wc);//列长度
                    addCell(ws,11,row,metaData.isPrimaryKey()?"1":"0",wc);//主键
                    addCell(ws,12,row,metaData.isNullable()?"1":"0",wc);//可为空
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

    //判断数据集code是否已存在
    private boolean isExistDataSetCode(String dataSetCode,String versionCode){
        String url ="/data_set/is_exist/code";
        Map<String,Object> params = new HashMap<>();
        params.put("version_code",versionCode);
        params.put("code",dataSetCode);
        String _msg = null;
        try {
            _msg = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return Boolean.parseBoolean(_msg);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    //数据集数据元整体入库
    private Envelop saveData(DataSetModel dataSet,List<MetaDataModel> metaDataList,String versionCode){
        Envelop ret = new Envelop();
        String url = "/data_set";
        Map<String,Object> params = new HashMap<>();
        params.put("version_code",versionCode);
        long dataSetId;
        DataSetModel dataSetModel=null;
        List<MetaDataModel> metaDataModels = new ArrayList<>();
        try {
            //数据集入库
            String jsonDataNew = toJson(dataSet);
            params.put("json_data",jsonDataNew);
            String envelopStrNew = HttpClientUtil.doPost(comUrl+url,params,username,password);
            Envelop envelop = getEnvelop(envelopStrNew);
            if (envelop.isSuccessFlg()){
                dataSetModel = getEnvelopModel(envelop.getObj(),DataSetModel.class);
                dataSetId = dataSetModel.getId();
                //数据元入库
                url = "/meta_data";
                params.remove("version_code");
                params.put("version",versionCode);
                if (metaDataList.size()>0){
                    for (MetaDataModel metaData : metaDataList) {
                        metaData.setDataSetId(dataSetId);
                        params.remove("json_data");
                        params.put("json_data",toJson(metaData));
                        envelopStrNew = HttpClientUtil.doPost(comUrl+url,params,username,password);
                        envelop = getEnvelop(envelopStrNew);
                        //新增成功后的数据元集合
                        if (envelop.isSuccessFlg()) {
                            MetaDataModel metaDataModel = getEnvelopModel(envelop.getObj(),MetaDataModel.class);
                            metaDataModels.add(metaDataModel);
                        }
                    }
                }

            }
            //返回信息
            ret.setSuccessFlg(true);
            ret.setObj(dataSetModel);
            ret.setDetailModelList(metaDataModels);
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
            addCell(ws,0,0,"名称");
            addCell(ws,0,1,"标识");
            addCell(ws,0,2,"参考");
            addCell(ws,0,3,"备注");
            //--------------------
            WritableFont wfc = new WritableFont(WritableFont.ARIAL,12,WritableFont.NO_BOLD,false,
                    UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.WHITE);//字体：大小，加粗，颜色
            WritableCellFormat wcfFC = new WritableCellFormat(wfc);
            wcfFC.setBackground(jxl.format.Colour.LIGHT_BLUE);//北京色
            addCell(ws,0,4,"序号",wcfFC);
            addCell(ws,1,4,"内部标识",wcfFC);
            addCell(ws,2,4,"数据元编码",wcfFC);
            addCell(ws,3,4,"数据元名称",wcfFC);
            addCell(ws,4,4,"数据元定义",wcfFC);
            addCell(ws,5,4,"数据类型",wcfFC);
            addCell(ws,6,4,"表示形式",wcfFC);
            addCell(ws,7,4,"术语范围值",wcfFC);
            addCell(ws,8,4,"列名",wcfFC);
            addCell(ws,9,4,"列类型",wcfFC);
            addCell(ws,10,4,"列长度",wcfFC);
            addCell(ws,11,4,"主键",wcfFC);
            addCell(ws,12,4,"可为空",wcfFC);
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


    private static final String parentFile = "stdDataSet";
    @RequestMapping(value = "import")
    @ResponseBody
    public void importData(MultipartFile file, String version,
                           HttpServletRequest request, HttpServletResponse response) throws IOException {

        UserDetailModel user = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        try {
            writerResponse(response, 1 + "", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new DataSetMsgReader();
            excelReader.read(file.getInputStream());
            List<DataSetMsg> errorLs = excelReader.getErrorLs();
            List<DataSetMsg> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 35+"", "l_upd_progress");

            List saveLs = validate(version, response, excelReader, errorLs, correctLs);
            writerResponse(response, 55+"", "l_upd_progress");

            Map rs = new HashMap<>();
            if(errorLs.size()>0){
                String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".xls");
                new DataSetMsgWriter().write(new File(TemPath.getFullPath(eFile, parentFile)), errorLs);
                rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
            }
            writerResponse(response, 65 + "", "l_upd_progress");

            if(saveLs.size()>0)
                saveData(toJson(saveLs), version);
            if(errorLs.size()==0)
                writerResponse(response, 100 + ",'suc'", "l_upd_progress");
            else
                writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");

        } catch (Exception e) {
            e.printStackTrace();
            writerResponse(response, "-1", "l_upd_progress");
        }
    }

    private List validate(String version, HttpServletResponse response, AExcelReader excelReader,
                          List<DataSetMsg> errorLs, List<DataSetMsg> correctLs) throws Exception {
        List saveLs = new ArrayList<>();

        Set<String> codes = findExistCode(excelReader.getRepeat().get("code"), version);
//            Map<String, String> stdSources = findStdSources(excelReader.getRepeat().get("referenceCode").toString().replace("[", "").replace("]", "").replace(" ", ""));
        Map<String, String> stdSources = null;
        Map<String, String> dicts = findStdDict(version);
        String columnTypes = "VARCHAR,INT,FLOAT,DOUBLE,CHAR,TEXT,DATE,DATETIME,NUMERIC,TINYINT";
        writerResponse(response, 45+"", "l_upd_progress");
        DataSetMsg model;
        boolean valid;
        String sourceId;

        for(int i=0; i<errorLs.size(); i++){
            model = errorLs.get(i);
            if(codes.contains(model.getCode())){
                model.addErrorMsg("code", "该标识已存在！");
            }
            validateMeta(model, columnTypes, dicts) ;
        }

        for(int i=0; i<correctLs.size(); i++){
            valid = true;
            model = correctLs.get(i);
            if(codes.contains(model.getCode())){
                model.addErrorMsg("code", "该标识已存在！");
                valid = false;
            }
//                if(!StringUtils.isEmpty(model.getReferenceCode())){
//                    if((sourceId = stdSources.get(model.getReferenceCode())) == null){
//                        model.addErrorMsg("referenceCode", "该参考来源不存在！");
//                        valid = false;
//                    }else
//                        model.setReferenceId(sourceId);
//                }

            valid = valid & validateMeta(model, columnTypes, dicts) ;
            if(valid)
                saveLs.add(correctLs.get(i));
            else
                errorLs.add(model);

        }
        return saveLs;
    }

    private boolean validateMeta(DataSetMsg model, String columnTypes, Map<String, String> dicts) throws Exception {
        List<MetaDataMsg> children = model.getChildren();

        boolean valid= true;
        String dictId;
        for(MetaDataMsg meta : children){
            if(!StringUtils.isEmpty(meta.getDictCode())){
                if((dictId=dicts.get(meta.getDictCode())) == null){
                    valid = false;
                    meta.addErrorMsg("dictCode", "该术语范围值不存在");
                }else
                    meta.setDictId(dictId);
            }

            if(!StringUtils.isEmpty(meta.getColumnType()) && columnTypes.indexOf(meta.getColumnType())==-1){
                meta.addErrorMsg("columnType", "只能是["+ columnTypes +"]里的值！");
                valid = false;
            }
        }
        return valid;
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

    private void saveData(String datas, String version) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<>();
        conditionMap.add("models", datas);
        conditionMap.add("version", version);
        RestTemplates restTemplates = new RestTemplates();
        String rs = restTemplates.doPost(comUrl + "/data_set/batch", conditionMap);
        if(!"true".equals(rs))
            throw new Exception("保存失败！");
    }

    private Map<String, String> findStdDict(String version) throws Exception {
        Map map = new HashMap<>();
        map.put("fields", "");
        map.put("filters", "");
        map.put("sorts", "");
        map.put("page", 1);
        map.put("size", 999);
        map.put("version", version);
        EnvelopExt<DictModel> rs = objectMapper.readValue(
                HttpClientUtil.doGet(comUrl + "/dicts", map),
                new TypeReference<EnvelopExt<DictModel>>() {});

        if(rs.isSuccessFlg()){
            Map modelMap = new HashMap<>();
            for(DictModel m : rs.getDetailModelList()){
                modelMap.put(m.getCode(), String.valueOf(m.getId()));
            }
            return modelMap;
        }
        throw new Exception("获取标准字典出错");
    }

    private Map<String, String> findStdSources(String referenceCodes) throws Exception {
        Map map = new HashMap<>();
        map.put("fields", "");
        map.put("filters", "code=" + referenceCodes + " g1");
        map.put("sorts", "");
        map.put("page", 1);
        map.put("size", 500);
        EnvelopExt<StdSourceModel> rs = objectMapper.readValue(
                HttpClientUtil.doGet(stdSrcUrl + "/sources", map),
                new TypeReference<EnvelopExt<StdSourceModel>>() {});

        if(rs.isSuccessFlg()){
            Map modelMap = new HashMap<>();
            for(StdSourceModel m : rs.getDetailModelList()){
                modelMap.put(m.getCode(), m.getId());
            }
            return modelMap;
        }

        throw new Exception("获取标准来源出错");
    }

    private Set<String> findExistCode(Set<String> codes, String version) throws Exception {

        Map<String,Object> conditionMap = new HashMap<>();
        conditionMap.put("codes", codes.toString().replace(" ", "").replace("[", "").replace("]", ""));
        conditionMap.put("version", version);
        conditionMap.put("size", codes.size() + "");
        String rs = HttpClientUtil.doGet(comUrl + "/data_set/codes/existence", conditionMap);
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

    public void downLoadFile(String filePath,  HttpServletResponse response) throws IOException {

        InputStream fis=null;
        OutputStream toClient = null;
        try{
            File file = new File( filePath );
            fis = new BufferedInputStream(new FileInputStream(file));
            byte[] buffer = new byte[fis.available()];
            fis.read(buffer);
            fis.close();

            response.reset();
            response.setContentType("octets/stream");
            response.addHeader("Content-Length", "" + file.length());
            response.addHeader("Content-Disposition", "attachment; filename="
                    + new String(file.getName().getBytes("gb2312"), "ISO8859-1"));

            toClient = new BufferedOutputStream(response.getOutputStream());
            toClient.write(buffer);
            toClient.flush();
            toClient.close();
        } catch (Exception e) {
            e.printStackTrace();
            if(fis!=null) fis.close();
            if(toClient!=null) toClient.close();
        }
    }
}