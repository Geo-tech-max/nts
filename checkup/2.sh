#!/bin/bash

ALLOY_POD_NAME=$(kubectl get pods -n monitoring -l app.kubernetes.io/instance=alloy -o jsonpath="{.items[0].metadata.name}")
echo "Логи Alloy с фильтрацией по remote_write:"

kubectl logs -n monitoring $ALLOY_POD_NAME --tail=100 | grep -i remote_write
