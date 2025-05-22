resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name   = "auto-generated-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Private ec2
resource "aws_instance" "private" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private1.id
  availability_zone      = "${data.aws_region.current.name}a"
  vpc_security_group_ids = [aws_security_group.ssh.id, ]
  key_name               = aws_key_pair.generated_key.key_name
  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-private-ec2" })
  )
}

# Public ec2
resource "aws_instance" "public" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ssh.id, ]
  key_name               = aws_key_pair.generated_key.key_name
  availability_zone      = "${data.aws_region.current.name}b"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-public-ec2" })
  )
}
