;(function ( W, $, u) {
    var MousePop = {
        es: ['contextmenu','mousedown','mouseover','click'],
        childShowHtml: ['<div class="pop-item"><a class="add-child-btn" data-id="{{id}}" data-category-name="{{categoryName}}" href="javascript:;">添加子部门</a></div>',
            '<div class="pop-item"><a class="edit-name-btn" data-id="{{id}}" data-category-name="{{categoryName}}" href="javascript:;">修改名称</a></div>',
            '<div class="pop-item"><a class="del-btn" data-id="{{id}}" href="javascript:;">删除</a></div>',
            '<div class="pop-item {{prevClass}}"><a class="up-btn" data-id="{{id}}" href="javascript:;">上移</a></div>',
            '<div class="pop-item {{nextClass}}"><a class="down-btn" data-id="{{id}}" href="javascript:;">下移</a></div>'].join(''),
        parentShowHtml: '<div class="pop-item"><a class="add-parent-btn" data-category-name="{{categoryName}}" data-id="{{id}}" href="javascript:;">添加根部门</a></div>',
        popWin:['<div class="pop-win">',
                    '<h3 class="pop-tit">{{title}}</h3>',
                    '<div class="pop-form">',
                        '<label for="name">名称：</label>',
                        '<input id="name" class="name" type="text" value="{{name}}" /><input type="hidden" id="oldName" value="{{name}}" /><span style="line-height: 26px;    vertical-align: bottom;padding-left: 10px;color: red;">*</span>',
                    '</div>',
                    '<div class="pop-form {{classCode}}">',
                        '<label for="code">编码：</label>',
                        '<input id="code" class="code" type="text" value="" /><span style="line-height: 26px;    vertical-align: bottom;padding-left: 10px;color: red;">*</span>',
                    '</div>',
                    '<div class="btns">',
                        '<a class="btn sure-btn" id="sureBtn" href="javascript:;">确定</a>',
                        '<a class="btn cancel-btn" id="cancelBtn" href="javascript:;">取消</a>',
                    '</div>',
                '</div>'].join(''),
        $pd: $('#div_tree'),
        $htmlStrDom: null,
        $popWim: null,
        $b: $('body'),
        ops: null,
        prevId: '',
        nextId: '',
        init: function (options) {
            var me = this;
            if (!!options && typeof options === 'object') {
                me.ops = options;
            } else {
                alert('请传入对象参数');
                return false;
            }
            me.clearContextmenuEvent();
            me.addPdEvent();
            return me;
        },
        addPdEvent: function () {
            var me = this;
            me.bindEvents( me.$pd, me.es[1], function (e) {
                me.setPdFun( e, me);
            });
        },
        setPdFun: function ( e, me) {
            if (me.$htmlStrDom !== null) {
                me.closeMousePop(me);
            }
            if (e.which === 3) {
                var parentDom = $(e.target).parent().parent(),
                    id = parentDom.attr('id'),
                    htmlStr = '<div class="mouse-pop-win" data-id="' + id + '">',
                    x = e.pageX,
                    y = e.pageY,
                    categoryName = (function () {
                        var isDom = (/<[^>]+>/g).test($(e.target).html());
                        if (isDom) {
                            str = $($(e.target).html()).next('span').html();
                        } else {
                            str = $(e.target).html();
                        }
                        return str;
                    })();
                me.prevId = parentDom.prev().attr('id');
                me.nextId = parentDom.next().attr('id');
                if (id === 'div_tree') {
                    htmlStr += me.render(me.parentShowHtml,{ 'id' : id, categoryName:categoryName, prevId: me.prevId},function ( data, $1) {
                        me.checkNPData( data, $1);
                    });
                } else {
                    htmlStr += me.render(me.childShowHtml,{ 'id' : id , categoryName:categoryName, nextId: me.nextId},function ( data, $1) {
                        me.checkNPData( data, $1);
                    });
                }
                htmlStr += '</div>';
                me.$htmlStrDom = $(htmlStr);
                me.$htmlStrDom.css({
                    top: (y - 20) + 'px',
                    left: (x - 20) + 'px'
                });
                me.$b.append(me.$htmlStrDom);
                me.setHtmlStrDomEvent(me);
            }
        },
        checkNPData: function ( data, $1){
            var me = this;
            if ($1 === 'prevClass') {
                data[$1] = !!me.prevId ? '' : 'pop-f-hide';
            }
            if ($1 === 'nextClass') {
                data[$1] = !!me.nextId ? '' : 'pop-f-hide';
            }
        },
        setHtmlStrDomEvent: function (me) {
            me.bindEvents( me.$pd, me.es[2],function (e) {
                var p = $(e.target).parent();
                if (!p.hasClass('pop-item')) {
                    me.closeMousePop(me);
                }
            });
            me.bindEvents( me.$htmlStrDom, me.es[3], function (e) {
                var id = $(this).attr('data-id'),
                    categoryName = $(e.target).attr('data-category-name'),
                    className = $(e.target).attr('class');
                me.closeMousePop(me);
                switch (className) {
                    case 'add-child-btn':
                        me.ops.setAddChildFun && me.ops.setAddChildFun.call( this, id, me, categoryName);
                        break;
                    case 'edit-name-btn':
                        me.ops.setEditNameFun && me.ops.setEditNameFun.call( this, id, me, categoryName);
                        break;
                    case 'del-btn':
                        me.ops.setDelFun && me.ops.setDelFun.call( this, id, me);
                        break;
                    case 'up-btn':
                        me.ops.setUpFun && me.ops.setUpFun.call( this, id, me, me.prevId);
                        break;
                    case 'down-btn':
                        me.ops.setDownFun && me.ops.setDownFun.call( this, id, me, me.nextId);
                        break;
                    case 'add-parent-btn':
                        me.ops.setAddParentFun && me.ops.setAddParentFun.call( this, id, me, '');
                        break;
                }
            });
        },
        showPopWin: function ( me, cb, d) {
            if (me.$popWim !== null) {
                me.removePopWin(me);
            }
            me.$popWim = $(me.render( me.popWin, d, function ( data, $1) {
                data[$1] = data[$1] || '';
            }));
            me.$b.append(me.$popWim);
            me.bindEvents( me.$popWim, me.es[3], function (e) {
                var className = $(e.target).attr('id');
                switch (className) {
                    case 'cancelBtn':
                        me.removePopWin(me);
                        break;
                    case 'sureBtn':
                        cb && (cb.call(this) ? (function () {
                            me.removePopWin(me);
                        })(): '');
                        break;
                }
            })
        },
        removePopWin: function (me) {
            me.$popWim && me.$popWim.remove();
            me.$popWim && (me.$popWim= null);
        },
        closeMousePop: function (me) {
            me.$htmlStrDom && me.$htmlStrDom.remove();
            me.$htmlStrDom && (me.$htmlStrDom = null);
        },
        //阻止默认事件
        clearContextmenuEvent: function () {
            this.bindEvents( $(document), this.es[0], function (e) {
                e.preventDefault();
            });
        },
        bindEvents: function ( d, ev, cb, nd) {
            cb && d.on( ev, nd, cb);
        },
        render: function(tmpl, data, cb){
            return tmpl.replace(/\{\{(\w+)\}\}/g, function(m, $1){
                cb && cb.call( this, data, $1);
                return data[$1];
            });
        },
        res: function ( url, d, cb) {
            $.ajax({
                url: url,
                type: 'GET',
                dataType: 'json',
                data: d,
                success: function (data) {
                    cb && cb.call( this, data);
                }
            });
        }
    };
    W.$MousePop = MousePop;
})( window, $);