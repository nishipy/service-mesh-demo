#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage:"
    echo "  $0 SMCP_NS APP_NS"
    echo "  Example: $0 bookretail-istio-system bookinfo cluster-26cb.26cb.sandbox1023.opentlc.com "
    exit 1
fi

SMCP_NS=$1
APP_NS=$2
SUBDOMAIN_BASE=$3

# # Create cert
# echo "
# [ req ]
# req_extensions     = req_ext
# distinguished_name = req_distinguished_name
# prompt             = no

# [req_distinguished_name]
# commonName=apps.$SUBDOMAIN_BASE

# [req_ext]
# subjectAltName   = @alt_names

# [alt_names]
# DNS.1  = apps.$SUBDOMAIN_BASE
# DNS.2  = *.apps.$SUBDOMAIN_BASE
# " > $HOME/cert.cfg

# openssl req -x509 -config cert.cfg -extensions req_ext -nodes -days 730 -newkey rsa:2048 -sha256 -keyout $HOME/tls.key -out $HOME/tls.crt

# oc create secret tls istio-ingressgateway-certs --cert $HOME/tls.crt --key $HOME/tls.key -n ${APP_NS}

# oc patch deployment istio-ingressgateway -p '{"spec":{"template":{"metadata":{"annotations":{"kubectl.kubernetes.io/restartedAt": "'`date +%FT%T%z`'"}}}}}' -n ${SMCP_NS}


# Define Wildcard Gateway
echo "---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: bookinfo-gateway
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: bookinfo
spec:
  hosts:
  - "*"
  gateways:
  - bookinfo-gateway
  http:
  - match:
    - uri:
        exact: /productpage
    - uri:
        prefix: /static
    - uri:
        exact: /login
    - uri:
        exact: /logout
    - uri:
        prefix: /api/v1/products
    route:
    - destination:
        host: productpage
        port:
          number: 9080
" > $HOME/bookinfo-gateway.yml

oc apply -f $HOME/bookinfo-gateway.yml -n ${APP_NS}

echo "---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: bookinfo-mtls
spec:
  host: "*.bookinfo.svc.cluster.local"
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
" > bookinfo-mtls-destinationrule.yml

oc apply -f $HOME/bookinfo-mtls-destinationrule.yml -n ${APP_NS}
