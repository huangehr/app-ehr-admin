/*!
 * AOP -v1.0.0 (2015/7/27)
 *
 * @description: AOP模块
 *
 *      该模块将jQuery AOP插件包装成符合CMD规范的模块。
 *
 * @usage:
 *     [相关文档]
 *          AOP一共有四种通知:
 *          1.前置通知：before (Map pointcut, Function advice) return Array<Function>
 *             在指定织入点创建一个前置通知。通知在被织入的方法之前执行，不能改变原方法的行为或阻止它执行。
 *
 *          2.后置通知：after (Map pointcut, Function advice) return Array<Function>
 *             通知(advice)在定义的切入点后面执行(pointcut),并接收切入点方法运行后的返回值作为参数
 *
 *          3.环绕通知：around (Map pointcut, Function advice) return Array<Function>
 *             在指定切入点处创建一个环绕通知，此类型的通知通过调用innovation.proceed()能够控制切入点方法的执行，
 *             也能在函数执行前更改它的参数。
 *
 *          4.引入：introduction (Map pointcut, Function advice) return Array<Function>
 *             此类型的通知的方法（advice)将替代制定切入点的方法。要恢复原方法，唯有卸载通知。
 *
 *     [例子]
 *      jQuery.aop.before( {target: window, method: /My/}, function() { alert('About to execute one of my global methods'); });
 *      jQuery.aop.before( {target: String, method: 'indexOf'}, function(index) { alert('About to execute String.indexOf on: ' + this);});
 *      jQuery.aop.after( {target: String, method: 'indexOf'}, function(index) { alert('Result found at: ' + index + ' on:' + this); } );
 *      jQuery.aop.around( {target: String, method: 'indexOf'}, function(invocation) {
 *        alert('Searching: ' + invocation.arguments[0] + ' on: ' + this);
 *        return invocation.proceed(); // 如果不执行invocation.proceed()，则切入点方法不会执行
 *       } );
 *       jQuery.aop.introduction( {target: String, method: 'log'}, function() { alert('Console: ' + this); } );
 *
 * @author:      yezehua
 *
 * @copyright:   2015 www.yihu.com
 */

