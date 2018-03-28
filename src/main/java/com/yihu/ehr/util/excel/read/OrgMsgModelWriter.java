package com.yihu.ehr.util.excel.read;

import com.yihu.ehr.organization.model.OrgMsgModel;
import com.yihu.ehr.util.excel.AExcelWriter;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.List;

/**
 * Created by zdm on 2017/10/19
 */
public class OrgMsgModelWriter extends AExcelWriter {

    public void addHeader(WritableSheet ws) throws WriteException {
       String[] header ={"机构代码", "机构全名","医院类型", "医院归属", "机构简称", "机构类型", "医院等级", "医院法人", "联系人", "联系方式", "中西医标识", "床位", "机构地址", "", "", "", "交通路线", "入驻方式", "经度", "纬度", "标签", "医院简介","医院等次","经济类型代码","卫生机构分类","卫生机构大分类","机构性质1","机构性质Ⅱ","是否开放显示","健康之路机构id", "错误信息"};
        if (!"".equals(header)) {
            int i = 0;
            for (String h : header) {
                addCell(ws, 0, i, h);
                i++;
            }
        }
    }

    private String getErrorInfo(OrgMsgModel m) {
        String errorInfo = "";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgCode")) ? "" : m.findErrorMsg("orgCode") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("fullName")) ? "" : m.findErrorMsg("fullName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("hosTypeId")) ? "" : m.findErrorMsg("hosTypeId") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("ascriptionType")) ? "" : m.findErrorMsg("ascriptionType") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("shortName")) ? "" : m.findErrorMsg("shortName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("orgType")) ? "" : m.findErrorMsg("orgType") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("levelId")) ? "" : m.findErrorMsg("levelId") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("legalPerson")) ? "" : m.findErrorMsg("legalPerson") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("admin")) ? "" : m.findErrorMsg("admin") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("phone")) ? "" : m.findErrorMsg("phone") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("zxy")) ? "" : m.findErrorMsg("zxy") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("berth")) ? "" : m.findErrorMsg("berth") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("provinceName")) ? "" : m.findErrorMsg("provinceName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("cityName")) ? "" : m.findErrorMsg("cityName") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("district")) ? "" : m.findErrorMsg("district") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("street")) ? "" : m.findErrorMsg("street") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("traffic")) ? "" : m.findErrorMsg("traffic") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("settledWay")) ? "" : m.findErrorMsg("settledWay") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("ing")) ? "" : m.findErrorMsg("ing") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("lat")) ? "" : m.findErrorMsg("lat") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("tags")) ? "" : m.findErrorMsg("tags") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("introduction")) ? "" : m.findErrorMsg("introduction") + "；";

        errorInfo += StringUtils.isEmpty(m.findErrorMsg("hosHierarchy")) ? "" : m.findErrorMsg("hosHierarchy") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("hosEconomic")) ? "" : m.findErrorMsg("hosEconomic") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("classification")) ? "" : m.findErrorMsg("classification") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("bigClassification")) ? "" : m.findErrorMsg("bigClassification") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("nature")) ? "" : m.findErrorMsg("nature") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("branchType")) ? "" : m.findErrorMsg("branchType") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("displayStatus")) ? "" : m.findErrorMsg("displayStatus") + "；";
        errorInfo += StringUtils.isEmpty(m.findErrorMsg("jkzlOrgId")) ? "" : m.findErrorMsg("jkzlOrgId") + "；";

        return StringUtils.isEmpty(errorInfo) ? errorInfo : errorInfo.substring(0,errorInfo.length()-1);
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
                addCell(ws, i, 11, m.getBerth(), m.findErrorMsg("berth"));
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

                addCell(ws, i, 22, m.getHosHierarchy(), m.findErrorMsg("hosHierarchy"));
                addCell(ws, i, 23, m.getHosEconomic(), m.findErrorMsg("hosEconomic"));
                addCell(ws, i, 24, m.getClassification(), m.findErrorMsg("classification"));
                addCell(ws, i, 25, m.getBigClassification(), m.findErrorMsg("bigClassification"));
                addCell(ws, i, 26, m.getNature(), m.findErrorMsg("nature"));
                addCell(ws, i, 27, m.getBranchType(), m.findErrorMsg("branchType"));
                addCell(ws, i, 28, m.getDisplayStatus(), m.findErrorMsg("displayStatus"));
                addCell(ws, i, 29, m.getJkzlOrgId(), m.findErrorMsg("jkzlOrgId"));

                addCell(ws, i, 30, getErrorInfo(m), "");
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
