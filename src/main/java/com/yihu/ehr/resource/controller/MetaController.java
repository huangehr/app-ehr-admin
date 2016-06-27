package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.resource.model.RsMetaMsgModel;
import com.yihu.ehr.resource.service.MetaService;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.excel.ObjectFileRW;
import com.yihu.ehr.util.excel.TemPath;
import com.yihu.ehr.util.excel.read.RsMetaMsgModelReader;
import com.yihu.ehr.util.excel.read.RsMetaMsgModelWriter;
import com.yihu.ehr.util.rest.Envelop;
import com.yihu.ehr.web.RestTemplates;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
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
 * @author lincl
 * @version 1.0
 * @created 2016/5/19
 */
@Controller
@RequestMapping("/resource/meta")
public class MetaController extends ExtendController<MetaService> {
    static final String parentFile = "meta";

    public MetaController() {
        this.init(
                "/resource/meta/grid",        //列表页面url
                "/resource/meta/dialog"      //编辑页面url
        );
        comboKv = new HashMap<>();
        comboKv.put("code", "id");
        comboKv.put("value", "name");
        comboKv.put("domainName", "domainName");
        comboKv.put("domain", "domain");
    }

    @RequestMapping("/gotoImportLs")
    public String gotoImportLs(Model model, String result){
        try {
            model.addAttribute("domainData", service.searchSysDictEntries(31));
            model.addAttribute("columnTypeData", service.searchSysDictEntries(30));
            model.addAttribute("ynData", service.searchSysDictEntries(18));
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.addAttribute("files", result);
        model.addAttribute("contentPage", "/resource/meta/impGrid");
        return "pageView";
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

//            toClient = new BufferedOutputStream(response.getOutputStream());
            new RsMetaMsgModelWriter().write(toClient, (List) ObjectFileRW.read(file));
            toClient.flush();
            toClient.close();
        } catch (Exception e) {
            e.printStackTrace();
//            if(toClient!=null) toClient.close();
        }
    }

    @RequestMapping("/batchSave")
    @ResponseBody
    public Object batchSave(String metas, String eFile, String tFile, String datePath){

        try{
            eFile = datePath + TemPath.separator + eFile;
            File file = new File(TemPath.getFullPath(eFile, parentFile));
            List<RsMetaMsgModel> all = (List<RsMetaMsgModel>) ObjectFileRW.read(file);
            List<RsMetaMsgModel> rsMetaMsgModels = objectMapper.readValue(metas, new TypeReference<List<RsMetaMsgModel>>() {});


            Map<String, Set> repeat = new HashMap<>();
            repeat.put("id", new HashSet<String>());
            for(RsMetaMsgModel model : rsMetaMsgModels){
                model.validate(repeat);
            }

            Set<String> existIds = findExistId(toJson(repeat.get("id")));
            String domains = getSysDictEntries(31);
            String columnTypes = getSysDictEntries(30);
            String nullAbles = "[0,1]";

            RsMetaMsgModel model;
            List saveLs = new ArrayList<>();
            for(int i=0; i<rsMetaMsgModels.size(); i++){
                model = rsMetaMsgModels.get(i);
                if(validate(model, existIds, domains, columnTypes, null, nullAbles, 0)==0
                        || model.errorMsg.size()>0)
                    all.set(all.indexOf(model), model);
                else{
                    saveLs.add(model);
                    all.remove(model);
                }

            }
            saveMeta(toJson(saveLs));
            ObjectFileRW.write(file, all);

            return success("");
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
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
            return systemError();
        }
    }

