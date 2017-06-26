1. maven parent改成spring-boot-parent
   ```
   <parent>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-parent</artifactId>
       <version>1.5.3.RELEASE</version>
   </parent>
   
   ```
2. 将common-parent中的依赖定义给引入进来
   ```
   <dependencyManagement>
       <dependencies>
           <dependency>
               <groupId>io.comi.common</groupId>
               <artifactId>common-parent</artifactId>
               <version>0.0.1-SNAPSHOT</version>
               <type>pom</type>
               <scope>import</scope>
           </dependency>
       </dependencies>
   </dependencyManagement>
   ```
3. 以上两步可以统一修改为
   ```
   <parent>
       <groupId>io.comi.common</groupId>
       <artifactId>common-spring-boot-parent</artifactId>
       <version>1.0-SNAPSHOT</version>
   </parent>
   ```

3. 修改 打包方式为 war
   ```
    <packaging>war</packaging>
   ```
4. 将内嵌的tomcat的依赖范围设置为 provide
   ```
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-tomcat</artifactId>
       <scope>provided</scope>
   </dependency>
   ```
5. 修改启动类，继承自SpringBootServletInitializer
   ```
   @SpringBootApplication
   public class DemoApplication extends SpringBootServletInitializer{
       @Override
       protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
           return application.sources(DemoApplication.class);
       }
       public static void main(String[] args) {
           SpringApplication.run(DemoApplication.class, args);
       }
   }
   
   ```