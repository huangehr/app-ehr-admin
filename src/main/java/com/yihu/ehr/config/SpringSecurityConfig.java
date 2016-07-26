package com.yihu.ehr.config;

import com.yihu.ehr.Filter.AccessDecisionManagerImpl;
import com.yihu.ehr.Filter.AccessDeniedHandlerImpl;
import org.springframework.context.annotation.Bean;
import org.springframework.security.access.AccessDecisionManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.access.expression.DefaultWebSecurityExpressionHandler;

/**
 * @author lincl
 * @version 1.0
 * @created 2016/7/21
 */
//@Configuration
@EnableWebSecurity
public class SpringSecurityConfig extends WebSecurityConfigurerAdapter {
    @Override
    public void configure(WebSecurity web) throws Exception {
        // 设置不拦截规则
        web.ignoring().antMatchers("/develop/**", "/static-dev/**", "/out", "/**.jsp");
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        // 设置拦截规则
        http.authorizeRequests().accessDecisionManager(accessDecisionManager())
                .expressionHandler(webSecurityExpressionHandler())
                .antMatchers("/login").permitAll()
                .antMatchers("/login/**").permitAll()
//                .antMatchers("*.btn").hasRole("BTN")
                .antMatchers("/**").hasRole("USER")
//                .antMatchers("/**/*.jsp").hasRole("ADMIN")
                .and()
                .exceptionHandling().accessDeniedHandler(accessDeniedHandler());

        // 自定义登录页面
        http.csrf().disable().formLogin().loginPage("/login").permitAll();

        // 自定义注销
//        http.logout().logoutUrl("/logout").logoutSuccessUrl("/login")
//                .invalidateHttpSession(true);

        // session管理
//        http.sessionManagement().sessionFixation().changeSessionId()
//                .maximumSessions(1).expiredUrl("/");

        // RemeberMe  和UserDetailsService合作 用来保存用户信息， 一段时间内可以不用在输入用户名和密码登录，暂不使用该功能
//        http.rememberMe().key("webmvc#FD637E6D9C0F1A5A67082AF56CE32485");

    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {

    }

    /*
     * 最终访问控制器
     */
    @Bean(name = "accessDecisionManager")
    public AccessDecisionManager accessDecisionManager() {

        return new AccessDecisionManagerImpl();
    }

    /*
     * 错误信息拦截器
     */
    @Bean(name = "accessDeniedHandler")
    public AccessDeniedHandlerImpl accessDeniedHandler() {
        AccessDeniedHandlerImpl accessDeniedHandler = new AccessDeniedHandlerImpl();
        accessDeniedHandler.setErrorPage("/error/403.jsp");
        return accessDeniedHandler;
    }

    /*
     * 表达式控制器
     */
    @Bean(name = "expressionHandler")
    public DefaultWebSecurityExpressionHandler webSecurityExpressionHandler() {
        DefaultWebSecurityExpressionHandler webSecurityExpressionHandler = new DefaultWebSecurityExpressionHandler();
        return webSecurityExpressionHandler;
    }
}
