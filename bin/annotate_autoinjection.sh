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

for i in $LIST ; do
    echo $i
done