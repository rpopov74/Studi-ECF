# Studi-ECF
ECF STUDI 2024

# 1- Deploiement de l'infrastructure

Ce projet Terraform crée une infrastructure de base sur AWS pour héberger une application distribuée. Elle inclut la configuration d'un VPC, de sous-réseaux publics et privés, de passerelles Internet et NAT, de tables de routage, de groupes de sécurité, d'un cluster Apache Spark et d'une instance MongoDB.

## Architecture

L'architecture déployée par ce script Terraform comprend :
- Un **VPC** avec une plage d'adresses IP définie.
- Deux **sous-réseaux** :
  - Un sous-réseau public pour le cluster Apache Spark.
  - Un sous-réseau privé pour l'instance MongoDB.
- Une **passerelle Internet** pour permettre le trafic entrant et sortant du sous-réseau public.
- Une **passerelle NAT** pour permettre au sous-réseau privé d'accéder à Internet pour les mises à jour et le trafic sortant.
- Des **tables de routage** pour diriger le trafic sortant vers la passerelle Internet ou la passerelle NAT selon le cas.
- Des **groupes de sécurité** pour contrôler l'accès aux instances dans les sous-réseaux public et privé.
- Un **cluster Apache Spark** dans le sous-réseau public.
- Une **instance MongoDB** dans le sous-réseau privé.

## Prérequis

- Compte AWS avec les droits nécessaires pour créer les ressources mentionnées.
- Installation de terraform et aws-cli
- Creation des IAM dans AWS
- Configuration AWS et Terraform pour l'authentification

## Usage

1. **Cloner le dépôt**

   Clonez ce dépôt sur votre machine locale.

2. **Initialiser Terraform**

   Dans le répertoire du projet, exécutez :

terraform init

Cette commande initialise Terraform avec les providers requis.

3. **Formater le code**
Exécutez :

terraform fmt

pour formater le main.tf 

4. **Valider le code**

Exécutez :

terraform validate

pour vérifier que votre code ne comporte pas d'erreur

5. **Planifier les modifications**

Exécutez :

terraform plan

pour voir les modifications que Terraform prévoit d'appliquer à votre infrastructure AWS.

6. **Appliquer les modifications**

Pour appliquer les modifications, exécutez :

Terraform apply

Après confirmation, Terraform créera les ressources sur AWS.

## Sécurité

- Remplacez l'adresse IP dans la règle d'ingress du groupe de sécurité `public_sg` par votre adresse IP publique pour sécuriser l'accès SSH.

## Nettoyage

Pour supprimer les ressources créées par Terraform, exécutez :

terraform destroy