package com.yihu.ehr.util.excel;

import java.util.Map;
import java.util.Set;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/6/15
 */
public interface Validation {

    public int validate(Map<String, Set> repeatMap) throws Exception;
}
