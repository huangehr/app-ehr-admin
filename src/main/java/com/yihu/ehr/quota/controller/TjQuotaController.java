package com.yihu.ehr.quota.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.tj.TjDimensionSlaveModel;
import com.yihu.ehr.agModel.tj.TjQuotaDimensionSlaveModel;
import com.yihu.ehr.agModel.tj.TjQuotaModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.quota.controller.model.TjQuotaDMainMsg;
import com.yihu.ehr.quota.controller.model.TjQuotaDSlaveMsg;
import com.yihu.ehr.quota.controller.model.TjQuotaMsg;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.excel.read.TjQuotaMsgReader;
import com.yihu.ehr.util.excel.read.TjQuotaMsgWriter;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.client.RestClientException;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLDecoder;
import java.util.*;

/**
 * Created by Administrator on 2017/6/13.
 */
@Controller
@RequestMapping("/tjQuota")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class TjQuotaController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    private ObjectMapper objectMapper;


    /*
    * 获取弹窗页面：指标增、改
    * */
    @RequestMapping(value = "getPage")
    public String getPage(Model model,String id){
        if (id == "") {
            model.addAttribute("id","-1");
        } else {
            model.addAttribute("id",id);
        }
        return  "/report/zhibiao/zhiBiaoInfoDialog";
    }


    /**
     * 指标
     * @param model
     * @return
     */
    @RequestMapping("initial")
    public String initial(Model model) {
        model.addAttribute("contentPage", "/report/zhibiao/quota");
        return "pageView";
    }

    @RequestMapping("/getTjQuota")
    @ResponseBody
    public Object searchTjQuota(String name,Integer quotaType, int page, int rows){
        String url = "/tj/getTjQuotaList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(name)) {
            stringBuffer.append("name?" + name + " g1;code?" + name + " g1;");
        }
        if (!StringUtils.isEmpty(quotaType)) {
            stringBuffer.append("quotaType=" + quotaType + ";");
        } /*else {
            stringBuffer.append("quotaType=-1");
        }*/
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(TjQuotaController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 新增修改
     * @param tjQuotaModelJsonData
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "updateTjDataSource", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object updateTjQuota(String tjQuotaModelJsonData, HttpServletRequest request) throws IOException {

        String url = "/tj/addTjQuota/";
        String resultStr = "";
        Envelop result = new Envelop();
        UserDetailModel userDetailModel = getCurrentUserRedis(request);
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        String[] strings = URLDecoder.decode(tjQuotaModelJsonData, "UTF-8").split(";");
        TjQuotaModel detailModel = toModel(strings[0], TjQuotaModel.class);
        RestTemplates templates = new RestTemplates();

        try {
            if (!StringUtils.isEmpty(detailModel.getId())) {
                Long tjQuotaId = detailModel.getId();
                resultStr = templates.doGet(comUrl + "/tj/getTjQuotaById/" + tjQuotaId);
                Envelop envelop = getEnvelop(resultStr);
                if (envelop.isSuccessFlg()) {
                    TjQuotaModel updateTjQuota = getEnvelopModel(envelop.getObj(), TjQuotaModel.class);

                    updateTjQuota.setCode(detailModel.getCode());
                    updateTjQuota.setName(detailModel.getName());
                    updateTjQuota.setCron(detailModel.getCron());
                    updateTjQuota.setExecType(detailModel.getExecType());
                    updateTjQuota.setExecTime(detailModel.getExecTime());
                    updateTjQuota.setJobClazz(detailModel.getJobClazz());
                    updateTjQuota.setQuotaType(detailModel.getQuotaType());
                    updateTjQuota.setDataLevel(detailModel.getDataLevel());
                    updateTjQuota.setRemark(detailModel.getRemark());
                    updateTjQuota.setUpdateUser(userDetailModel.getId());
                    updateTjQuota.setUpdateUserName(userDetailModel.getRealName());
                    updateTjQuota.setTjQuotaDataSaveModel(detailModel.getTjQuotaDataSaveModel());
                    updateTjQuota.setTjQuotaDataSourceModel(detailModel.getTjQuotaDataSourceModel());
                    updateTjQuota.setTjQuotaChartModel(detailModel.getTjQuotaChartModel());
                    params.add("model", toJson(updateTjQuota));

                    resultStr = templates.doPost(comUrl + url, params);
                } else {
                    result.setSuccessFlg(false);
                    result.setErrorMsg(envelop.getErrorMsg());
                    return result;
                }
            } else {
                detailModel.setCreateUser(userDetailModel.getId());
                detailModel.setCreateUserName(userDetailModel.getRealName());
                params.add("model", toJson(detailModel));
                resultStr = templates.doPost(comUrl + url, params);
            }
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
        return resultStr;
    }

    /**
     * 删除
     * @param tjQuotaId
     * @return
     */
    @RequestMapping("deleteTjDataSave")
    @ResponseBody
    public Object deleteTjQuota(Long tjQuotaId) {
        String url = "/tj/deleteTjQuota";
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();

        //判断资源视图中有没有用到此视图，有用到 不允许删除
        String resQuotaUrl = "/resourceQuota/searchByQuotaId";

        try {
            params.put("quotaId", tjQuotaId);
            resultStr = HttpClientUtil.doGet(comUrl + resQuotaUrl, params, username, password);
            result = mapper.readValue(resultStr, Envelop.class);
            if(result.getObj() != null){
                result.setSuccessFlg(false);
                result.setErrorMsg("指标在视图中被使用暂时不能删除，若要删除先解除资源视图中指标关系");
                return result;
            }

            params.clear();
            params.put("id", tjQuotaId);
            resultStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            result = mapper.readValue(resultStr, Envelop.class);
            if (result.isSuccessFlg()) {
                result.setSuccessFlg(true);
            } else {
                result.setSuccessFlg(false);
                result.setErrorMsg(ErrorCode.InvalidDelete.toString());
            }
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 根据id获取消息
     * @param model
     * @param id
     * @return
     */
    @RequestMapping("getTjQuotaById")
    @ResponseBody
    public Object getTjQuotaById(Model model, Long id ) {
        String url ="/tj/getTjQuotaById/" +id;
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        TjQuotaModel detailModel = null;
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop ep = getEnvelop(resultStr);
            detailModel = toModel(toJson(ep.getObj()),TjQuotaModel.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detailModel;
    }

    /**
     * 校验name是否唯一,true已存在
     * @param name
     * @return
     */
    @RequestMapping("hasExistsName")
    @ResponseBody
    public boolean hasExistsName(String name) {
        String url = "/tj/tjQuotaExistsName/" + name ;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("name", name);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if (resultStr.equals("true")) {
                return  true;
            }
        } catch (Exception e) {
            e.getMessage();
        }
        return  false;
    }

    /**
     * 校验code是否唯一
     * @param code
     * @return
     */
    @RequestMapping("hasExistsCode")
    @ResponseBody
    public boolean hasExistsCode(String code) {
        String url = "/tj/tjQuotaExistsCode/" + code ;
        String resultStr = "";
        Envelop result = new Envelop();
        Map<String, Object> params = new HashMap<>();
        ObjectMapper mapper = new ObjectMapper();
        params.put("code", code);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if (resultStr.equals("true")) {
                return  true;
            }
        } catch (Exception e) {
            e.getMessage();
        }
        return  false;
    }



    /**
     * 指标执行
     * @param tjQuotaId
     * @return
     */
    @RequestMapping("execuQuota")
    @ResponseBody
    public Object execuQuota(Long tjQuotaId) {
        String url = "/job/execuJob";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("id", tjQuotaId);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = objectMapper.readValue(resultStr,Envelop.class);
            return envelop;
        } catch (Exception e) {
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 指标结果页
     * @param model
     * @return
     */
    @RequestMapping("initialResult")
    public String initialResult(Model model,long tjQuotaId,String quotaCode, String quotaType, String name) throws Exception {
        model.addAttribute("contentPage", "/report/zhibiao/resultIndex");
        model.addAttribute("id", tjQuotaId);
        model.addAttribute("quotaType", quotaType);
        model.addAttribute("name", name);
        String urlSlave ="/tj/getDimensionSlaveByQuotaCode";
        Map<String, Object> params = new HashMap<>();
        params.put("quotaCode", quotaCode);
        Envelop result = null;
        try {
            String resultStr = HttpClientUtil.doGet(comUrl + urlSlave, params, username, password);
            result = objectMapper.readValue(resultStr, Envelop.class);
            if (result.isSuccessFlg() && result.getDetailModelList().size() >0) {
                List<HashMap> slaveModelList = result.getDetailModelList();
                if (slaveModelList != null && slaveModelList.size() > 0) {
                    int num = 1;
                    for (HashMap map : slaveModelList) {
                        TjQuotaDimensionSlaveModel quotaDimensionSlaveModel = objectMapper.convertValue(map,TjQuotaDimensionSlaveModel.class);
                        RestTemplates templates = new RestTemplates();
                        params.clear();
                        params.put("code", quotaDimensionSlaveModel.getSlaveCode());
                        resultStr = HttpClientUtil.doGet(comUrl + "/tj/getTjDimensionSlaveByCode", params, username, password);
                        result = objectMapper.readValue(resultStr, Envelop.class);
                        if (result.isSuccessFlg()) {
                            TjDimensionSlaveModel tjDimensionSlaveModel = objectMapper.convertValue(result.getObj(), TjDimensionSlaveModel.class);
                            model.addAttribute("slaveKey"+num+"Name", tjDimensionSlaveModel.getName());
                            num++;
                        }
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "emptyView";
    }


    /**
     * 指标执行结果
     * @param tjQuotaId
     * @return
     */
    @RequestMapping("selectQuotaResult")
    @ResponseBody
    public Object selectQuotaResult(Long tjQuotaId, int page, int rows,
                                    String startTime,String endTime,String orgName,
                                    String province,String city,String district,HttpServletRequest request) {
        Envelop result = new Envelop();
        String resultStr = "";
        String url = "/tj/tjGetQuotaResult";
        try {
            Map<String, Object> filters = new HashMap<>();
            filters.put("startTime", startTime);
            filters.put("endTime", endTime);
            filters.put("orgName", orgName);
            filters.put("province", province);
            filters.put("city", city);
            filters.put("district", district);
            Map<String, Object> params = new HashMap<>();
            List<String> userOrgList  = getUserOrgSaasListRedis(request);
            params.put("userOrgList", userOrgList);
            params.put("id", tjQuotaId);
            params.put("pageNo", page);
            params.put("pageSize", rows);
            params.put("filters", objectMapper.writeValueAsString(filters));
            ObjectMapper mapper = new ObjectMapper();
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            result = mapper.readValue(resultStr, Envelop.class);
            return result;
        } catch (Exception e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
    }

    /**
     * 指标日志查询
     * @param model
     * @return
     */
    @RequestMapping("initialQuotaLog")
    public String initialQuotaLog(Model model,String quotaCode, String quotaType, String name) {
        model.addAttribute("contentPage", "/report/zhibiao/zhiBiaoLogIndex");
        model.addAttribute("quotaCode", quotaCode);
        model.addAttribute("quotaType", quotaType);
        model.addAttribute("name", name);
        return "emptyView";
    }

    /**
     * 获取指标日志信息
     * @param
     * @return
     */
    @RequestMapping("queryQuotaLog")
    @ResponseBody
    public Object queryQuotaLog(String quotaCode, String startTime, String endTime,int page, int rows) throws Exception{
        String url = "/tj/getTjQuotaLogList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();

        params.put("startTime", startTime);
        params.put("endTime", endTime);
        params.put("quotaCode", quotaCode);
        params.put("fields", "");
        params.put("sorts", "");
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(TjQuotaController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 获取quotaCode查询是否配置维度
     * @param
     * @return
     */
    @RequestMapping("hasConfigDimension")
    @ResponseBody
    public boolean hasConfigDimension(String quotaCode) throws Exception {
        String url = "/tj/hasConfigDimension";
        String resultStr = "";
        Map<String, Object> params = new HashMap<>();

        params.put("quotaCode", quotaCode);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            if (resultStr.equals("true")) {
                return  true;
            }
        } catch (Exception e) {
            e.getMessage();
        }
        return  false;
    }


    //带检索分页的查找指标方法,用于下拉框
    @RequestMapping("/rsQuota")
    @ResponseBody
    public Object searchRsQuota(String searchParm,int page,int rows){
        String url = "/tj/getTjQuotaList";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(searchParm)) {
            stringBuffer.append("name?" + searchParm +";");
        }
        params.put("filters", "");
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        params.put("page", page);
        params.put("size", rows);
        try {
            String envelopStrGet = HttpClientUtil.doGet(comUrl + url, params, username, password);
            Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
            List<TjQuotaModel> tjQuotaModelList = new ArrayList<>();
            List<Map> list = new ArrayList<>();
            if(envelopGet.isSuccessFlg()){
                tjQuotaModelList = (List<TjQuotaModel>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<TjQuotaModel>(),TjQuotaModel.class);
                for (TjQuotaModel m:tjQuotaModelList){
                    Map map = new HashMap<>();
                    map.put("id",m.getCode());
                    map.put("name",m.getName());
                    list.add(map);
                }
                envelopGet.setDetailModelList(list);
                return envelopGet;
            }
            return envelop;
        } catch (Exception ex) {
            LogService.getLogger(TjQuotaController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }


    @RequestMapping("/getTjQuotaChartList")
    @ResponseBody
    public Object getQuotaChartList(String quotaCode,String name,int dictId,int page,int rows){
        String url = "/tj/getTjQuotaChartList";
        String resultStr = "";
        Envelop envelop = new Envelop();
        Map<String, Object> params = new HashMap<>();
        params.put("filters", "");
        StringBuffer stringBuffer = new StringBuffer();
        if (!StringUtils.isEmpty(quotaCode)) {
            stringBuffer.append( "quotaCode=" + quotaCode);
        }
        if (!StringUtils.isEmpty(name)) {
            stringBuffer.append("value?" + name );
        }
        String filters = stringBuffer.toString();
        if (!StringUtils.isEmpty(filters)) {
            params.put("filters", filters);
        }
        String filter = "";
        if (!StringUtils.isEmpty(dictId)) {
            filter = "dictId=" + dictId;
        }
        params.put("dictfilter", filter);
        params.put("page", page);
        params.put("size", rows);
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            return resultStr;
        } catch (Exception ex) {
            LogService.getLogger(TjQuotaController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 添加主维度子表
     * @param jsonModel 维度子表信息的json串
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "addTjQuotaChart", produces = "text/html;charset=UTF-8")
    @ResponseBody
    public Object addTjQuotaChart(String quotaCode, String jsonModel, HttpServletRequest request) throws IOException {
        String url = "/tj/batchTjQuotaChart";
        String resultStr = "";
        Envelop result = new Envelop();
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("model", jsonModel);
        RestTemplates templates = new RestTemplates();
        try {
            resultStr = templates.doPost(comUrl + url, params);
        } catch (RestClientException e) {
            result.setSuccessFlg(false);
            result.setErrorMsg(ErrorCode.SystemError.toString());
            return result;
        }
        return resultStr;
    }

    /**
     * 指标文件导入
     * @param file
     * @param request
     * @param response
     * @return
     * @throws IOException
     */
    private static final String parentFile = "tjQuotaDataSet";
    @RequestMapping(value = "import")
    @ResponseBody
    public void importData(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        try {
            UserDetailModel user = getCurrentUserRedis(request);
            writerResponse(response, 1 + "", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            TjQuotaMsgReader excelReader = new TjQuotaMsgReader();
            excelReader.read(file.getInputStream());
            //指标
            List<TjQuotaMsg> errorLs = excelReader.getErrorLs();
            List<TjQuotaMsg> correctLs = excelReader.getCorrectLs();
            //主维度
            List<TjQuotaDMainMsg> quotaMainErrorLs = excelReader.getErrorLs();
            List<TjQuotaDMainMsg> quotaMainCorrectLs = excelReader.getCorrectLs();
            //细维度
            List<TjQuotaDSlaveMsg> quotaSlaveErrorLs = excelReader.getErrorLs();
            List<TjQuotaDSlaveMsg> quotaSlaveCorrectLs = excelReader.getCorrectLs();
            writerResponse(response, 35+"", "l_upd_progress");

            Map<String,Object> LsMap = validate(excelReader, errorLs, correctLs, quotaMainErrorLs, quotaMainCorrectLs, quotaSlaveErrorLs, quotaSlaveCorrectLs);
            writerResponse(response, 55+"", "l_upd_progress");

            Map rs = new HashMap<>();
            //输出错误信息
            if(errorLs.size()>0 || quotaMainErrorLs.size()>0 || quotaSlaveErrorLs.size()>0){
                String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".xls");
                new TjQuotaMsgWriter().write(new File(TemPath.getFullPath(eFile, parentFile)), errorLs, quotaMainErrorLs, quotaSlaveErrorLs);
                rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
            }
            writerResponse(response, 65 + "", "l_upd_progress");

            if(LsMap.size()>0)
                saveData(LsMap);
            if(errorLs.size()==0)
                writerResponse(response, 100 + ",'suc'", "l_upd_progress");
            else
                writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");

        } catch (Exception e) {
            e.printStackTrace();
            writerResponse(response, "-1", "l_upd_progress");
        }
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

    /**
     * 验证指标编码、名称、指标分类、主维度、细维度
     * @param excelReader   待验证的数据
     * @param errorLs       指标错误数据
     * @param correctLs     指标正常数据
     * @param quotaMainErrorLs 主维度错误数据
     * @param quotaMainCorrectLs    主维度正常数据
     * @param quotaSlaveErrorLs 细维度错误数据
     * @param quotaSlaveCorrectLs 细维度正常数据
     * @return
     * @throws Exception
     */
    private Map<String,Object> validate(TjQuotaMsgReader excelReader,
                          List<TjQuotaMsg> errorLs, List<TjQuotaMsg> correctLs ,
                           List<TjQuotaDMainMsg>  quotaMainErrorLs ,List<TjQuotaDMainMsg>  quotaMainCorrectLs ,
                           List<TjQuotaDSlaveMsg>  quotaSlaveErrorLs ,List<TjQuotaDSlaveMsg>  quotaSlaveCorrectLs) throws Exception {
        List saveLs = new ArrayList<>();
        List quotaMainLs = new ArrayList<>();
        List quotaSlaveLs = new ArrayList<>();
        //验证指标编码是否存在
        Set<String> quotaCodes = findExistCodeOrName("code",excelReader.getRepeat().get("code"));
        //验证指标名称是否存在
        Set<String> quotaNames = findExistCodeOrName("name",excelReader.getRepeat().get("name"));
        //根据指标类型名称获取指标类型id
        Map<String,String> quotaTypes = findExistQuotaType(excelReader.getRepeat().get("quotaType"));
        //判断主维度编码是否存在
        Set<String> mainCodes = findExistCodeOrName("mainCode",excelReader.getRepeat().get("mainCode"));
        //判断细维度编码是否存在
        Set<String> slaveCodes = findExistCodeOrName("slaveCode",excelReader.getRepeat().get("slaveCode"));

        TjQuotaMsg model;
        TjQuotaDMainMsg TjQuotaDMainModel;
        TjQuotaDSlaveMsg TjQuotaDSlaveModel;
        boolean valid;
        for(int i=0; i<errorLs.size(); i++){
            model = errorLs.get(i);
            TjQuotaDMainModel = quotaMainErrorLs.get(i);
            TjQuotaDSlaveModel = quotaSlaveErrorLs.get(i);
            //验证指标编码是否存在
            if(quotaCodes.contains(model.getCode())){
                model.addErrorMsg("code", "该指标编码已存在！");
            }

            //验证指标名称是否存在
            if(quotaNames.contains(model.getName())){
                model.addErrorMsg("name", "该指标名称已存在！");
            }

            //根据指标类型名称获取指标类型id
            if(null == quotaTypes.get(model.getQuotaType())){
                model.addErrorMsg("quotaType","该指标类型不存在！");
            }

            //判断主维度编码是否存在
            if( mainCodes.contains(TjQuotaDMainModel.getMainCode())){
                TjQuotaDMainModel.addErrorMsg("mainCode","该主维度编码不存在！");
            }

            //判断细维度编码是否存在
            if(slaveCodes.contains(TjQuotaDSlaveModel.getSlaveCode())){
                TjQuotaDSlaveModel.addErrorMsg("slaveCode","该细维度编码不存在！");
            }

            //判断主维度指标编码是否存在（包括库里存在、现导入文件的指标编码）
            if(!(quotaCodes.contains(TjQuotaDMainModel.getMainCode()) || excelReader.getRepeat().get("code").contains(TjQuotaDMainModel.getMainCode()))){
                TjQuotaDMainModel.addErrorMsg("quotaCode", "该主维度的指标编码不存在！");
            }
            //判断细维度指标编码是否存在（包括库里存在、现导入文件的指标编码）
            if(!(quotaCodes.contains(TjQuotaDSlaveModel.getSlaveCode()) || excelReader.getRepeat().get("code").contains(TjQuotaDSlaveModel.getSlaveCode()))){
                TjQuotaDSlaveModel.addErrorMsg("quotaCode", "该细维度的指标编码不存在！");
            }
        }

        for(int i=0; i<correctLs.size(); i++){
            valid = true;
            model = correctLs.get(i);
            TjQuotaDMainModel = quotaMainCorrectLs.get(i);
            TjQuotaDSlaveModel = quotaSlaveCorrectLs.get(i);
            //验证指标编码是否存在
            if(quotaCodes.contains(model.getCode())){
                model.addErrorMsg("code", "该指标编码已存在！");
                valid = false;
                errorLs.add(model);
            }

            //验证指标名称是否存在
            if(quotaNames.contains(model.getName())){
                model.addErrorMsg("name", "该指标名称已存在！");
                valid = false;
                errorLs.add(model);
            }

            //根据指标类型名称获取指标类型id
            if(null == quotaTypes.get(model.getQuotaType())){
                model.addErrorMsg("quotaType","该指标类型不存在！");
                valid = false;
                errorLs.add(model);
            }else{
                model.setQuotaType(quotaTypes.get(model.getQuotaType()));
            }

            //判断主维度编码是否存在
            if(!( mainCodes.contains(TjQuotaDMainModel.getMainCode()))){
                TjQuotaDMainModel.addErrorMsg("mainCode","该主维度编码不存在！");
                valid = false;
                quotaMainErrorLs.add(TjQuotaDMainModel);
            }

            //判断细维度编码是否存在
            if(!(slaveCodes.contains(TjQuotaDSlaveModel.getSlaveCode()))){
                TjQuotaDSlaveModel.addErrorMsg("slaveCode","该细维度编码不存在！");
                valid = false;
                quotaSlaveErrorLs.add(TjQuotaDSlaveModel);
            }

            //判断主维度指标编码是否存在（包括库里存在、现导入文件的指标编码）
            if(!(quotaCodes.contains(TjQuotaDMainModel.getMainCode()) || excelReader.getRepeat().get("code").contains(TjQuotaDMainModel.getMainCode()))){
                TjQuotaDMainModel.addErrorMsg("quotaCode", "该主维度的指标编码不存在！");
                valid = false;
                quotaMainErrorLs.add(TjQuotaDMainModel);
            }
            //判断细维度指标编码是否存在（包括库里存在、现导入文件的指标编码）
            if(!(quotaCodes.contains(TjQuotaDSlaveModel.getSlaveCode()) || excelReader.getRepeat().get("code").contains(TjQuotaDSlaveModel.getSlaveCode()))){
                TjQuotaDSlaveModel.addErrorMsg("quotaCode", "该细维度的指标编码不存在！");
                valid = false;
                quotaSlaveErrorLs.add(TjQuotaDSlaveModel);
            }

            if(valid) {
                saveLs.add(correctLs.get(i));
                quotaMainLs.add(quotaMainCorrectLs.get(i));
                quotaSlaveLs.add(quotaSlaveCorrectLs.get(i));

            }
        }
        Map<String,Object> map = new HashMap<>();
        map.put("saveLs",saveLs);
        map.put("quotaMainLs",quotaMainLs);
        map.put("quotaSlaveLs",quotaSlaveLs);
        return map;
    }

    /**
     * 获取已经存在的指标编码/指标名称
     * @param name  检索字段名称
     * @param codes 检索列表
     * @return
     * @throws Exception
     */
    private Set<String> findExistCodeOrName(String name,Set<String> codes) throws Exception {

        Map<String,Object> conditionMap = new HashMap<>();
        String rs ="";
        //获取存在的主维度
        if(!StringUtils.isEmpty(name) && name.equals("mainCode")){
            conditionMap.put("mainCode", codes);
            rs = HttpClientUtil.doGet(comUrl + "/quota/TjDimensionMainIsExist", conditionMap);

        }else if(!StringUtils.isEmpty(name) && name.equals("slaveCode")){
            //获取存在的细维度
            conditionMap.put("slaveCode", codes);
            rs = HttpClientUtil.doGet(comUrl + "/quota/TjDimensionSlaveIsExist", conditionMap);

        }else{
            conditionMap.put("type",name);
            conditionMap.put("json", codes);
            rs = HttpClientUtil.doGet(comUrl + "/quota/type_isExist", conditionMap);
        }

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }

    /**
     * 根据指标分类的名称获取指标id和name
     * @param names 指标分类名称
     * @return
     * @throws Exception
     */
    private Map<String,String> findExistQuotaType(Set<String> names) throws Exception {
        Map map = new HashMap<>();
        map.put("name", names);
        String resultStr = "";
        resultStr = HttpClientUtil.doPost(comUrl + "/quotaCategory/getQuotaCategoryByName", map, username, password);
        Map<String,String>  quotaCategoryMap=objectMapper.readValue(resultStr, new TypeReference<Map<String,String>>() {});
        return quotaCategoryMap;
    }

    /**
     * 指标、数据源、数据存储、主维度、细维度整体入库
     * @param lsMap  saveLs、quotaMainLs、quotaSlaveLs
     * @return
     */
    private Envelop saveData(Map<String,Object> lsMap){
        Envelop ret = new Envelop();
        String url = "/tjQuota/batch";
        Map<String,Object> params = new HashMap<>();
        try {
            params.put("lsMap",lsMap);
            String envelopStrNew = HttpClientUtil.doPost(comUrl+url,params,username,password);
            Envelop envelop = getEnvelop(envelopStrNew);
            ret.setSuccessFlg(true);
            return ret;
        } catch (Exception e) {
            e.printStackTrace();
            ret.setSuccessFlg(false);
            return ret;
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
