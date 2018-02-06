SonarQube是代码分析得整合工具，可以通过 maven 运行，也可以通过单独的 sonar scanner 运行

1. 安装
    
    下载地址 [www.sonarqube.org](https://www.sonarqube.org)
    
    windows 下直接运行即可
    
    linux 必须以非 root 账户运行，需要调整运行账户的权限等
    > chmod -R 777 ${sonar_dir}
    
2. 使用
    
    正式环境需要配置 mysql 数据库连接以存储信息
    
    默认的账号密码是 admin admin
    
    针对每个项目需要生成一个 authentication key，给 jenkins 插件使用

3. 配合 jenkins 使用 
    1. 安装 jenkins 插件 https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+Jenkins
    2. jenkins 系统管理-系统配置 设置 SonarQube servers 相关属性
    3. jenkins 系统管理-全局工具配置 设置 SonarQube Scanner 相关属性
    3. 给构建添加步骤 Execute SonarQube Scanner 配置 Analysis Properties：
       ```
       sonar.projectKey=com.zhonglian.ctx.user
       sonar.projectName=ctx-user
       sonar.projectVersion=1.0
       sonar.sources=ctx-user/ctx-user-web/src,ctx-user/ctx-user-interface/src
       sonar.java.binaries=ctx-user/ctx-user-web/target/classes,ctx-user/ctx-user-interface/target/classes
       
       sonar.junit.reportsPath=ctx-user/ctx-user-web/target/surefire-reports
       sonar.surefire.reportsPath=ctx-user/ctx-user-web/target/surefire-reports
       sonar.jacoco.reportPath=ctx-user/ctx-user-web/target/jacoco.exec
       sonar.java.coveragePlugin=jacoco
       ```
    