#!/bin/bash -e
set -e
. /tmp/os_detect.sh

subscription-manager register --username=<USERNAME> --password=<PASSWORD>
subscription-manager attach --auto

# Turn off DNS lookups for SSH
echo "UseDNS no" >> /etc/ssh/sshd_config

if [[ $OS_VERSION =~ ^6 ]]; then
	if [ -z $EPEL_DOWNLOAD_URL ]; then
		echo "No EPEL_DOWNLOAD_URL was set in environment, this should be set in Packer."
		exit 1
	fi
	rpm -i "$EPEL_DOWNLOAD_URL"
	
	yum install -y git wget curl vim cloud-init cloud-utils-growpart dracut-modules-growroot
	
	while read version; do
		version=${version#*-}
		dracut -f -H /boot/initramfs-${version}.img $version
	done < <(rpm -qa kernel)
else
	yum -y install git wget curl vim cloud-init cloud-utils-growpart

	while read version; do
		version=${version#*-}
		dracut -f -H /boot/initramfs-${version}.img $version
	done < <(rpm -qa kernel)

fi

yum -y upgrade
