#!/bin/bash

echo "*********** Adding the Hashicorp Vault Helm Repository ***********"
helm repo add hashicorp https://helm.releases.hashicorp.com

echo "*********** Updating the Hashicorp Vault Helm Repository ***********"
helm repo update

echo "*********** Install the Hashicorp Vault Helm Repository ***********"
helm install vault hashicorp/vault --set='server.ha.enabled=true' --set='server.ha.raft.enabled=true' 

echo "*********** Create the Namespace for Hashicorp Vault ***********"
kubectl create namespace vault