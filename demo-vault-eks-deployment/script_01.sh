#!/bin/bash 
echo "Required EBS Volume ID are as follows:"
## List EBS Volumes ##
Volume_ID=$(aws ec2 describe-volumes --filters "Name=tag:Name,Values=Vault_Storage_backend-1"| awk '/"VolumeId":/{print $NF}' | cut -d\" -f2)

for i in "${Volume_ID}"
do 
    echo $Volume_ID
    export TEST_VALUE="$Volume_ID"
done

echo "Exported value is: $TEST_VALUE"

echo "Creating the Persistant Volume"
# kubectl create -f create_pvc.yaml

echo "Creating the Persistant Volume Claim"
# kubectl create -f create_pvc.yaml