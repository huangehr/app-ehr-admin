/*!
 * Ajax -v1.0.0 (2015/7/27)
 *
 * @description: Ajax模块
 *
 *      该模块封装了jQuery.ajax方法，并设定了一些默认参数。
 *      同时，对DataModel模块提供了远程数据的缓存功能。
 *
 * @usage:
 *      var ajax = require('ajax').ajax;
 *      ajax(url,options);
 *
 * @author:      yezehua
 *
 * @copyright:   2015 www.yihu.com
 */
(function ($, win) {

    function isTimeOut(XMLHttpRequest){
        return XMLHttpRequest.getResponseHeader("sessionStatus") == "timeOut";
    }

    function isNoPermission(XMLHttpRequest){
        return XMLHttpRequest.getResponseHeader("noPermission") == "true";
    }

    function showMsg(){
        $.Notice.error("您没有权限进行该操作！");
        throw new Error("no permission！");
    }

    function gotoIndex(){
        sessionCheckOut();
        throw new Error("time out！");
    }

    function checkSession(XMLHttpRequest){
        if(isTimeOut(XMLHttpRequest)) gotoIndex();
        else if(isNoPermission(XMLHttpRequest)) showMsg();
    }

    var _ajax = $.ajax;
    $.ajax = function(opt){
        var fn = {
            complete: function(XMLHttpRequest, textStatus, errorThrown){},
            success: function(data, textStatus, XMLHttpRequest){},
            error: function(XMLHttpRequest, textStatus, errorThrown){}
        }
        if(opt.complete) fn.complete = opt.complete;
        if(opt.success) fn.success = opt.success;
        if(opt.error) fn.error = opt.error;

        var _opt = $.extend(opt,{
            complete:function(XMLHttpRequest, textStatus, errorThrown){
                checkSession(XMLHttpRequest);
                fn.complete(XMLHttpRequest, textStatus, errorThrown);
            },
            success: function(data, textStatus, XMLHttpRequest){
                checkSession(XMLHttpRequest);
                fn.success(data, textStatus, XMLHttpRequest);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown){
                checkSession(XMLHttpRequest);
                fn.error(XMLHttpRequest, textStatus, errorThrown);
            },
        });
        return _ajax(_opt);
    };

    $.AjaxUtil = {
        ajax: function(url,options){

            if(!url){
                throw('The load url parameter is null');
            }

            var self = this;
            options = options || {};

            // ajax请求参数设定
            var opts = {
                url: url, //请求的url地址
                dataType: options.dataType || 'json', //返回格式为json
                async: (options.async===false)?false:true , //请求是否异步，默认为异步，这也是ajax重要特性
                data: options.data || {}, // 传给服务器的数据
                type: options.type || "POST",   //请求方式
                beforeSend: function(){
                    //请求前的处理
                    if(options){
                        var call = options['beforeSend'];
                        if(call&&$.isFunction(call) )  call.apply(self,arguments);
                    }

                },
                success: function(){
                    //请求成功时处理
                    if(options){
                        var call = options['success'];
                        self.cacheData && (self.data = arguments[0]); // 对DataModel模块提供了远程数据的缓存功能
                        if(call&&$.isFunction(call) )  call.apply(self,arguments);
                    }
                },
                complete: function(){
                    //请求完成的处理
                    if(options){
                        var call = options['complete'];
                        if(call&&$.isFunction(call) )  call.apply(self,arguments);
                    }
                },
                error: function( ){
                    //请求出错处理
                    if(options){
                        var call = options['error'];
                        if(call&&$.isFunction(call) )  call.apply(self,arguments);
                    }

                    // log error message
                    window.console && window.console.error('Ajax error occur!');
                    for(var i in arguments) {
                        window.console&&window.console.log(arguments[i]);
                    }

                }
            };

            // 执行ajax请求
            $.ajax(opts);
        }
    }
})(jQuery, window);