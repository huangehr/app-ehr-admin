package com.yihu.ehr.adapter.controller;

import com.yihu.ehr.adapter.service.ExtendService;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.util.controller.BaseUIController;
import com.yihu.ehr.util.rest.Envelop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/3/19
 */
public class ExtendController<T extends ExtendService> extends BaseUIController {

    @Autowired
    public T service;

    public String listUrl = "";
    public String modifyUrl = "";
    public String addUrl = "";

    public Map<String, String> comboKv = null;

    {
        comboKv = new HashMap<>();
        comboKv.put("code", "id");
        comboKv.put("value", "name");
    }

    public void init(String listUrl, String modifyUrl){
        this.init(listUrl, modifyUrl, modifyUrl);
    }

    public void init(String listUrl, String modifyUrl, String addUrl){
        this.listUrl = listUrl;
        this.addUrl = addUrl;
        this.modifyUrl = modifyUrl;
    }

    @RequestMapping("/initial")
    public String gotoList(Model model, String dataModel){
        model.addAttribute("dataModel",dataModel);
        model.addAttribute("contentPage", this.listUrl);
        return "emptyView";
    }


    @RequestMapping("/gotoModify")
    public Object gotoModify(Model model, String id, String mode, String extParms, String myFlag){
        try {
            Envelop envelop = new Envelop();

            Map<String, Object> params = new HashMap<>();
            params.put("id",id);
            params.put("mode",mode);
            params = putAll(extParms, params);
            params = beforeGotoModify(params);

            if (!StringUtils.isEmpty(id))
                envelop = getEnvelop(service.getModel(params));

            Object plan;
            if(envelop.getObj()==null)
                plan = service.newModel();
            else
                plan = envelop.getObj();

            plan = afterGotoModify(plan, params);

            model.addAttribute("model",toJson(plan));
            model.addAttribute("mode",mode);
            model.addAttribute("myFlag",myFlag);
            model.addAttribute("contentPage", getModeUrl(mode));
            model.addAttribute("staged", params.get("staged"));
            return "emptyView";
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @RequestMapping("/model")
    @ResponseBody
    public Object getModel(String id, String extParms){
        try {
            Envelop envelop = new Envelop();
            if (!StringUtils.isEmpty(id)){
                Map<String, Object> params = new HashMap<>();
                params.put("id",id);

                params = putAll(extParms, params);
                params = beforeGotoModify(params);

                envelop = getEnvelop(service.getModel(params));
            }
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @RequestMapping("/list")
    @ResponseBody
    public Object search(String fields, String filters, String sorts, int page, int rows, String extParms){

        try{
            Map<String, Object> params = new HashMap<>();
            params.put("fields", nullToSpace(fields));
            params.put("filters",nullToSpace(filters));
            params.put("sorts",nullToSpace(sorts));
            params.put("page",page);
            params.put("size",rows);
            putAll(extParms, params);
            String url = beforeSearch(service.searchUrl, params);
            String resultStr = service.search(url, params);
            return afterSearch(resultStr);
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }


    @RequestMapping("/combo")
    @ResponseBody
    public Object comboSearch(String fields, String filters, String sorts, int page, int rows){

        try{
            Map<String, Object> params = new HashMap<>();
            params.put("fields", nullToSpace(fields));
            params.put("filters",nullToSpace(filters));
            params.put("sorts",nullToSpace(sorts));
            params.put("page",page);
            params.put("size",rows);

            String resultStr = service.search(params);
            resultStr = afterComboSearch(resultStr);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @RequestMapping("/existence")
    @ResponseBody
    public Object isExistence(String filters){
        try {
            Map map = new HashMap<>();
            map.put("filters", filters);
            return service.isExistence(map);
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    public String afterComboSearch(String resultStr) {
        Envelop envelop = getEnvelop(resultStr);
        List ls = envelop.getDetailModelList();
        List rs = new ArrayList<>();
        if(comboKv!=null){
            Map<String, String> map;
            Map<String, String> combo;
            for(int i=0; i<ls.size(); i++){
                map = ((Map) ls.get(i));
                combo = new HashMap<>();
                for(String key : comboKv.keySet()){
                    combo.put(key, map.get(comboKv.get(key)));
                }
                rs.add(combo);
            }
        }
        envelop.setDetailModelList(rs);
        return toJson(envelop);
    }

    @RequestMapping("/delete")
    @ResponseBody
    public Object delete(String ids, String idField, String extParms, String type){

        try {
            Map<String, Object> params = new HashMap<>();
            if(StringUtils.isEmpty(idField))
                params.put("ids", nullToSpace(ids));
            else
                params.put(idField, nullToSpace(ids));

            params = putAll(extParms, params);

            params = beforeDel(params);
            String rs;
            if("uniq".equals(type))
                rs = service.deleteUniq(params);
            else
                rs = service.delete(params);

            return afterDel(rs, params);
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }


    @RequestMapping("/update")
    @ResponseBody
    public Object update(String id, String model, String modelName, String extParms){

        try {
            Map<String, Object> params = new HashMap<>();
            params.put("id",id);
            if(StringUtils.isEmpty(modelName))
                params.put("model",model);
            else
                params.put(modelName,model);

            params =  putAll(extParms, params);

            params = beforeUpdate(params);
            String resultStr = "";
            if(StringUtils.isEmpty(id) || "0".equals(id))
                resultStr = service.add(params);
            else
                resultStr = service.update(params);

            return afterUpdate(resultStr, id, model, params);
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    public String beforeSearch(String searchUrl, Map<String, Object> params) {

        return searchUrl;
    }

    public Object afterSearch(String rs){

        return rs;
    }

    public Object afterGotoModify(Object rs, Map params){

        return rs;
    }

    public Map beforeGotoModify(Map params){

        return params;
    }

    public Object afterDel(String rs,  Map<String, Object> params){

        return rs;
    }

    public Map beforeDel(Map params){

        return params;
    }

    public String afterUpdate(String rs, String id, String model, Map<String, Object> params){

        return rs;
    }

    public Map beforeUpdate(Map params){

        return params;
    }

    public Envelop systemError(){

        return faild("系统错误！");
    }

    public Envelop pramsError(){

        return faild("参数出错！");
    }

    public Envelop faild(String msg){
        Envelop result = new Envelop();
        result.setSuccessFlg(false);
        result.setErrorMsg(msg);
        return result;
    }

    public String getModeUrl(String mode){
        if("add".equals(mode))
            return this.addUrl;
        return this.modifyUrl;
    }

    public String nullToSpace(String str){
        if(str == null)
            return "";
        return str;
    }

    public Map putAll(String sourceJson, Map target){
        if(!StringUtils.isEmpty(sourceJson)){
            Map<String, String> source = new HashMap<>();
            try {
                source = objectMapper.readValue(sourceJson, Map.class);
            } catch (IOException e) {
                e.printStackTrace();
            }
            for(Object key : source.keySet()){
                target.put(key, source.get(key));
            }
        }
        return target;
    }

    public Envelop formatComboData(String resultStr, String idField, String nameField){
        Envelop rs = getEnvelop(resultStr);
        List ls = new ArrayList<>();
        if(rs.getDetailModelList()!=null && rs.getDetailModelList().size()>0){
            Map<String, String> tem, map;
            for(Object obj: rs.getDetailModelList()){
                map = ((Map) obj);
                tem = new HashMap<>();
                tem.put("id", map.get(idField));
                tem.put("name", map.get(nameField));
                ls.add(tem);
            }
        }
        rs.setDetailModelList(ls);
        return rs;
    }

    public EnvelopExt getEnvelopExt(String json){
        try {
            return objectMapper.readValue(json, service.getExtTypeReference());
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    public EnvelopExt getEnvelopExt(String json, Class entity){
        try {
            return objectMapper.readValue(json, service.initExtTypeReference(entity));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
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
