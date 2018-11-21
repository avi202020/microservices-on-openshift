#!/usr/bin/env bash

. ../env.sh

oc login https://${IP}:8443 -u justin

APP=grafeas

oc project $CICD_PROJECT

oc delete imagestream ${APP}
oc delete buildconfig ${APP}-docker-build
oc delete deploymentconfig ${APP}
oc delete persistentvolumeclaim ${APP}-data
oc delete persistentvolumeclaim ${APP}-extensions
oc delete serviceaccounts ${APP}
oc delete service ${APP}
oc delete route ${APP}


oc new-app -f grafeas-persistent-template.yml \
    -p APPLICATION_NAME=${APP} \
    -p SOURCE_REPOSITORY_URL=https://github.com/justindav1s/microservices-on-openshift.git \
    -p SOURCE_REPOSITORY_URL=master \
    -p DOCKERFILE_PATH="grafeas" \

