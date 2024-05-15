#!/bin/sh

pw=`openssl rsautl -decrypt -inkey ~/.ssh/password.key -in ~/.ssh/password_r.txt`
com0="sudo make -C /home/user/free5gc/gtp5g/"
com1="sudo make -C /home/user/free5gc/gtp5g/ install"


isInstalled="0"
i=0

while [ $isInstalled -ne "1" ]
do
	isInstalled=`lsmod | grep "gtp5g" | awk '{print $1}' | grep "gtp5g" -x -c`
	echo "$isInstalled"

	if [ $i -ge 5 ];
	then
		break
	fi

	if [ $isInstalled -ne "1" ];
	then
		# sudo make -C gtp5g/
                expect -c "
                spawn ${com0}
                expect \"password for user:\"
                send \"${pw}\n\"
                expect \"$\"
                "
		# sudo make -C gtp5g/ install
		expect -c "
		spawn ${com1}
		expect \"password for user:\"
		send \"${pw}\n\"
		expect \"$\"
		"

		i=`expr $i + 1`
	else
		break
	fi

done

echo "gtp5g has been installed!"
