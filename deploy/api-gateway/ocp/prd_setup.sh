#!/usr/bin/env bash

APP=api-gateway

. ../../../env.sh

oc login https://${IP}:8443 -u $USER

oc project ${PROD_PROJECT}

oc delete deploy -l app=${APP} -n ${PROD_PROJECT}
oc delete deploymentconfigs -l app=${APP} -n ${PROD_PROJECT}
oc delete po -l app=${APP} -n ${PROD_PROJECT}
oc delete builds -l app=${APP} -n ${PROD_PROJECT}
oc delete svc -l app=${APP} -n ${PROD_PROJECT}
oc delete bc -l app=${APP} -n ${PROD_PROJECT}
oc delete routes -l app=${APP} -n ${PROD_PROJECT}

#oc apply -f <(istioctl kube-inject -f ${APP}-istio-prod.yaml)
oc apply -f ${APP}-istio-prod.yaml
