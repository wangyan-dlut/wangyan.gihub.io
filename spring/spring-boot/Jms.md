#### 基本配置
maven依赖 `spring-boot-starter-activemq`

在`application.properties`中主要的配置有
```
spring.activemq.broker-url=tcp://192.168.1.210:9876
spring.activemq.user=admin
spring.activemq.password=secret
```

#### 发送消息
使用JmsTemplate
```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Component;

@Component
public class MyBean {

    private final JmsTemplate jmsTemplate;

    @Autowired
    public MyBean(JmsTemplate jmsTemplate) {
        this.jmsTemplate = jmsTemplate;
    }

    // ...

}
```
>`JmsMessagingTemplate` can be injected in a similar manner.
If a DestinationResolver or MessageConverter beans are defined,
they are associated automatically to the auto-configured `JmsTemplate`.
#### 接收消息
使用注解,注意，这种方式需要在配置文件中启用`@EnableJms`
```
@Component
public class MyBean {

    @JmsListener(destination = "someQueue")
    public void processMessage(String content) {
        // ...
    }
}
```
http://docs.spring.io/spring/docs/current/spring-framework-reference/htmlsingle/#jms-annotated
