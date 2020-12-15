if [ "$#" -ne 2 ]; then
    echo "Usage:"
    echo "  $0 SMCP_NS APP_NS"
    echo "  Example: $0 bookretail-istio-system bookinfo"
    exit 1
fi

SMCP_NS=$1
APP_NS=$2

#Get all deployment in APP_NS namespace
LIST=`oc get deployment --template '{{range .items}}{{.metadata.name}} {{end}}' -n ${APP_NS}`

for DEPLOY in $LIST ; do
    #echo $DEPLOY
    oc patch deployment $DEPLOY -p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject":"true", "sidecar.istio.io/rewriteAppHTTPProbers": "true"}}}}}' -n ${APP_NS}
done