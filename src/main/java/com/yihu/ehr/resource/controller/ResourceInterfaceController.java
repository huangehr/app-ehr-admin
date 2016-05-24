package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.esb.HosAcqTaskModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.util.Envelop;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by yww on 2016/5/24.
 */
@Controller
@RequestMapping("/resource/resourceInterface")
public class ResourceInterfaceController extends BaseUIController {

    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    @Autowired
    ObjectMapper objectMapper;

    @RequestMapping("/initial")
    public String resourceInterfaceInitial(Model model){
        model.addAttribute("contentPage","/resource/resourceinterface/resourceInterface");
        return "pageView";
    }

    @RequestMapping("/infoInitial")
    public String resourceInterfaceInfoInitial(Model model,String id,String mode){
        model.addAttribute("mode",mode);
        model.addAttribute("contentPage","/resource/resourceinterface/resourceInterfaceInfoDialog");
        Envelop envelop = new Envelop();
        String envelopStr = "";
        try{
            if (!StringUtils.isEmpty(id)) {
                envelopStr = getmodel(id);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
        }
        return "simpleView";
    }

    @RequestMapping("/searchInterfaces")
    @ResponseBody
    public Object searchResource(String searchNm, int page, int rows) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(true);
        List<HosAcqTaskModel> list = new ArrayList<>();
        for(int i=0;i<20;i++){
            HosAcqTaskModel model = new HosAcqTaskModel();
            //模拟数据

            model.setId("10000000"+i);
            model.setOrgCode("wwcs"+i);
            model.setSystemCode("yyww0"+i);
            model.setStartTime("<Req>\n<TransactionCode></TransactionCode>\n<Data>\n<BeginDate>开始时间（格式YYYY-MM-DD HH:mm:ss ）</BeginDate>\n<EndDate>结束时间（格式YYYY-MM-DD HH:mm:ss ）</EndDate>\n</Data>\n</Req>"+i);
            model.setEndTime("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n" +
                    "<Resp>\n" +
                    "<TransactionCode></TransactionCode>\n" +
                    "<RespCode>10000</RespCode>\n" +
                    "<RespMessage>成功</RespMessage>\n" +
                    "<Data>\n" +
                    "<OrgCode>组织机构代码</OrgCode>\n" +
                    "<PatientId>病人ID</PatientId>\n" +
                    "<EventNo>事件号</EventNo>\n" +
                    "<EventType>就诊类型</EventType>\n" +
                    "<EventTime>就诊时间</EventTime>\n" +
                    "<LocalCardNo>就诊卡</LocalCardNo>\n" +
                    "<IdCardId>身份证</IdCardIdNo>\n" +
                    "</Data>\n" +
                    "<Data>\n" +
                    "……\n" +
                    "</Data>\n" +
                    "……\n" +
                    "</Resp>"+i);
            model.setCreateTime("说明说明说明说明说明说明说明说明说明说明说明说明说明说明说明"+i);
            list.add(model);
        }
        envelop.setTotalPage(20);
        envelop.setCurrPage(page);
        envelop.setPageSize(rows);
        envelop.setDetailModelList(list);
        String envelopStr = "";
        try{
            envelopStr = objectMapper.writeValueAsString(envelop);
        }catch (Exception ex){
        }
        return envelopStr;
    }

    @RequestMapping("getResourceInterface")
    @ResponseBody
    public Object getResourceInterface(String id){
        Envelop envelop = new Envelop();
        try{
            String url = ""+id;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        }catch (Exception ex){
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
            envelop.setSuccessFlg(false);
            envelop.setErrorMsg(ErrorCode.SystemError.toString());
            return envelop;
        }
    }

    @RequestMapping("/isNameExist")
    @ResponseBody
    public Object isNameExist(String name){
        Envelop envelop = new Envelop();
        try{
            String url = "";
            Map<String,Object> params = new HashMap<>();
            params.put("",name);
        }catch (Exception ex){

        }
        return null;
    }


    public String getmodel(String id) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(true);
        HosAcqTaskModel model = new HosAcqTaskModel();
        //模拟数据
        model.setId("10000000");
        model.setOrgCode("wwcs");
        model.setSystemCode("yyww0");
        model.setStartTime("<Req>\n<TransactionCode></TransactionCode>\n<Data>\n<BeginDate>开始时间（格式YYYY-MM-DD HH:mm:ss ）</BeginDate>\n<EndDate>结束时间（格式YYYY-MM-DD HH:mm:ss ）</EndDate>\n</Data>\n</Req>");
        model.setEndTime(
                "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n" +
                "<Resp>\n" +
                "<TransactionCode></TransactionCode>\n" +
                "<RespCode>10000</RespCode>\n" +
                "<RespMessage>成功</RespMessage>\n" +
                "<Data>\n" +
                "<OrgCode>组织机构代码</OrgCode>\n" +
                "<PatientId>病人ID</PatientId>\n" +
                "<EventNo>事件号</EventNo>\n" +
                "<EventType>就诊类型</EventType>\n" +
                "<EventTime>就诊时间</EventTime>\n" +
                "<LocalCardNo>就诊卡</LocalCardNo>\n" +
                "<IdCardId>身份证</IdCardIdNo>\n" +
                "</Data>\n" +
                "<Data>\n" +
                "……\n" +
                "</Data>\n" +
                "……\n" +
                "</Resp>");
        model.setCreateTime("说明说明说明说明说明说明说明说明说明说明说明说明说明说明说明");
        envelop.setObj(model);
        String envelopStr = "";
        try{
            envelopStr = objectMapper.writeValueAsString(envelop);
        }catch (Exception ex){
        }
        return envelopStr;
    }




}
