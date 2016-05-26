/**
 * 工具栏添加按钮
 * @param type 类型
 * @param clkFun 点击事件
 * @param barId 工具栏id
 * @returns {string}
 */
function addBarBtn(type, clkFun, barId, imgClz, id){
    var text;
    if(type == 'batchDel'){
        id = "btn_del_" + barId;
        text = "批量删除";
    }
    else if(type == 'edit'){
        id = "btn_add_" + barId;
        text = "新增";
    }
    else{
        text = type;
    }
    var wrap = $('<div class="f-fr f-mr10"></div>');
    var btn;
    if(imgClz)
        btn = $('<div title="'+ text +'" id="btn_create" class="'+ imgClz +' f-mt5"></div>');
    else
        btn = $(
            '<div id="'+ id +'" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >' +
                '<span>'+ text +'</span>' +
            '</div>');

    btn.click(clkFun);
    wrap.append(btn);
    return  wrap;
}

/**
 * 初始化工具栏
 * @param el 工具栏dom
 * @param vo 按钮集合
 * @param barId 工具栏id
 */
function initBarBtn(el, vo, barId){
    if($.isArray(vo) && vo.length>0){
        for(var i=0; i<vo.length; i++){
            $(el).append(addBarBtn(vo[i].type, vo[i].clkFun, barId ? barId : 1, vo[i].imgClz))
        }
    }
}

/**
 * 初始化form表单
 * @param vo
 * [
     {type: 'text', id: 'ipt_search', searchFun: searchFun},
     {type: 'select', id: 'ipt_search_type'， url: '', params: {}, opts: {}},
     {type: 'searchBtn', id: 'search_btn', searchFun: searchFun}
   ];
 * @param area 所在页面位置，给搜索按钮使用
 */
function initFormFields(vo, area){

    if($.isArray(vo) && vo.length>0){
        var ipt_el;
        $.each(vo, function (i, v) {
            ipt_el = $('#' + v.id);
            if(v.type == 'text'){
                if(v.searchFun)
                    initSearchTextDom(ipt_el, v.searchFun, v.width, v.opts);
                else
                    initTextDom(ipt_el, v.width, v.opts);
            }
            else if(v.type == 'select'){
                if(v.dictId)
                    initSystemSelDom(ipt_el, v.dictId, v.opts);
                else
                    initSelDom(ipt_el, v.url, v.params, v.opts);
            }
            else if(v.type == 'searchBtn'){
                $(area).append(
                    '<div class="m-form-control m-form-control-fr f-ml10">' +
                        '<div id="'+ v.id +'" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam" >' +
                            '<span>搜索</span>' +
                        '</div>' +
                    '</div>');
                $('#' + v.id).click(v.searchFun);
            }
            else if(v.type == 'radio'){
                $('input[name="'+ v.id +'"]').ligerRadio();
            }
        })
    }
}

/**
 * 开启窗口
 * @param url
 * @param title
 * @param height
 * @param width
 * @param parms
 * @param opts
 * @returns {*|Window}
 */
function openDialog(url, title, width, height, parms, opts){
    var defaultOpts = {
        height: height || 440,
        width: width || 600,
        title: title,
        url: url,
        urlParms: parms || {id: id, mode: mode},
        load: true,
        isHidden: false
    };
    opts = $.extend({}, defaultOpts, opts);
    var dialog = $.ligerDialog.open(opts);
    return dialog;
}


function getSelectId(grid, code){
    code = code || 'id';
    var rows = grid.getSelectedRows();
    var ids = [];
    $.each(rows, function (i, v) {
        ids.push(v[code]);
    })
    return ids;
}

function uniqDel(gtGrid, findFunc, url, ids, code, idField) {
    if(ids && !$.isArray(ids)){
        ids = [ids];
    }
    ids = ids || getSelectId(gtGrid, code);
    if (ids.length > 0) {
        $.ligerDialog.confirm('确定删除这些数据?', function (yes) {
            if (yes)
                remoteDel(ids, findFunc, gtGrid, url, idField, 'uniq');
        });
    }else{
        $.ligerDialog.warn("请选择要删除的数据");
    }
}

function batchDel(gtGrid, findFunc, url, ids, code, idField) {
    if(ids && !$.isArray(ids)){
        ids = [ids];
    }
    ids = ids || getSelectId(gtGrid, code);
    if (ids.length > 0) {
        $.ligerDialog.confirm('确定删除这些数据?', function (yes) {
            if (yes)
                remoteDel(ids, findFunc, gtGrid, url, idField);
        });
    }else{
        $.ligerDialog.warn("请选择要删除的数据");
    }
}

function remoteDel(ids, findFunc, gtGrid, url, idField, type){
    var dialog = $.ligerDialog.waitting('正在删除中,请稍候...');
    var dataModel = $.DataModel.init();
    dataModel.updateRemote(url, {
        data: {ids: ids.join(','), idField: idField, type: type},
        success: function (data) {
            if (data.successFlg) {
                $.Notice.success('删除成功！');
                if(findFunc)
                    findFunc($.Util.checkCurPage.call(gtGrid, ids.length))
            } else {
                $.Notice.error(data.errorMsg);
            }
        },
        complete: function () {
            dialog.close();
        },
        error: function(){
            $.Notice.error('请求错误！');
        }
    });
}

function covertFilters(vo, $form){

    $form.attrScan();
    var model = $form.Fields.getValues();
    var f = '', v, fields, val;
    for(var i=0; i<vo.length; i++){
        v = vo[i];
        if($.Util.isStrEmpty((val = model[v.name])))
            continue;
        val = v.cover ? v.cover(val) : val;
        if(v.fields){
            fields = v.fields.split(',');
            for(var j=0; j<fields.length; j++){
                f += fields[j] + v.logic + val + ' g' + i + ';';
            }
        }else
            f += v.name + v.logic + val + ';';
    }
    return f;
}