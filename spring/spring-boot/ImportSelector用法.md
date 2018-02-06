`org.springframework.context.annotation.ImportSelector`

是用来实现类似@Enable...的机制，具体方式如下：
1. 自定义个一个ImportSelector的实现
    ```
    public class ContentImportSelector implements ImportSelector {
    
        @Override
        public String[] selectImports(AnnotationMetadata importingClassMetadata) {
            Class<?> annotationType = EnableContentService.class;
            AnnotationAttributes attributes = AnnotationAttributes.fromMap(importingClassMetadata.getAnnotationAttributes(
                    annotationType.getName(), false));
            String policy = attributes.getString("policy");
            if ("core".equals(policy)) {
                return new String[] { CoreContentConfiguration.class.getName() };
            } else {
                return new String[] { SimpleContentConfiguration.class.getName() };
            }
        }
    
    }
    ```
2. 自定义一个@Enable...注解，在注解上import这个`ContentImportSelector`
    ```
    @Retention(RetentionPolicy.RUNTIME)
    @Target(ElementType.TYPE)
    @Import(ContentImportSelector.class)
    public @interface EnableContentService {
        String policy() default "simple";
    }
    ```
可以看到， 注解和选择器是**互相引用**的，因此要针对每个@Enable...实现一个自己的选择器

在第一种方法中，需要实现自己的选择器，且加载的configuration类是写死在代码中，因此推荐使用
`SpringFactoryImportSelector`，通过这个，可以将要加载的configuration类写在`META-INF/spring.factories`
中，从而实现自由配置。

具体使用方式
1. 实现自己的ImportSelector，需继承`SpringFactoryImportSelector`
    ```
    public class EnableDiscoveryClientImportSelector
    		extends SpringFactoryImportSelector<EnableDiscoveryClient> {
    
    	@Override
    	protected boolean isEnabled() {
    		return new RelaxedPropertyResolver(getEnvironment()).getProperty(
    				"spring.cloud.discovery.enabled", Boolean.class, Boolean.TRUE);
    	}
    }
    ```
2. 自定义@Enable...注解，这里略
3. 在`META-INF/spring.factories`添加对应的属性
    ```
    org.springframework.cloud.client.discovery.EnableDiscoveryClient=\
    org.springframework.cloud.netflix.eureka.EurekaDiscoveryClientConfiguration
    ```
可以看到，重点在于继承`SpringFactoryImportSelector`的泛型类，spring会根据这个泛型类的全名去`META-INF/spring.factories`
中查找对应的属性

>几个点
>1. 在`SpringFactoryImportSelector`中可以读取@Enable...注解的属性，以便做配置
>2. 加载`META-INF/spring.factories`的方法为`SpringFactoriesLoader.loadFactoryNames(...)`
>3. 加载`META-INF/spring.factories`的ClassLoader为通过`BeanClassLoaderAware`发现的。