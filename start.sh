#!/bin/bash

set -ex

if [ ! $SERVER_IP ]
then
        echo "Please use $SERVER_IP set the IP address of the need to monitor."
        exit 1
elif [ ! $DHCP_RANGE ]
then
        echo "Please use $DHCP_RANGE set up DHCP network segment."
        exit 1
elif [ ! $ROOT_PASSWORD ]
then
        echo "Please use $ROOT_PASSWORD set the root password."
        exit 1
elif [ ! $DHCP_SUBNET ]
then
        echo "Please use $DHCP_SUBNET set the dhcp subnet."
        exit 1
elif [ ! $DHCP_ROUTER ]
then
        echo "Please use $DHCP_ROUTER set the dhcp router."
        exit 1
elif [ ! $DHCP_DNS ]
then
        echo "Please use $DHCP_DNS set the dhcp dns."
        exit 1
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
        sed -i "s/^#ServerName www.example.com:80/ServerName localhost:80/" /etc/httpd/conf/httpd.conf
        sed -i "s/service %s restart/supervisorctl restart %s/g" /usr/lib/python2.7/site-packages/cobbler/modules/sync_post_restart_services.py

        rm -rf /run/httpd/*
        /usr/sbin/apachectl
        /usr/bin/cobblerd

        cobbler sync
        cobbler get-loaders

        pkill cobblerd
        pkill httpd
        rm -rf /run/httpd/*
        
        exec supervisord -n -c /etc/supervisord.conf
fi