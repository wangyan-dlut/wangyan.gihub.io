1. 基本的jasypt使用方式  
   略
2. jaspty-spring-starter解析
   1. 核心加解密逻辑
      + DefaultLazyEncryptor
        
        用于对一个属性进行加解密
      + DefaultPropertyDetector
        用于检测一个属性是被加密的
   2. 使得在获取任意加密后属性可以自动获取真正值的原理
      1. 方式1 通过对Environment进行代理
      
         这是最简单直接的一种方式，也能够对xml配置中的属性进行解密
         + 优先级最高
         + 原理是spring中一切实体在获取property的时候都是直接或间接的从Environment中获取的，
         而这种方式就是在获取属性后，检测这个属性是否是加密后的属性，如果是，则进行解密后再返回
         + 这是颗粒度很大的方式，对spring体系侵入性很大（替换了Environment）
      2. 方式2 通过`BeanFactoryPostProcessor`
         
         `jaspty-spring-boot` 自定了3个`BeanFactoryPostProcessor`,分别是
         + `BeanNamePlaceholderRegistryPostProcessor`
           
           这个是用于提供让使用者自定义jasypt相关bean的名称的机会，会将bean的名称修改为指定PlaceHolder的名称，
           核心代码:
           ```
           @Override
           public void postProcessBeanDefinitionRegistry(BeanDefinitionRegistry registry) throws BeansException {
               DefaultListableBeanFactory bf = (DefaultListableBeanFactory) registry;
               Stream.of(bf.getBeanDefinitionNames())
                       //Look for beans with placeholders name format: '${placeholder}' or '${placeholder:defaultValue}'
                       .filter(name -> name.matches("\\$\\{[\\w.-]+(?>:[\\w.-]+)?\\}"))
                       .forEach(placeholder -> {
                           String actualName = environment.resolveRequiredPlaceholders(placeholder);
                           BeanDefinition bd = bf.getBeanDefinition(placeholder);
                           //删除原来的bean，添加新的bean
                           bf.removeBeanDefinition(placeholder);
                           bf.registerBeanDefinition(actualName, bd);
                           log.debug("Registering new name '{}' for Bean definition with placeholder name: {}", actualName, placeholder);
                       });
           }
           ```
         + `EnableEncryptablePropertiesBeanFactoryPostProcessor`
         
           ***这个是最重要的核心***
           原理是对spring现有的加载到的PropertySource做一个代理，从Environment获取参数，本质上是从各个PropertySource
           获取数据，这里从原来的PropertySource获取数据的时候做一个检验，如果是加密后的属性则进行解密。核心代码：
           ```
           LOG.info("Post-processing PropertySource instances");
           //获取现有的PropertySource
           MutablePropertySources propSources = environment.getPropertySources();
           StreamSupport.stream(propSources.spliterator(), false)
                   .filter(ps -> !(ps instanceof EncryptablePropertySource))
                   //进行代理封装
                   .map(s -> makeEncryptable(s, beanFactory))
                   .collect(toList())
                   //替换原有的PropertySource
                   .forEach(ps -> propSources.replace(ps.getName(), ps));
           ```
         + `EncryptablePropertySourceBeanFactoryPostProcessor`
           
           这个是对自定义的注解`EncryptablePropertySource`进行扫描的处理器，可以在任意地方指定要加载配置文件的地址，然后加载到spring context中。
           核心代码：
           ```
           @Override
           public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
               ConfigurableEnvironment env = beanFactory.getBean(ConfigurableEnvironment.class);
               ResourceLoader ac = new DefaultResourceLoader();
               EncryptablePropertyResolver resolver = beanFactory.getBean(env.resolveRequiredPlaceholders(RESOLVER_BEAN_PLACEHOLDER), EncryptablePropertyResolver.class);
               MutablePropertySources propertySources = env.getPropertySources();
               //获取所有的带有EncryptablePropertySource注解的类的信息
               Stream<AnnotationAttributes> encryptablePropertySourcesMetadata = getEncryptablePropertySourcesMetadata(beanFactory);
               //加载这些注解上指明的配置文件
               encryptablePropertySourcesMetadata.forEach(eps -> loadEncryptablePropertySource(eps, env, ac, resolver, propertySources));
           }
           ```
3. 可以学习的细节
   1. starter 
   
      spring是通过meta-info(META-INF/spring.factories)中的信息来实现各种starter的，
      比如jasypt就是指定了：
      ```
      org.springframework.boot.autoconfigure.EnableAutoConfiguration=com.ulisesbocchio.jasyptspringboot.JasyptSpringBootAutoConfiguration
      ```
      通过上面声明了BeanFactoryPostProcessor来对spring的加载过程进行定制
   2. 默认配置属性
   
      同样是META-INF目录，通过配置`spring-configuration-metadata.json`来对要默认配置的属性进行说明。  
      不单单可以指定默认值，还可以通过IDE给予一定的提示。
   3. 延迟加载
      
      通过`java.util.function.Supplier`来实现
      ```
      public final class Singleton<R> implements Supplier<R> {
      
          private boolean initialized = false;
          private volatile Supplier<R> instanceSupplier;
      
          public Singleton(final Supplier<R> original) {
              instanceSupplier = () -> {
                  synchronized (original) {
                      if (!initialized) {
                          final R singletonInstance = original.get();
                          instanceSupplier = () -> singletonInstance;
                          initialized = true;
                      }
                      return instanceSupplier.get();
                  }
              };
          }
      
          @Override
          public R get() {
              return instanceSupplier.get();
          }
      }
      ```
   4. aop - 略
   5. 自定义注解
      
      可以在BeanFactoryPostProcess时扫描自己的注解，做一些事情。而且这个事情是在大部分bean初始化之前的。