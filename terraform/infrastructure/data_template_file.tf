#data "template_file" "nginx_config" {
#  template = "${file("${path.module}/files/nginx.conf")}"
#  vars = {
#    dns_name = var.dns_name
#  }
#}

data "template_file" "sdkman-vm-cloud-init" {
  template = file("${path.module}/files/install.sdkman.sh")
}


#data "template_file" "nginx_config" {
#  template = "${file("${path.module}/files/nginx.conf")}"
#  vars = {
#    dns_name = var.dns_name
#  }
#}

data "template_file" "nginx-vm-cloud-init" {
  template = file("${path.module}/files/install.nginx.sh")
}