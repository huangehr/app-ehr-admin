package com.yihu.ehr.util.excel.read;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.yihu.ehr.agModel.dict.SystemDictEntryModel;
import com.yihu.ehr.organization.controller.OrganizationController;
import com.yihu.ehr.user.controller.model.DoctorMsgModel;
import com.yihu.ehr.user.controller.model.WtDoctorMsgModel;
import com.yihu.ehr.util.HttpClientUtil;
import com.yihu.ehr.util.excel.AExcelReader;
import com.yihu.ehr.util.log.LogService;
import com.yihu.ehr.util.rest.Envelop;
import jxl.Sheet;
import jxl.Workbook;
import org.springframework.util.StringUtils;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 卫统医生数据导入
 */
public class WtDoctorMsgModelReader extends AExcelReader {

    @Override
    public void read(Workbook rwb) throws Exception {
        try {
            Sheet[] sheets = rwb.getSheets();
            int j = 0, rows;
            WtDoctorMsgModel p;
            getRepeat().put("phone", new HashSet<>());
            getRepeat().put("idCardNo", new HashSet<>());
            getRepeat().put("orgCode", new HashSet<>());
            getRepeat().put("orgFullName", new HashSet<>());
            for (Sheet sheet : sheets) {
                if ((rows = sheet.getRows()) == 0) {
                    continue;
                }
                for (int i = 1; i < rows; i++, j++) {
                    p = new WtDoctorMsgModel();
                    boolean vatFlag = true;
                    p.setOrgId(null == getCellCont(sheet, i, 0) ? "" : getCellCont(sheet, i, 0).trim());
                    p.setOrgCode(null == getCellCont(sheet, i, 1) ? "" : getCellCont(sheet, i, 1).trim());
                    p.setOrgFullName(null == getCellCont(sheet, i, 2) ? "" : getCellCont(sheet, i, 2).trim());
                    p.setName(null == getCellCont(sheet, i, 3) ? "" : getCellCont(sheet, i, 3).trim());
                    p.setSfzjzl(null == getCellCont(sheet, i, 4) ? "" : getCellCont(sheet, i, 4).trim());
                    p.setIdCardNo(null == getCellCont(sheet, i, 5) ? "" : getCellCont(sheet, i, 5).trim());
                    p.setCsrq(null == getCellCont(sheet, i, 6) ? "" : getCellCont(sheet, i, 6).trim());
                    p.setSex(null == getCellCont(sheet, i, 7) ? "" : getCellCont(sheet, i, 7).trim());
                    p.setMzdm(null == getCellCont(sheet, i, 8) ? "" : getCellCont(sheet, i, 8).trim());
                    p.setCjgzrq(null == getCellCont(sheet, i, 9) ? "" : getCellCont(sheet, i, 9).trim());
                    p.setOfficeTel(null == getCellCont(sheet, i, 10) ? "" : getCellCont(sheet, i, 10).trim());
                    p.setPhone(null == getCellCont(sheet, i, 11) ? "" : getCellCont(sheet, i, 11).trim());
                    p.setSzksdm(null == getCellCont(sheet, i, 12) ? "" : getCellCont(sheet, i, 12).trim());
                    p.setDept_name(null == getCellCont(sheet, i, 13) ? "" : getCellCont(sheet, i, 13).trim());
                    p.setRole_type(null == getCellCont(sheet, i, 14) ? "" : getCellCont(sheet, i, 14).trim());
                    p.setYszyzsbm(null == getCellCont(sheet, i, 15) ? "" : getCellCont(sheet, i, 15).trim());
                    p.setJob_type(null == getCellCont(sheet, i, 16) ? "" : getCellCont(sheet, i, 16).trim());
                    p.setJob_scope(null == getCellCont(sheet, i, 17) ? "" : getCellCont(sheet, i, 17).trim());
                    p.setSfdddzyys(null == getCellCont(sheet, i, 18) ? "" : getCellCont(sheet, i, 18).trim());
                    p.setDezydwjglb(null == getCellCont(sheet, i, 19) ? "" : getCellCont(sheet, i, 19).trim());
                    p.setDszydwjglb(null == getCellCont(sheet, i, 20) ? "" : getCellCont(sheet, i, 20).trim());
                    p.setSfhdgjzs(null == getCellCont(sheet, i, 21) ? "" : getCellCont(sheet, i, 21).trim());
                    p.setZyyszsbm(null == getCellCont(sheet, i, 22) ? "" : getCellCont(sheet, i, 22).trim());
                    p.setXzzc(null == getCellCont(sheet, i, 23) ? "" : getCellCont(sheet, i, 23).trim());
                    p.setLczc(null == getCellCont(sheet, i, 24) ? "" : getCellCont(sheet, i, 24).trim());
                    p.setZyjszwdm(null == getCellCont(sheet, i, 25) ? "" : getCellCont(sheet, i, 25).trim());
                    p.setXldm(null == getCellCont(sheet, i, 26) ? "" : getCellCont(sheet, i, 26).trim());
                    p.setXwdm(null == getCellCont(sheet, i, 27) ? "" : getCellCont(sheet, i, 27).trim());
                    p.setSzydm(null == getCellCont(sheet, i, 28) ? "" : getCellCont(sheet, i, 28).trim());
                    p.setZktc1(null == getCellCont(sheet, i, 29) ? "" : getCellCont(sheet, i, 29).trim());
                    p.setZktc2(null == getCellCont(sheet, i, 30) ? "" : getCellCont(sheet, i, 30).trim());
                    p.setZktc3(null == getCellCont(sheet, i, 31) ? "" : getCellCont(sheet, i, 31).trim());
                    p.setNnryldqk(null == getCellCont(sheet, i, 32) ? "" : getCellCont(sheet, i, 32).trim());
                    p.setDrdcsj(null == getCellCont(sheet, i, 33) ? "" : getCellCont(sheet, i, 33).trim());
                    p.setBzqk(null == getCellCont(sheet, i, 34) ? "" : getCellCont(sheet, i, 34).trim());
                    p.setSfzcqkyx(null == getCellCont(sheet, i, 35) ? "" : getCellCont(sheet, i, 35).trim());
                    p.setQdhgzs(null == getCellCont(sheet, i, 36) ? "" : getCellCont(sheet, i, 36).trim());
                    p.setXzsqpzgz(null == getCellCont(sheet, i, 37) ? "" : getCellCont(sheet, i, 37).trim());
                    p.setSfcstjgz(null == getCellCont(sheet, i, 38) ? "" : getCellCont(sheet, i, 38).trim());
                    p.setTjxxhgz(null == getCellCont(sheet, i, 39) ? "" : getCellCont(sheet, i, 39).trim());
                    p.setExcelSeq(j);
                    int rs = p.validate(repeat);
                    if (rs == 1 && vatFlag == true) {
                        correctLs.add(p);
                    } else {
                        errorLs.add(p);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("模板不正确，请下载新的模板，并按照示例正确填写后上传！");
        } finally {
            if (rwb != null) {
                rwb.close();
            }
        }
    }

}
