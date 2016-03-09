# Cobbler 批量装机

> 这是一个运行在docker里的cobbler平台。

### 文件说明

构建cobbler镜像的Dockerfile文件：

- Dockerfile
- start.sh

运行cobbler容器的compose文件：

- docker-compose.yml
- cobbler.env

### 使用说明

1、首先更改`cobbler.env`变量文件里的变量信息  
2、把系统镜像挂载到本机的`/mnt`目录下  
3、运行cobbler容器：`docker-compose up -d`  
4、进入cobbler容器，配置装机系统：`docker exec -it dockercobbler_cobbler_1 bash`  
