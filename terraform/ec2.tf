# IAM Role for EC2
resource "aws_iam_role" "ec2" {
  name = "${var.project}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = { Name = "${var.project}-ec2-role" }
}

# Attach SSM policy — lets you connect to EC2 without SSH key
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach ECR policy — lets EC2 pull Docker images
resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Attach Secrets Manager policy — lets EC2 read DB password securely
resource "aws_iam_role_policy_attachment" "secrets" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# Instance Profile — attaches IAM role to EC2
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project}-ec2-profile"
  role = aws_iam_role.ec2.name
}

# EC2 Instance — t2.micro (free tier)
resource "aws_instance" "app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  user_data = <<-USERDATA
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user
  USERDATA

  tags = { Name = "${var.project}-app-server" }
}
