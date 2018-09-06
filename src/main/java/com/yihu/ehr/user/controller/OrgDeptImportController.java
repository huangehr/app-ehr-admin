package com.yihu.ehr.user.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.agModel.user.UsersModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.user.controller.model.OrgDeptMsgModel;
import com.yihu.ehr.user.controller.service.OrgDeptService;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.ObjectFileRW;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.excel.read.OrgDeptMsgModelReader;
import com.yihu.ehr.util.excel.read.OrgDeptMsgModelWriter;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.util.web.RestTemplates;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

/**
 * Created by Administrator on 2017/7/14.
 */
@Controller
@RequestMapping("/orgDeptImport")
public class OrgDeptImportController extends ExtendController<OrgDeptService> {
    @Value("${service-gateway.username}")
    private String username;
    @Value("${service-gateway.password}")
    private String password;
    @Value("${service-gateway.url}")
    private String comUrl;
    static final String parentFile = "orgDept";

    @RequestMapping(value = "importOrgDept")
    @ResponseBody
    public void importOrgDeptMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        UsersModel user = getCurrentUserRedis(request);
        try {
            writerResponse(response, 1+"", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new OrgDeptMsgModelReader();
            excelReader.read(file.getInputStream());
            List<OrgDeptMsgModel> errorLs = excelReader.getErrorLs();
            List<OrgDeptMsgModel> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 20+"", "l_upd_progress");
            List saveLs = new ArrayList<>();
            //获取部门表的部门编号
            Set<String> codes = findExistCodeInOrgDept(toJson(excelReader.getRepeat().get("code")));
            //获取机构表的机构编码
            Set<String> orgCodes = findExistOrgCodeInOrganization(toJson(excelReader.getRepeat().get("orgCode")));
            writerResponse(response, 35+"", "l_upd_progress");
            OrgDeptMsgModel model;
            for(int i=0; i<correctLs.size(); i++) {
                model = correctLs.get(i);
                if (validate(model, codes, orgCodes) == 0) {
                    errorLs.add(model);
                }else{
                    saveLs.add(model);
                }
            }
            for(int i=0; i<errorLs.size(); i++){
                model = errorLs.get(i);
                validate(model, codes, orgCodes);
            }
            writerResponse(response, 55+"", "l_upd_progress");
            Map rs = new HashMap<>();
            if(errorLs.size()>0){
                String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".dat");
                ObjectFileRW.write(new File(TemPath.getFullPath(eFile, parentFile)),errorLs);
                rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
                writerResponse(response, 75 + "", "l_upd_progress");
            }
            if(saveLs.size()>0) {
                saveMeta(toJson(saveLs));
            }
            if(rs.size()>0) {
                writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");
            }else{
                writerResponse(response, 100 + "", "l_upd_progress");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if(e.getMessage().equals("模板不正确，请下载新的模板，并按照示例正确填写后上传！")) {
                writerResponse(response, "-2", "l_upd_progress");
            }else{
                writerResponse(response, "-1", "l_upd_progress");
            }
        }
    }

    private Set<String> findExistCodeInOrgDept(String code) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("code", code);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/code/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }

    private Set<String> findExistOrgCodeInOrganization(String orgCode) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("orgCode", orgCode);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/orgCode/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }

    private Set<String> findExistOrgNameInOrgDept(String orgName) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("name", orgName);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/name/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }

    private int validate(OrgDeptMsgModel model, Set<String> codes, Set<String> orgCodes){
        int rs = 1;
        if(codes.contains(model.getCode())){
            model.addErrorMsg("code", "该部门编号在部门表已存在，请核对！");
            rs = 0;
        }

        if("".equals(model.getName())){
            model.addErrorMsg("name", "部门名称不能为空，请核对！");
            rs = 0;
        }

        if(!orgCodes.contains(model.getOrgCode())){
            model.addErrorMsg("orgCode", "该机构代码不存在，请核对！");
            rs = 0;
        }
        return rs;
    }

    private List saveMeta(String orgDepts) throws Exception {
        Map map = new HashMap<>();
        map.put("orgDepts", orgDepts);
        EnvelopExt<OrgDeptMsgModel> envelop = getEnvelopExt(service.doPost(service.comUrl + "/orgDept/batch", map), OrgDeptMsgModel.class);
        if(envelop.isSuccessFlg()){
            return envelop.getDetailModelList();
        }
        throw new Exception("保存失败！");
    }

    @RequestMapping("/gotoImportLs")
    public String gotoImportLs(Model model, String result){
        try {
            model.addAttribute("files", result);
            model.addAttribute("contentPage", "/organization/impOrgDeptGrid");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "pageView";
    }

    @RequestMapping("/importLs")
    @ResponseBody
    public Object importLs(int page, int rows, String filenName, String datePath){
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
            Envelop envelop = new Envelop();
            envelop.setDetailModelList(g);
            envelop.setTotalCount(total);
            envelop.setSuccessFlg(true);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

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

            new OrgDeptMsgModelWriter().write(toClient, (List) ObjectFileRW.read(file));
            toClient.flush();
            toClient.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("/orgDeptIsExistence")
    @ResponseBody
    public Object orgDeptIsExistence(String filters){
        try {
            Map map = new HashMap<>();
            map.put("filters", filters);
            String resultStr = "";
            resultStr = HttpClientUtil.doGet(comUrl + "/orgDept/code/existence", map, username, password);
            return resultStr;
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }
}
