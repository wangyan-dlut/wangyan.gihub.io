###创建docker私库
1. 拉取镜像
    ```
    $ docker pull registry 
    ```
2. 运行私库
    ```
    $  docker run -d -p 5000:5000 --restart=always --name registry registry
    ```
3. 获取仓库列表
    ```
    $ curl http://127.0.0.1:5000/v2/_catalog
    ```
 4. 查看仓库中具体镜像信息
    ```
    $ curl http://127.0.0.1:5000/v2/iamgeName/tags/list
    ```
###客户端连接docker私库
1. 配置私库地址
    ```
    $ vi /etc/docker/daemon.json 
    $ vi /run/systemd/system/docker.service
    $ systemctl daemon-reload
    ```
    > $ /lib/systemd/system/docker.service
    
    添加
    ```
    {"insecure-registries":["101.201.110.191:5000"]}
    ```
2. 重启docker
    ```
    $ service docker restart
    ```
3. 给镜像一个标签
    ```
    $ docker tag busybox 101.201.110.191:5000/busybox
    ```
4. 推送镜像
    ```
    $ docker push 101.201.110.191:5000/busybox
    ```
5. 验证镜像
    ```
    $ docker search 101.201.110.191:5000/busybox
    ```
6. 移除第3步打了tag的多余镜像
    ```
    $ docker rmi busybox 101.201.110.191:5000/busybox
    ```
7. 拉取镜像
    ```
    docker pull 101.201.110.191:5000/busybox
    ```

    