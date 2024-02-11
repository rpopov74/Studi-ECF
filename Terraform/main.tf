# Configuration des informations d'identification AWS
provider "aws" {
  region = "eu-west-3"
}
resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.0.0/16"  # Plage d'adresses IP pour le VPC

  tags = {
    Name = "VPC-1"
  }
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc_lab1.id
  cidr_block = "10.0.1.0/24"  # Plage d'adresses IP pour le subnet public

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.vpc_lab1.id
  cidr_block = "10.0.2.0/24"  # Plage d'adresses IP pour le subnet privé

  tags = {
    Name = "PrivateSubnet"
  }
}
resource "aws_internet_gateway" "igw_1" {
  vpc_id = aws_vpc.vpc_lab1.id
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.private_subnet_lab1.id
}

resource "aws_eip" "my_eip" {
  vpc = true
}
# Création d'un cluster Apache Spark
resource "aws_instance" "spark_cluster" {
  ami           = "ami-0c60233f7f38809a4" # ID de l'AMI Spark
  instance_type = "t2.small"              # Type d'instance Spark
  count         = 3                       # Nombre d'instances dans le cluster

  tags = {
    Name = "Spark-Node-${count.index + 1}"
  }
}

# Création d'une instance MongoDB
resource "aws_instance" "mongodb_instance" {
  ami           = "ami-00f5f1e76dfe1aa88" # ID de l'AMI MongoDB
  instance_type = "t2.micro"              # Type d'instance MongoDB

  tags = {
    Name = "MongoDB-Instance"
  }
}
