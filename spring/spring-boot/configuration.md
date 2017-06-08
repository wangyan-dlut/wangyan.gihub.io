# Spring boot 参数配置
主要参照[Externalized Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html)  
## 重点关注
1. 配置属性的加载顺序
	1. 命令行参数
	2. `SPRING_APPLICATION_JSON`-一个以json形式的配置，一般可出现在系统变量或者命令行参数中
	3. servlet中参数
	4. JNDI
	5. java环境变量
	6. 操作系统环境变量
	7. jar包外的properties或者YAML
	8. jar包内的properties或者YAML
	9. `@PropertySource`注解的配置类
2. 配置文件中支持的特殊语法
	1. random
	```
	my.secret=${random.value}
	my.number=${random.int}
	my.bignumber=${random.long}
	my.uuid=${random.uuid}
	my.number.less.than.ten=${random.int(10)}
	my.number.in.range=${random.int[1024,65536]}
	```
	2. 对上文已配置属性的引用
	```
	app.name=xxx
	app.yy=${app.name}
	```
3. 配置多份  
	1. 通过在主配置文件中指定`spring.profiles.active`来指定
	2. YAML中可在一个文件中指定多份配置-用`---`来分隔
4. 关键注解
	1. `@ConfigurationProperties`
	2. `@Value`
		
