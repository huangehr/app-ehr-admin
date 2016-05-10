package com.yihu.ehr.common.utils;

import java.util.List;

/**
 * 用来解析信封的对象
 *
 * @author lincl
 * @version 1.0
 * @created 2016/4/26
 */
public class EnvelopExt<T> {
    private static final long serialVersionUID = 2076324875575488461L;
    private boolean successFlg;
    private int pageSize = 10;
    private int currPage;
    private int totalPage;
    private int totalCount;
    private List<T> detailModelList;
    private T obj;
    private String errorMsg;
    private int errorCode;

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public boolean isSuccessFlg() {
        return successFlg;
    }

    public void setSuccessFlg(boolean successFlg) {
        this.successFlg = successFlg;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getCurrPage() {
        return currPage;
    }

    public void setCurrPage(int currPage) {
        this.currPage = currPage;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public List<T> getDetailModelList() {
        return detailModelList;
    }

    public void setDetailModelList(List<T> detailModelList) {
        this.detailModelList = detailModelList;
    }

    public T getObj() {
        return obj;
    }

    public void setObj(T obj) {
        this.obj = obj;
    }

    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }
}
