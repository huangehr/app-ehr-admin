package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.resource.RsInterfaceModel;
import com.yihu.ehr.constants.ErrorCode;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.rest.Envelop;
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
                String url = "/resources/interfaces/"+id;
                envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            }
            model.addAttribute("envelop",StringUtils.isEmpty(envelopStr)?objectMapper.writeValueAsString(envelop):envelopStr);
        }catch (Exception ex){
            LogService.getLogger(ResourceInterfaceController.class).error(ex.getMessage());
        }
        return "emptyView";
    }

    @RequestMapping("/searchRsInterfaces")
    @ResponseBody
    public Object searchRsInterfaces(String searchNm, int page, int rows) {
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(true);
        String envelopStr = "";
        String filters = "";
        try{
            if(!StringUtils.isEmpty(searchNm)){
                filters += "name?"+searchNm+" g1;resourceInterface?"+searchNm+" g1;";
            }
            Map<String,Object> params = new HashMap<>();
            params.put("fields","");
            params.put("filters",filters);
            params.put("sorts","");
            params.put("page",page);
            params.put("size",rows);
            String url = "/resources/interfaces";
            envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
        } catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return envelopStr;
    }

    @RequestMapping("/getResourceInterface")
    @ResponseBody
    public Object getResourceInterface(String id){
        Envelop envelop = new Envelop();
        try{
            String url = "/resources/interfaces/{id}"+id;
            String envelopStr = HttpClientUtil.doGet(comUrl+url,username,password);
            return envelopStr;
        } catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("/findByResourceInterface")
    @ResponseBody
    public Object findByResourceInterface(String resourceInterface){
        Envelop envelop = new Envelop();
        try{
            String url = "/resources/interface";
            Map<String,Object> params = new HashMap<>();
            params.put("resource_interface",resourceInterface);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,params,username,password);
            return envelopStr;
        } catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }
    //新增、修改
    @RequestMapping("/update")
    @ResponseBody
    public Object updateResourceInterface(String dataJson,String mode){
        Envelop envelop = new Envelop();
        envelop.setSuccessFlg(false);
        String url = "/resources/interfaces";
        try{
            RsInterfaceModel model = objectMapper.readValue(dataJson,RsInterfaceModel.class);
            if(StringUtils.isEmpty(model.getName())){
                envelop.setErrorMsg("资源接口名称不能为空！");
                return envelop;
            }
            if("new".equals(mode)){
                Map<String,Object> args = new HashMap<>();
                args.put("json_data",dataJson);
                String envelopStr = HttpClientUtil.doPost(comUrl+url,args,username,password);
                return envelopStr;
            } else if("modify".equals(mode)){
                String urlGet = "/resources/interfaces/"+model.getId();
                String envelopGetStr = HttpClientUtil.doGet(comUrl+urlGet,username,password);
                Envelop envelopGet = objectMapper.readValue(envelopGetStr, Envelop.class);
                if (!envelopGet.isSuccessFlg()){
                    envelop.setErrorMsg("原资源接口信息获取失败！");
                }
                RsInterfaceModel updateModel = getEnvelopModel(envelopGet.getObj(),RsInterfaceModel.class);
                updateModel.setName(model.getName());
                updateModel.setResourceInterface(model.getResourceInterface());
                updateModel.setParamDescription(model.getParamDescription());
                updateModel.setResultDescription(model.getResultDescription());
                updateModel.setDescription(model.getDescription());
                String updateModelJson = objectMapper.writeValueAsString(updateModel);
                Map<String,Object> params = new HashMap<>();
                params.put("json_data",updateModelJson);
                String envelopStr = HttpClientUtil.doPut(comUrl+url,params,username,password);
                return envelopStr;
            }
        }catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
        return envelop;
    }

    //删除
    @RequestMapping("/delete")
    @ResponseBody
    public Object deleteRsInterface(String id){
        Envelop envelop = new Envelop();
        try{
            String url = "/resources/interfaces/"+id;
            String envelopStr = HttpClientUtil.doDelete(comUrl+url,new HashMap<>(),username,password);
            return envelopStr;
        } catch(Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }

    @RequestMapping("/isNameExist")
    @ResponseBody
    public Object isNameExist(String name){
        Envelop envelop = new Envelop();
        try{
            String url = "/resources/existence/name";
            Map<String,Object> args = new HashMap<>();
            args.put("name",name);
            String envelopStr = HttpClientUtil.doGet(comUrl+url,args,username,password);
            return envelopStr;
        } catch (Exception ex){
            ex.printStackTrace();
            return failed(ERR_SYSTEM_DES);
        }
    }
}
