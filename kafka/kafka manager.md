### 项目地址
https://github.com/yahoo/kafka-manager

### 安装过程
#### 安装SBT

ubuntu 下安装： 
```
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-get update
sudo apt-get install sbt
```

#### 编译
首先通过git或者手动下载的方式下载最新的源码
```
git clone https://github.com/yahoo/kafka-manager
```
然后编译，必须确保有java环境
```
cd kafka-manager
sbt clean dist
```
生成的包会在kafka-manager/target/universal 下面,是一个zip包，
也可以使用已经压缩好的[kafka-manager-1.3.3.7.zip](kafka-manager-1.3.3.7.zip)

#### 部署
+ 解压
```
unzip kafka-manager-1.0-SNAPSHOT.zip
```
+ 修改配置文件`conf/application.conf`中的zookeeper地址
```
kafka-manager.zkhosts="localhost:2181"
```
+ 启动
```
cd kafka-manager-1.0-SNAPSHOT/bin
./kafka-manager -Dconfig.file=../conf/application.conf
```


