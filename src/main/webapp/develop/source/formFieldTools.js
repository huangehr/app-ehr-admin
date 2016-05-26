/**
 * 初始化文本框
 * @param el dom节点
 * @returns {ligerTextBox}
 */
function initTextDom(el, width, opts){
    var defaultOpts = {width: width || 240};
    opts = $.extend({}, defaultOpts, opts);
    return $(el).ligerTextBox(opts);
}

/**
 * 初始化搜索文本框
 * @param el dom节点
 * @param searchFun 搜索方法
 * @param width 宽
 * @param opts 其他配置信息
 * @returns {ligerTextBox}
 */
function initSearchTextDom(el, searchFun, width, opts){
    var defaultOpts = {
        isSearch: true,
        width: width || 240,
        search: searchFun
    };
    opts = $.extend({}, defaultOpts, opts);
    return $(el).ligerTextBox(opts);
}

/**
 * 初始化普通下拉框
 * @param el dom节点
 * @param url 数据接口
 * @param parms 参数
 * @param opts 其他配置信息
 * @returns {ligerComboBox}
 */
function initSelDom(el, url, params, opts){
    var defaultOpts = {
        url: url,
        valueField: 'code',
        textField: 'value',
        dataParmName: 'detailModelList',
        parms: params
    };
    opts = $.extend({}, defaultOpts, opts);

    return $(el).ligerComboBox(opts);
}

/**
 * 初始化系统字典下拉框
 * @param el dom节点
 * @param dictId 参数
 * @param opts 其他配置信息
 * @returns {ligerComboBox}
 */
function initSystemSelDom(el, dictId, opts){
    var defaultOpts = {
        url: $.Context.PATH + '/dict/searchDictEntryList',
        valueField: 'code',
        textField: 'value',
        dataParmName: 'detailModelList',
        parms: {dictId: dictId, page: 1, rows: 500}
    };
    opts = $.extend({}, defaultOpts, opts);
    return $(el).ligerComboBox(opts);
}

function initValidate($form, onElementValidateForAjax){

    return new  $.jValidation.Validation($form, {
        immediate: true, onSubmit: false,
        onElementValidateForAjax: onElementValidateForAjax || function (elm) {}
    });
}
/**
 * opts {url: '', $form: '', validator: '', parms: '', modelName: '', notIncluded: []}
 * @param opts
 */
function saveForm(opts){
    var $form = opts.$form;
    var validator = opts.validator;

    if(!validator){
        validator = initDefaultValidate($form);
    }
    if(!validator.validate())
        return;

    var waittingDialog = $.ligerDialog.waitting('正在保存中,请稍候...');
    var parms = opts.parms;
    if(!parms){
        $form.attrScan();
        var model = $form.Fields.getValues();
        var id = model.id || '';
        if(opts.notIncluded){
            var tmp = opts.notIncluded.split(',');
            for(var i=0; i< tmp.length; i++){
                model[tmp[i]] = undefined;
            }
        }
        parms = {model: JSON.stringify(model), modelName: opts.modelName ? opts.modelName : '', id: id  }
    }
    var dataModel = $.DataModel.init();
    dataModel.createRemote(opts.url, {
        data: parms,
        success: function (data) {
            waittingDialog.close();
            if (data.successFlg) {
                parent.closeDialog("保存成功")
            } else {
                if (data.errorMsg)
                    $.Notice.error(data.errorMsg);
                else
                    $.Notice.error('出错了！');
            }
        },
        error: function () {
            waittingDialog.close();
        }
    });
}


function fillForm(model, $form){
    $form.attrScan();
    $form.Fields.fillValues(model);
}


function uniqValid(url, filters, errorMsg) {
    var result = new $.jValidation.ajax.Result();
    var dataModel = $.DataModel.init();
    dataModel.fetchRemote(url, {
        data: {filters: filters},
        async: false,
        success: function (data) {
            if(data.successFlg){
                if (data.obj) {
                    result.setResult(false);
                    result.setErrorMsg(errorMsg);
                } else {
                    result.setResult(true);
                }
            } else {
                result.setResult(false);
                result.setErrorMsg("验证出错，请刷新页面或联系管理员！");
            }
        }
    });
    return result;
}