    @RequestMapping(value = "import")
    @ResponseBody
    public void importMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        UserDetailModel user = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        try {
            writerResponse(response, 1+"", "l_upd_progress");
            request.setCharacterEncoding("UTF-8");
            AExcelReader excelReader = new RsMetaMsgModelReader();
            excelReader.read(file.getInputStream());
            List<RsMetaMsgModel> errorLs = excelReader.getErrorLs();
            List<RsMetaMsgModel> correctLs = excelReader.getCorrectLs();
            writerResponse(response, 20+"", "l_upd_progress");

            Set<String> dictCodeSet = excelReader.getRepeat().get("dictCode");
            String dictCodes = "";
            for(String code :dictCodeSet){
                dictCodes += "," + code;
            }
            List saveLs = new ArrayList<>();

            Set<String> ids = findExistId(toJson(excelReader.getRepeat().get("id")));
            String domains = getSysDictEntries(31);
            String columnTypes = getSysDictEntries(30);
            String nullAbles = "[0,1]";
            Map dictIds = null;
            if(dictCodes.length()>0)
                dictIds = getDictIds(dictCodes.substring(1));
            writerResponse(response, 35+"", "l_upd_progress");
            RsMetaMsgModel model;
            for(int i=0; i<correctLs.size(); i++){
                model = correctLs.get(i);
                if(validate(model, ids, domains, columnTypes, dictIds, nullAbles, 1)==0)
                    errorLs.add(model);
                else
                    saveLs.add(model);
            }
            for(int i=0; i<errorLs.size(); i++){
                model = errorLs.get(i);
                validate(model, ids, domains, columnTypes, dictIds, nullAbles, 1);
            }
            writerResponse(response, 55+"", "l_upd_progress");

            String eFile = TemPath.createFileName(user.getLoginCode(), "e", parentFile, ".dat");
            ObjectFileRW.write(new File(TemPath.getFullPath(eFile, parentFile)),errorLs);
            Map rs = new HashMap<>();
            rs.put("eFile", new String[]{eFile.substring(0, 10), eFile.substring(11, eFile.length())});
            writerResponse(response, 75 + "", "l_upd_progress");

            if(saveLs.size()>0)
                saveMeta(toJson(saveLs));
            writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");
        } catch (Exception e) {
            e.printStackTrace();
            writerResponse(response, "-1", "l_upd_progress");
        }
    }



    private int validate(RsMetaMsgModel model, Set<String> ids, String domains,
                         String columnTypes, Map dictIds, String nullAbles, int type){
        int rs = 1;
        if(ids.contains(model.getId())){
            model.addErrorMsg("id", "该资源标准编码已存在！");
            rs = 0;
        }
        int i = 0;
        if((i=domains.indexOf(model.getDomain()))==0 || i==-1){
            model.addErrorMsg("domain", "只能是"+ domains +"里的值！");
            rs = 0;
        }

        if( (i=columnTypes.indexOf(model.getColumnType()))==0 || i==-1 ){
            model.addErrorMsg("columnType", "只能是"+ columnTypes +"里的值！");
            rs = 0;
        }

        if( (i=nullAbles.indexOf(model.getNullAble()))==0 || i==-1 ){
            model.addErrorMsg("nullAble", "只能是"+ nullAbles +"里的值！");
            rs = 0;
        }

        if(type==1 && !StringUtils.isEmpty(model.getDictCode())){
            if(dictIds==null){
                model.addErrorMsg("dictCode", "该字典代码不存在！");
                rs = 0;
            }else {
                Integer dictId = (Integer) dictIds.get(model.getDictCode());
                if(dictId==null || dictId==0){
                    model.addErrorMsg("dictCode", "该字典代码不存在！");
                    rs = 0;
                }else
                    model.setDictId(dictId);
            }
        }
        return rs;
    }

    private Map getDictIds( String dictCodes) throws Exception {
        PageParms pageParms = new PageParms(5000,1)
                .addGroupNotNull("code", dictCodes, "g1")
                .setFields("id,code");
        Envelop rs = getEnvelop(service.search("/resources/dict", pageParms));
        if(rs.isSuccessFlg()){
            Map dictIds = new HashMap<>();
            List<Map> maps = rs.getDetailModelList();
            for (Map map : maps){
                dictIds.put(map.get("code"), map.get("id"));
            }
            return dictIds;
        }
        throw new Exception("获取字典数据出错");
    }


    private String getSysDictEntries(int dictId) throws Exception {
        Envelop envelop = getEnvelop(service.searchSysDictEntries(dictId));
        if(!envelop.isSuccessFlg())
            throw new Exception("预加载字典失败！");
        String str = "[";
        for(Map map: (List<Map>)envelop.getDetailModelList()){
            str += String.valueOf(map.get("code")) +",";
        }
        return str.substring(0, str.length()-1) + "]";
    }

    private List saveMeta(String metas) throws Exception {
        Map map = new HashMap<>();
        map.put("metadatas", metas);
        EnvelopExt<RsMetaMsgModel> envelop = getEnvelopExt(service.doPost(service.comUrl + "/resources/metadata/batch", map), RsMetaMsgModel.class);
        if(envelop.isSuccessFlg())
            return envelop.getDetailModelList();
        throw new Exception("保存失败！");
    }

    private Set<String> findExistId(String ids) throws Exception {
        MultiValueMap<String,String> conditionMap = new LinkedMultiValueMap<String, String>();
        conditionMap.add("ids", ids);

        RestTemplates template = new RestTemplates();
        String rs = template.doPost(service.comUrl + "/resources/metadata/id/existence", conditionMap);

        return objectMapper.readValue(rs, new TypeReference<Set<String>>() {});
    }
}
