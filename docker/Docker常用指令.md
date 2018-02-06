删除空镜像
```
$ docker rmi $(docker images -f "dangling=true" -q)
```
查看镜像层次/历史
```
$ docker history
```
调整 docker 时区

+ 进入 container 后
    ```
    echo "Asia/Shanghai" > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
    ```
+ 修改 docker file
    ```
    RUN echo "Asia/Shanghai" > /etc/timezone
    RUN dpkg-reconfigure -f noninteractive tzdata
    ```
+ 启动 container 时
    ```
    docker run -v /etc/localtime:/etc/localtime <IMAGE:TAG>
    ```
    

 
