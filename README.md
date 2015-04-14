# Overview

This is a general purpose Jenkins Image. It extends the baseline OpenShift Jenkins Image, adding:

* JDK 7
* Maven, with an instance pre-configured in Jenkins
* Git Support, including GitHub
* The Env Inject Plugin

At some point it may be worth moving to the official docker container, because it has slightly nicer support for installing plugins

TODO:

Because jenkins jobs/config isn't stored on a volume, everythig is lost when container is stopped

## Run

A build is available on bintray. You can install as follows:

    docker run -it -p 8181:8080 davidatkins-docker-registry.bintray.io/blueprint/jenkins:1.0.0

And then connect using:

    http://$(boot2docker ip 2>/dev/null):8181

### Configure Docker for Builds

You may want to execute docker commands from jenkins builds. The jenkins container includes the latest docker client, but it'll only work if your docker host allow insecure connections (yes, this needs fixing, see http://container-solutions.com/2015/03/running-docker-in-jenkins-in-docker/ for options)

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

If pushing to a private repo, you'll also need to add auth details to docker container's ~/.dockercfg file

# Building

     docker build -t blueprint/jenkins:1.0.0 .

Look at the [README for the blueprint-activemq](http://github.com/davidatkins/blueprint-activemq) for notes on publishing

## Publishing

    docker tag blueprint/jenkins:1.0.0 davidatkins-docker-registry.bintray.io/blueprint/jenkins:1.0.0
    docker push davidatkins-docker-registry.bintray.io/blueprint/jenkins:1.0.0