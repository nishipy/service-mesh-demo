#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage:"
    echo "  $0 SMCP_NS APP_NS"
    echo "  Example: $0 bookretail-istio-system bookinfo"
    exit 1
fi

SMCP_NS=$1
APP_NS=$2

HOST=`oc get route istio-ingressgateway --template '{{.spec.host}}' -n ${SMCP_NS}`

for i in `seq 1 100`; do
    curl -s -o /dev/null http://${HOST}/productpage
done