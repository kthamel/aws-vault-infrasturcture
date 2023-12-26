#!/bin/bash 
echo "*********** Required EBS Volume ID are as follows: ***********"
export Volume_ID=$(aws ec2 describe-volumes --filters "Name=tag:Name,Values=Vault_Storage_backend"| awk '/"VolumeId":/{print $NF}' | cut -d\" -f2)

echo "*********** Exported value is: $Volume_ID ***********"

echo "*********** Writing the create_sc.yaml using the $Volume_ID ***********"
tee tech-01/create_sc.yaml <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"storage.k8s.io/v1","kind":"StorageClass","metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"},"name":"gp2"},"parameters":{"fsType":"ext4","type":"gp2"},"provisioner":"kubernetes.io/aws-ebs","volumeBindingMode":"WaitForFirstConsumer"}
    storageclass.kubernetes.io/is-default-class: "true"
  name: gp2
parameters:
  fsType: ext4
  type: gp2
allowedTopologies:
  - matchLabelExpressions:
    - key: topology.ebs.csi.aws.com/zone
      values:
        - us-east-1c
provisioner: kubernetes.io/aws-ebs
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
EOF

echo "*********** Writing the create_pv.yaml using the $Volume_ID ***********"
tee tech-01/create_pv.yaml <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: vault-pv
spec:
  storageClassName: gp2
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
                - us-east-1c
EOF

echo "*********** Deleting the Storage Class ***********"
kubectl delete sc gp2

echo "*********** Creating the Storage Class ***********"
kubectl create -f tech-01/create_sc.yaml

echo "*********** Creating the Persistant Volume ***********"
kubectl create -f tech-01/create_pv.yaml

echo "*********** Creating the Persistant Volume Claim ***********"
kubectl create -f tech-01/create_pvc.yaml

echo "*********** Delete the YAML PV Creation File  ***********"
rm -rf tech-01/create_pv.yaml
