provider "aws"{
 region = "ap-south-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "Security_sample" {
 ami = data.aws_ami.ubuntu.id
 instance_type = "t2.micro"
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


# Ingress Rule for SSH Access (port 22)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
 security_group_id = aws_security_group.allow_tls.id
 cidr_ipv4 = "0.0.0.0/0"
 from_port = 22
 ip_protocol = "tcp"
 to_port = 22
}
# Ingress Rule for SSH Access (port 22) IPV6
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv6" {
 security_group_id = aws_security_group.allow_tls.id
 cidr_ipv6 = "::/0"
 from_port = 22
 ip_protocol = "tcp"
 to_port = 22
}

# Ingress Rule for IPv4 - HTTP traffic within the VPC
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"    # Allow from anywhere
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Ingress Rule for IPv6 - HTTP traffic within the VPC
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

