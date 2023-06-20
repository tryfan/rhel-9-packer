#!/bin/bash -e
set -e
. /tmp/os_detect.sh

if [ -z $USER_HOME ]; then
	echo "Missing environment variable USER_HOME, set in packer template."
	exit 1
fi

case "$OS_RELEASE" in
  ubuntu)
		# if [[ "$OS_VERSION" =~ ^17 ]]; then
			
		# 	exit 0
		# else
		#apt-get -y install open-vm-tools 
	  	apt-get -y install dkms nfs-common
	  	if [[ "$OS_VERSION" =~ ^18 ]]; then
	  		apt-get -y install net-tools
	  	fi
	  ;;

  centos|rhel|ol|rocky|almalinux)
  	if [[ $OS_VERSION =~ ^8 ]] || [[ $OS_VERSION =~ ^9 ]]; then
  	  yum -y install nfs-utils open-vm-tools
	else
  	  yum install dkms nfs-utils open-vm-tools -y
  	fi
  	exit 0
   	;;

  *)
   	;;
esac

if [ -e /home/$USER_HOME/linux.iso ]; then
	ISO_PATH=/home/$USER_HOME/linux.iso
elif [ -e /root/linux.iso ]; then
	ISO_PATH=/root/linux.iso
elif [ -e /tmp/linux.iso ]; then
	ISO_PATH=/tmp/linux.iso
else
	echo "Did not find CD image at /home/${USER_HOME}/linux.iso, check packer output to see if it was copied to VM."
	exit 1
fi

echo "Mounting vmware tools iso at ${ISO_PATH}"
mkdir -p /mnt/vmware
mount -o loop "$ISO_PATH" /mnt/vmware
cd /tmp
tar xzf /mnt/vmware/VMwareTools-*.tar.gz
umount /mnt/vmware
rm -f "$ISO_PATH"
/tmp/vmware-tools-distrib/vmware-install.pl --default --force-install
rm -rf /tmp/vmware-tools-distrib
echo "answer AUTO_KMODS_ENABLED yes" >> /etc/vmware-tools/locations
