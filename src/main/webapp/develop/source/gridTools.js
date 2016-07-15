/**
 * 操作栏添加编辑按钮
 * @param clkFun 点击事件
 * @returns {string}
 */
function addEditBtn(clkFun){

    return '<a class="grid_edit" title="编辑" href="#" onclick="javascript:' + clkFun + '"></a>'
}

/**
 * 操作栏添加失效按钮
 * @param clkFun 点击事件
 * @returns {string}
 */
function addLockBtn(clkFun){

    return '<a class="grid_lock" title="失效" href="#" onclick="javascript:' + clkFun + '"></a>'
}

/**
 * 操作栏添加生效按钮
 * @param clkFun 点击事件
 * @returns {string}
 */
function addActiveBtn(clkFun){

    return '<a class="grid_active" title="生效" href="#" onclick="javascript:' + clkFun + '"></a>'
}

/**
 * 操作栏添加删除按钮
 * @param clkFun 点击事件
 * @returns {string}
 */
function addDelBtn(clkFun){

    return '<a class="grid_delete" title="删除" href="#" onclick="javascript:' + clkFun + '"></a>'
}

/**
 * 操作栏添加文字按钮
 * @param text 显示文本
 * @param clkFun 点击事件
 * @returns {string}
 */
function addTextBtn(text, clkFun){

    return '<a class="label_a" title="'+ text +'" style="margin-left:5px;" href="#" onclick="javascript:' + clkFun + '">'+ text +'</a>';
}

/**
 * 初始化操作按钮
 * @param vo 操作按钮集合,[{type: 'edit', clkFun: clkFun}, {type: '适配', clkFun: clkFun}]
 * @returns {string}
 */
function initGridOperator(vo, spiltFlag){
    var oprs = [];
    if($.isArray(vo) && vo.length>0){
        var v, html= '';
        for(var i=0; i<vo.length; i++){
            v = vo[i];
            if(v.type == 'edit')
                html = addEditBtn(v.clkFun);
            else if(v.type == 'del')
                html = addDelBtn(v.clkFun);
            else if(v.type == 'lock')
                html = addLockBtn(v.clkFun);
            else if(v.type == 'active')
                html = addActiveBtn(v.clkFun);
            else
                html = addTextBtn(v.type, v.clkFun);
            oprs.push(html);
        }
    }
    spiltFlag = spiltFlag ? spiltFlag : '';
    return oprs.join(spiltFlag);
}

/**
 * 初始化grid
 * @param el 元素
 * @param url 数据接口
 * @param params 参数
 * @param columns 列配置
 * @param opts 事件集合
 * @returns {ligerGrid}
 */
function initGrid(el, url, params, columns, opts){

    opts = $.extend(
        {},
        {
            url: url,
            parms: params,
            columns: columns,
            selectRowButtonOnly: false,
            checkbox: true,
            allowHideColumn: false
        },
        opts
    );
    var grid = $(el).ligerGrid($.LigerGridEx.config(opts));
    grid.adjustToWidth();
    return grid;
}


/**
 * 初始化grid
 * @param el 元素
 * @param url 数据接口
 * @param params 参数
 * @param columns 列配置
 * @param opts 事件集合
 * @returns {ligerGrid}
 */
function initGridDef(el, url, params, columns, opts){
    var defaults = {
        record: 'totalCount',
        root: 'detailModelList',
        pageSize:15,
        pagesizeParmName: 'rows',
        height:'100%',
        heightDiff: -10,
        rownumbers:true,
        headerRowHeight: 40,
        rowHeight: 40,
        editorTopDiff: 41,
        allowAdjustColWidth: true
    };
    opts = $.extend(
        defaults,
        {
            url: url,
            parms: params,
            columns: columns,
            selectRowButtonOnly: false,
            checkbox: true,
            allowHideColumn: false
        },
        opts
    );
    var grid = $(el).ligerGrid(opts);
    //grid.adjustToWidth();
    return grid;
}

/**
 * 重新加载grid
 * @param curPage 加载页面
 * @param params 参数
 * @param url 路径
 */
function reloadGrid(grid, curPage, params, url) {
    $.Util.reloadGrid.call(grid, url, params, curPage);
}

