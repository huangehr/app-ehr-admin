package com.yihu.ehr.common.utils;

import com.fasterxml.jackson.core.type.TypeReference;

import java.lang.reflect.Type;

/**
 *
 * @author lincl
 * @version 1.0
 * @created 2016/5/3
 */
public class ExtTypeReference extends TypeReference<Object> {

    protected Type type;

    public ExtTypeReference() {

    }

    public ExtTypeReference(Type clz) {

        this.type = clz;
    }

    public void setType(Type clz){

        this.type = clz;
    }

    public Type getType() {
        return this.type;
    }
}
