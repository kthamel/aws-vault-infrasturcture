#!/bin/bash
echo "### Terminating the EKS Infrastructure ###"
bash eks_terminate.sh

echo "### Re-Provisioning the EKS Infrastructure ###"
bash eks_startup.sh