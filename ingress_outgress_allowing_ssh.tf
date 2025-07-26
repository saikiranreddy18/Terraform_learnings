provider "aws"{
 provider="terraform_aws"
}
resource "aws_instance" "Sample_demo" {
 ami = "ami-09e6f87a47903347c`"
 instance_type = "t2.micro"

provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y docker.io",
      "sudo systemctl start docker",
      "sudo docker run -d -p 80:5000 your-dockerhub-username/login-app"
    ]
  }
 tags = {
 Name = "EC2_Security_Groups"
 }
}
#use the default VPC
data "aws_vpc" "default" {
 default = true
}
resource "aws_security_group" "allow_tls" {
 name = "allow_tls"
 description = "Allow TLS inbound traffic and all outbound traffic"
 vpc_id = data.aws_vpc.default.id
 tags = {
 Name = "allow_tls"
 }
}
# Ingress Rule for IPv4 - HTTPS traffic within the VPC
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
 security_group_id = aws_security_group.allow_tls.id
 cidr_ipv4 = data.aws_vpc.default.cidr_block #If public HTTPS access is required then use "0.0.0.0/0"
 from_port = 443
 ip_protocol = "tcp"
 to_port = 443
}

# Ingress Rule for IPv6 - HTTPS traffic within the VPC
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
 security_group_id = aws_security_group.allow_tls.id
 cidr_ipv6 = "::/0"
 from_port = 443
 ip_protocol = "tcp"
 to_port = 443
}
# Egress Rule - Allow all outbound IPv4 traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
 security_group_id = aws_security_group.allow_tls.id
 cidr_ipv4 = "0.0.0.0/0"
 ip_protocol = "-1" # semantically equivalent to all ports
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
 security_group_id = aws_security_group.allow_tls.id
 cidr_ipv6 = "::/0"
 ip_protocol = "-1" # semantically equivalent to all ports
}

# Ingress Rule for SSH Access (port 22)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
 security_group_id = aws_security_group.allow_tls.id
 cidr_ipv4 = "0.0.0.0/0"
 from_port = 22
 ip_protocol = "tcp"
 to_port = 22
}