(function (factory) {
    if (typeof define === 'function') {
        // 如果define已被定义，模块化代码
        define(function(require,exports,moudles){
            factory(require('jquery')); // 初始化插件
            return jQuery; // 返回jQuery
        });
    } else {
        // 如果define没有被定义，正常执行jQuery
        factory(jQuery);
    }
}(function ($) {

    var jQuery = $;

    // jQuery AOP 源代码开始
    /**
     * jQuery AOP - jQuery plugin to add features of aspect-oriented programming (AOP) to jQuery.
     * http://jquery-aop.googlecode.com/
     *
     * Licensed under the MIT license:
     * http://www.opensource.org/licenses/mit-license.php
     *
     * Version: 1.1
     */

    (function() {

        var _after	= 1;
        var _before	= 2;
        var _around	= 3;
        var _intro  = 4;
        var _regexEnabled = true;

        /**
         * Private weaving function.
         */
        var weaveOne = function(source, method, advice) {

            var old = source[method];

            var aspect;
            if (advice.type == _after)
                aspect = function() {
                    var returnValue = old.apply(this, arguments);
                    return advice.value.apply(this, [returnValue, method]);
                };
            else if (advice.type == _before)
                aspect = function() {
                    advice.value.apply(this, [arguments, method]);
                    return old.apply(this, arguments);
                };
            else if (advice.type == _intro)
                aspect = function() {
                    return advice.value.apply(this, arguments);
                };
            else if (advice.type == _around) {
                aspect = function() {
                    var invocation = { object: this, args: arguments };
                    return advice.value.apply(invocation.object, [{ arguments: invocation.args, method: method, proceed :
                        function() {
                            return old.apply(invocation.object, invocation.args);
                        }
                    }] );
                };
            }

            aspect.unweave = function() {
                source[method] = old;
                pointcut = source = aspect = old = null;
            };

            source[method] = aspect;

            return aspect;

        };


        /**
         * Private weaver and pointcut parser.
         */
        var weave = function(pointcut, advice)
        {

            var source = (typeof(pointcut.target.prototype) != 'undefined') ? pointcut.target.prototype : pointcut.target;
            var advices = [];
            console.log(source);
            // If it's not an introduction and no method was found, try with regex...
            if (advice.type != _intro && typeof(source[pointcut.method]) == 'undefined')
            {

                for (var method in source)
                {
                    if (source[method] != null && source[method] instanceof Function && method.match(pointcut.method))
                    {
                        advices[advices.length] = weaveOne(source, method, advice);
                    }
                }

                if (advices.length == 0)
                    throw 'No method: ' + pointcut.method;

            }
            else
            {
                // Return as an array of one element
                advices[0] = weaveOne(source, pointcut.method, advice);
            }

            return _regexEnabled ? advices : advices[0];

        };

        jQuery.aop =
        {
            /**
             * Creates an advice after the defined point-cut. The advice will be executed after the point-cut method
             * has completed execution successfully, and will receive one parameter with the result of the execution.
             * This function returns an array of weaved aspects (Function).
             *
             * @example jQuery.aop.after( {target: window, method: 'MyGlobalMethod'}, function(result) { alert('Returned: ' + result); } );
             * @result Array<Function>
             *
             * @example jQuery.aop.after( {target: String, method: 'indexOf'}, function(index) { alert('Result found at: ' + index + ' on:' + this); } );
             * @result Array<Function>
             *
             * @name after
             * @param Map pointcut Definition of the point-cut to apply the advice. A point-cut is the definition of the object/s and method/s to be weaved.
             * @option Object target Target object to be weaved.
             * @option String method Name of the function to be weaved. Regex are supported, but not on built-in objects.
             * @param Function advice Function containing the code that will get called after the execution of the point-cut. It receives one parameter
             *                        with the result of the point-cut's execution.
             *
             * @type Array<Function>
             * @cat Plugins/General
             */
            after : function(pointcut, advice)
            {
                return weave( pointcut, { type: _after, value: advice } );
            },

            /**
             * Creates an advice before the defined point-cut. The advice will be executed before the point-cut method
             * but cannot modify the behavior of the method, or prevent its execution.
             * This function returns an array of weaved aspects (Function).
             *
             * @example jQuery.aop.before( {target: window, method: 'MyGlobalMethod'}, function() { alert('About to execute MyGlobalMethod'); } );
             * @result Array<Function>
             *
             * @example jQuery.aop.before( {target: String, method: 'indexOf'}, function(index) { alert('About to execute String.indexOf on: ' + this); } );
             * @result Array<Function>
             *
             * @name before
             * @param Map pointcut Definition of the point-cut to apply the advice. A point-cut is the definition of the object/s and method/s to be weaved.
             * @option Object target Target object to be weaved.
             * @option String method Name of the function to be weaved. Regex are supported, but not on built-in objects.
             * @param Function advice Function containing the code that will get called before the execution of the point-cut.
             *
             * @type Array<Function>
             * @cat Plugins/General
             */
            before : function(pointcut, advice)
            {
                return weave( pointcut, { type: _before, value: advice } );
            },


            /**
             * Creates an advice 'around' the defined point-cut. This type of advice can control the point-cut method execution by calling
             * the functions '.proceed()' on the 'invocation' object, and also, can modify the arguments collection before sending them to the function call.
             * This function returns an array of weaved aspects (Function).
             *
             * @example jQuery.aop.around( {target: window, method: 'MyGlobalMethod'}, function(invocation) {
		 *                alert('# of Arguments: ' + invocation.arguments.length);
		 *                return invocation.proceed();
		 *          } );
             * @result Array<Function>
             *
             * @example jQuery.aop.around( {target: String, method: 'indexOf'}, function(invocation) {
		 *                alert('Searching: ' + invocation.arguments[0] + ' on: ' + this);
		 *                return invocation.proceed();
		 *          } );
             * @result Array<Function>
             *
             * @example jQuery.aop.around( {target: window, method: /Get(\d+)/}, function(invocation) {
		 *                alert('Executing ' + invocation.method);
		 *                return invocation.proceed();
		 *          } );
             * @desc Matches all global methods starting with 'Get' and followed by a number.
             * @result Array<Function>
             *
             *
             * @name around
             * @param Map pointcut Definition of the point-cut to apply the advice. A point-cut is the definition of the object/s and method/s to be weaved.
             * @option Object target Target object to be weaved.
             * @option String method Name of the function to be weaved. Regex are supported, but not on built-in objects.
             * @param Function advice Function containing the code that will get called around the execution of the point-cut. This advice will be called with one
             *                        argument containing one function '.proceed()', the collection of arguments '.arguments', and the matched method name '.method'.
             *
             * @type Array<Function>
             * @cat Plugins/General
             */
            around : function(pointcut, advice)
            {
                return weave( pointcut, { type: _around, value: advice } );
            },

            /**
             * Creates an introduction on the defined point-cut. This type of advice replaces any existing methods with the same
             * name. To restore them, just unweave it.
             * This function returns an array with only one weaved aspect (Function).
             *
             * @example jQuery.aop.introduction( {target: window, method: 'MyGlobalMethod'}, function(result) { alert('Returned: ' + result); } );
             * @result Array<Function>
             *
             * @example jQuery.aop.introduction( {target: String, method: 'log'}, function() { alert('Console: ' + this); } );
             * @result Array<Function>
             *
             * @name introduction
             * @param Map pointcut Definition of the point-cut to apply the advice. A point-cut is the definition of the object/s and method/s to be weaved.
             * @option Object target Target object to be weaved.
             * @option String method Name of the function to be weaved.
             * @param Function advice Function containing the code that will be executed on the point-cut.
             *
             * @type Array<Function>
             * @cat Plugins/General
             */
            introduction : function(pointcut, advice)
            {
                return weave( pointcut, { type: _intro, value: advice } );
            },

            /**
             * Configures global options.
             *
             * @name setup
             * @param Map settings Configuration options.
             * @option Boolean regexMatch Enables/disables regex matching of method names.
             *
             * @example jQuery.aop.setup( { regexMatch: false } );
             * @desc Disable regex matching.
             *
             * @type Void
             * @cat Plugins/General
             */
            setup: function(settings)
            {
                _regexEnabled = settings.regexMatch;
            }
        };

    })();

    // jQuery AOP 源代码结束
}));

