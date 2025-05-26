#!/bin/bash

NAMESPACE="monitoring"
ALLOY_LABEL="app.kubernetes.io/instance=alloy"
VM_URL="http://vm-victoria-metrics-single-server.monitoring.svc.cluster.local:8428"

ALLOY_POD_NAME=$(kubectl get pods -n $NAMESPACE -l $ALLOY_LABEL -o jsonpath="{.items[0].metadata.name}")

echo "Проверяем доступность VictoriaMetrics из пода Alloy ($ALLOY_POD_NAME)..."

# Запускаем pod с curl
kubectl run -n $NAMESPACE curl-test --image=curlimages/curl --restart=Never --command -- sleep 300

# Ждём, пока pod не будет в статусе Ready
echo "Ждём готовности pod curl-test..."
kubectl wait --for=condition=Ready pod/curl-test -n $NAMESPACE --timeout=30s

# Выполняем curl-запросы
kubectl exec -n $NAMESPACE curl-test -- sh -c "curl -v $VM_URL/api/v1/labels && echo && curl -v '$VM_URL/api/v1/query?query=up'"

# Удаляем pod
kubectl delete pod curl-test -n $NAMESPACE
