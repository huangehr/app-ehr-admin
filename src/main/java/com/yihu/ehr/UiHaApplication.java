package com.yihu.ehr;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;


@Configuration
@EnableAutoConfiguration
@ComponentScan
//@SpringBootApplication
public class UiHaApplication extends SpringBootServletInitializer {
	/*static {
		try{
			//String log4jPath = UiHaApplication.class.getClassLoader().getResource("").getPath()+"log4j.properties";
			PropertyConfigurator.configure("classpath:log4j.properties");
		}catch (Exception e){
			e.printStackTrace();
		}
	}*/

	public static void main(String[] args) {
		SpringApplication.run(UiHaApplication.class, args);
	}

}
