测试覆盖率的检测使用工具 [JaCoCo](http://www.eclemma.org/jacoco/trunk/index.html)

IDEA 本身已经集成，Eclipse 可以通过插件集成

这里对 maven 下的使用进行说明。

1. maven 配置样例 [http://www.eclemma.org/jacoco/trunk/doc/examples/build/pom.xml](http://www.eclemma.org/jacoco/trunk/doc/examples/build/pom.xml) 
    ```
    <plugin>
        <groupId>org.jacoco</groupId>
        <artifactId>jacoco-maven-plugin</artifactId>
        <version>0.8.1-SNAPSHOT</version>
        <executions>
            <execution>
                <id>default-prepare-agent</id>
                <goals>
                    <goal>prepare-agent</goal>
                </goals>
            </execution>
            <execution>
                <id>default-report</id>
                <goals>
                    <goal>report</goal>
                </goals>
            </execution>
            <execution>
                <id>default-check</id>
                <goals>
                    <goal>check</goal>
                </goals>
            </execution>
        </executions>
    </plugin>
    ```
    或者是简单的
    ```
     <plugin>
         <groupId>org.jacoco</groupId>
         <artifactId>jacoco-maven-plugin</artifactId>
         <version>0.8.0</version>
     </plugin>
    ```
    如果是这种方式，则必须通过 maven 命令来执行
    ```
    jacoco:prepare-agent package jacoco:report
    ```
    > jacoco:prepare-agent 必须在 package 之前，否则无法收集测试信息
    
2. Jenkins 配置

    1. 安装插件 [JaCoCo](https://plugins.jenkins.io/jacoco)
    2. 新建 project，配置 maven，并配置构建后操作：`Record JaCoCo coverage report`
    3. 构建完成后，在左侧查看 `Coverage Trend`
    
此外还可以在运行时对代码运行覆盖率进行检查，通过 java agent 的方式进行

1. 启动

    可参考官方说明 http://www.eclemma.org/jacoco/trunk/doc/agent.html

    + 具体来说就是添加 jvm 参数，指定 file 目录，这样就会在 jvm 正常退出时将覆盖率信息写入到指定的文件中。

    + 也可以开启 jmx ，通过 jmx 控制台在运行中 dump 覆盖率信息
    
2. 可视化
    
    在上一步生成的文件是 exec 文件，要可视化需要结合源代码进行，在对应源代码的工程执行 maven 命令
    ```
        clean package jacoco:report -Djacoco.dataFile=C:/env/jacoco/jacoco.exec -DskipTests
    ```
    即可在 target 目录下看到


    