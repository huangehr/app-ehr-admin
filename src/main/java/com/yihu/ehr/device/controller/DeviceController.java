package com.yihu.ehr.device.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.device.model.DeviceMsgModel;
import com.yihu.ehr.device.model.DeviceMsgModelReader;
import com.yihu.ehr.device.model.DeviceMsgModelWriter;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

/**
 * @Author: zhengwei
 * @Date: 2018/5/4 15:47
 * @Description: 设备管理
 */
@Controller
@RequestMapping("/device")
public class DeviceController extends BaseUIController {

    private static final String parentFile = "ambulance";

    @RequestMapping("/initial")
    public String initial(Model model){
        model.addAttribute("contentPage", "/device/deviceList");
        return "pageView";
    }

    @RequestMapping("/deviceInfo")
    public String deviceInfo(Model model, String id, String mode) {
        Object device = null;
        try {
            if (!mode.equals("new")) {
                Map<String, Object> params = new HashMap<String, Object>();
                String result = "";
                String url = "/device/findById";
                params.put("id", id);
                String resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
                Envelop envelopGet = objectMapper.readValue(resultStr, Envelop.class);
                device = envelopGet.getObj();
            }
        }catch (Exception e){
            LogService.getLogger(DeviceController.class).error(e.getMessage());
        }
        model.addAttribute("model", toJson(device));
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","/device/deviceDialog");
        return "emptyView";
    }

    @RequestMapping(value = "importInit")
    public String importInit(Model model){
        model.addAttribute("contentPage", "/device/importDevice");
        return "pageView";
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
        model.addAttribute("contentPage", "/device/impGrid");
        return "pageView";
    }

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    @ApiOperation(value = "获取所有列表")
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
            @ApiParam(name = "rows", value = "页码", defaultValue = "15")
            @RequestParam(value = "rows", required = false) int rows) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/device/list";
            if(filters != null && !"id=".equals(filters)) {
                params.put("filters", filters);
            }
            params.put("page", page);
            params.put("size", rows);
            params.put("sorts","-createDate");
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(DeviceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    @ApiOperation(value = "保存单条记录")
    @ResponseBody
    public Envelop save(
            @ApiParam(name = "device", value = "实体类Json")
            @RequestParam(value = "device", required = false) String device,
            HttpServletRequest request) {
        Envelop envelop = new Envelop();
        try {
            if(StringUtils.isEmpty(device)) {
                return envelop;
            }
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/device/save";
            Map<String, Object> map = objectMapper.readValue(device, Map.class);
            HttpSession session = request.getSession();
            if(map.get("id")!=null){
                map.put("modifier", session.getAttribute("userId"));
            }else{
                map.put("creator", session.getAttribute("userId"));
            }
            params.put("device", objectMapper.writeValueAsString(map));
            String envelopStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(DeviceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }



    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ApiOperation(value = "删除记录")
    @ResponseBody
    public Envelop delete(
            @ApiParam(name = "ids", value = "id列表")
            @RequestParam(value = "ids") String ids) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/device/delete";
            params.put("ids", ids);
            String envelopStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(DeviceController.class).error(e.getMessage());
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
            String url = "/device/findById";
            params.put("id", id);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(DeviceController.class).error(e.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "importDevice")
    @ResponseBody
    public void importDevice(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        UsersModel user = getCurrentUserRedis(request);
        try {
            writerResponse(response, 1+"", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new DeviceMsgModelReader();
            excelReader.read(file.getInputStream());
            List<DeviceMsgModel> errorLs = excelReader.getErrorLs();
            List<DeviceMsgModel> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 20+"", "l_upd_progress");
            List saveLs = new ArrayList<>();
            //获取机构表所有机构、机构名称
            Map<String,String> orgs = findExistOrgInOrganization(toJson(excelReader.getRepeat().get("orgCode")));
            writerResponse(response, 35+"", "l_upd_progress");
            DeviceMsgModel model;
            for(int i=0; i<correctLs.size(); i++){
                model = correctLs.get(i);
                model.setCreator(user.getId());
                if(validate(model,orgs)==0)
                    errorLs.add(model);
                else
                    saveLs.add(model);
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
     * 保存列表信息
     * @param devices
     * @return
     * @throws Exception
     */
    private List saveMeta(String devices) throws Exception {
        Map map = new HashMap<>();
        map.put("devices", devices);
        String rs = HttpClientUtil.doPost(comUrl+ "/device/batch", map, username, password);
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
            new DeviceMsgModelWriter().write(toClient, (List) ObjectFileRW.read(file));
            toClient.flush();
            toClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 保存救护车信息
     * @param device
     * @param eFile
     * @param tFile
     * @param datePath
     * @return
     */
    @RequestMapping("/batchSave")
    @ResponseBody
    public Object batchSave(String device, String eFile, String tFile, String datePath) {
        if(!StringUtils.isEmpty(device)&&!StringUtils.isEmpty(device.replaceAll("\\[|\\]",""))){
            try {
                eFile = datePath + TemPath.separator + eFile;
                File file = new File(TemPath.getFullPath(eFile, parentFile));
                List<DeviceMsgModel> all = (List<DeviceMsgModel>) ObjectFileRW.read(file);
                List<DeviceMsgModel> DeviceMsgModels = objectMapper.readValue(device, new TypeReference<List<DeviceMsgModel>>() {});
                Map<String, Set> repeat = new HashMap<>();
                repeat.put("orgCode", new HashSet<String>());
                for (DeviceMsgModel model : DeviceMsgModels) {
                    model.validate(repeat);
                }
                //获取机构表所有机构、机构名称
                Map<String, String> orgs = findExistOrgInOrganization(toJson(repeat.get("orgCode")));
                DeviceMsgModel model;
                List saveLs = new ArrayList<>();
                for (int i = 0; i < DeviceMsgModels.size(); i++) {
                    model = DeviceMsgModels.get(i);
                    if (validate(model, orgs) == 0 || model.errorMsg.size() > 0) {
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
                return  failed("没有可保存的数据");
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
            List<String> list  = new ArrayList<>();
            list.add(orgCode);
            Map<String,String>  orgMap=findExistOrgInOrganization(toJson(list));
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


    private int validate(DeviceMsgModel model,  Map<String,String> orgs){
        int rs = 1;
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
