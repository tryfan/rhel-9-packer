source "vsphere-iso" "rhel" {
    vcenter_server = "${var.remote_host}"
    username = "${var.remote_username}"
    password = "${var.remote_password}"
    insecure_connection = true
    datacenter = "${var.vsphere_datacenter}"
    cluster = "${var.vsphere_cluster}"
    resource_pool = "${var.vsphere_resource_pool}"
    datastore = "${var.remote_datastore}"
    CPUs = "${var.cpus}"
    CPU_hot_plug = "${var.cpu_hot_plug}"
    RAM = "${var.memory}"
    RAM_hot_plug = "${var.ram_hot_plug}"
    video_ram = 16384
    shutdown_command = "${var.shutdown_command}"
    iso_url = "${var.iso_url}"
    iso_checksum = "${var.iso_checksum}"
    vm_version = 11
    vm_name = "${local.vm_name}"
    remove_cdrom = true
    guest_os_type = "${var.guest_os_type}"
    boot_command = ["${var.boot_command}"]
    http_directory = "${var.http_directory}"
    network_adapters {
        network = "${var.vsphere_network}"
        network_card = "${var.vsphere_network_card}"
    }
    storage {
        disk_size = "${var.disk_size}"
        disk_thin_provisioned = true
    }
    
    ssh_username = "${var.ssh_username}"
    ssh_password = "${var.ssh_password}"
    ssh_wait_timeout = "${var.ssh_wait_timeout}"
    convert_to_template = "${var.convert_to_template}"
    export {
        force = true
        output_directory = "${var.output_directory}"
    }
}

build {
  sources = [
    "source.vsphere-iso.rhel"
  ]
  provisioner "file" {
    source = "supportfiles/os_detect.sh"
    destination = "/tmp/os_detect.sh"
  }
  provisioner "shell" {
    script = "supportfiles/rhel_setup.sh"
  }
  provisioner "shell" {
    environment_vars = [
      "USER_HOME=root",
    ]
     script = "supportfiles/vmware_tools.sh"
  }
  provisioner "shell" {
    script = "supportfiles/rhel_cleanup.sh"
  }
}