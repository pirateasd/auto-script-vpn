#!/bin/bash
#script by jiraphat yuenying for debian9
#install openvpn

apt-get purge openvpn easy-rsa -y;
apt-get purge squid -y;
apt-get purge ufw -y;
apt-get update
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

apt-get update
apt-get -y install openvpn easy-rsa;

wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/openvpn.tar"
wget -O /etc/openvpn/default.tar "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/default.tar"
cd /etc/openvpn/
tar xf openvpn.tar
tar xf default.tar
cp sysctl.conf /etc/
cp before.rules /etc/ufw/
cp ufw /etc/default/
rm sysctl.conf
rm before.rules
rm ufw
systemctl restart openvpn

#install squid3

apt-get -y install squid;
cp /etc/squid/squid.conf /etc/squid3/squid.conf.bak
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/squid.conf"
sed -i $MYIP2 /etc/squid/squid.conf;
systemctl restart squid

cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/client.ovpn"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /root/

#N | apt-get install ufw
ufw allow ssh
ufw allow 1194/tcp
ufw allow 8080/tcp
ufw allow 3128/tcp
ufw allow 80/tcp
yes | sudo ufw enable

# download script
cd /usr/bin
wget -O member "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/member.sh"
wget -O menu "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/menu.sh"
echo "0 0 * * * root /usr/bin/reboot" > /etc/cron.d/reboot
#echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
chmod +x member
chmod +x menu
clear

printf '###############################\n'
printf '# Script by Jiraphat Yuenying #\n'
printf '#                             #\n'

printf '#                             #\n'
printf '#    พิมพ์ menu เพื่อใช้คำสั่งต่างๆ   #\n'
printf '###############################\n\n'
echo -e "ดาวน์โหลดไฟล์  : /root/client.ovpn\n\n"
printf '\n\nเพิ่ม user โดยใช้คำสั่ง useradd'
printf '\n\nตั้งรหัสโดย ใช้คำสั่ง passwd'
printf '\n\nคุณจำเป็นต้องรีสตาร์ทระบบหนึ่งรอบ (y/n):'
read a
if [ $a == 'y' ]
then
reboot
else
exit
fi