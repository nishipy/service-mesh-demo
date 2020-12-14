#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage:"
    echo "  $0 SMCP_NS APP_NS"
    echo "  Example: $0 bookretail-istio-system bookinfo"
    exit 1
fi

SMCP_NS=$1
APP_NS=$2

#Create manifest for ServiceMeshMemberRoll
echo "apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
spec:
  members:
  # a list of projects joined into the service mesh
  - "${APP_NS}"
" > $HOME/service-mesh-roll.yaml

oc apply -f $HOME/service-mesh-roll.yaml -n ${SMCP_NS}