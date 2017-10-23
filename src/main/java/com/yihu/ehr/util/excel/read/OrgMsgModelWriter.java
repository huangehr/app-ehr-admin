package com.yihu.ehr.util.excel.read;

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
        String[] header = {"部门编号", "部门名称", "父级部门编号", "父级部门名称", "科室电话", "科室荣誉(国家重点科室,省级重点科室,医院特色专科)", "机构代码", "所属机构", "科室介绍", "科室位置", "科室类型"};
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
            for (OrgDeptMsgModel m : (List<OrgDeptMsgModel>) ls) {
                addCell(ws, i, 0, m.getCode(), m.findErrorMsg("code"));
                addCell(ws, i, 1, m.getName(), m.findErrorMsg("name"));
                addCell(ws, i, 2, m.getParentDeptId(), m.findErrorMsg("parentDeptId"));
                addCell(ws, i, 3, m.getParentDeptName(), m.findErrorMsg("parentDeptName"));
                addCell(ws, i, 4, m.getPhone(), m.findErrorMsg("phone"));
                addCell(ws, i, 5, m.getGloryId(), m.findErrorMsg("gloryId"));
                addCell(ws, i, 6, m.getOrgCode(), m.findErrorMsg("orgCode"));
                addCell(ws, i, 7, m.getOrgName(), m.findErrorMsg("orgName"));
                addCell(ws, i, 8, m.getIntroduction(), m.findErrorMsg("introduction"));
                addCell(ws, i, 9, m.getPlace(), m.findErrorMsg("place"));
                addCell(ws, i, 10, m.getPyCode(), m.findErrorMsg("pyCode"));
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
