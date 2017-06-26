#### 核心周期管理在于`org.springframework.context.support.AbstractApplicationContext`的`refresh()`方法

示意代码
```
@Override
public void refresh() throws BeansException, IllegalStateException {
	synchronized (this.startupShutdownMonitor) {
		// Prepare this context for refreshing.
		prepareRefresh();
		// Tell the subclass to refresh the internal bean factory.
		ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();
		// Prepare the bean factory for use in this context.
		prepareBeanFactory(beanFactory);
	    // Allows post-processing of the bean factory in context subclasses.
	    postProcessBeanFactory(beanFactory);
	    // Invoke factory processors registered as beans in the context.
	    invokeBeanFactoryPostProcessors(beanFactory);
	    // Register bean processors that intercept bean creation.
	    registerBeanPostProcessors(beanFactory);
	    // Initialize message source for this context.
	    initMessageSource();
	    // Initialize event multicaster for this context.
	    initApplicationEventMulticaster();
	    // Initialize other special beans in specific context subclasses.
	    onRefresh();
	    // Check for listener beans and register them.
	    registerListeners();
	    // Instantiate all remaining (non-lazy-init) singletons.
	    finishBeanFactoryInitialization(beanFactory);
	    // Last step: publish corresponding event.
	    finishRefresh();
	}
}
```
具体解析
1. prepareRefresh

   主要工作是从各个源加载配置信息
2. prepareBeanFactory

   用于对BeanFactory做预处理，使其能够正确的加载bean
   1. 设置classloader
   2. 添加`BeanPostProcessor:ApplicationContextAwareProcessor`，确保可以注入spring context
   3. 将Environment和系统变量等作为bean添加到beanFactory中去
3. postProcessBeanFactory

   用于子类在BeanFactory创建完成后做一些自定义的准备动作。比如说对于web环境，这里添加初始化web环境的postProcesser等等
4. invokeBeanFactoryPostProcessors - *使用者可以插入动作的生命周期*

   1. 调用之前准备动作中添加的那些PostProcessor
   2. 从bean的定义中查找用户自定义的`BeanFactoryPostProcessor`并调用
   > 1. 这个生命周期很是重要的一个，因为这个是在大部分的bean构造之前，因而可以进行很多动作
   > 2. 加载xml配置文件就是在这时进行的，而且优先级很高 `XmlBeanDefinitionReader`
5. initMessageSource

   初始化消息-待调查
6. initApplicationEventMulticaster
   
   初始化事件广播器
7. onRefresh
   
   提前初始化一些特殊的bean，这些bean是由子类指定的
   比如说
   + TomcatEmbeddedServletContainer
   + o.apache.catalina.core.StandardService
   + org.apache.catalina.core.StandardEngine
   + o.a.c.c.C.[Tomcat].[localhost].[/] 
   + o.s.web.context.ContextLoader
   + ServletRegistrationBean
   + FilterRegistrationBean
8. registerListeners
   
   从从bean的定义中查找用户自定义的ApplicationListener并注册相应的监听器
   > 还有spring的一些bean：`RequestMappingHandlerMapping`，因为这个必须在controller初始化之后才能执行
9. finishBeanFactoryInitialization

   初始化所有的用户自定义的非延迟加载的bean

需要注意
1. beanPostProcessor是在afterPropertiesSet()之前执行的