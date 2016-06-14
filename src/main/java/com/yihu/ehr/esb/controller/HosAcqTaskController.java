package com.yihu.ehr.esb.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.esb.HosAcqTaskModel;
import com.yihu.ehr.agModel.org.OrgModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.DateTimeUtils;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.controller.BaseUIController;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.operator.DateUtil;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by yww on 2016/5/13.
 */
@Controller
@RequestMapping("/esb/acqTask")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class HosAcqTaskController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    private ObjectMapper objectMapper;

    @RequestMapping("/initial")
    public String acqInitial(Model model){
        model.addAttribute("contentPage","/esb/acqtask/hosAcqTask");
        return  "pageView";
    }

    @RequestMapping("/acqInfoDialog")
    public String acqInfoDialog(Model model,String acqId,String mode){
        Envelop envelop = new Envelop();
        model.addAttribute("contentPage","/esb/acqtask/hosAcqTaskInfoDialog");
        model.addAttribute("mode",mode);
        String envelopStr = "";
        try{
            if (!StringUtils.isEmpty(acqId)) {
                String url = "/esb/hosAcqTask/" + acqId;
                envelopStr = HttpClientUtil.doGet(comUrl + url, username, password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(HosAcqTaskController.class).error(ex.getMessage());
        }
        return "simpleView";
    }

    @RequestMapping("/hosAcqTasks")
    @ResponseBody
    public Object searchHosAcqTasks(String orgSysCode,String status,String startTimeLow,String startTimeUp,String endTimeLow,String endTimeUp,int page,int rows){
        Envelop envelop = new Envelop();
        String filters = "";
        try{
            if (!StringUtils.isEmpty(orgSysCode)){
                filters += "orgCode?"+orgSysCode+" g1;systemCode?"+orgSysCode+" g1;";
            }
            if (!StringUtils.isEmpty(status)){
                filters += "status="+status+";";
            }
            //按时间过滤
            if(!(StringUtils.isEmpty(startTimeLow)&&StringUtils.isEmpty(startTimeUp))){
                filters += formatTimeFilters("startTime",startTimeLow,startTimeUp);
            }
            if(!(StringUtils.isEmpty(endTimeLow)&&StringUtils.isEmpty(endTimeUp))){
                filters += formatTimeFilters("endTime",endTimeLow,endTimeUp);
            }
            String url = "/esb/searchHosAcqTasks";
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(HosAcqTaskController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            envelop.setSuccessFlg(false);
            return envelop;
        }
    }

    /**
     * 检索条件的时间区间格式化并拼接成过滤条件
     * @param fieldName
     * @param timeLow
     * @param timeUp
     * @return
     */
    public String formatTimeFilters(String fieldName,String timeLow,String timeUp) throws Exception{
        StringBuffer buffer = new StringBuffer();
        if(StringUtils.isEmpty(timeLow)){
            Date dateUp = DateTimeUtils.simpleDateTimeParse(timeUp);
            buffer.append(fieldName+"<=");
            buffer.append(DateTimeUtils.utcDateTimeFormat(dateUp)+";");
        }else if(StringUtils.isEmpty(timeUp)){
            Date dateLow = DateTimeUtils.simpleDateTimeParse(timeLow);
            buffer.append(fieldName+">=");
            buffer.append(DateTimeUtils.utcDateTimeFormat(dateLow)+";");
        }else {
            Date dateLow = DateTimeUtils.simpleDateTimeParse(timeLow);
            Date dateUp = DateTimeUtils.simpleDateTimeParse(timeUp);
            buffer.append(fieldName+">=");
            buffer.append(DateTimeUtils.utcDateTimeFormat(dateLow)+";");
            buffer.append(fieldName+"<=");
            buffer.append(DateTimeUtils.utcDateTimeFormat(dateUp)+";");
        }
        return buffer.toString();
    }

    @RequestMapping("/update")
    @ResponseBody
    public Object updateHosAcqTask(String dataJson,String mode){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            HosAcqTaskModel model = objectMapper.readValue(dataJson,HosAcqTaskModel.class);
            try {
                model.setStartTime(changeToUtc(model.getStartTime()));
                model.setEndTime(changeToUtc(model.getEndTime()));
            }catch (Exception ex){
                envelop.setErrorMsg("时间格式有误！");
                return envelop;
            }
            if(StringUtils.isEmpty(model.getOrgCode())){
                envelop.setErrorMsg("机构代码不能为空！");
                return envelop;
            }
            if(StringUtils.isEmpty(model.getSystemCode())){
                envelop.setErrorMsg("系统编码不能为空！");
                return envelop;
            }
            if(DateUtil.compareDate("yyyy-MM-dd HH:mm:ss",model.getStartTime(),model.getEndTime()) >= 0){
                envelop.setErrorMsg("结束时间不能小于开始时间！");
                return envelop;
            }
            //(重复判断？--机构code+系统code）
            Map<String,Object> params = new HashMap<>();
            if("new".equals(mode)){
                String urlCreate = "/esb/createHosAcqTask";
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                model.setCreateTime(changeToUtc(sdf.format(new Date())));
                params.put("json_data",objectMapper.writeValueAsString(model));
                String envelopStr = HttpClientUtil.doPost(comUrl+urlCreate,params,username,password);
                return envelopStr;
            }
            String urlGet = "/esb/hosAcqTask/"+model.getId();
            String envelopStrGet = HttpClientUtil.doGet(comUrl+urlGet,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStrGet,Envelop.class);
            if(envelopGet.isSuccessFlg()){
                String urlUpdate = "/esb/updateHosAcqTask";
                HosAcqTaskModel updateModel = getEnvelopModel(envelopGet.getObj(),HosAcqTaskModel.class);
                updateModel.setCreateTime(changeToUtc(updateModel.getCreateTime()));
                updateModel.setOrgCode(model.getOrgCode());
                updateModel.setSystemCode(model.getSystemCode());
                updateModel.setStartTime(model.getStartTime());
                updateModel.setEndTime(model.getEndTime());
                params.put("json_data",objectMapper.writeValueAsString(updateModel));
                String envelopStr = HttpClientUtil.doPut(comUrl+urlUpdate,params,username,password);
                return envelopStr;
            }
        }catch (Exception ex){
            LogService.getLogger(HosAcqTaskController.class).error(ex.getMessage());
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
        }
        return envelop;

    }
    /**
     * yyyy-MM-dd HH:mm:ss 转化为utc时间
     */
    public String changeToUtc(String timeStr) throws Exception{
        if(!StringUtils.isEmpty(timeStr)){
            Date date = DateTimeUtils.simpleDateTimeParse(timeStr);
            timeStr = DateTimeUtils.utcDateTimeFormat(date);
        }
        return timeStr;
    }

    @RequestMapping("delete")
    @ResponseBody
    public Object deleteHosAcqTask(String id){
        Envelop envelop = new Envelop();
        try{
            String url = "/esb/deleteHosAcqTask/"+id;
            Map<String,Object> params = new HashMap<>();
            params.put("id",id);
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(HosAcqTaskController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    /**
     * 获取机构代码下拉框(根据输入机构代码/名称近似查询）
     * @param searchParm  控件传递参数的参数名
     * @param page
     * @param rows
     * @return
     */
    @RequestMapping("/orgCodes")
    @ResponseBody
    public Object searchOrgCodes(String searchParm,int page,int rows){
        Envelop envelop = new Envelop();
        String filters = "";
        try{
            if (!StringUtils.isEmpty(searchParm)){
                filters += "orgCode?"+searchParm+" g1;fullName?"+searchParm+" g1;";
                //filters += "orgCode?"+searchParm+";";

            }
            String url = "/organizations";
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            String envelopStrFGet = HttpClientUtil.doGet(comUrl+url,params,username,password);
            Envelop envelopGet = objectMapper.readValue(envelopStrFGet,Envelop.class);
            List<OrgModel> orgModels = new ArrayList<>();
            List<Map> list = new ArrayList<>();
            if(envelopGet.isSuccessFlg()){
                orgModels = (List<OrgModel>)getEnvelopList(envelopGet.getDetailModelList(),new ArrayList<OrgModel>(),OrgModel.class);
                for (OrgModel m:orgModels){
                    Map map = new HashMap<>();
                    map.put("id",m.getOrgCode());
                    map.put("name",m.getFullName());
                    list.add(map);
                }
                envelopGet.setDetailModelList(list);
                return envelopGet;
            }
            return envelop;
        }catch (Exception ex){
            LogService.getLogger(HosAcqTaskController.class).error(ex.getMessage());
            return envelop;
        }
    }
}
