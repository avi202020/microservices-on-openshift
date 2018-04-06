#!/usr/bin/env bash

APP=frontend
S2I_IMAGE=nginx:latest

. ../../env.sh

oc login https://${IP}:8443 -u $USER

oc project ${DEV_PROJECT}

oc delete all -l app=${APP} -n ${DEV_PROJECT}
oc delete pvc -l app=${APP} -n ${DEV_PROJECT}
oc delete is,bc,dc,svc,route ${APP} -n ${DEV_PROJECT}
oc delete template ${APP}-dev-dc -n ${DEV_PROJECT}
oc delete configmap ${APP}-config -n ${DEV_PROJECT}

echo Setting up ${APP} for ${DEV_PROJECT}
oc new-build --binary=true --labels=app=${APP} --name=${APP} ${S2I_IMAGE} -n ${DEV_PROJECT}
oc new-app -f ./${APP}-dev-dc.yaml --allow-missing-imagestream-tags=true -n ${DEV_PROJECT}
oc expose dc ${APP} --port 80 -n ${DEV_PROJECT}
oc expose svc ${APP} -l app=${APP} -n ${DEV_PROJECT}
