#!/bin/sh

pw=`openssl rsautl -decrypt -inkey ~/.ssh/password.key -in ~/.ssh/password_r.txt`
com1="sudo sysctl -w net.ipv4.ip_forward=1"
com2="sudo iptables -t nat -A POSTROUTING -o ens34 -j MASQUERADE"
com3="sudo systemctl stop ufw"
com4="sudo iptables -I FORWARD 1 -j ACCEPT"

expect -c "
spawn ${com1}
expect \"password for user:\"
send \"${pw}\n\"
expect \"$\"
spawn ${com2}
expect \"password for user:\"
send \"${pw}\n\"
expect \"$\"
spawn ${com3}
expect \"password for user:\"
send \"${pw}\n\"
expect \"$\"
spawn ${com4}
expect \"password for user:\"
send \"${pw}\n\"
expect \"$\"
exit 0
"

# sudo sysctl -w net.ipv4.ip_forward=1
# sudo iptables -t nat -A POSTROUTING -o ens160 -j MASQUERADE
# sudo systemctl stop ufw
# sudo iptables -I FORWARD 1 -j ACCEPT
