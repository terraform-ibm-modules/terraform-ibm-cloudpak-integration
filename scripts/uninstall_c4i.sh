# export API_KEY="******************"
# export CLUSTER_ID="****************"
# export NAMESPACE="cp4i"


ibmcloud login -q -apikey $API_KEY
ibmcloud ks cluster config -c $CLUSTER_ID --admin

echo "Deleting Resources"
kubectl delete APIConnectCluster -n ${NAMESPACE} --all
kubectl delete Dashboard -n ${NAMESPACE} --all
kubectl delete DataPowerService -n ${NAMESPACE} --all
kubectl delete DesignerAuthoring -n ${NAMESPACE} --all
kubectl delete EventStreams -n ${NAMESPACE} --all
kubectl delete QueueManager -n ${NAMESPACE} --all
kubectl delete OperationsDashboard -n ${NAMESPACE} --all
kubectl delete AssetRepository -n ${NAMESPACE} --all
kubectl delete PlatformNavigator -n ${NAMESPACE} --all
kubectl delete subscription -n ${NAMESPACE} --all
kubectl delete csv -n ${NAMESPACE} --all
kubectl delete OperatorGroup -n ${NAMESPACE} --all
kubectl delete jobs -n cp4i --all 
kubectl delete pods -n cp4i --all
kubectl delete ConfigMap couchdb-release redis-release -n ${NAMESPACE}
kubectl delete catalogsource ibm-operator-catalog -n openshift-marketplace
kubectl delete pv ibm-common-services/mongodbdir-icp-mongodb-0
kubectl delete secret ibm-entitlement-key -n default
kubectl delete secret ibm-entitlement-key -n openshift-operators
kubectl delete secret ibm-entitlement-key -n ${NAMESPACE}
kubectl delete namespace ${NAMESPACE}
# remove kubernetes from finalizer
kubectl get namespace ${NAMESPACE} -o json | jq 'del(.spec.finalizers[] | select(. == "kubernetes"))' > ${NAMESPACE}.json
kubectl replace --raw "/api/v1/namespaces/${NAMESPACE}/finalize" -f ./${NAMESPACE}.json
kubectl delete namespace ${NAMESPACE}
