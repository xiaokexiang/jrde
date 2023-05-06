#!/bin/bash
if [ "$#" -ne 2 ] then
    echo "Usage: $0 IP PASSWORD"
    exit 1
fi
NEWIP=$1
PASSWORD=$2
cp /root/.kube/config.sample /root/.kube/config -f
sed -i "s/{IP}/$NEWIP/g" /root/.kube/config
sed -i "s/{PATH}/pki/g" /root/.kube/config
sshpass -p $PASSWORD scp -r root@$NEWIP:/etc/kubernetes/pki/ /root/.kube/
ktctl -d -i abcsys.cn:5000/public/kt-connect-shadow:stable  --namespace=kube-system connect

