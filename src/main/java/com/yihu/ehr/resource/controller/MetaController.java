package com.yihu.ehr.resource.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.yihu.ehr.adapter.controller.ExtendController;
import com.yihu.ehr.adapter.service.PageParms;
import com.yihu.ehr.agModel.resource.RsMetaMsgModel;
import com.yihu.ehr.agModel.user.UserDetailModel;
import com.yihu.ehr.common.utils.EnvelopExt;
import com.yihu.ehr.constants.SessionAttributeKeys;
import com.yihu.ehr.resource.service.MetaService;

import com.yihu.ehr.util.operator.DateUtil;
import com.yihu.ehr.util.rest.Envelop;
import javafx.util.Pair;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.write.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.*;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/5/19
 */
@Controller
@RequestMapping("/resource/meta")
public class MetaController extends ExtendController<MetaService> {
    String tmpdir = System.getProperty("java.io.tmpdir");
    String separator = System.getProperty("file.separator");
    String fileType = ".xls";
    String defPath = "ehr" + separator;

    private String[] excelHeader = new String[]{"资源标准编码", "数据元名称", "业务领域", "内部标识符", "类型",	"关联字段","是否允空", "说明", "关联字典编号"};

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

        InputStream fis=null;
        OutputStream toClient = null;
        try{
            f = datePath + separator + f;
            File file = new File( getFullPath(f) );
            fis = new BufferedInputStream(new FileInputStream(file));
            byte[] buffer = new byte[fis.available()];
            fis.read(buffer);
            fis.close();

            response.reset();
            response.setContentType("octets/stream");
            response.addHeader("Content-Length", "" + file.length());
            response.addHeader("Content-Disposition", "attachment; filename="
                    + new String(f.getBytes("gb2312"), "ISO8859-1"));

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

    @RequestMapping("/batchSave")
    @ResponseBody
    public Object batchSave(String metas, String eFile, String tFile, String datePath){

        try{
            List ls = saveMeta(metas);
            List<RsMetaMsgModel> rsMetaMsgModel = objectMapper.readValue(metas, new TypeReference<List<RsMetaMsgModel>>() {});
            eFile = datePath + separator + eFile;
            cleanExcel(rsMetaMsgModel, ls, eFile, tFile);
            return success("");
        } catch (Exception e) {
            e.printStackTrace();
            return systemError();
        }
    }

    @RequestMapping("/importLs")
    @ResponseBody
    public Object importLs(int page, int rows, String filenName, String datePath){
        Workbook rwb= null;
        try{
            File file = new File( getFullPath( datePath + separator + filenName ) );
            rwb = Workbook.getWorkbook(file);
            Sheet sheet = rwb.getSheet(0);

            int start = (page-1) * rows + 1;
            int total = sheet.getRows();
            int end = start + rows;
            end = end > total ? total : end;

            List ls = new ArrayList<>();
            for(int i=start; i<end; i++){
                ls.add(initModel(i, sheet));
            }
            rwb.close();

            Envelop envelop = new Envelop();
            envelop.setDetailModelList(ls);
            envelop.setTotalCount(total-1);
            envelop.setSuccessFlg(true);
            return envelop;
        } catch (Exception e) {
            e.printStackTrace();
            if(rwb!=null) rwb.close();
            return systemError();
        }
    }

    @RequestMapping(value = "import")
    @ResponseBody
    public void importMeta(MultipartFile file, HttpServletRequest request, HttpServletResponse response) throws IOException {

        UserDetailModel user = (UserDetailModel) request.getSession().getAttribute(SessionAttributeKeys.CurrentUser);
        try {
            request.setCharacterEncoding("UTF-8");
            Workbook rwb = Workbook.getWorkbook(file.getInputStream());
            Sheet[] sheets = rwb.getSheets();

            RsMetaMsgModel model;
            List<RsMetaMsgModel> all = new ArrayList<>();
            int rows;

            writerResponse(response, 10+"", "l_upd_progress");

            Set<String> dictCode = new HashSet<>();
            String dictCodes = "";
            for(Sheet sheet : sheets){
                rows = sheet.getRows();
                for(int i=1; i<rows; i++){
                    model = initModel(i, sheet);
                    if(!StringUtils.isEmpty(model.getDictCode()) && dictCode.add(model.getDictCode()))
                        dictCodes += "," + model.getDictCode();
                    all.add(model);
                }
            }
            rwb.close();
            writerResponse(response, 55+"", "l_upd_progress");

            Map<String, List<RsMetaMsgModel>> validateRs = validate(all, dictCodes);
            List<RsMetaMsgModel> trueLs = validateRs.get("correct");
            List<RsMetaMsgModel> errorLs = validateRs.get("error");

            //将保存失败的添加到错误列表， 并从正确列表删除
            if(trueLs.size()>0){
                List ls = saveMeta(toJson(trueLs));
                if(ls!=null)
                    errorLs.addAll(ls);
            }

//            trueLs.removeAll(ls); //新增成功功能暂时不用

            writerResponse(response, 75 + "", "l_upd_progress");

            String eFile = createFileName(user.getLoginCode(), "e");
            createXls(errorLs, eFile);
//            String tFile = createFileName(user.getLoginCode(), "t");
//            createXls(trueLs, tFile); //新增成功功能暂时不用

            Map rs = new HashMap<>();
            rs.put("eFile", eFile.split("\\\\"));
//            rs.put("tFile", tFile);
            writerResponse(response, 100 + ",'" + toJson(rs) + "'", "l_upd_progress");
        } catch (Exception e) {
            e.printStackTrace();
            writerResponse(response, "-1", "l_upd_progress");
        }
    }

    private Map getDictIds( String dictCodes) throws Exception {
        PageParms pageParms = new PageParms(1000,1)
                .addEqual("code", dictCodes)
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

    private boolean validateDictCode(RsMetaMsgModel model, Map dictIds){

        if(!StringUtils.isEmpty(model.getDictCode())){
            if(dictIds==null){
                model.addErrorMsg("dictId", "该字典代码不存在！");
                return false;
            }

            Integer dictId = (Integer) dictIds.get(model.getDictCode());
            if(dictId==null || dictId==0){
                model.addErrorMsg("dictId", "该字典代码不存在！");
                return false;
            }
            model.setDictId(dictId);
        }
        return true;
    }

    private Map validate(List<RsMetaMsgModel> all,  String dictCodes) throws Exception {
        Pair<String, List> domainData = getSysDictEntries(31);
        Pair<String, List> columnTypeData = getSysDictEntries(30);
        Map dictIds=null;
        if(!StringUtils.isEmpty(dictCodes))
            dictIds = getDictIds(dictCodes.substring(1));

        Set<String> stdCodes = new HashSet<>();
        Set<String> ids = new HashSet<>();
        List<RsMetaMsgModel> trueLs = new ArrayList<>();
        List<RsMetaMsgModel> errorLs = new ArrayList<>();

        for(RsMetaMsgModel model: all){
            if(validModel(model, domainData.getKey(), columnTypeData.getKey(), "0, 1", stdCodes, ids)
                    & validateDictCode(model, dictIds))
                trueLs.add(model);
            else
                errorLs.add(model);
        }
        Map rs = new HashMap<>();
        rs.put("error", errorLs);
        rs.put("correct", trueLs);
        return rs;
    }

    private boolean validModel(RsMetaMsgModel model, String domainData, String columnTypeData, String ynData,
                               Set<String> stdCodes, Set<String> ids){

        boolean valid = model.validate() & model.validateHas(domainData, columnTypeData, ynData);

        if(valid){
            int stdCodeLen = stdCodes.size(), idLen = ids.size();

            stdCodes.add(model.getStdCode());
            if(stdCodes.size()==stdCodeLen){
                model.addStdCodeMsg("该内部标识符已存在！");
                valid = false;
            }

            ids.add(model.getId());
            if(ids.size()==idLen){
                model.addIdMsg("该资源标准编码已存在！");
                valid = false;
            }
        }
        return valid;
    }

    private Pair<String, List> getSysDictEntries(int dictId) throws Exception {
        Envelop envelop = getEnvelop(service.searchSysDictEntries(dictId));
        if(!envelop.isSuccessFlg())
            throw new Exception("预加载字典失败！");
        String codes = "";
        for(Map map: (List<Map>)envelop.getDetailModelList()){
            codes += "," + map.get("code");
        }
        return new Pair<>(codes, envelop.getDetailModelList());
    }

    private void cleanExcel(List<RsMetaMsgModel> toSaveLs, List<RsMetaMsgModel> errLs, String eFile, String tFile) throws Exception {

        Workbook rwb = null;
        try {
            toSaveLs.removeAll(errLs);
            File file = new File( getFullPath(eFile) );
            rwb = Workbook.getWorkbook(file);
            Sheet[] sheets = rwb.getSheets();

            List<RsMetaMsgModel> ls = new ArrayList<>();
            int rows;
            RsMetaMsgModel model;
            for(Sheet sheet : sheets){
                rows = sheet.getRows();
                for(int i=1; i<rows; i++){
                    model = initModel(i, sheet);
                    ls.add(model);
                }
            }
            rwb.close();

            ls.removeAll(toSaveLs);
            copy(ls, errLs);

            createXls(ls , eFile);
//            addToXls(toSaveLs, tFile);  //新增成功功能暂时不用
        }catch (Exception e){
            if(rwb!=null) rwb.close();
            throw e;
        }
    }

    private void copy(List<RsMetaMsgModel> ls, List<RsMetaMsgModel> errLs) {
        int idx = 0;
        RsMetaMsgModel source;
        for(RsMetaMsgModel model : ls){
            if((idx = errLs.indexOf(model)) != -1){
                source = errLs.get(idx);
                model.setId(source.getId());
                model.setName(source.getName());
                model.setDomain(source.getDomain());
                model.setColumnType(source.getColumnType());
                model.setNullAble(source.getNullAble());
                model.setDictCode(source.getDictCode());
                model.setDictId(source.getDictId());
                model.setErrMsg(source.getErrMsg());
                model.setDescription(source.getDescription());
            }
        }
    }

    private void addToXls(List<RsMetaMsgModel> ls, String fileName) throws Exception {
        Workbook wb = null;
        WritableWorkbook wwb = null;
        try {
            wb = Workbook.getWorkbook(new File(fileName));
            wwb = Workbook.createWorkbook(new File(fileName), wb);

            WritableSheet ws =  wwb.getSheet(0);
            int rows = ws.getRows();
            RsMetaMsgModel model;
            for(int i=0; i<ls.size(); i++, rows++){
                model = ls.get(i);
                addCell(ws, 0, rows, model.getId(), model.findIdMsg());
                addCell(ws, 1, rows, model.getName(), model.findNameMsg());
                addCell(ws, 2, rows, model.getDomain(), model.findDomainMsg());
                addCell(ws, 3, rows, model.getStdCode(), model.findStdCodeMsg());
                addCell(ws, 4, rows, model.getColumnType(), model.findColumnTypeMsg());
                addCell(ws, 5, rows, model.getDictCode(), model.findDictCodeMsg());
                addCell(ws, 6, rows, model.getNullAble(), model.findNullAbleMsg());
            }
            wwb.write();
        } catch (Exception e){
            throw e;
        } finally {
            if(wwb!=null) wwb.close();
            if(wb!=null) wb.close();
        }
    }

    private void createXls(List<RsMetaMsgModel> ls, String fileName) throws Exception {
        WritableWorkbook wwb = null;
        try {
            File f = new File( getFullPath(fileName) );
            if(f.exists())
                f.delete();
            f.createNewFile();

            wwb = Workbook.createWorkbook(f);
            WritableSheet ws = wwb.createSheet("Sheet1", 0);
            RsMetaMsgModel model;
            addHeader(ws);
            for(int i=1; i<=ls.size(); i++){
                model = ls.get(i-1);
                addCell(ws, 0, i, model.getId(), model.findIdMsg());
                addCell(ws, 1, i, model.getName(), model.findNameMsg());
                addCell(ws, 2, i, model.getDomain(), model.findDomainMsg());
                addCell(ws, 3, i, model.getStdCode(), model.findStdCodeMsg());
                addCell(ws, 4, i, model.getColumnType(), model.findColumnTypeMsg());
                addCell(ws, 5, i, model.getDictCode(), model.findErrorMsg("dictId"));
                addCell(ws, 6, i, model.getNullAble(), model.findNullAbleMsg());
                addCell(ws, 7, i, model.getDescription(), model.getDescription());
                addCell(ws, 8, i, model.getDictId()+"");
            }
            wwb.write();
        }catch (Exception e){
            throw e;
        }finally {
            if(wwb!=null) wwb.close();
        }
    }

    private RsMetaMsgModel initModel(int row, Sheet sheet){
        RsMetaMsgModel model = new RsMetaMsgModel();
        model.setSeq(row);
        Cell cell = sheet.getCell(0, row);
        model.setId(cell.getContents());
        readCellFeatures(cell, model, "id");

        cell = sheet.getCell(1, row);
        model.setName(cell.getContents());
        readCellFeatures(cell, model, "name");

        cell = sheet.getCell(2, row);
        model.setDomain(cell.getContents());
        readCellFeatures(cell, model, "domain");

        cell = sheet.getCell(3, row);
        model.setStdCode(cell.getContents());
        readCellFeatures(cell, model, "stdCode");

        cell = sheet.getCell(4, row);
        model.setColumnType(cell.getContents());
        readCellFeatures(cell, model, "columnType");

        cell = sheet.getCell(5, row);
        model.setDictCode(cell.getContents());
        readCellFeatures(cell, model, "dictCode");

        cell = sheet.getCell(6, row);
        model.setNullAble(cell.getContents());
        readCellFeatures(cell, model, "nullAble");

        cell = sheet.getCell(7, row);
        model.setDescription(cell.getContents());
        readCellFeatures(cell, model, "description");

        try{
            cell = sheet.getCell(8, row);
            model.setDictId(Integer.parseInt(cell.getContents()));
        }catch (Exception e){}

        return model;
    }

    private void readCellFeatures(Cell cell, RsMetaMsgModel model, String columnName) {
        if(cell.getCellFeatures()!=null)
            model.getErrMsg().put(columnName, cell.getCellFeatures().getComment());
    }

    private List saveMeta(String metas) throws Exception {
        Map map = new HashMap<>();
        map.put("metadatas", metas);
        EnvelopExt<RsMetaMsgModel> envelop = getEnvelopExt(service.doPost(service.comUrl + "/resources/metadata/batch", map), RsMetaMsgModel.class);
        if(envelop.isSuccessFlg())
            return envelop.getDetailModelList();
        throw new Exception("保存失败！");
    }

    private void addHeader(WritableSheet ws) throws WriteException {
        for(int i=0; i<excelHeader.length; i++){
            addCell(ws, i, 0, excelHeader[i]);
        }
    }

    //添加单元格内容
    private void addCell(WritableSheet ws,int column, int row, String data) throws WriteException {
        Label label = new Label(column ,row, data);
        ws.addCell(label);
    }

    //添加单元格内容
    private void addCell(WritableSheet ws,int column, int row, String data, String memo) throws WriteException {

        Label label = new Label(column ,row, data);
        if(!StringUtils.isEmpty(memo)){
            WritableCellFeatures cellFeatures = new WritableCellFeatures();
            cellFeatures.setComment(memo);
            label.setCellFeatures(cellFeatures);
        }
        ws.addCell(label);
    }



    private String createFileName(String userId, String type) throws IOException {
        File file = new File( tmpdir + defPath  );
        if(!file.exists())
            file.mkdirs();

        String curPath = DateUtil.getCurrentString("yyyy_MM_dd") + separator;
        file = new File( tmpdir + defPath + curPath );
        if(!file.exists())
            file.mkdirs();
        return curPath + DateUtil.getCurrentString("HHmmss") + "_" + userId + "_" + type + fileType;
    }

    private String getFullPath(String fileName){
        return tmpdir + defPath + fileName;
    }
}
