package com.yihu.ehr.apps.model;

import java.util.ArrayList;
import java.util.List;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/7/11
 */
public class AppFeatureTree {
    int id;
    String name;
    String appId;
    int parentId;
    String type;
    String iconUrl;
    String memo;
    List children = new ArrayList<>();

    public AppFeatureTree(int id, String name, int parentId, String type, String iconUrl) {
        this.id = id;
        this.name = name;
        this.parentId = parentId;
        this.type = type;
        this.iconUrl = iconUrl;
    }

    public AppFeatureTree(int id, String name, String memo, int parentId, String type, String appId) {
        this.id = id;
        this.name = name;
        this.memo = memo;
        this.parentId = parentId;
        this.type = type;
        this.appId = appId;
    }

    public void addChild(AppFeatureTree child){
        children.add(child);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public List getChildren() {
        return children;
    }

    public void setChildren(List children) {
        this.children = children;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }
}
