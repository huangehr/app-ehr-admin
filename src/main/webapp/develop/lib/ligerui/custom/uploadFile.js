(function ($, win) {

    var Util = $.Util;

    var options = {
        url: '',
        method: 'post',
        id: 'l_upd',
        field: 'file',
        result: undefined,
        onUploadSuccess: function () {},
        onDlgClose: function () {},
        onBeforeUpload: function () {}
    };

    var form =
        '<form id="$form" action="$a" method="$m" target="handleFrame" enctype="multipart/form-data">' +
            '<input type="file" id="$f_id" name="$field" value="浏览"' +
                'style="position: relative; cursor: pointer; width: 284px; height: 32px; opacity: 0; z-index: 1000; filter:alpha(opacity=0);' +
                    'left: -100px; " accept="application/vnd.ms-excel" >' +
        '</form>';

    var btnStyle =
        '<div style="position: absolute; top: 0px" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">' +
            '<span>导入</span>' +
        '</div>';


    function UploadFile(el, opts){
        var g =this;
        g.options = $.extend({}, options, opts);
        g._el = el;
        g._init();
    }

    UploadFile.prototype._init = function () {
        var g= this, p= this.options;
        var $form = $(
            form.replace("$form", p.id + "_form").replace("$f_id", p.id + "_file").replace("$field", p.field)
                .replace("$a", p.url).replace("$m", p.method));

        g._el.css("overflow", "hidden");
        g._el.css("width", "84px");
        g._el.append($form);
        g._el.append(btnStyle);

        g._bindEvt();

        function suc(){
            $('#'+  p.id + "_file").val("");
            if(uploadDialog) uploadDialog.close();
            if(p.onUploadSuccess) p.onUploadSuccess(g, p.result);
        }

        win[p.id + "_progress"] = function (percentage, data) {

            if(uploadDialog){
                var html;
                if(percentage == -1)
                    html = "导入失败！";
                else
                    html = "导入进度："+ percentage +" %";

                $('#importPros', uploadDialog.element).html(html);
                if(percentage == 100){
                    p.result = data;
                    setTimeout(suc, 500);
                }
            }

        }
    };

    var uploadDialog;
    UploadFile.prototype._bindEvt = function () {
        var g= this, p= this.options;
        function clk() {
            if(p.onBeforeUpload)
                return p.onBeforeUpload(g);
            return true;
        }

        function chg(v) {
            if($(this).val()=='')
                return;
            uploadDialog = $.ligerDialog.open({
                onClose: p.onDlgClose,
                content: "<span id='importPros'>导入进度：0 %</span>" +
                "<iframe name='handleFrame' style='display:none'></iframe>  "});
            $('#'+ p.id + "_form", g._el).submit();

            var file = $('#'+ p.id + "_file", g._el);
            var newFile = file.clone();
            newFile.val("");
            file.after(newFile);
            newFile.click(clk).change(chg);
            file.remove();
        }

        $('#'+  p.id + "_file", g._el).click(clk).change(chg);
    };

    $.fn.uploadFile = function (opts) {

        var me = new UploadFile(this, opts);
        return me;
    }
})(jQuery, window);
