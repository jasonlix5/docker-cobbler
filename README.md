# docker-cobbler
这是一个运行在docker里的cobbler平台。

启动：
--请先挂载系统镜像，不然容器内看不到系统镜像：（如挂载到/mnt下）
mount /dev/cdrom /mnt

docker run -d -v /mnt:/mnt --name cobbler --net host -e IPADDR=192.168.1.10 -e DHCP_RANGE=192.168.1.20,192.168.1.30 -e ROOT_PASSWORD=password cobbler

说明：共有3个变量：
IPADDR:指定本机内网卡的IP地址
DHCP_RANGE：指定批量装机需要获取的IP地址段
ROOT_PASSWORD：指定批量装机后系统默认的root密码

可用ss -antup命令看到启动的端口

配置防火墙：
firewall-cmd --add-service=dns
firewall-cmd --add-service=dhcp
firewall-cmd --add-service=http
firewall-cmd --add-service=tftp
firewall-cmd --add-port=25151/tcp

启动后可进入容器内配置装机系统：
docker exec -it cobbler bash

cobbler配置命令请参考官方文档。
