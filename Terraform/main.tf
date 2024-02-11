# Configuration des informations d'identification AWS
provider "aws" {
  region = "eu-west-3"
}
resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.0.0/16" # Plage d'adresses IP pour le VPC

  tags = {
    Name = "VPC-1"
  }
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.1.0/24" # Plage d'adresses IP pour le subnet public

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.2.0/24" # Plage d'adresses IP pour le subnet privé

  tags = {
    Name = "PrivateSubnet"
  }
}
#Passerelle Internet
resource "aws_internet_gateway" "igw_1" {
  vpc_id = aws_vpc.vpc_1.id
}

#Passerelle NAT Public / Privé
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.private_subnet_1.id
}

resource "aws_eip" "my_eip" {
  domain = "vpc"
}


# routage pour le subnet privé

# Creation de la table de routage
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_1.id
}

# Association de la table de routage avec le sous resau privé
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

# Mis en place des routes
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
}

# routage pour le subnet public

# Creation de la table de routage
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_1.id
}

# Association de la table de routage avec le sous resau public
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Mis en place des routes
resource "aws_route" "public_igw_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_1.id
}

#Configuration Security Group
resource "aws_security_group" "public_sg" {
  name        = "PublicSecurityGroup"
  description = "Security group for public subnet instances"
  vpc_id      = aws_vpc.vpc_1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #acces au port 80 
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["82.66.40.185/32"] # remplacer par votre adresse public. c-a-d celle de votre box internet
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Autorise tout le trafic sortant
  }
}

resource "aws_security_group" "private_sg" {
  name        = "PrivateSecurityGroup"
  description = "Security group for private subnet instances"
  vpc_id      = aws_vpc.vpc_1.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id] # permet aux machines frontend d'acceder à celle du backend en SSH 
  }
  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id] # permet aux machine frontend de se connecter a la DB MONGO
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Autorise tout le trafic sortant
  }
}


# Création d'un cluster Apache Spark
resource "aws_instance" "spark_cluster" {
  ami                    = "ami-0c60233f7f38809a4" # ID de l'AMI Spark
  instance_type          = "t2.small"              # Type d'instance Spark
  count                  = 3                       # Nombre d'instances dans le cluster
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "Spark-Node-${count.index + 1}"
  }
}

# Création d'une instance MongoDB
resource "aws_instance" "mongodb_instance" {
  ami                    = "ami-00f5f1e76dfe1aa88" # ID de l'AMI MongoDB
  instance_type          = "t2.micro"              # Type d'instance MongoDB
  subnet_id              = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "MongoDB-Instance"
  }
}
