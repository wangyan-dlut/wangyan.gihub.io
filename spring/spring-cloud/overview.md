# Spring-cloud 各项目简要说明
当前最新的spring-cloud总体发布版为Dalston，对应各个模块的版本号为
```xml
<spring-cloud-aws.version>1.2.0.RELEASE</spring-cloud-aws.version>
<spring-cloud-bus.version>1.3.0.RELEASE</spring-cloud-bus.version>
<spring-cloud-contract.version>1.1.0.RELEASE</spring-cloud-contract.version>
<spring-cloud-cloudfoundry.version>1.1.0.RELEASE</spring-cloud-cloudfoundry.version>
<spring-cloud-commons.version>1.2.0.RELEASE</spring-cloud-commons.version>
<spring-cloud-config.version>1.3.0.RELEASE</spring-cloud-config.version>
<spring-cloud-netflix.version>1.3.0.RELEASE</spring-cloud-netflix.version>
<spring-cloud-security.version>1.2.0.RELEASE</spring-cloud-security.version>
<spring-cloud-consul.version>1.2.0.RELEASE</spring-cloud-consul.version>
<spring-cloud-sleuth.version>1.2.0.RELEASE</spring-cloud-sleuth.version>
<spring-cloud-stream.version>Chelsea.SR1</spring-cloud-stream.version>
<spring-cloud-task.version>1.1.2.RELEASE</spring-cloud-task.version>
<spring-cloud-vault.version>1.0.0.RELEASE</spring-cloud-vault.version>
<spring-cloud-zookeeper.version>1.1.0.RELEASE</spring-cloud-zookeeper.version>
```
各个模块的版本号都要比Camden版本要前进了一个小版本

## 主要几个项目说明
1. Spring Cloud Config  
	配置中心，以git为底层技术支持，通过配置，可以快速的将配置加载到spring的Environment中
2. Spring Cloud Netflix  
	spring对Netflix OSS组件进行的封装，Netflix OSS提供了很多微服务必备的功能组件，如
	1. Eureka 用于服务的注册与发现，并提供负载均衡的组件
	2. Hystrix 用于在微服务远程调用时提供错误保障机制，如熔断机制
	3. Zuul 提供网关服务，包括路由，监控，安全等机制
	4. Archaius 配置中心
3. Spring Cloud Bus  
	spring提供的用于在微服务之间传递消息的时间总线，可在集群中传递状态变化事件，如配置改动事件
4. Spring Cloud Cluster  
	提供集群管理功能，例如节点选举，状态监控
5. Spring Cloud Consul  
	基于Hashicorp Consul的服务发现与配置管理
6. Spring Cloud Security  
	对OAuth2的实现，具有负载均衡相关功能
7. Spring Cloud Sleuth  
	对spring微服务组件的跟踪，可以和其他跟踪工具兼容，如：
	1. Zipkin
	2. HTrace
	3. log-based (e.g. ELK) tracing
8. Spring Cloud Data Flow  
	完全基于spring cloud提供的功能，可通过DSL、UI或者REST API对已有的微服务进行组合来处理数据六
9. Spring Cloud Stream  
	为快速的开发一个用于对接外部系统的组件，以数据流的方式，比如Apache Kafka或RabbitMq
10. Spring Cloud Task  
	为快速的开发一个用于处理有限数据的微服务提供的组件
11. Spring Cloud Zookeeper  
	基于Zookeeper的服务发现与配置管理
12. Spring Cloud Connectors  
	提供工具，使得非Spring cloud应用能够更加简单的使用spring cloud所构建的微服务

## 项目分类
1. 核心  
	+ 配置中心 - Spring Cloud Config
	+ 网关 - Spring Cloud Zuul
	+ 服务发现
		- Spring Cloud Eureka
		- Spring Cloud Consul
		- Spring Cloud Zookeeper
		- Spring Cloud Consul
	+ 安全认证
		- Spring Cloud Security
		- 自己实现
	+ 服务间调用 - Spring Cloud Hystrix
2. 功能组件  
	+ 日志追踪
		- Spring Cloud Sleuth
		- ELK log-base
	+ 事件总线
		- Spring Cloud Bus
	+ 监控
		- spring-boot-admin
	+ 集群管理
		- Spring Cloud Cluster

## 架构图
一个微服务的架构图
 ![一个微服务的架构图](https://dzone.com/storage/temp/1858172-365c0d94-eefa-11e5-90ad-9d74804ca412-2.png)
