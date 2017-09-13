package com.yihu.ehr.patient.model;

import com.yihu.ehr.resource.model.RsDictionaryEntryMsg;
import com.yihu.ehr.util.excel.ExcelUtil;
import com.yihu.ehr.util.excel.RegUtil;
import com.yihu.ehr.util.excel.Validation;
import com.yihu.ehr.util.excel.annotation.*;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Row(start = 1)
@Title(names= "{'卡类型', '卡号', '发卡机构', '发卡时间', '有效起始时间', '有效截止时间', '说明', '状态'}")
public class RsMedicalCardModel extends ExcelUtil implements Validation {

    @Location(x=0)
    private String cardType;
    @Location(x=1)
    @ValidRepeat
    private String cardNo;
    @Location(x=2)
    private String releaseOrg;
    @Location(x=3)
    private String releaseDate;
    @Location(x=4)
    private String validityDateBegin;
    @Location(x=5)
    private String validityDateEnd;
    @Location(x=6)
    private String description;
    @Location(x=7)
    private String status;



    @Override
    public int validate(Map<String, Set> repeatMap) {
        int valid = 1;

        if(!repeatMap.get("cardNo").add(cardNo)){
            valid = 0;
            addErrorMsg("cardNo", "卡号重复！" );
        }
        if(!RegUtil.regCode(cardNo)){
            addErrorMsg("cardNo", RegUtil.codeMsg);
            valid = 0;
        }
        if(!RegUtil.regLen(releaseOrg)){
            valid = 0;
            addErrorMsg("releaseOrg", RegUtil.lenMsg);
        }
        if(!RegUtil.regDate(releaseDate)){
            valid = 0;
            addErrorMsg("releaseDate", RegUtil.dateMsg);
        }

        if(!RegUtil.regDate(validityDateBegin)){
            valid = 0;
            addErrorMsg("validityDateBegin", RegUtil.dateMsg);
        }

        if(!RegUtil.regDate(validityDateEnd)){
            valid = 0;
            addErrorMsg("validityDateEnd", RegUtil.dateMsg);
        }

        if(!RegUtil.regLen(description)){
            valid = 0;
            addErrorMsg("description", RegUtil.lenMsg);
        }
        return valid;
    }

    public String getCardType() {
        return cardType;
    }

    public void setCardType(String cardType) {
        if(cardType.trim().equals("社会保障卡")){
            this.cardType = "1";
        }else  if(status.trim().equals("医保卡")){
            this.cardType = "2";
        }else  if(status.trim().equals("新农合")){
            this.cardType = "3";
        }else  if(status.trim().equals("发行正式卡")){
            this.cardType = "4";
        }else  if(status.trim().equals("发行临时卡")){
            this.cardType = "5";
        }else  if(status.trim().equals("其他卡类别")){
            this.cardType = "6";
        }else {
            this.cardType = "6";
        }
    }

    public String getCardNo() {
        return cardNo;
    }

    public void setCardNo(String cardNo) {
        this.cardNo = cardNo;
    }

    public String getReleaseOrg() {
        return releaseOrg;
    }

    public void setReleaseOrg(String releaseOrg) {
        this.releaseOrg = releaseOrg;
    }

    public String getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getValidityDateBegin() {
        return validityDateBegin;
    }

    public void setValidityDateBegin(String validityDateBegin) {
        this.validityDateBegin = validityDateBegin;
    }

    public String getValidityDateEnd() {
        return validityDateEnd;
    }

    public void setValidityDateEnd(String validityDateEnd) {
        this.validityDateEnd = validityDateEnd;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        if(status.trim().equals("无效")){
            this.status = "0";
        }else  if(status.trim().equals("有效")){
            this.status = "1";
        }
    }
}
