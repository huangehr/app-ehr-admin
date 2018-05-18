package com.yihu.ehr.emergency.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.emergency.model.AmbulanceMsgModel;
import com.yihu.ehr.emergency.model.AmbulanceMsgModelReader;
import com.yihu.ehr.emergency.model.AmbulanceMsgModelWriter;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.ObjectFileRW;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

/**
 * Created by zdm on 2017/11/15.
 */
@Controller
@RequestMapping("/ambulance")
public class AmbulanceController extends BaseUIController {

    private static final String parentFile = "ambulance";

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    @ApiOperation(value = "获取所有救护车列表")
    @ResponseBody
    public Envelop list(
            @ApiParam(name = "fields", value = "返回的字段，为空返回全部字段")
            @RequestParam(value = "fields", required = false) String fields,
            @ApiParam(name = "filters", value = "过滤器，为空检索所有条件")
            @RequestParam(value = "filters", required = false) String filters,
            @ApiParam(name = "sorts", value = "排序，规则参见说明文档")
            @RequestParam(value = "sorts", required = false) String sorts,
            @ApiParam(name = "page", value = "分页大小", defaultValue = "1")
            @RequestParam(value = "page", required = false) int page,
            @ApiParam(name = "size", value = "页码", defaultValue = "15")
            @RequestParam(value = "size", required = false) int size) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/ambulance/list";
            if (filters != null && !"id?".equals(filters)) {
                params.put("filters", filters);
            }
            params.put("page", page);
            params.put("size", size);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        } catch (Exception e){
            LogService.getLogger(AmbulanceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    /**
     * 该接口为前端使用
     * @param fields
     * @param filters
     * @param sorts
     * @param page
     * @param size
     * @return
     */
    @RequestMapping(value = "/search", method = RequestMethod.GET)
    @ApiOperation(value = "查询救护车信息以及包括执勤人员信息，检索条件只针对车辆")
    @ResponseBody
    public Envelop search(
            @ApiParam(name = "fields", value = "返回的字段，为空返回全部字段")
            @RequestParam(value = "fields", required = false) String fields,
            @ApiParam(name = "filters", value = "过滤器，为空检索所有条件")
            @RequestParam(value = "filters", required = false) String filters,
            @ApiParam(name = "sorts", value = "排序，规则参见说明文档")
            @RequestParam(value = "sorts", required = false) String sorts,
            @ApiParam(name = "page", value = "分页大小", defaultValue = "1")
            @RequestParam(value = "page", required = false) int page,
            @ApiParam(name = "size", value = "页码", defaultValue = "15")
            @RequestParam(value = "size", required = false) int size) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/ambulance/search";
            params.put("filters", filters);
            params.put("fields", fields);
            params.put("sorts", sorts);
            params.put("page", page);
            params.put("size", size);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(AmbulanceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/updateStatus", method = RequestMethod.POST)
    @ApiOperation(value = "更新救护车状态信息")
    @ResponseBody
    public Envelop update(
            @ApiParam(name = "carId", value = "车牌号码")
            @RequestParam(value = "carId") String carId,
            @ApiParam(name = "status", value = "车辆状态码(0为统一可用状态码，1为统一不可用状态码)")
            @RequestParam(value = "status") String status) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/ambulance/updateStatus";
            params.put("carId", carId);
            params.put("status", status);
            String envelopStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(AmbulanceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    @ApiOperation(value = "保存单条记录")
    @ResponseBody
    public Envelop save(
            @ApiParam(name = "ambulance", value = "救护车")
            @RequestParam(value = "ambulance", required = false) String ambulance,
            HttpServletRequest request) {
        Envelop envelop = new Envelop();
        try {
            if(StringUtils.isEmpty(ambulance)) {
                return envelop;
            }
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/ambulance/save";
            Map<String, Object> ambulanceMap = objectMapper.readValue(ambulance, Map.class);
            HttpSession session = request.getSession();
            ambulanceMap.put("creator", session.getAttribute("userId"));
            ambulanceMap.put("status", 0);
            params.put("ambulance", objectMapper.writeValueAsString(ambulanceMap));
            String envelopStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(AmbulanceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ApiOperation(value = "更新单条记录")
    @ResponseBody
    public Envelop update(
            @ApiParam(name = "attendance", value = "救护车")
            @RequestParam(value = "ambulance") String ambulance,
            HttpServletRequest request) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/ambulance/update";
            Map<String, Object> ambulanceMap = objectMapper.readValue(ambulance, Map.class);
            HttpSession session = request.getSession();
            ambulanceMap.put("modifier", session.getAttribute("userId"));
            params.put("ambulance", objectMapper.writeValueAsString(ambulanceMap));
            String envelopStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(AmbulanceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ApiOperation(value = "删除记录")
    @ResponseBody
    public Envelop delete(
            @ApiParam(name = "ids", value = "id列表xxxx,xxxx,xxxx,...")
            @RequestParam(value = "ids") String ids) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/ambulance/delete";
            params.put("ids", ids);
            String envelopStr = HttpClientUtil.doDelete(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(AmbulanceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/findById", method = RequestMethod.GET)
    @ApiOperation("获取单条记录")
    @ResponseBody
    public Envelop findById(
            @ApiParam(name = "id", value = "id")
            @RequestParam(value = "id") String id){
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/ambulance/findById";
            params.put("id", id);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(AmbulanceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "import")
    @ResponseBody
    public void importMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        UsersModel user = getCurrentUserRedis(request);
        try {
            writerResponse(response, 1+"", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new AmbulanceMsgModelReader();
            excelReader.read(file.getInputStream());
            List<AmbulanceMsgModel> errorLs = excelReader.getErrorLs();
            List<AmbulanceMsgModel> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 20+"", "l_upd_progress");
            List saveLs = new ArrayList<>();
            //获取eme_ambulance所有车牌号
            Set<String> ids = findExistIdOrPhoneInAmbulance("id",toJson(excelReader.getRepeat().get("id")));
            //获取eme_ambulance所有随车电话
            Set<String> phones = findExistIdOrPhoneInAmbulance("phone",toJson(excelReader.getRepeat().get("phone")));
            //获取机构表所有机构、机构名称
            Map<String,String> orgs = findExistOrgInOrganization(toJson(excelReader.getRepeat().get("orgCode")));
            writerResponse(response, 35+"", "l_upd_progress");
            AmbulanceMsgModel model;
            for(int i=0; i<correctLs.size(); i++){
                model = correctLs.get(i);
                model.setCreator(user.getId());
                if(validate(model, ids,phones,orgs)==0)
                    errorLs.add(model);
                else
                    saveLs.add(model);
            }
            for(int i=0; i<errorLs.size(); i++){
                model = errorLs.get(i);
                model.setCreator(user.getId());
                validate(model, ids,phones,orgs);
            }
            writerResponse(response, 55+"", "l_upd_progress");
            Map rs = new HashMap<>();
            if(errorLs.size()>0){
                String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".dat");
                ObjectFileRW.write(new File(TemPath.getFullPath(eFile, parentFile)),errorLs);
                rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
                writerResponse(response, 75 + "", "l_upd_progress");
            }
            if(saveLs.size()>0)
                saveMeta(toJson(saveLs));

            if(rs.size()>0)
                writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");
            else
                writerResponse(response, 100 + "", "l_upd_progress");
        } catch (Exception e) {
            e.printStackTrace();
            if(e.getMessage().equals("模板不正确，请下载新的模板，并按照示例正确填写后上传！")) {
                writerResponse(response, "-2", "l_upd_progress");
            }else{
                writerResponse(response, "-1", "l_upd_progress");
            }
        }
    }

    /**
     * 导入错误信息
     * @param model
     * @param result
     * @return
     */
    @RequestMapping("/gotoImportLs")
    public String gotoImportLs(Model model, String result){
        model.addAttribute("files", result);
        model.addAttribute("contentPage", "/emergency/impGrid");
        return "pageView";
    }

    @RequestMapping("/initialization")
    public String initialization(Model model){
        model.addAttribute("contentPage", "/emergency/menu/fleet");
        return "pageView";
    }
    @RequestMapping("/intercalatesupervise")
    public String intercalatesupervise(Model model){
        model.addAttribute("contentPage", "/emergency/menu/fleetset");
        return "pageView";
    }

    @RequestMapping("/sortmanage")
    public String sortmanage(Model model){
        model.addAttribute("contentPage", "/emergency/menu/rdermanage");
        return "pageView";
    }

    @RequestMapping(value = "getPage")
    public String getPage(Model model,String id, String entityName){
        if (id == "" ) {
            model.addAttribute("id","-1");
        } else {
            model.addAttribute("id",id);
        }
        if (entityName == "" ) {
            model.addAttribute("entityName", "-1");
        } else {
            model.addAttribute("entityName", entityName);
        }
        return  "/emergency/menu/vehiclemMenu";
    }

    @RequestMapping("/importLs")
    @ResponseBody
    public Object importLs(int page, int rows, String filenName, String datePath){
        Envelop envelop = new Envelop();
        try{
            File file = new File( TemPath.getFullPath(datePath + TemPath.separator + filenName, parentFile) );
            List ls = (List) ObjectFileRW.read(file);
            int start = (page-1) * rows;
            int total = ls.size();
            int end = start + rows;
            end = end > total ? total : end;
            List g = new ArrayList<>();
            for(int i=start; i<end; i++){
                g.add( ls.get(i) );
            }

            envelop.setDetailModelList(g);
            envelop.setTotalCount(total);
            envelop.setSuccessFlg(true);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg("上传失败！"+e.getMessage());
            return envelop;
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
     * 根据车牌号、随车手机号在Ambulance表获取数据
     * @param type  查询字段名
     * @param values 多个值
     * @return Set<String>
     * @throws Exception
     */
    private Set<String> findExistIdOrPhoneInAmbulance(String type, String values) throws Exception {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("type", type);
        conditionMap.add("values", values);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(comUrl + "/ambulance/idOrPhoneExistence", conditionMap);
        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }

    /**
     * 根据机构code、name在user表获取数据
     * @param org_codes 导入文件的所有机构
     * @return
     * @throws Exception
     */
    private Map<String,String> findExistOrgInOrganization(String org_codes) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("org_codes", org_codes);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(comUrl +"/organizations/seaOrgsByOrgCode", conditionMap);
        Envelop envelop = objectMapper.readValue(rs,Envelop.class);
        Map<String,String> map= new LinkedHashMap<String,String>();
        if(envelop.isSuccessFlg()&&null!=envelop.getObj()) {
            map=(LinkedHashMap)envelop.getObj();
            return map;
        }
        return map;
    }

    /**
     * 保存救护车列表信息
     * @param ambulances 救护车对象json
     * @return
     * @throws Exception
     */
    private List saveMeta(String ambulances) throws Exception {
        Map map = new HashMap<>();
        map.put("ambulances", ambulances);
        String rs = HttpClientUtil.doPost(comUrl+ "/ambulances/batch", map, username, password);
        Envelop envelop = objectMapper.readValue(rs,Envelop.class);
        if(envelop.isSuccessFlg()) {
            return envelop.getDetailModelList();
        }else{
           return null;
        }
    }

    /**
     * 下载错误信息
     * @param f
     * @param datePath
     * @param response
     * @throws IOException
     */
    @RequestMapping("/downLoadErrInfo")
    public void downLoadErrInfo(String f, String datePath,  HttpServletResponse response) throws IOException {
        OutputStream toClient = response.getOutputStream();
        try{
            f = datePath + TemPath.separator + f;
            File file = new File( TemPath.getFullPath(f, parentFile) );
            response.reset();
            response.setContentType("octets/stream");
            response.addHeader("Content-Disposition", "attachment; filename="
                    + new String((f.substring(0, f.length()-4)+".xls").getBytes("gb2312"), "ISO8859-1"));
            new AmbulanceMsgModelWriter().write(toClient, (List) ObjectFileRW.read(file));
            toClient.flush();
            toClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 保存救护车信息
     * @param ambulances
     * @param eFile
     * @param tFile
     * @param datePath
     * @return
     */
    @RequestMapping("/batchSave")
    @ResponseBody
    public Object batchSave(String ambulances, String eFile, String tFile, String datePath) {
        if(!StringUtils.isEmpty(ambulances)&&!StringUtils.isEmpty(ambulances.replaceAll("\\[|\\]",""))){
        try {
            eFile = datePath + TemPath.separator + eFile;
            File file = new File(TemPath.getFullPath(eFile, parentFile));
            List<AmbulanceMsgModel> all = (List<AmbulanceMsgModel>) ObjectFileRW.read(file);
            List<AmbulanceMsgModel> ambulanceMsgModels = objectMapper.readValue(ambulances, new TypeReference<List<AmbulanceMsgModel>>() {});
            Map<String, Set> repeat = new HashMap<>();
            repeat.put("id", new HashSet<String>());
            repeat.put("orgCode", new HashSet<String>());
            repeat.put("orgName", new HashSet<String>());
            repeat.put("phone", new HashSet<String>());
            for (AmbulanceMsgModel model : ambulanceMsgModels) {
                model.validate(repeat);
            }
            //获取eme_ambulance所有车牌号
            Set<String> ids = findExistIdOrPhoneInAmbulance("id", toJson(repeat.get("id")));
            //获取eme_ambulance所有随车电话
            Set<String> phones = findExistIdOrPhoneInAmbulance("phone", toJson(repeat.get("phone")));
            //获取机构表所有机构、机构名称
            Map<String, String> orgs = findExistOrgInOrganization(toJson(repeat.get("orgCode")));
            AmbulanceMsgModel model;
            List saveLs = new ArrayList<>();
            for (int i = 0; i < ambulanceMsgModels.size(); i++) {
                model = ambulanceMsgModels.get(i);
                if (validate(model, ids, phones, orgs) == 0 || model.errorMsg.size() > 0) {
                    all.set(all.indexOf(model), model);
                } else {
                    saveLs.add(model);
                    all.remove(model);
                }
            }
            saveMeta(toJson(saveLs));
            ObjectFileRW.write(file, all);
            return success("");
        } catch (Exception e) {
            e.printStackTrace();
            return failed("保存失败！" + e.getMessage());
        }
    }else{
            return  failed("没有数据，保存失败！");
        }
    }

    /**
     * 错误页面 验证车牌号或者随车手机号码是否存在
     * @param type type="id"为车牌号，type="phone"为随车手机号
     * @param values  验证值
     * @return
     */
    @RequestMapping("/idOrPhoneIsExistence")
    @ResponseBody
    public Object idOrPhoneIsExistence(String type,String values){
        Envelop envelop = new Envelop();
        try {
            Map map = new HashMap<>();
            map.put("type", type);
            List<String> list = new ArrayList<String>();
            list.add(values);
            map.put("values", objectMapper.writeValueAsString(list));
            String resultStr = "";
            resultStr = HttpClientUtil.doPost(comUrl + "/ambulance/idOrPhoneExistence", map, username, password);
            Set<String> set=objectMapper.readValue(resultStr, new TypeReference<Set<String>>() {});
            if(null!=set&&set.size()>0){
                //返回成功 表示库里存在该车牌号或者随车号码
                envelop.setSuccessFlg(true);
                envelop.setObj(true);
                if(type.equals("id")){
                    envelop.setErrorMsg("该车牌号已存在，请核对！");
                }else if(type.equals("phone")){
                    envelop.setErrorMsg("该随车号码已存在，请核对！");
                }
            }else{
                envelop.setSuccessFlg(true);
            }
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
            return envelop;
        }
    }

    /**
     * 错误页面 验证机构（机构code、name是否存在；机构code和name是否对应）是否存在
     * @param orgCode  机构code
     * @param orgName  机构name
     * @return
     */
    @RequestMapping("/isOrgExistence")
    @ResponseBody
    public Object idOrgExistence(String orgCode,String orgName){
        Envelop envelop = new Envelop();
        try {
            Map map = new HashMap<>();
            map.put("org_codes", orgCode);
            String resultStr = "";
            resultStr = HttpClientUtil.doPost(comUrl + "/organizations/seaOrgsByOrgCode", map, username, password);
            Map<String,String>  orgMap=objectMapper.readValue(resultStr, new TypeReference<Map<String,String>>() {});
            if(null!=orgMap&&null!=orgMap.get(orgCode)){
                if(orgName.equals(orgMap.get(orgCode))){
                    envelop.setSuccessFlg(true);
                }else{
                    envelop.setSuccessFlg(false);
                    envelop.setErrorMsg("该机构code和机构名称不对应，请核对！");
                }
            }else{
                envelop.setSuccessFlg(false);
                envelop.setErrorMsg("该机构不存在，请核对！");
            }
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
            return envelop;
        }
    }


    private int validate(AmbulanceMsgModel model, Set<String> ids, Set<String> phones, Map<String,String> orgs){
        int rs = 1;
        //验证车牌号
        if(ids.contains(model.getId())){
            model.addErrorMsg("id", "该车牌号已存在，请核对！");
            rs = 0;
        }
        //验证随车手机号
        if(phones.contains(model.getPhone())){
            model.addErrorMsg("phone", "该随车手机号已存在，请核对！");
            rs = 0;
        }
        //验证机构
        if(null==orgs.get(model.getOrgCode())){
            model.addErrorMsg("orgCode", "该机构不存在，请核对！");
            rs = 0;
        }else if(!orgs.get(model.getOrgCode()).equals(model.getOrgName())){
            model.addErrorMsg("orgName", "该机构名称不正确，请核对！");
            rs = 0;
        }
        return rs;
    }


}
