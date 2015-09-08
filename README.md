# docker-cobbler  
这是一个运行在docker里的cobbler平台。

启动：  
--请先挂载系统镜像，不然容器内看不到系统镜像：（如挂载到/mnt下）  
  mount /dev/cdrom /mnt  
示例：  
  docker run -d -e SERVER_IP=192.168.2.8 -e DHCP_RANGE="192.168.2.230 192.168.2.235" -e ROOT_PASSWORD=cobbler -e DHCP_SUBNET=192.168.2.0 -e DHCP_ROUTER=192.168.2.1 -e DHCP_DNS=223.5.5.5 --name cobbler --net host -v /mnt:/mnt:ro cobbler

说明：共有6个变量：  
  SERVER_IP:指定本机内网卡的IP地址  
  DHCP_RANGE：指定批量装机需要获取的IP地址段  
  ROOT_PASSWORD：指定批量装机后系统默认的root密码  
  DHCP_SUBNET：指定DHCP的网段  
  DHCP_ROUTER：指定DHCP的网管  
  DHCP_DNS：指定DHCP的DNS地址  

可用ss -antup命令看到启动的端口

配置防火墙：  
  firewall-cmd --add-service=dhcp  
  firewall-cmd --add-service=http  
  firewall-cmd --add-service=tftp  
  firewall-cmd --add-port=25151/tcp  

启动后可进入容器内配置装机系统：
  docker exec -it cobbler bash

cobbler配置命令请参考官方文档。
