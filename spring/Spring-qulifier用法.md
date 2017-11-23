Qualifier的用法主要有两个
1. 通过id来标识一个bean
    + 声明
        ```
        @Bean
        @Qualifier("id")
        public TempBean tempBean1() {
            return new TempBean("with out tag");
        }
        ```
    + 使用
        ```
        @Autowired
        @Qualifier("id")
        TempBean tempBeans;
        ```
     这种方式适用于在一个项目内进行注入指定Bean时使用
     
2. 通过自定义注解来标识一个bean
    + 用Qualifier来标识自定义注解
        ```
        @Qualifier
        @Retention(RetentionPolicy.RUNTIME)
        public @interface TempTag {
        }
        ```
        这样，这个注解就有了标识bean的作用
    + 声明
        ```
        @Bean
        @TempTag
        public TempBean tempBean() {
            return new TempBean("with tag");
        }
        ```
    + 使用
        ```
        @TempTag
        @Autowired
        TempBean tempBeansWithTag;
        ```
    这种方式适合跨项目时需要注入指定的Bean时使用，具体实例参见针对`RestTemplate`的`@LoadBalanced`注解