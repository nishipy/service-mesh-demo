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

# Responsible for injecting the istio annotation that opts in a Deployment for auto injection of the envoy sidecar
function annotateForInjection() {

  echo -en "\n\nInjecting istio sidecar annotation into Deployment: $DEPLOY\n"

  # 1)  Add istio inject annotion into pod.spec.template
  echo "apiVersion: apps/v1
kind: Deployment
metadata:
  name: $DEPLOY
spec:
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: \"true\"" \
  | oc apply -n $APP_NS -f -

}


for DEPLOY in $LIST ; do
    #echo $d
    annotateForInjection
done