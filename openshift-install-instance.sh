#!/bin/sh
docker build -t $DOCKER_REGISTRY/atos/jenkins:1.0-SNAPSHOT .

# experimenting with setting additional tags
#imageId=`docker images | grep atos/jenkins | awk '{ print $3 }' | head -1`
#echo "Image ID is ${imageId}. Going to tag with repository prefix to push"
#docker tag --force=true $imageId $DOCKER_REGISTRY/atos/jenkins:1.0-SNAPSHOT

docker push $DOCKER_REGISTRY/atos/jenkins:1.0-SNAPSHOT

alias osc="docker run --rm -i --entrypoint=osc --net=host openshift/origin:latest --insecure-skip-tls-verify"
# the awk is used to dynamically set the DOCKER_REGISTRY ip as this tends to be different per install
# TODO: could we setup an OpenShift route to remove this issue?
awk '{while(match($0,"[$]{[^}]*}")) {var=substr($0,RSTART+2,RLENGTH -3);gsub("[$]{"var"}",ENVIRON[var])}}1' openshift-jenkins-template.json | osc create -f -
