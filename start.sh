#!/bin/bash


if [ ! $IPADDR ]
then
        echo "Please use $IPADDR set the IP address of the need to monitor."
elif [ ! $DHCP_RANGE ]
then
        echo "Please use $DHCP_RANGE set up DHCP network segment."
elif [ ! $ROOT_PASSWORD ]
then
        echo "Please use $ROOT_PASSWORD set the root password."
else
        PASSWORD=`openssl passwd -1 -salt hLGoLIZR $ROOT_PASSWORD`
        sed -i "s/^server: 127.0.0.1/server: $IPADDR/g" /etc/cobbler/settings
        sed -i "s/^next_server: 127.0.0.1/next_server: $IPADDR/g" /etc/cobbler/settings
        sed -i 's/pxe_just_once: 0/pxe_just_once: 1/g' /etc/cobbler/settings
        sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g' /etc/cobbler/settings
        sed -i "s#^default_password.*#default_password_crypted: \"$PASSWORD\"#g" /etc/cobbler/settings
        sed -i 's/module = manage_bind/module = manage_dnsmasq/g' /etc/cobbler/modules.conf
        sed -i 's/module = manage_isc/module = manage_dnsmasq/g' /etc/cobbler/modules.conf
        sed -i "s/dhcp-range.*/dhcp-range=$DHCP_RANGE"/g /etc/cobbler/dnsmasq.template

        rm -rf /run/httpd/*
        /usr/sbin/apachectl
        /usr/bin/cobblerd

        cobbler sync > /dev/null 2>&1

        pkill cobblerd

        /usr/sbin/dnsmasq -u root
        /usr/sbin/xinetd -stayalive -pidfile /var/run/xinetd.pid
        /usr/bin/cobblerd -F
fi
