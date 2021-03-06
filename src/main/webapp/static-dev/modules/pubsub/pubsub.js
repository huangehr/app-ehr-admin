/**
 * Created by yezehua on 2015/7/21.
 *
 * @require:
 *      jQuery.js
 *
 * @exports:
 *      none
 *
 * @description:
 *      发布/订阅者模式
 * @example:
 *      $.subscribe('some:topic',function(event,a,b,c){
 *          console.log(event.type,a + b + c);
 *      });
 *      $.publish('some:topic', ["a","b","c"]);
 *
 */

define(function(require, exports, module){

    var $ = require('jquery');
    var o = $({});

    $.subscribe = function(){

        o.bind.apply(o, arguments);
    };

    $.unsubscribe = function () {

        o.unbind.apply(o, arguments);
    };

    $.publish = function () {

        o.trigger.apply(o, arguments);
    };
});