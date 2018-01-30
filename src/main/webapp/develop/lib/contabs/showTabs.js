(function (w, $) {
    var getTabTmp = function (url, name, id) {
            return '<a href="#" class="active J_menuTab" data-id="'+ (id || url) +'">'+ name +' <i class="glyphicon glyphicon-remove"></i></a>';
        },
        getIframTmp = function (len, url, id) {
            return $('<iframe class="J_iframe" method="post" name="iframe'+ len +'" src="'+ url +'" width="100%" height="100%" frameborder="0" data-id="'+ (id || url) +'" seamless>');
        };

    var showTab = function (opt) {
        var me = this,
            $pageTabsContent = $('.page-tabs-content').length? $('.page-tabs-content') :  $(top.document).find('.page-tabs-content'),
            $contentMain = $('#content-main').length? $('#content-main'): $(top.document).find('#content-main'),
            cLen = 0,
            hasTab = false,
            $iframe = null;
        $.each($pageTabsContent.find("a"), function (k, obj) {
            if ($(obj).attr('data-id') == opt.url || $(obj).attr('data-id') == opt.id) {
                hasTab = true;
                $(obj).trigger('click');
                return;
            }
        });
        if (hasTab) return;
        $pageTabsContent.children().removeClass('active');
        $pageTabsContent.append(getTabTmp(opt.url, opt.name, opt.id));
        cLen = $contentMain.children().length;
        $contentMain.children().hide();
        $iframe = getIframTmp(cLen, opt.url, opt.id);
        $contentMain.append($iframe);
        opt.cb && opt.cb.call(this, $iframe);
    }
    w._SHOWTAB = showTab;
})(window, jQuery);