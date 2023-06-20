variable "boot_command"  { default = "" }
variable "preseed_file" { default = "preseed.cfg" }
variable "floppy_files"  { default = null }
variable "cd_label" { default = "OEMDRV" }
variable "cd_files" { default = ["null"] }
variable "http_directory" { default = "null" }
variable "disk_type_id"  { default = "thin" }
variable "guest_os_type" {}
variable "headless" { default = true }
variable "iso_url" {}
variable "iso_checksum" {}
variable "iso_checksum_type" {}
variable "cpus" {}
variable "memory" {}
variable "disk_size" {}
variable "boot_wait" { default = "20" }
variable "ssh_username" {}
variable "ssh_password" {}
variable "ssh_wait_timeout" {}
variable "shutdown_command" {}
variable "tools_upload_flavor" { default = "" }
variable "ram_hot_plug" { default = true }
variable "cpu_hot_plug" { default = true }
variable "remote_type" { default = "esx5" }
variable "remote_host" { default = "" }
variable "remote_username" { default = "" }
variable "remote_password" { default = "" }
variable "remote_datastore" { default = "" }
variable "esx_host" { default = "" }
variable "skip_compaction" { default = true }
variable "keep_registered" { default = true }
variable "format" { default = "" }
variable "vnc_disable_password" { default = true }
variable "vmx_data" { default = {} }
variable "vm_name" { default = {} }
variable "vm_name_prefix" {}
variable "convert_to_template" { default = true }
variable "rhsm_username" { default = "" }
variable "rhsm_password" { default = "" }
variable "rhsm_pool" { default = "" }
variable "qemu_format" { default = "qcow2" }
variable "output_directory" { default = "" }
variable "xen_host" { default = "" }
variable "xen_user" { default = "" }
variable "xen_pass" { default = "" }
variable "az_subscription_id" { default = "" }
variable "az_client_id" { default = "" }
variable "az_client_secret" { default = "" }
variable "az_tenant_id" { default = "" }
variable "az_managed_image_resource_group_name" { default = "" }
variable "vsphere_network" { default = "" }
variable "vsphere_network_card" { default = "vmxnet3" }
variable "vsphere_cluster" { default = "" }
variable "vsphere_resource_pool" { default = "" }
variable "vsphere_datacenter" { default = "" }
locals {
  vm_name = "${var.vm_name_prefix}${formatdate("YYYYMMDD", timestamp())}"
}