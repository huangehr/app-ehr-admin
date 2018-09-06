/**
 * Created by JKZL-A on 2017/11/8.
 */
~(function (w, $) {
    var ET = {
        $main: null,
        //视图控制
        html: ['<div class="view-btns" style="position: absolute;top: 0;right: 0;z-index: 999;cursor:pointer;">',
                    '<div id="delView" style="width: 50px;height: 35px;display:inline-block;text-align: center;line-height: 35px;background: #d9534f;color: #fff;">删除</div>',
                    '<div type="button" id="selView" style="width: 80px;height: 35px;display:inline-block;background: #5cb85c;text-align:center;line-height: 35px;color: #fff;">选择视图</div>',
              '</div>'].join(''),
        //编辑标题
        $sel: ['<div id="editTitCon" style="position: absolute;top:0;right: 0;z-index: 999;">',
                    '<input type="text" id="titVal" style="width: 170px;height: 35px;line-height: 35px;padding: 0 5px;border: 1px solid #5cb85c;border-top:0;right: 80px;display: none;"/>',
                    '<div type="button" class="" data-type="edit" id="editTit" style="width: 80px;height: 35px;display:inline-block;background: #5cb85c;text-align:center;line-height: 35px;cursor:pointer;color: #fff;">编辑</div>',
                '</div>'].join(''),
        addViewFun: null,
        createET: function (opt) {
            return new this.init(opt, this);
        },
        init: function (opt, me) {
            me.opt = opt;
            me.$main = opt.$main;
            me.addViewFun = opt.addViewFun;
            me.$main && (function () {
                me.bindEvent();
            })();
            return me;
        },
        resetHtml: function ($dom, cb) {//重置
            var id = $dom.find('.charts-con').attr('id');
            $dom.find('.c-title').html('');
            $dom.find('.charts-con').removeAttr('ligeruiid').removeAttr('data-type').removeAttr('style').removeAttr('_echarts_instance_').removeClass('l-panel').removeClass('l-frozen').attr('id', '').html('');
            id && (cb && cb.call(this, id));
        },
        bindEvent: function () {
            var me = this;
            me.$main.on('mouseenter', '.g-title', function (e) {
                var $that = $(this);
                $that.append(me.$sel);
                $that.css('border', '1px solid #5cb85c');
                e.stopPropagation();
            }).on('mouseenter', '.charts', function (e) {
                var $that = $(this);
                $that.append(me.html);
                $that.css('border', '1px solid #5cb85c');
                e.stopPropagation();
            }).on('mouseleave', '.g-title', function (e) {
                var $that = $(this);
                $that.find('#editTitCon').remove();
                $that.css('border', 'none');
                e.stopPropagation();
            }).on('mouseleave', '.charts', function (e) {
                var $that = $(this);
                $that.find('.view-btns').remove();
                $that.css('border', '1px solid #e8edec');
                e.stopPropagation();
            }).on('click', '.charts #selView', function (e) {//选择视图
                var $that = $(this);
                me.addViewFun && me.addViewFun.call(this, $that);
                e.stopPropagation();
            }).on('click', '.charts #delView', function (e) {//清除视图
                var $that = $(this);
                me.resetHtml($that.closest('.charts'), me.opt.cb);
                e.stopPropagation();
            }).on('click', '.dropdown-menu li', function (e) {
                var $li = $(this);
                $li.closest('.g-title').find('.model-title').html($li.find('a').html());
                e.stopPropagation();
            }).on('click', '.g-title #editTit', function (e) {
                var $that = $(this),
                    type = $that.attr('data-type'),
                    $parent = $that.closest('.g-title');
                if (type == 'edit') {
                    $parent.find('#titVal').show();
                    $that.attr('data-type', 'save').html('保存');
                } else {
                    var val = $that.prev().val();
                    if (val.trim() == '') {
                        $.Notice.error('请填写标题！');
                        return ;
                    }
                    $parent.find('.model-title').html(val);
                    $that.attr('data-type', 'edit').html('编辑');
                    $parent.find('#titVal').hide();
                }
                e.stopPropagation();
            });
        }
    };
    w._ET = function (opt) {
        return ET.createET(opt);
    };
})(window, jQuery);