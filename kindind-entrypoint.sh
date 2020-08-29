#!/bin/sh

set -e

echo waiting for docker dind service...
if ! docker version >/dev/null 2>&1; then
	for i in $(seq 1 30); do
		echo -n .
		sleep 1
		docker version >/dev/null 2>&1 && break
	done
	if [ $? = 0 ]; then
		echo
	else
		echo >&2 "Timeout waiting for docker service"
		exit 1
	fi
fi

kind get clusters
kind delete cluster

docker build -t kind-node-aufs -f /Dockerfile.node-aufs .

kind create cluster --config /kindind-config.yaml --image kind-node-aufs

sed -i s%https://0.0.0.0%https://kind-control-plane% ~/.kube/config

trap 'kind delete cluster' 0 1 2 3 15
tail -f /dev/null &
wait $!
