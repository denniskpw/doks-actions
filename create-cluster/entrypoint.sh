#!/bin/sh -l

set -euo pipefail

RANDOM_STRING=$(hexdump -n 12 -e '3/4 "%08X" 1 "\n"' /dev/random)
NAME=test-cluster-$(echo ${RANDOM_STRING} | tr '[:upper:]' '[:lower:]')

echo "Creating k8s cluster: ${NAME}"
/app/doctl kubernetes cluster create ${NAME} --update-kubeconfig=false

CLUSTER_ID=$(/app/doctl kubernetes cluster get ${NAME} | grep ${NAME} | awk '{print $1}')
/app/doctl kubernetes cluster kubeconfig show ${NAME} > $GITHUB_WORKSPACE/kubeconfig
ls -al $GITHUB_WORKSPACE

echo "::set-output name=CLUSTER_NAME::${NAME}"
echo "::set-output name=CLUSTER_ID::${CLUSTER_ID}"
