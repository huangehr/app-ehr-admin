package com.yihu.ehr.std.controller;

import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import java.util.HashMap;
import java.util.Map;

@RequestMapping("/cda")
@Controller
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class CdaController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;

    @Value("${service-gateway.standard}")
    public String standardUrl;


    @RequestMapping("GetCdaListByKey")
    @ResponseBody
    public Object GetCdaListByKey(String strKey, String strVersion, String strType, Integer page, Integer rows) {

        String url = "/cda/cdas";
        String filters = "type="+strType;

        Envelop result = new Envelop();
        Map<String,Object> params = new HashMap<>();

        if (!StringUtils.isEmpty(strKey)){
            filters += " g1;code?"+strKey+" g2;name?"+strKey+" g2";
        }
        params.put("fields","");
        params.put("sorts","");
        params.put("version",strVersion);
        params.put("filters",filters);
        params.put("page",page);
        params.put("size",rows);

        if (StringUtils.isEmpty(strVersion)) {
            return failed("版本号不能为空");
        }

        try {

            String _rus = HttpClientUtil.doGet(comUrl+url, params, username, password);
            if (StringUtils.isEmpty(_rus)) {
                result.setSuccessFlg(false);
                result.setErrorMsg("获取CDA失败");
            }else{
                return _rus;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return result;

    }

    @RequestMapping("getCDAInfoById")
    @ResponseBody
    public Object getCDAInfoById(String strId, String strVersion) {

        String url = "/cda/cda";
        String strErrorMsg = "";

        Envelop result = new Envelop();
        Map<String,Object> params = new HashMap<>();

        params.put("version_code",strVersion);
        params.put("cda_id",strId);

        if (StringUtils.isEmpty(strVersion)) {
            strErrorMsg += "请选择标准版本!";
        }
        if (StringUtils.isEmpty(strId)) {
            strErrorMsg += "请选择将要编辑的CDA!";
        }
        if (!StringUtils.isEmpty(strErrorMsg)) {
            result.setSuccessFlg(false);
            result.setErrorMsg(strErrorMsg);
            return result;
        }
        try {

            String _rus = HttpClientUtil.doGet(comUrl + url, params, username, password);

            return _rus;
        } catch (Exception ex) {
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

        /*Result result = new Result();
        try {
            String strErrorMsg = "";
            if (strVersion == null || strVersion == "") {
                strErrorMsg += "请选择标准版本!";
            }
            if (strId == null || strId == "") {
                strErrorMsg += "请选择将要编辑的CDA!";
            }
            if (strErrorMsg != "") {
                result.setSuccessFlg(false);
                result.setErrorMsg(strErrorMsg);
                return result;
            }
            List<String> listId = Arrays.asList(strId.split(","));
            XCDADocument[] xcdaDocuments = xcdaDocumentManager.getDocumentList(strVersion, listId);
            if (xcdaDocuments == null) {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.GetCDAInfoFailed.toString());
                return result;
            }
            List<CDAForInterface> resultInfos = GetCDAForInterface(xcdaDocuments);
            result.setSuccessFlg(true);
            result.setObj(resultInfos.get(0));
        } catch (Exception ex) {
            LogService.getLogger(CdaController_w.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.GetCDAInfoFailed.toString());
        }
        return result;*/
    }

   /* public List<CDAForInterface> GetCDAForInterface(XCDADocument[] xcdaDocuments) {
        List<CDAForInterface> infos = new ArrayList<>();
        for (XCDADocument xcdaDocument : xcdaDocuments) {
            CDAForInterface info = new CDAForInterface();
            info.setId(xcdaDocument.getId());
            info.setCode(xcdaDocument.getCode());
            info.setName(xcdaDocument.getName());
            info.setDescription(xcdaDocument.getDescription());
            info.setPrintOut(xcdaDocument.getPrintOut());
            info.setSourceId(xcdaDocument.getSourceId());
            info.setSchema(xcdaDocument.getSchema());
            info.setVersionCode(xcdaDocument.getVersionCode());
            info.setTypeId(xcdaDocument.getTypeId());
            infos.add(info);
        }
        return infos;
    }*/

    @RequestMapping("getRelationByCdaId")
    @ResponseBody
    public Object getRelationByCdaId(String cdaId, String strVersionCode, String strkey, Integer page, Integer rows) {
        // TODO 无对应
        Envelop result = new Envelop();
        try {
            String url = "/cda*/************";
            Map<String,Object> params = new HashMap<>();
            params.put("cdaId",cdaId);
            params.put("versionCode",strVersionCode);
            params.put("strkey",strkey);
            params.put("page",page);
            params.put("rows",rows);
            String _rus = HttpClientUtil.doGet(comUrl+url,params,username,password);
            if(StringUtils.isEmpty(_rus)){
                result.setSuccessFlg(false);
                result.setErrorMsg("关系获取失败!");
            }else {
                return _rus;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return result;

        /*Result result = new Result();
        try {
            List<CdaDatasetRelationshipForInterface> listResult = new ArrayList<>();
            XCdaDatasetRelationship[] relations = xCdaDatasetRelationshipManager.getRelationshipByCdaId(cdaId, strVersionCode, strkey, page, rows);
            if (relations != null) {
                for (XCdaDatasetRelationship info : relations) {
                    CdaDatasetRelationshipForInterface _res = new CdaDatasetRelationshipForInterface();
                    _res.setId(info.getId());
                    _res.setDatasetId(info.getDataSetId());
                    _res.setDataset_code(info.getDataSetCode());
                    _res.setDataset_name(info.getDataSetName());
                    _res.setSummary(info.getSummary());
                    listResult.add(_res);
                }
            }
            int resultCount = xCdaDatasetRelationshipManager.getRelationshipCountByCdaId(cdaId, strVersionCode, strkey);
            result = getResult(listResult, resultCount, page, rows);
        } catch (Exception ex) {
            LogService.getLogger(CdaController_w.class).error(ex.getMessage());
            result.setSuccessFlg(false);
            result.setErrorMsg("��ϵ��ȡʧ��!");
        }
        return result;*/
    }

    @RequestMapping("getALLRelationByCdaId")
    @ResponseBody
    public Object getALLRelationByCdaId(String cdaId, String strVersionCode) {
        Envelop result = new Envelop();
        try {
            String url = "/cda/relationships";
            Map<String,Object> params = new HashMap<>();
            params.put("cdaId",cdaId);
            params.put("versionCode",strVersionCode);
            //TODO 结果转换为对象且getResult(listResult,1,1,1);
            String _rus = HttpClientUtil.doGet(comUrl+url,params,username,password);
            if(StringUtils.isEmpty(_rus)){
                result.setSuccessFlg(false);
                result.setErrorMsg("关系获取失败!");
            }else {
                result.setSuccessFlg(true);
                return _rus;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return result;
    }

    /**
     * 保存CDA信息
     * 1.先删除CDA数据集关联关系信息与cda文档XML文件，在新增信息
     * @param strDatasetIds 关联的数据集
     * @param strCdaId  cda文档 ID
     * @param strVersionCode 版本号
     * @param xmlInfo xml 文件内容
     * @return 操作结果
     */
    @RequestMapping("SaveRelationship")
    @ResponseBody
    public Object SaveRelationship(String strDatasetIds, String strCdaId, String strVersionCode, String xmlInfo) {

//        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
//        RestTemplates template = new RestTemplates();

        Envelop result = new Envelop();
        String strErrorMsg = "";
        if (StringUtils.isEmpty(strVersionCode)) {
            strErrorMsg += "标准版本不能为空!";
        }
        if (StringUtils.isEmpty(strCdaId)) {
            strErrorMsg += "请先选择CDA!";
        }
        if (!StringUtils.isEmpty(strErrorMsg)) {
            result.setSuccessFlg(false);
            result.setErrorMsg(strErrorMsg);
            return result;
        }
        try {
            Map<String,Object> conditionMap = new HashMap<>();
            conditionMap.put("dataSetIds", strDatasetIds);
            conditionMap.put("cdaId", strCdaId);
            conditionMap.put("versionCode", strVersionCode);
            conditionMap.put("xmlInfo", xmlInfo);
            String url = comUrl + "/cda/saveRelationship";

            RestTemplates template = new RestTemplates();
//            String _rus = template.doPost(url, conditionMap);
            String _rus = HttpClientUtil.doPost( url, conditionMap, username, password);


            //测试
//            conditionMap.add("dataSetIds", strDatasetIds);
//            conditionMap.add("cdaId", strCdaId);
//            conditionMap.add("versionCode", strVersionCode);
//            conditionMap.add("xmlInfo", xmlInfo);
//            String _rus = template.doPost(comUrl + url, conditionMap);
            //结束


            if(StringUtils.isEmpty(_rus)){
                result.setSuccessFlg(false);
                result.setErrorMsg("关系保存失败");
            }else{
                result.setSuccessFlg(true);
            }
        }catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return result;
    }

    @RequestMapping("DeleteRelationship")
    @ResponseBody
    public Object DeleteRelationship(String ids, String strVersionCode) {
        //TODO 无对应
        Envelop result = new Envelop();
        try {
            String url = "/cda*/*************";
            Map<String,Object> params = new HashMap<>();
            params.put("ids",ids);
            params.put("strVersionCode",strVersionCode);
            String _msg = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            if(Boolean.parseBoolean(_msg)){
                result.setSuccessFlg(true);
            }else {
                result.setSuccessFlg(false);
                result.setErrorMsg("关系删除失败!");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return result;

    }

    /*
  * 判断文件是否存在*/
    @RequestMapping("/FileExists")
    @ResponseBody
    public String FileExists(String strCdaId, String strVersionCode) {
        //TODO 无对应
        try{
            String url = "/cda/***********";
            Map<String,Object> params = new HashMap<>();
            params.put("strCdaId",strCdaId);
            params.put("strVersionCode",strVersionCode);
            String _msg = HttpClientUtil.doGet(comUrl+url,params,username,password);
            if(Boolean.parseBoolean(_msg)){
                return "true";
            }else{
                return "false";
            }
        }catch(Exception ex){
            LogService.getLogger(CdaController.class).error(ex.getMessage());
            return "false";
        }
    }


    /*
     * 根据CDA ID 获取数据集信息
     * @param strVersionCode 版本号
     * @param strCdaId CDAID
     * @return Result
     * */
    @RequestMapping("/getDatasetByCdaId")
    @ResponseBody
    public Object getDatasetByCdaId(String strVersionCode, String strCdaId) {
        Envelop result = new Envelop();
        try {
            String url = "/cda/relationships";
            Map<String,Object> params = new HashMap<>();
            params.put("versionCode",strVersionCode);
            params.put("cdaId",strCdaId);
            String _rus = HttpClientUtil.doGet(comUrl+url,params,username,password);
            if(StringUtils.isEmpty(_rus)){
                result.setSuccessFlg(false);
                result.setErrorMsg("数据集获取失败");
            }else{
                result.setSuccessFlg(true);
                return _rus;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return result;

    }

    @RequestMapping("/validatorCda")
    @ResponseBody
    public Object validatorCda(String code, String versionCode) {
        Envelop result = new Envelop();
        try {
            String url = "/cda/documentExist";
            Map<String,Object> params = new HashMap<>();
            params.put("code",code);
            params.put("versionCode",versionCode);
            String _msg = HttpClientUtil.doPost(comUrl+url,params,username,password);
            if(Boolean.parseBoolean(_msg)){
                result.setSuccessFlg(true);
            }else {
                result.setSuccessFlg(false);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return result;

        /*boolean documentExist = xcdaDocumentManager.isDocumentExist(versionCode, code);
        if (documentExist) {
            return getSuccessResult(true).toJson();
        }
        return getSuccessResult(false).toJson();*/
    }

    /**
     * 将String 保存为XML文件
     *
     * @param fileInfo 文件信息
     * @return 返回 文件路径
     */
    /*public String SaveCdaFile(String fileInfo, String versionCode, String cdaId) {
        fileInfo = fileInfo.replaceAll("&lt;", "<").replaceAll("&gt;", ">");
        String strPath = System.getProperty("java.io.tmpdir");
        String splitMark = System.getProperty("file.separator");
        strPath += splitMark+"StandardFiles";
        //文件路径
        String strXMLFilePath = strPath + splitMark + "xml" + splitMark + versionCode + splitMark + "createfile" + splitMark + cdaId + ".xml";

        File file = new File(strXMLFilePath);
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        try {
            file.createNewFile();
        } catch (IOException ex) {
            LogService.getLogger(CdaController_w.class).error(ex.getMessage());
        }

        try {
            FileWriter fw = new FileWriter(file, true);
            BufferedWriter bw = new BufferedWriter(fw);
            bw.write(fileInfo);
            bw.flush();
            bw.close();
            fw.close();
        } catch (IOException ex) {
            LogService.getLogger(CdaController_w.class).error(ex.getMessage());
        }

        return strXMLFilePath;
    }*/

   /* public boolean SaveXmlFilePath(String cdaId, String versionCode, String fileGroup, String filePath) {
        boolean result = true;
        try {
            List<String> listIds = new ArrayList<>();
            listIds.add(cdaId);
            XCDADocument[] xcdaDocuments = xcdaDocumentManager.getDocumentList(versionCode, listIds);
            if (xcdaDocuments.length <= 0) {
                LogService.getLogger(CdaController_w.class).error("δ�ҵ�CDA");
                return false;
            }

            xcdaDocuments[0].setFileGroup(fileGroup);
            xcdaDocuments[0].setSchema(filePath);
            xcdaDocuments[0].setVersionCode(versionCode);
            int iRes = xcdaDocumentManager.saveDocument(xcdaDocuments[0]);
            if (iRes < 0) {
                return false;
            }
        } catch (Exception ex) {
            result = false;
            LogService.getLogger(CdaController_w.class).error(ex.getMessage());
        }

        return result;
    }*/

    /**
     * 获取cda文档的XML文件信息。
     * <p>
     * 从服务器的临时文件路径中读取配置文件，并以XML形式返回。
     *
     * @param cdaId
     * @param versionCode
     * @return XML信息
     * @version 1.0.1 将临时目录转移至fastDFS。
     */
    @RequestMapping("/getCdaXmlFileInfo")
    @ResponseBody
    public Object getCdaXmlFileInfo(String cdaId, String versionCode) {
        Envelop envelop = new Envelop();

        String strXmlInfo = "";
        try {
            String url = "/cda/getCdaXmlFileInfo";
            Map<String,Object> params = new HashMap<>();
            params.put("cdaId",cdaId);
            params.put("versionCode",versionCode);
            strXmlInfo = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return strXmlInfo;

        } catch (Exception ex) {
            LogService.getLogger(CdaController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
        }
        return envelop;

    }

    @RequestMapping("/getOrgType")
    @ResponseBody
    public Object getOrgType() {
        // 例子
        Envelop result = new Envelop();
        try {
            String url = "/conDict/orgType";
            Map<String, Object> params = new HashMap<>();
            params.put("type","Govement");
            String _res = HttpClientUtil.doGet(comUrl + url, params, username, password);
            result.setSuccessFlg(true);
            result.setObj(_res);
        } catch (Exception ex) {
            LogService.getLogger(CdaController.class).error(ex.getMessage());
            result.setSuccessFlg(false);
        }
        return result;
    }
}
