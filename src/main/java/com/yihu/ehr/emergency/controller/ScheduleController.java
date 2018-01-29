package com.yihu.ehr.emergency.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.emergency.model.ScheduleMsgModel;
import com.yihu.ehr.emergency.model.ScheduleMsgModelReader;
import com.yihu.ehr.emergency.model.ScheduleMsgModelWriter;
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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.*;

/**
 * Created by zdm on 2017/11/20.
 */
@Controller
@RequestMapping("/schedule")
public class ScheduleController extends BaseUIController {

    static final String parentFile = "schedule";


    @RequestMapping(value = "/list", method = RequestMethod.GET)
    @ApiOperation("获取排班列表")
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
            String url = "/schedule/list";
            params.put("filters", filters);
            //params.put("fields", fields);
            //params.put("sorts", sorts);
            params.put("page", page);
            params.put("size", size);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(ScheduleController.class).error(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    @ApiOperation("保存单条记录")
    @ResponseBody
    public Envelop save(
            @ApiParam(name = "schedule", value = "排班")
            @RequestParam(value = "schedule") String schedule){
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/schedule/save";
            params.put("schedule", schedule);
            String envelopStr = HttpClientUtil.doPost(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(ScheduleController.class).error(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ApiOperation("更新单条记录，只允许更新时间和状态")
    @ResponseBody
    public Envelop update(
            @ApiParam(name = "schedule", value = "排班")
            @RequestParam(value = "schedule") String schedule){
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/schedule/update";
            params.put("schedule", schedule);
            String envelopStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(ScheduleController.class).error(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/bathUpdate", method = RequestMethod.POST)
    @ApiOperation("更新多条记录")
    @ResponseBody
    public Envelop bathUpdate(
            @ApiParam(name = "schedules", value = "排班")
            @RequestParam(value = "schedules") String schedules){
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/schedule/bathUpdate";
            params.put("schedules", schedules);
            String envelopStr = HttpClientUtil.doPut(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(ScheduleController.class).error(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/level", method = RequestMethod.GET)
    @ApiOperation("获取排班层级列表（年-月-日）")
    @ResponseBody
    public Envelop level(
            @ApiParam(name = "date", value = "年-月")
            @RequestParam(value = "date", required = false) String date,
            @ApiParam(name = "page", value = "分页大小", required = true, defaultValue = "1")
            @RequestParam(value = "page") int page,
            @ApiParam(name = "size", value = "页码", required = true, defaultValue = "15")
            @RequestParam(value = "size") int size) {
        Envelop envelop = new Envelop();
        try {
            Map<String, Object> params = new HashMap<String, Object>();
            String url = "/schedule/level";
            params.put("date", date);
            params.put("page", page);
            params.put("size", size);
            String envelopStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
            envelop = toModel(envelopStr, Envelop.class);
        }catch (Exception e){
            LogService.getLogger(ScheduleController.class).error(e.getMessage());
        }
        return envelop;
    }

    @RequestMapping(value = "/downloadTemplate", method = RequestMethod.GET)
    @ApiOperation("获取下载模板")
    public void download(HttpServletResponse response, HttpServletRequest request) throws IOException {
        String path = request.getServletContext().getRealPath("/") + "template/排班表.xls";
        File file = new File(path);
        response.setHeader("content-type", "application/octet-stream");
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(file.getName(), "UTF-8"));
        FileInputStream inputStream = new FileInputStream(path);
        OutputStream outputStream = response.getOutputStream();
        byte buffer[] = new byte[1024];
        int len = 0;
        while((len = inputStream.read(buffer))>0){
            outputStream.write(buffer, 0, len);
        }
        inputStream.close();
        outputStream.close();
    }

    @RequestMapping(value = "/initial", method = RequestMethod.GET)
    public String gotoList(Model model, String date){
        model.addAttribute("data", date);
        //model.addAttribute("version",  version);
        /**
        Map<String, Object> params = new HashMap<String, Object>();
        String url = "/schedule/level";
        params.put("date", date);
        params.put("page", 1);
        params.put("size", 500);
        String resultStr = "";
        Envelop result = new Envelop();
        //Map<String, Object> params = new HashMap<>();
        try {
            resultStr = HttpClientUtil.doGet(comUrl + url, params, username, password);
        }catch (Exception e){
            e.printStackTrace();
            //LogService.getLogger(SchemeAdaptDataSetController.class).error(e.getMessage());
            model.addAttribute("rs", "error");
        }
        Envelop envelop = toModel(resultStr, Envelop.class);
         */
        //model.addAttribute("date", date);
        model.addAttribute("contentPage","/emergency/menu/scheDetails");
        return "emptyView";
    }

    @RequestMapping(value = "import")
    @ResponseBody
    public void importMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {
        UsersModel user = (UsersModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        try {
            writerResponse(response, 1+"", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new ScheduleMsgModelReader();
            excelReader.read(file.getInputStream());
            List<ScheduleMsgModel> errorLs = excelReader.getErrorLs();
            List<ScheduleMsgModel> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 20+"", "l_upd_progress");
            List saveLs = new ArrayList<>();
            //获取eme_schedule所有车牌号
            Set<String> carIds = findExistIdOrPhoneInSchedule("id",toJson(excelReader.getRepeat().get("carId")));
            writerResponse(response, 35+"", "l_upd_progress");
            ScheduleMsgModel model;
            for(int i=0; i<correctLs.size(); i++){
                model = correctLs.get(i);
                model.setCreator(user.getId());
                if(validate(model, carIds)==0)
                    errorLs.add(model);
                else
                    saveLs.add(model);
            }
            for(int i=0; i<errorLs.size(); i++){
                model = errorLs.get(i);
                model.setCreator(user.getId());
                validate(model, carIds);
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
        model.addAttribute("contentPage", "/emergency/schedule/scheduleImpGrid");
        return "pageView";
    }

    @RequestMapping(value = "getImport")
    public String getImport(Model model,String id){
        model.addAttribute("contentPage", "/emergency/menu/importSch");
        return "pageView";
    }

    @RequestMapping(value = "getPage")
    public String getPage(Model model,String id, String main,String carId,String date){
        model.addAttribute("id",id);
        model.addAttribute("date",date);
        model.addAttribute("carId",carId);
        model.addAttribute("main",main);
        return  "/emergency/menu/schinfo";
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
     * 根据车牌号、随车手机号在Schedule表获取数据
     * @param type  查询字段名
     * @param values 多个值
     * @return Set<String>
     * @throws Exception
     */
    private Set<String> findExistIdOrPhoneInSchedule(String type, String values) throws Exception {
        MultiValueMap<String, String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("type", type);
        conditionMap.add("values", values);
        RestTemplates template = new RestTemplates();
        String rs = template.doPost(comUrl + "/ambulance/idOrPhoneExistence", conditionMap);
        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }

    /**
     * 保存救护车列表信息
     * @param schedules 救护车对象json
     * @return
     * @throws Exception
     */
    private List saveMeta(String schedules) throws Exception {
        Map map = new HashMap<>();
        map.put("schedules", schedules);
        String rs = HttpClientUtil.doPost(comUrl+ "/schedules/batch", map, username, password);
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
            new ScheduleMsgModelWriter().write(toClient, (List) ObjectFileRW.read(file));
            toClient.flush();
            toClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 保存救护车信息
     * @param schedules
     * @param eFile
     * @param tFile
     * @param datePath
     * @return
     */
    @RequestMapping("/batchSave")
    @ResponseBody
    public Object batchSave(String schedules, String eFile, String tFile, String datePath){
        try{
            eFile = datePath + TemPath.separator + eFile;
            File file = new File(TemPath.getFullPath(eFile, parentFile));
            List<ScheduleMsgModel> all = (List<ScheduleMsgModel>) ObjectFileRW.read(file);
            List<ScheduleMsgModel> scheduleMsgModels = objectMapper.readValue(schedules, new TypeReference<List<ScheduleMsgModel>>() {});
            Map<String, Set> repeat = new HashMap<>();
            repeat.put("carId", new HashSet<String>());
            repeat.put("dutyNum", new HashSet<String>());
            repeat.put("dutyPhone", new HashSet<String>());
            repeat.put("start", new HashSet<String>());
            repeat.put("end", new HashSet<String>());
            repeat.put("main", new HashSet<String>());

            for(ScheduleMsgModel model : scheduleMsgModels){
                model.validate(repeat);
            }
            //获取eme_schedule所有车牌号
            Set<String> carIds = findExistIdOrPhoneInSchedule("id",toJson(repeat.get("carId")));
            ScheduleMsgModel model;
            List saveLs = new ArrayList<>();
            for(int i=0; i<scheduleMsgModels.size(); i++){
                model = scheduleMsgModels.get(i);
                if(validate(model, carIds)==0|| model.errorMsg.size()>0) {
                    all.set(all.indexOf(model), model);
                }else{
                    saveLs.add(model);
                    all.remove(model);
                }
            }
            saveMeta(toJson(saveLs));
            ObjectFileRW.write(file, all);
            return success("");
        } catch (Exception e) {
            e.printStackTrace();
            return failed("保存失败！"+e.getMessage());
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
                //返回成功 表示库里存在该车牌号
                envelop.setSuccessFlg(true);
            }else{
                envelop.setSuccessFlg(true);
                envelop.setObj(true);
                envelop.setErrorMsg("该车牌号不存在，请核对！");
            }
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(e.getMessage());
            return envelop;
        }
    }

    private int validate(ScheduleMsgModel model, Set<String> carIds){
        int rs = 1;
        //验证车牌号
        if(!carIds.contains(model.getCarId())){
            model.addErrorMsg("carId", "该车牌号不存在，请核对！");
            rs = 0;
        }
        return rs;
    }


}
