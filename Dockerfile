FROM jenkins:1.651.1

MAINTAINER aherrera and acyost

USER root
RUN apt-get update &&\
    apt-get dist-upgrade -y &&\
    apt-get install -y \
    sudo \
    gcc \
    libyaml-dev \
    libpython2.7-dev \
    python-crypto \
    python-pip \
    virtualenv \
    apt-transport-https \
    xmlstarlet \
    jq \
    software-properties-common &&\
    #docker repo
    apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv 58118E89F3A912897C070ADBF76221572C52609D &&\
    echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list &&\
    #install docker
    apt-get update &&\
    apt-get install -y \
    docker-engine=1.9.1-0~jessie &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN pip install \
    awscli \
    ansible \
    credstash \
    boto &&\
    #jenkins user sudo
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins_sudo

#https://github.com/bdruemen/jenkins-docker-uid-from-volume...Babou, Serpentine!!
ADD https://github.com/tianon/gosu/releases/download/1.5/gosu-amd64 /usr/local/bin/gosu
RUN chmod 755 /usr/local/bin/gosu

#restore job
ADD restore.sh /restore.sh

USER jenkins
#add some plugins at start time
ADD plugins.txt /usr/share/jenkins/plugins.txt

#add some default jobs that we want to ship with all jenkins servers
ADD jobs /usr/share/jenkins/ref/jobs

#add credstash usage so that we can salt our config files with a credstash secret
ADD credstash.sh /credstash.sh

#fixup the backup job to be specific to the product we start with
ADD fixup_backup.sh /fixup_backup.sh

#add the config file that we want to salt with our secrets
ADD jenkins_config.xml /usr/share/jenkins/ref/jenkins_config.xml

USER root

#add jenkins user to the docker group
RUN gpasswd -a jenkins docker

#add entrypoint script into the container
ADD uidgid_volume_entry.sh /tmp/uidgid_volume_entry.sh
ENTRYPOINT ["/tmp/uidgid_volume_entry.sh"]
