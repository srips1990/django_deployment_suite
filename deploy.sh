#!/bin/bash
source init.conf

#### CREATING LINUX ADMIN USER

if ! id $linux_admin_user >/dev/null 2>&1; then
	# Setting up user account
	echo '----------------------------------------'
	echo -e 'SETTING UP '$linux_admin_user' USER ACCOUNT:'
	echo '----------------------------------------'

	passwd=`< /dev/urandom tr -dc A-Za-z0-9 | head -c40; echo`
	sudo useradd -d /home/$linux_admin_user -s /bin/bash -m $linux_admin_user
	sudo usermod -a -G sudo,www-data $linux_admin_user
	echo $linux_admin_user":"$passwd | sudo chpasswd
	echo "$linux_admin_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

homedir=`su -l $linux_admin_user -c 'echo ~'`
sudo chown -R $linux_admin_user: $homedir

cp -r `pwd` $homedir
current_dir_name=${PWD##*/}
#### INITIATING DEPLOYMENT

su -l $linux_admin_user -c  'cd ~/'$current_dir_name' && bash -e core.sh '$1