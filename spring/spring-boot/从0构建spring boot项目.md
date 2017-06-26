1. 工程构建
   1. 创建普通的maven工程
   2. 修改pom文件
      + 修改父pom文件
        ```
        <parent>
            <groupId>io.comi.common</groupId>
            <artifactId>common-spring-boot-parent</artifactId>
            <version>1.0-SNAPSHOT</version>
        </parent>
        ```
      + 设置plugin
         ```
         <plugin>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-maven-plugin</artifactId>
         </plugin>
         ```
      + 添加spring依赖
		+ spring-boot 核心
		  ```
		  <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter</artifactId>
          </dependency>
		  <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-web</artifactId>
          </dependency>
		  ``` 
		  > 如果想要一个简单的非web环境的话，不加第二个依赖即可
   3. 基本配置
      + 启动类 xxxApplication  
        一般是在根package下创建这个类，必要的注解是`@SpringBootApplication`，比如
	    ```
	    @SpringBootApplication
		 public class ZeroServerApplication {
		     public static void main(String[] args) {
			 	new SpringApplicationBuilder()
		 	                    .sources(ZeroServerApplication.class).run(args);
		     }
		 }
	    ```
	    可以看出，最简单的情况下只需要给定source即可运行
	  + 包扫描  
	    添加注解`@ComponentScan(basePackages = "io.comi.zero")`,注意这里的`basePackages`属性是个数组`
	  + 引入传统的xml配置文件
	    添加注解`@ImportResource("classpath:spring/zero.xml")`
	  + 修改pom文件，添加属性 `start-class`
	     ```
	     <properties>
             <start-class>io.comi.zero.server.ZeroServerApplication</start-class>
         </properties>
	     ```
   4. swagger
      + pom
	    ```
		<dependency>
		 <groupId>io.springfox</groupId>
		 <artifactId>springfox-swagger2</artifactId>
		</dependency>
		<dependency>
		 <groupId>io.springfox</groupId>
		 <artifactId>springfox-swagger-ui</artifactId>
		</dependency>
		```
      + config文件  
        需要这个配置文件在包扫描路径下
		```java
        @Configuration
        @EnableSwagger2
        public class SwaggerConfig {
        
            @Bean
            public Docket api() {
                return new Docket(DocumentationType.SWAGGER_2)
                        .select()
                        .apis(RequestHandlerSelectors.basePackage("io.comi"))
                        .paths(PathSelectors.any())
                        .build()
                        .ignoredParameterTypes(MultipartHttpServletRequest.class)
                        .apiInfo(apiInfo());
            }
        
            private ApiInfo apiInfo() {
                return new ApiInfoBuilder()
                        .title("zero艺术中心接口")
                        .version("0.1")
                        .termsOfServiceUrl("http://terms-of-services.url")
                        .license("LICENSE")
                        .licenseUrl("http://url-to-license.com")
                        .build();
            }
        
        }

		```
	  + 自定义全局参数  
	    通过`Docket`的函数`globalOperationParameters`来实现，比如说，对一个全局枚举型参数，添加方式如下：
	    ```
	    Language[] availableLanguage = new Language[]{Language.zh_cn, Language.en};
        List<String> languages = Arrays.stream(availableLanguage).map(Object::toString).collect(Collectors.toList());
        ModelRef modelRef = new ModelRef("string", null, new AllowableListValues(languages, "string"));
        Parameter parameter = new ParameterBuilder()
                .name("Language")
                .description("当前展示给用户的语言版本")
                .modelRef(modelRef)
                .allowableValues(new AllowableListValues(languages, "string"))
                .parameterType("header")
                .required(true)
                .build();
	    ```
   5. mybatis
      + pom
        ```
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis-spring</artifactId>
        </dependency>
        <dependency>
            <groupId>commons-dbcp</groupId>
            <artifactId>commons-dbcp</artifactId>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
        </dependency>
        ```
        其中postgresql可以替换成任意数据库链接
      + 在`application.yml`中指定数据库连接属性，来让spring帮助配置dataSource
        ```
        spring:
          datasource:
            username: postgres
            password: admin
            url: jdbc:postgresql://localhost:5432/zeroTest
            driver-class-name: org.postgresql.Driver
        ```
      + 在xml配置文件中配置mybatis的接口扫描器和`SqlSessionFactory`
        ```
         <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
             <property name="basePackage"
                       value="{mapper package}"/>
         </bean>
         <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
             <property name="dataSource" ref="dataSource"/>
             <property name="mapperLocations" value="classpath:mybatis/*.xml"/>
         </bean>
        ```
      + 通过某些方式生成mapper和相应的xml文件放入指定目录
   6. redis
      + pom
        ```
        <dependency>
           <groupId>org.springframework.boot</groupId>
           <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>
        <dependency>
       	   <groupId>redis.clients</groupId>
       	   <artifactId>jedis</artifactId>
        </dependency>
        ```
      + 在`application.yml`中指定Redis接属性，来让spring帮助配置RedisTemplate和StringRedisTemplate
        ```
        spring:
          redis:
            database: 2
            host: localhost
        ```
      + 之后就可以直接通过依赖注入的方法来获取相应的template
   7. config
      + 配置文件
        + 默认
          application.yml
        + 额外引入别的配置文件`yaml/propertis`  
          在Application上添加注解
          ```
          @PropertySource("classpath:config/encryptor.properties")
          ```
      + 将配置文件的属性注入到某个属性中  
        在spring的bean的属性上使用`@value`注解即可,注意遵循标准的引用语法，即需要使用`${}`的形式
      + 根据配置文件的属性来生成配置类
        + pom
        ```
        <dependency>
           <groupId>org.springframework.boot</groupId>
           <artifactId>spring-boot-configuration-processor</artifactId>
        </dependency>
        ```
        + application  
        在application上添加注解`@EnableConfigurationProperties()`来启动这种配置方式
        + pojo
          ```
          @Component
          @ConfigurationProperties("nick")
          public class NickConfig implements InitializingBean {
              public static NickConfig I;
          
              private String serverHost;
          
          
              public String getServerHost() {
                  return serverHost;
              }
          
              public void setServerHost(String serverHost) {
                  this.serverHost = serverHost;
              }
          
              @Override
              public void afterPropertiesSet() throws Exception {
                  NickConfig.I = this;
              }
          
          }
          ```
          1. 首先要先确保这个pojo能够被spring扫描到，所以添加了`@Component`注解
          2. `@ConfigurationProperties("nick")`表示pojo里面的属性是根据nick路径下的属性得到的
          3. `InitializingBean`继承这个方法是为了保证在属性加载完后做一些初始化工作，比如图中的这种
        
   8. 加密
      + 这里使用的加密技术是[jasypt](http://www.jasypt.org/)以及[jasypt-spring-boot](https://github.com/ulisesbocchio/jasypt-spring-boot)
      + pom
        ```
        <dependency>
            <groupId>com.github.ulisesbocchio</groupId>
            <artifactId>jasypt-spring-boot-starter</artifactId>
        </dependency>
        
        ```
      + 修改Application的启动方式为
        ```
        public static void main(String[] args) {
                new SpringApplicationBuilder()
                        .environment(new EncryptableEnvironment(new StandardServletEnvironment()))
                        .sources(NickServerApplication.class).run(args);
            }
        ```
      + 这样无论是在任何地方使用都是可以使用加密属性了
      + 解密属性配置
      
        可以在yaml中配置，也可以额外引入配置文件，最好是配置成环境变量，这样隐蔽性最好
         ```
         jasypt.encryptor.password=******
         ```
         > 其他可选属性参考`jasypt-spring-boot`上的说明
      + 加解密测试(用于生成密码)
        ```
        public class test {
            @Test
            public void test() {
                System.out.println(getClass().getName());
            }
        
            @Test
            public void testEncrypt() {
                MockEnvironment mockEnvironment = new MockEnvironment();
                mockEnvironment.setProperty("jasypt.encryptor.password", "00001130");
                DefaultLazyEncryptor encryptor = new DefaultLazyEncryptor(mockEnvironment);
                String encrypt = encryptor.encrypt("postgres");
                System.out.println(encrypt);
            }
            @Test
            public void testDecode() {
                MockEnvironment mockEnvironment = new MockEnvironment();
                mockEnvironment.setProperty("jasypt.encryptor.password", "00001130");
                DefaultLazyEncryptor encryptor = new DefaultLazyEncryptor(mockEnvironment);
                String encrypt = encryptor.decrypt("me29h5DUMHU0wGr8ekH9JQ==");
                System.out.println(encrypt);
            }
        }
        ```
      + 加密后属性使用
        
        在配置属性时，使用`ENC[]`包裹起来即可，比如
        ```
        redis.password=ENC(nrmZtkF7T0kjG/VodDvBw93Ct8EgjCA+)
        ```
        其中，这个前后缀也可以自定义
        ```
        jasypt:
          encryptor:
            property:
              prefix: "ENC["
              suffix: "]"
        ```
2. 启动脚本
   + windows - bat文件
     ```
     @echo off
     call chcp 65001
     call java -jar server.jar --server.port=8085
     pause
     ```