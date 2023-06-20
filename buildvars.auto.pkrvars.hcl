boot_command = "<up><tab><wait> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/el9_ks.cfg<enter><wait>"
http_directory = "supportfiles"
guest_os_type = "centos64Guest"
cpus = "1"
memory = "1024"
disk_size = "5000"
ssh_username = "root"
ssh_password = "vagrant"
ssh_wait_timeout = "20m"
shutdown_command = "sudo -S shutdown -P now"
disk_type_id = "thin"
headless = "true"
boot_wait = "5s"
tools_upload_flavor = ""
remote_type = "esx5"
skip_compaction = "true"
keep_registered = "false"
format = "vmx"
