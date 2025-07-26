provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "multi_aws_instance" {
  count         = 3
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-EC2-${count.index + 1}"
  }
}
