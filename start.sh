#!/bin/bash


if [ ! $SERVER_IP ]
then
        echo "Please use $SERVER_IP set the IP address of the need to monitor."
elif [ ! $DHCP_RANGE ]
then
        echo "Please use $DHCP_RANGE set up DHCP network segment."
elif [ ! $ROOT_PASSWORD ]
then
        echo "Please use $ROOT_PASSWORD set the root password."
elif [ ! $DHCP_SUBNET ]
then
        echo "Please use $DHCP_SUBNET set the dhcp subnet."
elif [ ! $DHCP_ROUTER ]
then
        echo "Please use $DHCP_ROUTER set the dhcp router."
elif [ ! $DHCP_DNS ]
then
        echo "Please use $DHCP_DNS set the dhcp dns."
else
        PASSWORD=`openssl passwd -1 -salt hLGoLIZR $ROOT_PASSWORD`
        sed -i "s/^server: 127.0.0.1/server: $SERVER_IP/g" /etc/cobbler/settings
        sed -i "s/^next_server: 127.0.0.1/next_server: $SERVER_IP/g" /etc/cobbler/settings
        sed -i 's/pxe_just_once: 0/pxe_just_once: 1/g' /etc/cobbler/settings
        sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g' /etc/cobbler/settings
        sed -i "s#^default_password.*#default_password_crypted: \"$PASSWORD\"#g" /etc/cobbler/settings
        sed -i "s/192.168.1.0/$DHCP_SUBNET/" /etc/cobbler/dhcp.template
        sed -i "s/192.168.1.5/$DHCP_ROUTER/" /etc/cobbler/dhcp.template
        sed -i "s/192.168.1.1;/$DHCP_DNS;/" /etc/cobbler/dhcp.template
        sed -i "s/192.168.1.100 192.168.1.254/$DHCP_RANGE/" /etc/cobbler/dhcp.template
        rm -rf /run/httpd/*
        /usr/sbin/apachectl
        /usr/bin/cobblerd

        cobbler sync > /dev/null 2>&1

        pkill cobblerd

        /usr/sbin/dhcpd -cf /etc/dhcp/dhcpd.conf -user dhcpd -group dhcpd --no-pid
        /usr/sbin/xinetd -stayalive -pidfile /var/run/xinetd.pid
        /usr/bin/cobblerd -F
fi
