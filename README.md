# Overview

This is a general purpose Jenkins Image. It extends the baseline OpenShift Jenkins Image, adding:

* JDK 7
* Maven, with an instance pre-configured in Jenkins
* Git Support, including GitHub
* The Env Inject Plugin

Note that this article is really good, and should probably be reviewed for any future iterations of this image - http://container-solutions.com/2015/03/running-docker-in-jenkins-in-docker/. Of interest is using the official docker image with plugins.txt, and the part about Docker In Docker.

## Run

A build is available on bintray. You can install as follows:

    docker run -Pit davidatkins-docker-registry.bintray.io/blueprint/jenkins:1.0.0

Check 'docker ps' to find the port that 8080 has been forwarded to

### Configure Docker Client Access

The jenkins container includes the latest docker client, but it'll only work if your docker host allow insecure connections (yes, this needs fixing!).

If using boot2docker, you can enable insecure access as follows. Please check warnings from Docker peeps before doing this!

      boot2docker ssh
      sudo vi /var/lib/boot2docker/profile
      # add this to profile
      DOCKER_TLS=no
      exit
      # quick and dirty way to restart docker daemon
      boot2docker restart

If you're using mac/linux and still want your local docker client to work, you'll need to tell it tls doesn't work anymore in your ~/.profile

      #export DOCKER_TLS_VERIFY=1
      export DOCKER_HOST=tcp://192.168.59.103:2375

Note the change in port from 2376 to 2375

# Building

     docker build -t blueprint/jenkins:1.0.0 .

Look at the [README for the blueprint-activemq](http://github.com/davidatkins/blueprint-activemq) for notes on publishing

## Publishing

    docker tag blueprint/jenkins:1.0.0 davidatkins-docker-registry.bintray.io/blueprint/jenkins:1.0.0
    docker push davidatkins-docker-registry.bintray.io/blueprint/jenkins:1.0.0

# TODO

Need to make this work with secure docker registry (provide straight forward instructions to setup)