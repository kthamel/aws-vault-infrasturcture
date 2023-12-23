#!/bin/bash 
echo "*********** Required EBS Volume ID are as follows: ***********"
export Volume_ID=$(aws ec2 describe-volumes --filters "Name=tag:Name,Values=Vault_Storage_backend"| awk '/"VolumeId":/{print $NF}' | cut -d\" -f2)

echo "*********** Exported value is: $Volume_ID ***********"

echo "*********** Writing the create_pv.yaml using the $Volume_ID ***********"
tee tech-01/create_pv.yaml <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: vault-pv
spec:
  storageClassName: vault-gp3
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 10Gi
  csi:
    driver: ebs.csi.aws.com
    fsType: ext4
    volumeHandle: $Volume_ID
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: topology.ebs.csi.aws.com/zone
              operator: In
              values:
                - us-east-1a
                - us-east-1b
                - us-east-1c
EOF

echo "*********** Creating the Persistant Volume ***********"
kubectl create -f tech-01/create_pv.yaml

echo "*********** Creating the Persistant Volume Claim ***********"
kubectl create -f tech-01/create_pvc.yaml

echo "*********** Delete the YAML PV Creation File  ***********"
rm -rf tech-01/create_pv.yaml
