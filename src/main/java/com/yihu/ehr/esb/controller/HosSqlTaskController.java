package com.yihu.ehr.esb.controller;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.esb.HosSqlTaskModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by yww on 2016/5/13.
 */
@Controller
@RequestMapping("/esb/sqlTask")
@SessionAttributes(SessionAttributeKeys.CurrentUser)
public class HosSqlTaskController extends BaseUIController {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    private ObjectMapper objectMapper;

    @RequestMapping("/initial")
    public String hosSqlTaskInitial(Model model){
        model.addAttribute("contentPage","/esb/sqltask/hosSqlTask");
        return  "pageView";
    }

    @RequestMapping("/hosSqlTaskInfoDialog")
    public String hisInfoDialogInitial(Model model){
        model.addAttribute("contentPage","/esb/sqltask/hosSqlTaskInfoDialog");
        return "simpleView";
    }

    @RequestMapping("/result")
    public String queryResult(Model model,String id){
        Envelop envelop = new Envelop();
        model.addAttribute("contentPage","/esb/sqltask/queryResult");
        String envelopStr = "";
        try{
            if(!StringUtils.isEmpty(id)){
                String url = "/esb/hosSqlTask/"+id;
                Map<String,Object> params = new HashMap<>();
                params.put("id",id);
                envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch(Exception ex){
            LogService.getLogger(HosSqlTaskController.class).error(ex.getMessage());
        }
        return "simpleView";
    }

    @RequestMapping("/create")
    @ResponseBody
    public Object createHosSqlTask(String dataJson){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        try{
            HosSqlTaskModel model = objectMapper.readValue(dataJson,HosSqlTaskModel.class);
            if(StringUtils.isEmpty(model.getOrgCode())){
                envelop.setErrorMsg("机构代码不能为空！");
                return envelop;
            }
            if(StringUtils.isEmpty(model.getSystemCode())){
                envelop.setErrorMsg("系统代码不能为空！");
                return envelop;
            }
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            model.setCreateTime(sdf.format(new Date()));
            String url = "/esb/createHosSqlTask";
            Map<String,Object> params = new HashMap<>();
            params.put("json_data",objectMapper.writeValueAsString(model));
            String envelopStr = HttpClientUtil.doPost(comUrl+url,params,username,password);
            return envelopStr;
        }catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("/delete")
    @ResponseBody
    public Object deleteHosSqlTask(String id){
        Envelop envelop = new Envelop();
        try {
            String url = "/esb/deleteHosSqlTask/"+id;
            Map<String,Object> params = new HashMap<>();
            params.put("id",id);
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,params,username,password);
            return envelopStr;
        } catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }

    }

    @RequestMapping("/hosSqlTasks")
    @ResponseBody
    public Object searchHosSqlTasks(String orgSysCode,String status,int page,int rows){
        Envelop envelop = new Envelop();
        String filters = "";
        if (!StringUtils.isEmpty(orgSysCode)){
            filters += "orgCode?"+orgSysCode+" g1;systemCode?"+orgSysCode+" g1;";
        }
        if (!StringUtils.isEmpty(status)){
            filters += "status="+status+";";
        }
        try{
            String url = "/esb/searchHosSqlTasks";
            Map<String,Object> params = new HashMap<>();
            params.put("fields","id,orgCode,systemCode,sqlscript,status,message,createTime");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        } catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("/hosSqlTask")
    @ResponseBody
    public Object getHosSqlTask(String id){
        Envelop envelop = new Envelop();
        try{
            String url = "/esb/hosSqlTask/"+id;
            Map<String,Object> params = new HashMap<>();
            params.put("id",id);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        } catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }
}
