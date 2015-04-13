# Overview

This is a general purpose Jenkins Image. It extends the baseline OpenShift Jenkins Image, adding:

* JDK 7
* Maven, with an instance pre-configured in Jenkins
* Git Support, including GitHub
* The Env Inject Plugin

# Build

    docker build -t blueprint/jenkins:1.0.0 .
    docker run -Pit blueprint/jenkins:1.0.0

# Using docker commands from Jenkins

The container includes the latest docker client, but it'll need to be able to connect to your local docker instance to execute docker commands.

If using boot2docker, by default you'll be using TLS based authentication. This is a pain to setup for every jenkins container (until I find a way to automate), so experimentation purposes only, we'll disable TLS on boot2docker. To do this:

      boot2docker ssh
      sudo vi /var/lib/boot2docker/profile
      DOCKER_TLS=no
      exit
      boot2docker restart

If using a mac and still want local docker client to work:

      #export DOCKER_TLS_VERIFY=1
      export DOCKER_HOST=tcp://192.168.59.103:2375

Note the change in port from 2376 to 2375

# Connect to docker host from ssh

http://docs.docker.com/reference/commandline/cli/#adding-entries-to-a-container-hosts-file

alias hostip="ip route show 0.0.0.0/0 | grep -Eo 'via \S+' | awk '{ print \$2 }'"

export DOCKER_IP=`ip route show 0.0.0.0/0 | grep -Eo 'via \S+' | awk '{ print $2 }'`
export DOCKER_HOST=tcp://172.17.42.1:2376
