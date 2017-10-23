package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.organization.controller.model.OrgMsgModel;
import com.yihu.ehr.user.controller.model.OrgDeptMsgModel;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

import java.io.IOException;
import java.util.List;

/**
 * Created by zdm on 2017/10/19
 */
public class OrgMsgModelWriter extends AExcelWriter {

    public void addHeader(WritableSheet ws) throws WriteException {
       String[] header ={"机构代码", "机构全名","医院类型", "医院归属", "机构简称", "机构类型", "医院等级", "医院法人", "联系人", "联系方式", "中西医标识", "上级医院", "机构地址", "", "", "", "交通路线", "入驻方式", "经度", "纬度", "标签", "医院简介"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

    @Override
    public void write(WritableWorkbook wwb, List ls) throws Exception {
        try {
            WritableSheet ws = wwb.createSheet("sheet1", 0);
            addHeader(ws);
            int i = 1;
            for (OrgMsgModel m : (List<OrgMsgModel>) ls) {
                addCell(ws, i, 0, m.getOrgCode(), m.findErrorMsg("orgCode"));
                addCell(ws, i, 1, m.getFullName(), m.findErrorMsg("fullName"));
                addCell(ws, i, 2, m.getHosTypeId(), m.findErrorMsg("hosTypeId"));
                addCell(ws, i, 3, m.getAscriptionType(), m.findErrorMsg("ascriptionType"));
                addCell(ws, i, 4, m.getShortName(), m.findErrorMsg("shortName"));
                addCell(ws, i, 5, m.getOrgType(), m.findErrorMsg("orgType"));
                addCell(ws, i, 6, m.getLevelId(), m.findErrorMsg("levelId"));
                addCell(ws, i, 7, m.getLegalPerson(), m.findErrorMsg("legalPerson"));
                addCell(ws, i, 8, m.getAdmin(), m.findErrorMsg("admin"));
                addCell(ws, i, 9, m.getPhone(), m.findErrorMsg("phone"));
                addCell(ws, i, 10, m.getZxy(), m.findErrorMsg("zxy"));
                addCell(ws, i, 11, m.getParentHosId(), m.findErrorMsg("parentHosId"));
                addCell(ws, i, 12, m.getProvinceName(), m.findErrorMsg("provinceName"));
                addCell(ws, i, 13, m.getCityName(), m.findErrorMsg("cityName"));
                addCell(ws, i, 14, m.getDistrict(), m.findErrorMsg("district"));
                addCell(ws, i, 15, m.getStreet(), m.findErrorMsg("street"));
                addCell(ws, i, 16, m.getTraffic(), m.findErrorMsg("traffic"));
                addCell(ws, i, 17, m.getSettledWay(), m.findErrorMsg("settledWay"));
                addCell(ws, i, 18, m.getIng(), m.findErrorMsg("ing"));
                addCell(ws, i, 19, m.getLat(), m.findErrorMsg("lat"));
                addCell(ws, i, 20, m.getTags(), m.findErrorMsg("tags"));
                addCell(ws, i, 21, m.getIntroduction(), m.findErrorMsg("introduction"));
                i++;
            }
            wwb.write();
            wwb.close();
        } catch (IOException e) {
            e.printStackTrace();
            if (wwb != null) wwb.close();
            throw e;
        }
    }
}
