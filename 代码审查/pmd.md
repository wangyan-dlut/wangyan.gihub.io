代码审查通过[阿里Java代码规约](https://github.com/alibaba/p3c)来进行，
可以通过 IDEA 或者 Eclipse 插件来进行编码时检查，也可以在编译阶段进行检查，
这里介绍通过 maven 来进行编译阶段的代码审查

> 阿里的代码审查工具是在 [PMD](https://github.com/pmd/pmd) 基础上自定义规则来进行的，因此主要是对 PMD 进行配置

+ 通过 maven 插件 [maven-pmd-plugin](https://maven.apache.org/plugins/maven-pmd-plugin/) 进行代码审查
    ```
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-pmd-plugin</artifactId>
                <version>3.8</version>
            </plugin>
        </plugins>
    </build>
    ```
    maven 执行命令
    ```
    mvn pmd:pmd
    ```
    审查结果会出现在 target 目录下的 pmd.xml 文件和 site/pmd.html 文件中
 + 附加使用阿里代码规约 [p3c-pmd](https://github.com/alibaba/p3c/tree/master/p3c-pmd)
    ```
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-pmd-plugin</artifactId>
                <version>3.8</version>
                <configuration>
                    <rulesets>
                        <ruleset>rulesets/java/ali-comment.xml</ruleset>
                        <ruleset>rulesets/java/ali-concurrent.xml</ruleset>
                        <ruleset>rulesets/java/ali-constant.xml</ruleset>
                        <ruleset>rulesets/java/ali-exception.xml</ruleset>
                        <ruleset>rulesets/java/ali-flowcontrol.xml</ruleset>
                        <ruleset>rulesets/java/ali-naming.xml</ruleset>
                        <ruleset>rulesets/java/ali-oop.xml</ruleset>
                        <ruleset>rulesets/java/ali-orm.xml</ruleset>
                        <ruleset>rulesets/java/ali-other.xml</ruleset>
                        <ruleset>rulesets/java/ali-set.xml</ruleset>
                    </rulesets>
                    <printFailingErrors>true</printFailingErrors>
                </configuration>
                <dependencies>
                    <dependency>
                        <groupId>com.alibaba.p3c</groupId>
                        <artifactId>p3c-pmd</artifactId>
                        <version>1.3.3</version>
                    </dependency>
                </dependencies>
            </plugin>
        </plugins>
    </build>
    ```
+ 通过 jenkins 来收集展示 pmd 审查结果
    1. 安装插件 [PMD Plugin](https://wiki.jenkins.io/display/JENKINS/PMD+Plugin)
    2. 新建 project，配置 maven，并配置构建后操作：`Publish PMD analysis results`
    3. 构建完成后，在左侧查看 `PDM Warnings`