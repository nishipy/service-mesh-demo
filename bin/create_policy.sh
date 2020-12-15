#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage:"
    echo "  $0 SMCP_NS APP_NS"
    echo "  Example: $0 bookretail-istio-system bookinfo"
    exit 1
fi

SMCP_NS=$1
APP_NS=$2

SERVICES=`oc get services --template '{{range .items}}{{.metadata.name}} {{end}}' -n ${APP_NS}`

function createPolicy() {
    echo "---
apiVersion: authentication.istio.io/v1alpha1
kind: Policy
metadata:
  name: process-service-mtls
spec:
  peers:
  - mtls:
      mode: STRICT
  targets:
  - name: ${SVC}
" > $HOME/${SVC}-policy.yml

oc apply -f $HOME/${SVC}-policy.yml -n ${APP_NS}
}