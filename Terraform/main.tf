# Configuration des informations d'identification AWS
provider "aws" {
  region = "eu-west-3"
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
