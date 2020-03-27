provider "aws" {
    region="us-east-2"
}
resource "aws_security_group" "ssh_connection" {
  name        = var.sg_name
  dynamic "ingress" {
    for_each = var.ingress_rule
    content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
    }
  }
    dynamic "egress" {
    for_each = var.egress_rule
    content {
        from_port   = egress.value.from_port
        to_port     = egress.value.to_port
        protocol    = egress.value.protocol
        cidr_blocks = egress.value.cidr_blocks
    }
  }
}    

resource "aws_instance" "dahwild-instance" {
    # ami = "ami-01715ada337e1f5d3"
    ami = var.ami_id
    instance_type = var.instance_type
    tags = var.tags
    security_groups = ["${aws_security_group.ssh_connection.name}"]
    #se crea el provisioner para conectarse de forma remota.
    provisioner "remote-exec" {
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file("~/terraform/amazon-keypair-ohio.pem")}"
        host = self.public_ip
      }
      #Esta es la parte que hace el aprovisionamiento
      inline = ["echo hello","docker run -it -d -p 80:80 dahwild/hello-nginx:1.0"]
    }
}