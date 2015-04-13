# We either use the openshift image or the official jenkins image. Official image is out of date. OpenShift version provides osc command
# eventually should be jenkins osc plugin, so then can use official jenkins build?
FROM openshift/jenkins-1-centos

# Note that OpenShift install jenkins as per https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+RedHat+distributions

USER root

# this fixes the top command
ENV TERM xterm-256color

# note: this allows me to mess around in the container as root during dev. probably should remove at some point!
RUN yum -y install sudo passwd
RUN echo "jenkins:jenkins" | chpasswd
RUN usermod -a -G wheel jenkins # allows sudo

# centos yum repo provides a dev version of docker for 1.5 that uses API 1.18. this breaks boot2docker compatibility
# so for now, forcing 1.4.1
RUN yum -y install docker-1.4.1-37.el7.centos

RUN yum -y install java-1.7.0-openjdk-devel.x86_64 maven.noarch

RUN mkdir /usr/lib/maven
RUN cd /usr/lib/maven && curl -LO http://mirror.catn.com/pub/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.zip
RUN unzip /usr/lib/maven/apache-maven-3.2.5-bin.zip -d /usr/lib/maven/

# set up the CLI
ENV JENKINS_URL http://localhost:8080
RUN unzip -j /usr/lib/jenkins/jenkins.war WEB-INF/jenkins-cli.jar -d /usr/lib/jenkins
COPY resources/jenkins-cli.sh /usr/local/bin/jenkins-cli
RUN chmod 755 /usr/local/bin/jenkins-cli

USER jenkins

# this lets docker client access the local (insecure!) docker host
RUN echo "export DOCKER_IP=`ip route show 0.0.0.0/0 | grep -Eo 'via \S+' | awk '{ print $2 }'`" >> ~/.profile
RUN echo "export DOCKER_HOST=tcp://\$DOCKER_IP:2375" >> ~/.profile

# Install Plugins
# originally i wanted to use the cli for plugins but because jenkins isn't running
# when processing this script it didn't work. rather than fix that, in the short term it was easier
# to just dump the plugins into the jenkins-home/plugin folder. note that this
# means you have to install dependencies yourselves
# see http://stackoverflow.com/questions/27559234/how-can-write-dockerfile-to-start-a-webserver-and-curl-it-for-some-requirements for possible approach

RUN mkdir /var/jenkins_home/plugins

RUN cd /var/jenkins_home/plugins && curl -LO http://updates.jenkins-ci.org/latest/envinject.hpi

RUN cd /var/jenkins_home/plugins && curl -LO http://updates.jenkins-ci.org/latest/scm-api.hpi
RUN cd /var/jenkins_home/plugins && curl -LO http://updates.jenkins-ci.org/latest/git-client.hpi
RUN cd /var/jenkins_home/plugins && curl -LO http://updates.jenkins-ci.org/latest/git.hpi
RUN cd /var/jenkins_home/plugins && curl -LO http://updates.jenkins-ci.org/latest/github-api.hpi
RUN cd /var/jenkins_home/plugins && curl -LO http://updates.jenkins-ci.org/latest/github.hpi

# configure maven install
COPY resources/hudson.tasks.Maven.xml /var/jenkins_home/
