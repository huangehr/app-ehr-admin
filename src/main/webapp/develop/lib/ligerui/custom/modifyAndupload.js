//加载条
(function ($, win) {

    var Util = $.Util;

    var options = {
        url: '',
        method: 'post',
        id: 'l_upd',
        field: 'file',
        str: '浏览',
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

    var btnStyle = function (str) {
        return '<div style="position: absolute; top: 12px;left: 8px" class="l-button u-btn u-btn-primary u-btn-small f-ib f-vam">' +
            '<span>' + str + '</span>'
        '</div>';
    }

    function process(width){
        return "<div style='display:inline-block;vertical-align:middle;width:193px;height: 16px;border: solid 1px #ccc;margin-left:10px;'><div style='height:15px;border:solid 1px #30A9DE;background-color: #30A9DE;width:"+width+"px'></div></div>"
    }

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
        g._el.append(btnStyle(p.str));

        g._bindEvt();

        function suc(){
            $('#'+  p.id + "_file").val("");
            if(uploadDialog) uploadDialog.close();
            if(p.onUploadSuccess) p.onUploadSuccess(g, p.result);
        }

        win[p.id + "_progress"] = function (percentage, data) {

            if(uploadDialog){
                var html;
                if(percentage == -2)
                    html = "模板不正确，请下载新的模板，并按照示例正确填写后上传！";
                else if(percentage == -1)
                    html = "导入失败！";
                else
                    var width = parseInt(percentage/100*193)
                html = "导入进度:"+process(width);
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
        function showName(){
            $('#thelist').val($(this).val())
        }
        function chg(val) {
            console.log(val)
            if(val=='')
                return
            uploadDialog = $.ligerDialog.open({
                onClose: p.onDlgClose,
                content: "<div id='importPros'>导入进度:" +process(0)+"</div><iframe name='handleFrame' style='display:none'></iframe>  "});
            $('#'+ p.id + "_form", g._el).submit();
            var file = $('#'+ p.id + "_file", g._el);
            var newFile = file.clone();
            newFile.val("");
            file.after(newFile);
            newFile.click(clk).change(chg);
            file.remove();
        }
        $('#'+  p.id + "_file", g._el).click(clk).change(showName);
        $('#okbutton').click(function(){
            var $val = $('#thelist').val()
            chg($val)
        })
    };

    $.fn.uploadFile = function (opts) {
        var me = new UploadFile(this, opts);
        return me;
    }
})(jQuery, window);

