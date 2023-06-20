#!/bin/bash -e
set -e
. /tmp/os_detect.sh

echo 1
sed 's/#PasswordAuthentication yes/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
echo 2
unset HISTFILE
echo 3
sudo find / -path /proc -prune -o -name "authorized_keys" -exec rm -f {} \;

echo 4
# Delete unneeded files.
files=(/home/vagrant/*.sh
/home/cloud-user/*.sh
/tmp/*
/etc/udev/rules.d/70-persistent-net.rules
/lib/udev/rules.d/75-persistent-net-generator.rules
/dev/.udev/
/var/lib/dhcp/*
/var/run/*/*.pid
/var/run/*.pid
/var/log/syslog*
/var/log/messages*
/var/log/maillog*
/var/log/mail.log*
/var/log/*.log
/var/log/lastlog
/var/log/btmp*
/var/log/utmp*
/var/log/wtmp*
/root/.ssh/*
/root/.bash_history
/home/*/.bash_history
/tmp/*.json
/etc/ssh/ssh_host_*
)

echo 5
set +e
for f in "${files[@]}"
do
  sudo rm -rf $f
done

echo 6
rpmdb --rebuilddb
rm -f /var/lib/rpm/__db*

if [[ $ISGOOGLE == "true" ]]; then
  sed -i -e 's/\<rhgb\>//g' /etc/default/grub
  sed -i -e 's/quiet/console=ttyS0,38400n8d/' /etc/default/grub
  grub2-mkconfig -o /boot/grub2/grub.cfg
fi

echo 7
if [[ $OS_VERSION =~ ^8 ]]; then
	yum -y install network-scripts

	echo "Ensuring selinux is set to permissive"
	sed -i "s/SELINUX=enforcing/SELINUX=permissive/g" /etc/sysconfig/selinux
	sed -i "s/SELINUX=enforcing/SELINUX=permissive/g" /etc/selinux/config
	echo "Finished ensuring selinux is set to permissive"
fi
if [[ $OS_VERSION =~ ^7 ]]; then
	echo "Ensuring selinux is set to permissive"
	sed -i "s/SELINUX=enforcing/SELINUX=permissive/g" /etc/sysconfig/selinux
	sed -i "s/SELINUX=enforcing/SELINUX=permissive/g" /etc/selinux/config
	echo "Finished ensuring selinux is set to permissive"

	CLOUD_INIT_VERSION=`rpm -q --queryformat "%{VERSION}" cloud-init`
	if [[ $CLOUD_INIT_VERSION =~ ^18 ]]; then
		cloud-init clean --logs
		rm -rf /var/log/cloud
		rm -rf /var/lib/cloud/*
		systemctl enable cloud-final
	else
		rm -rf /var/log/cloud
		rm -rf /var/lib/cloud/*
	fi
fi

echo 8
touch /var/log/wtmp
touch /var/log/lastlog

echo 9
# Fix Huawei Xen Drivers
if [[ $OS_VERSION =~ ^7 ]]; then
	echo "add_drivers+=\"xen-blkfront xen-netfront virtio_blk virtio_scsi virtio_net virtio_pci virtio_ring virtio\" " >> /etc/dracut.conf
	dracut -f /boot/initramfs-`uname -r`.img
fi

yum clean all

echo 10
if [ ! -f "/etc/centos-release" ] && [ ! -f "/etc/rocky-release" ]; then
	subscription-manager unsubscribe --all
	subscription-manager unregister
	subscription-manager clean
	echo "subscription manager cleared"
	rm -rf /var/log/rhsm/*
	rm -rf /tmp/*
	rm -rf /var/cache/yum/*
	rm -rf /etc/ssh/ssh_host_*
	echo "logs and ssh keys cleared"
fi

echo 11
# Clean up credentials
passwd -l root
userdel -r vagrant
rm -f /etc/sudoers.d/vagrant
[[ -f /etc/waagent.conf ]] && waagent -force -deprovision

echo 12
set +e
# Zero out the rest of the free space using dd, then delete the written file.
/sbin/swapoff -a
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

echo 13
# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
